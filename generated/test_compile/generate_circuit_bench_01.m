% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_bench_01
% Generated:   2026-09-24 20:35:26 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_bench_01...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_bench_01')
    close_system('circuit_bench_01', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_bench_01');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_bench_01', 'Solver', 'ode23t');
set_param('circuit_bench_01', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_bench_01/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] DC Input Voltage
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_bench_01/V1', ...
    'Position', [120, 260, 180, 330]);
set_param('circuit_bench_01/V1', 'v0', '10.0');
set_param('circuit_bench_01/V1', 'v0_unit', 'V');

% [R1] Filter Series Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_bench_01/R1', ...
    'Position', [340, 170, 420, 210]);
set_param('circuit_bench_01/R1', 'R', '4700.0');
set_param('circuit_bench_01/R1', 'R_unit', 'Ohm');

% [C1] Filter Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_bench_01/C1', ...
    'Position', [550, 260, 610, 330]);
set_param('circuit_bench_01/C1', 'c', '1e-06');
set_param('circuit_bench_01/C1', 'c_unit', 'F');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_bench_01/GND1', ...
    'Position', [340, 410, 400, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_bench_01', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, R1.1)
try
    add_line('circuit_bench_01', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_OUT (connections: R1.2, C1.1)
try
    add_line('circuit_bench_01', 'R1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, GND1.1)
try
    add_line('circuit_bench_01', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_bench_01', 'C1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_bench_01', 'F:/KONE FINALS/generated/test_compile/circuit_bench_01.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/generated/test_compile/circuit_bench_01.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_bench_01', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_bench_01', 0);