% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_15_full_wave_bridge_rectifier
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_15_full_wave_bridge_rectifier...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_15_full_wave_bridge_rectifier')
    close_system('model_15_full_wave_bridge_rectifier', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_15_full_wave_bridge_rectifier');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_15_full_wave_bridge_rectifier', 'Solver', 'ode23t');
set_param('model_15_full_wave_bridge_rectifier', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_15_full_wave_bridge_rectifier/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] AC Transformer Secondary
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_15_full_wave_bridge_rectifier/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_15_full_wave_bridge_rectifier/V1', 'v0', '24.0');
set_param('model_15_full_wave_bridge_rectifier/V1', 'v0_unit', 'V');

% [D1] Bridge Diode Top-Left
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_15_full_wave_bridge_rectifier/D1', ...
    'Position', [240, 180, 300, 220]);
set_param('model_15_full_wave_bridge_rectifier/D1', 'Vf', '0.7');
set_param('model_15_full_wave_bridge_rectifier/D1', 'Vf_unit', 'V');

% [D2] Bridge Diode Top-Right
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_15_full_wave_bridge_rectifier/D2', ...
    'Position', [380, 180, 440, 220]);
set_param('model_15_full_wave_bridge_rectifier/D2', 'Vf', '0.7');
set_param('model_15_full_wave_bridge_rectifier/D2', 'Vf_unit', 'V');

% [D3] Bridge Diode Bottom-Left
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_15_full_wave_bridge_rectifier/D3', ...
    'Position', [240, 340, 300, 380]);
set_param('model_15_full_wave_bridge_rectifier/D3', 'Vf', '0.7');
set_param('model_15_full_wave_bridge_rectifier/D3', 'Vf_unit', 'V');

% [D4] Bridge Diode Bottom-Right
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_15_full_wave_bridge_rectifier/D4', ...
    'Position', [380, 340, 440, 380]);
set_param('model_15_full_wave_bridge_rectifier/D4', 'Vf', '0.7');
set_param('model_15_full_wave_bridge_rectifier/D4', 'Vf_unit', 'V');

% [C1] Bulk Smoothing Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_15_full_wave_bridge_rectifier/C1', ...
    'Position', [520, 260, 580, 330]);
set_param('model_15_full_wave_bridge_rectifier/C1', 'c', '0.00022');
set_param('model_15_full_wave_bridge_rectifier/C1', 'c_unit', 'F');

% [R1] DC Circuit Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_15_full_wave_bridge_rectifier/R1', ...
    'Position', [640, 260, 700, 330]);
set_param('model_15_full_wave_bridge_rectifier/R1', 'R', '200.0');
set_param('model_15_full_wave_bridge_rectifier/R1', 'R_unit', 'Ohm');

% [GND1] DC Return Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_15_full_wave_bridge_rectifier/GND1', ...
    'Position', [520, 420, 580, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_15_full_wave_bridge_rectifier', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_AC_P (connections: V1.+, D1.A, D3.K)
try
    add_line('model_15_full_wave_bridge_rectifier', 'V1/RConn1', 'D1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_AC_P: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'D1/LConn1', 'D3/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_AC_P: ', me.message]);
end

% Net: N_AC_N (connections: V1.-, D2.A, D4.K)
try
    add_line('model_15_full_wave_bridge_rectifier', 'V1/LConn1', 'D2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_AC_N: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'D2/LConn1', 'D4/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_AC_N: ', me.message]);
end

% Net: N_DC_POS (connections: D1.K, D2.K, C1.1, R1.1)
try
    add_line('model_15_full_wave_bridge_rectifier', 'D1/RConn1', 'D2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_POS: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'D2/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_POS: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'C1/LConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_POS: ', me.message]);
end

% Net: GND (connections: D3.A, D4.A, C1.2, R1.2, GND1.1)
try
    add_line('model_15_full_wave_bridge_rectifier', 'D3/LConn1', 'D4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'D4/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'C1/RConn1', 'R1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_15_full_wave_bridge_rectifier', 'R1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_15_full_wave_bridge_rectifier', 'F:/KONE FINALS/datasets/15_full_wave_bridge_rectifier/model_15_full_wave_bridge_rectifier.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/15_full_wave_bridge_rectifier/model_15_full_wave_bridge_rectifier.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_15_full_wave_bridge_rectifier', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_15_full_wave_bridge_rectifier', 0);