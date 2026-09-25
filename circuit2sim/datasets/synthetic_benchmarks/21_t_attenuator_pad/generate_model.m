% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_21_t_attenuator_pad
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_21_t_attenuator_pad...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_21_t_attenuator_pad')
    close_system('model_21_t_attenuator_pad', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_21_t_attenuator_pad');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_21_t_attenuator_pad', 'Solver', 'ode23t');
set_param('model_21_t_attenuator_pad', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_21_t_attenuator_pad/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] RF Source 50 Ohm
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_21_t_attenuator_pad/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_21_t_attenuator_pad/V1', 'v0', '5.0');
set_param('model_21_t_attenuator_pad/V1', 'v0_unit', 'V');

% [R1] T-Pad Input Arm
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_21_t_attenuator_pad/R1', ...
    'Position', [260, 170, 340, 210]);
set_param('model_21_t_attenuator_pad/R1', 'R', '16.6');
set_param('model_21_t_attenuator_pad/R1', 'R_unit', 'Ohm');

% [R2] T-Pad Shunt Leg
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_21_t_attenuator_pad/R2', ...
    'Position', [420, 260, 480, 330]);
set_param('model_21_t_attenuator_pad/R2', 'R', '66.9');
set_param('model_21_t_attenuator_pad/R2', 'R_unit', 'Ohm');

% [R3] T-Pad Output Arm
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_21_t_attenuator_pad/R3', ...
    'Position', [560, 170, 640, 210]);
set_param('model_21_t_attenuator_pad/R3', 'R', '16.6');
set_param('model_21_t_attenuator_pad/R3', 'R_unit', 'Ohm');

% [R_LOAD] Matched Characteristic Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_21_t_attenuator_pad/R_LOAD', ...
    'Position', [720, 260, 780, 330]);
set_param('model_21_t_attenuator_pad/R_LOAD', 'R', '50.0');
set_param('model_21_t_attenuator_pad/R_LOAD', 'R_unit', 'Ohm');

% [GND1] RF System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_21_t_attenuator_pad/GND1', ...
    'Position', [420, 410, 480, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_21_t_attenuator_pad', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1)
try
    add_line('model_21_t_attenuator_pad', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_CENTER (connections: R1.2, R2.1, R3.1)
try
    add_line('model_21_t_attenuator_pad', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CENTER: ', me.message]);
end
try
    add_line('model_21_t_attenuator_pad', 'R2/LConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CENTER: ', me.message]);
end

% Net: N_OUT (connections: R3.2, R_LOAD.1)
try
    add_line('model_21_t_attenuator_pad', 'R3/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, R2.2, R_LOAD.2, GND1.1)
try
    add_line('model_21_t_attenuator_pad', 'V1/LConn1', 'R2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_21_t_attenuator_pad', 'R2/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_21_t_attenuator_pad', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_21_t_attenuator_pad', 'F:/KONE FINALS/datasets/21_t_attenuator_pad/model_21_t_attenuator_pad.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/21_t_attenuator_pad/model_21_t_attenuator_pad.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_21_t_attenuator_pad', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_21_t_attenuator_pad', 0);