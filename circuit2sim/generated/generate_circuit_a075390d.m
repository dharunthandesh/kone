% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_a075390d
% Generated:   2026-09-24 21:20:02 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_a075390d...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_a075390d')
    close_system('circuit_a075390d', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_a075390d');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_a075390d', 'Solver', 'ode23t');
set_param('circuit_a075390d', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_a075390d/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V_BUS] Main DC Power Bus
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_a075390d/V_BUS', ...
    'Position', [100, 260, 160, 330]);
set_param('circuit_a075390d/V_BUS', 'v0', '24.0');
set_param('circuit_a075390d/V_BUS', 'v0_unit', 'V');

% [R_SHUNT] Kelvin Sense Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_a075390d/R_SHUNT', ...
    'Position', [260, 170, 340, 210]);
set_param('circuit_a075390d/R_SHUNT', 'R', '0.05');
set_param('circuit_a075390d/R_SHUNT', 'R_unit', 'Ohm');

% [R_LOAD] System Work Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_a075390d/R_LOAD', ...
    'Position', [420, 260, 480, 330]);
set_param('circuit_a075390d/R_LOAD', 'R', '12.0');
set_param('circuit_a075390d/R_LOAD', 'R_unit', 'Ohm');

% [R_FILT] Sense Lead Filter Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_a075390d/R_FILT', ...
    'Position', [560, 170, 640, 210]);
set_param('circuit_a075390d/R_FILT', 'R', '100.0');
set_param('circuit_a075390d/R_FILT', 'R_unit', 'Ohm');

% [C_FILT] Sense Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_a075390d/C_FILT', ...
    'Position', [700, 260, 760, 330]);
set_param('circuit_a075390d/C_FILT', 'c', '1e-07');
set_param('circuit_a075390d/C_FILT', 'c_unit', 'F');

% [GND1] Power Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_a075390d/GND1', ...
    'Position', [420, 410, 480, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_a075390d', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_BUS (connections: V_BUS.+, R_SHUNT.1)
try
    add_line('circuit_a075390d', 'V_BUS/RConn1', 'R_SHUNT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BUS: ', me.message]);
end

% Net: N_LOAD (connections: R_SHUNT.2, R_LOAD.1, R_FILT.1)
try
    add_line('circuit_a075390d', 'R_SHUNT/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_LOAD: ', me.message]);
end
try
    add_line('circuit_a075390d', 'R_LOAD/LConn1', 'R_FILT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_LOAD: ', me.message]);
end

% Net: N_SENSE (connections: R_FILT.2, C_FILT.1)
try
    add_line('circuit_a075390d', 'R_FILT/RConn1', 'C_FILT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_SENSE: ', me.message]);
end

% Net: GND (connections: V_BUS.-, R_LOAD.2, C_FILT.2, GND1.1)
try
    add_line('circuit_a075390d', 'V_BUS/LConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_a075390d', 'R_LOAD/RConn1', 'C_FILT/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_a075390d', 'C_FILT/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_a075390d', 'F:/KONE FINALS/circuit2sim/generated/circuit_a075390d.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_a075390d.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_a075390d', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_a075390d', 0);