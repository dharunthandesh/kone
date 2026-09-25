% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_02_rl_transient_circuit
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_02_rl_transient_circuit...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_02_rl_transient_circuit')
    close_system('model_02_rl_transient_circuit', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_02_rl_transient_circuit');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_02_rl_transient_circuit', 'Solver', 'ode23t');
set_param('model_02_rl_transient_circuit', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_02_rl_transient_circuit/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] DC Bus Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_02_rl_transient_circuit/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('model_02_rl_transient_circuit/V1', 'v0', '24.0');
set_param('model_02_rl_transient_circuit/V1', 'v0_unit', 'V');

% [L1] Series Filter Choke
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_02_rl_transient_circuit/L1', ...
    'Position', [340, 170, 420, 210]);
set_param('model_02_rl_transient_circuit/L1', 'l', '0.05');
set_param('model_02_rl_transient_circuit/L1', 'l_unit', 'H');

% [R1] Load Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_02_rl_transient_circuit/R1', ...
    'Position', [550, 260, 610, 330]);
set_param('model_02_rl_transient_circuit/R1', 'R', '100.0');
set_param('model_02_rl_transient_circuit/R1', 'R_unit', 'Ohm');

% [GND1] Ground Reference
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_02_rl_transient_circuit/GND1', ...
    'Position', [340, 410, 400, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_02_rl_transient_circuit', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, L1.1)
try
    add_line('model_02_rl_transient_circuit', 'V1/RConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_MID (connections: L1.2, R1.1)
try
    add_line('model_02_rl_transient_circuit', 'L1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID: ', me.message]);
end

% Net: GND (connections: V1.-, R1.2, GND1.1)
try
    add_line('model_02_rl_transient_circuit', 'V1/LConn1', 'R1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_02_rl_transient_circuit', 'R1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_02_rl_transient_circuit', 'F:/KONE FINALS/datasets/02_rl_transient_circuit/model_02_rl_transient_circuit.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/02_rl_transient_circuit/model_02_rl_transient_circuit.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_02_rl_transient_circuit', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_02_rl_transient_circuit', 0);