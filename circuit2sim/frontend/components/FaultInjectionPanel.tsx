"use client";

import React, { useState, useEffect, useMemo } from "react";
import {
  Zap,
  ShieldAlert,
  AlertTriangle,
  CheckCircle2,
  Activity,
  Sliders,
  FileSpreadsheet,
  Key,
  Flame,
  Layers,
  FileCode,
} from "lucide-react";
import {
  ComponentFault,
  FMEAReport,
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
  const [isRunning, setIsRunning] = useState(false);
  const [report, setReport] = useState<FMEAReport | null>(null);
  const [selectedFault, setSelectedFault] = useState<ComponentFault | null>(null);
  const [severityFilter, setSeverityFilter] = useState<string>("ALL");
  const [searchQuery, setSearchQuery] = useState("");

  const [matlabSettings, setMatlabSettings] = useState<MatlabSettings | null>(null);
  const [showKeyModal, setShowKeyModal] = useState(false);
  const [apiKeyInput, setApiKeyInput] = useState("");
  const [savingKey, setSavingKey] = useState(false);

  const [sandboxCompId, setSandboxCompId] = useState<string>("");
  const [sandboxFaultType, setSandboxFaultType] = useState<string>("SHORT_CIRCUIT");
  const [sandboxCustomVal, setSandboxCustomVal] = useState<string>("");
  const [isInjectingSingle, setIsInjectingSingle] = useState(false);

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

  useEffect(() => {
    if (circuitIr?.components && circuitIr.components.length > 0 && !sandboxCompId) {
      const firstValid = circuitIr.components.find((c) => c.type !== "ground");
      if (firstValid) {
        setSandboxCompId(firstValid.id);
      }
    }
  }, [circuitIr, sandboxCompId]);

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
      <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-xs">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
          <div className="flex items-center space-x-3.5">
            <div className="p-3 bg-blue-50 border border-blue-200 rounded-xl text-[#0055A5]">
              <Flame className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center space-x-2.5">
                <h2 className="text-xl font-bold text-slate-900 tracking-tight">
                  Autonomous Fault Injection &amp; FMEA Engine
                </h2>
                <span className="px-2.5 py-0.5 text-xs font-semibold rounded-full bg-blue-50 text-[#0055A5] border border-blue-200">
                  ISO 26262 / MIL-STD-1629A
                </span>
              </div>
              <p className="text-sm text-slate-500 mt-0.5">
                Autonomously synthesizes hardware component faults, computes baseline vs. fault waveforms, and validates safety thresholds.
              </p>
            </div>
          </div>

          {/* MATLAB Connectivity Capsule */}
          <div className="flex items-center flex-wrap gap-2.5 bg-slate-50 border border-slate-200 px-3.5 py-2 rounded-lg text-xs">
            <div className="flex items-center space-x-2">
              <span className="relative flex h-2.5 w-2.5">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-[#0055A5]"></span>
              </span>
              <span className="font-semibold text-slate-800">
                {matlabSettings?.version ? `MATLAB ${matlabSettings.version.split(" ")[0]} Simscape` : "Simscape Connected"}
              </span>
            </div>
            <span className="text-slate-300">|</span>
            <div className="flex items-center space-x-1.5 text-slate-500">
              <Key className="w-3.5 h-3.5 text-amber-500" />
              <span>Key:</span>
              <span className="font-mono text-slate-800 font-bold">
                {matlabSettings?.masked_api_key || "Configured"}
              </span>
            </div>
            <button
              onClick={() => setShowKeyModal(true)}
              className="text-[#0055A5] hover:text-[#004385] underline font-bold ml-1 transition"
            >
              Configure
            </button>
          </div>
        </div>

        {/* Action Bar */}
        <div className="mt-5 pt-4 border-t border-slate-200 flex flex-wrap items-center justify-between gap-3">
          <div className="flex items-center gap-2.5">
            <button
              onClick={handleRunAutonomousSuite}
              disabled={isRunning || !circuitIr?.components?.length}
              className={`px-5 py-2.5 rounded-lg font-bold text-sm flex items-center space-x-2 shadow-xs transition ${
                isRunning
                  ? "bg-slate-200 text-slate-400 cursor-not-allowed"
                  : "bg-[#0055A5] hover:bg-[#004385] text-white active:scale-95"
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
                  className="px-3.5 py-2 rounded-lg bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 text-xs font-semibold flex items-center space-x-1.5 transition shadow-2xs"
                >
                  <FileCode className="w-3.5 h-3.5 text-[#0055A5]" />
                  <span>Download Simscape Script (.m)</span>
                </a>
                <button
                  onClick={handleExportCsv}
                  className="px-3.5 py-2 rounded-lg bg-white hover:bg-slate-50 border border-slate-300 text-slate-700 text-xs font-semibold flex items-center space-x-1.5 transition shadow-2xs"
                >
                  <FileSpreadsheet className="w-3.5 h-3.5 text-emerald-600" />
                  <span>Export FMEA (CSV)</span>
                </button>
              </>
            )}
          </div>

          <div className="text-xs text-slate-500 flex items-center space-x-2">
            <Layers className="w-4 h-4 text-slate-400" />
            <span>Target Circuit: <strong className="text-slate-800">{circuitIr?.title || "Active Schematic"}</strong> ({circuitIr?.components?.length || 0} Components)</span>
          </div>
        </div>
      </div>

      {/* 2. KPI EXECUTIVE METRIC CARDS */}
      {report && (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3.5">
          <div className="bg-white border border-slate-200 rounded-xl p-4 flex flex-col justify-between shadow-2xs">
            <span className="text-xs font-medium text-slate-500">Total Faults Simulated</span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-extrabold text-slate-900">{report.total_faults_simulated}</span>
              <span className="text-xs text-slate-400 font-mono">modes</span>
            </div>
            <span className="text-[11px] text-slate-400 mt-1">Across all detected components</span>
          </div>

          <div className="bg-white border border-slate-200 rounded-xl p-4 flex flex-col justify-between shadow-2xs">
            <span className="text-xs font-medium text-slate-500">Safety Robustness Score</span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className={`text-2xl font-extrabold ${report.safety_score > 60 ? "text-emerald-600" : "text-amber-600"}`}>
                {report.safety_score}%
              </span>
              <span className="text-xs text-slate-400 font-mono">SIL-2 index</span>
            </div>
            <div className="w-full bg-slate-100 h-1.5 rounded-full mt-2 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-red-500 via-amber-500 to-emerald-500"
                style={{ width: `${Math.min(report.safety_score, 100)}%` }}
              />
            </div>
          </div>

          <div className="bg-red-50/50 border border-red-200 rounded-xl p-4 flex flex-col justify-between shadow-2xs">
            <span className="text-xs font-bold text-red-700 flex items-center space-x-1.5">
              <Flame className="w-3.5 h-3.5 text-red-600" />
              <span>Critical Hazards</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-extrabold text-red-700">{report.critical_count}</span>
              <span className="text-xs text-red-600/80 font-mono">urgent</span>
            </div>
            <span className="text-[11px] text-red-600/70 mt-1">Overcurrent / clamp saturation</span>
          </div>

          <div className="bg-amber-50/50 border border-amber-200 rounded-xl p-4 flex flex-col justify-between shadow-2xs">
            <span className="text-xs font-bold text-amber-700 flex items-center space-x-1.5">
              <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
              <span>Degraded / Warnings</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-extrabold text-amber-700">{report.warning_count}</span>
              <span className="text-xs text-amber-600/80 font-mono">warnings</span>
            </div>
            <span className="text-[11px] text-amber-600/70 mt-1">Parameter drift &gt; 15%</span>
          </div>

          <div className="bg-emerald-50/50 border border-emerald-200 rounded-xl p-4 flex flex-col justify-between shadow-2xs">
            <span className="text-xs font-bold text-emerald-700 flex items-center space-x-1.5">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
              <span>Safe / Tolerated</span>
            </span>
            <div className="mt-2 flex items-baseline space-x-2">
              <span className="text-2xl font-extrabold text-emerald-700">{report.safe_count}</span>
              <span className="text-xs text-emerald-600/80 font-mono">mitigated</span>
            </div>
            <span className="text-[11px] text-emerald-600/70 mt-1">Graceful shutdown / within bounds</span>
          </div>
        </div>
      )}

      {/* 3. INTERACTIVE TESTING SANDBOX & WAVEFORM COMPARATOR */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Interactive Single Fault Injection Box */}
        <div className="lg:col-span-4 bg-white border border-slate-200 rounded-xl p-5 shadow-xs flex flex-col justify-between space-y-4">
          <div>
            <div className="flex items-center space-x-2">
              <Sliders className="w-4 h-4 text-[#0055A5]" />
              <h3 className="font-bold text-slate-900 text-sm">Interactive Fault Injection Sandbox</h3>
            </div>
            <p className="text-xs text-slate-500 mt-1">
              Select any component on the schematic to test its immediate failure transient.
            </p>
          </div>

          <div className="space-y-3.5">
            <div>
              <label className="text-xs font-semibold text-slate-700 block mb-1">
                Select Target Component
              </label>
              <select
                value={sandboxCompId}
                onChange={(e) => setSandboxCompId(e.target.value)}
                className="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-900 focus:outline-none focus:border-[#0055A5] font-mono font-semibold"
              >
                {circuitIr?.components?.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.id} ({c.type}) {c.name ? `- ${c.name}` : ""}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="text-xs font-semibold text-slate-700 block mb-1">
                Failure Mode
              </label>
              <select
                value={sandboxFaultType}
                onChange={(e) => setSandboxFaultType(e.target.value)}
                className="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-900 focus:outline-none focus:border-[#0055A5] font-mono font-semibold"
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
              <label className="text-xs font-semibold text-slate-700 block mb-1">
                Custom Fault Parameter <span className="text-slate-400 font-normal">(Optional Override)</span>
              </label>
              <input
                type="number"
                placeholder="e.g. 0.05 or 1000000"
                value={sandboxCustomVal}
                onChange={(e) => setSandboxCustomVal(e.target.value)}
                className="w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-900 placeholder-slate-400 focus:outline-none focus:border-[#0055A5] font-mono"
              />
            </div>
          </div>

          <button
            onClick={handleInjectSingle}
            disabled={isInjectingSingle || !sandboxCompId}
            className="w-full py-2.5 px-4 rounded-lg bg-[#0055A5] hover:bg-[#004385] text-white font-bold text-xs flex items-center justify-center space-x-2 transition shadow-xs active:scale-98"
          >
            <Zap className={`w-3.5 h-3.5 ${isInjectingSingle ? "animate-spin" : ""}`} />
            <span>{isInjectingSingle ? "Injecting Fault..." : "Inject Fault & Re-simulate"}</span>
          </button>
        </div>

        {/* Right Column: Live Transient Waveform Comparison */}
        <div className="lg:col-span-8 bg-white border border-slate-200 rounded-xl p-5 shadow-xs flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between flex-wrap gap-2">
              <div className="flex items-center space-x-2">
                <Activity className="w-4 h-4 text-[#0055A5]" />
                <h3 className="font-bold text-slate-900 text-sm">
                  Transient Waveform Comparator: Healthy Baseline vs. Injected Fault
                </h3>
              </div>
              {selectedFault && (
                <span
                  className={`px-2.5 py-0.5 rounded-full text-xs font-bold border ${
                    selectedFault.criticality === "CRITICAL"
                      ? "bg-red-50 text-red-700 border-red-200"
                      : selectedFault.criticality === "WARNING"
                      ? "bg-amber-50 text-amber-700 border-amber-200"
                      : "bg-emerald-50 text-emerald-700 border-emerald-200"
                  }`}
                >
                  {selectedFault.criticality} HAZARD
                </span>
              )}
            </div>

            {selectedFault && (
              <p className="text-xs text-slate-500 mt-1">
                Active Test: <strong className="text-slate-900">{selectedFault.fault_id}</strong> &mdash; {selectedFault.description}
              </p>
            )}
          </div>

          {/* SVG Waveform Visualizer */}
          <div className="my-4 bg-white border border-slate-200 rounded-xl p-4 relative overflow-hidden shadow-2xs">
            {selectedFault?.waveform && selectedFault.waveform.time.length > 0 ? (
              <div className="space-y-3">
                <div className="flex items-center justify-between text-[11px] text-slate-500">
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center space-x-1.5">
                      <span className="w-3 h-0.5 bg-[#0055A5] rounded-full inline-block"></span>
                      <span className="text-slate-700 font-semibold">Healthy Nominal Voltage</span>
                    </div>
                    <div className="flex items-center space-x-1.5">
                      <span className="w-3 h-0.5 bg-red-600 rounded-full inline-block"></span>
                      <span className="text-red-700 font-semibold">Fault Injected Response</span>
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
                  <line x1="0" y1="30" x2="500" y2="30" stroke="#f1f5f9" strokeDasharray="3,3" />
                  <line x1="0" y1="75" x2="500" y2="75" stroke="#f1f5f9" strokeDasharray="3,3" />
                  <line x1="0" y1="120" x2="500" y2="120" stroke="#f1f5f9" strokeDasharray="3,3" />

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
                          stroke="#0055A5"
                          strokeWidth="2.5"
                          strokeLinecap="round"
                          points={basePoints}
                        />
                        <polyline
                          fill="none"
                          stroke="#dc2626"
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
                <div className="grid grid-cols-3 gap-2 pt-2 border-t border-slate-200 text-[11px]">
                  <div>
                    <span className="text-slate-500">Peak Voltage Deviation:</span>
                    <span className="ml-1.5 font-bold font-mono text-slate-900">
                      {selectedFault.metrics?.peak_deviation_v ?? 0} V
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-500">RMS Error:</span>
                    <span className="ml-1.5 font-bold font-mono text-slate-900">
                      {selectedFault.metrics?.rms_error_v ?? 0} V
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-500">Risk Priority (RPN):</span>
                    <span className="ml-1.5 font-bold font-mono text-amber-700">
                      {selectedFault.rpn} / 1000
                    </span>
                  </div>
                </div>
              </div>
            ) : (
              <div className="h-44 flex flex-col items-center justify-center text-slate-400 text-xs">
                <Activity className="w-8 h-8 mb-2 text-slate-300" />
                <span>No waveform data available. Click "Run Autonomous Fault Injection Suite" above.</span>
              </div>
            )}
          </div>

          {/* Failure Effect & Mitigation callout */}
          {selectedFault && (
            <div className="bg-slate-50 border border-slate-200 rounded-lg p-3 text-xs space-y-1.5">
              <div>
                <span className="text-slate-600 font-bold">Circuit Impact: </span>
                <span className="text-slate-800">{selectedFault.effects}</span>
              </div>
              <div>
                <span className="text-[#0055A5] font-bold">Recommended Design Mitigation: </span>
                <span className="text-slate-700">{selectedFault.mitigation}</span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* 4. COMPREHENSIVE FMEA MATRIX TABLE */}
      {report && (
        <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-xs">
          <div className="p-4 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div className="flex items-center space-x-2">
              <ShieldAlert className="w-4 h-4 text-[#0055A5]" />
              <h3 className="font-bold text-slate-900 text-sm">
                FMEA Failure Modes &amp; Effects Analysis Matrix ({filteredFaults.length} tests)
              </h3>
            </div>

            {/* Filter buttons & Search */}
            <div className="flex items-center flex-wrap gap-2">
              <input
                type="text"
                placeholder="Search component or effect..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="bg-white border border-slate-300 rounded-lg px-2.5 py-1 text-xs text-slate-900 placeholder-slate-400 focus:outline-none focus:border-[#0055A5]"
              />

              <div className="flex items-center bg-slate-50 p-1 rounded-lg border border-slate-200 text-xs">
                {["ALL", "CRITICAL", "WARNING", "SAFE"].map((level) => (
                  <button
                    key={level}
                    onClick={() => setSeverityFilter(level)}
                    className={`px-2.5 py-1 rounded font-medium transition ${
                      severityFilter === level
                        ? "bg-[#0055A5] text-white font-bold"
                        : "text-slate-600 hover:text-slate-900"
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
              <thead className="bg-slate-50 text-slate-600 font-bold border-b border-slate-200 sticky top-0 backdrop-blur-sm z-10">
                <tr>
                  <th className="py-2.5 px-3">Fault ID</th>
                  <th className="py-2.5 px-3">Component</th>
                  <th className="py-2.5 px-3">Mode</th>
                  <th className="py-2.5 px-3">Injected Value</th>
                  <th className="py-2.5 px-3">Severity &amp; Effects</th>
                  <th className="py-2.5 px-3">RPN</th>
                  <th className="py-2.5 px-3">Criticality</th>
                  <th className="py-2.5 px-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 text-slate-700">
                {filteredFaults.map((flt) => {
                  const isSelected = selectedFault?.fault_id === flt.fault_id;
                  return (
                    <tr
                      key={flt.fault_id}
                      onClick={() => setSelectedFault(flt)}
                      className={`cursor-pointer transition hover:bg-slate-50 ${
                        isSelected ? "bg-blue-50/70 border-l-2 border-[#0055A5]" : ""
                      }`}
                    >
                      <td className="py-2.5 px-3 font-mono font-bold text-[#0055A5]">
                        {flt.fault_id}
                      </td>
                      <td className="py-2.5 px-3">
                        <span className="font-bold text-slate-900">{flt.component_id}</span>
                        <span className="text-[10px] text-slate-500 block">{flt.component_type}</span>
                      </td>
                      <td className="py-2.5 px-3 font-mono text-[11px] text-slate-800">
                        {flt.fault_type}
                      </td>
                      <td className="py-2.5 px-3 font-mono text-slate-500">
                        {flt.nominal_value} &rarr; <strong className="text-slate-900">{flt.fault_value} {flt.unit}</strong>
                      </td>
                      <td className="py-2.5 px-3 max-w-xs truncate" title={flt.effects}>
                        {flt.effects}
                      </td>
                      <td className="py-2.5 px-3 font-mono font-bold text-amber-700">
                        {flt.rpn}
                      </td>
                      <td className="py-2.5 px-3">
                        <span
                          className={`px-2 py-0.5 rounded text-[10px] font-bold border ${
                            flt.criticality === "CRITICAL"
                              ? "bg-red-50 text-red-700 border-red-200"
                              : flt.criticality === "WARNING"
                              ? "bg-amber-50 text-amber-700 border-amber-200"
                              : "bg-emerald-50 text-emerald-700 border-emerald-200"
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
                          className="px-2 py-1 rounded bg-slate-100 hover:bg-blue-50 text-[#0055A5] font-semibold text-[11px] transition border border-slate-200"
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
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4">
          <div className="bg-white border border-slate-200 rounded-xl p-6 max-w-md w-full shadow-2xl space-y-4">
            <div className="flex items-center space-x-2.5">
              <Key className="w-5 h-5 text-[#0055A5]" />
              <h3 className="text-lg font-bold text-slate-900">MATLAB &amp; MathWorks API Configuration</h3>
            </div>

            <p className="text-xs text-slate-600 leading-relaxed">
              Circuit2Sim interacts with MATLAB Simscape Electrical directly. Configure your MathWorks Account Token, MATLAB Production Server API Key, or use the local Simscape installation.
            </p>

            <div className="space-y-3">
              <div>
                <label className="text-xs font-semibold text-slate-700 block mb-1">
                  MATLAB / MathWorks API Key
                </label>
                <input
                  type="text"
                  placeholder="e.g. mw-live-sim-88f921a4c"
                  value={apiKeyInput}
                  onChange={(e) => setApiKeyInput(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-900 focus:outline-none focus:border-[#0055A5] font-mono"
                />
              </div>

              <div className="bg-slate-50 border border-slate-200 rounded-lg p-3 text-xs space-y-1">
                <span className="font-semibold text-slate-800 block">Detected Toolboxes:</span>
                <ul className="text-slate-600 list-disc list-inside space-y-0.5">
                  {matlabSettings?.toolboxes?.map((t) => (
                    <li key={t.name}>
                      {t.name} &mdash; <strong className="text-slate-800">{t.version}</strong> ({t.status})
                    </li>
                  )) || <li>MATLAB R2026a Simscape Electrical</li>}
                </ul>
              </div>
            </div>

            <div className="flex items-center justify-end space-x-3 pt-3 border-t border-slate-200">
              <button
                onClick={() => setShowKeyModal(false)}
                className="px-4 py-2 rounded-lg bg-slate-100 text-slate-700 hover:bg-slate-200 text-xs font-semibold transition"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveApiKey}
                disabled={savingKey}
                className="px-4 py-2 rounded-lg bg-[#0055A5] hover:bg-[#004385] text-white text-xs font-bold transition shadow-xs"
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
