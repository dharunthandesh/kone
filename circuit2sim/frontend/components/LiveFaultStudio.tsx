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
} from "lucide-react";
import { UniversalCircuitIR } from "../types/circuit";

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
  const defaultBlocks: CircuitBlock[] = [
    {
      id: "XB11",
      type: "AC Input Terminal Connector",
      label: "XB11",
      sublabel: "AC IN",
      x: 6,
      y: 42,
      w: 8,
      h: 22,
      shape: "rect",
      category: "input",
      nominalVoltage: "230V RMS (325.3Vpk)",
      nominalCurrent: "0.8A RMS",
      description: "230V RMS (325.3 Vpk) Single-Phase AC Mains Input Connector.",
      faultModes: [
        {
          id: "FLT-XB11-SURGE",
          label: "AC Surge +50V (375.3 Vpk)",
          type: "OVERVOLTAGE_SURGE",
          impact: "Peak voltage spikes +50V above nominal. MOV clamps line overvoltage.",
          action: "MOV RV3 CLAMP ENGAGED",
          finalState: "SURGE CLAMPED / DEGRADED",
          dcBusV: 442.5,
          currentA: 2.8,
          gateV: 15.0,
        },
        {
          id: "FLT-XB11-LOSS",
          label: "Mains Power Drop (0V)",
          type: "POWER_LOSS",
          impact: "AC input disconnects completely. DC link discharges safely.",
          action: "UNDERVOLTAGE LOCKOUT (UVLO)",
          finalState: "SAFE DE-ENERGIZED",
          dcBusV: 0.0,
          currentA: 0.0,
          gateV: 0.0,
        },
        {
          id: "FLT-XB11-SAG",
          label: "Brownout Sag -50% (115V RMS)",
          type: "VOLTAGE_SAG",
          impact: "Input line drops to 115V RMS. PFC attempts maximum compensation.",
          action: "DUTY CYCLE CLAMP",
          finalState: "DEGRADED BUS",
          dcBusV: 285.0,
          currentA: 1.6,
          gateV: 15.0,
        },
      ],
    },
    {
      id: "D2",
      type: "Diode Bridge Rectifier",
      label: "D2",
      sublabel: "BRIDGE",
      x: 17,
      y: 40,
      w: 8,
      h: 26,
      shape: "diamond",
      category: "rectifier",
      nominalVoltage: "325.3V Rectified",
      nominalCurrent: "0.8A DC",
      description: "Full-Wave Bridge Rectifier Package (Single-Phase AC to Raw Pulsating DC).",
      faultModes: [
        {
          id: "FLT-D2-SHORT",
          label: "Diode Arm Short Circuit",
          type: "SHORT_CIRCUIT",
          impact: "Severe AC-to-DC shoot-through. Input fuse blows immediately.",
          action: "INPUT FAST BLOW FUSE TRIP",
          finalState: "CRITICAL / TRIPPED",
          dcBusV: 12.0,
          currentA: 18.5,
          gateV: 0.0,
        },
        {
          id: "FLT-D2-OPEN",
          label: "Diode Arm Open Circuit",
          type: "OPEN_CIRCUIT",
          impact: "Operates as half-wave rectifier with heavy 50Hz ripple.",
          action: "RIPPLE WARNING DETECTED",
          finalState: "DEGRADED (HALF-WAVE)",
          dcBusV: 260.0,
          currentA: 0.45,
          gateV: 15.0,
        },
      ],
    },
    {
      id: "R122",
      type: "Precharge Inrush Resistor",
      label: "R122|R51",
      sublabel: "INRUSH",
      x: 28,
      y: 34,
      w: 9,
      h: 15,
      shape: "rect",
      category: "converter",
      nominalVoltage: "12V drop",
      nominalCurrent: "0.4A",
      description: "Soft-Start Inrush Current Limiting Resistor Pair.",
      faultModes: [
        {
          id: "FLT-R122-OPEN",
          label: "Inrush Resistor Open Circuit",
          type: "OPEN_CIRCUIT",
          impact: "DC link cannot pre-charge; system fails to initialize.",
          action: "PRECHARGE TIMEOUT FAULT",
          finalState: "STARTUP INHIBITED",
          dcBusV: 0.0,
          currentA: 0.0,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "Q14",
      type: "Bypass Relay / MOSFET",
      label: "Q14",
      sublabel: "BYPASS",
      x: 28,
      y: 53,
      w: 9,
      h: 15,
      shape: "rect",
      category: "converter",
      nominalVoltage: "VDS=0.1V",
      nominalCurrent: "ID=0.8A",
      description: "Relay / Bypass Switch Shunting Inrush Resistor after Pre-Charge.",
      faultModes: [
        {
          id: "FLT-Q14-STUCK-OPEN",
          label: "Bypass Contact Stuck Open",
          type: "OPEN_CIRCUIT",
          impact: "Full load current continuously flows through R122, causing overheating.",
          action: "THERMAL CUTOFF TRIP",
          finalState: "OVERHEATING WARNING",
          dcBusV: 370.0,
          currentA: 0.8,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "L13",
      type: "PFC Choke Inductor",
      label: "L13",
      sublabel: "750µH",
      x: 41,
      y: 43,
      w: 8,
      h: 18,
      shape: "round",
      category: "converter",
      nominalVoltage: "PFC Boost Node",
      nominalCurrent: "16.0A Peak",
      description: "750 µH High-Frequency Magnetic Power Factor Correction Inductor.",
      faultModes: [
        {
          id: "FLT-L13-SAT",
          label: "Core Saturation / Short Turns",
          type: "SHORT_CIRCUIT",
          impact: "Inductance collapses. Steep di/dt overcurrent through PFC switch.",
          action: "CYCLE-BY-CYCLE OVERCURRENT TRIP",
          finalState: "CRITICAL HAZARD",
          dcBusV: 310.0,
          currentA: 24.2,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "Q23",
      type: "PFC Power Switch (IGBT/MOSFET)",
      label: "Q23",
      sublabel: "PFC",
      x: 48,
      y: 50,
      w: 7,
      h: 22,
      shape: "rect",
      category: "converter",
      nominalVoltage: "650V rated",
      nominalCurrent: "20kHz PWM",
      description: "650V Power Switch with Active 20kHz Gate Modulation.",
      faultModes: [
        {
          id: "FLT-Q23-SHORT",
          label: "Drain-Source / CE Short",
          type: "SHORT_CIRCUIT",
          impact: "Shunts PFC inductor directly to ground. Maximum fault current.",
          action: "DESAT PROTECTION SHUTDOWN",
          finalState: "CRITICAL FAULT LATCH",
          dcBusV: 45.0,
          currentA: 32.0,
          gateV: 0.0,
        },
        {
          id: "FLT-Q23-OPEN",
          label: "Gate Signal Lost / Open Gate",
          type: "OPEN_CIRCUIT",
          impact: "PFC boost converter inactive. Operates in passive pass-through.",
          action: "PFC BOOST LOSS WARNING",
          finalState: "DEGRADED (325V UNBOOSTED)",
          dcBusV: 325.0,
          currentA: 0.8,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "RV3",
      type: "MOV Surge Varistor",
      label: "RV3",
      sublabel: "MOV 385V",
      x: 54,
      y: 45,
      w: 5,
      h: 30,
      shape: "rect",
      category: "filter",
      nominalVoltage: "385V Clamping",
      nominalCurrent: "0A Leakage",
      description: "Metal Oxide Varistor Overvoltage Transient Suppressor.",
      faultModes: [
        {
          id: "FLT-RV3-DEGRADE",
          label: "MOV Degradation / High Leakage",
          type: "DIELECTRIC_LEAKAGE",
          impact: "Internal degradation causes persistent continuous leakage current.",
          action: "EARTH LEAKAGE MONITOR",
          finalState: "THERMAL WARNING",
          dcBusV: 391.0,
          currentA: 1.2,
          gateV: 15.0,
        },
      ],
    },
    {
      id: "C82",
      type: "DC Link Capacitor Bank",
      label: "C82-C53",
      sublabel: "5x Caps (395.2V)",
      x: 61,
      y: 44,
      w: 15,
      h: 20,
      shape: "rect",
      category: "filter",
      nominalVoltage: "UDC = 395.2V",
      nominalCurrent: "Ripple < 1V",
      description: "Parallel Low-ESR Electrolytic & Film Capacitor Bank (470µF x 5).",
      faultModes: [
        {
          id: "FLT-C82-SHORT",
          label: "Dielectric Breakdown (Short)",
          type: "SHORT_CIRCUIT",
          impact: "DC Bus short-circuited to GND rail. High energy discharge.",
          action: "HARDWARE CROWBAR & BRAKE TRIP",
          finalState: "CRITICAL HAZARD",
          dcBusV: 4.5,
          currentA: 45.0,
          gateV: 0.0,
        },
        {
          id: "FLT-C82-HIGH-ESR",
          label: "Electrolyte Dryout (+500% ESR)",
          type: "HIGH_ESR",
          impact: "High voltage ripple and capacitor self-heating.",
          action: "RIPPLE FREQUENCY WARNING",
          finalState: "DEGRADED (HIGH RIPPLE)",
          dcBusV: 388.0,
          currentA: 1.1,
          gateV: 15.0,
        },
      ],
    },
    {
      id: "U9",
      type: "Isolated Voltage Sensing Subsystem",
      label: "U9|U3B",
      sublabel: "ACPL-C79A",
      x: 52,
      y: 28,
      w: 8,
      h: 14,
      shape: "triangle",
      category: "sensor",
      nominalVoltage: "5.0V Analog",
      nominalCurrent: "12mA",
      description: "KONE BCX14 Isolated Sigma-Delta ADC / High-Impedance DC Sensing Stage.",
      faultModes: [
        {
          id: "FLT-U9-STUCK-HI",
          label: "Output Clamped to High Rail (+15V)",
          type: "STUCK_AT_RAIL_HIGH",
          impact: "Microcontroller ADC perceives false severe overvoltage condition.",
          action: "SAFETY BRAKE TRIP (FALSE ALARM)",
          finalState: "EMERGENCY SAFE STOP",
          dcBusV: 395.2,
          currentA: 0.8,
          gateV: 0.0,
        },
        {
          id: "FLT-U9-STUCK-LO",
          label: "Output Clamped to 0V (Blind Sensor)",
          type: "STUCK_AT_RAIL_LOW",
          impact: "System cannot detect real overvoltages. Critical safety hazard.",
          action: "ADC SENSOR WATCHDOG TIMEOUT",
          finalState: "CRITICAL BLIND SENSOR",
          dcBusV: 395.2,
          currentA: 0.8,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "U25",
      type: "Isolated Gate Driver",
      label: "U25",
      sublabel: "HCPL-316J DESAT",
      x: 26,
      y: 72,
      w: 11,
      h: 12,
      shape: "rect",
      category: "control",
      nominalVoltage: "15V / -5V",
      nominalCurrent: "2.5A Peak",
      description: "Optically Isolated Gate Driver with Integrated Desaturation Detection.",
      faultModes: [
        {
          id: "FLT-U25-UVLO",
          label: "Secondary Bias Undervoltage",
          type: "VOLTAGE_SAG",
          impact: "Gate driver enters UVLO shutdown, de-energizing IGBT safely.",
          action: "DRIVER UVLO ACTIVE",
          finalState: "SAFE SHUTDOWN",
          dcBusV: 325.0,
          currentA: 0.8,
          gateV: 0.0,
        },
      ],
    },
    {
      id: "U22",
      type: "PFC Controller IC",
      label: "U22",
      sublabel: "PFC CTRL",
      x: 39,
      y: 72,
      w: 11,
      h: 12,
      shape: "rect",
      category: "control",
      nominalVoltage: "3.3V / 12V",
      nominalCurrent: "25mA",
      description: "Continuous Conduction Mode (CCM) Power Factor Correction Controller.",
      faultModes: [
        {
          id: "FLT-U22-RESET",
          label: "Watchdog Reset / Clock Loss",
          type: "POWER_LOSS",
          impact: "Controller resets, forcing all gate outputs to zero state.",
          action: "CONTROLLER WATCHDOG TRIP",
          finalState: "SAFE SYSTEM IDLE",
          dcBusV: 325.0,
          currentA: 0.8,
          gateV: 0.0,
        },
      ],
    },
  ];

  const blocks: CircuitBlock[] = useMemo(() => defaultBlocks, [defaultBlocks]);

  const [selectedBlockId, setSelectedBlockId] = useState<string>("XB11");
  const [selectedFaultId, setSelectedFaultId] = useState<string>(
    defaultBlocks[0].faultModes[0].id
  );
  const [systemState, setSystemState] = useState<"NORMAL" | "ARMED" | "FAULT_ACTIVE">(
    "NORMAL"
  );
  const [faultTime, setFaultTime] = useState<string>("0.2");
  const [activeTab, setActiveTab] = useState<"WORKFLOW" | "ARCHITECTURE">("WORKFLOW");

  const activeBlock = useMemo(
    () => blocks.find((b) => b.id === selectedBlockId) || blocks[0],
    [blocks, selectedBlockId]
  );

  const activeFault = useMemo(() => {
    return (
      activeBlock.faultModes.find((f) => f.id === selectedFaultId) ||
      activeBlock.faultModes[0]
    );
  }, [activeBlock, selectedFaultId]);

  useEffect(() => {
    if (activeBlock.faultModes.length > 0) {
      setSelectedFaultId(activeBlock.faultModes[0].id);
    }
  }, [activeBlock]);

  const [logs, setLogs] = useState<string[]>([
    "[0.000000 s] * NORMAL OPERATION - Baseline DC: 395.2V",
    "[0.200000 s] * CONTINUOUS NORMAL OPERATION",
    "[0.350000 s] * FINAL STATE - NORMAL",
  ]);

  const [historyRuns, setHistoryRuns] = useState<SimRunRecord[]>([]);

  const handleRunNormal = () => {
    setSystemState("NORMAL");
    setLogs([
      "[0.000000 s] * SIMULATION INITIATED: Full Baseline Nominal State",
      "[0.050000 s] * AC Mains Input 230V RMS (325.3 Vpk) Locked",
      "[0.120000 s] * Soft-start Precharge R122 Inrush Complete -> Relay Q14 Closed",
      "[0.200000 s] * 20kHz PFC Active Boost Initialized",
      "[0.350000 s] * Final Stable State: DC LINK = 395.20V | NORMAL (100% HEALTH)",
    ]);
  };

  const handleArmFault = () => {
    setSystemState("ARMED");
    setLogs((prev) => [
      ...prev,
      `[T_ARM] *** FAULT ARMED: [${activeBlock.id}] ${activeFault.label} scheduled for t = ${faultTime}s ***`,
      `[T_ARM] System primed for hardware fault injection trigger.`,
    ]);
  };

  const handleInjectFaultAndRun = () => {
    setSystemState("FAULT_ACTIVE");
    const tFlt = parseFloat(faultTime) || 0.2;

    const newLogs = [
      `[0.000000 s] * NORMAL OPERATION - Baseline DC Link: 395.20V`,
      `[${tFlt.toFixed(6)} s] !!! FAULT INJECTED ON [${activeBlock.id}] -> ${activeFault.label} !!!`,
      `[${(tFlt + 0.002).toFixed(6)} s] ! ${activeFault.impact}`,
      `[${(tFlt + 0.008).toFixed(6)} s] * ACTION: ${activeFault.action}`,
      `[0.350000 s] * SIMULATION COMPLETE -> Final State: ${activeFault.finalState}`,
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
      dcBusBefore: "395.20 V",
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

      let vBus = 395.2;
      let iComp = 0.8;
      let vGate = 15.0;

      if (isFault && t >= tFlt) {
        const progress = Math.min((t - tFlt) / 0.015, 1.0);
        vBus = 395.2 + (activeFault.dcBusV - 395.2) * progress;
        iComp = 0.8 + (activeFault.currentA - 0.8) * progress;
        vGate = 15.0 + (activeFault.gateV - 15.0) * progress;
      }

      const yV = 40 - (vBus / 500) * 35;
      vPoints.push(`${x.toFixed(1)},${yV.toFixed(1)}`);

      const yI = 40 - (Math.min(iComp, 50) / 50) * 35;
      iPoints.push(`${x.toFixed(1)},${yI.toFixed(1)}`);

      const yG = 40 - (vGate / 20) * 35;
      gPoints.push(`${x.toFixed(1)},${yG.toFixed(1)}`);
    }

    return {
      vPoints: vPoints.join(" "),
      iPoints: iPoints.join(" "),
      gPoints: gPoints.join(" "),
    };
  }, [systemState, faultTime, activeFault]);

  return (
    <div className="bg-white text-slate-800 border border-slate-200 rounded-xl overflow-hidden shadow-sm font-sans">
      {/* 1. TOP CONTROL BAR */}
      <div className="bg-white border-b border-slate-200 px-4 py-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center space-x-3">
          <div className="flex items-center space-x-2">
            <span className="h-2.5 w-2.5 rounded-full bg-[#0055A5] animate-pulse"></span>
            <span className="font-bold text-sm sm:text-base tracking-tight text-slate-900 font-mono">
              BCX14 LIVE PHYSICAL ELECTRICAL MODEL (V3)
            </span>
          </div>
          <span className="hidden sm:inline-block text-[11px] font-mono text-slate-500 border-l border-slate-200 pl-3">
            Simulation: <strong className="text-slate-800">0.35 s</strong> (Solver: <span className="text-[#0055A5] font-semibold">Simscape ode23t</span>)
          </span>
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
              <span className="text-[#0055A5] uppercase tracking-wider font-extrabold">
                BCX14 INTERACTIVE ENGINEERING ELECTRICAL TOPOLOGY (SCHEMATIC VIEW)
              </span>
              <span className="text-slate-500 text-[11px] font-normal">
                Click any component block to arm and inject hardware faults
              </span>
            </div>

            {/* Component Voltage/Current Status Overheads */}
            <div className="flex items-center justify-between text-[11px] font-mono font-semibold px-3 py-1.5 mb-2 bg-[#f8fafc] rounded-lg border border-slate-200 text-slate-700">
              <span className="text-[#0055A5]">XB11: 230V RMS (325.3Vpk)</span>
              <span className="text-sky-700">D2: 325.3V Rectified</span>
              <span className="text-slate-700">Q14: VDS=0.1V ID=0.8A</span>
              <span className="text-indigo-700">L13: 750µH (16.0A)</span>
              <span className="text-[#0055A5] font-extrabold bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
                DC LINK: UDC = {systemState === "FAULT_ACTIVE" ? activeFault.dcBusV.toFixed(1) : "395.2"} V
              </span>
            </div>
          </div>

          {/* Interactive Topology Diagram Canvas */}
          <div className="relative w-full h-[320px] bg-[#f8fafc] border border-slate-200 rounded-lg overflow-hidden flex items-center justify-center p-2 select-none shadow-inner">
            {/* SVG Connecting Wiring Bus Lines */}
            <svg className="absolute inset-0 w-full h-full pointer-events-none" viewBox="0 0 100 100" preserveAspectRatio="none">
              {/* AC Input lines to Bridge */}
              <line x1="14" y1="50" x2="17" y2="50" stroke="#0284c7" strokeWidth="1.5" />
              <line x1="14" y1="55" x2="17" y2="55" stroke="#0284c7" strokeWidth="1.5" />
              {/* Bridge to Precharge & Bypass split */}
              <line x1="25" y1="53" x2="28" y2="41" stroke="#0055A5" strokeWidth="1.5" />
              <line x1="25" y1="53" x2="28" y2="60" stroke="#0055A5" strokeWidth="1.5" />
              {/* Precharge & Bypass merge to PFC Choke */}
              <line x1="37" y1="41" x2="41" y2="52" stroke="#0055A5" strokeWidth="1.5" />
              <line x1="37" y1="60" x2="41" y2="52" stroke="#0055A5" strokeWidth="1.5" />
              {/* PFC Choke to Switch & MOV */}
              <line x1="49" y1="52" x2="54" y2="52" stroke="#0055A5" strokeWidth="1.5" />
              {/* Main +UDC High Voltage Rail (Gold) */}
              <line x1="54" y1="36" x2="88" y2="36" stroke="#d97706" strokeWidth="2.5" />
              {/* Capacitor Drops from +UDC */}
              <line x1="64" y1="36" x2="64" y2="44" stroke="#d97706" strokeWidth="1.5" />
              <line x1="68" y1="36" x2="68" y2="44" stroke="#d97706" strokeWidth="1.5" />
              <line x1="72" y1="36" x2="72" y2="44" stroke="#d97706" strokeWidth="1.5" />
              {/* Ground Reference -UDC Rail */}
              <line x1="17" y1="67" x2="88" y2="67" stroke="#64748b" strokeWidth="2.0" />
              {/* Gate Control connection */}
              <line x1="37" y1="78" x2="48" y2="78" stroke="#7c3aed" strokeWidth="1.2" strokeDasharray="2,2" />
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
                >
                  <div className={blk.shape === "diamond" ? "-rotate-45" : ""}>
                    <span
                      className={`text-[11px] font-extrabold block leading-tight ${
                        isSelected ? "text-amber-900" : "text-[#0055A5]"
                      }`}
                    >
                      {blk.label}
                    </span>
                    <span className="text-[9px] text-slate-500 block font-medium leading-none mt-0.5">
                      {blk.sublabel}
                    </span>
                  </div>
                </div>
              );
            })}

            {/* Labels on Diagram */}
            <span className="absolute right-4 top-8 text-xs font-mono font-bold text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200">
              +UDC
            </span>
            <span className="absolute right-4 bottom-7 text-xs font-mono font-bold text-slate-600 bg-slate-100 px-1.5 py-0.5 rounded border border-slate-200">
              -UDC
            </span>
          </div>

          {/* Bottom Annotation Legend */}
          <div className="flex items-center justify-between text-[11px] font-mono mt-2 text-slate-500">
            <span className="text-slate-700 font-semibold">Q23: 20kHz PWM Active Boost</span>
            <span className="text-[#0055A5] font-semibold">C82-C53: 5x Caps Bank (395.2V)</span>
            <span className="text-amber-700 font-semibold">RV3: MOV 385V Clamping</span>
          </div>
        </div>

        {/* Right Column: Component / Fault Inspector & Waveforms (4 cols) */}
        <div className="lg:col-span-4 p-4 bg-[#f8fafc] flex flex-col justify-between space-y-3">
          <div>
            <span className="text-xs font-bold text-[#0055A5] uppercase tracking-wider block font-mono">
              COMPONENT / FAULT INSPECTOR
            </span>

            {/* Select Component Dropdown */}
            <div className="mt-2.5">
              <label className="text-[11px] font-semibold text-slate-600 block mb-1 font-mono">
                Select Component:
              </label>
              <select
                value={selectedBlockId}
                onChange={(e) => setSelectedBlockId(e.target.value)}
                className="w-full bg-white border border-slate-300 rounded-lg px-2.5 py-1.5 text-xs text-slate-900 font-mono font-bold focus:outline-none focus:border-[#0055A5] shadow-2xs"
              >
                {blocks.map((b) => (
                  <option key={b.id} value={b.id}>
                    {b.id} &mdash; {b.type} ({b.label})
                  </option>
                ))}
              </select>
            </div>

            {/* Component Summary Card */}
            <div className="mt-2 bg-white border border-slate-200 rounded-lg p-2.5 text-[11px] font-mono space-y-1 shadow-2xs">
              <div>
                <span className="text-[#0055A5] font-bold">SELECTED: </span>
                <span className="text-slate-900 font-bold">{activeBlock.id} {activeBlock.type}</span>
              </div>
              <p className="text-slate-600 text-[10px] leading-tight">
                Description: {activeBlock.description}
              </p>
            </div>

            {/* Fault Selection Dropdown */}
            <div className="mt-2.5">
              <label className="text-[11px] font-semibold text-slate-600 block mb-1 font-mono">
                Fault Selection:
              </label>
              <select
                value={selectedFaultId}
                onChange={(e) => setSelectedFaultId(e.target.value)}
                className="w-full bg-white border border-amber-300 rounded-lg px-2.5 py-1.5 text-xs text-slate-900 font-mono font-bold focus:outline-none focus:border-amber-500 shadow-2xs"
              >
                {activeBlock.faultModes.map((fm) => (
                  <option key={fm.id} value={fm.id}>
                    {fm.label}
                  </option>
                ))}
              </select>
            </div>

            {/* Dual Action Buttons */}
            <div className="grid grid-cols-2 gap-2 mt-3 font-mono font-bold text-xs">
              <button
                onClick={handleArmFault}
                className="py-1.5 px-2 bg-amber-500 hover:bg-amber-600 text-white rounded-lg transition shadow-xs"
              >
                ARM FAULT
              </button>
              <button
                onClick={handleInjectFaultAndRun}
                className="py-1.5 px-2 bg-red-600 hover:bg-red-700 text-white rounded-lg transition shadow-xs flex items-center justify-center space-x-1"
              >
                <Flame className="w-3 h-3" />
                <span>INJECT + RUN</span>
              </button>
            </div>

            {/* Status Pill */}
            <div className="mt-2.5 p-2 bg-white rounded-lg border border-slate-200 text-center font-mono text-[11px] font-bold shadow-2xs">
              {systemState === "FAULT_ACTIVE" ? (
                <span className="text-red-700">
                  STATUS: FAULT ACTIVE | ACTION: {activeFault.action}
                </span>
              ) : systemState === "ARMED" ? (
                <span className="text-amber-700">
                  STATUS: ARMED (t = {faultTime}s) | READY TO TRIGGER
                </span>
              ) : (
                <span className="text-emerald-700">
                  STATUS: NORMAL | ACTION: NONE (NORMAL OPERATION)
                </span>
              )}
            </div>
          </div>

          {/* COMPONENT WAVEFORMS (3 Channel Oscilloscope) */}
          <div className="space-y-2 pt-2 border-t border-slate-200">
            <span className="text-[11px] font-bold text-slate-700 uppercase tracking-wider block font-mono">
              COMPONENT WAVEFORMS:
            </span>

            {/* Channel 1: VDC Voltage */}
            <div className="bg-white border border-slate-200 rounded-lg p-2 shadow-2xs">
              <div className="flex items-center justify-between text-[10px] font-mono text-[#0055A5] font-bold mb-1">
                <span>UDC(t) DC Bus Voltage [V] (Peak: {systemState === "FAULT_ACTIVE" ? activeFault.dcBusV.toFixed(1) : "395.2"}V)</span>
                <span className="text-slate-400">500V FS</span>
              </div>
              <svg className="w-full h-11" viewBox="0 0 380 45">
                <line x1="0" y1="10" x2="380" y2="10" stroke="#f1f5f9" strokeDasharray="3,3" />
                <line x1="0" y1="25" x2="380" y2="25" stroke="#f1f5f9" strokeDasharray="3,3" />
                <polyline fill="none" stroke="#0055A5" strokeWidth="2.2" points={waveformData.vPoints} />
              </svg>
            </div>

            {/* Channel 2: Component Current */}
            <div className="bg-white border border-slate-200 rounded-lg p-2 shadow-2xs">
              <div className="flex items-center justify-between text-[10px] font-mono text-amber-700 font-bold mb-1">
                <span>Component Current [A] (Peak: {systemState === "FAULT_ACTIVE" ? activeFault.currentA.toFixed(1) : "0.8"}A)</span>
                <span className="text-slate-400">50A FS</span>
              </div>
              <svg className="w-full h-11" viewBox="0 0 380 45">
                <line x1="0" y1="10" x2="380" y2="10" stroke="#f1f5f9" strokeDasharray="3,3" />
                <line x1="0" y1="25" x2="380" y2="25" stroke="#f1f5f9" strokeDasharray="3,3" />
                <polyline fill="none" stroke="#d97706" strokeWidth="2.2" points={waveformData.iPoints} />
              </svg>
            </div>

            {/* Channel 3: Gate Signal / Driver State */}
            <div className="bg-white border border-slate-200 rounded-lg p-2 shadow-2xs">
              <div className="flex items-center justify-between text-[10px] font-mono text-emerald-700 font-bold mb-1">
                <span>Gate Signal Vgate(t) / Driver State [V]</span>
                <span className="text-slate-400">20V FS</span>
              </div>
              <svg className="w-full h-11" viewBox="0 0 380 45">
                <line x1="0" y1="10" x2="380" y2="10" stroke="#f1f5f9" strokeDasharray="3,3" />
                <line x1="0" y1="25" x2="380" y2="25" stroke="#f1f5f9" strokeDasharray="3,3" />
                <polyline fill="none" stroke="#16a34a" strokeWidth="2.2" points={waveformData.gPoints} />
              </svg>
            </div>
          </div>
        </div>
      </div>

      {/* 4. BOTTOM THREE-COLUMN CONSOLE */}
      <div className="grid grid-cols-1 lg:grid-cols-3 divide-y lg:divide-y-0 lg:divide-x divide-slate-200 bg-white text-xs font-mono">
        {/* Panel 1: Simulation Event Timeline */}
        <div className="p-3.5 space-y-2">
          <span className="text-[11px] font-bold text-[#0055A5] uppercase tracking-wider block">
            SIMULATION EVENT TIMELINE
          </span>
          <div className="bg-slate-900 border border-slate-800 rounded-lg p-2.5 h-36 overflow-y-auto space-y-1 text-emerald-400 font-mono text-[11px] leading-relaxed shadow-inner">
            {logs.map((line, i) => (
              <div key={i} className="flex items-start space-x-1.5">
                <span className="text-slate-500">&gt;</span>
                <span className={line.includes("FAULT INJECTED") || line.includes("TRIPPED") ? "text-rose-400 font-bold" : ""}>
                  {line}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Panel 2: Before / After Simulation Comparison */}
        <div className="p-3.5 space-y-2">
          <span className="text-[11px] font-bold text-[#0055A5] uppercase tracking-wider block">
            BEFORE / AFTER SIMULATION COMPARISON
          </span>
          <div className="bg-white border border-slate-200 rounded-lg overflow-hidden h-36 shadow-2xs">
            <table className="w-full text-left text-[11px]">
              <thead className="bg-slate-50 text-slate-500 border-b border-slate-200 font-semibold">
                <tr>
                  <th className="py-1.5 px-3">Parameter</th>
                  <th className="py-1.5 px-3">Normal / Before</th>
                  <th className="py-1.5 px-3">Fault / After</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 text-slate-700">
                <tr>
                  <td className="py-1.5 px-3 text-slate-500">DC Bus Voltage (UDC)</td>
                  <td className="py-1.5 px-3 font-bold text-emerald-700">395.20 V</td>
                  <td className={`py-1.5 px-3 font-bold ${systemState === "FAULT_ACTIVE" ? "text-red-700" : "text-emerald-700"}`}>
                    {systemState === "FAULT_ACTIVE" ? `${activeFault.dcBusV.toFixed(2)} V` : "395.20 V"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 px-3 text-slate-500">Component Health State</td>
                  <td className="py-1.5 px-3 text-emerald-700 font-bold">NORMAL</td>
                  <td className={`py-1.5 px-3 font-bold ${systemState === "FAULT_ACTIVE" ? "text-red-700" : "text-emerald-700"}`}>
                    {systemState === "FAULT_ACTIVE" ? activeFault.finalState : "NORMAL"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 px-3 text-slate-500">Protection Action</td>
                  <td className="py-1.5 px-3 text-slate-500">NONE</td>
                  <td className={`py-1.5 px-3 font-bold ${systemState === "FAULT_ACTIVE" ? "text-amber-700" : "text-slate-500"}`}>
                    {systemState === "FAULT_ACTIVE" ? activeFault.action : "NONE (NORMAL OPERATION)"}
                  </td>
                </tr>
                <tr>
                  <td className="py-1.5 px-3 text-slate-500">Unconstrained Peak</td>
                  <td className="py-1.5 px-3 text-slate-500">0.80 A</td>
                  <td className={`py-1.5 px-3 font-bold ${systemState === "FAULT_ACTIVE" ? "text-amber-700" : "text-slate-500"}`}>
                    {systemState === "FAULT_ACTIVE" ? `${activeFault.currentA.toFixed(2)} A` : "0.80 A"}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        {/* Panel 3: Simulation Results & Fault History */}
        <div className="p-3.5 space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-[#0055A5] uppercase tracking-wider block">
              SIMULATION RESULTS &amp; FAULT HISTORY
            </span>
            <div className="flex items-center space-x-1">
              <span className="text-[10px] text-slate-500">Past Runs:</span>
              <span className="text-[10px] text-[#0055A5] bg-blue-50 px-1.5 py-0.5 rounded border border-blue-200 font-bold">
                {historyRuns.length > 0 ? `${historyRuns.length} recorded` : "No runs yet"}
              </span>
            </div>
          </div>

          <div className="bg-slate-50 border border-slate-200 rounded-lg p-2.5 h-36 overflow-y-auto text-[11px] font-mono text-slate-700 space-y-1 shadow-2xs">
            <div className="text-slate-400">=============================================</div>
            <div>
              <span className="text-slate-500">SIMULATION RESULT: </span>
              <span className={`font-bold ${systemState === "FAULT_ACTIVE" ? "text-red-700" : "text-emerald-700"}`}>
                {systemState === "FAULT_ACTIVE" ? "FAULT INJECTED" : "NORMAL"}
              </span>
            </div>
            <div>
              <span className="text-slate-500">ACTIVE COMPONENT: </span>
              <span className="text-[#0055A5] font-bold">{activeBlock.id} ({activeBlock.type})</span>
            </div>
            <div>
              <span className="text-slate-500">FAULT MODE: </span>
              <span className="text-amber-700 font-bold">{activeFault.label}</span>
            </div>
            <div>
              <span className="text-slate-500">FINAL STATE: </span>
              <span className="text-slate-900 font-bold">{systemState === "FAULT_ACTIVE" ? activeFault.finalState : "NORMAL"}</span>
            </div>
            <div>
              <span className="text-slate-500">PROTECTION ACTION: </span>
              <span className="text-sky-700 font-bold">{systemState === "FAULT_ACTIVE" ? activeFault.action : "NONE"}</span>
            </div>
            <div className="text-slate-400">=============================================</div>
          </div>
        </div>
      </div>
    </div>
  );
};
