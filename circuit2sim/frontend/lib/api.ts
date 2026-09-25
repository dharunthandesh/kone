import {
  Component,
  ComponentType,
  Net,
  ParameterValue,
  Project,
  UniversalCircuitIR,
  ValidationReport,
} from "../types/circuit";

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000";

export const api = {
  async getHealth() {
    const res = await fetch(`${API_BASE}/health`);
    if (!res.ok) throw new Error("Backend connection failed");
    return res.json();
  },

  async getProjects(): Promise<Project[]> {
    const res = await fetch(`${API_BASE}/api/projects`);
    if (!res.ok) throw new Error("Failed to fetch projects");
    return res.json();
  },

  async getProject(id: string): Promise<Project> {
    const res = await fetch(`${API_BASE}/api/projects/${id}`);
    if (!res.ok) throw new Error("Failed to fetch project");
    return res.json();
  },

  async createProject(name: string, description?: string, targetSimulator = "matlab_simscape"): Promise<Project> {
    const res = await fetch(`${API_BASE}/api/projects`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, description, target_simulator: targetSimulator }),
    });
    if (!res.ok) throw new Error("Failed to create project");
    return res.json();
  },

  async uploadSchematic(projectId: string, file: File) {
    const formData = new FormData();
    formData.append("file", file);
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/schematic`, {
      method: "POST",
      body: formData,
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Upload failed" }));
      throw new Error(err.detail || "Failed to upload schematic");
    }
    return res.json();
  },

  async startAnalysis(projectId: string) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/analyze`, {
      method: "POST",
    });
    if (!res.ok) throw new Error("Failed to trigger analysis");
    return res.json();
  },

  async getAnalysis(projectId: string, jobId?: string): Promise<{
    project_id: string;
    status: string;
    job?: any;
    circuit_ir?: UniversalCircuitIR;
    validation?: ValidationReport;
  }> {
    const url = jobId
      ? `${API_BASE}/api/projects/${projectId}/analysis?job_id=${encodeURIComponent(jobId)}`
      : `${API_BASE}/api/projects/${projectId}/analysis`;
    const res = await fetch(url);
    if (!res.ok) throw new Error("Failed to fetch analysis");
    return res.json();
  },

  async updateComponent(
    projectId: string,
    componentId: string,
    data: {
      type?: ComponentType;
      name?: string;
      parameters?: Record<string, ParameterValue>;
      pins?: string[];
      orientation?: number;
    }
  ) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/components/${componentId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error("Failed to update component");
    return res.json();
  },

  async addComponent(
    projectId: string,
    data: {
      id: string;
      type: ComponentType;
      name?: string;
      parameters?: Record<string, ParameterValue>;
      pins?: string[];
      orientation?: number;
    }
  ) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/components`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error("Failed to add component");
    return res.json();
  },

  async deleteComponent(projectId: string, componentId: string) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/components/${componentId}`, {
      method: "DELETE",
    });
    if (!res.ok) throw new Error("Failed to delete component");
    return res.json();
  },

  async updateConnections(projectId: string, nets: Net[]) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/connections`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nets }),
    });
    if (!res.ok) throw new Error("Failed to update connections");
    return res.json();
  },

  async getValidation(projectId: string): Promise<ValidationReport> {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/validation`);
    if (!res.ok) throw new Error("Failed to fetch validation");
    return res.json();
  },

  async generateModel(projectId: string, target = "matlab_simscape") {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ target }),
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Model generation failed" }));
      throw new Error(err.detail || "Model generation failed");
    }
    return res.json();
  },

  async getProjectModel(projectId: string) {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/model`, {
      cache: "no-store",
    });
    if (!res.ok) return null;
    return res.json();
  },

  getDownloadUrl(
    projectId: string,
    type: "zip" | "slx" | "m" | "cir" | "json" | "all" = "zip",
    timestamp?: number
  ) {
    const ts = timestamp || Date.now();
    return `${API_BASE}/api/projects/${projectId}/download?type=${type}&_t=${ts}`;
  },

  getStaticFileUrl(url?: string) {
    if (!url) return "";
    if (url.startsWith("http")) return url;
    return `${API_BASE}${url}`;
  },

  async getSamples() {
    const res = await fetch(`${API_BASE}/api/samples`);
    if (!res.ok) throw new Error("Failed to fetch benchmark samples");
    return res.json();
  },

  async loadSample(sampleId: string) {
    const res = await fetch(`${API_BASE}/api/samples/${sampleId}/load`, {
      method: "POST",
    });
    if (!res.ok) throw new Error("Failed to load sample");
    return res.json();
  },

  // MATLAB Integration & Settings
  async getMatlabSettings(): Promise<any> {
    const res = await fetch(`${API_BASE}/api/settings/matlab`, { cache: "no-store" });
    if (!res.ok) throw new Error("Failed to fetch MATLAB settings");
    return res.json();
  },

  async updateMatlabSettings(data: { api_key?: string; execution_mode?: string; account_token?: string }) {
    const res = await fetch(`${API_BASE}/api/settings/matlab`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    if (!res.ok) throw new Error("Failed to update MATLAB settings");
    return res.json();
  },

  // Autonomous Fault Injection & FMEA
  async runFaultInjection(projectId: string): Promise<any> {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/faults/run`, {
      method: "POST",
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Fault injection failed" }));
      throw new Error(err.detail || "Fault injection failed");
    }
    return res.json();
  },

  async getFaultResults(projectId: string): Promise<any> {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/faults`, {
      cache: "no-store",
    });
    if (!res.ok) throw new Error("Failed to fetch fault results");
    return res.json();
  },

  async injectSingleFault(
    projectId: string,
    componentId: string,
    faultType: string,
    customValue?: number
  ): Promise<any> {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/faults/inject`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        component_id: componentId,
        fault_type: faultType,
        custom_value: customValue,
      }),
    });
    if (!res.ok) throw new Error("Failed to inject custom fault");
    return res.json();
  },

  async exportFMEAReport(projectId: string, format: "csv" | "json" = "csv") {
    const res = await fetch(`${API_BASE}/api/projects/${projectId}/faults/export?format=${format}`);
    if (!res.ok) throw new Error("Failed to export FMEA report");
    return res.json();
  },

  getFaultMatlabScriptUrl(projectId: string) {
    return `${API_BASE}/api/projects/${projectId}/faults/matlab-script?_t=${Date.now()}`;
  },
};
