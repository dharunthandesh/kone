"use client";

import React, { useState } from "react";
import {
  AlertTriangle,
  CheckCircle,
  Edit2,
  Trash2,
  Plus,
  Save,
  X,
  Sliders,
  HelpCircle,
} from "lucide-react";
import { Component, ComponentType, ParameterValue } from "../types/circuit";

interface ComponentReviewTableProps {
  components: Component[];
  selectedComponentId?: string;
  onSelectComponent: (id: string) => void;
  onUpdateComponent: (
    id: string,
    data: {
      type?: ComponentType;
      name?: string;
      parameters?: Record<string, ParameterValue>;
      pins?: string[];
      orientation?: number;
    }
  ) => Promise<void>;
  onDeleteComponent: (id: string) => Promise<void>;
  onAddComponent: (data: {
    id: string;
    type: ComponentType;
    name?: string;
    parameters?: Record<string, ParameterValue>;
    pins?: string[];
    orientation?: number;
  }) => Promise<void>;
}

export const ComponentReviewTable: React.FC<ComponentReviewTableProps> = ({
  components,
  selectedComponentId,
  onSelectComponent,
  onUpdateComponent,
  onDeleteComponent,
  onAddComponent,
}) => {
  const [filter, setFilter] = useState<"all" | "uncertain" | "verified">("all");
  const [editingId, setEditingId] = useState<string | null>(null);

  // Edit buffer
  const [editType, setEditType] = useState<ComponentType>("resistor");
  const [editVal, setEditVal] = useState<string>("");
  const [editUnit, setEditUnit] = useState<string>("");
  const [editOrientation, setEditOrientation] = useState<number>(0);

  // New component modal
  const [showAddModal, setShowAddModal] = useState(false);
  const [newId, setNewId] = useState("");
  const [newType, setNewType] = useState<ComponentType>("resistor");
  const [newVal, setNewVal] = useState("10k");
  const [newUnit, setNewUnit] = useState("ohm");

  const startEdit = (c: Component) => {
    setEditingId(c.id);
    setEditType(c.type);
    const p = Object.values(c.parameters)[0];
    setEditVal(p?.raw_text || (p?.value ? String(p.value) : ""));
    setEditUnit(p?.unit || "");
    setEditOrientation(c.orientation || 0);
  };

  const cancelEdit = () => {
    setEditingId(null);
  };

  const saveEdit = async (c: Component) => {
    let paramKey = "resistance";
    if (editType === "capacitor") paramKey = "capacitance";
    else if (editType === "inductor") paramKey = "inductance";
    else if (editType === "voltage_source") paramKey = "voltage";
    else if (editType === "current_source") paramKey = "current";
    else if (editType === "diode") paramKey = "forward_voltage";

    const parsedNum = parseFloat(editVal.replace(/[^\d.-]/g, "")) || 0;

    const newParams: Record<string, ParameterValue> = {
      [paramKey]: {
        value: parsedNum,
        unit: editUnit,
        raw_text: editVal,
        confidence: 1.0,
        uncertain: false,
      },
    };

    await onUpdateComponent(c.id, {
      type: editType,
      parameters: newParams,
      orientation: editOrientation,
    });
    setEditingId(null);
  };

  const handleAddNew = async () => {
    if (!newId) return;
    let paramKey = "resistance";
    if (newType === "capacitor") paramKey = "capacitance";
    else if (newType === "inductor") paramKey = "inductance";
    else if (newType === "voltage_source") paramKey = "voltage";
    else if (newType === "current_source") paramKey = "current";

    const parsedNum = parseFloat(newVal.replace(/[^\d.-]/g, "")) || 0;

    await onAddComponent({
      id: newId.toUpperCase(),
      type: newType,
      name: `${newType.toUpperCase()} ${newId.toUpperCase()}`,
      parameters: {
        [paramKey]: {
          value: parsedNum,
          unit: newUnit,
          raw_text: newVal,
          confidence: 1.0,
          uncertain: false,
        },
      },
      pins: newType === "ground" ? ["1"] : newType === "voltage_source" ? ["+", "-"] : ["1", "2"],
      orientation: 0,
    });

    setShowAddModal(false);
    setNewId("");
    setNewVal("");
  };

  const filtered = components.filter((c) => {
    if (filter === "uncertain") return c.confidence < 0.85 || c.uncertainties.length > 0;
    if (filter === "verified") return c.verified_by_user || c.confidence >= 0.90;
    return true;
  });

  return (
    <div className="flex flex-col h-full bg-slate-900 border border-slate-800 rounded-xl overflow-hidden shadow-xl">
      {/* Header & Filter Controls */}
      <div className="flex items-center justify-between px-4 py-3 bg-slate-950/90 border-b border-slate-800">
        <div className="flex items-center space-x-2">
          <Sliders className="w-4 h-4 text-cyan-400" />
          <h3 className="text-xs font-semibold text-slate-200 uppercase tracking-wider">
            Detected Components & Verification
          </h3>
          <span className="text-[10px] font-mono bg-slate-800 text-slate-300 px-2 py-0.5 rounded">
            {components.length} total
          </span>
        </div>

        <div className="flex items-center space-x-2">
          {/* Filters */}
          <div className="flex items-center space-x-1 bg-slate-900 border border-slate-800 rounded p-0.5 text-[11px]">
            <button
              onClick={() => setFilter("all")}
              className={`px-2 py-0.5 rounded transition ${
                filter === "all" ? "bg-cyan-600/30 text-cyan-300 font-semibold" : "text-slate-400 hover:text-slate-200"
              }`}
            >
              All ({components.length})
            </button>
            <button
              onClick={() => setFilter("uncertain")}
              className={`px-2 py-0.5 rounded transition ${
                filter === "uncertain"
                  ? "bg-amber-600/30 text-amber-300 font-semibold"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              Needs Review (
              {components.filter((c) => c.confidence < 0.85 || c.uncertainties.length > 0).length}
              )
            </button>
            <button
              onClick={() => setFilter("verified")}
              className={`px-2 py-0.5 rounded transition ${
                filter === "verified"
                  ? "bg-emerald-600/30 text-emerald-300 font-semibold"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              Verified
            </button>
          </div>

          {/* Add Component Button */}
          <button
            onClick={() => setShowAddModal(true)}
            className="inline-flex items-center space-x-1 px-2.5 py-1 rounded bg-slate-800 hover:bg-slate-700 text-cyan-400 text-xs font-medium border border-slate-700 transition"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add</span>
          </button>
        </div>
      </div>

      {/* Component Table */}
      <div className="flex-1 overflow-auto">
        <table className="w-full text-left border-collapse text-xs">
          <thead>
            <tr className="bg-slate-950/60 border-b border-slate-800 text-slate-400 font-mono text-[11px]">
              <th className="py-2.5 px-3">Ref ID</th>
              <th className="py-2.5 px-3">Type</th>
              <th className="py-2.5 px-3">Nominal Value</th>
              <th className="py-2.5 px-3">Pins</th>
              <th className="py-2.5 px-3">Confidence & Status</th>
              <th className="py-2.5 px-3 text-right">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-800/60 font-sans">
            {filtered.length === 0 ? (
              <tr>
                <td colSpan={6} className="py-8 text-center text-slate-500 text-xs">
                  No components match the selected filter.
                </td>
              </tr>
            ) : (
              filtered.map((comp) => {
                const isSelected = selectedComponentId === comp.id;
                const isEditing = editingId === comp.id;
                const isUncertain = comp.confidence < 0.85 || comp.uncertainties.length > 0;
                const param = Object.values(comp.parameters)[0];

                return (
                  <tr
                    key={comp.id}
                    onClick={() => onSelectComponent(comp.id)}
                    className={`transition-colors cursor-pointer ${
                      isSelected
                        ? "bg-cyan-950/40 border-l-2 border-l-cyan-400"
                        : "hover:bg-slate-850/50 hover:bg-slate-800/30"
                    }`}
                  >
                    {/* Ref ID */}
                    <td className="py-2.5 px-3 font-mono font-bold text-cyan-300">
                      {comp.id}
                    </td>

                    {/* Type */}
                    <td className="py-2.5 px-3">
                      {isEditing ? (
                        <select
                          value={editType}
                          onChange={(e) => setEditType(e.target.value as ComponentType)}
                          className="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-slate-200 text-xs focus:ring-1 focus:ring-cyan-500"
                        >
                          <option value="resistor">Resistor</option>
                          <option value="capacitor">Capacitor</option>
                          <option value="inductor">Inductor</option>
                          <option value="voltage_source">DC Voltage Source</option>
                          <option value="current_source">DC Current Source</option>
                          <option value="diode">Diode</option>
                          <option value="switch">Switch</option>
                          <option value="ground">Electrical Reference / Ground</option>
                        </select>
                      ) : (
                        <span className="capitalize text-slate-200">
                          {comp.type.replace("_", " ")}
                        </span>
                      )}
                    </td>

                    {/* Nominal Value */}
                    <td className="py-2.5 px-3 font-mono">
                      {isEditing ? (
                        <div className="flex items-center space-x-1">
                          <input
                            type="text"
                            value={editVal}
                            onChange={(e) => setEditVal(e.target.value)}
                            placeholder="e.g. 10k"
                            className="w-20 bg-slate-900 border border-slate-700 rounded px-1.5 py-0.5 text-slate-200 text-xs focus:ring-1 focus:ring-cyan-500"
                          />
                          <input
                            type="text"
                            value={editUnit}
                            onChange={(e) => setEditUnit(e.target.value)}
                            placeholder="unit"
                            className="w-14 bg-slate-900 border border-slate-700 rounded px-1.5 py-0.5 text-slate-200 text-xs focus:ring-1 focus:ring-cyan-500"
                          />
                        </div>
                      ) : param ? (
                        <span className="text-slate-100 font-semibold">
                          {param.raw_text || (param.value !== undefined ? `${param.value} ${param.unit || ""}` : "—")}
                        </span>
                      ) : (
                        <span className="text-slate-500">—</span>
                      )}
                    </td>

                    {/* Pins */}
                    <td className="py-2.5 px-3 font-mono text-slate-400 text-[11px]">
                      {comp.pins.join(", ")}
                    </td>

                    {/* Confidence & Status */}
                    <td className="py-2.5 px-3">
                      {comp.verified_by_user ? (
                        <span className="inline-flex items-center space-x-1 px-2 py-0.5 rounded text-[10px] font-medium bg-blue-950 text-blue-300 border border-blue-800">
                          <CheckCircle className="w-3 h-3 text-blue-400" />
                          <span>Manually Verified</span>
                        </span>
                      ) : isUncertain ? (
                        <span
                          className="inline-flex items-center space-x-1 px-2 py-0.5 rounded text-[10px] font-bold bg-amber-950 text-amber-300 border border-amber-800 animate-pulse"
                          title={comp.uncertainties.join("; ")}
                        >
                          <AlertTriangle className="w-3 h-3 text-amber-400" />
                          <span>UNCERTAIN ({Math.round(comp.confidence * 100)}%)</span>
                        </span>
                      ) : (
                        <span className="inline-flex items-center space-x-1 px-2 py-0.5 rounded text-[10px] font-medium bg-emerald-950 text-emerald-300 border border-emerald-800">
                          <CheckCircle className="w-3 h-3 text-emerald-400" />
                          <span>{Math.round(comp.confidence * 100)}% Recognized</span>
                        </span>
                      )}
                    </td>

                    {/* Actions */}
                    <td className="py-2.5 px-3 text-right">
                      {isEditing ? (
                        <div className="flex items-center justify-end space-x-1">
                          <button
                            onClick={() => saveEdit(comp)}
                            className="p-1 text-emerald-400 hover:text-emerald-300"
                            title="Save Changes"
                          >
                            <Save className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={cancelEdit}
                            className="p-1 text-slate-400 hover:text-slate-200"
                            title="Cancel"
                          >
                            <X className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ) : (
                        <div className="flex items-center justify-end space-x-1">
                          <button
                            onClick={() => startEdit(comp)}
                            className="p-1 text-slate-400 hover:text-cyan-400 transition"
                            title="Edit Component"
                          >
                            <Edit2 className="w-3.5 h-3.5" />
                          </button>
                          <button
                            onClick={() => onDeleteComponent(comp.id)}
                            className="p-1 text-slate-400 hover:text-rose-400 transition"
                            title="Delete Component"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {/* Add Component Modal */}
      {showAddModal && (
        <div className="p-4 bg-slate-950 border-t border-slate-800 flex items-center justify-between space-x-3 text-xs">
          <span className="font-semibold text-slate-200">Add Component:</span>
          <input
            type="text"
            value={newId}
            onChange={(e) => setNewId(e.target.value)}
            placeholder="Ref ID (e.g. R2)"
            className="w-24 bg-slate-900 border border-slate-700 rounded px-2 py-1 text-slate-200 font-mono"
          />
          <select
            value={newType}
            onChange={(e) => setNewType(e.target.value as ComponentType)}
            className="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-slate-200"
          >
            <option value="resistor">Resistor</option>
            <option value="capacitor">Capacitor</option>
            <option value="inductor">Inductor</option>
            <option value="voltage_source">DC Voltage Source</option>
            <option value="current_source">DC Current Source</option>
            <option value="diode">Diode</option>
            <option value="switch">Switch</option>
            <option value="ground">Electrical Reference / Ground</option>
          </select>
          <input
            type="text"
            value={newVal}
            onChange={(e) => setNewVal(e.target.value)}
            placeholder="Value (e.g. 10k)"
            className="w-24 bg-slate-900 border border-slate-700 rounded px-2 py-1 text-slate-200 font-mono"
          />
          <input
            type="text"
            value={newUnit}
            onChange={(e) => setNewUnit(e.target.value)}
            placeholder="Unit (ohm)"
            className="w-16 bg-slate-900 border border-slate-700 rounded px-2 py-1 text-slate-200 font-mono"
          />
          <button
            onClick={handleAddNew}
            className="px-3 py-1 bg-cyan-600 hover:bg-cyan-500 text-white rounded font-medium transition"
          >
            Confirm Add
          </button>
          <button
            onClick={() => setShowAddModal(false)}
            className="px-2 py-1 text-slate-400 hover:text-slate-200 transition"
          >
            Cancel
          </button>
        </div>
      )}
    </div>
  );
};
