# Circuit2Sim — Schematic to Native Simulation Model SaaS

Circuit2Sim takes electrical circuit schematics uploaded by users and converts them into **native, fully editable simulation models**, initially targeting **MATLAB/Simulink/Simscape (`.slx`)**.

---

## Demonstrable User Experience

```
UPLOAD SCHEMATIC → UNDERSTAND CIRCUIT → REVIEW & EDIT → GENERATE MODEL → DOWNLOAD .SLX
```

1. **Dashboard & Project Creation**: Create projects or load pre-calibrated engineering benchmarks (e.g., RC Low-Pass Filter, Series RLC Snubber).
2. **Schematic Viewport**: View high-resolution circuit diagrams with overlaid bounding boxes, pin markers, and net connections.
3. **5-Stage Circuit Understanding Pipeline**:
   - `Image/PDF Preprocessing`
   - `Symbol & Component Detection`
   - `Electronics Notation OCR & Value Extraction`
   - `Conductive Wire & Junction Tracing`
   - `Universal Circuit IR Generation`
4. **Engineering Review Interface**: Tabular component editor with confidence indicators, SI unit parsing, and explicit `UNCERTAIN — PLEASE VERIFY` alerts.
5. **Topological & Simulation Validation**: Verifies reference nodes (Ground), checks for floating pins or short circuits, and reports compilation readiness.
6. **MATLAB Simscape Compiler**: Translates Universal Circuit IR into clean Simscape Electrical blocks (`fl_lib/Electrical/Electrical Elements/Resistor`, `Capacitor`, `Inductor`, `DC Voltage Source`, `Electrical Reference`, `Solver Configuration`), runs simulation smoke tests, and exports both `.slx` and `.m` scripts.

---

## Project Structure

```
circuit2sim/
│
├── frontend/                     # Next.js 16 (React 19 + TypeScript + Tailwind CSS)
│   ├── app/
│   │   ├── page.tsx              # Main dashboard & interactive workspace
│   │   ├── layout.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── Navbar.tsx            # Technical top navigation & simulator target badge
│   │   ├── SchematicViewer.tsx   # Interactive canvas with detection overlays
│   │   ├── ComponentReviewTable.tsx # Tabular review & manual correction editor
│   │   ├── ValidationReportCard.tsx # Validation status & error/warning report
│   │   ├── ModelCompilerPanel.tsx   # Simscape compilation & download drawer
│   │   └── NewProjectModal.tsx   # Project creation & benchmark loader
│   ├── lib/
│   │   └── api.ts                # REST API client
│   └── types/
│       └── circuit.ts            # TypeScript interfaces for Circuit IR
│
├── backend/                      # Python 3.10+ FastAPI Backend
│   ├── app/
│   │   ├── main.py               # FastAPI entry point & static file mounts
│   │   ├── api/
│   │   │   └── routes.py         # REST endpoints for projects, upload, analysis, compiler
│   │   ├── core/
│   │   │   ├── config.py         # App configuration & paths
│   │   │   └── database.py       # SQLite database manager (WAL mode)
│   │   ├── circuit/              # Circuit graph abstractions
│   │   ├── vision/
│   │   │   ├── preprocessing.py  # Image & PDF contrast/binarization
│   │   │   ├── detector.py       # Component contour detection & OCR parser
│   │   │   ├── wire_tracer.py    # Wire morphology & net reconstruction
│   │   │   └── pipeline.py       # 5-stage pipeline & benchmark generators
│   │   ├── compiler/
│   │   │   └── matlab_simscape.py # Native Simscape block mapping & .slx compiler
│   │   └── validation/
│   │       └── circuit_validator.py # Topological & simulation readiness checker
│   └── tests/
│       └── test_circuit2sim.py   # Unit test suite
│
├── models/
│   ├── circuit_ir/
│   │   └── circuit.py            # Universal Circuit IR Pydantic models (v0.1)
│   └── schemas/
│       └── api.py                # REST request/response schemas
│
├── matlab/                       # MATLAB generation assets
│   ├── generators/
│   ├── templates/
│   └── validation/
│
├── uploads/                      # Storage for uploaded schematic images & PDFs
├── generated/                    # Storage for compiled .slx models & .m scripts
├── docs/                         # Architecture and API documentation
└── README.md
```

---

## Environment Requirements

- **Operating System**: Windows / Linux / macOS
- **Python**: 3.10+
  - Dependencies: `fastapi`, `uvicorn`, `pydantic`, `opencv-python`, `numpy`, `networkx`, `pillow`, `pypdf`, `scipy`
- **Node.js**: v18+ (v24.20.0 recommended) with `npm`
- **MATLAB** (Optional for headless `.slx` compilation):
  - MATLAB R2023b+ with Simulink and Simscape / Simscape Electrical installed.
  - If MATLAB is not installed or detected, Circuit2Sim gracefully generates verified standalone Simulink generator scripts (`.m`) and exports the complete Universal Circuit IR (`.json`).

---

## Exact Commands to Run

### 1. Start the FastAPI Backend
Open a terminal in the project root (`f:\KONE FINALS`):
```bash
python -m uvicorn circuit2sim.backend.app.main:app --host 127.0.0.1 --port 8000 --reload
```
API docs will be available at: `http://127.0.0.1:8000/docs`
Health check: `http://127.0.0.1:8000/health`

### 2. Start the Next.js Frontend
Open a second terminal in `circuit2sim/frontend`:
```bash
cd circuit2sim/frontend
npm run dev
```
The web application will open at: `http://localhost:3000`

### 3. Run Backend Test Suite
```bash
python -m unittest circuit2sim.backend.tests.test_circuit2sim
```

---

## Current Functionality (Phase 1 MVP)

1. **Dashboard & Projects**: Create custom projects or load calibrated engineering benchmark presets (`RC Low-Pass Filter`, `Series RLC Resonant Stage`).
2. **Schematic Viewport & Overlays**:
   - Interactive zoom/pan schematic viewer.
   - Bounding box overlays on detected symbols with confidence ratings.
   - Pin/terminal markers (`1`, `2`, `+`, `-`, `GND`).
   - Click-to-focus synchronization with the Review table.
3. **5-Stage Vision Understanding Engine**:
   - Preprocesses images & PDFs with adaptive thresholding.
   - Detects circuit symbols and candidate regions.
   - Parses engineering electrical notation (`10k`, `100nF`, `47uH`, `12V`, `1k5`, `220R`).
   - Flags ambiguous parameters as `"UNCERTAIN — PLEASE VERIFY"` instead of guessing.
   - Traces conductive paths and reconstructs electrical nets.
4. **Universal Circuit IR (v0.1)**:
   - Simulator-independent Pydantic models for components, pins, nets, parameters, and confidence metrics.
5. **Topological & Simulation Validation**:
   - Verifies presence of electrical reference node (Ground).
   - Identifies dangling or floating pins.
   - Detects potential short circuits (two-terminal devices shorted on identical net).
6. **MATLAB / Simscape Compiler**:
   - Generates native Simscape Electrical models using `fl_lib` and `nesl_utility/Solver Configuration`.
   - Emits documented, standalone MATLAB scripts (`.m`) that construct the model via Simulink programmatic APIs.
   - Auto-calculates coordinate placement grid to prevent overlapping blocks.
   - Compiles `.slx` and executes simulation smoke tests when MATLAB CLI is available.
   - Gracefully reports `"MATLAB backend unavailable"` if MATLAB is not active, providing the verified `.m` generator and Universal Circuit IR for manual or desktop compilation.

---

## Known Limitations

1. **Active Semiconductor Symbols**: Phase 1 focuses on standard two-terminal and single-terminal components (Resistors, Capacitors, Inductors, Voltage Sources, Current Sources, Diodes, Grounds, Switches). Advanced multi-terminal switches (MOSFETs, IGBTs, Three-Phase Bridge Rectifiers) will be added in Phase 6.
2. **Hand-Drawn Sketches**: The optical contour matcher is calibrated for clean engineering schematics, CAD exports, and vector diagrams. Freehand napkin sketches with disconnected lines require manual pin correction in the review table.
3. **Headless MATLAB Cold-Start**: On Windows, launching a headless `matlab.exe` batch process from cold start can take 60–90 seconds while MATLAB loads its runtime environment. The UI provides standalone `.m` download as an instant alternative.

---

## Next Implementation Steps

- **Phase 2 Expansion**: Integrate a fine-tuned YOLO / ViT model for complex multi-terminal symbols (MOSFETs, IGBTs, Transformers, Op-Amps).
- **Phase 3 Wire Router**: Advanced A* path routing for complex multi-junction bus connections.
- **Phase 4 Multi-Target Compilers**: Expand from MATLAB/Simscape to SPICE netlists (`.cir`), PLECS (`.plecs`), and OpenModelica (`.mo`).
- **Phase 6 Power Electronics Benchmarks**: Full converter stages including BCX14 DC-DC converters, 3-phase inverters, and DC links.
