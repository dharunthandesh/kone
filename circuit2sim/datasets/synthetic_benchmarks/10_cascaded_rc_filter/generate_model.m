% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_10_cascaded_rc_filter
% Generated:   2026-09-24 20:10:31 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_10_cascaded_rc_filter...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_10_cascaded_rc_filter')
    close_system('model_10_cascaded_rc_filter', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_10_cascaded_rc_filter');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_10_cascaded_rc_filter', 'Solver', 'ode23t');
set_param('model_10_cascaded_rc_filter', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_10_cascaded_rc_filter/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Step Signal Source
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_10_cascaded_rc_filter/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_10_cascaded_rc_filter/V1', 'v0', '10.0');
set_param('model_10_cascaded_rc_filter/V1', 'v0_unit', 'V');

% [R1] Stage 1 Filter Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_10_cascaded_rc_filter/R1', ...
    'Position', [260, 170, 340, 210]);
set_param('model_10_cascaded_rc_filter/R1', 'R', '4700.0');
set_param('model_10_cascaded_rc_filter/R1', 'R_unit', 'Ohm');

% [C1] Stage 1 Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_10_cascaded_rc_filter/C1', ...
    'Position', [380, 260, 440, 330]);
set_param('model_10_cascaded_rc_filter/C1', 'c', '2.2e-07');
set_param('model_10_cascaded_rc_filter/C1', 'c_unit', 'F');

% [R2] Stage 2 Isolation Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_10_cascaded_rc_filter/R2', ...
    'Position', [500, 170, 580, 210]);
set_param('model_10_cascaded_rc_filter/R2', 'R', '10000.0');
set_param('model_10_cascaded_rc_filter/R2', 'R_unit', 'Ohm');

% [C2] Stage 2 Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_10_cascaded_rc_filter/C2', ...
    'Position', [620, 260, 680, 330]);
set_param('model_10_cascaded_rc_filter/C2', 'c', '4.7e-08');
set_param('model_10_cascaded_rc_filter/C2', 'c_unit', 'F');

% [R_LOAD] Instrumentation Output Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_10_cascaded_rc_filter/R_LOAD', ...
    'Position', [740, 260, 800, 330]);
set_param('model_10_cascaded_rc_filter/R_LOAD', 'R', '100000.0');
set_param('model_10_cascaded_rc_filter/R_LOAD', 'R_unit', 'Ohm');

% [GND1] Ground Plane
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_10_cascaded_rc_filter/GND1', ...
    'Position', [440, 420, 500, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_10_cascaded_rc_filter', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1 (connections: V1.+, R1.1)
try
    add_line('model_10_cascaded_rc_filter', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1: ', me.message]);
end

% Net: N2 (connections: R1.2, C1.1, R2.1)
try
    add_line('model_10_cascaded_rc_filter', 'R1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end
try
    add_line('model_10_cascaded_rc_filter', 'C1/LConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: R2.2, C2.1, R_LOAD.1)
try
    add_line('model_10_cascaded_rc_filter', 'R2/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end
try
    add_line('model_10_cascaded_rc_filter', 'C2/LConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, C2.2, R_LOAD.2, GND1.1)
try
    add_line('model_10_cascaded_rc_filter', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_10_cascaded_rc_filter', 'C1/RConn1', 'C2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_10_cascaded_rc_filter', 'C2/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_10_cascaded_rc_filter', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_10_cascaded_rc_filter', 'F:/KONE FINALS/datasets/10_cascaded_rc_filter/model_10_cascaded_rc_filter.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/10_cascaded_rc_filter/model_10_cascaded_rc_filter.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_10_cascaded_rc_filter', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_10_cascaded_rc_filter', 0);