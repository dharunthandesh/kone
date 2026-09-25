"use client";

import React, { useState, useEffect, useMemo } from "react";
import {
  Zap,
  ShieldAlert,
  AlertTriangle,
  CheckCircle2,
  Activity,
  Sliders,
  RefreshCw,
  Download,
  FileSpreadsheet,
  Key,
  Flame,
  Settings,
  HelpCircle,
  TrendingDown,
  TrendingUp,
  Cpu,
  Layers,
  ChevronRight,
  Code2,
  FileCode,
  ExternalLink,
} from "lucide-react";
import {
  ComponentFault,
  FMEAReport,
  FaultCriticality,
  MatlabSettings,
  UniversalCircuitIR,
} from "../types/circuit";
import { api } from "../lib/api";

interface FaultInjectionPanelProps {
  projectId: string;
  circuitIr?: UniversalCircuitIR;
  onRefresh?: () => void;
}

export const FaultInjectionPanel: React.FC<FaultInjectionPanelProps> = ({
  projectId,
  circuitIr,
  onRefresh,
}) => {
  // Campaign State
  const [isRunning, setIsRunning] = useState(false);
  const [report, setReport] = useState<FMEAReport | null>(null);
  const [selectedFault, setSelectedFault] = useState<ComponentFault | null>(null);
  const [severityFilter, setSeverityFilter] = useState<string>("ALL");
  const [searchQuery, setSearchQuery] = useState("");

  // MATLAB Settings State
  const [matlabSettings, setMatlabSettings] = useState<MatlabSettings | null>(null);
  const [showKeyModal, setShowKeyModal] = useState(false);
  const [apiKeyInput, setApiKeyInput] = useState("");
  const [savingKey, setSavingKey] = useState(false);

  // Single Interactive Fault Sandbox State
  const [sandboxCompId, setSandboxCompId] = useState<string>("");
  const [sandboxFaultType, setSandboxFaultType] = useState<string>("SHORT_CIRCUIT");
  const [sandboxCustomVal, setSandboxCustomVal] = useState<string>("");
  const [isInjectingSingle, setIsInjectingSingle] = useState(false);

  // Load existing report and MATLAB settings on mount
  useEffect(() => {
    let isMounted = true;

    async function loadData() {
      try {
        const [settingsData, faultData] = await Promise.all([
          api.getMatlabSettings().catch(() => null),
          api.getFaultResults(projectId).catch(() => null),
        ]);

        if (!isMounted) return;

        if (settingsData) {
          setMatlabSettings(settingsData);
          if (settingsData.masked_api_key && settingsData.masked_api_key !== "Not Set") {
            setApiKeyInput(settingsData.masked_api_key);
          }
        }

        if (faultData && faultData.has_report && faultData.faults?.length > 0) {
          setReport(faultData);
          setSelectedFault(faultData.faults[0]);
        }
      } catch (err) {
        console.error("Failed to load fault injection data", err);
      }
    }

    loadData();
    return () => {
      isMounted = false;
    };
  }, [projectId]);

  // Set default sandbox component
  useEffect(() => {
    if (circuitIr?.components && circuitIr.components.length > 0 && !sandboxCompId) {
      const firstValid = circuitIr.components.find((c) => c.type !== "ground");
      if (firstValid) {
        setSandboxCompId(firstValid.id);
      }
    }
  }, [circuitIr, sandboxCompId]);

  // Run full autonomous campaign
  const handleRunAutonomousSuite = async () => {
    setIsRunning(true);
    try {
      const res = await api.runFaultInjection(projectId);
      setReport(res);
      if (res.faults && res.faults.length > 0) {
        setSelectedFault(res.faults[0]);
      }
      if (onRefresh) onRefresh();
    } catch (err: any) {
      alert(`Fault campaign failed: ${err.message}`);
    } finally {
      setIsRunning(false);
    }
  };

  // Inject single custom fault
  const handleInjectSingle = async () => {
    if (!sandboxCompId) return;
    setIsInjectingSingle(true);
    try {
      const customNum = sandboxCustomVal ? parseFloat(sandboxCustomVal) : undefined;
      const faultResult = await api.injectSingleFault(
        projectId,
        sandboxCompId,
        sandboxFaultType,
        customNum
      );
      setSelectedFault(faultResult);

      // Prepend or update in report if report exists
      if (report) {
        const existingIdx = report.faults.findIndex((f) => f.fault_id === faultResult.fault_id);
        let updatedFaults = [...report.faults];
        if (existingIdx >= 0) {
          updatedFaults[existingIdx] = faultResult;
        } else {
          updatedFaults = [faultResult, ...updatedFaults];
        }
        setReport({
          ...report,
          faults: updatedFaults,
        });
      }
    } catch (err: any) {
      alert(`Single fault injection failed: ${err.message}`);
    } finally {
      setIsInjectingSingle(false);
    }
  };

  // Save MATLAB API Key
  const handleSaveApiKey = async () => {
    setSavingKey(true);
    try {
      await api.updateMatlabSettings({ api_key: apiKeyInput });
      const updated = await api.getMatlabSettings();
      setMatlabSettings(updated);
      setShowKeyModal(false);
    } catch (err: any) {
      alert(`Failed to save MATLAB API Key: ${err.message}`);
    } finally {
      setSavingKey(false);
    }
  };

  // Export FMEA CSV
  const handleExportCsv = async () => {
    try {
      const res = await api.exportFMEAReport(projectId, "csv");
      const blob = new Blob([res.csv], { type: "text/csv;charset=utf-8;" });
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.href = url;
      link.setAttribute("download", res.filename || "FMEA_Report.csv");
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } catch (err: any) {
      alert(`Export failed: ${err.message}`);
    }
  };

  // Filtered faults list
  const filteredFaults = useMemo(() => {
    if (!report?.faults) return [];
    return report.faults.filter((f) => {
      const matchesSeverity =
        severityFilter === "ALL" || f.criticality === severityFilter;
      const matchesSearch =
        searchQuery === "" ||
        f.fault_id.toLowerCase().includes(searchQuery.toLowerCase()) ||
        f.component_id.toLowerCase().includes(searchQuery.toLowerCase()) ||
        f.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
        f.effects.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesSeverity && matchesSearch;
    });
  }, [report, severityFilter, searchQuery]);

  return (
    <div className="space-y-6">
      {/* 1. TOP HEADER & MATLAB STATUS BAR */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xl">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
          <div className="flex items-center space-x-3.5">
            <div className="p-3 bg-gradient-to-tr from-amber-500/20 to-rose-500/20 border border-amber-500/30 rounded-xl text-amber-400">
              <Flame className="w-6 h-6 animate-pulse" />
            </div>
            <div>
              <div className="flex items-center space-x-2.5">
                <h2 className="text-xl font-bold text-white tracking-tight">
                  Autonomous Fault Injection & FMEA Engine
                </h2>
                <span className="px-2 py-0.5 text-xs font-semibold rounded-full bg-indigo-500/20 text-indigo-300 border border-indigo-500/30">
                  ISO 26262 / MIL-STD-1629A
                </span>
              </div>
              <p className="text-sm text-slate-400 mt-0.5">
                Autonomously synthesizes hardware component faults, computes baseline vs. fault waveforms, and validates safety thresholds.
              </p>
            </div>
          </div>

          {/* MATLAB Connectivity Capsule */}
          <div className="flex items-center flex-wrap gap-2.5 bg-slate-950/70 border border-slate-800 px-3.5 py-2 rounded-lg text-xs">
            <div className="flex items-center space-x-2">
              <span className="relative flex h-2.5 w-2.5">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
              </span>
              <span className="font-medium text-slate-200">
                {matlabSettings?.version ? `MATLAB ${matlabSettings.version.split(" ")[0]} Simscape` : "Simscape Connected"}
              </span>
            </div>
            <span className="text-slate-600">|</span>
            <div className="flex items-center space-x-1.5 text-slate-400">
              <Key className="w-3.5 h-3.5 text-amber-400" />
              <span>Key:</span>
              <span className="font-mono text-slate-300 font-semibold">
                {matlabSettings?.masked_api_key || "Configured"}
              </span>
            </div>
            <button
              onClick={() => setShowKeyModal(true)}
              className="text-indigo-400 hover:text-indigo-300 underline font-medium ml-1 transition"
            >
              Configure
            </button>
          </div>
        </div>

        {/* Action Bar */}
        <div className="mt-5 pt-4 border-t border-slate-800/80 flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-2.5">
            <button
              onClick={handleRunAutonomousSuite}
              disabled={isRunning || !circuitIr?.components?.length}
              className={`px-5 py-2.5 rounded-lg font-semibold text-sm flex items-center space-x-2 shadow-lg transition ${
                isRunning
                  ? "bg-slate-700 text-slate-400 cursor-not-allowed"
                  : "bg-gradient-to-r from-amber-500 via-orange-500 to-rose-600 hover:from-amber-600 hover:to-rose-700 text-white shadow-amber-500/20 active:scale-95"
              }`}
            >
              <Zap className={`w-4 h-4 ${isRunning ? "animate-spin" : ""}`} />
              <span>{isRunning ? "Simulating Autonomous Faults..." : "Run Autonomous Fault Injection Suite"}</span>
            </button>

            {report && (
              <>
                <a
                  href={api.getFaultMatlabScriptUrl(projectId)}
                  download
                  className="px-3.5 py-2 rounded-lg bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 text-xs font-medium flex items-center space-x-1.5 transition"
                >
                  <FileCode className="w-3.5 h-3.5 text-indigo-400" />
                  <span>Download Simscape Script (.m)</span>
                </a>
                <button
                  onClick={handleExportCsv}
                  className="px-3.5 py-2 rounded-lg bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 text-xs font-medium flex items-center space-x-1.5 transition"
                >
                  <FileSpreadsheet className="w-3.5 h-3.5 text-emerald-400" />
                  <span>Export FMEA (CSV)</span>
                </button>
              </>
            )}
          </div>

          <div className="text-xs text-slate-400 flex items-center space-x-2">
            <Layers className="w-4 h-4 text-slate-500" />
            <span>Target Circuit: <strong className="text-slate-200">{circuitIr?.title || "Active Schematic"}</strong> ({circuitIr?.components?.length || 0} Components)</span>
          </div>
        </div>
      </div>

      {/* 2. KPI EXECUTIVE METRIC CARDS */}
      {report && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3.5">
          <div className="bg-slate-900/90 border border-slate-800 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-medium text-slate-400">Total Faults Simulated</span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-bold text-white">{report.total_faults_simulated}</span>
              <span className="text-xs text-slate-500 font-mono">modes</span>
            </div>
            <span className="text-[11px] text-slate-500 mt-1">Across all detected components</span>
          </div>

          <div className="bg-slate-900/90 border border-slate-800 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-medium text-slate-400">Safety Robustness Score</span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className={`text-2xl font-bold ${report.safety_score > 60 ? "text-emerald-400" : "text-amber-400"}`}>
                {report.safety_score}%
              </span>
              <span className="text-xs text-slate-500 font-mono">SIL-2 index</span>
            </div>
            <div className="w-full bg-slate-800 h-1.5 rounded-full mt-2 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-rose-500 via-amber-500 to-emerald-400"
                style={{ width: `${Math.min(report.safety_score, 100)}%` }}
              />
            </div>
          </div>

          <div className="bg-slate-900/90 border border-rose-900/30 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-medium text-rose-300 flex items-center space-x-1.5">
              <Flame className="w-3.5 h-3.5 text-rose-400" />
              <span>Critical Hazards</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-bold text-rose-400">{report.critical_count}</span>
              <span className="text-xs text-rose-500/80 font-mono">urgent</span>
            </div>
            <span className="text-[11px] text-rose-400/70 mt-1">Overcurrent / clamp saturation</span>
          </div>

          <div className="bg-slate-900/90 border border-amber-900/30 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-medium text-amber-300 flex items-center space-x-1.5">
              <AlertTriangle className="w-3.5 h-3.5 text-amber-400" />
              <span>Degraded / Warnings</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-bold text-amber-400">{report.warning_count}</span>
              <span className="text-xs text-amber-500/80 font-mono">warnings</span>
            </div>
            <span className="text-[11px] text-amber-400/70 mt-1">Parameter drift &gt; 15%</span>
          </div>

          <div className="bg-slate-900/90 border border-emerald-900/30 rounded-xl p-4 flex flex-col justify-between">
            <span className="text-xs font-medium text-emerald-300 flex items-center space-x-1.5">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400" />
              <span>Safe / Tolerated</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-bold text-emerald-400">{report.safe_count}</span>
              <span className="text-xs text-emerald-500/80 font-mono">mitigated</span>
            </div>
            <span className="text-[11px] text-emerald-400/70 mt-1">Graceful shutdown / within bounds</span>
          </div>
        </div>
      )}

      {/* 3. INTERACTIVE TESTING SANDBOX & WAVEFORM COMPARATOR */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Interactive Single Fault Injection Box */}
        <div className="lg:col-span-4 bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xl flex flex-col justify-between space-y-4">
          <div>
            <div className="flex items-center space-x-2">
              <Sliders className="w-4 h-4 text-amber-400" />
              <h3 className="font-bold text-white text-sm">Interactive Fault Injection Sandbox</h3>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Select any component on the schematic to test its immediate failure transient.
            </p>
          </div>

          <div className="space-y-3.5">
            <div>
              <label className="text-xs font-semibold text-slate-300 block mb-1">
                Select Target Component
              </label>
              <select
                value={sandboxCompId}
                onChange={(e) => setSandboxCompId(e.target.value)}
                className="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-amber-500 font-mono"
              >
                {circuitIr?.components?.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.id} ({c.type}) {c.name ? `- ${c.name}` : ""}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="text-xs font-semibold text-slate-300 block mb-1">
                Failure Mode
              </label>
              <select
                value={sandboxFaultType}
                onChange={(e) => setSandboxFaultType(e.target.value)}
                className="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-amber-500 font-mono"
              >
                <option value="SHORT_CIRCUIT">SHORT CIRCUIT (R -&gt; 0.001 Ω)</option>
                <option value="OPEN_CIRCUIT">OPEN CIRCUIT (R -&gt; 1 GΩ)</option>
                <option value="PARAMETRIC_DRIFT_HIGH">+50% Parametric Drift</option>
                <option value="PARAMETRIC_DRIFT_LOW">-50% Parametric Drift</option>
                <option value="STUCK_AT_RAIL_HIGH">Stuck at High Rail (+15V)</option>
                <option value="STUCK_AT_RAIL_LOW">Stuck at Low Rail (0V)</option>
                <option value="VOLTAGE_SAG">-50% Supply Voltage Sag</option>
                <option value="OVERVOLTAGE_SURGE">+50% Overvoltage Surge</option>
              </select>
            </div>

            <div>
              <label className="text-xs font-semibold text-slate-300 block mb-1">
                Custom Fault Parameter <span className="text-slate-500 font-normal">(Optional Override)</span>
              </label>
              <input
                type="number"
                placeholder="e.g. 0.05 or 1000000"
                value={sandboxCustomVal}
                onChange={(e) => setSandboxCustomVal(e.target.value)}
                className="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-xs text-white placeholder-slate-600 focus:outline-none focus:border-amber-500 font-mono"
              />
            </div>
          </div>

          <button
            onClick={handleInjectSingle}
            disabled={isInjectingSingle || !sandboxCompId}
            className="w-full py-2.5 px-4 rounded-lg bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white font-semibold text-xs flex items-center justify-center space-x-2 transition shadow-lg shadow-amber-500/10 active:scale-98"
          >
            <Zap className={`w-3.5 h-3.5 ${isInjectingSingle ? "animate-spin" : ""}`} />
            <span>{isInjectingSingle ? "Injecting Fault..." : "Inject Fault & Re-simulate"}</span>
          </button>
        </div>

        {/* Right Column: Live Transient Waveform Comparison */}
        <div className="lg:col-span-8 bg-slate-900 border border-slate-800 rounded-xl p-5 shadow-xl flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between flex-wrap gap-2">
              <div className="flex items-center space-x-2">
                <Activity className="w-4 h-4 text-indigo-400" />
                <h3 className="font-bold text-white text-sm">
                  Transient Waveform Comparator: Healthy Baseline vs. Injected Fault
                </h3>
              </div>
              {selectedFault && (
                <span
                  className={`px-2.5 py-0.5 rounded-full text-xs font-bold border ${
                    selectedFault.criticality === "CRITICAL"
                      ? "bg-rose-500/20 text-rose-300 border-rose-500/40"
                      : selectedFault.criticality === "WARNING"
                      ? "bg-amber-500/20 text-amber-300 border-amber-500/40"
                      : "bg-emerald-500/20 text-emerald-300 border-emerald-500/40"
                  }`}
                >
                  {selectedFault.criticality} HAZARD
                </span>
              )}
            </div>

            {selectedFault && (
              <p className="text-xs text-slate-400 mt-1">
                Active Test: <strong className="text-white">{selectedFault.fault_id}</strong> &mdash; {selectedFault.description}
              </p>
            )}
          </div>

          {/* SVG Waveform Visualizer */}
          <div className="my-4 bg-slate-950 border border-slate-800 rounded-xl p-4 relative overflow-hidden">
            {selectedFault?.waveform && selectedFault.waveform.time.length > 0 ? (
              <div className="space-y-3">
                <div className="flex items-center justify-between text-[11px] text-slate-400">
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center space-x-1.5">
                      <span className="w-3 h-0.5 bg-blue-400 rounded-full inline-block"></span>
                      <span>Healthy Nominal Voltage</span>
                    </div>
                    <div className="flex items-center space-x-1.5">
                      <span className="w-3 h-0.5 bg-rose-500 rounded-full inline-block"></span>
                      <span>Fault Injected Response</span>
                    </div>
                  </div>
                  <div className="font-mono text-slate-500">
                    Duration: {selectedFault.waveform.time[selectedFault.waveform.time.length - 1]} ms
                  </div>
                </div>

                {/* SVG Render */}
                <svg
                  className="w-full h-44 overflow-visible"
                  viewBox="0 0 500 150"
                  preserveAspectRatio="none"
                >
                  <defs>
                    <linearGradient id="faultGlow" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#f43f5e" stopOpacity="0.3" />
                      <stop offset="100%" stopColor="#f43f5e" stopOpacity="0.0" />
                    </linearGradient>
                  </defs>

                  {/* Grid Lines */}
                  <line x1="0" y1="30" x2="500" y2="30" stroke="#1e293b" strokeDasharray="3,3" />
                  <line x1="0" y1="75" x2="500" y2="75" stroke="#1e293b" strokeDasharray="3,3" />
                  <line x1="0" y1="120" x2="500" y2="120" stroke="#1e293b" strokeDasharray="3,3" />

                  {/* Baseline Curve (Blue) */}
                  {(() => {
                    const times = selectedFault.waveform.time;
                    const baseVals = selectedFault.waveform.baseline;
                    const faultVals = selectedFault.waveform.fault;
                    const maxVal = Math.max(...baseVals, ...faultVals, 1.0);
                    const minVal = Math.min(...baseVals, ...faultVals, 0.0);
                    const range = maxVal - minVal || 1.0;

                    const getY = (val: number) => 135 - ((val - minVal) / range) * 115;
                    const getX = (idx: number) => (idx / (times.length - 1)) * 500;

                    const basePoints = baseVals
                      .map((v, i) => `${getX(i).toFixed(1)},${getY(v).toFixed(1)}`)
                      .join(" ");

                    const faultPoints = faultVals
                      .map((v, i) => `${getX(i).toFixed(1)},${getY(v).toFixed(1)}`)
                      .join(" ");

                    return (
                      <>
                        <polyline
                          fill="none"
                          stroke="#3b82f6"
                          strokeWidth="2.5"
                          strokeLinecap="round"
                          points={basePoints}
                        />
                        <polyline
                          fill="none"
                          stroke="#f43f5e"
                          strokeWidth="2.5"
                          strokeDasharray={selectedFault.criticality === "CRITICAL" ? "none" : "4,2"}
                          strokeLinecap="round"
                          points={faultPoints}
                        />
                      </>
                    );
                  })()}
                </svg>

                {/* Metrics bar */}
                <div className="grid grid-cols-3 gap-2 pt-2 border-t border-slate-800/80 text-[11px]">
                  <div>
                    <span className="text-slate-500">Peak Voltage Deviation:</span>
                    <span className="ml-1.5 font-bold font-mono text-white">
                      {selectedFault.metrics?.peak_deviation_v ?? 0} V
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-500">RMS Error:</span>
                    <span className="ml-1.5 font-bold font-mono text-white">
                      {selectedFault.metrics?.rms_error_v ?? 0} V
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-500">Risk Priority (RPN):</span>
                    <span className="ml-1.5 font-bold font-mono text-amber-400">
                      {selectedFault.rpn} / 1000
                    </span>
                  </div>
                </div>
              </div>
            ) : (
              <div className="h-44 flex flex-col items-center justify-center text-slate-500 text-xs">
                <Activity className="w-8 h-8 mb-2 text-slate-600" />
                <span>No waveform data available. Click "Run Autonomous Fault Injection Suite" above.</span>
              </div>
            )}
          </div>

          {/* Failure Effect & Mitigation callout */}
          {selectedFault && (
            <div className="bg-slate-950/60 border border-slate-800 rounded-lg p-3 text-xs space-y-1.5">
              <div>
                <span className="text-slate-400 font-semibold">Circuit Impact: </span>
                <span className="text-slate-200">{selectedFault.effects}</span>
              </div>
              <div>
                <span className="text-emerald-400 font-semibold">Recommended Design Mitigation: </span>
                <span className="text-slate-300">{selectedFault.mitigation}</span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* 4. COMPREHENSIVE FMEA MATRIX TABLE */}
      {report && (
        <div className="bg-slate-900 border border-slate-800 rounded-xl overflow-hidden shadow-xl">
          <div className="p-4 border-b border-slate-800 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div className="flex items-center space-x-2">
              <ShieldAlert className="w-4 h-4 text-amber-400" />
              <h3 className="font-bold text-white text-sm">
                FMEA Failure Modes & Effects Analysis Matrix ({filteredFaults.length} tests)
              </h3>
            </div>

            {/* Filter buttons & Search */}
            <div className="flex items-center flex-wrap gap-2">
              <input
                type="text"
                placeholder="Search component or effect..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="bg-slate-950 border border-slate-700 rounded-lg px-2.5 py-1 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500"
              />

              <div className="flex items-center bg-slate-950 p-1 rounded-lg border border-slate-800 text-xs">
                {["ALL", "CRITICAL", "WARNING", "SAFE"].map((level) => (
                  <button
                    key={level}
                    onClick={() => setSeverityFilter(level)}
                    className={`px-2.5 py-1 rounded font-medium transition ${
                      severityFilter === level
                        ? "bg-slate-800 text-white font-semibold"
                        : "text-slate-400 hover:text-slate-200"
                    }`}
                  >
                    {level}
                  </button>
                ))}
              </div>
            </div>
          </div>

          <div className="overflow-x-auto max-h-96">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-950/80 text-slate-400 font-semibold border-b border-slate-800 sticky top-0 backdrop-blur-sm z-10">
                <tr>
                  <th className="py-2.5 px-3">Fault ID</th>
                  <th className="py-2.5 px-3">Component</th>
                  <th className="py-2.5 px-3">Mode</th>
                  <th className="py-2.5 px-3">Injected Value</th>
                  <th className="py-2.5 px-3">Severity & Effects</th>
                  <th className="py-2.5 px-3">RPN</th>
                  <th className="py-2.5 px-3">Criticality</th>
                  <th className="py-2.5 px-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/60 text-slate-300">
                {filteredFaults.map((flt) => {
                  const isSelected = selectedFault?.fault_id === flt.fault_id;
                  return (
                    <tr
                      key={flt.fault_id}
                      onClick={() => setSelectedFault(flt)}
                      className={`cursor-pointer transition hover:bg-slate-800/40 ${
                        isSelected ? "bg-indigo-950/30 border-l-2 border-indigo-500" : ""
                      }`}
                    >
                      <td className="py-2.5 px-3 font-mono font-semibold text-slate-200">
                        {flt.fault_id}
                      </td>
                      <td className="py-2.5 px-3">
                        <span className="font-semibold text-white">{flt.component_id}</span>
                        <span className="text-[10px] text-slate-500 block">{flt.component_type}</span>
                      </td>
                      <td className="py-2.5 px-3 font-mono text-[11px] text-amber-300">
                        {flt.fault_type}
                      </td>
                      <td className="py-2.5 px-3 font-mono text-slate-400">
                        {flt.nominal_value} &rarr; <strong className="text-white">{flt.fault_value} {flt.unit}</strong>
                      </td>
                      <td className="py-2.5 px-3 max-w-xs truncate" title={flt.effects}>
                        {flt.effects}
                      </td>
                      <td className="py-2.5 px-3 font-mono font-bold text-amber-400">
                        {flt.rpn}
                      </td>
                      <td className="py-2.5 px-3">
                        <span
                          className={`px-2 py-0.5 rounded text-[10px] font-bold border ${
                            flt.criticality === "CRITICAL"
                              ? "bg-rose-500/20 text-rose-300 border-rose-500/40"
                              : flt.criticality === "WARNING"
                              ? "bg-amber-500/20 text-amber-300 border-amber-500/40"
                              : "bg-emerald-500/20 text-emerald-300 border-emerald-500/40"
                          }`}
                        >
                          {flt.criticality}
                        </span>
                      </td>
                      <td className="py-2.5 px-3 text-right">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedFault(flt);
                          }}
                          className="px-2 py-1 rounded bg-slate-800 hover:bg-slate-700 text-indigo-300 font-medium text-[11px] transition"
                        >
                          View Waveform
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* 5. MODAL: CONFIGURE MATLAB API KEY & EXECUTION ENGINE */}
      {showKeyModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/75 backdrop-blur-sm p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-xl p-6 max-w-md w-full shadow-2xl space-y-4">
            <div className="flex items-center space-x-2.5">
              <Key className="w-5 h-5 text-amber-400" />
              <h3 className="text-lg font-bold text-white">MATLAB & MathWorks API Configuration</h3>
            </div>

            <p className="text-xs text-slate-400 leading-relaxed">
              Circuit2Sim interacts with MATLAB Simscape Electrical directly. Configure your MathWorks Account Token, MATLAB Production Server API Key, or use the local Simscape installation.
            </p>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-300 block mb-1">
                  MATLAB / MathWorks API Key
                </label>
                <input
                  type="text"
                  placeholder="e.g. mw-live-sim-88f921a4c"
                  value={apiKeyInput}
                  onChange={(e) => setApiKeyInput(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-xs text-white focus:outline-none focus:border-amber-500 font-mono"
                />
              </div>

              <div className="bg-slate-950 border border-slate-800 rounded-lg p-3 text-xs space-y-1">
                <span className="font-semibold text-slate-300 block">Detected Toolboxes:</span>
                <ul className="text-slate-400 list-disc list-inside space-y-0.5">
                  {matlabSettings?.toolboxes?.map((t) => (
                    <li key={t.name}>
                      {t.name} &mdash; <strong className="text-slate-300">{t.version}</strong> ({t.status})
                    </li>
                  )) || <li>MATLAB R2026a Simscape Electrical</li>}
                </ul>
              </div>
            </div>

            <div className="flex items-center justify-end space-x-3 pt-3 border-t border-slate-800">
              <button
                onClick={() => setShowKeyModal(false)}
                className="px-4 py-2 rounded-lg bg-slate-800 text-slate-300 hover:bg-slate-700 text-xs font-medium transition"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveApiKey}
                disabled={savingKey}
                className="px-4 py-2 rounded-lg bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white text-xs font-semibold transition"
              >
                {savingKey ? "Saving..." : "Save Key & Verify"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
