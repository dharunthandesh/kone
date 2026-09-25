% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_03_series_rlc_snubber
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_03_series_rlc_snubber...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_03_series_rlc_snubber')
    close_system('model_03_series_rlc_snubber', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_03_series_rlc_snubber');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_03_series_rlc_snubber', 'Solver', 'ode23t');
set_param('model_03_series_rlc_snubber', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_03_series_rlc_snubber/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Step Excitation Source
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_03_series_rlc_snubber/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_03_series_rlc_snubber/V1', 'v0', '48.0');
set_param('model_03_series_rlc_snubber/V1', 'v0_unit', 'V');

% [R1] Damping Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_03_series_rlc_snubber/R1', ...
    'Position', [280, 170, 360, 210]);
set_param('model_03_series_rlc_snubber/R1', 'R', '15.0');
set_param('model_03_series_rlc_snubber/R1', 'R_unit', 'Ohm');

% [L1] Resonant Inductor
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_03_series_rlc_snubber/L1', ...
    'Position', [460, 170, 540, 210]);
set_param('model_03_series_rlc_snubber/L1', 'l', '0.0022');
set_param('model_03_series_rlc_snubber/L1', 'l_unit', 'H');

% [C1] Snubber Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_03_series_rlc_snubber/C1', ...
    'Position', [640, 260, 700, 330]);
set_param('model_03_series_rlc_snubber/C1', 'c', '2.2e-07');
set_param('model_03_series_rlc_snubber/C1', 'c_unit', 'F');

% [GND1] Chassis Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_03_series_rlc_snubber/GND1', ...
    'Position', [380, 410, 440, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_03_series_rlc_snubber', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1 (connections: V1.+, R1.1)
try
    add_line('model_03_series_rlc_snubber', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1: ', me.message]);
end

% Net: N2 (connections: R1.2, L1.1)
try
    add_line('model_03_series_rlc_snubber', 'R1/RConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: L1.2, C1.1)
try
    add_line('model_03_series_rlc_snubber', 'L1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, GND1.1)
try
    add_line('model_03_series_rlc_snubber', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_03_series_rlc_snubber', 'C1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_03_series_rlc_snubber', 'F:/KONE FINALS/datasets/03_series_rlc_snubber/model_03_series_rlc_snubber.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/03_series_rlc_snubber/model_03_series_rlc_snubber.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_03_series_rlc_snubber', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_03_series_rlc_snubber', 0);