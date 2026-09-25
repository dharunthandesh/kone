"use client";

import React, { useState } from "react";
import { UploadCloud, FileImage, Sparkles, X, Check, ArrowRight, Loader2 } from "lucide-react";
import { api } from "../lib/api";

interface NewProjectModalProps {
  isOpen: boolean;
  onClose: () => void;
  onProjectCreated: (projectId: string) => void;
}

export const NewProjectModal: React.FC<NewProjectModalProps> = ({
  isOpen,
  onClose,
  onProjectCreated,
}) => {
  const [name, setName] = useState("");
  const [desc, setDesc] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedBenchmark, setSelectedBenchmark] = useState<string | null>(null);
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  // Always reset fields when modal opens or closes
  React.useEffect(() => {
    if (isOpen) {
      setName("");
      setDesc("");
      setFile(null);
      setSelectedBenchmark(null);
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
    }
  }, [isOpen]);

  if (!isOpen) return null;

  const handleCreateCustom = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    setIsSubmitting(true);
    try {
      const proj = await api.createProject(name, desc);
      if (file) {
        await api.uploadSchematic(proj.id, file);
      }
      setName("");
      setDesc("");
      setFile(null);
      if (fileInputRef.current) {
        fileInputRef.current.value = "";
      }
      onProjectCreated(proj.id);
      onClose();
    } catch (err: any) {
      alert(err.message || "Failed to create project");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleLoadBenchmark = async (sampleId: string) => {
    setIsSubmitting(true);
    try {
      const res = await api.loadSample(sampleId);
      onProjectCreated(res.project_id);
      onClose();
    } catch (err: any) {
      alert(err.message || "Failed to load benchmark");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
      <div className="bg-slate-900 border border-slate-800 rounded-2xl max-w-xl w-full p-6 shadow-2xl relative">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-slate-400 hover:text-slate-200 transition"
        >
          <X className="w-5 h-5" />
        </button>

        <div className="flex items-center space-x-2 mb-1">
          <Sparkles className="w-5 h-5 text-cyan-400" />
          <h2 className="text-lg font-bold text-slate-100">Create Circuit Simulation Project</h2>
        </div>
        <p className="text-xs text-slate-400 mb-6">
          Upload an electrical circuit diagram or launch a verified benchmark preset.
        </p>

        {/* Option A: Quick Calibrated Benchmarks */}
        <div className="mb-6">
          <span className="text-xs font-semibold uppercase tracking-wider text-slate-400 block mb-2">
            Option 1: Calibrated Benchmarks (Instant 1-Click Verification)
          </span>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <button
              type="button"
              disabled={isSubmitting}
              onClick={() => handleLoadBenchmark("rc_filter")}
              className="text-left p-3 rounded-xl bg-slate-950 border border-slate-800 hover:border-cyan-500 hover:bg-slate-900 transition group cursor-pointer"
            >
              <div className="flex items-center justify-between text-xs font-bold text-slate-200 group-hover:text-cyan-400">
                <span>RC Low-Pass Filter</span>
                <ArrowRight className="w-3.5 h-3.5 transition transform group-hover:translate-x-1" />
              </div>
              <p className="text-[11px] text-slate-400 mt-1">
                12V Supply, 10kΩ series resistor, 100nF capacitor, ground reference.
              </p>
            </button>

            <button
              type="button"
              disabled={isSubmitting}
              onClick={() => handleLoadBenchmark("rlc_resonant")}
              className="text-left p-3 rounded-xl bg-slate-950 border border-slate-800 hover:border-cyan-500 hover:bg-slate-900 transition group cursor-pointer"
            >
              <div className="flex items-center justify-between text-xs font-bold text-slate-200 group-hover:text-cyan-400">
                <span>Series RLC Resonant Stage</span>
                <ArrowRight className="w-3.5 h-3.5 transition transform group-hover:translate-x-1" />
              </div>
              <p className="text-[11px] text-slate-400 mt-1">
                24V Source, 22Ω damping resistor, 1mH inductor, 470nF capacitor.
              </p>
            </button>
          </div>
        </div>

        <div className="relative flex py-2 items-center">
          <div className="flex-grow border-t border-slate-800"></div>
          <span className="flex-shrink mx-4 text-xs font-mono text-slate-500 uppercase">Or upload schematic</span>
          <div className="flex-grow border-t border-slate-800"></div>
        </div>

        {/* Option B: Custom Schematic Form */}
        <form onSubmit={handleCreateCustom} className="space-y-4 mt-2">
          <div>
            <label className="block text-xs font-medium text-slate-300 mb-1">
              Project Name *
            </label>
            <input
              type="text"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. DC-DC Buck Filter Stage"
              className="w-full bg-slate-950 border border-slate-800 rounded-lg px-3 py-2 text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:ring-1 focus:ring-cyan-500"
            />
          </div>

          <div>
            <label className="block text-xs font-medium text-slate-300 mb-1">
              Schematic File (PNG, JPG, PDF)
            </label>
            <div className="border-2 border-dashed border-slate-800 hover:border-cyan-500 rounded-xl p-4 text-center cursor-pointer transition bg-slate-950/60 relative">
              <input
                ref={fileInputRef}
                type="file"
                accept=".png,.jpg,.jpeg,.pdf,.bmp"
                onChange={(e) => setFile(e.target.files?.[0] || null)}
                className="absolute inset-0 opacity-0 cursor-pointer"
              />
              <UploadCloud className="w-6 h-6 text-slate-400 mx-auto mb-1" />
              {file ? (
                <div className="flex items-center justify-center space-x-2">
                  <span className="text-xs font-mono text-cyan-400 font-semibold">{file.name}</span>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setFile(null);
                      if (fileInputRef.current) fileInputRef.current.value = "";
                    }}
                    className="text-xs text-rose-400 hover:text-rose-300 font-bold px-1.5 py-0.5 rounded bg-rose-950/40 border border-rose-800/40 relative z-10"
                  >
                    Remove
                  </button>
                </div>
              ) : (
                <div className="text-[11px] text-slate-400">
                  <span className="font-semibold text-slate-200">Click to browse</span> or drag and drop schematic
                </div>
              )}
            </div>
          </div>

          <div className="flex items-center justify-end space-x-2 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="px-3 py-1.5 rounded-lg border border-slate-700 text-xs text-slate-400 hover:text-slate-200"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting || !name.trim()}
              className="inline-flex items-center space-x-1.5 px-4 py-1.5 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-bold transition disabled:opacity-50"
            >
              {isSubmitting && <Loader2 className="w-3.5 h-3.5 animate-spin" />}
              <span>Create Project</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
