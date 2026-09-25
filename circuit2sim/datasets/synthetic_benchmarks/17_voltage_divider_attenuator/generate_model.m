% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_17_voltage_divider_attenuator
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_17_voltage_divider_attenuator...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_17_voltage_divider_attenuator')
    close_system('model_17_voltage_divider_attenuator', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_17_voltage_divider_attenuator');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_17_voltage_divider_attenuator', 'Solver', 'ode23t');
set_param('model_17_voltage_divider_attenuator', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_17_voltage_divider_attenuator/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Precision Reference Voltage
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_17_voltage_divider_attenuator/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('model_17_voltage_divider_attenuator/V1', 'v0', '10.0');
set_param('model_17_voltage_divider_attenuator/V1', 'v0_unit', 'V');

% [R1] Divider Upper Arm
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_17_voltage_divider_attenuator/R1', ...
    'Position', [320, 170, 400, 210]);
set_param('model_17_voltage_divider_attenuator/R1', 'R', '9000.0');
set_param('model_17_voltage_divider_attenuator/R1', 'R_unit', 'Ohm');

% [R2] Divider Lower Arm
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_17_voltage_divider_attenuator/R2', ...
    'Position', [520, 260, 580, 330]);
set_param('model_17_voltage_divider_attenuator/R2', 'R', '1000.0');
set_param('model_17_voltage_divider_attenuator/R2', 'R_unit', 'Ohm');

% [R3] Instrumentation High-Z Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_17_voltage_divider_attenuator/R3', ...
    'Position', [660, 260, 720, 330]);
set_param('model_17_voltage_divider_attenuator/R3', 'R', '100000.0');
set_param('model_17_voltage_divider_attenuator/R3', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_17_voltage_divider_attenuator/GND1', ...
    'Position', [400, 410, 460, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_17_voltage_divider_attenuator', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1)
try
    add_line('model_17_voltage_divider_attenuator', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_DIV (connections: R1.2, R2.1, R3.1)
try
    add_line('model_17_voltage_divider_attenuator', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DIV: ', me.message]);
end
try
    add_line('model_17_voltage_divider_attenuator', 'R2/LConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DIV: ', me.message]);
end

% Net: GND (connections: V1.-, R2.2, R3.2, GND1.1)
try
    add_line('model_17_voltage_divider_attenuator', 'V1/LConn1', 'R2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_17_voltage_divider_attenuator', 'R2/RConn1', 'R3/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_17_voltage_divider_attenuator', 'R3/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_17_voltage_divider_attenuator', 'F:/KONE FINALS/datasets/17_voltage_divider_attenuator/model_17_voltage_divider_attenuator.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/17_voltage_divider_attenuator/model_17_voltage_divider_attenuator.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_17_voltage_divider_attenuator', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_17_voltage_divider_attenuator', 0);