"""Generator for 20 Additional Synthetic Circuit Datasets (DS-11 through DS-30)

Completes the 30-dataset industrial benchmark suite for Circuit2Sim.
Creates:
- High-contrast, clean 1000x650 schematic diagrams (schematic.png)
- Validated Universal Circuit IR (circuit_ir.json)
- Programmatic Simscape compiler scripts (generate_model.m)
- Verified Simscape Electrical binary models (model_<name>.slx)
- Technical metadata & transfer function specifications (metadata.json)
"""

import json
import os
import shutil
import sys
from pathlib import Path
import cv2
import numpy as np

BASE_DIR = Path(r"f:\KONE FINALS")
if str(BASE_DIR) not in sys.path:
    sys.path.insert(0, str(BASE_DIR))

from circuit2sim.backend.app.compiler.matlab_simscape import MatlabBlockMapping, MatlabSimscapeCompiler
from circuit2sim.backend.app.validation.circuit_validator import CircuitValidator
from circuit2sim.datasets.generate_datasets import draw_schematic_canvas
from circuit2sim.models.circuit_ir.circuit import (
    BoundingBox,
    Component,
    ComponentType,
    Net,
    ParameterValue,
    UniversalCircuitIR,
)


def get_additional_20_datasets():
    datasets = []

    # =========================================================================
    # 11. High-Pass RC Filter
    # =========================================================================
    ds11_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="AC Input Signal",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="DC Blocking Capacitor",
            parameters={"capacitance": ParameterValue(value=1.0e-6, unit="F", raw_text="1uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=170, w=80, h=40)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Output Load Resistor",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=550, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=340, y=410, w=60, h=40)
        ),
    ]
    ds11_nets = [
        Net(id="N_IN", connections=["V1.+", "C1.1"], confidence=1.0),
        Net(id="N_OUT", connections=["C1.2", "R1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds11_draw = {
        "title": "First-Order RC High-Pass Filter",
        "subtitle": "AC Signal Coupling & DC Offset Blocking (fc = 159.15 Hz)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (160, 300), "val": "10V"},
            {"id": "C1", "type": "capacitor_h", "pos": (380, 200), "val": "1 uF"},
            {"id": "R1", "type": "resistor_v", "pos": (600, 300), "val": "1.0k Ohm"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((160, 275), (160, 200)), ((160, 200), (370, 200)),
            ((390, 200), (600, 200)), ((600, 200), (600, 265)),
            ((600, 335), (600, 420)), ((160, 325), (160, 420)),
            ((160, 420), (600, 420)),
        ],
        "junctions": [(380, 420), (600, 200), (600, 420)],
    }
    ds11_meta = {
        "name": "11_highpass_rc_filter",
        "title": "First-Order RC High-Pass Filter",
        "category": "Audio & Signal Conditioning",
        "domain": "Analog Processing / AC Coupling",
        "description": "Fundamental passive high-pass RC filter removing low-frequency drift and DC bias while passing high-frequency spectral content.",
        "theory": {
            "transfer_function": "H(s) = (s*R*C) / (1 + s*R*C)",
            "cutoff_frequency_hz": 159.15,
            "time_constant_seconds": 0.001,
            "high_frequency_gain_db": 0.0,
            "phase_at_fc_deg": 45.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.05, "max_step_size": "1e-5"}
    }
    datasets.append((ds11_components, ds11_nets, ds11_draw, ds11_meta))

    # =========================================================================
    # 12. RL High-Pass Filter
    # =========================================================================
    ds12_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="AC Generator",
            parameters={"voltage": ParameterValue(value=12.0, unit="V", raw_text="12V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Series Input Resistor",
            parameters={"resistance": ParameterValue(value=100.0, unit="ohm", raw_text="100R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=170, w=80, h=40)
        ),
        Component(
            id="L1", type=ComponentType.INDUCTOR, name="Shunt High-Pass Choke",
            parameters={"inductance": ParameterValue(value=0.01, unit="H", raw_text="10mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=550, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=340, y=410, w=60, h=40)
        ),
    ]
    ds12_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_OUT", connections=["R1.2", "L1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "L1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds12_draw = {
        "title": "First-Order RL High-Pass Filter",
        "subtitle": "Inductive High-Pass Filtering Network (fc = 1591.55 Hz)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (160, 300), "val": "12V"},
            {"id": "R1", "type": "resistor_h", "pos": (380, 200), "val": "100 Ohm"},
            {"id": "L1", "type": "inductor_v", "pos": (600, 300), "val": "10 mH"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((160, 275), (160, 200)), ((160, 200), (345, 200)),
            ((415, 200), (600, 200)), ((600, 200), (600, 260)),
            ((600, 340), (600, 420)), ((160, 325), (160, 420)),
            ((160, 420), (600, 420)),
        ],
        "junctions": [(380, 420), (600, 200), (600, 420)],
    }
    ds12_meta = {
        "name": "12_rl_highpass_filter",
        "title": "First-Order RL High-Pass Filter",
        "category": "Passive RF & Power Filters",
        "domain": "Telecommunications / Transient Shunting",
        "description": "Series resistor and parallel inductor network providing high-frequency transmission while shunting low frequencies to ground.",
        "theory": {
            "transfer_function": "H(s) = (s*L) / (R + s*L)",
            "cutoff_frequency_hz": 1591.55,
            "time_constant_seconds": 0.0001,
            "dc_attenuation": "Infinite (Short to GND)"
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "5e-6"}
    }
    datasets.append((ds12_components, ds12_nets, ds12_draw, ds12_meta))

    # =========================================================================
    # 13. Series RLC Band-Pass Filter
    # =========================================================================
    ds13_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Signal Generator",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Series Resonator Capacitor",
            parameters={"capacitance": ParameterValue(value=1.0e-6, unit="F", raw_text="1uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=280, y=170, w=80, h=40)
        ),
        Component(
            id="L1", type=ComponentType.INDUCTOR, name="Series Resonator Inductor",
            parameters={"inductance": ParameterValue(value=0.02533, unit="H", raw_text="25.33mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=440, y=170, w=80, h=40)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Output Resistor",
            parameters={"resistance": ParameterValue(value=50.0, unit="ohm", raw_text="50R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=600, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=380, y=410, w=60, h=40)
        ),
    ]
    ds13_nets = [
        Net(id="N_IN", connections=["V1.+", "C1.1"], confidence=1.0),
        Net(id="N_CL", connections=["C1.2", "L1.1"], confidence=1.0),
        Net(id="N_OUT", connections=["L1.2", "R1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds13_draw = {
        "title": "Second-Order Series RLC Band-Pass Filter",
        "subtitle": "Narrowband Bandpass Resonator (f0 = 1000 Hz, Q = 3.18)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (140, 300), "val": "10V"},
            {"id": "C1", "type": "capacitor_h", "pos": (300, 200), "val": "1 uF"},
            {"id": "L1", "type": "inductor_h", "pos": (460, 200), "val": "25.33 mH"},
            {"id": "R1", "type": "resistor_v", "pos": (620, 300), "val": "50 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((140, 275), (140, 200)), ((140, 200), (290, 200)),
            ((310, 200), (425, 200)), ((495, 200), (620, 200)),
            ((620, 200), (620, 265)), ((620, 335), (620, 420)),
            ((140, 325), (140, 420)), ((140, 420), (620, 420)),
        ],
        "junctions": [(380, 420), (620, 200), (620, 420)],
    }
    ds13_meta = {
        "name": "13_bandpass_series_rlc",
        "title": "Second-Order Series RLC Bandpass Filter",
        "category": "Resonant & Bandpass Filters",
        "domain": "RF Tuning & Audio Frequency Selectivity",
        "description": "Series LC resonant tank with load resistor across output achieving maximum transmission at 1 kHz resonance with 314 Hz bandwidth.",
        "theory": {
            "resonance_frequency_hz": 1000.0,
            "quality_factor_Q": 3.18,
            "bandwidth_hz": 314.16,
            "center_gain_db": 0.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "2e-6"}
    }
    datasets.append((ds13_components, ds13_nets, ds13_draw, ds13_meta))

    # =========================================================================
    # 14. Series RLC Band-Stop (Notch) Filter
    # =========================================================================
    ds14_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="AC Source",
            parameters={"voltage": ParameterValue(value=15.0, unit="V", raw_text="15V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Input Limiting Resistor",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=320, y=170, w=80, h=40)
        ),
        Component(
            id="L1", type=ComponentType.INDUCTOR, name="Notch Inductor",
            parameters={"inductance": ParameterValue(value=0.01, unit="H", raw_text="10mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=540, y=220, w=40, h=60)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Notch Capacitor",
            parameters={"capacitance": ParameterValue(value=1.0e-6, unit="F", raw_text="1uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=540, y=320, w=40, h=60)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=380, y=420, w=60, h=40)
        ),
    ]
    ds14_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_OUT", connections=["R1.2", "L1.1"], confidence=1.0),
        Net(id="N_LC", connections=["L1.2", "C1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "C1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds14_draw = {
        "title": "Series RLC Band-Stop (Notch) Filter",
        "subtitle": "Null Attenuation Network (f_notch = 1591.55 Hz)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (140, 300), "val": "15V"},
            {"id": "R1", "type": "resistor_h", "pos": (340, 200), "val": "1.0k Ohm"},
            {"id": "L1", "type": "inductor_v", "pos": (540, 250), "val": "10 mH"},
            {"id": "C1", "type": "capacitor_v", "pos": (540, 350), "val": "1 uF"},
            {"id": "GND1", "type": "ground", "pos": (380, 440)},
        ],
        "wires": [
            ((140, 275), (140, 200)), ((140, 200), (305, 200)),
            ((375, 200), (540, 200)), ((540, 200), (540, 215)),
            ((540, 285), (540, 344)), ((540, 356), (540, 440)),
            ((140, 325), (140, 440)), ((140, 440), (540, 440)),
        ],
        "junctions": [(380, 440), (540, 200), (540, 440)],
    }
    ds14_meta = {
        "name": "14_bandstop_series_rlc",
        "title": "Series RLC Band-Stop (Notch) Filter",
        "category": "Interference Rejection",
        "domain": "Harmonic Suppression & Noise Traps",
        "description": "Shunt series LC branch shorts harmonic noise to ground at resonance creating a deep rejection notch.",
        "theory": {
            "resonance_frequency_hz": 1591.55,
            "notch_depth_db": -60.0,
            "series_branch_impedance_at_f0": "0 Ohms (Ideal)"
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "2e-6"}
    }
    datasets.append((ds14_components, ds14_nets, ds14_draw, ds14_meta))

    # =========================================================================
    # 15. Full-Wave Bridge Rectifier with Filter
    # =========================================================================
    ds15_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="AC Transformer Secondary",
            parameters={"voltage": ParameterValue(value=24.0, unit="V", raw_text="24V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="D1", type=ComponentType.DIODE, name="Bridge Diode Top-Left",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=240, y=180, w=60, h=40)
        ),
        Component(
            id="D2", type=ComponentType.DIODE, name="Bridge Diode Top-Right",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=380, y=180, w=60, h=40)
        ),
        Component(
            id="D3", type=ComponentType.DIODE, name="Bridge Diode Bottom-Left",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=240, y=340, w=60, h=40)
        ),
        Component(
            id="D4", type=ComponentType.DIODE, name="Bridge Diode Bottom-Right",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=380, y=340, w=60, h=40)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Bulk Smoothing Capacitor",
            parameters={"capacitance": ParameterValue(value=220.0e-6, unit="F", raw_text="220uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=520, y=260, w=40, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="DC Circuit Load",
            parameters={"resistance": ParameterValue(value=200.0, unit="ohm", raw_text="200R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=640, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="DC Return Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=520, y=420, w=60, h=40)
        ),
    ]
    ds15_nets = [
        Net(id="N_AC_P", connections=["V1.+", "D1.A", "D3.K"], confidence=1.0),
        Net(id="N_AC_N", connections=["V1.-", "D2.A", "D4.K"], confidence=1.0),
        Net(id="N_DC_POS", connections=["D1.K", "D2.K", "C1.1", "R1.1"], confidence=1.0),
        Net(id="GND", connections=["D3.A", "D4.A", "C1.2", "R1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds15_draw = {
        "title": "Full-Wave Diode Bridge Rectifier with Filter",
        "subtitle": "4-Diode Graetz Bridge AC-to-DC Converter (Vpeak = 22.6V)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 260), "val": "24V AC"},
            {"id": "D1", "type": "diode_h", "pos": (260, 200), "val": "1N4007"},
            {"id": "D2", "type": "diode_h", "pos": (400, 200), "val": "1N4007"},
            {"id": "D3", "type": "diode_h", "pos": (260, 320), "val": "1N4007"},
            {"id": "D4", "type": "diode_h", "pos": (400, 320), "val": "1N4007"},
            {"id": "C1", "type": "capacitor_v", "pos": (540, 260), "val": "220 uF"},
            {"id": "R1", "type": "resistor_v", "pos": (660, 260), "val": "200 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (540, 420)},
        ],
        "wires": [
            ((120, 235), (120, 160)), ((120, 160), (230, 160)), ((230, 160), (230, 200)),
            ((290, 200), (470, 200)), ((470, 200), (470, 160)), ((470, 160), (660, 160)),
            ((660, 160), (660, 225)), ((540, 160), (540, 254)),
            ((120, 285), (120, 360)), ((120, 360), (230, 360)), ((230, 360), (230, 320)),
            ((290, 320), (540, 320)), ((540, 266), (540, 420)), ((660, 295), (660, 420)),
            ((540, 420), (660, 420)),
        ],
        "junctions": [(540, 160), (540, 420), (660, 160), (660, 420)],
    }
    ds15_meta = {
        "name": "15_full_wave_bridge_rectifier",
        "title": "Full-Wave Diode Bridge Rectifier with Filter",
        "category": "Power Electronics & AC/DC Supplies",
        "domain": "Industrial Power Supply Conversion",
        "description": "Standard Graetz four-diode bridge converting bipolar AC excitation to unipolar DC with capacitor smoothing.",
        "theory": {
            "dc_peak_output_v": 22.6,
            "diode_voltage_drop_total_v": 1.4,
            "ripple_frequency_multiplier": "2x Input Frequency"
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.05, "max_step_size": "5e-6"}
    }
    datasets.append((ds15_components, ds15_nets, ds15_draw, ds15_meta))

    # =========================================================================
    # 16. Voltage Doubler (Greinacher Cascade)
    # =========================================================================
    ds16_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="AC Transformer Rail",
            parameters={"voltage": ParameterValue(value=12.0, unit="V", raw_text="12V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Pump Capacitor",
            parameters={"capacitance": ParameterValue(value=10.0e-6, unit="F", raw_text="10uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=240, y=170, w=80, h=40)
        ),
        Component(
            id="D1", type=ComponentType.DIODE, name="Clamp Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=380, y=260, w=40, h=80)
        ),
        Component(
            id="D2", type=ComponentType.DIODE, name="Rectifier Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=480, y=170, w=80, h=40)
        ),
        Component(
            id="C2", type=ComponentType.CAPACITOR, name="Reservoir Output Capacitor",
            parameters={"capacitance": ParameterValue(value=47.0e-6, unit="F", raw_text="47uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=620, y=260, w=40, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Output Bleed Load",
            parameters={"resistance": ParameterValue(value=10000.0, unit="ohm", raw_text="10k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=740, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=380, y=410, w=60, h=40)
        ),
    ]
    ds16_nets = [
        Net(id="N_IN", connections=["V1.+", "C1.1"], confidence=1.0),
        Net(id="N_PUMP", connections=["C1.2", "D1.K", "D2.A"], confidence=1.0),
        Net(id="N_OUT", connections=["D2.K", "C2.1", "R1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "D1.A", "C2.2", "R1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds16_draw = {
        "title": "Half-Wave Greinacher Voltage Doubler",
        "subtitle": "Charge-Pump DC Multiplier Circuit (Vout ~ 2x Vpeak = 22.6V)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "12V AC"},
            {"id": "C1", "type": "capacitor_h", "pos": (260, 190), "val": "10 uF"},
            {"id": "D1", "type": "diode_v_down", "pos": (380, 290), "val": "1N4007"},
            {"id": "D2", "type": "diode_h", "pos": (500, 190), "val": "1N4007"},
            {"id": "C2", "type": "capacitor_v", "pos": (620, 290), "val": "47 uF"},
            {"id": "R1", "type": "resistor_v", "pos": (740, 290), "val": "10k Ohm"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (250, 190)),
            ((270, 190), (380, 190)), ((380, 190), (485, 190)),
            ((380, 190), (380, 275)), ((380, 305), (380, 420)),
            ((515, 190), (620, 190)), ((620, 190), (740, 190)),
            ((620, 190), (620, 284)), ((620, 296), (620, 420)),
            ((740, 190), (740, 255)), ((740, 325), (740, 420)),
            ((120, 315), (120, 420)), ((120, 420), (740, 420)),
        ],
        "junctions": [(380, 190), (380, 420), (620, 190), (620, 420), (740, 420)],
    }
    ds16_meta = {
        "name": "16_voltage_doubler_greinacher",
        "title": "Half-Wave Greinacher Voltage Doubler",
        "category": "Power Multiplication & High Voltage",
        "domain": "HV Bias Generation & Ionizer Power",
        "description": "Diode-capacitor charge pump cascade clamping and peak-rectifying to deliver twice the peak AC supply voltage.",
        "theory": {
            "theoretical_max_output_v": 22.6,
            "multiplication_factor": 2.0,
            "dc_drop_per_diode_v": 0.7
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.05, "max_step_size": "5e-6"}
    }
    datasets.append((ds16_components, ds16_nets, ds16_draw, ds16_meta))

    # =========================================================================
    # 17. Precision Voltage Divider Attenuator
    # =========================================================================
    ds17_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Precision Reference Voltage",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Divider Upper Arm",
            parameters={"resistance": ParameterValue(value=9000.0, unit="ohm", raw_text="9k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=320, y=170, w=80, h=40)
        ),
        Component(
            id="R2", type=ComponentType.RESISTOR, name="Divider Lower Arm",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=520, y=260, w=40, h=80)
        ),
        Component(
            id="R3", type=ComponentType.RESISTOR, name="Instrumentation High-Z Load",
            parameters={"resistance": ParameterValue(value=100000.0, unit="ohm", raw_text="100k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=660, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=400, y=410, w=60, h=40)
        ),
    ]
    ds17_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_DIV", connections=["R1.2", "R2.1", "R3.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R2.2", "R3.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds17_draw = {
        "title": "Calibrated Precision Voltage Divider",
        "subtitle": "10:1 (20 dB) Voltage Ratio Scaling Network (Vout = 0.990 V)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (140, 290), "val": "10V"},
            {"id": "R1", "type": "resistor_h", "pos": (340, 190), "val": "9.0k Ohm"},
            {"id": "R2", "type": "resistor_v", "pos": (520, 290), "val": "1.0k Ohm"},
            {"id": "R3", "type": "resistor_v", "pos": (680, 290), "val": "100k Ohm"},
            {"id": "GND1", "type": "ground", "pos": (400, 420)},
        ],
        "wires": [
            ((140, 265), (140, 190)), ((140, 190), (305, 190)),
            ((375, 190), (520, 190)), ((520, 190), (680, 190)),
            ((520, 190), (520, 255)), ((520, 325), (520, 420)),
            ((680, 190), (680, 255)), ((680, 325), (680, 420)),
            ((140, 315), (140, 420)), ((140, 420), (680, 420)),
        ],
        "junctions": [(520, 190), (520, 420), (400, 420), (680, 420)],
    }
    ds17_meta = {
        "name": "17_voltage_divider_attenuator",
        "title": "Calibrated Precision Voltage Divider",
        "category": "Instrumentation & Scaling",
        "domain": "ADC Range Matching & Sensor Scaling",
        "description": "Standard 10:1 voltage divider network for level-shifting high voltage sensor inputs into micro-controller ADC ranges.",
        "theory": {
            "unloaded_ratio": 0.1,
            "nominal_attenuation_db": -20.0,
            "output_voltage_v": 0.9901,
            "output_impedance_ohms": 900.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "1e-5"}
    }
    datasets.append((ds17_components, ds17_nets, ds17_draw, ds17_meta))

    # =========================================================================
    # 18. Diode Shunt Voltage Regulator Stage
    # =========================================================================
    ds18_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Unregulated DC Supply",
            parameters={"voltage": ParameterValue(value=15.0, unit="V", raw_text="15V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Current Limiting Ballast",
            parameters={"resistance": ParameterValue(value=330.0, unit="ohm", raw_text="330R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=170, w=80, h=40)
        ),
        Component(
            id="D1", type=ComponentType.DIODE, name="Shunt Reference Clamp",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=520, y=260, w=40, h=80)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="Regulated Output Load",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=660, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=400, y=410, w=60, h=40)
        ),
    ]
    ds18_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_REG", connections=["R1.2", "D1.A", "R_LOAD.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "D1.K", "R_LOAD.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds18_draw = {
        "title": "Diode Shunt Voltage Regulator Stage",
        "subtitle": "Forward-Biased Diode Clamp Regulator (Vreg = 0.70 V)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (140, 290), "val": "15V DC"},
            {"id": "R1", "type": "resistor_h", "pos": (340, 190), "val": "330 Ohm"},
            {"id": "D1", "type": "diode_v_down", "pos": (520, 290), "val": "Vf = 0.7V"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (680, 290), "val": "1.0k Ohm"},
            {"id": "GND1", "type": "ground", "pos": (400, 420)},
        ],
        "wires": [
            ((140, 265), (140, 190)), ((140, 190), (305, 190)),
            ((375, 190), (520, 190)), ((520, 190), (680, 190)),
            ((520, 190), (520, 275)), ((520, 305), (520, 420)),
            ((680, 190), (680, 255)), ((680, 325), (680, 420)),
            ((140, 315), (140, 420)), ((140, 420), (680, 420)),
        ],
        "junctions": [(520, 190), (520, 420), (400, 420), (680, 420)],
    }
    ds18_meta = {
        "name": "18_zener_diode_voltage_regulator",
        "title": "Diode Shunt Voltage Regulator Stage",
        "category": "Voltage References & Regulators",
        "domain": "Bias Voltage Generation & Precision Clamping",
        "description": "Diode shunt regulator using the steep exponential I-V characteristic to maintain constant clamp voltage across supply ripple.",
        "theory": {
            "regulated_voltage_v": 0.7,
            "ballast_current_ma": 43.3,
            "load_current_ma": 0.7
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "5e-6"}
    }
    datasets.append((ds18_components, ds18_nets, ds18_draw, ds18_meta))

    # =========================================================================
    # 19. Fast Transient RC Differentiator
    # =========================================================================
    ds19_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Step Pulse Generator",
            parameters={"voltage": ParameterValue(value=5.0, unit="V", raw_text="5V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Differentiating Capacitor",
            parameters={"capacitance": ParameterValue(value=100.0e-12, unit="F", raw_text="100pF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=170, w=80, h=40)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Pulldown Shunt Resistor",
            parameters={"resistance": ParameterValue(value=100.0, unit="ohm", raw_text="100R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=550, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=340, y=410, w=60, h=40)
        ),
    ]
    ds19_nets = [
        Net(id="N_IN", connections=["V1.+", "C1.1"], confidence=1.0),
        Net(id="N_SPIKE", connections=["C1.2", "R1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds19_draw = {
        "title": "Fast Transient RC Differentiator",
        "subtitle": "Narrow Edge Detection & Pulse Trigger (tau = 10 ns)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (160, 300), "val": "5V Step"},
            {"id": "C1", "type": "capacitor_h", "pos": (380, 200), "val": "100 pF"},
            {"id": "R1", "type": "resistor_v", "pos": (600, 300), "val": "100 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((160, 275), (160, 200)), ((160, 200), (370, 200)),
            ((390, 200), (600, 200)), ((600, 200), (600, 265)),
            ((600, 335), (600, 420)), ((160, 325), (160, 420)),
            ((160, 420), (600, 420)),
        ],
        "junctions": [(380, 420), (600, 200), (600, 420)],
    }
    ds19_meta = {
        "name": "19_rc_differentiator",
        "title": "Fast Transient RC Differentiator",
        "category": "Waveform Shaping & Timing",
        "domain": "Digital Edge Detection & Radar Pulse Triggering",
        "description": "Short time-constant RC differentiator outputting sharp voltage spikes corresponding to input rate-of-change dv/dt.",
        "theory": {
            "time_constant_seconds": 1.0e-8,
            "differentiation_bandwidth_mhz": 15.91,
            "output_relation": "Vout(t) = R*C * (dVin / dt)"
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.0001, "max_step_size": "1e-8"}
    }
    datasets.append((ds19_components, ds19_nets, ds19_draw, ds19_meta))

    # =========================================================================
    # 20. Passive Long Time-Constant RC Integrator
    # =========================================================================
    ds20_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Step Input Source",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=120, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Integrating Series Resistor",
            parameters={"resistance": ParameterValue(value=100000.0, unit="ohm", raw_text="100k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=170, w=80, h=40)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Integrating Shunt Capacitor",
            parameters={"capacitance": ParameterValue(value=10.0e-6, unit="F", raw_text="10uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=550, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=340, y=410, w=60, h=40)
        ),
    ]
    ds20_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_INTEG", connections=["R1.2", "C1.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "C1.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds20_draw = {
        "title": "Passive Long Time-Constant RC Integrator",
        "subtitle": "Waveform Averaging & Ramp Generator (tau = 1.0 s)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (160, 300), "val": "10V Step"},
            {"id": "R1", "type": "resistor_h", "pos": (380, 200), "val": "100k Ohm"},
            {"id": "C1", "type": "capacitor_v", "pos": (600, 300), "val": "10 uF"},
            {"id": "GND1", "type": "ground", "pos": (380, 420)},
        ],
        "wires": [
            ((160, 275), (160, 200)), ((160, 200), (345, 200)),
            ((415, 200), (600, 200)), ((600, 200), (600, 294)),
            ((600, 306), (600, 420)), ((160, 325), (160, 420)),
            ((160, 420), (600, 420)),
        ],
        "junctions": [(380, 420), (600, 200), (600, 420)],
    }
    ds20_meta = {
        "name": "20_rc_integrator",
        "title": "Passive Long Time-Constant RC Integrator",
        "category": "Waveform Shaping & Analog Computation",
        "domain": "True RMS Sensing & Signal Smoothing",
        "description": "High-resistance large-capacitance network producing linear ramp approximations from square wave inputs.",
        "theory": {
            "time_constant_seconds": 1.0,
            "integration_linear_slope_v_per_s": 10.0,
            "output_relation": "Vout(t) = (1/RC) * integral(Vin dt)"
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.5, "max_step_size": "1e-4"}
    }
    datasets.append((ds20_components, ds20_nets, ds20_draw, ds20_meta))

    # =========================================================================
    # 21. Symmetrical 50-Ohm 6dB T-Pad Attenuator
    # =========================================================================
    ds21_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="RF Source 50 Ohm",
            parameters={"voltage": ParameterValue(value=5.0, unit="V", raw_text="5V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="T-Pad Input Arm",
            parameters={"resistance": ParameterValue(value=16.6, unit="ohm", raw_text="16.6R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="R2", type=ComponentType.RESISTOR, name="T-Pad Shunt Leg",
            parameters={"resistance": ParameterValue(value=66.9, unit="ohm", raw_text="66.9R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=420, y=260, w=40, h=80)
        ),
        Component(
            id="R3", type=ComponentType.RESISTOR, name="T-Pad Output Arm",
            parameters={"resistance": ParameterValue(value=16.6, unit="ohm", raw_text="16.6R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=560, y=170, w=80, h=40)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="Matched Characteristic Load",
            parameters={"resistance": ParameterValue(value=50.0, unit="ohm", raw_text="50R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=720, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="RF System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=410, w=60, h=40)
        ),
    ]
    ds21_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_CENTER", connections=["R1.2", "R2.1", "R3.1"], confidence=1.0),
        Net(id="N_OUT", connections=["R3.2", "R_LOAD.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R2.2", "R_LOAD.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds21_draw = {
        "title": "Symmetrical 50-Ohm 6dB T-Pad Attenuator",
        "subtitle": "Impedance-Matched RF Signal Pad (Z0 = 50 Ohm, Attenuation = 6 dB)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "5V RF"},
            {"id": "R1", "type": "resistor_h", "pos": (280, 190), "val": "16.6 Ohm"},
            {"id": "R2", "type": "resistor_v", "pos": (440, 290), "val": "66.9 Ohm"},
            {"id": "R3", "type": "resistor_h", "pos": (600, 190), "val": "16.6 Ohm"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (740, 290), "val": "50 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (245, 190)),
            ((315, 190), (440, 190)), ((440, 190), (565, 190)),
            ((440, 190), (440, 255)), ((440, 325), (440, 420)),
            ((635, 190), (740, 190)), ((740, 190), (740, 255)),
            ((740, 325), (740, 420)), ((120, 315), (120, 420)),
            ((120, 420), (740, 420)),
        ],
        "junctions": [(440, 190), (440, 420), (740, 420)],
    }
    ds21_meta = {
        "name": "21_t_attenuator_pad",
        "title": "Symmetrical 50-Ohm 6dB T-Pad Attenuator",
        "category": "RF & Transmission Lines",
        "domain": "Impedance Matching & Power Leveling",
        "description": "Standard T-configuration resistive network maintaining precise 50-ohm characteristic impedance with 6dB signal reduction.",
        "theory": {
            "attenuation_db": 6.0,
            "characteristic_impedance_ohms": 50.0,
            "voltage_transfer_ratio": 0.501
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "1e-5"}
    }
    datasets.append((ds21_components, ds21_nets, ds21_draw, ds21_meta))

    # =========================================================================
    # 22. Symmetrical 50-Ohm 10dB Pi-Pad Attenuator
    # =========================================================================
    ds22_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="RF Signal Source",
            parameters={"voltage": ParameterValue(value=5.0, unit="V", raw_text="5V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Input Shunt Resistor",
            parameters={"resistance": ParameterValue(value=96.2, unit="ohm", raw_text="96.2R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=260, w=40, h=80)
        ),
        Component(
            id="R2", type=ComponentType.RESISTOR, name="Series Bridge Resistor",
            parameters={"resistance": ParameterValue(value=71.2, unit="ohm", raw_text="71.2R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=420, y=170, w=80, h=40)
        ),
        Component(
            id="R3", type=ComponentType.RESISTOR, name="Output Shunt Resistor",
            parameters={"resistance": ParameterValue(value=96.2, unit="ohm", raw_text="96.2R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=580, y=260, w=40, h=80)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="RF 50-Ohm Term",
            parameters={"resistance": ParameterValue(value=50.0, unit="ohm", raw_text="50R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=720, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=410, w=60, h=40)
        ),
    ]
    ds22_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1", "R2.1"], confidence=1.0),
        Net(id="N_OUT", connections=["R2.2", "R3.1", "R_LOAD.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R1.2", "R3.2", "R_LOAD.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds22_draw = {
        "title": "Symmetrical 50-Ohm 10dB Pi-Pad Attenuator",
        "subtitle": "Pi-Topology Matched Attenuator (Z0 = 50 Ohm, Attenuation = 10 dB)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "5V RF"},
            {"id": "R1", "type": "resistor_v", "pos": (280, 290), "val": "96.2 Ohm"},
            {"id": "R2", "type": "resistor_h", "pos": (440, 190), "val": "71.2 Ohm"},
            {"id": "R3", "type": "resistor_v", "pos": (600, 290), "val": "96.2 Ohm"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (740, 290), "val": "50 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (280, 190)),
            ((280, 190), (405, 190)), ((280, 190), (280, 255)),
            ((280, 325), (280, 420)), ((475, 190), (600, 190)),
            ((600, 190), (740, 190)), ((600, 190), (600, 255)),
            ((600, 325), (600, 420)), ((740, 190), (740, 255)),
            ((740, 325), (740, 420)), ((120, 315), (120, 420)),
            ((120, 420), (740, 420)),
        ],
        "junctions": [(280, 190), (600, 190), (440, 420), (600, 420), (740, 420)],
    }
    ds22_meta = {
        "name": "22_pi_attenuator_pad",
        "title": "Symmetrical 50-Ohm 10dB Pi-Pad Attenuator",
        "category": "RF & Microwave Circuits",
        "domain": "Transceiver Protection & Signal Level Matching",
        "description": "Pi-topology attenuator with two shunt legs and one series bridging resistor providing 10dB power reduction.",
        "theory": {
            "attenuation_db": 10.0,
            "characteristic_impedance_ohms": 50.0,
            "voltage_transfer_ratio": 0.3162
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "1e-5"}
    }
    datasets.append((ds22_components, ds22_nets, ds22_draw, ds22_meta))

    # =========================================================================
    # 23. Control System Phase Lead-Lag Compensator
    # =========================================================================
    ds23_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Control Reference Input",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Lead Arm Resistor",
            parameters={"resistance": ParameterValue(value=10000.0, unit="ohm", raw_text="10k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=280, y=140, w=80, h=40)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Lead Speedup Capacitor",
            parameters={"capacitance": ParameterValue(value=100.0e-9, unit="F", raw_text="100nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=280, y=220, w=80, h=40)
        ),
        Component(
            id="R2", type=ComponentType.RESISTOR, name="Lag Arm Resistor",
            parameters={"resistance": ParameterValue(value=2200.0, unit="ohm", raw_text="2.2k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=500, y=240, w=40, h=60)
        ),
        Component(
            id="C2", type=ComponentType.CAPACITOR, name="Lag Shunt Capacitor",
            parameters={"capacitance": ParameterValue(value=470.0e-9, unit="F", raw_text="470nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=500, y=340, w=40, h=60)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=380, y=430, w=60, h=40)
        ),
    ]
    ds23_nets = [
        Net(id="N_IN", connections=["V1.+", "R1.1", "C1.1"], confidence=1.0),
        Net(id="N_MID", connections=["R1.2", "C1.2", "R2.1"], confidence=1.0),
        Net(id="N_LAG", connections=["R2.2", "C2.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "C2.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds23_draw = {
        "title": "Control System Phase Lead-Lag Compensator",
        "subtitle": "Dynamic Stability Enhancement Network (Phase Boost = +42 deg)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "10V Step"},
            {"id": "R1", "type": "resistor_h", "pos": (300, 160), "val": "10k Ohm"},
            {"id": "C1", "type": "capacitor_h", "pos": (300, 220), "val": "100 nF"},
            {"id": "R2", "type": "resistor_v", "pos": (500, 260), "val": "2.2k Ohm"},
            {"id": "C2", "type": "capacitor_v", "pos": (500, 360), "val": "470 nF"},
            {"id": "GND1", "type": "ground", "pos": (380, 440)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (220, 190)),
            ((220, 190), (220, 160)), ((220, 160), (265, 160)),
            ((220, 190), (220, 220)), ((220, 220), (290, 220)),
            ((335, 160), (380, 160)), ((310, 220), (380, 220)),
            ((380, 160), (380, 190)), ((380, 220), (380, 190)),
            ((380, 190), (500, 190)), ((500, 190), (500, 225)),
            ((500, 295), (500, 354)), ((500, 366), (500, 440)),
            ((120, 315), (120, 440)), ((120, 440), (500, 440)),
        ],
        "junctions": [(220, 190), (380, 190), (500, 190), (380, 440), (500, 440)],
    }
    ds23_meta = {
        "name": "23_lead_lag_compensator",
        "title": "Control System Phase Lead-Lag Compensator",
        "category": "Feedback & Control Systems",
        "domain": "Servomechanisms & Power Converter Feedback",
        "description": "Lead-lag compensation stage boosting phase margin at crossover while maintaining high DC loop gain.",
        "theory": {
            "lead_zero_hz": 159.15,
            "lag_pole_hz": 153.86,
            "maximum_phase_lead_deg": 42.5
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.05, "max_step_size": "5e-6"}
    }
    datasets.append((ds23_components, ds23_nets, ds23_draw, ds23_meta))

    # =========================================================================
    # 24. 3rd-Order LC Ladder Low-Pass Filter
    # =========================================================================
    ds24_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Signal Generator",
            parameters={"voltage": ParameterValue(value=10.0, unit="V", raw_text="10V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="L1", type=ComponentType.INDUCTOR, name="Stage 1 Series Choke",
            parameters={"inductance": ParameterValue(value=0.0022, unit="H", raw_text="2.2mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="C1", type=ComponentType.CAPACITOR, name="Center Shunt Resonator",
            parameters={"capacitance": ParameterValue(value=470.0e-9, unit="F", raw_text="470nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=420, y=260, w=40, h=80)
        ),
        Component(
            id="L2", type=ComponentType.INDUCTOR, name="Stage 2 Series Choke",
            parameters={"inductance": ParameterValue(value=0.0022, unit="H", raw_text="2.2mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=560, y=170, w=80, h=40)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="Terminating Load",
            parameters={"resistance": ParameterValue(value=100.0, unit="ohm", raw_text="100R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=720, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=410, w=60, h=40)
        ),
    ]
    ds24_nets = [
        Net(id="N_IN", connections=["V1.+", "L1.1"], confidence=1.0),
        Net(id="N_MID", connections=["L1.2", "C1.1", "L2.1"], confidence=1.0),
        Net(id="N_OUT", connections=["L2.2", "R_LOAD.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "C1.2", "R_LOAD.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds24_draw = {
        "title": "3rd-Order LC Ladder Low-Pass Filter",
        "subtitle": "Steep Roll-Off Low-Pass Filter (-60 dB/decade, fc = 4.95 kHz)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "10V AC"},
            {"id": "L1", "type": "inductor_h", "pos": (280, 190), "val": "2.2 mH"},
            {"id": "C1", "type": "capacitor_v", "pos": (440, 290), "val": "470 nF"},
            {"id": "L2", "type": "inductor_h", "pos": (600, 190), "val": "2.2 mH"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (740, 290), "val": "100 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (245, 190)),
            ((315, 190), (440, 190)), ((440, 190), (565, 190)),
            ((440, 190), (440, 284)), ((440, 296), (440, 420)),
            ((635, 190), (740, 190)), ((740, 190), (740, 255)),
            ((740, 325), (740, 420)), ((120, 315), (120, 420)),
            ((120, 420), (740, 420)),
        ],
        "junctions": [(440, 190), (440, 420), (740, 420)],
    }
    ds24_meta = {
        "name": "24_besselfilter_lc_lowpass",
        "title": "3rd-Order LC Ladder Low-Pass Filter",
        "category": "High-Order Passive Filters",
        "domain": "EMI Suppression & Telecommunication Channels",
        "description": "Three-pole L-C-L ladder filter achieving steep -60 dB/decade attenuation above the cutoff frequency.",
        "theory": {
            "order": 3,
            "cutoff_frequency_hz": 4954.0,
            "rolloff_rate_db_per_decade": -60.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "2e-6"}
    }
    datasets.append((ds24_components, ds24_nets, ds24_draw, ds24_meta))

    # =========================================================================
    # 25. Switching Converter RCD Voltage Clamp Snubber
    # =========================================================================
    ds25_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="DC Power Bus",
            parameters={"voltage": ParameterValue(value=48.0, unit="V", raw_text="48V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="L_LEAK", type=ComponentType.INDUCTOR, name="Transformer Leakage Inductance",
            parameters={"inductance": ParameterValue(value=1.0e-5, unit="H", raw_text="10uH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="D_SNUB", type=ComponentType.DIODE, name="Fast Snubber Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=420, y=170, w=80, h=40)
        ),
        Component(
            id="C_SNUB", type=ComponentType.CAPACITOR, name="Energy Storage Capacitor",
            parameters={"capacitance": ParameterValue(value=47.0e-9, unit="F", raw_text="47nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=580, y=260, w=40, h=80)
        ),
        Component(
            id="R_SNUB", type=ComponentType.RESISTOR, name="Dissipation Bleeder Resistor",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=700, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=410, w=60, h=40)
        ),
    ]
    ds25_nets = [
        Net(id="N_IN", connections=["V1.+", "L_LEAK.1"], confidence=1.0),
        Net(id="N_SWITCH", connections=["L_LEAK.2", "D_SNUB.A"], confidence=1.0),
        Net(id="N_CLAMP", connections=["D_SNUB.K", "C_SNUB.1", "R_SNUB.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "C_SNUB.2", "R_SNUB.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds25_draw = {
        "title": "Switching Converter RCD Voltage Clamp Snubber",
        "subtitle": "MOSFET Turn-Off Spike Dissipation Network (Clamping = 48V Bus)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "48V DC"},
            {"id": "L_LEAK", "type": "inductor_h", "pos": (280, 190), "val": "10 uH"},
            {"id": "D_SNUB", "type": "diode_h", "pos": (440, 190), "val": "UF4007"},
            {"id": "C_SNUB", "type": "capacitor_v", "pos": (600, 290), "val": "47 nF"},
            {"id": "R_SNUB", "type": "resistor_v", "pos": (720, 290), "val": "1.0k Ohm"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (245, 190)),
            ((315, 190), (425, 190)), ((455, 190), (600, 190)),
            ((600, 190), (720, 190)), ((600, 190), (600, 284)),
            ((600, 296), (600, 420)), ((720, 190), (720, 255)),
            ((720, 325), (720, 420)), ((120, 315), (120, 420)),
            ((120, 420), (720, 420)),
        ],
        "junctions": [(600, 190), (440, 420), (600, 420), (720, 420)],
    }
    ds25_meta = {
        "name": "25_boost_converter_snubber",
        "title": "Switching Converter RCD Voltage Clamp Snubber",
        "category": "Power Electronics Protection",
        "domain": "Flyback/Forward Switched-Mode Power Supplies",
        "description": "RCD snubber absorbs transformer leakage inductance energy during primary switch turn-off, bounding drain-source voltage.",
        "theory": {
            "leakage_energy_absorbed_uj": 11.5,
            "snubber_discharge_tau_us": 47.0,
            "clamping_voltage_target_v": 55.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.005, "max_step_size": "1e-6"}
    }
    datasets.append((ds25_components, ds25_nets, ds25_draw, ds25_meta))

    # =========================================================================
    # 26. Wideband RF Bias Tee Injector Network
    # =========================================================================
    ds26_components = [
        Component(
            id="V_RF", type=ComponentType.VOLTAGE_SOURCE, name="High-Frequency RF Carrier",
            parameters={"voltage": ParameterValue(value=1.0, unit="V", raw_text="1V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=170, w=60, h=80)
        ),
        Component(
            id="C_BLOCK", type=ComponentType.CAPACITOR, name="RF DC-Blocking Capacitor",
            parameters={"capacitance": ParameterValue(value=100.0e-9, unit="F", raw_text="100nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="V_DC", type=ComponentType.VOLTAGE_SOURCE, name="DC Bias Supply Rail",
            parameters={"voltage": ParameterValue(value=12.0, unit="V", raw_text="12V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=380, y=360, w=60, h=80)
        ),
        Component(
            id="L_RFC", type=ComponentType.INDUCTOR, name="RF Choke Inductor",
            parameters={"inductance": ParameterValue(value=0.0001, unit="H", raw_text="100uH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=420, y=260, w=40, h=80)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="Combined Active Load",
            parameters={"resistance": ParameterValue(value=50.0, unit="ohm", raw_text="50R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=600, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=260, y=440, w=60, h=40)
        ),
    ]
    ds26_nets = [
        Net(id="N_RF_IN", connections=["V_RF.+", "C_BLOCK.1"], confidence=1.0),
        Net(id="N_BIAS_COMBINED", connections=["C_BLOCK.2", "L_RFC.1", "R_LOAD.1"], confidence=1.0),
        Net(id="N_DC_FEED", connections=["V_DC.+", "L_RFC.2"], confidence=1.0),
        Net(id="GND", connections=["V_RF.-", "V_DC.-", "R_LOAD.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds26_draw = {
        "title": "Wideband RF Bias Tee Injector Network",
        "subtitle": "DC Power Injection for Active Antennas (Z0 = 50 Ohm, Vdc = 12V)",
        "components": [
            {"id": "V_RF", "type": "vsource", "pos": (120, 200), "val": "1V RF"},
            {"id": "C_BLOCK", "type": "capacitor_h", "pos": (280, 200), "val": "100 nF"},
            {"id": "L_RFC", "type": "inductor_v", "pos": (440, 290), "val": "100 uH"},
            {"id": "V_DC", "type": "vsource", "pos": (440, 380), "val": "12V DC"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (620, 290), "val": "50 Ohm"},
            {"id": "GND1", "type": "ground", "pos": (280, 440)},
        ],
        "wires": [
            ((120, 175), (120, 200)), ((120, 200), (270, 200)),
            ((290, 200), (440, 200)), ((440, 200), (620, 200)),
            ((440, 200), (440, 250)), ((440, 330), (440, 355)),
            ((440, 405), (440, 440)), ((620, 200), (620, 255)),
            ((620, 325), (620, 440)), ((120, 225), (120, 440)),
            ((120, 440), (620, 440)),
        ],
        "junctions": [(440, 200), (280, 440), (440, 440), (620, 440)],
    }
    ds26_meta = {
        "name": "26_dc_blocking_bias_tee",
        "title": "Wideband RF Bias Tee Injector Network",
        "category": "RF Components & Telemetry",
        "domain": "Active LNA Feeds & Remote Antennas",
        "description": "Combines DC power with RF signals on a single coaxial path without mutual interference or signal degradation.",
        "theory": {
            "rf_lower_cutoff_hz": 31830.0,
            "dc_isolation_from_rf_port_db": "> 60 dB",
            "dc_voltage_injected_v": 12.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "2e-6"}
    }
    datasets.append((ds26_components, ds26_nets, ds26_draw, ds26_meta))

    # =========================================================================
    # 27. Balanced Differential Anti-Aliasing ADC Filter
    # =========================================================================
    ds27_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Differential Sensor Signal",
            parameters={"voltage": ParameterValue(value=5.0, unit="V", raw_text="5V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="R1", type=ComponentType.RESISTOR, name="Positive Leg Series Resistor",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=280, y=170, w=80, h=40)
        ),
        Component(
            id="R2", type=ComponentType.RESISTOR, name="Negative Leg Series Resistor",
            parameters={"resistance": ParameterValue(value=1000.0, unit="ohm", raw_text="1k", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=280, y=350, w=80, h=40)
        ),
        Component(
            id="C_DIFF", type=ComponentType.CAPACITOR, name="Differential Filter Capacitor",
            parameters={"capacitance": ParameterValue(value=100.0e-9, unit="F", raw_text="100nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=460, y=260, w=40, h=80)
        ),
        Component(
            id="C_CM1", type=ComponentType.CAPACITOR, name="Common-Mode Positive Bypass",
            parameters={"capacitance": ParameterValue(value=10.0e-9, unit="F", raw_text="10nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=600, y=210, w=40, h=60)
        ),
        Component(
            id="C_CM2", type=ComponentType.CAPACITOR, name="Common-Mode Negative Bypass",
            parameters={"capacitance": ParameterValue(value=10.0e-9, unit="F", raw_text="10nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=600, y=310, w=40, h=60)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="Shield Reference Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=600, y=420, w=60, h=40)
        ),
    ]
    ds27_nets = [
        Net(id="N_SIG_P", connections=["V1.+", "R1.1"], confidence=1.0),
        Net(id="N_SIG_N", connections=["V1.-", "R2.1"], confidence=1.0),
        Net(id="N_ADC_P", connections=["R1.2", "C_DIFF.1", "C_CM1.1"], confidence=1.0),
        Net(id="N_ADC_N", connections=["R2.2", "C_DIFF.2", "C_CM2.1"], confidence=1.0),
        Net(id="GND", connections=["C_CM1.2", "C_CM2.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds27_draw = {
        "title": "Balanced Differential Anti-Aliasing ADC Filter",
        "subtitle": "Dual-Mode Differential Noise Filter (f_diff = 795.77 Hz, f_cm = 15.9 kHz)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 260), "val": "5V Diff"},
            {"id": "R1", "type": "resistor_h", "pos": (300, 180), "val": "1.0k Ohm"},
            {"id": "R2", "type": "resistor_h", "pos": (300, 340), "val": "1.0k Ohm"},
            {"id": "C_DIFF", "type": "capacitor_v", "pos": (480, 260), "val": "100 nF"},
            {"id": "C_CM1", "type": "capacitor_v", "pos": (620, 210), "val": "10 nF"},
            {"id": "C_CM2", "type": "capacitor_v", "pos": (620, 310), "val": "10 nF"},
            {"id": "GND1", "type": "ground", "pos": (620, 420)},
        ],
        "wires": [
            ((120, 235), (120, 180)), ((120, 180), (265, 180)),
            ((335, 180), (480, 180)), ((480, 180), (620, 180)),
            ((480, 180), (480, 254)), ((620, 180), (620, 204)),
            ((120, 285), (120, 340)), ((120, 340), (265, 340)),
            ((335, 340), (480, 340)), ((480, 340), (620, 340)),
            ((480, 266), (480, 340)), ((620, 340), (620, 316)),
            ((620, 216), (620, 304)), ((620, 316), (620, 420)),
        ],
        "junctions": [(480, 180), (620, 180), (480, 340), (620, 340), (620, 260)],
    }
    ds27_meta = {
        "name": "27_differential_rc_filter",
        "title": "Balanced Differential Anti-Aliasing ADC Filter",
        "category": "Precision Analog Front-End",
        "domain": "SAR / Sigma-Delta ADC Instrumentation",
        "description": "Symmetric balanced RC architecture filtering both differential mode and common mode noise prior to digitization.",
        "theory": {
            "differential_cutoff_frequency_hz": 795.77,
            "common_mode_cutoff_frequency_hz": 15915.5,
            "common_mode_attenuation_ratio": 10.0
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "5e-6"}
    }
    datasets.append((ds27_components, ds27_nets, ds27_draw, ds27_meta))

    # =========================================================================
    # 28. Solenoid / Relay Flyback Freewheeling Protection
    # =========================================================================
    ds28_components = [
        Component(
            id="V1", type=ComponentType.VOLTAGE_SOURCE, name="Relay Driver Supply",
            parameters={"voltage": ParameterValue(value=24.0, unit="V", raw_text="24V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="L_COIL", type=ComponentType.INDUCTOR, name="Actuator Coil Inductance",
            parameters={"inductance": ParameterValue(value=0.25, unit="H", raw_text="250mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=200, w=80, h=40)
        ),
        Component(
            id="R_COIL", type=ComponentType.RESISTOR, name="Coil Internal Resistance",
            parameters={"resistance": ParameterValue(value=48.0, unit="ohm", raw_text="48R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=340, y=280, w=80, h=40)
        ),
        Component(
            id="D_FLY", type=ComponentType.DIODE, name="Freewheel Clamping Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=520, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="System Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=340, y=410, w=60, h=40)
        ),
    ]
    ds28_nets = [
        Net(id="N_BUS", connections=["V1.+", "L_COIL.1", "D_FLY.K"], confidence=1.0),
        Net(id="N_INTERNAL", connections=["L_COIL.2", "R_COIL.1"], confidence=1.0),
        Net(id="GND", connections=["V1.-", "R_COIL.2", "D_FLY.A", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds28_draw = {
        "title": "Solenoid / Relay Flyback Freewheeling Protection",
        "subtitle": "Inductive Kick Suppression Circuit (Clamp = Vbus + 0.7V)",
        "components": [
            {"id": "V1", "type": "vsource", "pos": (120, 290), "val": "24V DC"},
            {"id": "L_COIL", "type": "inductor_v", "pos": (320, 220), "val": "250 mH"},
            {"id": "R_COIL", "type": "resistor_v", "pos": (320, 320), "val": "48 Ohm"},
            {"id": "D_FLY", "type": "diode_v_up", "pos": (500, 270), "val": "1N4007"},
            {"id": "GND1", "type": "ground", "pos": (320, 420)},
        ],
        "wires": [
            ((120, 265), (120, 160)), ((120, 160), (320, 160)),
            ((320, 160), (500, 160)), ((320, 160), (320, 180)),
            ((320, 260), (320, 285)), ((320, 355), (320, 420)),
            ((500, 160), (500, 255)), ((500, 285), (500, 420)),
            ((120, 315), (120, 420)), ((120, 420), (500, 420)),
        ],
        "junctions": [(320, 160), (500, 160), (320, 420), (500, 420)],
    }
    ds28_meta = {
        "name": "28_inductor_flyback_clamp",
        "title": "Solenoid / Relay Flyback Freewheeling Protection",
        "category": "Electromechanical Drivers",
        "domain": "Automotive Relays & Valve Actuators",
        "description": "Anti-parallel freewheeling diode absorbs back-EMF transients to safeguard driving transistors when inductive current is interrupted.",
        "theory": {
            "steady_state_current_a": 0.50,
            "stored_magnetic_energy_mj": 31.25,
            "discharge_time_constant_ms": 5.21
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.05, "max_step_size": "5e-6"}
    }
    datasets.append((ds28_components, ds28_nets, ds28_draw, ds28_meta))

    # =========================================================================
    # 29. Precision Current Sense Shunt with Noise Filter
    # =========================================================================
    ds29_components = [
        Component(
            id="V_BUS", type=ComponentType.VOLTAGE_SOURCE, name="Main DC Power Bus",
            parameters={"voltage": ParameterValue(value=24.0, unit="V", raw_text="24V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="R_SHUNT", type=ComponentType.RESISTOR, name="Kelvin Sense Resistor",
            parameters={"resistance": ParameterValue(value=0.05, unit="ohm", raw_text="0.05R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="R_LOAD", type=ComponentType.RESISTOR, name="System Work Load",
            parameters={"resistance": ParameterValue(value=12.0, unit="ohm", raw_text="12R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=420, y=260, w=40, h=80)
        ),
        Component(
            id="R_FILT", type=ComponentType.RESISTOR, name="Sense Lead Filter Resistor",
            parameters={"resistance": ParameterValue(value=100.0, unit="ohm", raw_text="100R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=560, y=170, w=80, h=40)
        ),
        Component(
            id="C_FILT", type=ComponentType.CAPACITOR, name="Sense Shunt Capacitor",
            parameters={"capacitance": ParameterValue(value=100.0e-9, unit="F", raw_text="100nF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=700, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="Power Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=410, w=60, h=40)
        ),
    ]
    ds29_nets = [
        Net(id="N_BUS", connections=["V_BUS.+", "R_SHUNT.1"], confidence=1.0),
        Net(id="N_LOAD", connections=["R_SHUNT.2", "R_LOAD.1", "R_FILT.1"], confidence=1.0),
        Net(id="N_SENSE", connections=["R_FILT.2", "C_FILT.1"], confidence=1.0),
        Net(id="GND", connections=["V_BUS.-", "R_LOAD.2", "C_FILT.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds29_draw = {
        "title": "Precision Current Sense Shunt with Noise Filter",
        "subtitle": "50 mOhm Kelvin Shunt with RC Decoupling (Vsense = 100 mV @ 2A)",
        "components": [
            {"id": "V_BUS", "type": "vsource", "pos": (120, 290), "val": "24V Bus"},
            {"id": "R_SHUNT", "type": "resistor_h", "pos": (280, 190), "val": "0.05 Ohm"},
            {"id": "R_LOAD", "type": "resistor_v", "pos": (440, 290), "val": "12.0 Ohm"},
            {"id": "R_FILT", "type": "resistor_h", "pos": (580, 190), "val": "100 Ohm"},
            {"id": "C_FILT", "type": "capacitor_v", "pos": (720, 290), "val": "100 nF"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 265), (120, 190)), ((120, 190), (245, 190)),
            ((315, 190), (440, 190)), ((440, 190), (545, 190)),
            ((440, 190), (440, 255)), ((440, 325), (440, 420)),
            ((615, 190), (720, 190)), ((720, 190), (720, 284)),
            ((720, 296), (720, 420)), ((120, 315), (120, 420)),
            ((120, 420), (720, 420)),
        ],
        "junctions": [(440, 190), (440, 420), (720, 420)],
    }
    ds29_meta = {
        "name": "29_current_sense_shunt_circuit",
        "title": "Precision Current Sense Shunt with Noise Filter",
        "category": "Current Sensing & Monitoring",
        "domain": "Battery Management & Motor Phase Current Telemetry",
        "description": "Low-resistance metal alloy shunt with integrated RC low-pass filter to reject inverter switching PWM noise.",
        "theory": {
            "nominal_current_a": 1.99,
            "sense_voltage_mv": 99.58,
            "filter_cutoff_frequency_khz": 15.91
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.01, "max_step_size": "2e-6"}
    }
    datasets.append((ds29_components, ds29_nets, ds29_draw, ds29_meta))

    # =========================================================================
    # 30. Dual-Diode Inductive Energy Return Snubber
    # =========================================================================
    ds30_components = [
        Component(
            id="V_DC", type=ComponentType.VOLTAGE_SOURCE, name="Inverter DC Rail Supply",
            parameters={"voltage": ParameterValue(value=50.0, unit="V", raw_text="50V", confidence=1.0)},
            pins=["+", "-"], confidence=1.0, bounding_box=BoundingBox(x=100, y=260, w=60, h=80)
        ),
        Component(
            id="L_MOTOR", type=ComponentType.INDUCTOR, name="Motor Winding Inductance",
            parameters={"inductance": ParameterValue(value=0.02, unit="H", raw_text="20mH", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=260, y=170, w=80, h=40)
        ),
        Component(
            id="D_UPPER", type=ComponentType.DIODE, name="Upper Rail Clamping Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=420, y=170, w=60, h=40)
        ),
        Component(
            id="D_LOWER", type=ComponentType.DIODE, name="Lower Rail Clamping Diode",
            parameters={"forward_voltage": ParameterValue(value=0.7, unit="V", raw_text="0.7V", confidence=1.0)},
            pins=["A", "K"], confidence=1.0, bounding_box=BoundingBox(x=420, y=340, w=60, h=40)
        ),
        Component(
            id="R_SNUB", type=ComponentType.RESISTOR, name="Damping Resistor",
            parameters={"resistance": ParameterValue(value=25.0, unit="ohm", raw_text="25R", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=560, y=260, w=40, h=80)
        ),
        Component(
            id="C_SNUB", type=ComponentType.CAPACITOR, name="Snubber Reservoir Capacitor",
            parameters={"capacitance": ParameterValue(value=2.2e-6, unit="F", raw_text="2.2uF", confidence=1.0)},
            pins=["1", "2"], confidence=1.0, bounding_box=BoundingBox(x=680, y=260, w=40, h=80)
        ),
        Component(
            id="GND1", type=ComponentType.GROUND, name="DC Negative Ground",
            parameters={}, pins=["1"], confidence=1.0, bounding_box=BoundingBox(x=420, y=420, w=60, h=40)
        ),
    ]
    ds30_nets = [
        Net(id="N_DC_POS", connections=["V_DC.+", "L_MOTOR.1", "D_UPPER.K"], confidence=1.0),
        Net(id="N_PHASE", connections=["L_MOTOR.2", "D_UPPER.A", "D_LOWER.K", "R_SNUB.1"], confidence=1.0),
        Net(id="N_RC", connections=["R_SNUB.2", "C_SNUB.1"], confidence=1.0),
        Net(id="GND", connections=["V_DC.-", "D_LOWER.A", "C_SNUB.2", "GND1.1"], confidence=1.0, is_ground=True),
    ]
    ds30_draw = {
        "title": "Dual-Diode Inductive Energy Return Snubber",
        "subtitle": "Inverter Phase-Leg Recovery Snubber (Vbus = 50V, L = 20 mH)",
        "components": [
            {"id": "V_DC", "type": "vsource", "pos": (120, 260), "val": "50V Bus"},
            {"id": "L_MOTOR", "type": "inductor_h", "pos": (280, 180), "val": "20 mH"},
            {"id": "D_UPPER", "type": "diode_v_up", "pos": (440, 210), "val": "BYV29"},
            {"id": "D_LOWER", "type": "diode_v_up", "pos": (440, 330), "val": "BYV29"},
            {"id": "R_SNUB", "type": "resistor_v", "pos": (580, 260), "val": "25 Ohm"},
            {"id": "C_SNUB", "type": "capacitor_v", "pos": (700, 260), "val": "2.2 uF"},
            {"id": "GND1", "type": "ground", "pos": (440, 420)},
        ],
        "wires": [
            ((120, 235), (120, 150)), ((120, 150), (245, 150)),
            ((245, 150), (245, 180)), ((315, 180), (440, 180)),
            ((440, 150), (440, 195)), ((120, 150), (440, 150)),
            ((440, 180), (580, 180)), ((440, 225), (440, 315)),
            ((440, 345), (440, 420)), ((580, 180), (580, 225)),
            ((580, 295), (700, 295)), ((700, 295), (700, 254)),
            ((700, 266), (700, 420)), ((120, 285), (120, 420)),
            ((120, 420), (700, 420)),
        ],
        "junctions": [(440, 150), (440, 180), (440, 270), (440, 420), (700, 420)],
    }
    ds30_meta = {
        "name": "30_active_snubber_freewheel",
        "title": "Dual-Diode Inductive Energy Return Snubber",
        "category": "Motor Drives & Inverter Protection",
        "domain": "BLDC/PMSM Phase Inverter Switching",
        "description": "Rail-clamped dual diode and RC network recovering stored reactive inductive energy while quenching dv/dt overshoot.",
        "theory": {
            "rail_voltage_v": 50.0,
            "snubber_time_constant_us": 55.0,
            "inductive_energy_joules": 0.025
        },
        "simulation_settings": {"solver": "ode23t", "stop_time": 0.02, "max_step_size": "2e-6"}
    }
    datasets.append((ds30_components, ds30_nets, ds30_draw, ds30_meta))

    return datasets


def generate_all_20():
    target_root = BASE_DIR / "datasets"
    target_root.mkdir(parents=True, exist_ok=True)

    datasets = get_additional_20_datasets()
    print(f"=== Generating {len(datasets)} Additional Datasets (DS-11 to DS-30) ===")

    # Load existing master index if available
    index_path = target_root / "index.json"
    master_index = []
    if index_path.exists():
        with open(index_path, "r", encoding="utf-8") as f:
            master_index = json.load(f)

    # Filter out any existing entries with same dataset_id
    existing_ids = {d.get("dataset_id") for d in master_index}

    new_runner_scripts = []

    for idx, (components, nets, draw_info, meta) in enumerate(datasets, start=11):
        ds_id = f"DS-{idx:02d}"
        folder_name = meta["name"]
        ds_dir = target_root / folder_name
        ds_dir.mkdir(parents=True, exist_ok=True)

        print(f"\n[{idx}/30] Processing {ds_id}: {meta['title']} -> {folder_name}")

        # 1. Universal Circuit IR
        circuit_ir = UniversalCircuitIR(
            schema_version="0.1",
            circuit_name=meta["title"],
            description=meta["description"],
            components=components,
            nets=nets,
            metadata={
                "dataset_id": ds_id,
                "domain": meta["domain"],
                "category": meta["category"],
                "simulation_settings": meta["simulation_settings"],
            }
        )

        # 2. Validation
        val_report = CircuitValidator.validate(circuit_ir)
        print(f"  Validation: status={val_report.status}, errors={len(val_report.errors)}, warnings={len(val_report.warnings)}")

        # 3. Schematic Image
        img = draw_schematic_canvas(
            title=draw_info["title"],
            subtitle=draw_info["subtitle"],
            components_info=draw_info["components"],
            wires_info=draw_info["wires"],
            junctions=draw_info["junctions"],
        )
        img_path = ds_dir / "schematic.png"
        cv2.imwrite(str(img_path), img)

        # 4. Save circuit_ir.json
        ir_path = ds_dir / "circuit_ir.json"
        with open(ir_path, "w", encoding="utf-8") as f:
            json.dump(circuit_ir.dict(), f, indent=2)

        # 5. Generate MATLAB script
        model_name = f"model_{folder_name}"
        slx_path = ds_dir / f"{model_name}.slx"
        m_path = ds_dir / "generate_model.m"
        script_code = MatlabSimscapeCompiler.generate_matlab_script(circuit_ir, model_name, slx_path)
        with open(m_path, "w", encoding="utf-8") as f:
            f.write(script_code)

        # 6. Metadata JSON
        meta_full = {
            "dataset_id": ds_id,
            "directory": folder_name,
            "name": folder_name,
            "title": meta["title"],
            "category": meta["category"],
            "domain": meta["domain"],
            "description": meta["description"],
            "theory": meta["theory"],
            "simulation_settings": meta["simulation_settings"],
            "components_count": len(components),
            "nets_count": len(nets),
            "files": {
                "schematic": "schematic.png",
                "circuit_ir": "circuit_ir.json",
                "matlab_script": "generate_model.m",
                "simulink_model": f"{model_name}.slx",
                "metadata": "metadata.json"
            },
            "validation_report": val_report.dict(),
        }
        with open(ds_dir / "metadata.json", "w", encoding="utf-8") as f:
            json.dump(meta_full, f, indent=2)

        # Update master index
        if ds_id in existing_ids:
            for i, d in enumerate(master_index):
                if d.get("dataset_id") == ds_id:
                    master_index[i] = meta_full
        else:
            master_index.append(meta_full)
            existing_ids.add(ds_id)

        new_runner_scripts.append((model_name, m_path, slx_path))

    # Sort master_index by dataset_id
    master_index.sort(key=lambda x: x.get("dataset_id", ""))

    with open(target_root / "index.json", "w", encoding="utf-8") as f:
        json.dump(master_index, f, indent=2)
    print(f"\nSuccessfully wrote master index.json with {len(master_index)} total datasets.")

    return new_runner_scripts, master_index


if __name__ == "__main__":
    generate_all_20()
