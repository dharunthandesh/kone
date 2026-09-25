"use client";

import React, { useState, useRef } from "react";
import { ZoomIn, ZoomOut, Maximize2, Layers, UploadCloud, Loader2 } from "lucide-react";
import { UniversalCircuitIR } from "../types/circuit";
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
  const [imgNaturalSize, setImgNaturalSize] = useState<{ w: number; h: number }>({ w: 1000, h: 650 });
  const fileInputRef = useRef<HTMLInputElement>(null);

  const fullImageUrl = schematicUrl ? api.getStaticFileUrl(schematicUrl) : "";

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selected = e.target.files?.[0];
    if (selected && onUploadSchematic) {
      onUploadSchematic(selected);
    }
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
      <div className="relative overflow-auto bg-slate-100 flex items-center justify-center p-4 min-h-[360px]">
        {fullImageUrl ? (
          <div
            className="relative transition-transform duration-100 ease-out origin-center inline-block"
            style={{ transform: `scale(${zoom})` }}
          >
            {/* The Schematic Image */}
            <img
              src={fullImageUrl}
              alt="Uploaded Schematic"
              onLoad={(e) => {
                const nw = e.currentTarget.naturalWidth;
                const nh = e.currentTarget.naturalHeight;
                if (nw > 0 && nh > 0) {
                  setImgNaturalSize({ w: nw, h: nh });
                }
              }}
              className="max-w-none rounded-lg border border-slate-300 shadow-sm block bg-white"
              style={{ maxHeight: "550px", width: "auto" }}
            />

            {/* Overlays Layer - Scaled by exact percentage relative to natural image dimensions */}
            {circuitIr && (
              <div className="absolute inset-0 pointer-events-none">
                {showBoxes &&
                  circuitIr.components.map((comp) => {
                    const bb = comp.bounding_box;
                    if (!bb) return null;
                    const isSelected = selectedComponentId === comp.id;
                    const isUncertain = comp.confidence < 0.85 || comp.uncertainties.length > 0;

                    // Calculate invariant percentage coordinates
                    const leftPct = (bb.x / imgNaturalSize.w) * 100;
                    const topPct = (bb.y / imgNaturalSize.h) * 100;
                    const widthPct = (bb.w / imgNaturalSize.w) * 100;
                    const heightPct = (bb.h / imgNaturalSize.h) * 100;

                    const isVertical = comp.orientation === 90 || bb.h > bb.w * 1.35;
                    const isGround = comp.type === "ground";

                    let boxStyle = isSelected
                      ? "border-[#0055A5] bg-[#0055A5]/15 ring-2 ring-[#0055A5] shadow-md"
                      : isUncertain
                      ? "border-amber-500 bg-amber-500/10 hover:border-amber-600"
                      : "border-emerald-500/80 bg-emerald-500/10 hover:border-emerald-600";

                    return (
                      <div
                        key={comp.id}
                        onClick={(e) => {
                          e.stopPropagation();
                          onSelectComponent?.(comp.id);
                        }}
                        style={{
                          left: `${leftPct}%`,
                          top: `${topPct}%`,
                          width: `${widthPct}%`,
                          height: `${heightPct}%`,
                        }}
                        className={`absolute border-2 rounded transition-all cursor-pointer pointer-events-auto ${boxStyle}`}
                      >
                        {/* Component Label Tag floating cleanly above box */}
                        <div className="absolute -top-6 left-0 flex items-center space-x-1 bg-white/95 border border-slate-300 shadow-xs px-1.5 py-0.5 rounded text-[10px] font-mono whitespace-nowrap z-20">
                          <span className="font-bold text-[#0055A5]">{comp.id}</span>
                          <span className="text-slate-600 font-medium">
                            {Object.values(comp.parameters)[0]?.raw_text || comp.type}
                          </span>
                          <span
                            className={`text-[8px] font-bold px-1 rounded ml-0.5 ${
                              isUncertain
                                ? "bg-amber-100 text-amber-800"
                                : "bg-emerald-100 text-emerald-800"
                            }`}
                          >
                            {Math.round(comp.confidence * 100)}%
                          </span>
                        </div>

                        {/* Pins markers aligned to terminals */}
                        {showPins && (
                          <>
                            {isGround ? (
                              <div
                                className="absolute -top-1.5 left-1/2 -translate-x-1/2 w-3.5 h-3.5 rounded-full bg-[#0055A5] border border-white text-[8px] font-bold text-white flex items-center justify-center shadow"
                                title="GND Terminal"
                              >
                                1
                              </div>
                            ) : isVertical ? (
                              <>
                                <div
                                  className="absolute -top-1.5 left-1/2 -translate-x-1/2 w-3.5 h-3.5 rounded-full bg-[#0055A5] border border-white text-[8px] font-bold text-white flex items-center justify-center shadow"
                                  title={`Pin ${comp.pins[0] || '1'}`}
                                >
                                  {comp.pins[0] || '1'}
                                </div>
                                <div
                                  className="absolute -bottom-1.5 left-1/2 -translate-x-1/2 w-3.5 h-3.5 rounded-full bg-[#0055A5] border border-white text-[8px] font-bold text-white flex items-center justify-center shadow"
                                  title={`Pin ${comp.pins[1] || '2'}`}
                                >
                                  {comp.pins[1] || '2'}
                                </div>
                              </>
                            ) : (
                              <>
                                <div
                                  className="absolute -left-1.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 rounded-full bg-[#0055A5] border border-white text-[8px] font-bold text-white flex items-center justify-center shadow"
                                  title={`Pin ${comp.pins[0] || '1'}`}
                                >
                                  {comp.pins[0] || '1'}
                                </div>
                                <div
                                  className="absolute -right-1.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 rounded-full bg-[#0055A5] border border-white text-[8px] font-bold text-white flex items-center justify-center shadow"
                                  title={`Pin ${comp.pins[1] || '2'}`}
                                >
                                  {comp.pins[1] || '2'}
                                </div>
                              </>
                            )}
                          </>
                        )}
                      </div>
                    );
                  })}
              </div>
            )}
          </div>
        ) : (
          <div
            onClick={() => onUploadSchematic && fileInputRef.current?.click()}
            className={`flex flex-col items-center justify-center text-center p-8 border-2 border-dashed border-slate-300 hover:border-[#0055A5] rounded-2xl bg-white hover:bg-slate-50 transition-all ${
              onUploadSchematic ? "cursor-pointer group" : ""
            }`}
          >
            <div className="w-14 h-14 rounded-2xl bg-slate-100 group-hover:bg-blue-50 border border-slate-200 group-hover:border-[#0055A5] flex items-center justify-center mb-3 transition">
              <UploadCloud className="w-7 h-7 text-slate-500 group-hover:text-[#0055A5] transition" />
            </div>
            <p className="text-sm font-bold text-slate-800 group-hover:text-[#0055A5] transition">
              {onUploadSchematic ? "Click to Upload Schematic Diagram" : "No schematic uploaded yet"}
            </p>
            <p className="text-xs text-slate-500 mt-1 max-w-sm">
              Supports PNG, JPG, or PDF schematic files. Automatically segments symbol regions and terminal pins.
            </p>
            {onUploadSchematic && (
              <button
                type="button"
                className="mt-4 px-4 py-1.5 rounded-lg bg-[#0055A5] hover:bg-[#004385] text-white font-bold text-xs shadow-xs group-hover:scale-105 transition"
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
        <span className="text-slate-400 font-mono">Normalized Coordinate Engine</span>
      </div>
    </div>
  );
};
