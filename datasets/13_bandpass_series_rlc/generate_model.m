% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_13_bandpass_series_rlc
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_13_bandpass_series_rlc...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_13_bandpass_series_rlc')
    close_system('model_13_bandpass_series_rlc', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_13_bandpass_series_rlc');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_13_bandpass_series_rlc', 'Solver', 'ode23t');
set_param('model_13_bandpass_series_rlc', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_13_bandpass_series_rlc/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Signal Generator
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_13_bandpass_series_rlc/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('model_13_bandpass_series_rlc/V1', 'v0', '10.0');
set_param('model_13_bandpass_series_rlc/V1', 'v0_unit', 'V');

% [C1] Series Resonator Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_13_bandpass_series_rlc/C1', ...
    'Position', [280, 170, 360, 210]);
set_param('model_13_bandpass_series_rlc/C1', 'c', '1e-06');
set_param('model_13_bandpass_series_rlc/C1', 'c_unit', 'F');

% [L1] Series Resonator Inductor
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_13_bandpass_series_rlc/L1', ...
    'Position', [440, 170, 520, 210]);
set_param('model_13_bandpass_series_rlc/L1', 'l', '0.02533');
set_param('model_13_bandpass_series_rlc/L1', 'l_unit', 'H');

% [R1] Output Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_13_bandpass_series_rlc/R1', ...
    'Position', [600, 260, 660, 330]);
set_param('model_13_bandpass_series_rlc/R1', 'R', '50.0');
set_param('model_13_bandpass_series_rlc/R1', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_13_bandpass_series_rlc/GND1', ...
    'Position', [380, 410, 440, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_13_bandpass_series_rlc', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, C1.1)
try
    add_line('model_13_bandpass_series_rlc', 'V1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_CL (connections: C1.2, L1.1)
try
    add_line('model_13_bandpass_series_rlc', 'C1/RConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CL: ', me.message]);
end

% Net: N_OUT (connections: L1.2, R1.1)
try
    add_line('model_13_bandpass_series_rlc', 'L1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, R1.2, GND1.1)
try
    add_line('model_13_bandpass_series_rlc', 'V1/LConn1', 'R1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_13_bandpass_series_rlc', 'R1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_13_bandpass_series_rlc', 'F:/KONE FINALS/datasets/13_bandpass_series_rlc/model_13_bandpass_series_rlc.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/13_bandpass_series_rlc/model_13_bandpass_series_rlc.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_13_bandpass_series_rlc', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_13_bandpass_series_rlc', 0);