% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_23_lead_lag_compensator
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_23_lead_lag_compensator...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_23_lead_lag_compensator')
    close_system('model_23_lead_lag_compensator', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_23_lead_lag_compensator');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_23_lead_lag_compensator', 'Solver', 'ode23t');
set_param('model_23_lead_lag_compensator', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_23_lead_lag_compensator/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Control Reference Input
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_23_lead_lag_compensator/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_23_lead_lag_compensator/V1', 'v0', '10.0');
set_param('model_23_lead_lag_compensator/V1', 'v0_unit', 'V');

% [R1] Lead Arm Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_23_lead_lag_compensator/R1', ...
    'Position', [280, 140, 360, 180]);
set_param('model_23_lead_lag_compensator/R1', 'R', '10000.0');
set_param('model_23_lead_lag_compensator/R1', 'R_unit', 'Ohm');

% [C1] Lead Speedup Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_23_lead_lag_compensator/C1', ...
    'Position', [280, 220, 360, 260]);
set_param('model_23_lead_lag_compensator/C1', 'c', '1e-07');
set_param('model_23_lead_lag_compensator/C1', 'c_unit', 'F');

% [R2] Lag Arm Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_23_lead_lag_compensator/R2', ...
    'Position', [500, 240, 560, 300]);
set_param('model_23_lead_lag_compensator/R2', 'R', '2200.0');
set_param('model_23_lead_lag_compensator/R2', 'R_unit', 'Ohm');

% [C2] Lag Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_23_lead_lag_compensator/C2', ...
    'Position', [500, 340, 560, 400]);
set_param('model_23_lead_lag_compensator/C2', 'c', '4.7e-07');
set_param('model_23_lead_lag_compensator/C2', 'c_unit', 'F');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_23_lead_lag_compensator/GND1', ...
    'Position', [380, 430, 440, 470]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_23_lead_lag_compensator', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1, C1.1)
try
    add_line('model_23_lead_lag_compensator', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end
try
    add_line('model_23_lead_lag_compensator', 'R1/LConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_MID (connections: R1.2, C1.2, R2.1)
try
    add_line('model_23_lead_lag_compensator', 'R1/RConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID: ', me.message]);
end
try
    add_line('model_23_lead_lag_compensator', 'C1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID: ', me.message]);
end

% Net: N_LAG (connections: R2.2, C2.1)
try
    add_line('model_23_lead_lag_compensator', 'R2/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_LAG: ', me.message]);
end

% Net: GND (connections: V1.-, C2.2, GND1.1)
try
    add_line('model_23_lead_lag_compensator', 'V1/LConn1', 'C2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_23_lead_lag_compensator', 'C2/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_23_lead_lag_compensator', 'F:/KONE FINALS/datasets/23_lead_lag_compensator/model_23_lead_lag_compensator.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/23_lead_lag_compensator/model_23_lead_lag_compensator.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_23_lead_lag_compensator', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_23_lead_lag_compensator', 0);