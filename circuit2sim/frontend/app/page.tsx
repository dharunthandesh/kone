"use client";

import React, { useEffect, useState } from "react";
import {
  UploadCloud,
  Play,
  CheckCircle2,
  AlertTriangle,
  ArrowRight,
  RefreshCw,
  Cpu,
  Layers,
  Terminal,
  ShieldCheck,
  FileCheck2,
  Loader2,
  FolderOpen,
  Flame,
  Zap,
} from "lucide-react";
import { Navbar } from "../components/Navbar";
import { SchematicViewer } from "../components/SchematicViewer";
import { ComponentReviewTable } from "../components/ComponentReviewTable";
import { ValidationReportCard } from "../components/ValidationReportCard";
import { ModelCompilerPanel } from "../components/ModelCompilerPanel";
import { FaultInjectionPanel } from "../components/FaultInjectionPanel";
import { LiveFaultStudio } from "../components/LiveFaultStudio";
import { NewProjectModal } from "../components/NewProjectModal";
import { api } from "../lib/api";
import { ComponentType, ParameterValue, Project, UniversalCircuitIR, ValidationReport } from "../types/circuit";

export default function Home() {
  const [projects, setProjects] = useState<Project[]>([]);
  const [currentProject, setCurrentProject] = useState<Project | null>(null);
  const [circuitIr, setCircuitIr] = useState<UniversalCircuitIR | undefined>(undefined);
  const [validation, setValidation] = useState<ValidationReport | undefined>(undefined);
  const [selectedCompId, setSelectedCompId] = useState<string | undefined>(undefined);

  // System states
  const [apiOnline, setApiOnline] = useState<boolean>(false);
  const [isAnalyzing, setIsAnalyzing] = useState<boolean>(false);
  const [analysisLogs, setAnalysisLogs] = useState<string[]>([]);
  const [isCompiling, setIsCompiling] = useState<boolean>(false);
  const [compilationResult, setCompilationResult] = useState<any>(null);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);

  // Active step flow: 1: Upload, 2: Understand, 3: Review, 4: Validate, 5: Model
  const [activeStep, setActiveStep] = useState<number>(2);

  // Initial Load
  useEffect(() => {
    checkHealthAndLoad();
  }, []);

  const checkHealthAndLoad = async () => {
    try {
      await api.getHealth();
      setApiOnline(true);
      const projs = await api.getProjects();
      setProjects(projs);
      if (projs.length > 0) {
        loadProjectDetails(projs[0].id);
      } else {
        // If no projects exist, initialize default benchmark RC filter for seamless first-load!
        try {
          const sample = await api.loadSample("rc_filter");
          const updated = await api.getProjects();
          setProjects(updated);
          loadProjectDetails(sample.project_id);
        } catch (e) {
          console.error("Auto-sample creation failed", e);
        }
      }
    } catch (err) {
      setApiOnline(false);
      console.warn("Backend not yet connected", err);
    }
  };

  const loadProjectDetails = async (projectId: string) => {
    try {
      setCompilationResult(null);
      setSelectedCompId(undefined);
      const p = await api.getProject(projectId);
      setCurrentProject(p);
      const analysis = await api.getAnalysis(projectId);
      if (analysis.circuit_ir) {
        setCircuitIr(analysis.circuit_ir);
        setValidation(analysis.validation || analysis.circuit_ir.validation);
        setActiveStep(3);
      } else {
        setCircuitIr(undefined);
        setValidation(undefined);
        setActiveStep(p.schematic_filename ? 2 : 1);
      }
      // Load project-specific compiled model if already generated
      const model = await api.getProjectModel(projectId);
      if (model && model.has_model) {
        setCompilationResult(model);
      }
    } catch (err) {
      console.error("Error loading project details", err);
    }
  };

  const handleSelectProject = (projectId: string) => {
    loadProjectDetails(projectId);
  };

  const handleUploadSchematic = async (file: File) => {
    if (!currentProject) return;
    setIsAnalyzing(true);
    setCircuitIr(undefined);
    setValidation(undefined);
    setCompilationResult(null);
    setSelectedCompId(undefined);
    setAnalysisLogs([`Uploading ${file.name}...`]);

    try {
      await api.uploadSchematic(currentProject.id, file);
      const p = await api.getProject(currentProject.id);
      setCurrentProject(p);
      setProjects((prev) => prev.map((item) => (item.id === p.id ? p : item)));
      setIsAnalyzing(false);
      setActiveStep(2);
    } catch (err: any) {
      setIsAnalyzing(false);
      alert(err.message || "Failed to upload schematic");
    }
  };

  const handleAnalyze = async () => {
    if (!currentProject) return;
    setIsAnalyzing(true);
    setCircuitIr(undefined);
    setValidation(undefined);
    setCompilationResult(null);
    setSelectedCompId(undefined);
    setAnalysisLogs(["Initiating Circuit Understanding Pipeline..."]);

    try {
      const job = await api.startAnalysis(currentProject.id);
      const targetJobId = job.job_id;

      // Poll analysis progress specifically for targetJobId
      const pollInterval = setInterval(async () => {
        try {
          const res = await api.getAnalysis(currentProject.id, targetJobId);
          if (res.job?.logs) {
            setAnalysisLogs(res.job.logs);
          }
          if (res.job?.id === targetJobId && res.job?.status === "completed") {
            clearInterval(pollInterval);
            setIsAnalyzing(false);
            if (res.circuit_ir) {
              setCircuitIr(res.circuit_ir);
              setValidation(res.validation || res.circuit_ir.validation);
              setActiveStep(3); // Transition to Review
            }
            const updatedProj = await api.getProject(currentProject.id);
            setCurrentProject(updatedProj);
          } else if (res.job?.id === targetJobId && res.job?.status === "failed") {
            clearInterval(pollInterval);
            setIsAnalyzing(false);
            alert(`Analysis failed: ${res.job?.error || "Unknown error"}`);
          }
        } catch (pollErr) {
          console.error("Polling error", pollErr);
        }
      }, 800);
    } catch (err: any) {
      setIsAnalyzing(false);
      alert(err.message || "Failed to start analysis");
    }
  };

  const handleUpdateComponent = async (
    id: string,
    data: {
      type?: ComponentType;
      name?: string;
      parameters?: Record<string, ParameterValue>;
      pins?: string[];
      orientation?: number;
    }
  ) => {
    if (!currentProject) return;
    try {
      const res = await api.updateComponent(currentProject.id, id, data);
      setValidation(res.validation);
      // Reload IR
      const analysis = await api.getAnalysis(currentProject.id);
      if (analysis.circuit_ir) setCircuitIr(analysis.circuit_ir);
    } catch (err: any) {
      alert(err.message || "Failed to update component");
    }
  };

  const handleAddComponent = async (data: {
    id: string;
    type: ComponentType;
    name?: string;
    parameters?: Record<string, ParameterValue>;
    pins?: string[];
    orientation?: number;
  }) => {
    if (!currentProject) return;
    try {
      const res = await api.addComponent(currentProject.id, data);
      setValidation(res.validation);
      const analysis = await api.getAnalysis(currentProject.id);
      if (analysis.circuit_ir) setCircuitIr(analysis.circuit_ir);
    } catch (err: any) {
      alert(err.message || "Failed to add component");
    }
  };

  const handleDeleteComponent = async (id: string) => {
    if (!currentProject) return;
    try {
      const res = await api.deleteComponent(currentProject.id, id);
      setValidation(res.validation);
      const analysis = await api.getAnalysis(currentProject.id);
      if (analysis.circuit_ir) setCircuitIr(analysis.circuit_ir);
    } catch (err: any) {
      alert(err.message || "Failed to delete component");
    }
  };

  const handleGenerateModel = async (target: string) => {
    if (!currentProject) return;
    setIsCompiling(true);
    try {
      const res = await api.generateModel(currentProject.id, target);
      setCompilationResult(res);
      setActiveStep(5);
      return res;
    } catch (err: any) {
      alert(err.message || "Compilation failed");
    } finally {
      setIsCompiling(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans selection:bg-cyan-500 selection:text-white">
      {/* Top Navigation */}
      <Navbar
        currentProject={currentProject}
        projects={projects}
        onSelectProject={handleSelectProject}
        onOpenNewProject={() => setIsModalOpen(true)}
        apiOnline={apiOnline}
      />

      {/* Main Workspace */}
      <main className="flex-1 max-w-7xl w-full mx-auto p-4 sm:p-6 lg:p-8 flex flex-col space-y-6">
        {/* Engineering Stepper Header */}
        <div className="bg-slate-900 border border-slate-800 rounded-xl p-3 flex flex-wrap items-center justify-between shadow-lg text-xs font-mono">
          <div className="flex items-center space-x-1 sm:space-x-3 overflow-x-auto py-1">
            {/* Step 1: Upload */}
            <button
              onClick={() => setActiveStep(1)}
              className={`flex items-center space-x-1 px-2.5 py-1 rounded transition ${
                activeStep === 1
                  ? "bg-cyan-600/30 text-cyan-300 font-bold border border-cyan-500/50"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              <span>1. UPLOAD</span>
              {currentProject?.schematic_filename && <span className="text-emerald-400">✓</span>}
            </button>

            <span className="text-slate-600">→</span>

            {/* Step 2: Understand */}
            <button
              onClick={() => setActiveStep(2)}
              className={`flex items-center space-x-1 px-2.5 py-1 rounded transition ${
                activeStep === 2
                  ? "bg-cyan-600/30 text-cyan-300 font-bold border border-cyan-500/50"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              <span>2. UNDERSTAND</span>
              {circuitIr && <span className="text-emerald-400">✓</span>}
            </button>

            <span className="text-slate-600">→</span>

            {/* Step 3: Review */}
            <button
              onClick={() => setActiveStep(3)}
              className={`flex items-center space-x-1 px-2.5 py-1 rounded transition ${
                activeStep === 3
                  ? "bg-cyan-600/30 text-cyan-300 font-bold border border-cyan-500/50"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              <span>3. REVIEW & EDIT</span>
              {circuitIr?.components && circuitIr.components.length > 0 && (
                <span className="text-cyan-400">({circuitIr.components.length})</span>
              )}
            </button>

            <span className="text-slate-600">→</span>

            {/* Step 4: Validate */}
            <button
              onClick={() => setActiveStep(4)}
              className={`flex items-center space-x-1 px-2.5 py-1 rounded transition ${
                activeStep === 4
                  ? "bg-cyan-600/30 text-cyan-300 font-bold border border-cyan-500/50"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              <span>4. VALIDATE</span>
              {validation?.status === "PASS" ? (
                <span className="text-emerald-400">PASS ✓</span>
              ) : validation?.status === "WARNING" ? (
                <span className="text-amber-400">WARN ⚠</span>
              ) : null}
            </button>

            <span className="text-slate-600">→</span>

            {/* Step 5: Model */}
            <button
              onClick={() => setActiveStep(5)}
              className={`flex items-center space-x-1 px-2.5 py-1 rounded transition ${
                activeStep === 5
                  ? "bg-cyan-600/30 text-cyan-300 font-bold border border-cyan-500/50"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              <span>5. GENERATE .SLX</span>
              {compilationResult && <span className="text-emerald-400">✓</span>}
            </button>

            <span className="text-slate-600">→</span>

            {/* Step 6: Autonomous Fault Injection (FMEA) */}
            <button
              onClick={() => setActiveStep(6)}
              className={`flex items-center space-x-1.5 px-3 py-1 rounded transition ${
                activeStep === 6
                  ? "bg-gradient-to-r from-amber-500/30 to-rose-500/30 text-amber-300 font-bold border border-amber-500/60 shadow-lg shadow-amber-500/10"
                  : "text-amber-400/80 hover:text-amber-300 hover:bg-amber-500/10"
              }`}
            >
              <Flame className="w-3.5 h-3.5 text-amber-400" />
              <span>6. FAULT INJECTION (FMEA)</span>
            </button>
          </div>

          {/* Quick Actions */}
          <div className="flex items-center space-x-2 mt-2 sm:mt-0">
            {currentProject?.schematic_filename && (
              <button
                disabled={isAnalyzing}
                onClick={handleAnalyze}
                className="inline-flex items-center space-x-1.5 px-3 py-1 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white font-bold transition shadow shadow-cyan-600/20 active:scale-95 cursor-pointer disabled:opacity-50"
              >
                {isAnalyzing ? (
                  <Loader2 className="w-3.5 h-3.5 animate-spin" />
                ) : (
                  <Play className="w-3.5 h-3.5 fill-white" />
                )}
                <span>{circuitIr ? "Re-run Analysis" : "Run Analysis"}</span>
              </button>
            )}

            {circuitIr && (
              <button
                onClick={() => setActiveStep(6)}
                className="inline-flex items-center space-x-1.5 px-3 py-1 rounded-lg bg-gradient-to-r from-amber-500 via-orange-500 to-rose-600 hover:from-amber-600 hover:to-rose-700 text-white font-bold transition shadow shadow-amber-500/20 active:scale-95 cursor-pointer"
              >
                <Zap className="w-3.5 h-3.5 fill-white" />
                <span>Autonomous FMEA Engine</span>
              </button>
            )}
          </div>
        </div>

        {/* Live Analysis Terminal Banner (if active) */}
        {isAnalyzing && (
          <div className="bg-slate-900 border border-cyan-800 rounded-xl p-4 shadow-xl font-mono text-xs text-cyan-300 space-y-1">
            <div className="flex items-center justify-between text-cyan-400 font-bold mb-2">
              <span className="flex items-center space-x-2">
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>Running Circuit Understanding Pipeline...</span>
              </span>
              <span>Processing</span>
            </div>
            <div className="max-h-24 overflow-auto space-y-0.5 text-slate-300">
              {analysisLogs.map((log, i) => (
                <div key={i} className="text-[11px] leading-tight">
                  {log}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Dynamic Workspace View based on Step */}
        {activeStep === 6 ? (
          <div className="space-y-6 flex-1">
            {currentProject && (
              <>
                <LiveFaultStudio
                  projectId={currentProject.id}
                  circuitIr={circuitIr}
                  onRefresh={() => loadProjectDetails(currentProject.id)}
                />
                <FaultInjectionPanel
                  projectId={currentProject.id}
                  circuitIr={circuitIr}
                  onRefresh={() => loadProjectDetails(currentProject.id)}
                />
              </>
            )}
          </div>
        ) : (
          /* Two-Column Engineering Workspace */
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 flex-1">
            {/* Left Column: Schematic Viewport & Bounding Box Overlays (7 cols) */}
            <div className="lg:col-span-7 flex flex-col self-start sticky top-20">
              <SchematicViewer
                schematicUrl={currentProject?.schematic_url}
                circuitIr={circuitIr}
                selectedComponentId={selectedCompId}
                onSelectComponent={(id) => {
                  setSelectedCompId(id);
                  setActiveStep(3); // Bring user focus to review
                }}
                onUploadSchematic={handleUploadSchematic}
                isUploading={isAnalyzing}
              />
            </div>

            {/* Right Column: Dynamic Panel based on current focus (5 cols) */}
            <div className="lg:col-span-5 flex flex-col space-y-4">
              {/* Step 1 & 2: Review Table */}
              <div className="flex-1 min-h-[380px]">
                <ComponentReviewTable
                  components={circuitIr?.components || []}
                  selectedComponentId={selectedCompId}
                  onSelectComponent={(id) => setSelectedCompId(id)}
                  onUpdateComponent={handleUpdateComponent}
                  onDeleteComponent={handleDeleteComponent}
                  onAddComponent={handleAddComponent}
                />
              </div>

              {/* Validation Report Card */}
              <div>
                <ValidationReportCard validation={validation} />
              </div>

              {/* Model Compiler & SLX Download Panel */}
              {currentProject && (
                <div>
                  <ModelCompilerPanel
                    projectId={currentProject.id}
                    circuitIr={circuitIr}
                    onGenerateModel={handleGenerateModel}
                    isGenerating={isCompiling}
                    compilationResult={compilationResult}
                  />
                </div>
              )}

              {/* Quick FMEA Fault Injection Card */}
              {currentProject && (
                <div className="bg-slate-900 border border-amber-500/30 rounded-xl p-4 shadow-lg flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="p-2.5 bg-amber-500/20 text-amber-400 rounded-lg">
                      <Flame className="w-5 h-5" />
                    </div>
                    <div>
                      <h4 className="text-xs font-bold text-white">Autonomous Fault Injection Ready</h4>
                      <p className="text-[11px] text-slate-400">Run ISO 26262 FMEA matrix &amp; Simscape waveforms</p>
                    </div>
                  </div>
                  <button
                    onClick={() => setActiveStep(6)}
                    className="px-3 py-1.5 bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-slate-950 font-bold text-xs rounded-lg transition"
                  >
                    Open FMEA Studio &rarr;
                  </button>
                </div>
              )}
            </div>
          </div>
        )}
      </main>

      {/* New Project Modal */}
      <NewProjectModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onProjectCreated={(id) => {
          loadProjectDetails(id);
          api.getProjects().then(setProjects);
        }}
      />
    </div>
  );
}
