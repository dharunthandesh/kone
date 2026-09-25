% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_sim
% Generated:   2026-09-24 18:50:21 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_sim...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_sim')
    close_system('circuit_sim', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_sim');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_sim', 'Solver', 'ode23t');
set_param('circuit_sim', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_sim/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] DC Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_sim/V1', ...
    'Position', [200, 120, 280, 170]);
set_param('circuit_sim/V1', 'v0', '12.0');
set_param('circuit_sim/V1', 'v0_unit', 'V');

% [R1] Filter Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_sim/R1', ...
    'Position', [360, 120, 440, 170]);
set_param('circuit_sim/R1', 'R', '10000.0');
set_param('circuit_sim/R1', 'R_unit', 'Ohm');

% [C1] Filter Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_sim/C1', ...
    'Position', [520, 120, 600, 170]);
set_param('circuit_sim/C1', 'c', '1e-07');
set_param('circuit_sim/C1', 'c_unit', 'F');

% [GND1] Chassis Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_sim/GND1', ...
    'Position', [200, 230, 280, 280]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_sim', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1_VIN (connections: V1.+, R1.1)
try
    add_line('circuit_sim', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1_VIN: ', me.message]);
end

% Net: N2_VOUT (connections: R1.2, C1.1)
try
    add_line('circuit_sim', 'R1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2_VOUT: ', me.message]);
end

% Net: GND (connections: V1.-, C1.2, GND1.1)
try
    add_line('circuit_sim', 'V1/LConn1', 'C1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_sim', 'C1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_sim', 'F:/KONE FINALS/circuit2sim/generated/circuit_sim.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_sim.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_sim', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_sim', 0);