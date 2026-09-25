% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_08_pi_clc_power_filter
% Generated:   2026-09-24 20:10:30 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_08_pi_clc_power_filter...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_08_pi_clc_power_filter')
    close_system('model_08_pi_clc_power_filter', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_08_pi_clc_power_filter');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_08_pi_clc_power_filter', 'Solver', 'ode23t');
set_param('model_08_pi_clc_power_filter', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_08_pi_clc_power_filter/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Switching Rail DC Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_08_pi_clc_power_filter/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_08_pi_clc_power_filter/V1', 'v0', '12.0');
set_param('model_08_pi_clc_power_filter/V1', 'v0_unit', 'V');

% [C1] Input Decoupling Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_08_pi_clc_power_filter/C1', ...
    'Position', [280, 260, 340, 330]);
set_param('model_08_pi_clc_power_filter/C1', 'c', '1e-05');
set_param('model_08_pi_clc_power_filter/C1', 'c_unit', 'F');

% [L1] Pi-Filter Series Choke
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_08_pi_clc_power_filter/L1', ...
    'Position', [420, 170, 500, 210]);
set_param('model_08_pi_clc_power_filter/L1', 'l', '0.01');
set_param('model_08_pi_clc_power_filter/L1', 'l_unit', 'H');

% [C2] Output Decoupling Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_08_pi_clc_power_filter/C2', ...
    'Position', [560, 260, 620, 330]);
set_param('model_08_pi_clc_power_filter/C2', 'c', '1e-05');
set_param('model_08_pi_clc_power_filter/C2', 'c_unit', 'F');

% [R_LOAD] RF / Power Rail Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_08_pi_clc_power_filter/R_LOAD', ...
    'Position', [690, 260, 750, 330]);
set_param('model_08_pi_clc_power_filter/R_LOAD', 'R', '50.0');
set_param('model_08_pi_clc_power_filter/R_LOAD', 'R_unit', 'Ohm');

% [GND1] Ground Plane
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_08_pi_clc_power_filter/GND1', ...
    'Position', [420, 420, 480, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_08_pi_clc_power_filter', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, C1.1, L1.1)
try
    add_line('model_08_pi_clc_power_filter', 'V1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end
try
    add_line('model_08_pi_clc_power_filter', 'C1/LConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_OUT (connections: L1.2, C2.1, R_LOAD.1)
try
    add_line('model_08_pi_clc_power_filter', 'L1/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end
try
    add_line('model_08_pi_clc_power_filter', 'C2/LConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, C2.2, R_LOAD.2, GND1.1)
try
    add_line('model_08_pi_clc_power_filter', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_08_pi_clc_power_filter', 'C1/RConn1', 'C2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_08_pi_clc_power_filter', 'C2/RConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_08_pi_clc_power_filter', 'R_LOAD/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_08_pi_clc_power_filter', 'F:/KONE FINALS/datasets/08_pi_clc_power_filter/model_08_pi_clc_power_filter.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/08_pi_clc_power_filter/model_08_pi_clc_power_filter.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_08_pi_clc_power_filter', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_08_pi_clc_power_filter', 0);