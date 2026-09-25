"""Universal Circuit Intermediate Representation (Circuit IR).

Simulator-independent representation of electrical circuits.
Provides structured models for components, nets, pins, parameters, and confidence metrics.
"""

from __future__ import annotations
from enum import Enum
from typing import Any, Dict, List, Optional
from pydantic import BaseModel, Field


class ComponentType(str, Enum):
    RESISTOR = "resistor"
    CAPACITOR = "capacitor"
    INDUCTOR = "inductor"
    VOLTAGE_SOURCE = "voltage_source"
    CURRENT_SOURCE = "current_source"
    DIODE = "diode"
    SWITCH = "switch"
    GROUND = "ground"
    MOSFET = "mosfet"
    IGBT = "igbt"
    TRANSFORMER = "transformer"
    SENSOR = "sensor"
    THREE_PHASE_SOURCE = "three_phase_source"
    LOAD = "load"
    OP_AMP = "op_amp"
    INTEGRATED_CIRCUIT = "integrated_circuit"


class Pin(BaseModel):
    id: str = Field(..., description="Pin identifier e.g. '1', '2', '+', '-', 'A', 'K'")
    name: Optional[str] = Field(None, description="Human readable pin name")
    net_id: Optional[str] = Field(None, description="Assigned net ID if resolved")
    x: Optional[float] = Field(None, description="Normalized x coordinate (0.0 to 1.0)")
    y: Optional[float] = Field(None, description="Normalized y coordinate (0.0 to 1.0)")


class ParameterValue(BaseModel):
    value: Optional[float] = Field(None, description="Parsed numeric value")
    unit: Optional[str] = Field(None, description="Engineering unit (e.g. ohm, F, H, V, A)")
    raw_text: Optional[str] = Field(None, description="Extracted OCR text or label (e.g. '10k', '4.7uF')")
    confidence: float = Field(default=1.0, ge=0.0, le=1.0, description="OCR/extraction confidence score")
    uncertain: bool = Field(default=False, description="True if value could not be reliably determined")
    notes: Optional[str] = Field(None, description="Warning notes if uncertain")


class BoundingBox(BaseModel):
    x: int = Field(0, description="Top-left x in pixels")
    y: int = Field(0, description="Top-left y in pixels")
    w: int = Field(0, description="Width in pixels")
    h: int = Field(0, description="Height in pixels")


class Component(BaseModel):
    id: str = Field(..., description="Component identifier, e.g. 'R1', 'C1', 'V_IN', 'GND1'")
    type: ComponentType = Field(..., description="Standardized component type")
    name: Optional[str] = Field(None, description="Descriptive label e.g. 'Load Resistor'")
    parameters: Dict[str, ParameterValue] = Field(
        default_factory=dict,
        description="Keyed parameters (e.g. 'resistance', 'capacitance', 'voltage')"
    )
    pins: List[str] = Field(
        default_factory=list,
        description="List of available pin identifiers (e.g. ['1', '2'] or ['+', '-'])"
    )
    confidence: float = Field(
        default=0.95,
        ge=0.0,
        le=1.0,
        description="Detection confidence from optical/structural engine"
    )
    orientation: int = Field(
        default=0,
        description="Rotation in degrees (0, 90, 180, 270)"
    )
    bounding_box: Optional[BoundingBox] = Field(
        default=None,
        description="Bounding box coordinates in schematic image"
    )
    uncertainties: List[str] = Field(
        default_factory=list,
        description="List of warnings or user-verification notices"
    )
    verified_by_user: bool = Field(
        default=False,
        description="Indicates whether user manually reviewed/edited this component"
    )


class Net(BaseModel):
    id: str = Field(..., description="Net identifier, e.g. 'N1', 'N2', 'GND'")
    connections: List[str] = Field(
        default_factory=list,
        description="List of connected component pins in 'ComponentID.Pin' format, e.g. ['R1.2', 'C1.1']"
    )
    confidence: float = Field(
        default=0.95,
        ge=0.0,
        le=1.0,
        description="Connectivity reconstruction confidence"
    )
    is_ground: bool = Field(
        default=False,
        description="True if this net represents an electrical reference / ground"
    )
    notes: Optional[str] = Field(None)


class ValidationStatus(str, Enum):
    PASS = "PASS"
    WARNING = "WARNING"
    FAIL = "FAIL"


class ValidationReport(BaseModel):
    status: ValidationStatus = ValidationStatus.PASS
    components_total: int = 0
    components_verified: int = 0
    parameters_total: int = 0
    parameters_verified: int = 0
    parameters_uncertain: int = 0
    connections_total: int = 0
    connections_verified: int = 0
    has_ground_reference: bool = False
    floating_pins: List[str] = Field(default_factory=list)
    warnings: List[str] = Field(default_factory=list)
    errors: List[str] = Field(default_factory=list)
    ready_for_compilation: bool = False


class UniversalCircuitIR(BaseModel):
    version: str = Field(default="0.1", description="Circuit IR schema version")
    title: Optional[str] = Field(default="Untitled Circuit")
    components: List[Component] = Field(default_factory=list)
    nets: List[Net] = Field(default_factory=list)
    metadata: Dict[str, Any] = Field(default_factory=dict)
    validation: Optional[ValidationReport] = Field(default=None)

    def get_component(self, component_id: str) -> Optional[Component]:
        for c in self.components:
            if c.id == component_id:
                return c
        return None

    def get_net(self, net_id: str) -> Optional[Net]:
        for n in self.nets:
            if n.id == net_id:
                return n
        return None
