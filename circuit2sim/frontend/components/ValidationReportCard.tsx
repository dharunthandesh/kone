"use client";

import React from "react";
import { CheckCircle2, AlertTriangle, XCircle, ShieldCheck, Activity } from "lucide-react";
import { ValidationReport } from "../types/circuit";

interface ValidationReportCardProps {
  validation?: ValidationReport;
}

export const ValidationReportCard: React.FC<ValidationReportCardProps> = ({ validation }) => {
  if (!validation) {
    return (
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-4 text-center text-slate-500 text-xs">
        Validation report will be generated automatically upon schematic analysis.
      </div>
    );
  }

  const isPass = validation.status === "PASS";
  const isWarning = validation.status === "WARNING";
  const isFail = validation.status === "FAIL";

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-xl overflow-hidden shadow-xl">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 bg-slate-950/90 border-b border-slate-800">
        <div className="flex items-center space-x-2">
          <ShieldCheck className="w-4 h-4 text-cyan-400" />
          <h3 className="text-xs font-semibold text-slate-200 uppercase tracking-wider">
            Topological & Simulation Validation
          </h3>
        </div>

        {/* Global Status Banner */}
        <div>
          {isPass && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-emerald-950 text-emerald-300 border border-emerald-800">
              <CheckCircle2 className="w-3.5 h-3.5 mr-1 text-emerald-400" /> PASS ✓ READY
            </span>
          )}
          {isWarning && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-amber-950 text-amber-300 border border-amber-800 animate-pulse">
              <AlertTriangle className="w-3.5 h-3.5 mr-1 text-amber-400" /> WARNINGS REQUIRE VERIFICATION
            </span>
          )}
          {isFail && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-rose-950 text-rose-300 border border-rose-800">
              <XCircle className="w-3.5 h-3.5 mr-1 text-rose-400" /> TOPOLOGY INVALID ✕
            </span>
          )}
        </div>
      </div>

      {/* Grid of Key Metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 p-4 bg-slate-950/40 border-b border-slate-800 text-xs font-mono">
        {/* Components */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-lg p-3">
          <span className="text-[11px] text-slate-400 block font-sans">COMPONENTS</span>
          <div className="text-base font-bold text-slate-100 mt-1 flex items-center justify-between">
            <span>
              {validation.components_verified} / {validation.components_total}
            </span>
            <span className="text-emerald-400 text-xs">✓</span>
          </div>
          <span className="text-[10px] text-slate-500 font-sans">detected & mapped</span>
        </div>

        {/* Connections */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-lg p-3">
          <span className="text-[11px] text-slate-400 block font-sans">CONNECTIONS</span>
          <div className="text-base font-bold text-slate-100 mt-1 flex items-center justify-between">
            <span>
              {validation.connections_verified} / {validation.connections_total}
            </span>
            <span className="text-emerald-400 text-xs">✓</span>
          </div>
          <span className="text-[10px] text-slate-500 font-sans">nets reconstructed</span>
        </div>

        {/* Parameters */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-lg p-3">
          <span className="text-[11px] text-slate-400 block font-sans">PARAMETERS</span>
          <div className="text-base font-bold text-slate-100 mt-1 flex items-center justify-between">
            <span>
              {validation.parameters_verified} / {validation.parameters_total}
            </span>
            {validation.parameters_uncertain > 0 ? (
              <span className="text-amber-400 text-xs">⚠ {validation.parameters_uncertain}</span>
            ) : (
              <span className="text-emerald-400 text-xs">✓</span>
            )}
          </div>
          <span className="text-[10px] text-slate-500 font-sans">
            {validation.parameters_uncertain > 0 ? "requires verification" : "all nominals validated"}
          </span>
        </div>

        {/* Ground Reference */}
        <div className="bg-slate-900/80 border border-slate-800 rounded-lg p-3">
          <span className="text-[11px] text-slate-400 block font-sans">ELECTRICAL REF</span>
          <div className="text-base font-bold text-slate-100 mt-1 flex items-center justify-between">
            <span>{validation.has_ground_reference ? "Present" : "Missing"}</span>
            {validation.has_ground_reference ? (
              <span className="text-emerald-400 text-xs">✓</span>
            ) : (
              <span className="text-rose-400 text-xs">✕</span>
            )}
          </div>
          <span className="text-[10px] text-slate-500 font-sans">chassis reference node</span>
        </div>
      </div>

      {/* Warnings & Errors List */}
      {(validation.warnings.length > 0 || validation.errors.length > 0) && (
        <div className="p-4 space-y-2 text-xs">
          {validation.errors.map((err, i) => (
            <div
              key={`err-${i}`}
              className="flex items-start space-x-2 bg-rose-950/40 border border-rose-800/80 rounded-lg p-2.5 text-rose-200"
            >
              <XCircle className="w-4 h-4 text-rose-400 shrink-0 mt-0.5" />
              <div>
                <span className="font-bold uppercase tracking-wider text-[10px] text-rose-300 block">
                  Critical Error
                </span>
                <span>{err}</span>
              </div>
            </div>
          ))}

          {validation.warnings.map((warn, i) => (
            <div
              key={`warn-${i}`}
              className="flex items-start space-x-2 bg-amber-950/40 border border-amber-800/80 rounded-lg p-2.5 text-amber-200"
            >
              <AlertTriangle className="w-4 h-4 text-amber-400 shrink-0 mt-0.5" />
              <div>
                <span className="font-bold uppercase tracking-wider text-[10px] text-amber-300 block">
                  Notice — Verification Recommended
                </span>
                <span>{warn}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
