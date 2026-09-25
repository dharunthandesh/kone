"""Test Suite for Circuit2Sim Subsystems."""

import unittest
from circuit2sim.backend.app.compiler.matlab_simscape import MatlabBlockMapping, MatlabSimscapeCompiler
from circuit2sim.backend.app.validation.circuit_validator import CircuitValidator
from circuit2sim.backend.app.vision.detector import ElectronicsNotationParser
from circuit2sim.models.circuit_ir.circuit import (
    Component,
    ComponentType,
    Net,
    ParameterValue,
    UniversalCircuitIR,
    ValidationStatus,
)


class TestCircuit2Sim(unittest.TestCase):

    def test_electronics_notation_parser(self):
        # Resistance
        r1 = ElectronicsNotationParser.parse_resistance("10k")
        self.assertEqual(r1.value, 10000.0)
        self.assertEqual(r1.unit, "ohm")
        self.assertFalse(r1.uncertain)

        r2 = ElectronicsNotationParser.parse_resistance("4k7")
        self.assertEqual(r2.value, 4700.0)

        # Capacitance
        c1 = ElectronicsNotationParser.parse_capacitance("100nF")
        self.assertAlmostEqual(c1.value, 1e-7)
        self.assertEqual(c1.unit, "F")

        c2 = ElectronicsNotationParser.parse_capacitance("4.7uF")
        self.assertAlmostEqual(c2.value, 4.7e-6)

        # Inductance
        l1 = ElectronicsNotationParser.parse_inductance("10mH")
        self.assertAlmostEqual(l1.value, 0.01)

        # Voltage
        v1 = ElectronicsNotationParser.parse_voltage("12V")
        self.assertEqual(v1.value, 12.0)

    def test_circuit_validator_ground_check(self):
        # Circuit without ground
        ir_no_gnd = UniversalCircuitIR(
            components=[
                Component(id="R1", type=ComponentType.RESISTOR, parameters={"resistance": ParameterValue(value=1000, unit="ohm")}, pins=["1", "2"]),
                Component(id="V1", type=ComponentType.VOLTAGE_SOURCE, parameters={"voltage": ParameterValue(value=5, unit="V")}, pins=["+", "-"]),
            ],
            nets=[
                Net(id="N1", connections=["V1.+", "R1.1"]),
                Net(id="N2", connections=["V1.-", "R1.2"]),
            ]
        )
        report = CircuitValidator.validate(ir_no_gnd)
        self.assertFalse(report.has_ground_reference)
        self.assertTrue(any("Ground" in w for w in report.warnings))

        # Add ground
        ir_with_gnd = UniversalCircuitIR(
            components=[
                Component(id="R1", type=ComponentType.RESISTOR, parameters={"resistance": ParameterValue(value=1000, unit="ohm")}, pins=["1", "2"]),
                Component(id="V1", type=ComponentType.VOLTAGE_SOURCE, parameters={"voltage": ParameterValue(value=5, unit="V")}, pins=["+", "-"]),
                Component(id="GND1", type=ComponentType.GROUND, pins=["1"]),
            ],
            nets=[
                Net(id="N1", connections=["V1.+", "R1.1"]),
                Net(id="GND", connections=["V1.-", "R1.2", "GND1.1"], is_ground=True),
            ]
        )
        report_ok = CircuitValidator.validate(ir_with_gnd)
        self.assertTrue(report_ok.has_ground_reference)
        self.assertTrue(report_ok.ready_for_compilation)

    def test_matlab_script_generation(self):
        ir = UniversalCircuitIR(
            components=[
                Component(id="V1", type=ComponentType.VOLTAGE_SOURCE, parameters={"voltage": ParameterValue(value=12.0, unit="V")}, pins=["+", "-"]),
                Component(id="R1", type=ComponentType.RESISTOR, parameters={"resistance": ParameterValue(value=10000.0, unit="ohm")}, pins=["1", "2"]),
                Component(id="C1", type=ComponentType.CAPACITOR, parameters={"capacitance": ParameterValue(value=1e-7, unit="F")}, pins=["1", "2"]),
                Component(id="GND1", type=ComponentType.GROUND, pins=["1"]),
            ],
            nets=[
                Net(id="N1", connections=["V1.+", "R1.1"]),
                Net(id="N2", connections=["R1.2", "C1.1"]),
                Net(id="GND", connections=["V1.-", "C1.2", "GND1.1"], is_ground=True),
            ]
        )
        from pathlib import Path
        m_script = MatlabSimscapeCompiler.generate_matlab_script(ir, "test_rc_circuit", Path("test.slx"))
        self.assertIn("fl_lib/Electrical/Electrical Elements/Resistor", m_script)
        self.assertIn("fl_lib/Electrical/Electrical Elements/Capacitor", m_script)
        self.assertIn("fl_lib/Electrical/Electrical Sources/DC Voltage Source", m_script)
        self.assertIn("nesl_utility/Solver Configuration", m_script)
        self.assertIn("save_system('test_rc_circuit'", m_script)


if __name__ == "__main__":
    unittest.main()
