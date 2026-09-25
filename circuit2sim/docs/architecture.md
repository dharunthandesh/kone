# Circuit2Sim System Architecture

Circuit2Sim is an engineering SaaS system that takes electrical circuit schematics uploaded by users and converts them into native, editable simulation models, initially targeting MATLAB/Simulink/Simscape (`.slx`).

---

## 1. High-Level Pipeline

```
SCHEMATIC (PNG / JPG / PDF)
           ↓
IMAGE / PDF PREPROCESSING
           ↓
CONNECTED STROKE & COMPONENT DETECTION
           ↓
ELECTRONICS NOTATION OCR & VALUE EXTRACTION
           ↓
CONDUCTIVE WIRE & JUNCTION TRACING
           ↓
CIRCUIT GRAPH RECONSTRUCTION
           ↓
UNIVERSAL CIRCUIT IR (Simulator-Independent)
           ↓
TOPOLOGICAL & PARAMETRIC VALIDATION
           ↓
TARGET-SPECIFIC COMPILER (MATLAB Simscape)
           ↓
NATIVE EDITABLE MODEL (.slx) + GENERATOR SCRIPT (.m)
```

---

## 2. Universal Circuit IR (`circuit_ir/`)

The Universal Circuit IR decouples schematic understanding from any specific target simulator. It strictly stores:
- **Components**: Reference ID (`R1`, `C1`, `V1`, `GND1`), canonical component type, SI parameters (resistance, capacitance, inductance, voltage, etc.), pin names (`1`, `2`, `+`, `-`), confidence score, bounding box, orientation, and uncertainty warnings.
- **Nets**: Connected pin endpoints in `ComponentID.Pin` format (`["V1.+", "R1.1"]`), ground flags, confidence scores.
- **Metadata**: Schematic dimensions, timestamps, source project.
- **Validation Report**: Summary of detected components, verified connections, parameter status, and compilation readiness.

---

## 3. Strict Engineering Rules

1. **No Fake Conversion**: Never pretend a model was generated if the simulator failed.
2. **Expose Uncertainty**: Never silently guess ambiguous values or floating nets. Prefer `"UNCERTAIN — PLEASE VERIFY"`.
3. **No Flattened Models**: Generates native Simscape blocks (`fl_lib/Electrical/Electrical Elements/Resistor`, etc.) that remain individually selectable, editable, and parameterizable inside MATLAB.
4. **Simulator Independence**: Universal Circuit IR remains 100% agnostic to MATLAB, ready for SPICE, PLECS, or OpenModelica compilers.
