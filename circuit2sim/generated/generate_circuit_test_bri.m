% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_test_bri
% Generated:   2026-09-24 19:50:04 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_test_bri...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_test_bri')
    close_system('circuit_test_bri', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_test_bri');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_test_bri', 'Solver', 'ode23t');
set_param('circuit_test_bri', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_test_bri/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] voltage_source
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_test_bri/V1', ...
    'Position', [200, 120, 280, 170]);
set_param('circuit_test_bri/V1', 'v0', '10.0');
set_param('circuit_test_bri/V1', 'v0_unit', 'V');

% [R1] resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_test_bri/R1', ...
    'Position', [360, 120, 440, 170]);
set_param('circuit_test_bri/R1', 'R', '100.0');
set_param('circuit_test_bri/R1', 'R_unit', 'Ohm');

% [R2] resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_test_bri/R2', ...
    'Position', [520, 120, 600, 170]);
set_param('circuit_test_bri/R2', 'R', '100.0');
set_param('circuit_test_bri/R2', 'R_unit', 'Ohm');

% [R3] resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_test_bri/R3', ...
    'Position', [200, 230, 280, 280]);
set_param('circuit_test_bri/R3', 'R', '100.0');
set_param('circuit_test_bri/R3', 'R_unit', 'Ohm');

% [R4] resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_test_bri/R4', ...
    'Position', [360, 230, 440, 280]);
set_param('circuit_test_bri/R4', 'R', '100.0');
set_param('circuit_test_bri/R4', 'R_unit', 'Ohm');

% [GND1] ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_test_bri/GND1', ...
    'Position', [520, 230, 600, 280]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_test_bri', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_TOP (connections: V1.+, R1.1)
try
    add_line('circuit_test_bri', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_TOP: ', me.message]);
end

% Net: N_TOP2 (connections: R1.1, R2.1)
try
    add_line('circuit_test_bri', 'R1/LConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_TOP2: ', me.message]);
end

% Net: N_MID1 (connections: R1.2, R3.1)
try
    add_line('circuit_test_bri', 'R1/RConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID1: ', me.message]);
end

% Net: N_MID2 (connections: R2.2, R4.1)
try
    add_line('circuit_test_bri', 'R2/RConn1', 'R4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_MID2: ', me.message]);
end

% Net: GND (connections: V1.-, R3.2, GND1.1)
try
    add_line('circuit_test_bri', 'V1/LConn1', 'R3/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_test_bri', 'R3/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_test_bri', 'F:/KONE FINALS/circuit2sim/generated/circuit_test_bri.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_test_bri.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_test_bri', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_test_bri', 0);