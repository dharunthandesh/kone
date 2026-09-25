"""API request and response schemas for Circuit2Sim."""

from __future__ import annotations
from typing import Any, Dict, List, Optional
from pydantic import BaseModel, Field
from circuit2sim.models.circuit_ir.circuit import (
    Component,
    ComponentType,
    Net,
    ParameterValue,
    UniversalCircuitIR,
    ValidationReport,
)


class ProjectCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=120)
    description: Optional[str] = Field(None, max_length=500)
    target_simulator: str = Field(default="matlab_simscape")


class ProjectResponse(BaseModel):
    id: str
    name: str
    description: Optional[str] = None
    created_at: str
    updated_at: str
    status: str
    schematic_filename: Optional[str] = None
    schematic_url: Optional[str] = None
    target_simulator: str = "matlab_simscape"
    components_count: int = 0
    nets_count: int = 0
    validation: Optional[ValidationReport] = None


class JobResponse(BaseModel):
    job_id: str
    project_id: str
    status: str  # pending, processing, completed, failed
    stage: str
    progress: int  # 0 to 100
    logs: List[str] = Field(default_factory=list)
    error: Optional[str] = None


class ComponentCreateRequest(BaseModel):
    id: str
    type: ComponentType
    name: Optional[str] = None
    parameters: Dict[str, ParameterValue] = Field(default_factory=dict)
    pins: List[str] = Field(default_factory=lambda: ["1", "2"])
    orientation: int = 0


class ComponentUpdateRequest(BaseModel):
    id: Optional[str] = None
    type: Optional[ComponentType] = None
    name: Optional[str] = None
    parameters: Optional[Dict[str, ParameterValue]] = None
    pins: Optional[List[str]] = None
    orientation: Optional[int] = None
    verified_by_user: bool = True


class ConnectionsUpdateRequest(BaseModel):
    nets: List[Net]


class GenerateModelRequest(BaseModel):
    target: str = Field(default="matlab_simscape", description="Simulation target, e.g. matlab_simscape")


class GenerateModelResponse(BaseModel):
    success: bool
    status: str
    target: str
    model_name: str
    slx_filename: Optional[str] = None
    slx_download_url: Optional[str] = None
    script_filename: Optional[str] = None
    script_download_url: Optional[str] = None
    zip_download_url: Optional[str] = None
    cir_download_url: Optional[str] = None
    json_download_url: Optional[str] = None
    compilation_report: Dict[str, Any] = Field(default_factory=dict)
    message: str
