# Circuit2Sim Synthetic Datasets Suite (30 Industrial Benchmark Circuits)

This directory contains **30 verified synthetic datasets** designed for automated circuit schematic ingestion, Universal Circuit Intermediate Representation (IR) validation, and **Simulink/Simscape Electrical (`.slx`) physical model compilation**.

Every dataset folder contains:
1. **Schematic Diagram (`schematic.png`)**: High-contrast, clean 1000x650 pixel engineering circuit schematic with standard IEEE/ANSI electronic symbols, colored conductors, junction dots, terminal identifiers, and technical title block.
2. **Circuit IR (`circuit_ir.json`)**: Machine-readable Universal Circuit Intermediate Representation specifying components, nodes/nets, bounding boxes, pin connectivity, and electrical parameters.
3. **MATLAB Generation Script (`generate_model.m`)**: Standalone, human-readable programmatic Simscape compiler script configuring solver (`ode23t`), physical blocks, conserving ports, and autorouting lines.
4. **Compiled Simulink/Simscape Model (`model_<name>.slx`)**: Authentic, native binary Simulink/Simscape model compiled and verified directly by MATLAB Simscape Electrical.
5. **Metadata & Specification (`metadata.json`)**: Engineering specifications, theoretical transfer function equations, tolerances, ratings, and validation reports.

---

## Complete Dataset Overview & Verification Matrix (30 Models)

| ID | Dataset Directory | Circuit Title | Category / Domain | Comps | Nets | Verification (`.slx`) |
|:---|:---|:---|:---|:---:|:---:|:---:|
| **DS-01** | `01_rc_lowpass_filter` | 1st-Order RC Low-Pass Filter | Analog Signal Conditioning | 4 | 3 | **PASS (100% Solved)** |
| **DS-02** | `02_rl_transient_circuit` | Series RL Transient Circuit | Motor Drive / Inrush Dynamics | 4 | 3 | **PASS (100% Solved)** |
| **DS-03** | `03_series_rlc_snubber` | Series RLC Resonant Snubber | Power Switching Spike Damper | 5 | 4 | **PASS (100% Solved)** |
| **DS-04** | `04_wheatstone_bridge` | Precision Wheatstone Bridge | Strain Gauge / Sensor Instrumentation | 7 | 5 | **PASS (100% Solved)** |
| **DS-05** | `05_twin_t_notch_filter` | Twin-T Notch Reject Filter | 50/60 Hz Mains Interference Rejection | 9 | 7 | **PASS (100% Solved)** |
| **DS-06** | `06_half_wave_rectifier` | Half-Wave Power Rectifier with Filter | Power Conversion / AC-to-DC | 5 | 4 | **PASS (100% Solved)** |
| **DS-07** | `07_diode_clipper_limiter` | Symmetrical Diode Amplitude Clipper | Input Overvoltage & Signal Limiting | 6 | 4 | **PASS (100% Solved)** |
| **DS-08** | `08_pi_clc_power_filter` | Pi (CLC) Ripple Suppression Filter | Switch-Mode Power Supply Output Stage | 6 | 4 | **PASS (100% Solved)** |
| **DS-09** | `09_parallel_resonant_tank` | Parallel LC Tank Resonator | RF Carrier Selection / Bandpass Filter | 5 | 3 | **PASS (100% Solved)** |
| **DS-10** | `10_cascaded_rc_filter` | 2nd-Order Cascaded RC Filter | Higher-Order Analog Roll-off (-40dB/dec) | 7 | 5 | **PASS (100% Solved)** |
| **DS-11** | `11_highpass_rc_filter` | First-Order RC High-Pass Filter | Audio & Signal Conditioning / AC Coupling | 4 | 3 | **PASS (100% Solved)** |
| **DS-12** | `12_rl_highpass_filter` | First-Order RL High-Pass Filter | Passive RF & Power Telemetry | 4 | 3 | **PASS (100% Solved)** |
| **DS-13** | `13_bandpass_series_rlc` | Second-Order Series RLC Bandpass | Resonant Tuning & Bandpass Filtering | 5 | 4 | **PASS (100% Solved)** |
| **DS-14** | `14_bandstop_series_rlc` | Series RLC Band-Stop (Notch) Filter | Interference Rejection / Harmonic Trap | 5 | 4 | **PASS (100% Solved)** |
| **DS-15** | `15_full_wave_bridge_rectifier`| Full-Wave Diode Bridge Rectifier | Power Electronics & AC/DC Supplies | 8 | 4 | **PASS (100% Solved)** |
| **DS-16** | `16_voltage_doubler_greinacher`| Half-Wave Greinacher Voltage Doubler | Charge-Pump Multiplier & HV Bias | 7 | 4 | **PASS (100% Solved)** |
| **DS-17** | `17_voltage_divider_attenuator`| Calibrated Precision Voltage Divider | ADC Scaling & Level Shifting | 5 | 3 | **PASS (100% Solved)** |
| **DS-18** | `18_zener_diode_voltage_regulator`| Diode Shunt Voltage Regulator Stage | Voltage References & Bias Clamping | 5 | 3 | **PASS (100% Solved)** |
| **DS-19** | `19_rc_differentiator` | Fast Transient RC Differentiator | Waveform Shaping & Fast Pulse Triggering | 4 | 3 | **PASS (100% Solved)** |
| **DS-20** | `20_rc_integrator` | Passive Long Time-Constant RC Integrator | True RMS Sensing & Ramp Generation | 4 | 3 | **PASS (100% Solved)** |
| **DS-21** | `21_t_attenuator_pad` | Symmetrical 50-Ohm 6dB T-Pad | RF Transmission Lines & Level Matching | 6 | 4 | **PASS (100% Solved)** |
| **DS-22** | `22_pi_attenuator_pad` | Symmetrical 50-Ohm 10dB Pi-Pad | Transceiver RF Pad & Match | 6 | 3 | **PASS (100% Solved)** |
| **DS-23** | `23_lead_lag_compensator` | Control Phase Lead-Lag Compensator | Servomechanisms & Power Converter Loops | 6 | 4 | **PASS (100% Solved)** |
| **DS-24** | `24_besselfilter_lc_lowpass` | 3rd-Order LC Ladder Low-Pass Filter | Steep Roll-off (-60 dB/dec) Filter | 6 | 4 | **PASS (100% Solved)** |
| **DS-25** | `25_boost_converter_snubber` | Converter RCD Voltage Clamp Snubber | Flyback / Forward Switch Protection | 6 | 4 | **PASS (100% Solved)** |
| **DS-26** | `26_dc_blocking_bias_tee` | Wideband RF Bias Tee Injector Network | Active Antenna & LNA Power Feeds | 6 | 4 | **PASS (100% Solved)** |
| **DS-27** | `27_differential_rc_filter` | Balanced Differential ADC Filter | Differential & Common-Mode Noise Filter | 7 | 5 | **PASS (100% Solved)** |
| **DS-28** | `28_inductor_flyback_clamp` | Solenoid / Relay Flyback Protection | Inductive Kick Suppression & Freewheel | 5 | 3 | **PASS (100% Solved)** |
| **DS-29** | `29_current_sense_shunt_circuit`| Precision Current Sense Shunt Network | Kelvin Shunt & Motor Current Telemetry | 6 | 4 | **PASS (100% Solved)** |
| **DS-30** | `30_active_snubber_freewheel`| Dual-Diode Inductive Energy Return Snubber| BLDC/PMSM Inverter Phase-Leg Recovery | 7 | 4 | **PASS (100% Solved)** |

---

## Batch Compilation & Validation Instructions

To regenerate or verify all 30 `.slx` models in MATLAB:

```matlab
% In MATLAB command window:
cd('F:/KONE FINALS/datasets');
compile_all_models;
```
