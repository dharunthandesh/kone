"""Circuit Validation Engine.

Provides deep topological and parametric validation of Universal Circuit IR.
Enforces that no uncertain topology or parameter is silently converted.
Produces engineering-grade validation reports.
"""

from typing import List, Set, Tuple
from circuit2sim.models.circuit_ir.circuit import (
    Component,
    ComponentType,
    Net,
    UniversalCircuitIR,
    ValidationReport,
    ValidationStatus,
)


class CircuitValidator:
    """Validates Universal Circuit IR for physical simulator readiness."""

    @classmethod
    def validate(cls, circuit_ir: UniversalCircuitIR) -> ValidationReport:
        warnings: List[str] = []
        errors: List[str] = []
        floating_pins: List[str] = []

        components_total = len(circuit_ir.components)
        components_verified = sum(1 for c in circuit_ir.components if c.verified_by_user or c.confidence >= 0.90)

        parameters_total = 0
        parameters_verified = 0
        parameters_uncertain = 0

        # Map all connected pins from nets
        connected_pins: Set[str] = set()
        has_ground = False

        for net in circuit_ir.nets:
            if net.is_ground or net.id.upper() in ("GND", "0", "GROUND", "COM"):
                has_ground = True
            for conn in net.connections:
                connected_pins.add(conn)
                # If ground component is connected, mark ground true
                comp_id = conn.split(".")[0]
                comp = circuit_ir.get_component(comp_id)
                if comp and comp.type == ComponentType.GROUND:
                    has_ground = True

        # 1. Component & Parameter Inspection
        for comp in circuit_ir.components:
            if comp.type == ComponentType.GROUND:
                has_ground = True

            # Parameter check
            if not comp.parameters and comp.type not in (ComponentType.GROUND, ComponentType.SWITCH):
                parameters_uncertain += 1
                warnings.append(f"Component '{comp.id}' ({comp.type.value}) is missing nominal value/parameters. Please verify.")
            else:
                for param_name, pval in comp.parameters.items():
                    parameters_total += 1
                    if pval.uncertain or pval.value is None:
                        parameters_uncertain += 1
                        comp.uncertainties.append(f"Uncertain parameter '{param_name}' ({pval.raw_text or 'missing'})")
                        warnings.append(f"Component '{comp.id}': {param_name} is uncertain ({pval.raw_text or 'unknown'}). Please verify.")
                    else:
                        parameters_verified += 1
                        # Physical sanity checks
                        if param_name in ("resistance", "capacitance", "inductance") and pval.value <= 0:
                            errors.append(f"Component '{comp.id}' parameter '{param_name}' has non-positive value ({pval.value}).")

            # Pin connection check
            for pin in comp.pins:
                pin_key = f"{comp.id}.{pin}"
                if pin_key not in connected_pins:
                    floating_pins.append(pin_key)

        # 2. Floating pin warnings
        if floating_pins:
            warnings.append(f"Detected {len(floating_pins)} floating / unconnected pin(s): {', '.join(floating_pins[:5])}{'...' if len(floating_pins) > 5 else ''}.")

        # 3. Electrical Reference (Ground) check
        if not has_ground:
            warnings.append("No Electrical Reference / Ground (GND) detected. Simscape physical networks require a reference node.")

        # 4. Topology Checks (Loops, Short Circuits)
        for net in circuit_ir.nets:
            if len(net.connections) < 2 and not net.is_ground:
                warnings.append(f"Net '{net.id}' has fewer than 2 connections (orphan net).")

            # Check if any two-terminal element has both pins connected to this same net (short circuit)
            pins_in_net = set(net.connections)
            for comp in circuit_ir.components:
                if len(comp.pins) == 2:
                    p1 = f"{comp.id}.{comp.pins[0]}"
                    p2 = f"{comp.id}.{comp.pins[1]}"
                    if p1 in pins_in_net and p2 in pins_in_net:
                        errors.append(f"Severe short-circuit: Both terminals of '{comp.id}' ({comp.type.value}) are connected to net '{net.id}'.")

        # 5. Connection counts
        connections_total = len(circuit_ir.nets)
        connections_verified = sum(1 for n in circuit_ir.nets if n.confidence >= 0.85)

        # Determine overall status
        if errors:
            status = ValidationStatus.FAIL
            ready = False
        elif warnings:
            status = ValidationStatus.WARNING
            # Ready if at least basic components exist, but flagged with warning
            ready = (components_total > 0 and len(errors) == 0)
        else:
            status = ValidationStatus.PASS
            ready = (components_total > 0)

        report = ValidationReport(
            status=status,
            components_total=components_total,
            components_verified=components_verified,
            parameters_total=parameters_total,
            parameters_verified=parameters_verified,
            parameters_uncertain=parameters_uncertain,
            connections_total=connections_total,
            connections_verified=connections_verified,
            has_ground_reference=has_ground,
            floating_pins=floating_pins,
            warnings=warnings,
            errors=errors,
            ready_for_compilation=ready,
        )
        return report
