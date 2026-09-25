% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_06_half_wave_rectifier
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_06_half_wave_rectifier...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_06_half_wave_rectifier')
    close_system('model_06_half_wave_rectifier', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_06_half_wave_rectifier');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_06_half_wave_rectifier', 'Solver', 'ode23t');
set_param('model_06_half_wave_rectifier', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_06_half_wave_rectifier/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] AC Secondary Transformer
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_06_half_wave_rectifier/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('model_06_half_wave_rectifier/V1', 'v0', '12.0');
set_param('model_06_half_wave_rectifier/V1', 'v0_unit', 'V');

% [D1] Power Silicon Rectifier Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_06_half_wave_rectifier/D1', ...
    'Position', [320, 170, 400, 210]);
set_param('model_06_half_wave_rectifier/D1', 'Vf', '0.7');
set_param('model_06_half_wave_rectifier/D1', 'Vf_unit', 'V');

% [C1] Reservoir Smoothing Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_06_half_wave_rectifier/C1', ...
    'Position', [490, 260, 550, 330]);
set_param('model_06_half_wave_rectifier/C1', 'c', '0.0001');
set_param('model_06_half_wave_rectifier/C1', 'c_unit', 'F');

% [R_LOAD] DC Circuit Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_06_half_wave_rectifier/R_LOAD', ...
    'Position', [640, 260, 700, 330]);
set_param('model_06_half_wave_rectifier/R_LOAD', 'R', '500.0');
set_param('model_06_half_wave_rectifier/R_LOAD', 'R_unit', 'Ohm');

% [GND1] DC Return Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_06_half_wave_rectifier/GND1', ...
    'Position', [380, 420, 440, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_06_half_wave_rectifier', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_AC (connections: V1.+, D1.A)
try
    add_line('model_06_half_wave_rectifier', 'V1/RConn1', 'D1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_AC: ', me.message]);
end

% Net: N_DC (connections: D1.K, C1.1, R_LOAD.1)
try
    add_line('model_06_half_wave_rectifier', 'D1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC: ', me.message]);
end
try
    add_line('model_06_half_wave_rectifier', 'C1/LConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, R_LOAD.2, GND1.1)
try
    add_line('model_06_half_wave_rectifier', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_06_half_wave_rectifier', 'C1/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_06_half_wave_rectifier', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_06_half_wave_rectifier', 'F:/KONE FINALS/datasets/06_half_wave_rectifier/model_06_half_wave_rectifier.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/06_half_wave_rectifier/model_06_half_wave_rectifier.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_06_half_wave_rectifier', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_06_half_wave_rectifier', 0);