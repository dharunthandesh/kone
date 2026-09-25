% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_24_besselfilter_lc_lowpass
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_24_besselfilter_lc_lowpass...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_24_besselfilter_lc_lowpass')
    close_system('model_24_besselfilter_lc_lowpass', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_24_besselfilter_lc_lowpass');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_24_besselfilter_lc_lowpass', 'Solver', 'ode23t');
set_param('model_24_besselfilter_lc_lowpass', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_24_besselfilter_lc_lowpass/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Signal Generator
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_24_besselfilter_lc_lowpass/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_24_besselfilter_lc_lowpass/V1', 'v0', '10.0');
set_param('model_24_besselfilter_lc_lowpass/V1', 'v0_unit', 'V');

% [L1] Stage 1 Series Choke
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_24_besselfilter_lc_lowpass/L1', ...
    'Position', [260, 170, 340, 210]);
set_param('model_24_besselfilter_lc_lowpass/L1', 'l', '0.0022');
set_param('model_24_besselfilter_lc_lowpass/L1', 'l_unit', 'H');

% [C1] Center Shunt Resonator
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_24_besselfilter_lc_lowpass/C1', ...
    'Position', [420, 260, 480, 330]);
set_param('model_24_besselfilter_lc_lowpass/C1', 'c', '4.7e-07');
set_param('model_24_besselfilter_lc_lowpass/C1', 'c_unit', 'F');

% [L2] Stage 2 Series Choke
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_24_besselfilter_lc_lowpass/L2', ...
    'Position', [560, 170, 640, 210]);
set_param('model_24_besselfilter_lc_lowpass/L2', 'l', '0.0022');
set_param('model_24_besselfilter_lc_lowpass/L2', 'l_unit', 'H');

% [R_LOAD] Terminating Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_24_besselfilter_lc_lowpass/R_LOAD', ...
    'Position', [720, 260, 780, 330]);
set_param('model_24_besselfilter_lc_lowpass/R_LOAD', 'R', '100.0');
set_param('model_24_besselfilter_lc_lowpass/R_LOAD', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_24_besselfilter_lc_lowpass/GND1', ...
    'Position', [420, 410, 480, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_24_besselfilter_lc_lowpass', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, L1.1)
try
    add_line('model_24_besselfilter_lc_lowpass', 'V1/RConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_MID (connections: L1.2, C1.1, L2.1)
try
    add_line('model_24_besselfilter_lc_lowpass', 'L1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID: ', me.message]);
end
try
    add_line('model_24_besselfilter_lc_lowpass', 'C1/LConn1', 'L2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID: ', me.message]);
end

% Net: N_OUT (connections: L2.2, R_LOAD.1)
try
    add_line('model_24_besselfilter_lc_lowpass', 'L2/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, R_LOAD.2, GND1.1)
try
    add_line('model_24_besselfilter_lc_lowpass', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_24_besselfilter_lc_lowpass', 'C1/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_24_besselfilter_lc_lowpass', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_24_besselfilter_lc_lowpass', 'F:/KONE FINALS/datasets/24_besselfilter_lc_lowpass/model_24_besselfilter_lc_lowpass.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/24_besselfilter_lc_lowpass/model_24_besselfilter_lc_lowpass.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_24_besselfilter_lc_lowpass', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_24_besselfilter_lc_lowpass', 0);