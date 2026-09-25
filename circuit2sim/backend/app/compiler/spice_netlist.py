"""SPICE Netlist Compiler for Universal Circuit IR.

Generates standard, vendor-agnostic SPICE netlists (.cir / .net) that can be opened
and simulated in LTspice, ngspice, Multisim, PSpice, or KiCad with full parameter access.
"""

from pathlib import Path
from typing import Dict, List
from circuit2sim.backend.app.core.config import settings
from circuit2sim.models.circuit_ir.circuit import (
    Component,
    ComponentType,
    Net,
    UniversalCircuitIR,
)


class SpiceNetlistCompiler:
    """Compiles Universal Circuit IR into standard editable SPICE netlist (.cir)."""

    @classmethod
    def compile(cls, circuit_ir: UniversalCircuitIR, output_dir: Path = settings.GENERATED_DIR) -> Dict[str, str]:
        model_name = f"circuit_{circuit_ir.metadata.get('project_id', 'sim')[:8]}"
        cir_filename = f"{model_name}.cir"
        cir_path = output_dir / cir_filename

        output_dir.mkdir(parents=True, exist_ok=True)
        content = cls.generate_netlist(circuit_ir)
        with open(cir_path, "w", encoding="utf-8") as f:
            f.write(content)

        return {
            "model_name": model_name,
            "cir_file": cir_filename,
            "cir_path": str(cir_path),
            "status": "COMPILED_SUCCESS"
        }

    @classmethod
    def generate_netlist(cls, circuit_ir: UniversalCircuitIR) -> str:
        lines: List[str] = [
            f"* Circuit2Sim - Universal SPICE Netlist",
            f"* Model: {circuit_ir.title or 'Circuit'}",
            f"* Compatible with: LTspice, ngspice, PSpice, Multisim, PLECS",
            f"* -------------------------------------------------------------",
            f""
        ]

        # Map each pin to its assigned net name (0 for ground)
        pin_to_net: Dict[str, str] = {}
        for net in circuit_ir.nets:
            net_name = "0" if net.is_ground or net.id.upper() in ("GND", "0", "GROUND") else net.id
            for conn in net.connections:
                pin_to_net[conn] = net_name

        # Emit components
        for comp in circuit_ir.components:
            p = comp.parameters
            c_type = comp.type

            if c_type == ComponentType.RESISTOR:
                n1 = pin_to_net.get(f"{comp.id}.{comp.pins[0]}", "N_NC1")
                n2 = pin_to_net.get(f"{comp.id}.{comp.pins[1]}", "N_NC2")
                val = p.get("resistance")
                val_str = f"{val.value}" if val and val.value is not None else (val.raw_text if val else "1k")
                lines.append(f"{comp.id} {n1} {n2} {val_str}")

            elif c_type == ComponentType.CAPACITOR:
                n1 = pin_to_net.get(f"{comp.id}.{comp.pins[0]}", "N_NC1")
                n2 = pin_to_net.get(f"{comp.id}.{comp.pins[1]}", "N_NC2")
                val = p.get("capacitance")
                val_str = f"{val.value}" if val and val.value is not None else (val.raw_text if val else "1u")
                lines.append(f"{comp.id} {n1} {n2} {val_str}")

            elif c_type == ComponentType.INDUCTOR:
                n1 = pin_to_net.get(f"{comp.id}.{comp.pins[0]}", "N_NC1")
                n2 = pin_to_net.get(f"{comp.id}.{comp.pins[1]}", "N_NC2")
                val = p.get("inductance")
                val_str = f"{val.value}" if val and val.value is not None else (val.raw_text if val else "1m")
                lines.append(f"{comp.id} {n1} {n2} {val_str}")

            elif c_type == ComponentType.VOLTAGE_SOURCE:
                p_pos = comp.pins[0]
                p_neg = comp.pins[1] if len(comp.pins) > 1 else "2"
                n1 = pin_to_net.get(f"{comp.id}.{p_pos}", "N_NC1")
                n2 = pin_to_net.get(f"{comp.id}.{p_neg}", "0")
                val = p.get("voltage")
                val_str = f"{val.value}" if val and val.value is not None else (val.raw_text if val else "12")
                lines.append(f"{comp.id} {n1} {n2} DC {val_str}")

            elif c_type == ComponentType.DIODE:
                n1 = pin_to_net.get(f"{comp.id}.{comp.pins[0]}", "N_NC1")
                n2 = pin_to_net.get(f"{comp.id}.{comp.pins[1]}", "N_NC2")
                lines.append(f"{comp.id} {n1} {n2} DMOD")
                lines.append(f".model DMOD D (Is=1e-14 Rs=0.01 N=1 Cjo=2p)")

            elif c_type == ComponentType.GROUND:
                # Ground is already mapped to net 0 in SPICE
                lines.append(f"* {comp.id} Reference Ground Node 0")

        lines.extend([
            f"",
            f"* Transient analysis: start 0, stop 10ms, step 1us",
            f".tran 1u 10m",
            f".end"
        ])

        return "\n".join(lines)
