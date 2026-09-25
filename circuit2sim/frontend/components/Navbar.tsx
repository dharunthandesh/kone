"use client";

import React from "react";
import { Cpu, Layers, Plus, Activity, CheckCircle2, AlertTriangle } from "lucide-react";
import { Project } from "../types/circuit";

interface NavbarProps {
  currentProject: Project | null;
  projects: Project[];
  onSelectProject: (id: string) => void;
  onOpenNewProject: () => void;
  apiOnline: boolean;
}

export const Navbar: React.FC<NavbarProps> = ({
  currentProject,
  projects,
  onSelectProject,
  onOpenNewProject,
  apiOnline,
}) => {
  return (
    <header className="border-b border-slate-800 bg-slate-950/80 backdrop-blur-md sticky top-0 z-40 text-slate-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* Brand */}
        <div className="flex items-center space-x-3">
          <div className="h-9 w-9 rounded-lg bg-gradient-to-tr from-cyan-600 to-blue-500 flex items-center justify-center shadow-lg shadow-cyan-500/20 border border-cyan-400/30">
            <Cpu className="w-5 h-5 text-white" />
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <span className="font-bold text-lg tracking-tight bg-gradient-to-r from-white via-slate-100 to-slate-400 bg-clip-text text-transparent">
                Circuit2Sim
              </span>
              <span className="text-[10px] font-semibold tracking-wider uppercase px-1.5 py-0.5 rounded bg-cyan-950/80 text-cyan-400 border border-cyan-800/50">
                v0.1-mvp
              </span>
            </div>
            <p className="text-[11px] text-slate-400 leading-none">
              Schematic → Native Editable Simulink/Simscape Models
            </p>
          </div>
        </div>

        {/* Center: Project Switcher */}
        <div className="hidden md:flex items-center space-x-3 bg-slate-900/90 border border-slate-800 rounded-lg px-3 py-1.5 shadow-inner">
          <Layers className="w-4 h-4 text-cyan-400" />
          <span className="text-xs text-slate-400 font-medium">Project:</span>
          <select
            value={currentProject?.id || ""}
            onChange={(e) => onSelectProject(e.target.value)}
            className="bg-transparent text-xs font-semibold text-slate-200 focus:outline-none cursor-pointer pr-4"
          >
            {projects.length === 0 && <option value="">No projects available</option>}
            {projects.map((p) => (
              <option key={p.id} value={p.id} className="bg-slate-900 text-slate-200">
                {p.name} ({p.id.slice(0, 6)})
              </option>
            ))}
          </select>
        </div>

        {/* Right Actions */}
        <div className="flex items-center space-x-3">
          {/* Target Simulator Badge */}
          <div className="hidden lg:flex items-center space-x-2 px-2.5 py-1 rounded-md bg-blue-950/40 border border-blue-800/50 text-[11px] text-blue-300 font-mono">
            <span className="w-2 h-2 rounded-full bg-blue-400 animate-pulse" />
            <span>Target: MATLAB Simscape (.slx)</span>
          </div>

          {/* Backend Status indicator */}
          <div className="flex items-center space-x-1.5 text-xs">
            {apiOnline ? (
              <span className="inline-flex items-center text-emerald-400 text-[11px] font-medium bg-emerald-950/40 border border-emerald-800/50 px-2 py-0.5 rounded">
                <CheckCircle2 className="w-3 h-3 mr-1" /> API Connected
              </span>
            ) : (
              <span className="inline-flex items-center text-amber-400 text-[11px] font-medium bg-amber-950/40 border border-amber-800/50 px-2 py-0.5 rounded">
                <AlertTriangle className="w-3 h-3 mr-1" /> API Offline
              </span>
            )}
          </div>

          {/* New Project Button */}
          <button
            onClick={onOpenNewProject}
            className="inline-flex items-center space-x-1.5 px-3 py-1.5 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold shadow-md shadow-cyan-600/20 transition-all border border-cyan-400/30 active:scale-95"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>New Project</span>
          </button>
        </div>
      </div>
    </header>
  );
};
