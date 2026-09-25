# Circuit2Sim API Reference

Base URL: `http://localhost:8000/api`

### 1. Projects
- `POST /projects`: Create a new project.
- `GET /projects`: List all projects with summaries.
- `GET /projects/{id}`: Retrieve project details.

### 2. Schematic Upload & Vision Pipeline
- `POST /projects/{id}/schematic`: Upload schematic file (`.png`, `.jpg`, `.jpeg`, `.pdf`).
- `POST /projects/{id}/analyze`: Launch asynchronous 5-stage circuit understanding pipeline.
- `GET /projects/{id}/analysis`: Retrieve analysis job status, stage logs, and generated Universal Circuit IR.

### 3. Review & Manual Corrections
- `PUT /projects/{id}/components/{component_id}`: Edit component type, nominal value, orientation, or mark verified.
- `POST /projects/{id}/components`: Add missing component.
- `DELETE /projects/{id}/components/{component_id}`: Delete false positive component.
- `PUT /projects/{id}/connections`: Update electrical nets.

### 4. Validation & Model Compilation
- `GET /projects/{id}/validation`: Inspect topological and parametric simulation readiness report.
- `POST /projects/{id}/generate`: Compile Universal Circuit IR into MATLAB/Simscape `.slx` and `.m` generator.
- `GET /projects/{id}/download?type=zip|slx|m|cir|json`: Download complete simulation bundle (.zip) or individual artifacts (.slx, .m, .cir, .json).

### 5. Calibrated Benchmarks
- `GET /samples`: List pre-calibrated engineering benchmarks.
- `POST /samples/{sample_id}/load`: Instantiate a new project from a benchmark preset.
