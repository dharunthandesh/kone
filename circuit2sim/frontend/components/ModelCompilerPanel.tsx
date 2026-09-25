"use client";

import React, { useState } from "react";
import {
  Download,
  FileCode,
  Play,
  CheckCircle2,
  AlertTriangle,
  Code2,
  Terminal,
  Loader2,
  Archive,
  FolderDown,
} from "lucide-react";
import { CompilationReport, UniversalCircuitIR } from "../types/circuit";
import { api } from "../lib/api";

interface ModelCompilerPanelProps {
  projectId: string;
  circuitIr?: UniversalCircuitIR;
  onGenerateModel: (target: string) => Promise<any>;
  isGenerating: boolean;
  compilationResult?: any;
}

export const ModelCompilerPanel: React.FC<ModelCompilerPanelProps> = ({
  projectId,
  circuitIr,
  onGenerateModel,
  isGenerating,
  compilationResult,
}) => {
  const [target, setTarget] = useState("matlab_simscape");
  const [activeTab, setActiveTab] = useState<"compiler" | "script" | "ir">("compiler");
  const [previewScript, setPreviewScript] = useState<string>("");
  const [downloadingAll, setDownloadingAll] = useState(false);
  const [elapsedSeconds, setElapsedSeconds] = useState(0);

  React.useEffect(() => {
    let timer: any;
    if (isGenerating) {
      setElapsedSeconds(0);
      timer = setInterval(() => {
        setElapsedSeconds((prev) => prev + 1);
      }, 1000);
    } else {
      setElapsedSeconds(0);
    }
    return () => clearInterval(timer);
  }, [isGenerating]);

  const handleDownloadAllSeparately = () => {
    setDownloadingAll(true);
    const modelName = compilationResult?.model_name || `circuit_${projectId.slice(0, 8)}`;
    const hasSlx = Boolean(
      compilationResult?.has_slx ||
      compilationResult?.slx_filename ||
      compilationResult?.status === "COMPILED_SUCCESS"
    );

    const filesToDownload: { url: string; name: string }[] = [];
    if (hasSlx) {
      filesToDownload.push({
        url: api.getDownloadUrl(projectId, "slx", Date.now()),
        name: `${modelName}.slx`,
      });
    }
    filesToDownload.push(
      {
        url: api.getDownloadUrl(projectId, "m", Date.now()),
        name: `generate_${modelName}.m`,
      },
      {
        url: api.getDownloadUrl(projectId, "cir", Date.now()),
        name: `${modelName}.cir`,
      },
      {
        url: api.getDownloadUrl(projectId, "json", Date.now()),
        name: `circuit_ir_${projectId}.json`,
      }
    );

    filesToDownload.forEach((file, index) => {
      setTimeout(() => {
        const link = document.createElement("a");
        link.href = file.url;
        link.setAttribute("download", file.name);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        if (index === filesToDownload.length - 1) {
          setTimeout(() => setDownloadingAll(false), 500);
        }
      }, index * 350);
    });
  };

  const handleGenerate = async () => {
    const res = await onGenerateModel(target);
    if (res?.script_download_url) {
      // Fetch script for preview
      try {
        const resp = await fetch(api.getStaticFileUrl(res.script_download_url));
        if (resp.ok) {
          const text = await resp.text();
          setPreviewScript(text);
        }
      } catch (err) {
        console.error("Failed to load script preview", err);
      }
    }
  };

  const report = compilationResult?.compilation_report as CompilationReport | undefined;

  return (
    <div className="flex flex-col h-full bg-white border border-slate-200 rounded-xl overflow-hidden shadow-xs">
      {/* Top Header */}
      <div className="flex items-center justify-between px-4 py-3 bg-slate-50 border-b border-slate-200">
        <div className="flex items-center space-x-2">
          <Terminal className="w-4 h-4 text-[#0055a5]" />
          <h3 className="text-xs font-bold text-slate-800 uppercase tracking-wider">
            Model Compiler & Output
          </h3>
        </div>

        {/* Tab switch */}
        <div className="flex items-center space-x-1 bg-white border border-slate-200 rounded-lg p-0.5 text-[11px] shadow-2xs">
          <button
            onClick={() => setActiveTab("compiler")}
            className={`px-2.5 py-1 rounded-md transition font-medium ${
              activeTab === "compiler"
                ? "bg-[#0055a5] text-white shadow-xs"
                : "text-slate-600 hover:text-slate-900"
            }`}
          >
            Compilation
          </button>
          <button
            onClick={() => setActiveTab("script")}
            className={`px-2.5 py-1 rounded-md transition font-medium ${
              activeTab === "script"
                ? "bg-[#0055a5] text-white shadow-xs"
                : "text-slate-600 hover:text-slate-900"
            }`}
          >
            MATLAB Code (.m)
          </button>
          <button
            onClick={() => setActiveTab("ir")}
            className={`px-2.5 py-1 rounded-md transition font-medium ${
              activeTab === "ir"
                ? "bg-[#0055a5] text-white shadow-xs"
                : "text-slate-600 hover:text-slate-900"
            }`}
          >
            Universal IR
          </button>
        </div>
      </div>

      {/* Main Tab Content */}
      <div className="flex-1 p-4 overflow-auto">
        {activeTab === "compiler" && (
          <div className="space-y-4">
            {/* Target Selector Card */}
            <div className="bg-slate-50/60 border border-slate-200 rounded-lg p-3">
              <label className="text-[11px] font-bold text-slate-700 block uppercase tracking-wider mb-2">
                Simulation Backend Target
              </label>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs">
                <div
                  onClick={() => setTarget("matlab_simscape")}
                  className={`p-3 rounded-lg border cursor-pointer transition ${
                    target === "matlab_simscape"
                      ? "bg-blue-50/80 border-[#0055a5] text-slate-900 ring-1 ring-[#0055a5]"
                      : "bg-white border-slate-200 text-slate-600 hover:border-slate-300"
                  }`}
                >
                  <div className="font-bold text-[#0055a5] flex items-center justify-between">
                    <span>MATLAB / Simscape (.slx)</span>
                    <span className="text-[10px] font-mono bg-blue-100 text-[#0055a5] font-semibold px-1.5 py-0.2 rounded">Primary</span>
                  </div>
                  <p className="text-[11px] text-slate-500 mt-1">
                    Native physical modeling blocks, non-flattened layout, editable in MATLAB Desktop.
                  </p>
                </div>

                <div
                  onClick={() => setTarget("simulink_standard")}
                  className={`p-3 rounded-lg border cursor-pointer transition ${
                    target === "simulink_standard"
                      ? "bg-blue-50/80 border-[#0055a5] text-slate-900 ring-1 ring-[#0055a5]"
                      : "bg-white border-slate-200 text-slate-600 hover:border-slate-300"
                  }`}
                >
                  <div className="font-bold text-slate-800">Simulink Signal Flow</div>
                  <p className="text-[11px] text-slate-500 mt-1">
                    Mathematical transfer-function and block diagram representation.
                  </p>
                </div>
              </div>
            </div>

            {/* Compilation Action */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between bg-slate-50 border border-slate-200 rounded-lg p-3 gap-3">
              <div>
                <span className="text-xs font-bold text-slate-800 block">
                  Simscape Model Compiler
                </span>
                <span className="text-[11px] text-slate-500">
                  Translates Universal Circuit IR into verified executable simulation assets.
                </span>
              </div>

              <div className="flex items-center space-x-2 shrink-0">
                <button
                  disabled={isGenerating || !circuitIr}
                  onClick={handleGenerate}
                  className="inline-flex items-center space-x-2 px-4 py-2 rounded-lg bg-[#0055a5] hover:bg-[#004385] text-white text-xs font-bold shadow-xs transition disabled:opacity-50 active:scale-95 cursor-pointer"
                >
                  {isGenerating ? (
                    <>
                      <Loader2 className="w-4 h-4 animate-spin text-white" />
                      <span>
                        {elapsedSeconds < 2
                          ? "Starting Compiler..."
                          : elapsedSeconds < 8
                          ? `Initializing MATLAB (${elapsedSeconds}s)...`
                          : `Compiling Simscape Model (${elapsedSeconds}s)...`}
                      </span>
                    </>
                  ) : (
                    <>
                      <Play className="w-4 h-4 fill-white" />
                      <span>Compile Simulation Model</span>
                    </>
                  )}
                </button>
              </div>
            </div>

            {/* Live Progress Bar during compilation */}
            {isGenerating && (
              <div className="bg-blue-50/60 border border-blue-200 rounded-lg p-3.5 text-xs space-y-2.5 font-mono">
                <div className="flex items-center justify-between text-[#0055a5]">
                  <span className="flex items-center space-x-2">
                    <Loader2 className="w-3.5 h-3.5 animate-spin text-[#0055a5] shrink-0" />
                    <span className="text-[11px] font-sans font-medium text-slate-800">
                      {elapsedSeconds < 3
                        ? "1/3 Synthesizing circuit netlist & block diagrams..."
                        : elapsedSeconds < 10
                        ? "2/3 Initializing headless MATLAB engine in background..."
                        : "3/3 Synthesizing Simscape blocks and wiring physical nets..."}
                    </span>
                  </span>
                  <span className="text-[11px] font-bold text-[#0055a5] bg-white px-2 py-0.5 rounded border border-blue-200">
                    {elapsedSeconds}s elapsed
                  </span>
                </div>
                <div className="w-full bg-slate-200 h-1.5 rounded-full overflow-hidden">
                  <div
                    className="bg-[#0055a5] h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${Math.min(95, 10 + elapsedSeconds * 3.5)}%`,
                    }}
                  />
                </div>
                <p className="text-[10px] text-slate-500 font-sans leading-relaxed">
                  ⚡ MATLAB cold-starts its physical simulation engine on the first run. Subsequent compilations for unchanged circuits are instant via smart cache.
                </p>
              </div>
            )}

            {/* Output & Download Section */}
            {compilationResult && (
              <div className="bg-white border border-slate-200 rounded-lg p-4 space-y-4 shadow-xs">
                {/* Header status */}
                <div className="flex items-center justify-between pb-3 border-b border-slate-100">
                  <div className="flex items-center space-x-2">
                    {compilationResult.has_slx || compilationResult.status === "COMPILED_SUCCESS" || compilationResult.slx_filename ? (
                      <span className="inline-flex items-center space-x-1.5 text-emerald-700 text-xs font-bold">
                        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                        <span>All Simulation Artifacts Ready (.slx compiled)</span>
                      </span>
                    ) : (
                      <span className="inline-flex items-center space-x-1.5 text-amber-700 text-xs font-bold">
                        <AlertTriangle className="w-4 h-4 text-amber-600" />
                        <span>Generator Script & Netlist Ready (.m + .cir)</span>
                      </span>
                    )}
                  </div>
                  <span className="text-[10px] font-mono text-slate-600 bg-slate-50 px-2 py-0.5 rounded border border-slate-200">
                    Model: {compilationResult.model_name}
                  </span>
                </div>

                <p className="text-xs text-slate-600 leading-relaxed">{compilationResult.message}</p>

                {/* Primary Action Card: Download Complete Bundle */}
                <div className="bg-gradient-to-br from-blue-50/70 to-indigo-50/50 border border-blue-200 rounded-lg p-3.5 shadow-xs space-y-2.5">
                  <div className="flex items-center justify-between">
                    <div>
                      <span className="text-xs font-bold text-slate-900 flex items-center space-x-1.5">
                        <Archive className="w-3.5 h-3.5 text-[#0055a5]" />
                        <span>Complete Simulation Package (ZIP)</span>
                      </span>
                      <span className="text-[11px] text-slate-500 block mt-0.5">
                        Contains all files: .slx model, .m script, .cir SPICE netlist, circuit_ir.json & README guide.
                      </span>
                    </div>
                    <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded bg-blue-100 text-[#0055a5] border border-blue-200 shrink-0">
                      All-in-One
                    </span>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1">
                    {/* Primary ZIP Button */}
                    <a
                      href={api.getDownloadUrl(projectId, "zip", Date.now())}
                      download
                      className="inline-flex items-center justify-center space-x-2 py-2 px-3 rounded-lg bg-[#0055a5] hover:bg-[#004385] text-white font-bold text-xs shadow-xs transition active:scale-95 cursor-pointer"
                    >
                      <Download className="w-3.5 h-3.5" />
                      <span>Download Package (.zip)</span>
                    </a>

                    {/* Batch Download Button */}
                    <button
                      type="button"
                      disabled={downloadingAll}
                      onClick={handleDownloadAllSeparately}
                      className="inline-flex items-center justify-center space-x-2 py-2 px-3 rounded-lg bg-white hover:bg-slate-50 text-[#0055a5] font-semibold text-xs border border-slate-300 transition active:scale-95 cursor-pointer disabled:opacity-60"
                    >
                      {downloadingAll ? (
                        <>
                          <Loader2 className="w-3.5 h-3.5 animate-spin" />
                          <span>Downloading Files...</span>
                        </>
                      ) : (
                        <>
                          <FolderDown className="w-3.5 h-3.5" />
                          <span>Download All Files (Separate)</span>
                        </>
                      )}
                    </button>
                  </div>
                </div>

                {/* Individual File Actions */}
                <div className="space-y-1.5 pt-1">
                  <span className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">
                    Individual File Downloads
                  </span>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    {/* SLX Button */}
                    {compilationResult.has_slx || compilationResult.status === "COMPILED_SUCCESS" || compilationResult.slx_filename ? (
                      <a
                        href={api.getDownloadUrl(projectId, "slx", Date.now())}
                        download
                        className="flex items-center justify-between p-2.5 rounded-lg bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/40 text-xs transition group cursor-pointer"
                      >
                        <div className="flex items-center space-x-2">
                          <Download className="w-3.5 h-3.5 text-emerald-600" />
                          <div>
                            <span className="font-bold text-slate-800 block text-[11px]">
                              Native Model (.slx)
                            </span>
                            <span className="text-[10px] text-slate-500">MATLAB / Simscape</span>
                          </div>
                        </div>
                        <span className="text-[10px] font-mono text-emerald-600 font-semibold group-hover:underline">
                          Download
                        </span>
                      </a>
                    ) : (
                      <div className="flex items-center justify-between p-2.5 rounded-lg bg-slate-50/60 border border-slate-200 text-xs">
                        <div className="flex items-center space-x-2">
                          <AlertTriangle className="w-3.5 h-3.5 text-amber-500" />
                          <div>
                            <span className="font-semibold text-slate-600 block text-[11px]">
                              Native Model (.slx)
                            </span>
                            <span className="text-[10px] text-amber-600">Use .m in MATLAB desktop</span>
                          </div>
                        </div>
                        <span className="text-[10px] font-mono text-slate-400">Pending</span>
                      </div>
                    )}

                    {/* Script Button */}
                    <a
                      href={api.getDownloadUrl(projectId, "m", Date.now())}
                      download
                      className="flex items-center justify-between p-2.5 rounded-lg bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/40 text-xs transition group cursor-pointer"
                    >
                      <div className="flex items-center space-x-2">
                        <FileCode className="w-3.5 h-3.5 text-[#0055a5]" />
                        <div>
                          <span className="font-bold text-slate-800 block text-[11px]">
                            Generator Script (.m)
                          </span>
                          <span className="text-[10px] text-slate-500">M-Code Automation</span>
                        </div>
                      </div>
                      <span className="text-[10px] font-mono text-[#0055a5] font-semibold group-hover:underline">
                        Download
                      </span>
                    </a>

                    {/* SPICE Netlist Button */}
                    <a
                      href={api.getDownloadUrl(projectId, "cir", Date.now())}
                      download
                      className="flex items-center justify-between p-2.5 rounded-lg bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/40 text-xs transition group cursor-pointer"
                    >
                      <div className="flex items-center space-x-2">
                        <Code2 className="w-3.5 h-3.5 text-indigo-600" />
                        <div>
                          <span className="font-bold text-slate-800 block text-[11px]">
                            SPICE Netlist (.cir)
                          </span>
                          <span className="text-[10px] text-slate-500">LTspice / NGSpice</span>
                        </div>
                      </div>
                      <span className="text-[10px] font-mono text-indigo-600 font-semibold group-hover:underline">
                        Download
                      </span>
                    </a>

                    {/* Universal Circuit IR JSON Button */}
                    <a
                      href={api.getDownloadUrl(projectId, "json", Date.now())}
                      download
                      className="flex items-center justify-between p-2.5 rounded-lg bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/40 text-xs transition group cursor-pointer"
                    >
                      <div className="flex items-center space-x-2">
                        <FileCode className="w-3.5 h-3.5 text-amber-600" />
                        <div>
                          <span className="font-bold text-slate-800 block text-[11px]">
                            Universal Circuit IR (.json)
                          </span>
                          <span className="text-[10px] text-slate-500">Structured Netlist</span>
                        </div>
                      </div>
                      <span className="text-[10px] font-mono text-amber-600 font-semibold group-hover:underline">
                        Download
                      </span>
                    </a>
                  </div>
                </div>

                {/* Diagnostics box */}
                {report && (
                  <div className="mt-3 bg-slate-50 border border-slate-200 rounded-lg p-2.5 font-mono text-[11px] text-slate-600 space-y-1">
                    <div className="text-slate-800 font-bold">Compilation Report:</div>
                    <div>Status: {report.status}</div>
                    <div>MATLAB Binary: {report.matlab_binary || "Not on system PATH"}</div>
                    <div>Simulation Smoke Test: {report.simulation_smoke_test}</div>
                    {report.warnings.map((w, i) => (
                      <div key={i} className="text-amber-600">
                        ⚠ {w}
                      </div>
                    ))}
                    {report.errors.map((e, i) => (
                      <div key={i} className="text-rose-600">
                        ✕ {e}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        )}

        {/* Tab 2: MATLAB Script Code Preview */}
        {activeTab === "script" && (
          <div className="h-full flex flex-col">
            <div className="flex items-center justify-between text-xs text-slate-600 mb-2 font-mono">
              <span className="font-bold text-slate-800">generate_circuit_model.m</span>
              <a
                href={api.getDownloadUrl(projectId, "m")}
                download
                className="text-[#0055a5] font-semibold hover:underline flex items-center space-x-1"
              >
                <Download className="w-3 h-3" />
                <span>Download .m</span>
              </a>
            </div>
            <pre className="flex-1 bg-slate-900 border border-slate-800 rounded-lg p-3 text-[11px] font-mono text-cyan-200 overflow-auto whitespace-pre leading-relaxed select-all">
              {previewScript ||
                `% Compile the model to see the generated MATLAB script here.\n% Click 'Compile Simulation Model' in the Compilation tab.`}
            </pre>
          </div>
        )}

        {/* Tab 3: Raw Universal Circuit IR JSON */}
        {activeTab === "ir" && (
          <div className="h-full flex flex-col">
            <div className="flex items-center justify-between text-xs text-slate-600 mb-2 font-mono">
              <span className="font-bold text-slate-800">Universal Circuit IR (v{circuitIr?.version || "0.1"})</span>
              <button
                onClick={() => {
                  const blob = new Blob([JSON.stringify(circuitIr, null, 2)], {
                    type: "application/json",
                  });
                  const url = URL.createObjectURL(blob);
                  const a = document.createElement("a");
                  a.href = url;
                  a.download = `circuit_ir_${projectId}.json`;
                  a.click();
                }}
                className="text-[#0055a5] font-semibold hover:underline flex items-center space-x-1"
              >
                <Download className="w-3 h-3" />
                <span>Export JSON</span>
              </button>
            </div>
            <pre className="flex-1 bg-slate-900 border border-slate-800 rounded-lg p-3 text-[11px] font-mono text-emerald-300 overflow-auto whitespace-pre leading-relaxed select-all">
              {JSON.stringify(circuitIr, null, 2)}
            </pre>
          </div>
        )}
      </div>
    </div>
  );
};
