"use client";

import React, { useState } from "react";
import { UploadCloud, Sparkles, X, ArrowRight, Loader2 } from "lucide-react";
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
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/40 backdrop-blur-xs p-4">
      <div className="bg-white border border-slate-200 rounded-2xl max-w-xl w-full p-6 shadow-2xl relative">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-slate-400 hover:text-slate-700 transition"
        >
          <X className="w-5 h-5" />
        </button>

        <div className="flex items-center space-x-2 mb-1">
          <Sparkles className="w-5 h-5 text-[#0055a5]" />
          <h2 className="text-lg font-bold text-slate-900">Create Circuit Simulation Project</h2>
        </div>
        <p className="text-xs text-slate-500 mb-6">
          Upload an electrical circuit diagram or launch a verified benchmark preset.
        </p>

        {/* Option A: Quick Calibrated Benchmarks */}
        <div className="mb-6">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 block mb-2">
            Option 1: Calibrated Benchmarks (Instant 1-Click Verification)
          </span>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
            <button
              type="button"
              disabled={isSubmitting}
              onClick={() => handleLoadBenchmark("kone_bcx14_brake")}
              className="text-left p-3.5 rounded-xl bg-blue-50/70 border-2 border-[#0055a5] hover:bg-blue-100/50 transition group cursor-pointer shadow-xs sm:col-span-3"
            >
              <div className="flex items-center justify-between text-xs font-bold text-[#0055a5]">
                <span className="flex items-center space-x-1.5">
                  <span className="inline-block w-2 h-2 rounded-full bg-[#0055a5] animate-pulse"></span>
                  <span>KONE BCX14 Elevator Brake Controller (230V Mains Input)</span>
                </span>
                <span className="text-[10px] font-mono bg-[#0055a5] text-white px-2 py-0.5 rounded font-bold">
                  Recommended Primary
                </span>
              </div>
              <p className="text-[11px] text-slate-600 mt-1.5">
                230V AC Single-Phase Elevator Mains (XB11), Diode Bridge (D2), Inrush Stage (R122), 230V Hoist Machine Brake Solenoid (L_BRAKE), 450V DC Link Bank (C82), and 385V MOV Snubber (RV3).
              </p>
            </button>

            <button
              type="button"
              disabled={isSubmitting}
              onClick={() => handleLoadBenchmark("rc_filter")}
              className="text-left p-3.5 rounded-xl bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/50 transition group cursor-pointer shadow-2xs"
            >
              <div className="flex items-center justify-between text-xs font-bold text-slate-800 group-hover:text-[#0055a5]">
                <span>RC Low-Pass Filter</span>
                <ArrowRight className="w-3.5 h-3.5 transition transform group-hover:translate-x-1" />
              </div>
              <p className="text-[11px] text-slate-500 mt-1">
                12V Supply, 10kΩ series resistor, 100nF capacitor.
              </p>
            </button>

            <button
              type="button"
              disabled={isSubmitting}
              onClick={() => handleLoadBenchmark("rlc_resonant")}
              className="text-left p-3.5 rounded-xl bg-slate-50 border border-slate-200 hover:border-[#0055a5] hover:bg-blue-50/50 transition group cursor-pointer shadow-2xs sm:col-span-2"
            >
              <div className="flex items-center justify-between text-xs font-bold text-slate-800 group-hover:text-[#0055a5]">
                <span>Series RLC Resonant Stage</span>
                <ArrowRight className="w-3.5 h-3.5 transition transform group-hover:translate-x-1" />
              </div>
              <p className="text-[11px] text-slate-500 mt-1">
                24V Source, 22Ω damping resistor, 1mH inductor, 470nF capacitor.
              </p>
            </button>
          </div>
        </div>

        <div className="relative flex py-2 items-center">
          <div className="flex-grow border-t border-slate-200"></div>
          <span className="flex-shrink mx-4 text-xs font-mono text-slate-400 uppercase">Or upload schematic</span>
          <div className="flex-grow border-t border-slate-200"></div>
        </div>

        {/* Option B: Custom Schematic Form */}
        <form onSubmit={handleCreateCustom} className="space-y-4 mt-2">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Project Name *
            </label>
            <input
              type="text"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. DC-DC Buck Filter Stage"
              className="w-full bg-white border border-slate-300 rounded-lg px-3 py-2 text-xs text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-1 focus:ring-[#0055a5]"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Schematic File (PNG, JPG, PDF)
            </label>
            <div className="border-2 border-dashed border-slate-300 hover:border-[#0055a5] rounded-xl p-4 text-center cursor-pointer transition bg-slate-50/50 relative">
              <input
                ref={fileInputRef}
                type="file"
                accept=".png,.jpg,.jpeg,.pdf,.bmp"
                onChange={(e) => setFile(e.target.files?.[0] || null)}
                className="absolute inset-0 opacity-0 cursor-pointer"
              />
              <UploadCloud className="w-6 h-6 text-[#0055a5] mx-auto mb-1" />
              {file ? (
                <div className="flex items-center justify-center space-x-2">
                  <span className="text-xs font-mono text-[#0055a5] font-semibold">{file.name}</span>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setFile(null);
                      if (fileInputRef.current) fileInputRef.current.value = "";
                    }}
                    className="text-xs text-rose-600 hover:text-rose-700 font-bold px-1.5 py-0.5 rounded bg-rose-50 border border-rose-200 relative z-10"
                  >
                    Remove
                  </button>
                </div>
              ) : (
                <div className="text-[11px] text-slate-500">
                  <span className="font-semibold text-slate-800">Click to browse</span> or drag and drop schematic
                </div>
              )}
            </div>
          </div>

          <div className="flex items-center justify-end space-x-2 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="px-3.5 py-1.5 rounded-lg border border-slate-300 text-xs font-medium text-slate-600 hover:text-slate-800 hover:bg-slate-50 transition"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting || !name.trim()}
              className="inline-flex items-center space-x-1.5 px-4 py-1.5 rounded-lg bg-[#0055a5] hover:bg-[#004385] text-white text-xs font-bold transition disabled:opacity-50 shadow-xs"
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
