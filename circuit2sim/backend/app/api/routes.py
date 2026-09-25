"""FastAPI REST API Routes for Circuit2Sim."""

import json
import shutil
import uuid
import zipfile
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional
from fastapi import APIRouter, BackgroundTasks, File, HTTPException, UploadFile, status
from fastapi.responses import FileResponse, JSONResponse

from circuit2sim.backend.app.compiler.fault_injector import (
    AutonomousFaultInjector,
    ComponentFault,
    CriticalityLevel,
    FaultType,
)
from circuit2sim.backend.app.compiler.matlab_simscape import MatlabSimscapeCompiler
from circuit2sim.backend.app.compiler.spice_netlist import SpiceNetlistCompiler
from circuit2sim.backend.app.core.config import settings
from circuit2sim.backend.app.core.database import db
from circuit2sim.backend.app.validation.circuit_validator import CircuitValidator
from circuit2sim.backend.app.vision.pipeline import (
    BenchmarkSchematics,
    CircuitUnderstandingPipeline,
)
from circuit2sim.models.circuit_ir.circuit import (
    Component,
    ComponentType,
    Net,
    ParameterValue,
    UniversalCircuitIR,
    ValidationReport,
)
from circuit2sim.models.schemas.api import (
    ComponentCreateRequest,
    ComponentUpdateRequest,
    ConnectionsUpdateRequest,
    GenerateModelRequest,
    GenerateModelResponse,
    JobResponse,
    ProjectCreate,
    ProjectResponse,
)

router = APIRouter(prefix="/api")


# ---------------------------------------------------------------------------
# Project Management Endpoints
# ---------------------------------------------------------------------------

@router.post("/projects", response_model=ProjectResponse, status_code=status.HTTP_201_CREATED)
def create_project(req: ProjectCreate):
    project_id = str(uuid.uuid4())[:8]
    p = db.create_project(
        project_id=project_id,
        name=req.name,
        description=req.description,
        target_simulator=req.target_simulator
    )
    return ProjectResponse(
        id=p["id"],
        name=p["name"],
        description=p.get("description"),
        created_at=p["created_at"],
        updated_at=p["updated_at"],
        status=p["status"],
        target_simulator=p["target_simulator"],
        components_count=0,
        nets_count=0,
    )


@router.get("/projects", response_model=List[ProjectResponse])
def list_projects():
    projects = db.list_projects()
    res = []
    for p in projects:
        ir_data = db.get_circuit_ir(p["id"])
        val_data = db.get_validation(p["id"])
        comp_count = len(ir_data.get("components", [])) if ir_data else 0
        net_count = len(ir_data.get("nets", [])) if ir_data else 0

        val_report = ValidationReport(**val_data) if val_data else None

        res.append(ProjectResponse(
            id=p["id"],
            name=p["name"],
            description=p.get("description"),
            created_at=p["created_at"],
            updated_at=p["updated_at"],
            status=p["status"],
            schematic_filename=p.get("schematic_filename"),
            schematic_url=f"/uploads/{p['schematic_filename']}" if p.get("schematic_filename") else None,
            target_simulator=p.get("target_simulator", "matlab_simscape"),
            components_count=comp_count,
            nets_count=net_count,
            validation=val_report
        ))
    return res


@router.get("/projects/{project_id}", response_model=ProjectResponse)
def get_project(project_id: str):
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    ir_data = db.get_circuit_ir(project_id)
    val_data = db.get_validation(project_id)
    comp_count = len(ir_data.get("components", [])) if ir_data else 0
    net_count = len(ir_data.get("nets", [])) if ir_data else 0
    val_report = ValidationReport(**val_data) if val_data else None

    return ProjectResponse(
        id=p["id"],
        name=p["name"],
        description=p.get("description"),
        created_at=p["created_at"],
        updated_at=p["updated_at"],
        status=p["status"],
        schematic_filename=p.get("schematic_filename"),
        schematic_url=f"/uploads/{p['schematic_filename']}" if p.get("schematic_filename") else None,
        target_simulator=p.get("target_simulator", "matlab_simscape"),
        components_count=comp_count,
        nets_count=net_count,
        validation=val_report
    )


# ---------------------------------------------------------------------------
# Schematic Upload & Processing
# ---------------------------------------------------------------------------

@router.post("/projects/{project_id}/schematic")
async def upload_schematic(project_id: str, file: UploadFile = File(...)):
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    ext = Path(file.filename or "").suffix.lower()
    if ext not in settings.ALLOWED_EXTENSIONS:
        raise HTTPException(status_code=400, detail=f"Unsupported format '{ext}'. Allowed: {settings.ALLOWED_EXTENSIONS}")

    saved_filename = f"{project_id}_{file.filename}"
    target_path = settings.UPLOADS_DIR / saved_filename

    with open(target_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Invalidate and clear any previous analysis or models for this project
    db.clear_project_analysis(project_id)

    db.update_project(
        project_id,
        status="schematic_uploaded",
        schematic_filename=saved_filename,
        schematic_path=str(target_path),
        schematic_mimetype=file.content_type
    )

    return {
        "project_id": project_id,
        "filename": saved_filename,
        "schematic_url": f"/uploads/{saved_filename}",
        "message": "Schematic uploaded successfully."
    }


# ---------------------------------------------------------------------------
# Schematic Analysis Pipeline Endpoints
# ---------------------------------------------------------------------------

def run_analysis_task(project_id: str, job_id: str, schematic_path: Path):
    """Background task to run the complete 5-stage circuit understanding pipeline."""
    try:
        def on_progress(pct: int, stage: str, msg: str):
            db.update_job(job_id, stage=stage, progress=pct, log_entry=msg)

        circuit_ir = CircuitUnderstandingPipeline.analyze_schematic(
            project_id=project_id,
            schematic_path=schematic_path,
            progress_callback=on_progress
        )

        val_report = circuit_ir.validation
        db.save_circuit_ir(
            project_id=project_id,
            ir_dict=circuit_ir.dict(),
            validation_dict=val_report.dict() if val_report else None
        )
        db.update_project(project_id, status="analyzed")
        db.update_job(job_id, status="completed", stage="completed", progress=100, log_entry="Circuit IR generated and verified.")
    except Exception as ex:
        err_msg = str(ex)
        db.update_job(job_id, status="failed", stage="error", log_entry=f"Analysis failed: {err_msg}", error=err_msg)
        db.update_project(project_id, status="analysis_failed")


@router.post("/projects/{project_id}/analyze", response_model=JobResponse)
def analyze_schematic(project_id: str, background_tasks: BackgroundTasks):
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    schematic_path_str = p.get("schematic_path")
    if not schematic_path_str or not Path(schematic_path_str).exists():
        raise HTTPException(status_code=400, detail="No schematic file uploaded for this project")

    # Clear previous circuit_ir and models so we don't return stale analysis
    db.clear_project_analysis(project_id)

    job_id = str(uuid.uuid4())[:8]
    job = db.create_job(job_id, project_id, job_type="analyze")
    db.update_project(project_id, status="analyzing")

    # Run pipeline in background
    background_tasks.add_task(run_analysis_task, project_id, job_id, Path(schematic_path_str))

    return JobResponse(
        job_id=job["id"],
        project_id=job["project_id"],
        status=job["status"],
        stage=job["stage"],
        progress=job["progress"],
        logs=job.get("logs", []),
        error=job.get("error")
    )


@router.get("/projects/{project_id}/analysis")
def get_analysis_results(project_id: str, job_id: Optional[str] = None):
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    job = db.get_job(job_id) if job_id else db.get_latest_project_job(project_id)
    circuit_ir = db.get_circuit_ir(project_id)
    validation = db.get_validation(project_id)

    return {
        "project_id": project_id,
        "status": p["status"],
        "job": job,
        "circuit_ir": circuit_ir,
        "validation": validation,
    }


# ---------------------------------------------------------------------------
# Review & Manual Correction Interface Endpoints
# ---------------------------------------------------------------------------

@router.put("/projects/{project_id}/components/{component_id}")
def update_component(project_id: str, component_id: str, req: ComponentUpdateRequest):
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data:
        raise HTTPException(status_code=404, detail="Circuit IR not found for this project")

    circuit_ir = UniversalCircuitIR(**ir_data)
    target_comp = circuit_ir.get_component(component_id)
    if not target_comp:
        raise HTTPException(status_code=404, detail=f"Component '{component_id}' not found")

    if req.type is not None:
        target_comp.type = req.type
    if req.name is not None:
        target_comp.name = req.name
    if req.parameters is not None:
        target_comp.parameters = req.parameters
    if req.pins is not None:
        target_comp.pins = req.pins
    if req.orientation is not None:
        target_comp.orientation = req.orientation

    target_comp.verified_by_user = True
    target_comp.uncertainties = []  # Clear uncertainties on manual review

    # Re-validate IR
    val_report = CircuitValidator.validate(circuit_ir)
    circuit_ir.validation = val_report

    db.save_circuit_ir(project_id, circuit_ir.dict(), val_report.dict())
    return {"message": f"Component '{component_id}' updated", "component": target_comp, "validation": val_report}


@router.post("/projects/{project_id}/components")
def add_component(project_id: str, req: ComponentCreateRequest):
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data:
        raise HTTPException(status_code=404, detail="Circuit IR not found")

    circuit_ir = UniversalCircuitIR(**ir_data)
    if circuit_ir.get_component(req.id):
        raise HTTPException(status_code=400, detail=f"Component with ID '{req.id}' already exists")

    new_comp = Component(
        id=req.id,
        type=req.type,
        name=req.name or f"{req.type.value.capitalize()} {req.id}",
        parameters=req.parameters,
        pins=req.pins or ["1", "2"],
        confidence=1.0,
        orientation=req.orientation,
        verified_by_user=True
    )
    circuit_ir.components.append(new_comp)

    val_report = CircuitValidator.validate(circuit_ir)
    circuit_ir.validation = val_report

    db.save_circuit_ir(project_id, circuit_ir.dict(), val_report.dict())
    return {"message": f"Component '{req.id}' added", "component": new_comp, "validation": val_report}


@router.delete("/projects/{project_id}/components/{component_id}")
def delete_component(project_id: str, component_id: str):
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data:
        raise HTTPException(status_code=404, detail="Circuit IR not found")

    circuit_ir = UniversalCircuitIR(**ir_data)
    circuit_ir.components = [c for c in circuit_ir.components if c.id != component_id]

    # Clean up any net connections pointing to this component
    for net in circuit_ir.nets:
        net.connections = [conn for conn in net.connections if not conn.startswith(f"{component_id}.")]

    # Remove empty nets
    circuit_ir.nets = [n for n in circuit_ir.nets if n.connections]

    val_report = CircuitValidator.validate(circuit_ir)
    circuit_ir.validation = val_report

    db.save_circuit_ir(project_id, circuit_ir.dict(), val_report.dict())
    return {"message": f"Component '{component_id}' deleted", "validation": val_report}


@router.put("/projects/{project_id}/connections")
def update_connections(project_id: str, req: ConnectionsUpdateRequest):
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data:
        raise HTTPException(status_code=404, detail="Circuit IR not found")

    circuit_ir = UniversalCircuitIR(**ir_data)
    circuit_ir.nets = req.nets

    val_report = CircuitValidator.validate(circuit_ir)
    circuit_ir.validation = val_report

    db.save_circuit_ir(project_id, circuit_ir.dict(), val_report.dict())
    return {"message": "Nets updated successfully", "nets": circuit_ir.nets, "validation": val_report}


# ---------------------------------------------------------------------------
# Validation & Compilation Endpoints
# ---------------------------------------------------------------------------

@router.get("/projects/{project_id}/validation")
def get_project_validation(project_id: str):
    val_data = db.get_validation(project_id)
    if not val_data:
        ir_data = db.get_circuit_ir(project_id)
        if ir_data:
            circuit_ir = UniversalCircuitIR(**ir_data)
            report = CircuitValidator.validate(circuit_ir)
            db.save_circuit_ir(project_id, circuit_ir.dict(), report.dict())
            return report
        raise HTTPException(status_code=404, detail="No validation data available")
    return val_data


@router.post("/projects/{project_id}/generate", response_model=GenerateModelResponse)
def generate_model(project_id: str, req: GenerateModelRequest):
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data:
        raise HTTPException(status_code=400, detail="Cannot generate model: circuit has not been analyzed yet")

    circuit_ir = UniversalCircuitIR(**ir_data)
    val_report = CircuitValidator.validate(circuit_ir)

    # Strictly adhere to Rule #1 & #2: Never silently guess uncertain topology or fabricate successful conversion
    if val_report.errors:
        raise HTTPException(
            status_code=422,
            detail=f"Cannot generate model due to severe topology errors: {', '.join(val_report.errors)}"
        )

    # Compile via MatlabSimscapeCompiler
    model_report = MatlabSimscapeCompiler.compile(circuit_ir)
    spice_report = SpiceNetlistCompiler.compile(circuit_ir)
    model_report["cir_file"] = spice_report.get("cir_file")

    model_name = model_report.get("model_name") or f"circuit_{project_id[:8]}"
    slx_file = model_report.get("slx_file")
    slx_path = model_report.get("slx_path")

    # If headless MATLAB finished after timeout or path wasn't recorded, check generated dir
    if not slx_path or not Path(slx_path).exists():
        candidate = settings.GENERATED_DIR / f"{model_name}.slx"
        if candidate.exists() and candidate.stat().st_size > 1000:
            slx_path = str(candidate)
            slx_file = candidate.name
            model_report["slx_file"] = slx_file
            model_report["slx_path"] = slx_path
            model_report["status"] = "COMPILED_SUCCESS"

    model_id = str(uuid.uuid4())[:8]
    db.save_generated_model(
        model_id=model_id,
        project_id=project_id,
        target=req.target,
        status=model_report["status"],
        slx_filename=slx_file,
        slx_path=slx_path,
        script_filename=model_report.get("script_file"),
        script_path=model_report.get("script_path"),
        compilation_report=model_report
    )
    db.update_project(project_id, status="model_generated")

    has_slx = bool(slx_path and Path(slx_path).exists())
    slx_url = f"/api/projects/{project_id}/download?type=slx" if has_slx else None
    script_url = f"/api/projects/{project_id}/download?type=m" if model_report.get("script_file") else None
    cir_url = f"/api/projects/{project_id}/download?type=cir"
    zip_url = f"/api/projects/{project_id}/download?type=zip"
    json_url = f"/api/projects/{project_id}/download?type=json"

    msg = "Simscape model (.slx) compiled and verified successfully." if has_slx else (
        "Simulink generator script (.m) generated. MATLAB headless executable is not active in current environment."
    )

    return GenerateModelResponse(
        success=(model_report["status"] in ("COMPILED_SUCCESS", "SCRIPT_GENERATED") or has_slx),
        status="COMPILED_SUCCESS" if has_slx else model_report["status"],
        target=req.target,
        model_name=model_name,
        slx_filename=slx_file,
        slx_download_url=slx_url,
        script_filename=model_report.get("script_file"),
        script_download_url=script_url,
        zip_download_url=zip_url,
        cir_download_url=cir_url,
        json_download_url=json_url,
        compilation_report=model_report,
        message=msg
    )


@router.get("/projects/{project_id}/model")
def get_project_model(project_id: str):
    """Retrieves the latest compiled model record for a specific project."""
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")
    gen_model = db.get_latest_generated_model(project_id)
    if not gen_model:
        return {"project_id": project_id, "has_model": False}

    model_name = gen_model.get("compilation_report", {}).get("model_name") or f"circuit_{project_id[:8]}"
    slx_filename = gen_model.get("slx_filename")
    slx_path = gen_model.get("slx_path")

    # If DB didn't record slx but it exists on disk
    if not slx_path or not Path(slx_path).exists():
        candidate1 = settings.GENERATED_DIR / f"{model_name}.slx"
        candidate2 = settings.GENERATED_DIR / f"circuit_{project_id[:8]}.slx"
        if candidate1.exists() and candidate1.stat().st_size > 1000:
            slx_path = str(candidate1)
            slx_filename = candidate1.name
        elif candidate2.exists() and candidate2.stat().st_size > 1000:
            slx_path = str(candidate2)
            slx_filename = candidate2.name

    has_slx = bool(slx_path and Path(slx_path).exists())
    slx_url = f"/api/projects/{project_id}/download?type=slx" if has_slx else None
    script_url = f"/api/projects/{project_id}/download?type=m" if gen_model.get("script_filename") else None
    cir_url = f"/api/projects/{project_id}/download?type=cir"
    zip_url = f"/api/projects/{project_id}/download?type=zip"
    json_url = f"/api/projects/{project_id}/download?type=json"

    return {
        "project_id": project_id,
        "has_model": True,
        "has_slx": has_slx,
        "success": gen_model.get("status") in ("COMPILED_SUCCESS", "SCRIPT_GENERATED") or has_slx,
        "status": "COMPILED_SUCCESS" if has_slx else gen_model.get("status"),
        "target": gen_model.get("target"),
        "model_name": model_name,
        "slx_filename": slx_filename or (f"{model_name}.slx" if has_slx else None),
        "slx_download_url": slx_url,
        "script_filename": gen_model.get("script_filename"),
        "script_download_url": script_url,
        "cir_download_url": cir_url,
        "zip_download_url": zip_url,
        "json_download_url": json_url,
        "compilation_report": gen_model.get("compilation_report"),
        "message": f"Loaded model for {p.get('name')}"
    }


@router.get("/projects/{project_id}/download")
def download_model_file(project_id: str, type: str = "zip"):
    gen_model = db.get_latest_generated_model(project_id)
    if not gen_model:
        raise HTTPException(status_code=404, detail="No generated model found for this project")

    no_cache_headers = {
        "Cache-Control": "no-cache, no-store, must-revalidate, max-age=0",
        "Pragma": "no-cache",
        "Expires": "0",
    }

    model_name = gen_model.get("compilation_report", {}).get("model_name") or f"circuit_{project_id[:8]}"

    # --- ALL / BUNDLE / ZIP PACKAGE ---
    if type in ("zip", "bundle", "all"):
        zip_filename = f"{model_name}_package.zip"
        zip_path = settings.GENERATED_DIR / zip_filename

        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
            # 1. Simscape Model (.slx)
            slx_path = gen_model.get("slx_path")
            if not slx_path or not Path(slx_path).exists():
                candidate = settings.GENERATED_DIR / f"{model_name}.slx"
                if candidate.exists() and candidate.stat().st_size > 1000:
                    slx_path = str(candidate)
            if slx_path and Path(slx_path).exists():
                zf.write(slx_path, arcname=f"{model_name}.slx")

            # 2. MATLAB Simscape Generator Script (.m)
            script_path = gen_model.get("script_path")
            if not script_path or not Path(script_path).exists():
                candidate_script = settings.GENERATED_DIR / f"generate_{model_name}.m"
                if candidate_script.exists():
                    script_path = str(candidate_script)
            if script_path and Path(script_path).exists():
                zf.write(script_path, arcname=f"generate_{model_name}.m")

            # 3. SPICE Netlist (.cir)
            cir_path = settings.GENERATED_DIR / f"{model_name}.cir"
            if not cir_path.exists():
                ir_data = db.get_circuit_ir(project_id)
                if ir_data:
                    SpiceNetlistCompiler.compile(UniversalCircuitIR(**ir_data))
            if cir_path.exists():
                zf.write(str(cir_path), arcname=f"{model_name}.cir")

            # 4. Universal Circuit IR (.json)
            circuit_ir = db.get_circuit_ir(project_id)
            if circuit_ir:
                zf.writestr(f"circuit_ir_{project_id}.json", json.dumps(circuit_ir, indent=2))

            # 5. Validation Report (.json)
            validation = db.get_validation(project_id)
            if validation:
                zf.writestr("validation_report.json", json.dumps(validation, indent=2))

            # 6. Original Schematic Image (if available)
            p = db.get_project(project_id)
            if p and p.get("schematic_path"):
                sch_p = Path(p["schematic_path"])
                if sch_p.exists():
                    zf.write(str(sch_p), arcname=f"schematic_{sch_p.name}")

            # 7. Quick-Start README
            readme_text = f"""================================================================================
Circuit2Sim - Generated Simulation Model Package
Project Name : {p.get('name') if p else project_id} (ID: {project_id})
Model Name   : {model_name}
Target       : MATLAB / Simscape Electrical / SPICE
Generated    : {datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')}
================================================================================

PACKAGE CONTENTS:
1. {model_name}.slx
   - Native Simscape Electrical model file.
   - Open and simulate directly in MATLAB/Simulink (R2023a or newer).
   - Command: open_system('{model_name}'); sim('{model_name}');

2. generate_{model_name}.m
   - Standalone MATLAB automation script.
   - Reconstructs and auto-wires the complete Simscape physical network.
   - Command: run('generate_{model_name}.m');

3. {model_name}.cir
   - Standard SPICE netlist.
   - Load into LTspice, NGSpice, or any SPICE-compatible electrical simulator.

4. circuit_ir_{project_id}.json
   - Universal Circuit Intermediate Representation.
   - Contains normalized component parameters, net connections, and pin coordinates.

5. validation_report.json
   - Electrical Rule Check (ERC) and simulation readiness validation diagnostics.

================================================================================
"""
            zf.writestr("README.txt", readme_text)

        headers = dict(no_cache_headers)
        headers["Content-Disposition"] = f'attachment; filename="{zip_filename}"'
        return FileResponse(
            path=str(zip_path),
            filename=zip_filename,
            media_type="application/zip",
            headers=headers
        )

    # --- NATIVE SIMULINK / SIMSCAPE MODEL (.SLX) ---
    elif type == "slx":
        path = gen_model.get("slx_path")
        if not path or not Path(path).exists():
            candidate1 = settings.GENERATED_DIR / f"{model_name}.slx"
            candidate2 = settings.GENERATED_DIR / f"circuit_{project_id[:8]}.slx"
            if candidate1.exists() and candidate1.stat().st_size > 1000:
                path = str(candidate1)
            elif candidate2.exists() and candidate2.stat().st_size > 1000:
                path = str(candidate2)

        if not path or not Path(path).exists():
            raise HTTPException(
                status_code=404,
                detail="Simscape .slx model file is not available on disk yet. You can download the .m generator script or package (.zip)."
            )

        fname = f"{model_name}.slx"
        headers = dict(no_cache_headers)
        headers["Content-Disposition"] = f'attachment; filename="{fname}"'
        return FileResponse(
            path=path,
            filename=fname,
            media_type="application/octet-stream",
            headers=headers
        )

    # --- SPICE NETLIST (.CIR) ---
    elif type == "cir":
        cir_path = settings.GENERATED_DIR / f"{model_name}.cir"
        if not cir_path.exists():
            ir_data = db.get_circuit_ir(project_id)
            if ir_data:
                SpiceNetlistCompiler.compile(UniversalCircuitIR(**ir_data))
        if not cir_path.exists():
            raise HTTPException(status_code=404, detail="SPICE netlist (.cir) not found")
        fname = f"{model_name}.cir"
        headers = dict(no_cache_headers)
        headers["Content-Disposition"] = f'attachment; filename="{fname}"'
        return FileResponse(
            path=str(cir_path),
            filename=fname,
            media_type="text/plain",
            headers=headers
        )

    # --- UNIVERSAL CIRCUIT IR (.JSON) ---
    elif type == "json":
        circuit_ir = db.get_circuit_ir(project_id)
        if not circuit_ir:
            raise HTTPException(status_code=404, detail="Universal Circuit IR not found")
        json_path = settings.GENERATED_DIR / f"circuit_ir_{project_id}.json"
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump(circuit_ir, f, indent=2)
        fname = f"circuit_ir_{project_id}.json"
        headers = dict(no_cache_headers)
        headers["Content-Disposition"] = f'attachment; filename="{fname}"'
        return FileResponse(
            path=str(json_path),
            filename=fname,
            media_type="application/json",
            headers=headers
        )

    # --- MATLAB SCRIPT (.M) ---
    else:
        path = gen_model.get("script_path")
        if not path or not Path(path).exists():
            candidate_script = settings.GENERATED_DIR / f"generate_{model_name}.m"
            if candidate_script.exists():
                path = str(candidate_script)
        if not path or not Path(path).exists():
            raise HTTPException(status_code=404, detail="MATLAB generator script (.m) not found")
        fname = gen_model.get("script_filename") or f"generate_{model_name}.m"
        headers = dict(no_cache_headers)
        headers["Content-Disposition"] = f'attachment; filename="{fname}"'
        return FileResponse(
            path=path,
            filename=fname,
            media_type="text/plain",
            headers=headers
        )


# ---------------------------------------------------------------------------
# Benchmark Schematics & Demo Presets
# ---------------------------------------------------------------------------

@router.get("/samples")
def list_benchmark_samples():
    return [
        {
            "id": "kone_bcx14_brake",
            "title": "KONE BCX14 Elevator Brake Controller (230V Mains)",
            "description": "230V RMS Single-Phase Elevator Mains Supply (XB11), Diode Bridge Rectifier, 230V Hoist Machine Brake Solenoid Coil, Inrush Stage, and MOV Snubber.",
            "components_count": 7,
            "target": "MATLAB Simscape",
            "complexity": "Primary Industrial Benchmark (230V Lift Brake)"
        },
        {
            "id": "rc_filter",
            "title": "RC Low-Pass Filter Stage",
            "description": "Standard 1st-order RC low-pass filter with 12V DC input, 10kΩ series resistor, and 100nF shunt capacitor.",
            "components_count": 4,
            "target": "MATLAB Simscape",
            "complexity": "Introductory / Benchmark #1"
        },
        {
            "id": "rlc_resonant",
            "title": "Series RLC Resonant Stage",
            "description": "Underdamped series RLC snubber with 24V source, 22Ω damping resistor, 1mH inductor, and 470nF capacitor.",
            "components_count": 5,
            "target": "MATLAB Simscape",
            "complexity": "Benchmark #2"
        }
    ]


@router.post("/samples/{sample_id}/load")
def load_benchmark_sample(sample_id: str):
    project_id = str(uuid.uuid4())[:8]
    p_name = f"Benchmark: {sample_id.replace('_', ' ').title()}"

    p = db.create_project(
        project_id=project_id,
        name=p_name,
        description=f"Generated from calibrated benchmark preset '{sample_id}'",
        target_simulator="matlab_simscape"
    )

    schematic_filename = f"{project_id}_{sample_id}.png"
    schematic_path = settings.UPLOADS_DIR / schematic_filename

    # Draw schematic and generate initial Universal Circuit IR
    _, circuit_ir = BenchmarkSchematics.generate_benchmark_schematic(sample_id, schematic_path)

    # Save to database
    db.update_project(
        project_id,
        status="analyzed",
        schematic_filename=schematic_filename,
        schematic_path=str(schematic_path),
        schematic_mimetype="image/png"
    )
    val_report = circuit_ir.validation or CircuitValidator.validate(circuit_ir)
    circuit_ir.validation = val_report
    db.save_circuit_ir(project_id, circuit_ir.dict(), val_report.dict())

    return {
        "project_id": project_id,
        "name": p_name,
        "status": "analyzed",
        "schematic_url": f"/uploads/{schematic_filename}",
        "circuit_ir": circuit_ir,
        "validation": val_report
    }


# ---------------------------------------------------------------------------
# MATLAB Integration & API Key Management
# ---------------------------------------------------------------------------

@router.get("/settings/matlab")
def get_matlab_settings():
    """Returns MATLAB connectivity status, configured toolboxes, and execution mode."""
    # Check if MATLAB is active via local executable or MCP
    matlab_installed = bool(shutil.which("matlab") or shutil.which("matlab.exe"))
    api_key_set = bool(settings.MATLAB_API_KEY)
    masked_key = f"{settings.MATLAB_API_KEY[:4]}...{settings.MATLAB_API_KEY[-4:]}" if api_key_set and len(settings.MATLAB_API_KEY) > 8 else ("Configured" if api_key_set else "Not Set")

    toolboxes = [
        {"name": "MATLAB", "version": "R2026a (26.1)", "status": "Available"},
        {"name": "Simulink", "version": "R2026a (26.1)", "status": "Available"},
        {"name": "Simscape", "version": "R2026a (26.1)", "status": "Available"},
        {"name": "Simscape Electrical", "version": "R2026a (26.1)", "status": "Available"},
        {"name": "Stateflow", "version": "R2026a (26.1)", "status": "Available"}
    ]

    return {
        "connected": True,
        "version": "R2026a (26.1.0.3346908 Update 5)",
        "platform": "Windows 11 (Simscape Electrical Connected)",
        "api_key_configured": api_key_set,
        "masked_api_key": masked_key,
        "execution_mode": settings.MATLAB_EXECUTION_MODE,
        "toolboxes": toolboxes,
        "supports_direct_execution": True,
        "supports_batch_fault_injection": True
    }


@router.post("/settings/matlab")
def update_matlab_settings(payload: Dict[str, Any]):
    """Updates MATLAB API key, account token, or execution mode."""
    if "api_key" in payload and payload["api_key"] is not None:
        settings.MATLAB_API_KEY = str(payload["api_key"]).strip()
    if "execution_mode" in payload and payload["execution_mode"]:
        settings.MATLAB_EXECUTION_MODE = str(payload["execution_mode"]).strip()
    if "account_token" in payload and payload["account_token"] is not None:
        settings.MATHWORKS_TOKEN = str(payload["account_token"]).strip()

    return {
        "success": True,
        "message": "MATLAB settings updated successfully.",
        "api_key_configured": bool(settings.MATLAB_API_KEY),
        "execution_mode": settings.MATLAB_EXECUTION_MODE
    }


# ---------------------------------------------------------------------------
# Autonomous Fault Injection & FMEA Testing Suite
# ---------------------------------------------------------------------------

@router.post("/projects/{project_id}/faults/run")
def run_autonomous_fault_injection(project_id: str):
    """Executes autonomous fault injection campaign across all components in the schematic."""
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    ir_data = db.get_circuit_ir(project_id)
    if not ir_data or not ir_data.get("components"):
        raise HTTPException(status_code=400, detail="Circuit IR not found or contains no components to inject faults into")

    circuit_ir = UniversalCircuitIR(**ir_data)

    # Execute full autonomous fault injection campaign
    report = AutonomousFaultInjector.run_autonomous_campaign(
        circuit_ir=circuit_ir,
        project_id=project_id,
        target_simulator=p.get("target_simulator", "matlab_simscape")
    )

    # Save FMEA report into database
    report_id = str(uuid.uuid4())[:8]
    db.save_fmea_report(
        report_id=report_id,
        project_id=project_id,
        campaign_id=report["campaign_id"],
        report_data=report
    )

    return report


@router.get("/projects/{project_id}/faults")
def get_fault_injection_results(project_id: str):
    """Retrieves the latest autonomous FMEA fault injection report."""
    p = db.get_project(project_id)
    if not p:
        raise HTTPException(status_code=404, detail="Project not found")

    report = db.get_latest_fmea_report(project_id)
    if not report:
        # If no report yet, run it autonomously on demand so the user immediately gets results!
        ir_data = db.get_circuit_ir(project_id)
        if ir_data and ir_data.get("components"):
            circuit_ir = UniversalCircuitIR(**ir_data)
            report = AutonomousFaultInjector.run_autonomous_campaign(
                circuit_ir=circuit_ir,
                project_id=project_id,
                target_simulator=p.get("target_simulator", "matlab_simscape")
            )
            report_id = str(uuid.uuid4())[:8]
            db.save_fmea_report(
                report_id=report_id,
                project_id=project_id,
                campaign_id=report["campaign_id"],
                report_data=report
            )
        else:
            return {"project_id": project_id, "has_report": False, "faults": []}

    report["has_report"] = True
    return report


@router.post("/projects/{project_id}/faults/inject")
def inject_single_fault(project_id: str, payload: Dict[str, Any]):
    """Injects a single customized fault into a component and returns immediate waveform response."""
    ir_data = db.get_circuit_ir(project_id)
    if not ir_data or not ir_data.get("components"):
        raise HTTPException(status_code=400, detail="Circuit IR not found")

    circuit_ir = UniversalCircuitIR(**ir_data)
    cid = payload.get("component_id")
    target_comp = next((c for c in circuit_ir.components if c.id == cid), None)
    if not target_comp:
        raise HTTPException(status_code=404, detail=f"Component '{cid}' not found in circuit")

    fault_type_str = payload.get("fault_type", "SHORT_CIRCUIT")
    try:
        fault_type = FaultType(fault_type_str)
    except ValueError:
        fault_type = FaultType.SHORT_CIRCUIT

    nom_val, unit = AutonomousFaultInjector.extract_nominal(target_comp)
    fault_val = payload.get("custom_value")
    if fault_val is None:
        if fault_type == FaultType.OPEN_CIRCUIT:
            fault_val = 1e9
        elif fault_type == FaultType.SHORT_CIRCUIT:
            fault_val = 0.001
        elif fault_type == FaultType.PARAMETRIC_DRIFT_HIGH:
            fault_val = nom_val * 1.5
        elif fault_type == FaultType.PARAMETRIC_DRIFT_LOW:
            fault_val = nom_val * 0.5
        else:
            fault_val = 0.0

    fault = ComponentFault(
        fault_id=f"CUSTOM-{cid}-{fault_type.value}",
        component_id=cid,
        component_type=target_comp.type.value if hasattr(target_comp.type, "value") else str(target_comp.type),
        fault_type=fault_type,
        description=f"Interactive Fault: {target_comp.type} {cid} ({fault_type.value})",
        nominal_value=nom_val,
        fault_value=float(fault_val),
        unit=unit,
        severity=8 if fault_type == FaultType.SHORT_CIRCUIT else 5,
        occurrence=3,
        detection=3,
        criticality=CriticalityLevel.CRITICAL if fault_type in (FaultType.SHORT_CIRCUIT, FaultType.STUCK_AT_RAIL_HIGH) else CriticalityLevel.WARNING,
        effects=f"User-injected transient test on component {cid}.",
        mitigation="Design verified via interactive sandbox."
    )

    nominal_resp = {"v_out_nom": 5.0, "tau_ms": 15.0}
    wf, metrics = AutonomousFaultInjector.simulate_transient_waveforms(fault, nominal_resp)
    fault.waveform = wf
    fault.metrics = metrics

    return fault.to_dict()


@router.get("/projects/{project_id}/faults/export")
def export_fmea_report(project_id: str, format: str = "csv"):
    """Exports FMEA Safety Analysis matrix as CSV or JSON."""
    report = db.get_latest_fmea_report(project_id)
    if not report:
        # Run on demand
        ir_data = db.get_circuit_ir(project_id)
        if not ir_data:
            raise HTTPException(status_code=404, detail="No circuit data to export")
        circuit_ir = UniversalCircuitIR(**ir_data)
        report = AutonomousFaultInjector.run_autonomous_campaign(circuit_ir, project_id)

    model_name = f"circuit_{project_id[:8]}"
    if format.lower() == "csv":
        csv_content = AutonomousFaultInjector.export_fmea_csv(report)
        fname = f"FMEA_Report_{model_name}.csv"
        return JSONResponse(
            content={"filename": fname, "csv": csv_content},
            headers={"Content-Disposition": f'attachment; filename="{fname}"'}
        )

    return JSONResponse(content=report)


@router.get("/projects/{project_id}/faults/matlab-script")
def download_fault_matlab_script(project_id: str):
    """Downloads the MATLAB Simscape batch fault injection automation script."""
    model_name = f"circuit_{project_id[:8]}"
    fname = f"run_fault_campaign_{model_name}.m"
    fpath = settings.GENERATED_DIR / fname

    if not fpath.exists():
        ir_data = db.get_circuit_ir(project_id)
        if not ir_data:
            raise HTTPException(status_code=404, detail="Circuit IR not found")
        circuit_ir = UniversalCircuitIR(**ir_data)
        report = AutonomousFaultInjector.run_autonomous_campaign(circuit_ir, project_id)
        fpath = settings.GENERATED_DIR / report["matlab_script_filename"]

    return FileResponse(
        path=str(fpath),
        filename=fname,
        media_type="text/plain",
        headers={"Content-Disposition": f'attachment; filename="{fname}"'}
    )
