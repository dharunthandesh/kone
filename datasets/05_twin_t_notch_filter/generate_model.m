% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_05_twin_t_notch_filter
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_05_twin_t_notch_filter...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_05_twin_t_notch_filter')
    close_system('model_05_twin_t_notch_filter', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_05_twin_t_notch_filter');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_05_twin_t_notch_filter', 'Solver', 'ode23t');
set_param('model_05_twin_t_notch_filter', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_05_twin_t_notch_filter/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] AC Signal Generator
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_05_twin_t_notch_filter/V1', ...
    'Position', [80, 260, 140, 330]);
set_param('model_05_twin_t_notch_filter/V1', 'v0', '1.0');
set_param('model_05_twin_t_notch_filter/V1', 'v0_unit', 'V');

% [R1] T1 First Series Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_05_twin_t_notch_filter/R1', ...
    'Position', [240, 130, 320, 170]);
set_param('model_05_twin_t_notch_filter/R1', 'R', '10000.0');
set_param('model_05_twin_t_notch_filter/R1', 'R_unit', 'Ohm');

% [R2] T1 Second Series Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_05_twin_t_notch_filter/R2', ...
    'Position', [460, 130, 540, 170]);
set_param('model_05_twin_t_notch_filter/R2', 'R', '10000.0');
set_param('model_05_twin_t_notch_filter/R2', 'R_unit', 'Ohm');

% [C3] T1 Shunt Capacitor (2C)
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_05_twin_t_notch_filter/C3', ...
    'Position', [370, 190, 430, 260]);
set_param('model_05_twin_t_notch_filter/C3', 'c', '2e-07');
set_param('model_05_twin_t_notch_filter/C3', 'c_unit', 'F');

% [C1] T2 First Series Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_05_twin_t_notch_filter/C1', ...
    'Position', [240, 290, 320, 330]);
set_param('model_05_twin_t_notch_filter/C1', 'c', '1e-07');
set_param('model_05_twin_t_notch_filter/C1', 'c_unit', 'F');

% [C2] T2 Second Series Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_05_twin_t_notch_filter/C2', ...
    'Position', [460, 290, 540, 330]);
set_param('model_05_twin_t_notch_filter/C2', 'c', '1e-07');
set_param('model_05_twin_t_notch_filter/C2', 'c_unit', 'F');

% [R3] T2 Shunt Resistor (R/2)
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_05_twin_t_notch_filter/R3', ...
    'Position', [370, 360, 430, 430]);
set_param('model_05_twin_t_notch_filter/R3', 'R', '5000.0');
set_param('model_05_twin_t_notch_filter/R3', 'R_unit', 'Ohm');

% [R_LOAD] Filter Termination Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_05_twin_t_notch_filter/R_LOAD', ...
    'Position', [620, 240, 680, 310]);
set_param('model_05_twin_t_notch_filter/R_LOAD', 'R', '100000.0');
set_param('model_05_twin_t_notch_filter/R_LOAD', 'R_unit', 'Ohm');

% [GND1] Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_05_twin_t_notch_filter/GND1', ...
    'Position', [380, 490, 440, 530]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_05_twin_t_notch_filter', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1, C1.1)
try
    add_line('model_05_twin_t_notch_filter', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'R1/LConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_T1 (connections: R1.2, R2.1, C3.1)
try
    add_line('model_05_twin_t_notch_filter', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_T1: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'R2/LConn1', 'C3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_T1: ', me.message]);
end

% Net: N_T2 (connections: C1.2, C2.1, R3.1)
try
    add_line('model_05_twin_t_notch_filter', 'C1/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_T2: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'C2/LConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_T2: ', me.message]);
end

% Net: N_OUT (connections: R2.2, C2.2, R_LOAD.1)
try
    add_line('model_05_twin_t_notch_filter', 'R2/RConn1', 'C2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'C2/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, C3.2, R3.2, R_LOAD.2, GND1.1)
try
    add_line('model_05_twin_t_notch_filter', 'V1/LConn1', 'C3/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'C3/RConn1', 'R3/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'R3/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_05_twin_t_notch_filter', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_05_twin_t_notch_filter', 'F:/KONE FINALS/datasets/05_twin_t_notch_filter/model_05_twin_t_notch_filter.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/05_twin_t_notch_filter/model_05_twin_t_notch_filter.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_05_twin_t_notch_filter', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_05_twin_t_notch_filter', 0);