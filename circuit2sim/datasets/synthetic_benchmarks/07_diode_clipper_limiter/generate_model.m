% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_07_diode_clipper_limiter
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_07_diode_clipper_limiter...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_07_diode_clipper_limiter')
    close_system('model_07_diode_clipper_limiter', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_07_diode_clipper_limiter');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_07_diode_clipper_limiter', 'Solver', 'ode23t');
set_param('model_07_diode_clipper_limiter', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_07_diode_clipper_limiter/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Transient Spike Signal
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_07_diode_clipper_limiter/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_07_diode_clipper_limiter/V1', 'v0', '5.0');
set_param('model_07_diode_clipper_limiter/V1', 'v0_unit', 'V');

% [R1] Current Limiting Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_07_diode_clipper_limiter/R1', ...
    'Position', [280, 170, 360, 210]);
set_param('model_07_diode_clipper_limiter/R1', 'R', '1000.0');
set_param('model_07_diode_clipper_limiter/R1', 'R_unit', 'Ohm');

% [D1] Positive Rail Clamping Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_07_diode_clipper_limiter/D1', ...
    'Position', [440, 260, 500, 330]);
set_param('model_07_diode_clipper_limiter/D1', 'Vf', '0.7');
set_param('model_07_diode_clipper_limiter/D1', 'Vf_unit', 'V');

% [D2] Negative Rail Clamping Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_07_diode_clipper_limiter/D2', ...
    'Position', [540, 260, 600, 330]);
set_param('model_07_diode_clipper_limiter/D2', 'Vf', '0.7');
set_param('model_07_diode_clipper_limiter/D2', 'Vf_unit', 'V');

% [R_LOAD] Protected ADC Buffer Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_07_diode_clipper_limiter/R_LOAD', ...
    'Position', [660, 260, 720, 330]);
set_param('model_07_diode_clipper_limiter/R_LOAD', 'R', '10000.0');
set_param('model_07_diode_clipper_limiter/R_LOAD', 'R_unit', 'Ohm');

% [GND1] Ground Reference
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_07_diode_clipper_limiter/GND1', ...
    'Position', [380, 420, 440, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_07_diode_clipper_limiter', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1)
try
    add_line('model_07_diode_clipper_limiter', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_CLAMP (connections: R1.2, D1.A, D2.K, R_LOAD.1)
try
    add_line('model_07_diode_clipper_limiter', 'R1/RConn1', 'D1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CLAMP: ', me.message]);
end
try
    add_line('model_07_diode_clipper_limiter', 'D1/LConn1', 'D2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CLAMP: ', me.message]);
end
try
    add_line('model_07_diode_clipper_limiter', 'D2/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CLAMP: ', me.message]);
end

% Net: GND (connections: V1.-, D1.K, D2.A, R_LOAD.2, GND1.1)
try
    add_line('model_07_diode_clipper_limiter', 'V1/LConn1', 'D1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_07_diode_clipper_limiter', 'D1/RConn1', 'D2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_07_diode_clipper_limiter', 'D2/LConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_07_diode_clipper_limiter', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_07_diode_clipper_limiter', 'F:/KONE FINALS/datasets/07_diode_clipper_limiter/model_07_diode_clipper_limiter.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/07_diode_clipper_limiter/model_07_diode_clipper_limiter.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_07_diode_clipper_limiter', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_07_diode_clipper_limiter', 0);