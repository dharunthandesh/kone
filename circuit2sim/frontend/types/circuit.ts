export type ComponentType =
  | "resistor"
  | "capacitor"
  | "inductor"
  | "voltage_source"
  | "current_source"
  | "diode"
  | "switch"
  | "ground"
  | "mosfet"
  | "igbt"
  | "transformer"
  | "sensor"
  | "three_phase_source"
  | "load"
  | "op_amp"
  | "integrated_circuit";

export interface ParameterValue {
  value?: number;
  unit?: string;
  raw_text?: string;
  confidence: number;
  uncertain: boolean;
  notes?: string;
}

export interface BoundingBox {
  x: number;
  y: number;
  w: number;
  h: number;
}

export interface Component {
  id: string;
  type: ComponentType;
  name?: string;
  parameters: Record<string, ParameterValue>;
  pins: string[];
  confidence: number;
  orientation: number;
  bounding_box?: BoundingBox;
  uncertainties: string[];
  verified_by_user: boolean;
}

export interface Net {
  id: string;
  connections: string[];
  confidence: number;
  is_ground: boolean;
  notes?: string;
}

export interface ValidationReport {
  status: "PASS" | "WARNING" | "FAIL";
  components_total: number;
  components_verified: number;
  parameters_total: number;
  parameters_verified: number;
  parameters_uncertain: number;
  connections_total: number;
  connections_verified: number;
  has_ground_reference: boolean;
  floating_pins: string[];
  warnings: string[];
  errors: string[];
  ready_for_compilation: boolean;
}

export interface UniversalCircuitIR {
  version: string;
  title?: string;
  components: Component[];
  nets: Net[];
  metadata: Record<string, any>;
  validation?: ValidationReport;
}

export interface Project {
  id: string;
  name: string;
  description?: string;
  created_at: string;
  updated_at: string;
  status: string;
  schematic_filename?: string;
  schematic_url?: string;
  target_simulator: string;
  components_count: number;
  nets_count: number;
  validation?: ValidationReport;
}

export interface AnalysisJob {
  job_id: string;
  project_id: string;
  status: string;
  stage: string;
  progress: number;
  logs: string[];
  error?: string;
}

export interface CompilationReport {
  model_name: string;
  script_file?: string;
  script_path?: string;
  slx_file?: string;
  slx_path?: string;
  status: string;
  matlab_detected: boolean;
  matlab_binary?: string;
  compilation_output?: string;
  simulation_smoke_test: string;
  errors: string[];
  warnings: string[];
}
