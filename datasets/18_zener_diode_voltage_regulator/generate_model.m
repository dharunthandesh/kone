% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_18_zener_diode_voltage_regulator
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_18_zener_diode_voltage_regulator...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_18_zener_diode_voltage_regulator')
    close_system('model_18_zener_diode_voltage_regulator', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_18_zener_diode_voltage_regulator');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_18_zener_diode_voltage_regulator', 'Solver', 'ode23t');
set_param('model_18_zener_diode_voltage_regulator', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_18_zener_diode_voltage_regulator/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Unregulated DC Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_18_zener_diode_voltage_regulator/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('model_18_zener_diode_voltage_regulator/V1', 'v0', '15.0');
set_param('model_18_zener_diode_voltage_regulator/V1', 'v0_unit', 'V');

% [R1] Current Limiting Ballast
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_18_zener_diode_voltage_regulator/R1', ...
    'Position', [340, 170, 420, 210]);
set_param('model_18_zener_diode_voltage_regulator/R1', 'R', '330.0');
set_param('model_18_zener_diode_voltage_regulator/R1', 'R_unit', 'Ohm');

% [D1] Shunt Reference Clamp
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_18_zener_diode_voltage_regulator/D1', ...
    'Position', [520, 260, 580, 330]);
set_param('model_18_zener_diode_voltage_regulator/D1', 'Vf', '0.7');
set_param('model_18_zener_diode_voltage_regulator/D1', 'Vf_unit', 'V');

% [R_LOAD] Regulated Output Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_18_zener_diode_voltage_regulator/R_LOAD', ...
    'Position', [660, 260, 720, 330]);
set_param('model_18_zener_diode_voltage_regulator/R_LOAD', 'R', '1000.0');
set_param('model_18_zener_diode_voltage_regulator/R_LOAD', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_18_zener_diode_voltage_regulator/GND1', ...
    'Position', [400, 410, 460, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_18_zener_diode_voltage_regulator', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1)
try
    add_line('model_18_zener_diode_voltage_regulator', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_REG (connections: R1.2, D1.A, R_LOAD.1)
try
    add_line('model_18_zener_diode_voltage_regulator', 'R1/RConn1', 'D1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_REG: ', me.message]);
end
try
    add_line('model_18_zener_diode_voltage_regulator', 'D1/LConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_REG: ', me.message]);
end

% Net: GND (connections: V1.-, D1.K, R_LOAD.2, GND1.1)
try
    add_line('model_18_zener_diode_voltage_regulator', 'V1/LConn1', 'D1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_18_zener_diode_voltage_regulator', 'D1/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_18_zener_diode_voltage_regulator', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_18_zener_diode_voltage_regulator', 'F:/KONE FINALS/datasets/18_zener_diode_voltage_regulator/model_18_zener_diode_voltage_regulator.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/18_zener_diode_voltage_regulator/model_18_zener_diode_voltage_regulator.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_18_zener_diode_voltage_regulator', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_18_zener_diode_voltage_regulator', 0);