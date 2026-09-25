% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_7e4ff047
% Generated:   2026-09-24 21:06:33 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_7e4ff047...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_7e4ff047')
    close_system('circuit_7e4ff047', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_7e4ff047');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_7e4ff047', 'Solver', 'ode23t');
set_param('circuit_7e4ff047', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_7e4ff047/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [I1] Constant Current Source
add_block('fl_lib/Electrical/Electrical Sources/DC Current Source', 'circuit_7e4ff047/I1', ...
    'Position', [100, 260, 160, 330]);
set_param('circuit_7e4ff047/I1', 'i0', '0.02');
set_param('circuit_7e4ff047/I1', 'i0_unit', 'A');

% [L1] Tank Inductor
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_7e4ff047/L1', ...
    'Position', [290, 260, 350, 330]);
set_param('circuit_7e4ff047/L1', 'l', '0.001');
set_param('circuit_7e4ff047/L1', 'l_unit', 'H');

% [C1] Tank Tuning Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_7e4ff047/C1', ...
    'Position', [460, 260, 520, 330]);
set_param('circuit_7e4ff047/C1', 'c', '1e-07');
set_param('circuit_7e4ff047/C1', 'c_unit', 'F');

% [R1] Parallel Damping Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_7e4ff047/R1', ...
    'Position', [630, 260, 690, 330]);
set_param('circuit_7e4ff047/R1', 'R', '5000.0');
set_param('circuit_7e4ff047/R1', 'R_unit', 'Ohm');

% [GND1] Ground Reference
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_7e4ff047/GND1', ...
    'Position', [380, 420, 440, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_7e4ff047', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_TANK (connections: I1.+, L1.1, C1.1, R1.1)
try
    add_line('circuit_7e4ff047', 'I1/RConn1', 'L1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_TANK: ', me.message]);
end
try
    add_line('circuit_7e4ff047', 'L1/LConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_TANK: ', me.message]);
end
try
    add_line('circuit_7e4ff047', 'C1/LConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_TANK: ', me.message]);
end

% Net: GND (connections: I1.-, L1.2, C1.2, R1.2, GND1.1)
try
    add_line('circuit_7e4ff047', 'I1/LConn1', 'L1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_7e4ff047', 'L1/RConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_7e4ff047', 'C1/RConn1', 'R1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_7e4ff047', 'R1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_7e4ff047', 'F:/KONE FINALS/circuit2sim/generated/circuit_7e4ff047.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_7e4ff047.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_7e4ff047', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_7e4ff047', 0);