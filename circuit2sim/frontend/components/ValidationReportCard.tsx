"use client";

import React from "react";
import { CheckCircle2, AlertTriangle, XCircle, ShieldCheck } from "lucide-react";
import { ValidationReport } from "../types/circuit";

interface ValidationReportCardProps {
  validation?: ValidationReport;
}

export const ValidationReportCard: React.FC<ValidationReportCardProps> = ({ validation }) => {
  if (!validation) {
    return (
      <div className="bg-white border border-slate-200 rounded-xl p-4 text-center text-slate-400 text-xs shadow-xs">
        Validation report will be generated automatically upon schematic analysis.
      </div>
    );
  }

  const isPass = validation.status === "PASS";
  const isWarning = validation.status === "WARNING";
  const isFail = validation.status === "FAIL";

  return (
    <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-xs">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 bg-slate-50 border-b border-slate-200">
        <div className="flex items-center space-x-2">
          <ShieldCheck className="w-4 h-4 text-[#0055a5]" />
          <h3 className="text-xs font-bold text-slate-800 uppercase tracking-wider">
            Topological & Simulation Validation
          </h3>
        </div>

        {/* Global Status Banner */}
        <div>
          {isPass && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
              <CheckCircle2 className="w-3.5 h-3.5 mr-1 text-emerald-600" /> PASS ✓ READY
            </span>
          )}
          {isWarning && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-amber-50 text-amber-700 border border-amber-200">
              <AlertTriangle className="w-3.5 h-3.5 mr-1 text-amber-600" /> WARNINGS REQUIRE VERIFICATION
            </span>
          )}
          {isFail && (
            <span className="inline-flex items-center space-x-1 px-2.5 py-0.5 rounded text-xs font-bold bg-rose-50 text-rose-700 border border-rose-200">
              <XCircle className="w-3.5 h-3.5 mr-1 text-rose-600" /> TOPOLOGY INVALID ✕
            </span>
          )}
        </div>
      </div>

      {/* Grid of Key Metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 p-4 bg-slate-50/50 border-b border-slate-200 text-xs font-mono">
        {/* Components */}
        <div className="bg-white border border-slate-200 rounded-lg p-3 shadow-xs">
          <span className="text-[11px] text-slate-500 block font-sans font-medium">COMPONENTS</span>
          <div className="text-base font-bold text-slate-900 mt-1 flex items-center justify-between">
            <span>
              {validation.components_verified} / {validation.components_total}
            </span>
            <span className="text-emerald-600 text-xs font-bold">✓</span>
          </div>
          <span className="text-[10px] text-slate-400 font-sans">detected & mapped</span>
        </div>

        {/* Connections */}
        <div className="bg-white border border-slate-200 rounded-lg p-3 shadow-xs">
          <span className="text-[11px] text-slate-500 block font-sans font-medium">CONNECTIONS</span>
          <div className="text-base font-bold text-slate-900 mt-1 flex items-center justify-between">
            <span>
              {validation.connections_verified} / {validation.connections_total}
            </span>
            <span className="text-emerald-600 text-xs font-bold">✓</span>
          </div>
          <span className="text-[10px] text-slate-400 font-sans">nets reconstructed</span>
        </div>

        {/* Parameters */}
        <div className="bg-white border border-slate-200 rounded-lg p-3 shadow-xs">
          <span className="text-[11px] text-slate-500 block font-sans font-medium">PARAMETERS</span>
          <div className="text-base font-bold text-slate-900 mt-1 flex items-center justify-between">
            <span>
              {validation.parameters_verified} / {validation.parameters_total}
            </span>
            {validation.parameters_uncertain > 0 ? (
              <span className="text-amber-600 text-xs font-bold">⚠ {validation.parameters_uncertain}</span>
            ) : (
              <span className="text-emerald-600 text-xs font-bold">✓</span>
            )}
          </div>
          <span className="text-[10px] text-slate-400 font-sans">
            {validation.parameters_uncertain > 0 ? "requires verification" : "all nominals validated"}
          </span>
        </div>

        {/* Ground Reference */}
        <div className="bg-white border border-slate-200 rounded-lg p-3 shadow-xs">
          <span className="text-[11px] text-slate-500 block font-sans font-medium">ELECTRICAL REF</span>
          <div className="text-base font-bold text-slate-900 mt-1 flex items-center justify-between">
            <span>{validation.has_ground_reference ? "Present" : "Missing"}</span>
            {validation.has_ground_reference ? (
              <span className="text-emerald-600 text-xs font-bold">✓</span>
            ) : (
              <span className="text-rose-600 text-xs font-bold">✕</span>
            )}
          </div>
          <span className="text-[10px] text-slate-400 font-sans">chassis reference node</span>
        </div>
      </div>

      {/* Warnings & Errors List */}
      {(validation.warnings.length > 0 || validation.errors.length > 0) && (
        <div className="p-4 space-y-2 text-xs">
          {validation.errors.map((err, i) => (
            <div
              key={`err-${i}`}
              className="flex items-start space-x-2 bg-rose-50 border border-rose-200 rounded-lg p-2.5 text-rose-800"
            >
              <XCircle className="w-4 h-4 text-rose-600 shrink-0 mt-0.5" />
              <div>
                <span className="font-bold uppercase tracking-wider text-[10px] text-rose-700 block">
                  Critical Error
                </span>
                <span>{err}</span>
              </div>
            </div>
          ))}

          {validation.warnings.map((warn, i) => (
            <div
              key={`warn-${i}`}
              className="flex items-start space-x-2 bg-amber-50 border border-amber-200 rounded-lg p-2.5 text-amber-800"
            >
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <div>
                <span className="font-bold uppercase tracking-wider text-[10px] text-amber-700 block">
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
