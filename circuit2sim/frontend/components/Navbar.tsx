"use client";

import React from "react";
import { Cpu, Layers, Plus, CheckCircle2, AlertTriangle } from "lucide-react";
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
    <header className="border-b border-slate-200 bg-white/95 backdrop-blur-md sticky top-0 z-40 text-slate-800 shadow-xs">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
        {/* KONE Brand */}
        <div className="flex items-center space-x-3.5">
          <div className="h-9 w-9 rounded-lg bg-[#0055A5] flex items-center justify-center shadow-md shadow-blue-900/10">
            <span className="font-black text-white text-xs tracking-tighter">KONE</span>
          </div>
          <div>
            <div className="flex items-center space-x-2">
              <span className="font-bold text-lg tracking-tight text-slate-900">
                Circuit2Sim
              </span>
              <span className="text-[10px] font-bold tracking-wider uppercase px-2 py-0.5 rounded-full bg-blue-50 text-[#0055A5] border border-blue-200">
                BCX14 SUITE
              </span>
            </div>
            <p className="text-[11px] text-slate-500 leading-none">
              Electrical Schematic to Native MATLAB Simscape Models
            </p>
          </div>
        </div>

        {/* Center: Project Switcher */}
        <div className="hidden md:flex items-center space-x-2.5 bg-slate-50 border border-slate-200 rounded-lg px-3 py-1.5">
          <Layers className="w-4 h-4 text-[#0055A5]" />
          <span className="text-xs text-slate-500 font-medium">Project:</span>
          <select
            value={currentProject?.id || ""}
            onChange={(e) => onSelectProject(e.target.value)}
            className="bg-transparent text-xs font-semibold text-slate-800 focus:outline-none cursor-pointer pr-3"
          >
            {projects.length === 0 && <option value="">No projects available</option>}
            {projects.map((p) => (
              <option key={p.id} value={p.id} className="bg-white text-slate-800">
                {p.name} ({p.id.slice(0, 6)})
              </option>
            ))}
          </select>
        </div>

        {/* Right Actions */}
        <div className="flex items-center space-x-3">
          {/* Target Simulator Badge */}
          <div className="hidden lg:flex items-center space-x-2 px-2.5 py-1 rounded-md bg-sky-50 border border-sky-200 text-[11px] text-[#0055A5] font-medium">
            <span className="w-2 h-2 rounded-full bg-[#0055A5] animate-pulse" />
            <span>Simscape Electrical (.slx)</span>
          </div>

          {/* Backend Status indicator */}
          <div className="flex items-center space-x-1.5 text-xs">
            {apiOnline ? (
              <span className="inline-flex items-center text-emerald-700 text-[11px] font-medium bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
                <CheckCircle2 className="w-3 h-3 mr-1 text-emerald-600" /> Connected
              </span>
            ) : (
              <span className="inline-flex items-center text-amber-700 text-[11px] font-medium bg-amber-50 border border-amber-200 px-2 py-0.5 rounded-full">
                <AlertTriangle className="w-3 h-3 mr-1 text-amber-600" /> Offline
              </span>
            )}
          </div>

          {/* New Project Button */}
          <button
            onClick={onOpenNewProject}
            className="inline-flex items-center space-x-1.5 px-3.5 py-1.5 rounded-lg bg-[#0055A5] hover:bg-[#004385] text-white text-xs font-semibold shadow-sm transition-all active:scale-95"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>New Project</span>
          </button>
        </div>
      </div>
    </header>
  );
};
