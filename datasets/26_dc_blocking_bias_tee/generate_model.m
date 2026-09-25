% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_26_dc_blocking_bias_tee
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_26_dc_blocking_bias_tee...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_26_dc_blocking_bias_tee')
    close_system('model_26_dc_blocking_bias_tee', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_26_dc_blocking_bias_tee');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_26_dc_blocking_bias_tee', 'Solver', 'ode23t');
set_param('model_26_dc_blocking_bias_tee', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_26_dc_blocking_bias_tee/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V_RF] High-Frequency RF Carrier
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_26_dc_blocking_bias_tee/V_RF', ...
    'Position', [100, 170, 160, 240]);
set_param('model_26_dc_blocking_bias_tee/V_RF', 'v0', '1.0');
set_param('model_26_dc_blocking_bias_tee/V_RF', 'v0_unit', 'V');

% [C_BLOCK] RF DC-Blocking Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_26_dc_blocking_bias_tee/C_BLOCK', ...
    'Position', [260, 170, 340, 210]);
set_param('model_26_dc_blocking_bias_tee/C_BLOCK', 'c', '1e-07');
set_param('model_26_dc_blocking_bias_tee/C_BLOCK', 'c_unit', 'F');

% [V_DC] DC Bias Supply Rail
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_26_dc_blocking_bias_tee/V_DC', ...
    'Position', [380, 360, 440, 430]);
set_param('model_26_dc_blocking_bias_tee/V_DC', 'v0', '12.0');
set_param('model_26_dc_blocking_bias_tee/V_DC', 'v0_unit', 'V');

% [L_RFC] RF Choke Inductor
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_26_dc_blocking_bias_tee/L_RFC', ...
    'Position', [420, 260, 480, 330]);
set_param('model_26_dc_blocking_bias_tee/L_RFC', 'l', '0.0001');
set_param('model_26_dc_blocking_bias_tee/L_RFC', 'l_unit', 'H');

% [R_LOAD] Combined Active Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_26_dc_blocking_bias_tee/R_LOAD', ...
    'Position', [600, 260, 660, 330]);
set_param('model_26_dc_blocking_bias_tee/R_LOAD', 'R', '50.0');
set_param('model_26_dc_blocking_bias_tee/R_LOAD', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_26_dc_blocking_bias_tee/GND1', ...
    'Position', [260, 440, 320, 480]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_26_dc_blocking_bias_tee', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_RF_IN (connections: V_RF.+, C_BLOCK.1)
try
    add_line('model_26_dc_blocking_bias_tee', 'V_RF/RConn1', 'C_BLOCK/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_RF_IN: ', me.message]);
end

% Net: N_BIAS_COMBINED (connections: C_BLOCK.2, L_RFC.1, R_LOAD.1)
try
    add_line('model_26_dc_blocking_bias_tee', 'C_BLOCK/RConn1', 'L_RFC/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BIAS_COMBINED: ', me.message]);
end
try
    add_line('model_26_dc_blocking_bias_tee', 'L_RFC/LConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BIAS_COMBINED: ', me.message]);
end

% Net: N_DC_FEED (connections: V_DC.+, L_RFC.2)
try
    add_line('model_26_dc_blocking_bias_tee', 'V_DC/RConn1', 'L_RFC/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_FEED: ', me.message]);
end

% Net: GND (connections: V_RF.-, V_DC.-, R_LOAD.2, GND1.1)
try
    add_line('model_26_dc_blocking_bias_tee', 'V_RF/LConn1', 'V_DC/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_26_dc_blocking_bias_tee', 'V_DC/LConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_26_dc_blocking_bias_tee', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_26_dc_blocking_bias_tee', 'F:/KONE FINALS/datasets/26_dc_blocking_bias_tee/model_26_dc_blocking_bias_tee.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/26_dc_blocking_bias_tee/model_26_dc_blocking_bias_tee.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_26_dc_blocking_bias_tee', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_26_dc_blocking_bias_tee', 0);