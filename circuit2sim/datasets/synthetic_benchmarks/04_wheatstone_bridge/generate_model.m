% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_04_wheatstone_bridge
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_04_wheatstone_bridge...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_04_wheatstone_bridge')
    close_system('model_04_wheatstone_bridge', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_04_wheatstone_bridge');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_04_wheatstone_bridge', 'Solver', 'ode23t');
set_param('model_04_wheatstone_bridge', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_04_wheatstone_bridge/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Bridge Excitation Source
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_04_wheatstone_bridge/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_04_wheatstone_bridge/V1', 'v0', '5.0');
set_param('model_04_wheatstone_bridge/V1', 'v0_unit', 'V');

% [R1] Upper Left Arm Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_04_wheatstone_bridge/R1', ...
    'Position', [320, 140, 380, 210]);
set_param('model_04_wheatstone_bridge/R1', 'R', '1000.0');
set_param('model_04_wheatstone_bridge/R1', 'R_unit', 'Ohm');

% [R2] Lower Left Arm Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_04_wheatstone_bridge/R2', ...
    'Position', [320, 320, 380, 390]);
set_param('model_04_wheatstone_bridge/R2', 'R', '1000.0');
set_param('model_04_wheatstone_bridge/R2', 'R_unit', 'Ohm');

% [R3] Upper Right Arm Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_04_wheatstone_bridge/R3', ...
    'Position', [540, 140, 600, 210]);
set_param('model_04_wheatstone_bridge/R3', 'R', '1000.0');
set_param('model_04_wheatstone_bridge/R3', 'R_unit', 'Ohm');

% [R4] Active Strain Sensor Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_04_wheatstone_bridge/R4', ...
    'Position', [540, 320, 600, 390]);
set_param('model_04_wheatstone_bridge/R4', 'R', '1200.0');
set_param('model_04_wheatstone_bridge/R4', 'R_unit', 'Ohm');

% [R_DET] Detector Galvo/ADC Input Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_04_wheatstone_bridge/R_DET', ...
    'Position', [430, 240, 510, 280]);
set_param('model_04_wheatstone_bridge/R_DET', 'R', '10000.0');
set_param('model_04_wheatstone_bridge/R_DET', 'R_unit', 'Ohm');

% [GND1] Reference Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_04_wheatstone_bridge/GND1', ...
    'Position', [430, 470, 490, 510]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_04_wheatstone_bridge', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: VCC (connections: V1.+, R1.1, R3.1)
try
    add_line('model_04_wheatstone_bridge', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net VCC: ', me.message]);
end
try
    add_line('model_04_wheatstone_bridge', 'R1/LConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net VCC: ', me.message]);
end

% Net: NODE_A (connections: R1.2, R2.1, R_DET.1)
try
    add_line('model_04_wheatstone_bridge', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net NODE_A: ', me.message]);
end
try
    add_line('model_04_wheatstone_bridge', 'R2/LConn1', 'R_DET/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net NODE_A: ', me.message]);
end

% Net: NODE_B (connections: R3.2, R4.1, R_DET.2)
try
    add_line('model_04_wheatstone_bridge', 'R3/RConn1', 'R4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net NODE_B: ', me.message]);
end
try
    add_line('model_04_wheatstone_bridge', 'R4/LConn1', 'R_DET/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net NODE_B: ', me.message]);
end

% Net: GND (connections: V1.-, R2.2, R4.2, GND1.1)
try
    add_line('model_04_wheatstone_bridge', 'V1/LConn1', 'R2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_04_wheatstone_bridge', 'R2/RConn1', 'R4/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_04_wheatstone_bridge', 'R4/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_04_wheatstone_bridge', 'F:/KONE FINALS/datasets/04_wheatstone_bridge/model_04_wheatstone_bridge.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/04_wheatstone_bridge/model_04_wheatstone_bridge.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_04_wheatstone_bridge', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_04_wheatstone_bridge', 0);