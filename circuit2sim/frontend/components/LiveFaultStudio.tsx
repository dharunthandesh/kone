"use client";

import React, { useState, useEffect, useMemo } from "react";
import {
  Play,
  RotateCcw,
  Zap,
  Flame,
  CheckCircle2,
  AlertTriangle,
  Layers,
  Activity,
  Cpu,
} from "lucide-react";
import { Component, UniversalCircuitIR } from "../types/circuit";

interface LiveFaultStudioProps {
  projectId: string;
  circuitIr?: UniversalCircuitIR;
  onRefresh?: () => void;
}

interface CircuitBlock {
  id: string;
  type: string;
  label: string;
  sublabel: string;
  x: number;
  y: number;
  w: number;
  h: number;
  shape?: "rect" | "diamond" | "round" | "triangle";
  category: "input" | "rectifier" | "converter" | "filter" | "control" | "sensor";
  nominalVoltage: string;
  nominalCurrent: string;
  description: string;
  faultModes: Array<{
    id: string;
    label: string;
    type: string;
    impact: string;
    action: string;
    finalState: string;
    dcBusV: number;
    currentA: number;
    gateV: number;
  }>;
}

interface SimRunRecord {
  id: string;
  timestamp: string;
  componentId: string;
  faultName: string;
  status: "NORMAL" | "ARMED" | "FAULT_ACTIVE";
  finalState: string;
  protectionAction: string;
  dcBusBefore: string;
  dcBusAfter: string;
  currentPeak: string;
  timelineLogs: string[];
}

export const LiveFaultStudio: React.FC<LiveFaultStudioProps> = ({
  projectId,
  circuitIr,
  onRefresh,
}) => {
  // Mode toggle: Uploaded Circuit vs BCX14 Elevator Power Supply Benchmark
  const hasUploadedCircuit = Boolean(circuitIr?.components && circuitIr.components.length > 0);
  const [circuitMode, setCircuitMode] = useState<"UPLOADED" | "BCX14_BENCHMARK">(
    hasUploadedCircuit ? "UPLOADED" : "BCX14_BENCHMARK"
  );

  // Automatically sync mode when a new circuit is loaded
  useEffect(() => {
    if (circuitIr?.components && circuitIr.components.length > 0) {
      setCircuitMode("UPLOADED");
    }
  }, [circuitIr]);

  // -------------------------------------------------------------
  // A. PRESET BCX14 BENCHMARK BLOCKS (Elevator High-Voltage Power Stage)
  // -------------------------------------------------------------
  const bcx14Blocks: CircuitBlock[] = useMemo(
    () => [
      {
        id: "XB11",
        type: "230V AC Elevator Mains Feed",
        label: "XB11",
        sublabel: "230V AC",
        x: 6,
        y: 40,
        w: 8,
        h: 22,
        shape: "rect",
        category: "input",
        nominalVoltage: "230V RMS (325.3Vpk)",
        nominalCurrent: "2.5A RMS",
        description: "230V RMS (325.3 Vpk) 50Hz Single-Phase Elevator Mains Power Input Connector. Feeds Lift Brake Supply.",
        faultModes: [
          {
            id: "FLT-XB11-SURGE",
            label: "Mains Overvoltage Surge (375Vpk)",
            type: "OVERVOLTAGE_SURGE",
            impact: "Mains voltage surges +50V above nominal. RV3 MOV engages clamping to protect 230V brake coil.",
            action: "MOV RV3 CLAMP ACTIVE -> SURGE SUPPRESSED",
            finalState: "SURGE CLAMPED (PROTECTED)",
            dcBusV: 245.0,
            currentA: 2.2,
            gateV: 230.0,
          },
          {
            id: "FLT-XB11-LOSS",
            label: "Elevator Mains Power Cutout (0V)",
            type: "POWER_LOSS",
            impact: "AC mains drops to 0V. 230V brake coil de-energizes immediately. Mechanical springs drop brake shoes.",
            action: "SAFETY BRAKE DROP -> MECHANICAL SPRING CLAMP (EN 81-20)",
            finalState: "SAFE ELEVATOR ARREST (CAR LOCKED)",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
          {
            id: "FLT-XB11-SAG",
            label: "Brownout Sag -50% (115V RMS)",
            type: "VOLTAGE_SAG",
            impact: "Input line drops to 115V RMS. Insufficient voltage to pick elevator brake.",
            action: "UNDERVOLTAGE TRIP -> PREVENT CAR DISPATCH",
            finalState: "HELD AT LANDING FLOOR",
            dcBusV: 115.0,
            currentA: 0.95,
            gateV: 115.0,
          },
        ],
      },
      {
        id: "D2",
        type: "Full-Wave Brake Rectifier Bridge",
        label: "D2",
        sublabel: "325Vpk REC",
        x: 17,
        y: 38,
        w: 8,
        h: 26,
        shape: "diamond",
        category: "rectifier",
        nominalVoltage: "325.3V Peak Rectified",
        nominalCurrent: "2.5A Avg",
        description: "High-voltage single-phase full bridge diode rectifier (GBU808 / Vishay) converting 230V AC to DC for lift brake.",
        faultModes: [
          {
            id: "FLT-D2-SHORT",
            label: "Diode Bridge Short Circuit",
            type: "SHORT_CIRCUIT",
            impact: "Catastrophic reverse shoot-through current. Upstream mains circuit breaker trips.",
            action: "AC MAINS BREAKER TRIP -> EMERGENCY BRAKE DROP",
            finalState: "SAFE EMERGENCY STOP",
            dcBusV: 0.0,
            currentA: 38.0,
            gateV: 0.0,
          },
          {
            id: "FLT-D2-OPEN",
            label: "Diode Arm Open Circuit (Half-Wave)",
            type: "OPEN_CIRCUIT",
            impact: "Rectifier drops one half-cycle. Excessive 100Hz ripple on 230V brake rail.",
            action: "RIPPLE DETECTED -> DISPATCH WARNING",
            finalState: "DEGRADED BRAKE BUS",
            dcBusV: 180.0,
            currentA: 0.7,
            gateV: 115.0,
          },
        ],
      },
      {
        id: "R122",
        type: "Soft-Start Inrush Resistor Stage",
        label: "R122 | R51",
        sublabel: "47Ω INRUSH",
        x: 28,
        y: 28,
        w: 9,
        h: 18,
        shape: "rect",
        category: "converter",
        nominalVoltage: "325V Peak Transient",
        nominalCurrent: "7A Peak Inrush",
        description: "Ceramic power resistors (2x 47Ω in parallel) limiting initial capacitor bank charging inrush.",
        faultModes: [
          {
            id: "FLT-R122-OPEN",
            label: "Inrush Resistor Burned Open",
            type: "OPEN_CIRCUIT",
            impact: "Brake DC link fails to precharge. Relay bypass cannot engage.",
            action: "PRECHARGE TIMEOUT -> DRIVE START ABORTED",
            finalState: "CAR HELD STATIONARY",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "Q14",
        type: "Precharge Bypass Relay",
        label: "Q14",
        sublabel: "BYPASS",
        x: 28,
        y: 52,
        w: 9,
        h: 18,
        shape: "rect",
        category: "converter",
        nominalVoltage: "0.1V Contact Drop",
        nominalCurrent: "2.5A Continuous",
        description: "Heavy-duty relay bypassing inrush resistors once 230V brake DC bus stabilizes.",
        faultModes: [
          {
            id: "FLT-Q14-STUCK_OPEN",
            label: "Bypass Relay Stuck Open",
            type: "CONTACT_FAIL",
            impact: "Continuous brake current forced through R122 inrush resistors, risking thermal burnout.",
            action: "THERMAL PROTECTION ENGAGED -> LIFT PARKING",
            finalState: "CONTROLLED STOP AT NEXT FLOOR",
            dcBusV: 200.0,
            currentA: 1.2,
            gateV: 115.0,
          },
        ],
      },
      {
        id: "L13",
        type: "230V Hoist Machine Brake Solenoid Coil",
        label: "L_BRAKE",
        sublabel: "230V COIL",
        x: 41,
        y: 39,
        w: 8,
        h: 24,
        shape: "round",
        category: "converter",
        nominalVoltage: "230V Pick / 115V Hold",
        nominalCurrent: "1.9A Pick / 0.95A Hold",
        description: "KONE MX06/MX10 Elevator Hoisting Machine Dual Disc Brake Solenoid (2.5H, 120Ω DCR). Energized to 230V to release mechanical brake shoes.",
        faultModes: [
          {
            id: "FLT-L13-SHORT",
            label: "Brake Coil Turn-to-Turn Short Circuit",
            type: "SHORT_CIRCUIT",
            impact: "Solenoid coil impedance collapses. Destructive current spike. Controller cuts excitation.",
            action: "OVERCURRENT TRIP -> IMMEDIATE MECHANICAL BRAKE DROP",
            finalState: "FAIL-SAFE SPRING BRAKE APPLIED (EN 81-20)",
            dcBusV: 0.0,
            currentA: 28.5,
            gateV: 0.0,
          },
          {
            id: "FLT-L13-OPEN",
            label: "Brake Solenoid Coil Burnout Open",
            type: "OPEN_CIRCUIT",
            impact: "Brake coil loses excitation completely. Heavy mechanical springs immediately clamp sheave.",
            action: "SAFETY INTERLOCK ENGAGED -> HOIST MACHINE ARRESTED",
            finalState: "CAR HELD SAFE STATIONARY",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "Q23",
        type: "Brake Pick & Hold IGBT Chopper Switch",
        label: "Q_CHOPPER",
        sublabel: "IGBT 230V",
        x: 52,
        y: 44,
        w: 7,
        h: 26,
        shape: "rect",
        category: "converter",
        nominalVoltage: "650V Rated",
        nominalCurrent: "1.9A Pick / 20A Peak",
        description: "650V Field-Stop IGBT executing 100% duty cycle (230V) during Brake Pick, stepping down to 50% PWM (115V) during Brake Hold.",
        faultModes: [
          {
            id: "FLT-Q23-SHORT",
            label: "Brake Chopper Collector-Emitter Short",
            type: "SHORT_CIRCUIT",
            impact: "Brake coil permanently energized at 230V without hold-mode reduction. Risk of solenoid thermal damage.",
            action: "COIL THERMAL OVERLOAD ALARM -> TRIP DRIVE",
            finalState: "OVERHEATED SHUTDOWN (SAFE BRAKE DROP)",
            dcBusV: 230.0,
            currentA: 1.9,
            gateV: 0.0,
          },
          {
            id: "FLT-Q23-GATE_LOSS",
            label: "Loss of Gate Drive PWM",
            type: "GATE_LOSS",
            impact: "Brake chopper cannot conduct. Brake fails to release when elevator attempts dispatch.",
            action: "BRAKE NOT LIFTED INTERLOCK -> MOTOR POWER CUT",
            finalState: "CAR HELD SAFELY AT FLOOR",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "RV3",
        type: "Metal Oxide Varistor (MOV 385V Brake Snubber)",
        label: "RV3",
        sublabel: "MOV 385V",
        x: 60,
        y: 39,
        w: 6,
        h: 36,
        shape: "rect",
        category: "filter",
        nominalVoltage: "385V Continuous",
        nominalCurrent: "<1mA Quiescent",
        description: "Heavy-duty 385V Metal Oxide Varistor suppressing high inductive kickback arc when 230V brake coil de-energizes.",
        faultModes: [
          {
            id: "FLT-RV3-DEGRADED",
            label: "MOV Thermal Degradation Leakage",
            type: "LEAKAGE",
            impact: "Varistor resistance degrades from >10MΩ to 800Ω due to repeated brake release arcs.",
            action: "GROUND LEAKAGE WARNING -> SCHEDULED MAINTENANCE",
            finalState: "OPERATIONAL WITH WARNING",
            dcBusV: 228.0,
            currentA: 1.2,
            gateV: 115.0,
          },
        ],
      },
      {
        id: "C82",
        type: "230V-400V DC Link Energy Storage Bank",
        label: "C82-C53",
        sublabel: "230V-325V",
        x: 69,
        y: 38,
        w: 18,
        h: 24,
        shape: "rect",
        category: "filter",
        nominalVoltage: "230V DC Nominal",
        nominalCurrent: "1.9A DC Out",
        description: "Electrolytic hold-up capacitor bank ensuring controlled brake drop and preventing abrupt car jerks during power sags.",
        faultModes: [
          {
            id: "FLT-C82-SHORT",
            label: "DC Link Capacitor Dielectric Short",
            type: "SHORT_CIRCUIT",
            impact: "Direct short across 230V brake DC bus. Stored energy discharges instantly.",
            action: "OVERCURRENT HARD TRIP -> FAIL-SAFE BRAKE CLAMP",
            finalState: "LATCHED EMERGENCY STOP (EN 81-20)",
            dcBusV: 0.0,
            currentA: 35.0,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "U9",
        type: "Isolated Lift Brake Voltage Feedback Sensor",
        label: "U9 | U3B",
        sublabel: "ACPL-C79A",
        x: 58,
        y: 18,
        w: 10,
        h: 16,
        shape: "rect",
        category: "sensor",
        nominalVoltage: "3.3V Telemetry",
        nominalCurrent: "10mA",
        description: "Optically isolated differential sensor monitoring brake terminal voltage (230V Pick / 115V Hold) to confirm brake release.",
        faultModes: [
          {
            id: "FLT-U9-SAT",
            label: "Sensor Amplifier Rail Saturation",
            type: "SENSOR_DRIFT",
            impact: "Sensor outputs stuck high (false 230V signal). Safety board detects disagreement with brake microswitch.",
            action: "DISAGREEMENT TRIP -> SAFETY BRAKE DROP",
            finalState: "CRITICAL SENSOR INTERLOCK TRIP",
            dcBusV: 230.0,
            currentA: 0.95,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "U25",
        type: "HCPL-316J Desaturation Brake Driver",
        label: "U25",
        sublabel: "DESAT DRIVER",
        x: 26,
        y: 72,
        w: 12,
        h: 14,
        shape: "rect",
        category: "control",
        nominalVoltage: "15V / -5V",
        nominalCurrent: "2.5A Peak",
        description: "Optically isolated gate driver with <1µs desaturation overcurrent detection protecting the 230V brake chopper.",
        faultModes: [
          {
            id: "FLT-U25-UVLO",
            label: "Driver Secondary Bias Undervoltage",
            type: "VOLTAGE_SAG",
            impact: "Gate driver enters UVLO. Brake chopper shut down safely.",
            action: "DRIVER UVLO ACTIVE -> FAIL-SAFE BRAKE ENGAGE",
            finalState: "SAFE STATIONARY",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
        ],
      },
      {
        id: "U22",
        type: "Elevator Safety Board & Brake Controller",
        label: "U22",
        sublabel: "BRAKE CTRL",
        x: 41,
        y: 72,
        w: 12,
        h: 14,
        shape: "rect",
        category: "control",
        nominalVoltage: "24V Safety Loop",
        nominalCurrent: "100mA",
        description: "Elevator safety computer monitoring EN 81-20 safety loop, door locks, and hoistway limits to command brake pick and hold.",
        faultModes: [
          {
            id: "FLT-U22-RESET",
            label: "Safety Watchdog Reset / E-Stop",
            type: "POWER_LOSS",
            impact: "Controller watchdog timeout forces immediate de-energization of brake output line.",
            action: "SAFETY CHAIN BROKEN -> IMMEDIATE MECHANICAL BRAKE DROP",
            finalState: "LATCHED EMERGENCY STOP",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
        ],
      },
    ],
    []
  );

  // -------------------------------------------------------------
  // B. DYNAMIC SYNTHESIS FROM USER'S UPLOADED CIRCUIT IR
  // -------------------------------------------------------------
  const uploadedBlocks: CircuitBlock[] = useMemo(() => {
    if (!circuitIr?.components || circuitIr.components.length === 0) {
      return [];
    }

    const comps = circuitIr.components;
    const blocksList: CircuitBlock[] = [];

    // Separate by electrical function
    const sources = comps.filter((c) => c.type === "voltage_source" || c.type === "current_source");
    const grounds = comps.filter((c) => c.type === "ground");
    const others = comps.filter((c) => c.type !== "voltage_source" && c.type !== "current_source" && c.type !== "ground");

    // Layout coordinates in 100x100 space
    // 1. Sources on the left
    sources.forEach((s, idx) => {
      const p = Object.values(s.parameters)[0];
      const valStr = p?.raw_text || (p?.value !== undefined ? `${p.value}${p.unit || "V"}` : "5V");
      const numV = p?.value || 5.0;

      blocksList.push({
        id: s.id,
        type: s.type === "voltage_source" ? "DC/Pulse Voltage Source" : "Current Source",
        label: s.id,
        sublabel: valStr,
        x: 6,
        y: sources.length === 1 ? 38 : 28 + idx * 24,
        w: 12,
        h: 22,
        shape: "round",
        category: "input",
        nominalVoltage: valStr,
        nominalCurrent: "50 mA",
        description: `${s.name || s.id} (${valStr}). Circuit electrical excitation input.`,
        faultModes: [
          {
            id: `FLT-${s.id}-SURGE`,
            label: "Overvoltage Surge (+50%)",
            type: "OVERVOLTAGE_SURGE",
            impact: `Input voltage spikes +50% to ${(numV * 1.5).toFixed(1)}V. Output amplitude exceeds specs.`,
            action: "VOLTAGE CLAMPING ENGAGED",
            finalState: "OVERVOLTAGE RUN",
            dcBusV: numV * 1.5,
            currentA: 2.5,
            gateV: numV * 1.5,
          },
          {
            id: `FLT-${s.id}-LOSS`,
            label: "Power Cutout (0V)",
            type: "POWER_LOSS",
            impact: "Supply voltage collapses to 0V. Signal dies instantly.",
            action: "UNDERVOLTAGE TRIP (UVLO)",
            finalState: "DE-ENERGIZED FLATLINE",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
          {
            id: `FLT-${s.id}-SAG`,
            label: "Voltage Sag / Brownout (-50%)",
            type: "VOLTAGE_SAG",
            impact: `Input drops to ${(numV * 0.5).toFixed(1)}V. Insufficient drive level for output.`,
            action: "DEGRADED MODE ALARM",
            finalState: "DEGRADED SIGNAL",
            dcBusV: numV * 0.5,
            currentA: 0.4,
            gateV: numV * 0.5,
          },
        ],
      });
    });

    // 2. Middle components (Series passives, shunt loads, ICs)
    const midCount = Math.max(others.length, 1);
    const startX = 24;
    const endX = 80;
    const spacingX = (endX - startX) / Math.max(midCount, 1);

    others.forEach((comp, idx) => {
      const p = Object.values(comp.parameters)[0];
      const valStr = p?.raw_text || (p?.value !== undefined ? `${p.value}${p.unit || ""}` : comp.type);
      const isVertical = comp.orientation === 90 || (comp.bounding_box && comp.bounding_box.h > comp.bounding_box.w * 1.35);
      const isShunt = isVertical || idx === others.length - 1; // Last passive is typically shunt load

      const posX = startX + idx * spacingX;
      const posY = isShunt ? 38 : 34;
      const blockW = isShunt ? 11 : 13;
      const blockH = isShunt ? 28 : 20;

      const faultModes: CircuitBlock["faultModes"] = [];

      if (comp.type === "capacitor") {
        faultModes.push(
          {
            id: `FLT-${comp.id}-SHORT`,
            label: "Dielectric Breakdown / Short (C → 0Ω)",
            type: "SHORT_CIRCUIT",
            impact: "Dielectric short punctures plates. AC differentiation fails; pure DC level passes straight through.",
            action: "OVERCURRENT / DC LEAKAGE MONITOR",
            finalState: "DIFFERENTIATION BYPASSED (DC LEAK)",
            dcBusV: 5.0,
            currentA: 8.5,
            gateV: 5.0,
          },
          {
            id: `FLT-${comp.id}-OPEN`,
            label: "Plate Open Disconnect (C → ∞Ω)",
            type: "OPEN_CIRCUIT",
            impact: "Capacitor plates disconnect. Circuit is open-circuited; 0V flatline at output.",
            action: "SIGNAL LOSS DETECTED",
            finalState: "SIGNAL CUT / ZERO TRANSMISSION",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          },
          {
            id: `FLT-${comp.id}-CAP_LOSS`,
            label: "Capacitance Degradation -50%",
            type: "PARAMETRIC_DRIFT",
            impact: "Capacitance drops by half. Time constant tau = R*C halves, resulting in ultra-narrow pulse.",
            action: "BANDWIDTH DEGRADATION WARNING",
            finalState: "DEGRADED TIMING (NARROW PULSE)",
            dcBusV: 3.5,
            currentA: 0.6,
            gateV: 5.0,
          }
        );
      } else if (comp.type === "resistor") {
        faultModes.push(
          {
            id: `FLT-${comp.id}-OPEN`,
            label: "Element Burned Open (R → ∞Ω)",
            type: "OPEN_CIRCUIT",
            impact: "Pulldown discharge path broken. Output charges and cannot bleed off; voltage hangs high at 5V.",
            action: "ISOLATION TRIP ACTIVE",
            finalState: "LATCHED HIGH VOLTAGE",
            dcBusV: 5.0,
            currentA: 0.0,
            gateV: 5.0,
          },
          {
            id: `FLT-${comp.id}-SHORT`,
            label: "Terminal Solder Bridge / Short (R → 0Ω)",
            type: "SHORT_CIRCUIT",
            impact: "Shunt resistor shorted directly to GND return. Output is clamped hard to 0V.",
            action: "OVERCURRENT GROUND FAULT DETECTED",
            finalState: "GROUND SHUNT FLATLINE (0V)",
            dcBusV: 0.0,
            currentA: 18.2,
            gateV: 0.0,
          },
          {
            id: `FLT-${comp.id}-DRIFT_HIGH`,
            label: "Resistance Value Drift +50%",
            type: "PARAMETRIC_DRIFT",
            impact: "Resistance increases 1.5x nominal. Discharge decay slows down; pulse widens.",
            action: "PULSE WIDTH DEVIATION DETECTED",
            finalState: "WIDE PULSE OUT-OF-SPEC",
            dcBusV: 4.8,
            currentA: 0.35,
            gateV: 5.0,
          }
        );
      } else if (comp.type === "inductor") {
        faultModes.push(
          {
            id: `FLT-${comp.id}-SAT`,
            label: "Core Saturation (L → 0H)",
            type: "CORE_SATURATION",
            impact: "Inductor core saturates. Inductive reactance collapses to zero.",
            action: "PEAK CURRENT LIMIT TRIP",
            finalState: "SATURATED RUNAWAY",
            dcBusV: 1.2,
            currentA: 22.0,
            gateV: 5.0,
          },
          {
            id: `FLT-${comp.id}-OPEN`,
            label: "Winding Burnout Open",
            type: "OPEN_CIRCUIT",
            impact: "Series coil burns open. Current flow disrupted completely.",
            action: "OPEN CIRCUIT TRIP",
            finalState: "DE-ENERGIZED",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          }
        );
      } else {
        // Generic active or discrete component
        faultModes.push(
          {
            id: `FLT-${comp.id}-SHORT`,
            label: "Internal Junction Short Circuit",
            type: "SHORT_CIRCUIT",
            impact: "Silicon junction breakdown. Excessive current shunted to rail.",
            action: "HARD OVERCURRENT SHUTDOWN",
            finalState: "FAULT TRIP",
            dcBusV: 0.5,
            currentA: 15.0,
            gateV: 0.0,
          },
          {
            id: `FLT-${comp.id}-OPEN`,
            label: "Lead Terminal Open Circuit",
            type: "OPEN_CIRCUIT",
            impact: "Lead disconnects. Signal path severed.",
            action: "SIGNAL TIMEOUT ERROR",
            finalState: "SAFE ISOLATION",
            dcBusV: 0.0,
            currentA: 0.0,
            gateV: 0.0,
          }
        );
      }

      blocksList.push({
        id: comp.id,
        type: comp.type.replace("_", " ").toUpperCase(),
        label: comp.id,
        sublabel: valStr,
        x: posX,
        y: posY,
        w: blockW,
        h: blockH,
        shape: isShunt ? "rect" : comp.type === "capacitor" ? "rect" : "round",
        category: isShunt ? "filter" : "converter",
        nominalVoltage: isShunt ? "5V Output Node" : "Series Branch",
        nominalCurrent: "50 mA Peak",
        description: `${comp.name || comp.id} (${valStr}). Physical component detected from uploaded schematic.`,
        faultModes,
      });
    });

    // 3. Ground References on bottom return rail
    grounds.forEach((g, idx) => {
      blocksList.push({
        id: g.id,
        type: "Electrical Ground Reference",
        label: g.id,
        sublabel: "0V GND",
        x: others.length > 0 ? startX + (midCount - 1) * spacingX : 50,
        y: 72,
        w: 11,
        h: 14,
        shape: "rect",
        category: "sensor",
        nominalVoltage: "0.0V Return",
        nominalCurrent: "Return Path",
        description: `${g.name || g.id}. System common ground reference point.`,
        faultModes: [
          {
            id: `FLT-${g.id}-FLOAT`,
            label: "Ground Lift / Return Open",
            type: "OPEN_CIRCUIT",
            impact: "Ground reference severed. Common mode voltage floats +10V offset.",
            action: "GROUND FAULT INTERRUPT (GFI)",
            finalState: "FLOATING GROUND RUNAWAY",
            dcBusV: 10.0,
            currentA: 0.0,
            gateV: 10.0,
          },
        ],
      });
    });

    return blocksList;
  }, [circuitIr]);

  // Determine active block set based on mode
  const blocks: CircuitBlock[] = useMemo(() => {
    if (circuitMode === "UPLOADED" && uploadedBlocks.length > 0) {
      return uploadedBlocks;
    }
    return bcx14Blocks;
  }, [circuitMode, uploadedBlocks, bcx14Blocks]);

  const [selectedBlockId, setSelectedBlockId] = useState<string>(
    blocks[0]?.id || "XB11"
  );
  const [selectedFaultId, setSelectedFaultId] = useState<string>(
    blocks[0]?.faultModes[0]?.id || ""
  );
  const [systemState, setSystemState] = useState<"NORMAL" | "ARMED" | "FAULT_ACTIVE">(
    "NORMAL"
  );
  const [faultTime, setFaultTime] = useState<string>("0.2");
  const [activeTab, setActiveTab] = useState<"WORKFLOW" | "ARCHITECTURE">("WORKFLOW");

  // Keep selected block in sync when blocks change
  useEffect(() => {
    if (blocks.length > 0) {
      const exists = blocks.find((b) => b.id === selectedBlockId);
      if (!exists) {
        setSelectedBlockId(blocks[0].id);
        if (blocks[0].faultModes.length > 0) {
          setSelectedFaultId(blocks[0].faultModes[0].id);
        }
      }
    }
  }, [blocks, selectedBlockId]);

  const activeBlock = useMemo(
    () => blocks.find((b) => b.id === selectedBlockId) || blocks[0] || bcx14Blocks[0],
    [blocks, selectedBlockId, bcx14Blocks]
  );

  const activeFault = useMemo(() => {
    return (
      activeBlock?.faultModes.find((f) => f.id === selectedFaultId) ||
      activeBlock?.faultModes[0] || {
        id: "FLT-DEFAULT",
        label: "Default Parametric Deviation",
        type: "DRIFT",
        impact: "Nominal circuit deviation",
        action: "MONITOR ACTIVE",
        finalState: "DEGRADED",
        dcBusV: 5.0,
        currentA: 1.0,
        gateV: 5.0,
      }
    );
  }, [activeBlock, selectedFaultId]);

  useEffect(() => {
    if (activeBlock?.faultModes?.length > 0) {
      setSelectedFaultId(activeBlock.faultModes[0].id);
    }
  }, [activeBlock]);

  const isDifferentiator = circuitMode === "UPLOADED" && circuitIr?.title?.toLowerCase().includes("differentiator");

  const [logs, setLogs] = useState<string[]>([
    "[0.000000 s] * INITIALIZED: Normal circuit physical state verified.",
    "[0.200000 s] * CONTINUOUS NOMINAL OPERATION - All components healthy.",
    "[0.350000 s] * SIMULATION STEADY STATE REACHED.",
  ]);

  const [historyRuns, setHistoryRuns] = useState<SimRunRecord[]>([]);

  const handleRunNormal = () => {
    setSystemState("NORMAL");
    if (circuitMode === "UPLOADED") {
      setLogs([
        `[0.000000 s] * RUNNING USER SCHEMATIC: ${circuitIr?.title || "Custom Circuit"}`,
        `[0.050000 s] * Input Step Applied (${activeBlock?.nominalVoltage || "5V"})`,
        `[0.050010 s] * High-Speed Pulse Edge Captured across Series Component`,
        `[0.200000 s] * Shunt Load Settled to Steady-State Baseline`,
        `[0.350000 s] * Simulation Complete: 100% HEALTHY (0 Faults Active)`,
      ]);
    } else {
      setLogs([
        "[0.000000 s] * 230V MAINS FEED ENERGIZED: XB11 (230V RMS / 325.3 Vpk)",
        "[0.040000 s] * BRAKE CONTROLLER PICK COMMAND: 230V Pick (1.92A) Applied to L_BRAKE",
        "[0.140000 s] * BRAKE FULLY RELEASED -> Q23 Switches to 115V Hold Mode (0.96A)",
        "[0.250000 s] * EN 81-20 SAFETY MONITOR: Brake Hold Current & Lift Airgap Verified",
        "[0.350000 s] * STEADY STATE: L_BRAKE HOLD @ 115.0V / 0.96A (100% HEALTHY)",
      ]);
    }
  };

  const handleArmFault = () => {
    setSystemState("ARMED");
    setLogs((prev) => [
      ...prev,
      `[T_ARM] *** FAULT ARMED: [${activeBlock.id}] ${activeFault.label} scheduled for t = ${faultTime}s ***`,
      `[T_ARM] Simulation engine primed for hardware fault trigger injection.`,
    ]);
  };

  const handleInjectFaultAndRun = () => {
    setSystemState("FAULT_ACTIVE");
    const tFlt = parseFloat(faultTime) || 0.2;

    const baseVoltage = circuitMode === "UPLOADED" ? (isDifferentiator ? "0.00 V (Settled)" : "5.00 V") : "115.00 V";

    const newLogs = [
      `[0.000000 s] * NORMAL OPERATION - Baseline Level: ${baseVoltage}`,
      `[${tFlt.toFixed(6)} s] !!! HARDWARE FAULT INJECTED ON [${activeBlock.id}] -> ${activeFault.label} !!!`,
      `[${(tFlt + 0.002).toFixed(6)} s] ! ${activeFault.impact}`,
      `[${(tFlt + 0.008).toFixed(6)} s] * PROTECTION / BEHAVIOR: ${activeFault.action}`,
      `[0.350000 s] * SIMULATION FINISHED -> Final Circuit State: ${activeFault.finalState}`,
    ];
    setLogs(newLogs);

    const record: SimRunRecord = {
      id: `RUN-${Date.now().toString().slice(-4)}`,
      timestamp: new Date().toLocaleTimeString(),
      componentId: activeBlock.id,
      faultName: activeFault.label,
      status: "FAULT_ACTIVE",
      finalState: activeFault.finalState,
      protectionAction: activeFault.action,
      dcBusBefore: baseVoltage,
      dcBusAfter: `${activeFault.dcBusV.toFixed(2)} V`,
      currentPeak: `${activeFault.currentA.toFixed(2)} A`,
      timelineLogs: newLogs,
    };
    setHistoryRuns((prev) => [record, ...prev.slice(0, 9)]);
  };

  const handleReset = () => {
    setSystemState("NORMAL");
    handleRunNormal();
  };

  // Generate physics-accurate real-time waveform paths
  const waveformData = useMemo(() => {
    const numPoints = 80;
    const tEnd = 0.35;
    const tFlt = parseFloat(faultTime) || 0.2;
    const isFault = systemState === "FAULT_ACTIVE";

    const vPoints: string[] = [];
    const iPoints: string[] = [];
    const gPoints: string[] = [];

    for (let idx = 0; idx <= numPoints; idx++) {
      const t = (idx / numPoints) * tEnd;
      const x = (idx / numPoints) * 380;

      let vVal = 0.0;
      let iVal = 0.0;
      let gVal = 0.0;

      if (circuitMode === "UPLOADED") {
        // Mode A: Uploaded Circuit (e.g. RC Differentiator or user circuit)
        const vStep = 5.0;
        // Input step at t = 0.04s
        const inputV = t >= 0.04 ? vStep : 0.0;
        gVal = inputV;

        if (isDifferentiator) {
          // Normal RC differentiator produces impulse at step: Vout = Vstep * exp(-dt / tau)
          const dt = t - 0.04;
          const tau = 0.015; // Scaled for visual resolution
          const normalSpike = dt >= 0 ? vStep * Math.exp(-dt / tau) : 0.0;
          vVal = normalSpike;
          iVal = normalSpike / 100.0; // Current through 100 ohm resistor

          if (isFault && t >= tFlt) {
            const dtFault = t - tFlt;
            if (activeFault.type === "SHORT_CIRCUIT" && activeBlock.id.startsWith("C")) {
              // C1 short: Differentiation lost; DC step passes straight through
              vVal = 5.0;
              iVal = 5.0 / 100.0;
            } else if (activeFault.type === "OPEN_CIRCUIT") {
              // C1 or R1 open
              vVal = activeBlock.id.startsWith("R") ? 5.0 : 0.0;
              iVal = 0.0;
            } else if (activeFault.type === "SHORT_CIRCUIT" && activeBlock.id.startsWith("R")) {
              // R1 short to GND: output clamped to 0V
              vVal = 0.0;
              iVal = 0.25;
            } else if (activeFault.type === "OVERVOLTAGE_SURGE") {
              // Surge
              vVal = 7.5 * Math.exp(-Math.max(0, dtFault) / tau);
              iVal = vVal / 100.0;
              gVal = 7.5;
            } else {
              vVal = activeFault.dcBusV;
              iVal = activeFault.currentA / 100.0;
            }
          }
        } else {
          // General circuit
          vVal = inputV;
          iVal = inputV > 0 ? 0.05 : 0.0;
          if (isFault && t >= tFlt) {
            vVal = activeFault.dcBusV;
            iVal = activeFault.currentA;
          }
        }

        // Map to SVG coordinates (Canvas height: 40px)
        const yV = 36 - (vVal / 10.0) * 32;
        vPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yV)).toFixed(1)}`);

        const yI = 36 - (iVal / 0.1) * 32;
        iPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yI)).toFixed(1)}`);

        const yG = 36 - (gVal / 10.0) * 32;
        gPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yG)).toFixed(1)}`);
      } else {
        // Mode B: KONE BCX14 Elevator Brake Controller (230V Mains Input)
        // Brake Pick (230V, 0.04s - 0.14s) -> Brake Hold (115V PWM economizer)
        let vBrake = 0.0;
        let iBrake = 0.0;

        if (t < 0.04) {
          vBrake = 0.0;
          iBrake = 0.0;
        } else if (t < 0.14) {
          // 230V Pick phase (rapid coil pull-in to release mechanical spring clamps)
          vBrake = 230.0;
          const tau = 0.025; // L/R time constant (2.5H / 120 ohm approx 21ms)
          iBrake = 1.92 * (1.0 - Math.exp(-(t - 0.04) / tau));
        } else {
          // 115V Hold phase (energy-saving PWM duty cycle)
          vBrake = 115.0;
          iBrake = 0.96;
        }

        // 230V AC Mains 50Hz input: 325.3Vpk sin(2*pi*50*t)
        let vMains = 325.3 * Math.sin(2 * Math.PI * 50 * t);

        if (isFault && t >= tFlt) {
          const progress = Math.min((t - tFlt) / 0.012, 1.0);
          vBrake = vBrake + (activeFault.dcBusV - vBrake) * progress;
          iBrake = iBrake + (activeFault.currentA - iBrake) * progress;
          if (activeBlock.id === "XB11" && activeFault.type === "POWER_LOSS") {
            vMains = vMains * (1.0 - progress);
          }
        }

        // Map CH1 V_BRAKE (0 - 300V) to 40px canvas
        const yV = 38 - (Math.min(vBrake, 300) / 300) * 34;
        vPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yV)).toFixed(1)}`);

        // Map CH2 I_BRAKE (0 - 30A max scale for overcurrent trips)
        const maxI = activeFault.currentA > 5.0 ? 30.0 : 3.0;
        const yI = 38 - (Math.min(iBrake, maxI) / maxI) * 34;
        iPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yI)).toFixed(1)}`);

        // Map CH3 V_MAINS (AC sine wave around center line y = 20)
        const yMains = 20 - (vMains / 400.0) * 18;
        gPoints.push(`${x.toFixed(1)},${Math.max(2, Math.min(38, yMains)).toFixed(1)}`);
      }
    }

    return {
      vPoints: vPoints.join(" "),
      iPoints: iPoints.join(" "),
      gPoints: gPoints.join(" "),
    };
  }, [circuitMode, isDifferentiator, systemState, faultTime, activeFault, activeBlock]);

  return (
    <div className="bg-white text-slate-800 border border-slate-200 rounded-xl overflow-hidden shadow-xs font-sans">
      {/* 1. TOP CONTROL BAR */}
      <div className="bg-white border-b border-slate-200 px-4 py-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center space-x-3">
          <div className="flex items-center space-x-2">
            <span className="h-2.5 w-2.5 rounded-full bg-[#0055A5] animate-pulse"></span>
            <span className="font-bold text-sm sm:text-base tracking-tight text-slate-900 font-mono">
              {circuitMode === "UPLOADED"
                ? `LIVE ELECTRICAL FAULT STUDIO: ${circuitIr?.title || "Uploaded Schematic"}`
                : "KONE BCX14 230V ELEVATOR BRAKE CONTROLLER (BENCHMARK V3)"}
            </span>
          </div>

          {/* Mode Switcher Pills */}
          <div className="flex items-center space-x-1 bg-slate-100 p-0.5 rounded-lg border border-slate-200 text-[11px] font-mono">
            <button
              onClick={() => {
                setCircuitMode("UPLOADED");
                setSelectedBlockId(uploadedBlocks[0]?.id || "V1");
              }}
              disabled={uploadedBlocks.length === 0}
              className={`px-2.5 py-1 rounded-md transition font-bold flex items-center space-x-1 ${
                circuitMode === "UPLOADED"
                  ? "bg-[#0055A5] text-white shadow-xs"
                  : "text-slate-600 hover:text-slate-900 disabled:opacity-40"
              }`}
            >
              <Cpu className="w-3 h-3" />
              <span>Uploaded Circuit ({uploadedBlocks.length} comps)</span>
            </button>
            <button
              onClick={() => {
                setCircuitMode("BCX14_BENCHMARK");
                setSelectedBlockId("XB11");
              }}
              className={`px-2.5 py-1 rounded-md transition font-bold ${
                circuitMode === "BCX14_BENCHMARK"
                  ? "bg-[#0055A5] text-white shadow-xs"
                  : "text-slate-600 hover:text-slate-900"
              }`}
            >
              BCX14 230V Lift Brake Benchmark
            </button>
          </div>
        </div>

        {/* Action Controls */}
        <div className="flex items-center flex-wrap gap-2 text-xs font-bold font-mono">
          <button
            onClick={handleRunNormal}
            className="px-3.5 py-1.5 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white shadow-xs active:scale-95 transition"
          >
            RUN NORMAL
          </button>
          <button
            onClick={handleArmFault}
            className="px-3.5 py-1.5 rounded-lg bg-amber-500 hover:bg-amber-600 text-white shadow-xs active:scale-95 transition"
          >
            ARM FAULT
          </button>
          <button
            onClick={handleInjectFaultAndRun}
            className="px-3.5 py-1.5 rounded-lg bg-red-600 hover:bg-red-700 text-white shadow-xs active:scale-95 transition flex items-center space-x-1"
          >
            <Flame className="w-3.5 h-3.5" />
            <span>INJECT FAULT + RUN</span>
          </button>
          <button
            onClick={() => setSystemState("NORMAL")}
            className="px-3 py-1.5 rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 border border-slate-300 transition"
          >
            STOP
          </button>
          <button
            onClick={handleReset}
            className="px-3 py-1.5 rounded-lg bg-[#0055A5] hover:bg-[#004385] text-white transition flex items-center space-x-1 shadow-xs"
          >
            <RotateCcw className="w-3 h-3" />
            <span>RESET</span>
          </button>

          <div className="flex items-center space-x-1.5 bg-slate-50 border border-slate-300 px-2 py-1 rounded-lg text-[11px]">
            <span className="text-slate-500 font-medium">Fault Time (s):</span>
            <input
              type="text"
              value={faultTime}
              onChange={(e) => setFaultTime(e.target.value)}
              className="w-12 bg-white border border-slate-200 text-slate-900 font-mono font-bold focus:outline-none text-center rounded"
            />
          </div>

          <div
            className={`px-3 py-1 rounded-lg text-[11px] font-bold tracking-wider border ${
              systemState === "FAULT_ACTIVE"
                ? "bg-red-50 text-red-700 border-red-200 animate-pulse"
                : systemState === "ARMED"
                ? "bg-amber-50 text-amber-700 border-amber-200"
                : "bg-blue-50 text-[#0055A5] border-blue-200"
            }`}
          >
            STATUS: {systemState === "FAULT_ACTIVE" ? "FAULT ACTIVE" : systemState === "ARMED" ? "ARMED (READY)" : "FAULT UNARMED"}
          </div>
        </div>
      </div>

      {/* 2. SUB-NAVIGATION TABS */}
      <div className="bg-slate-50 border-b border-slate-200 px-4 py-2 flex items-center space-x-4 text-xs font-mono">
        <button
          onClick={() => setActiveTab("WORKFLOW")}
          className={`pb-1 border-b-2 font-bold transition ${
            activeTab === "WORKFLOW"
              ? "border-[#0055A5] text-[#0055A5]"
              : "border-transparent text-slate-500 hover:text-slate-800"
          }`}
        >
          LIVE SCHEMATIC &amp; FAULT WORKFLOW
        </button>
        <button
          onClick={() => setActiveTab("ARCHITECTURE")}
          className={`pb-1 border-b-2 font-bold transition ${
            activeTab === "ARCHITECTURE"
              ? "border-[#0055A5] text-[#0055A5]"
              : "border-transparent text-slate-500 hover:text-slate-800"
          }`}
        >
          MODEL ARCHITECTURE (PHYSICAL VS MATH)
        </button>
      </div>

      {/* 3. MAIN TOP SECTION (SCHEMATIC TOPOLOGY CANVAS + INSPECTOR & WAVEFORMS) */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-0 border-b border-slate-200">
        {/* Left Column: Interactive Schematic Topology View (8 cols) */}
        <div className="lg:col-span-8 p-4 bg-white flex flex-col justify-between border-r border-slate-200 min-h-[460px]">
          <div>
            <div className="flex items-center justify-between text-xs font-mono font-bold text-slate-700 mb-2">
              <span className="text-[#0055A5] uppercase tracking-wider font-extrabold flex items-center space-x-1.5">
                <span>{circuitMode === "UPLOADED" ? "UPLOADED CIRCUIT TOPOLOGY (INTERACTIVE)" : "BCX14 POWER STAGE ELECTRICAL TOPOLOGY"}</span>
              </span>
              <span className="text-slate-500 text-[11px] font-normal">
                Click any component block to inspect and inject hardware faults
              </span>
            </div>

            {/* Component Voltage/Current Status Overheads */}
            <div className="flex items-center justify-between text-[11px] font-mono font-semibold px-3 py-1.5 mb-2 bg-[#f8fafc] rounded-lg border border-slate-200 text-slate-700 overflow-x-auto">
              {blocks.slice(0, 5).map((b) => (
                <span
                  key={b.id}
                  onClick={() => setSelectedBlockId(b.id)}
                  className={`cursor-pointer px-1.5 py-0.5 rounded transition ${
                    selectedBlockId === b.id ? "bg-amber-100 text-amber-900 font-bold" : "hover:text-[#0055A5]"
                  }`}
                >
                  {b.id}: {b.sublabel}
                </span>
              ))}
              <span className="text-[#0055A5] font-extrabold bg-blue-50 px-2 py-0.5 rounded border border-blue-200 shrink-0">
                {circuitMode === "UPLOADED" ? "OUTPUT V:" : "DC LINK:"} {systemState === "FAULT_ACTIVE" ? activeFault.dcBusV.toFixed(1) : circuitMode === "UPLOADED" ? "5.0" : "395.2"} V
              </span>
            </div>
          </div>

          {/* Interactive Topology Diagram Canvas */}
          <div className="relative w-full h-[320px] bg-[#f8fafc] border border-slate-200 rounded-lg overflow-hidden flex items-center justify-center p-2 select-none shadow-inner">
            {/* SVG Connecting Wiring Bus Lines */}
            <svg className="absolute inset-0 w-full h-full pointer-events-none" viewBox="0 0 100 100" preserveAspectRatio="none">
              {circuitMode === "UPLOADED" ? (
                /* Dynamic Wiring for Uploaded Circuit */
                <>
                  {/* Top Bus Wire (Power/Signal) */}
                  <line x1="18" y1="44" x2="88" y2="44" stroke="#0055A5" strokeWidth="2.5" />
                  {/* Bottom Return Rail (Ground) */}
                  <line x1="18" y1="76" x2="88" y2="76" stroke="#64748b" strokeWidth="2.0" />
                  {/* Left Source Connections */}
                  <line x1="12" y1="38" x2="18" y2="44" stroke="#0055A5" strokeWidth="2.0" />
                  <line x1="12" y1="60" x2="18" y2="76" stroke="#64748b" strokeWidth="2.0" />
                  {/* Shunt Drops connecting top rail to bottom rail */}
                  {uploadedBlocks.filter((b) => b.y >= 38 && b.h >= 24).map((b) => (
                    <g key={`wire-${b.id}`}>
                      <line x1={b.x + b.w / 2} y1="44" x2={b.x + b.w / 2} y2={b.y} stroke="#0055A5" strokeWidth="1.5" />
                      <line x1={b.x + b.w / 2} y1={b.y + b.h} x2={b.x + b.w / 2} y2="76" stroke="#64748b" strokeWidth="1.5" />
                    </g>
                  ))}
                  {/* Output Node Measurement Points */}
                  <circle cx="88" cy="44" r="2.0" fill="#0055A5" stroke="#ffffff" strokeWidth="0.8" />
                  <circle cx="88" cy="76" r="2.0" fill="#64748b" stroke="#ffffff" strokeWidth="0.8" />
                  <line x1="88" y1="44" x2="94" y2="44" stroke="#0055A5" strokeWidth="1.5" strokeDasharray="1,1" />
                  <line x1="88" y1="76" x2="94" y2="76" stroke="#64748b" strokeWidth="1.5" strokeDasharray="1,1" />
                </>
              ) : (
                /* BCX14 Wiring */
                <>
                  <line x1="14" y1="50" x2="17" y2="50" stroke="#0284c7" strokeWidth="1.5" />
                  <line x1="14" y1="55" x2="17" y2="55" stroke="#0284c7" strokeWidth="1.5" />
                  <line x1="25" y1="53" x2="28" y2="41" stroke="#0055A5" strokeWidth="1.5" />
                  <line x1="25" y1="53" x2="28" y2="60" stroke="#0055A5" strokeWidth="1.5" />
                  <line x1="37" y1="41" x2="41" y2="52" stroke="#0055A5" strokeWidth="1.5" />
                  <line x1="37" y1="60" x2="41" y2="52" stroke="#0055A5" strokeWidth="1.5" />
                  <line x1="49" y1="52" x2="54" y2="52" stroke="#0055A5" strokeWidth="1.5" />
                  <line x1="54" y1="36" x2="88" y2="36" stroke="#d97706" strokeWidth="2.5" />
                  <line x1="64" y1="36" x2="64" y2="44" stroke="#d97706" strokeWidth="1.5" />
                  <line x1="68" y1="36" x2="68" y2="44" stroke="#d97706" strokeWidth="1.5" />
                  <line x1="72" y1="36" x2="72" y2="44" stroke="#d97706" strokeWidth="1.5" />
                  <line x1="17" y1="67" x2="88" y2="67" stroke="#64748b" strokeWidth="2.0" />
                  <line x1="37" y1="78" x2="48" y2="78" stroke="#7c3aed" strokeWidth="1.2" strokeDasharray="2,2" />
                </>
              )}
            </svg>

            {/* Render Component Interactive Blocks */}
            {blocks.map((blk) => {
              const isSelected = selectedBlockId === blk.id;
              const isFaultActiveOnThis =
                systemState === "FAULT_ACTIVE" && selectedBlockId === blk.id;

              return (
                <div
                  key={blk.id}
                  onClick={() => setSelectedBlockId(blk.id)}
                  style={{
                    left: `${blk.x}%`,
                    top: `${blk.y}%`,
                    width: `${blk.w}%`,
                    height: `${blk.h}%`,
                  }}
                  className={`absolute flex flex-col items-center justify-center cursor-pointer transition-all duration-150 p-1 text-center font-mono ${
                    isSelected
                      ? "ring-4 ring-amber-400 border-2 border-amber-500 bg-amber-50 shadow-lg z-20 scale-105"
                      : "hover:ring-2 hover:ring-[#0055A5] hover:scale-102 z-10 bg-white border-2 border-[#0055A5] shadow-xs"
                  } ${
                    isFaultActiveOnThis
                      ? "bg-red-50 border-2 border-red-500 animate-pulse text-red-900"
                      : ""
                  } ${
                    blk.shape === "round"
                      ? "rounded-full"
                      : blk.shape === "diamond"
                      ? "rounded-md rotate-45"
                      : "rounded-lg"
                  }`}
                  title={`Click to select ${blk.label}: ${blk.type}`}
                >
                  <div className={blk.shape === "diamond" ? "-rotate-45" : ""}>
                    <span className="font-extrabold text-xs block text-slate-900 leading-tight">
                      {blk.label}
                    </span>
                    <span className="text-[9px] text-slate-600 block leading-tight font-medium">
                      {blk.sublabel}
                    </span>
                  </div>
                </div>
              );
            })}

            {/* High-Voltage / Output Rail Badges */}
            <div className="absolute right-2 top-4 bg-amber-50 text-amber-800 border border-amber-300 font-mono text-[10px] font-bold px-2 py-0.5 rounded shadow-xs">
              {circuitMode === "UPLOADED" ? "+VOUT (PROBE)" : "+UDC (395V)"}
            </div>
            <div className="absolute right-2 bottom-4 bg-slate-100 text-slate-700 border border-slate-300 font-mono text-[10px] font-bold px-2 py-0.5 rounded shadow-xs">
              {circuitMode === "UPLOADED" ? "-VOUT (GND)" : "-UDC (GND)"}
            </div>
          </div>

          {/* Bottom Hint */}
          <div className="text-[11px] text-slate-500 font-mono mt-2 flex items-center justify-between">
            <span>Click any block above to select it, then choose a fault mode in the Inspector on the right.</span>
            <span className="font-semibold text-[#0055A5]">Active Block: {activeBlock.id}</span>
          </div>
        </div>

        {/* Right Column: Component/Fault Inspector & Real-time Waveforms (4 cols) */}
        <div className="lg:col-span-4 p-4 bg-[#f8fafc] flex flex-col justify-between space-y-4">
          {/* A. Component / Fault Inspector Card */}
          <div className="bg-white border border-slate-200 rounded-lg p-3.5 shadow-xs space-y-3">
            <h4 className="text-xs font-mono font-bold text-slate-800 uppercase tracking-wider flex items-center justify-between">
              <span>COMPONENT / FAULT INSPECTOR</span>
              <span className="text-[10px] bg-blue-50 text-[#0055A5] border border-blue-200 px-1.5 py-0.2 rounded font-semibold">
                {activeBlock.id}
              </span>
            </h4>

            {/* Component Selector Dropdown */}
            <div>
              <label className="text-[11px] text-slate-600 block mb-1 font-medium">Select Component:</label>
              <select
                value={selectedBlockId}
                onChange={(e) => setSelectedBlockId(e.target.value)}
                className="w-full bg-white border border-slate-300 rounded px-2.5 py-1.5 text-xs text-slate-900 font-medium focus:ring-1 focus:ring-[#0055A5]"
              >
                {blocks.map((b) => (
                  <option key={b.id} value={b.id}>
                    {b.id} — {b.type} ({b.sublabel})
                  </option>
                ))}
              </select>
            </div>

            {/* Selected Component Description */}
            <div className="bg-slate-50 border border-slate-200 rounded p-2 text-xs space-y-1">
              <div className="text-slate-800 font-bold">
                SELECTED: <span className="text-[#0055A5]">{activeBlock.id} {activeBlock.type}</span>
              </div>
              <p className="text-[11px] text-slate-600 leading-relaxed">
                {activeBlock.description}
              </p>
              <div className="text-[10px] font-mono text-slate-500 pt-1 flex justify-between border-t border-slate-200">
                <span>Rating: {activeBlock.nominalVoltage}</span>
                <span>Nominal: {activeBlock.nominalCurrent}</span>
              </div>
            </div>

            {/* Fault Selection Dropdown */}
            <div>
              <label className="text-[11px] text-slate-600 block mb-1 font-medium">Fault Mode:</label>
              <select
                value={selectedFaultId}
                onChange={(e) => setSelectedFaultId(e.target.value)}
                className="w-full bg-white border border-slate-300 rounded px-2.5 py-1.5 text-xs text-slate-900 font-bold focus:ring-1 focus:ring-[#0055A5]"
              >
                {activeBlock.faultModes.map((f) => (
                  <option key={f.id} value={f.id}>
                    {f.label}
                  </option>
                ))}
              </select>
            </div>

            {/* Action Buttons */}
            <div className="grid grid-cols-2 gap-2 pt-1 font-mono font-bold text-xs">
              <button
                onClick={handleArmFault}
                className="py-1.5 px-2 bg-amber-500 hover:bg-amber-600 text-white rounded shadow-xs active:scale-95 transition text-center"
              >
                ARM FAULT
              </button>
              <button
                onClick={handleInjectFaultAndRun}
                className="py-1.5 px-2 bg-red-600 hover:bg-red-700 text-white rounded shadow-xs active:scale-95 transition text-center flex items-center justify-center space-x-1"
              >
                <Flame className="w-3.5 h-3.5" />
                <span>INJECT + RUN</span>
              </button>
            </div>
          </div>

          {/* B. Live 3-Channel Oscilloscope Waveforms Card */}
          <div className="bg-white border border-slate-200 rounded-lg p-3.5 shadow-xs space-y-2">
            <div className="flex items-center justify-between text-xs font-mono font-bold">
              <span className="text-[#0055A5]">LIVE PHYSICAL WAVEFORMS (3-CH)</span>
              <span className="text-[10px] text-slate-500 font-mono">Simscape ode23t</span>
            </div>

            {/* Channel 1: Output / Bus Voltage */}
            <div>
              <div className="flex items-center justify-between text-[10px] font-mono text-slate-600 mb-0.5">
                <span className="font-bold text-[#0055A5] flex items-center space-x-1">
                  <span className="inline-block w-2 h-2 rounded-full bg-[#0055A5]"></span>
                  <span>{circuitMode === "UPLOADED" ? "CH1: V_OUT(t) (Node Voltage)" : "CH1: V_BRAKE(t) (Lift Brake: 230V Pick / 115V Hold)"}</span>
                </span>
                <span className="font-bold">
                  {systemState === "FAULT_ACTIVE" ? activeFault.dcBusV.toFixed(1) : circuitMode === "UPLOADED" ? "5.0" : "115.0"} V
                </span>
              </div>
              <div className="h-10 bg-slate-900 rounded border border-slate-300 relative overflow-hidden flex items-center">
                <svg className="w-full h-full" viewBox="0 0 380 40" preserveAspectRatio="none">
                  <polyline
                    fill="none"
                    stroke="#38bdf8"
                    strokeWidth="2.0"
                    points={waveformData.vPoints}
                  />
                </svg>
              </div>
            </div>

            {/* Channel 2: Branch Current */}
            <div>
              <div className="flex items-center justify-between text-[10px] font-mono text-slate-600 mb-0.5">
                <span className="font-bold text-amber-600 flex items-center space-x-1">
                  <span className="inline-block w-2 h-2 rounded-full bg-amber-500"></span>
                  <span>{circuitMode === "UPLOADED" ? "CH2: I_COMP(t) (Branch Current)" : "CH2: I_BRAKE(t) (Solenoid: 1.9A Pick / 0.95A Hold)"}</span>
                </span>
                <span className="font-bold">
                  {systemState === "FAULT_ACTIVE" ? activeFault.currentA.toFixed(1) : circuitMode === "UPLOADED" ? "0.05" : "0.96"} A
                </span>
              </div>
              <div className="h-10 bg-slate-900 rounded border border-slate-300 relative overflow-hidden flex items-center">
                <svg className="w-full h-full" viewBox="0 0 380 40" preserveAspectRatio="none">
                  <polyline
                    fill="none"
                    stroke="#fbbf24"
                    strokeWidth="2.0"
                    points={waveformData.iPoints}
                  />
                </svg>
              </div>
            </div>

            {/* Channel 3: Input / Gate Signal */}
            <div>
              <div className="flex items-center justify-between text-[10px] font-mono text-slate-600 mb-0.5">
                <span className="font-bold text-emerald-600 flex items-center space-x-1">
                  <span className="inline-block w-2 h-2 rounded-full bg-emerald-500"></span>
                  <span>{circuitMode === "UPLOADED" ? "CH3: V_IN(t) (Input Step Signal)" : "CH3: V_MAINS(t) (230V AC Lift Mains)"}</span>
                </span>
                <span className="font-bold">
                  {circuitMode === "UPLOADED" ? (systemState === "FAULT_ACTIVE" ? activeFault.gateV.toFixed(1) + " V" : "5.0 V") : (systemState === "FAULT_ACTIVE" && activeBlock.id === "XB11" ? "0.0 VAC" : "230.0 VAC (325Vpk)")}
                </span>
              </div>
              <div className="h-10 bg-slate-900 rounded border border-slate-300 relative overflow-hidden flex items-center">
                <svg className="w-full h-full" viewBox="0 0 380 40" preserveAspectRatio="none">
                  <polyline
                    fill="none"
                    stroke="#34d399"
                    strokeWidth="1.8"
                    points={waveformData.gPoints}
                  />
                </svg>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* 4. BOTTOM THREE-COLUMN CONSOLE */}
      <div className="grid grid-cols-1 md:grid-cols-3 divide-y md:divide-y-0 md:divide-x divide-slate-200 bg-white">
        {/* Col 1: Simulation Event Timeline */}
        <div className="p-4 space-y-2">
          <div className="flex items-center space-x-2 text-xs font-mono font-bold text-slate-800">
            <Activity className="w-4 h-4 text-[#0055A5]" />
            <span className="uppercase">SIMULATION EVENT TIMELINE</span>
          </div>
          <div className="bg-[#f8fafc] border border-slate-200 rounded-lg p-3 h-48 overflow-y-auto font-mono text-[11px] space-y-1.5 shadow-inner">
            {logs.map((line, i) => (
              <div
                key={i}
                className={
                  line.includes("!!!")
                    ? "text-red-600 font-bold bg-red-50 p-1 rounded"
                    : line.includes("***")
                    ? "text-amber-600 font-bold bg-amber-50 p-1 rounded"
                    : line.includes("ACTION")
                    ? "text-emerald-700 font-bold"
                    : "text-slate-600"
                }
              >
                {line}
              </div>
            ))}
          </div>
        </div>

        {/* Col 2: Before / After Comparison */}
        <div className="p-4 space-y-2">
          <div className="flex items-center space-x-2 text-xs font-mono font-bold text-slate-800">
            <AlertTriangle className="w-4 h-4 text-amber-500" />
            <span className="uppercase">BEFORE / AFTER COMPARISON</span>
          </div>
          <div className="bg-[#f8fafc] border border-slate-200 rounded-lg p-3 h-48 overflow-y-auto font-mono text-[11px] shadow-inner">
            <table className="w-full text-left">
              <thead>
                <tr className="text-slate-400 border-b border-slate-200 text-[10px]">
                  <th className="pb-1">METRIC</th>
                  <th className="pb-1 text-center">NORMAL</th>
                  <th className="pb-1 text-right">WITH FAULT</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 text-slate-700 font-bold">
                <tr>
                  <td className="py-1.5 font-normal text-slate-500">Output / Bus</td>
                  <td className="py-1.5 text-center text-emerald-600">{circuitMode === "UPLOADED" ? "5.0 V" : "395.2 V"}</td>
                  <td className="py-1.5 text-right text-red-600">
                    {systemState === "FAULT_ACTIVE" ? `${activeFault.dcBusV.toFixed(1)} V` : "—"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 font-normal text-slate-500">Peak Current</td>
                  <td className="py-1.5 text-center text-emerald-600">{circuitMode === "UPLOADED" ? "0.05 A" : "0.8 A"}</td>
                  <td className="py-1.5 text-right text-red-600">
                    {systemState === "FAULT_ACTIVE" ? `${activeFault.currentA.toFixed(1)} A` : "—"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 font-normal text-slate-500">Signal State</td>
                  <td className="py-1.5 text-center text-emerald-600">PASS</td>
                  <td className="py-1.5 text-right text-amber-600">
                    {systemState === "FAULT_ACTIVE" ? "DEGRADED" : "NOMINAL"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 font-normal text-slate-500">Protection</td>
                  <td className="py-1.5 text-center text-slate-400">IDLE</td>
                  <td className="py-1.5 text-right text-purple-700 text-[10px]">
                    {systemState === "FAULT_ACTIVE" ? activeFault.action : "ARMED"}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        {/* Col 3: Fault Injection History & Results */}
        <div className="p-4 space-y-2">
          <div className="flex items-center space-x-2 text-xs font-mono font-bold text-slate-800">
            <CheckCircle2 className="w-4 h-4 text-emerald-600" />
            <span className="uppercase">SIMULATION RESULTS &amp; HISTORY</span>
          </div>
          <div className="bg-[#f8fafc] border border-slate-200 rounded-lg p-2.5 h-48 overflow-y-auto font-mono text-[10px] space-y-2 shadow-inner">
            {historyRuns.length === 0 ? (
              <div className="h-full flex items-center justify-center text-slate-400 text-center">
                Click &apos;INJECT FAULT + RUN&apos; to execute hardware failure scenarios and record results.
              </div>
            ) : (
              historyRuns.map((run) => (
                <div key={run.id} className="bg-white border border-slate-200 rounded p-2 shadow-2xs space-y-1">
                  <div className="flex items-center justify-between text-slate-900 font-bold">
                    <span className="text-[#0055A5]">{run.componentId}</span>
                    <span className="text-slate-500">{run.timestamp}</span>
                  </div>
                  <div className="text-slate-700 font-semibold">{run.faultName}</div>
                  <div className="text-[9px] text-red-600 flex justify-between">
                    <span>Final State: {run.finalState}</span>
                    <span>Peak: {run.currentPeak}</span>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
