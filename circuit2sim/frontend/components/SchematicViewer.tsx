"use client";

import React, { useState, useRef } from "react";
import { ZoomIn, ZoomOut, Maximize2, Eye, EyeOff, Layers, Sparkles, UploadCloud, Loader2 } from "lucide-react";
import { Component, Net, UniversalCircuitIR } from "../types/circuit";
import { api } from "../lib/api";

interface SchematicViewerProps {
  schematicUrl?: string;
  circuitIr?: UniversalCircuitIR;
  selectedComponentId?: string;
  onSelectComponent?: (id: string) => void;
  onUploadSchematic?: (file: File) => void;
  isUploading?: boolean;
}

export const SchematicViewer: React.FC<SchematicViewerProps> = ({
  schematicUrl,
  circuitIr,
  selectedComponentId,
  onSelectComponent,
  onUploadSchematic,
  isUploading = false,
}) => {
  const [zoom, setZoom] = useState(1);
  const [showBoxes, setShowBoxes] = useState(true);
  const [showPins, setShowPins] = useState(true);
  const [showNets, setShowNets] = useState(true);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const fullImageUrl = schematicUrl ? api.getStaticFileUrl(schematicUrl) : "";

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selected = e.target.files?.[0];
    if (selected && onUploadSchematic) {
      onUploadSchematic(selected);
    }
    // Always clear input value so re-uploading a file with the same name triggers onChange
    if (e.target) {
      e.target.value = "";
    }
  };

  return (
    <div className="flex flex-col bg-white border border-slate-200 rounded-xl overflow-hidden shadow-xs">
      <input
        type="file"
        ref={fileInputRef}
        onChange={handleFileChange}
        accept="image/png,image/jpeg,image/webp,application/pdf"
        className="hidden"
      />

      {/* Top Toolbar */}
      <div className="flex items-center justify-between px-4 py-2.5 bg-slate-50 border-b border-slate-200">
        <div className="flex items-center space-x-2">
          <Layers className="w-4 h-4 text-[#0055A5]" />
          <span className="text-xs font-semibold text-slate-800 uppercase tracking-wider">
            Schematic Viewport & AI Detection Overlays
          </span>
          {circuitIr?.components && (
            <span className="text-[10px] font-mono bg-blue-50 text-[#0055A5] border border-blue-200 px-2 py-0.5 rounded font-bold">
              {circuitIr.components.length} components
            </span>
          )}
        </div>

        {/* Controls */}
        <div className="flex items-center space-x-2">
          {/* Direct Schematic Upload / Replace Button */}
          {onUploadSchematic && (
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={isUploading}
              className="flex items-center space-x-1 bg-white hover:bg-blue-50 border border-slate-300 text-[#0055A5] px-2 py-0.5 rounded text-[11px] font-semibold transition cursor-pointer disabled:opacity-50 shadow-2xs"
              title="Upload or replace schematic diagram"
            >
              {isUploading ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                <UploadCloud className="w-3.5 h-3.5" />
              )}
              <span>{fullImageUrl ? "Replace Schematic" : "Upload Schematic"}</span>
            </button>
          )}
          {/* Layer toggles */}
          <div className="flex items-center space-x-1 bg-white border border-slate-200 rounded px-1.5 py-0.5 text-[11px] shadow-2xs">
            <button
              onClick={() => setShowBoxes(!showBoxes)}
              className={`px-1.5 py-0.5 rounded transition ${
                showBoxes ? "bg-blue-50 text-[#0055A5] font-bold" : "text-slate-500 hover:text-slate-800"
              }`}
              title="Toggle Component Bounding Boxes"
            >
              Boxes
            </button>
            <button
              onClick={() => setShowPins(!showPins)}
              className={`px-1.5 py-0.5 rounded transition ${
                showPins ? "bg-blue-50 text-[#0055A5] font-bold" : "text-slate-500 hover:text-slate-800"
              }`}
              title="Toggle Terminals / Pins"
            >
              Pins
            </button>
            <button
              onClick={() => setShowNets(!showNets)}
              className={`px-1.5 py-0.5 rounded transition ${
                showNets ? "bg-blue-50 text-[#0055A5] font-bold" : "text-slate-500 hover:text-slate-800"
              }`}
              title="Toggle Net Connections"
            >
              Nets
            </button>
          </div>

          {/* Zoom controls */}
          <div className="flex items-center space-x-1 bg-white border border-slate-200 rounded px-1.5 py-0.5 text-xs text-slate-700 shadow-2xs">
            <button
              onClick={() => setZoom((z) => Math.max(0.5, z - 0.15))}
              className="p-1 hover:text-[#0055A5] transition"
              title="Zoom Out"
            >
              <ZoomOut className="w-3.5 h-3.5" />
            </button>
            <span className="text-[11px] font-mono px-1 font-bold">{Math.round(zoom * 100)}%</span>
            <button
              onClick={() => setZoom((z) => Math.min(2.5, z + 0.15))}
              className="p-1 hover:text-[#0055A5] transition"
              title="Zoom In"
            >
              <ZoomIn className="w-3.5 h-3.5" />
            </button>
            <button
              onClick={() => setZoom(1)}
              className="p-1 hover:text-[#0055A5] transition ml-1"
              title="Reset View"
            >
              <Maximize2 className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>
      </div>

      {/* Canvas Viewport */}
      <div className="relative overflow-auto bg-slate-950 flex items-center justify-center p-3">
        {fullImageUrl ? (
          <div
            className="relative transition-transform duration-100 ease-out origin-center"
            style={{ transform: `scale(${zoom})` }}
          >
            {/* The Schematic Image */}
            <img
              src={fullImageUrl}
              alt="Uploaded Schematic"
              className="max-w-none rounded-lg border border-slate-800 shadow-2xl block bg-white"
              style={{ maxHeight: "550px", width: "auto" }}
            />

            {/* Overlays SVG Layer */}
            {circuitIr && (
              <div className="absolute inset-0 pointer-events-none">
                {showBoxes &&
                  circuitIr.components.map((comp) => {
                    const bb = comp.bounding_box;
                    if (!bb) return null;
                    const isSelected = selectedComponentId === comp.id;
                    const isUncertain = comp.confidence < 0.85 || comp.uncertainties.length > 0;

                    let borderColor = isSelected
                      ? "border-cyan-400 bg-cyan-500/20 ring-2 ring-cyan-400 shadow-lg shadow-cyan-500/30"
                      : isUncertain
                      ? "border-amber-400/80 bg-amber-500/10 hover:border-amber-400"
                      : "border-emerald-500/70 bg-emerald-500/10 hover:border-emerald-400";

                    return (
                      <div
                        key={comp.id}
                        onClick={(e) => {
                          e.stopPropagation();
                          onSelectComponent?.(comp.id);
                        }}
                        style={{
                          left: `${bb.x}px`,
                          top: `${bb.y}px`,
                          width: `${bb.w}px`,
                          height: `${bb.h}px`,
                        }}
                        className={`absolute border-2 rounded transition-all cursor-pointer pointer-events-auto flex items-start justify-between p-1 ${borderColor}`}
                      >
                        {/* Component Label Tag */}
                        <div className="flex items-center space-x-1 bg-slate-900/90 border border-slate-700 rounded px-1 py-0.5 text-[10px] font-mono text-slate-100 shadow -mt-3 -ml-1">
                          <span className="font-bold text-cyan-400">{comp.id}</span>
                          <span className="text-slate-400">
                            {Object.values(comp.parameters)[0]?.raw_text || comp.type}
                          </span>
                        </div>

                        {/* Confidence Indicator Pill */}
                        <span
                          className={`text-[9px] font-bold font-mono px-1 rounded -mt-3 -mr-1 ${
                            isUncertain
                              ? "bg-amber-950 text-amber-300 border border-amber-800"
                              : "bg-emerald-950 text-emerald-300 border border-emerald-800"
                          }`}
                        >
                          {Math.round(comp.confidence * 100)}%
                        </span>

                        {/* Pins markers */}
                        {showPins &&
                          comp.pins.map((pin, pIdx) => {
                            const isFirst = pIdx === 0;
                            return (
                              <div
                                key={pin}
                                className={`absolute w-3 h-3 rounded-full bg-cyan-500 border border-white text-[8px] font-bold text-white flex items-center justify-center shadow ${
                                  isFirst ? "-left-1.5 top-1/2 -translate-y-1/2" : "-right-1.5 top-1/2 -translate-y-1/2"
                                }`}
                              >
                                {pin}
                              </div>
                            );
                          })}
                      </div>
                    );
                  })}
              </div>
            )}
          </div>
        ) : (
          <div
            onClick={() => onUploadSchematic && fileInputRef.current?.click()}
            className={`flex flex-col items-center justify-center text-center p-8 border-2 border-dashed border-slate-800 hover:border-cyan-500/60 rounded-2xl bg-slate-900/50 hover:bg-slate-900/90 transition-all ${
              onUploadSchematic ? "cursor-pointer group" : ""
            }`}
          >
            <div className="w-14 h-14 rounded-2xl bg-slate-800/80 group-hover:bg-cyan-950/60 border border-slate-700 group-hover:border-cyan-500/50 flex items-center justify-center mb-3 transition">
              <UploadCloud className="w-7 h-7 text-slate-400 group-hover:text-cyan-400 transition" />
            </div>
            <p className="text-sm font-semibold text-slate-300 group-hover:text-cyan-300 transition">
              {onUploadSchematic ? "Click to Upload Schematic Diagram" : "No schematic uploaded yet"}
            </p>
            <p className="text-xs text-slate-500 mt-1 max-w-sm">
              Supports PNG, JPG, or PDF schematic files. Uploading immediately clears previous analysis and prepares for recognition.
            </p>
            {onUploadSchematic && (
              <button
                type="button"
                className="mt-4 px-4 py-1.5 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white font-medium text-xs shadow-lg shadow-cyan-600/20 group-hover:scale-105 transition"
              >
                Choose Schematic File
              </button>
            )}
          </div>
        )}
      </div>

      {/* Bottom Hint */}
      <div className="px-4 py-2 bg-slate-50 border-t border-slate-200 text-[11px] text-slate-500 flex items-center justify-between">
        <span>Click on any bounding box to focus and inspect component properties in the Review panel.</span>
        <span className="text-slate-400 font-mono">Coordinate Space: 2D Pixel Grid</span>
      </div>
    </div>
  );
};
