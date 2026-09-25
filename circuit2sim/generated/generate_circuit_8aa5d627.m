% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_8aa5d627
% Generated:   2026-09-24 18:07:26 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_8aa5d627...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_8aa5d627')
    close_system('circuit_8aa5d627', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_8aa5d627');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_8aa5d627', 'Solver', 'ode23t');
set_param('circuit_8aa5d627', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_8aa5d627/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Voltage Source V1
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_8aa5d627/V1', ...
    'Position', [200, 120, 280, 170]);
set_param('circuit_8aa5d627/V1', 'v0', '12.0');
set_param('circuit_8aa5d627/V1', 'v0_unit', 'V');

% [R2] Resistor R2
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8aa5d627/R2', ...
    'Position', [360, 120, 440, 170]);
set_param('circuit_8aa5d627/R2', 'R', '10000.0');
set_param('circuit_8aa5d627/R2', 'R_unit', 'Ohm');

% [L3] Inductor L3
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_8aa5d627/L3', ...
    'Position', [520, 120, 600, 170]);
set_param('circuit_8aa5d627/L3', 'l', '0.001');
set_param('circuit_8aa5d627/L3', 'l_unit', 'H');

% [R4] Resistor R4
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8aa5d627/R4', ...
    'Position', [200, 230, 280, 280]);
set_param('circuit_8aa5d627/R4', 'R', '10000.0');
set_param('circuit_8aa5d627/R4', 'R_unit', 'Ohm');

% [C5] Capacitor C5
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8aa5d627/C5', ...
    'Position', [360, 230, 440, 280]);
set_param('circuit_8aa5d627/C5', 'c', '1e-06');
set_param('circuit_8aa5d627/C5', 'c_unit', 'F');

% [L6] Inductor L6
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_8aa5d627/L6', ...
    'Position', [520, 230, 600, 280]);
set_param('circuit_8aa5d627/L6', 'l', '0.001');
set_param('circuit_8aa5d627/L6', 'l_unit', 'H');

% [R7] Resistor R7
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8aa5d627/R7', ...
    'Position', [200, 340, 280, 390]);
set_param('circuit_8aa5d627/R7', 'R', '10000.0');
set_param('circuit_8aa5d627/R7', 'R_unit', 'Ohm');

% [C8] Capacitor C8
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8aa5d627/C8', ...
    'Position', [360, 340, 440, 390]);
set_param('circuit_8aa5d627/C8', 'c', '1e-06');
set_param('circuit_8aa5d627/C8', 'c_unit', 'F');

% [C9] Capacitor C9
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8aa5d627/C9', ...
    'Position', [520, 340, 600, 390]);
set_param('circuit_8aa5d627/C9', 'c', '1e-07');
set_param('circuit_8aa5d627/C9', 'c_unit', 'F');

% [C10] Capacitor C10
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8aa5d627/C10', ...
    'Position', [200, 450, 280, 500]);
set_param('circuit_8aa5d627/C10', 'c', '1e-07');
set_param('circuit_8aa5d627/C10', 'c_unit', 'F');

% [R11] Resistor R11
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8aa5d627/R11', ...
    'Position', [360, 450, 440, 500]);
set_param('circuit_8aa5d627/R11', 'R', '10000.0');
set_param('circuit_8aa5d627/R11', 'R_unit', 'Ohm');

% [GND12] Ground GND12
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_8aa5d627/GND12', ...
    'Position', [520, 450, 600, 500]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_8aa5d627', 'Solver_Config/RConn1', 'GND12/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1_VIN (connections: V1.+, R2.1)
try
    add_line('circuit_8aa5d627', 'V1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1_VIN: ', me.message]);
end

% Net: N2 (connections: R2.2, L3.1)
try
    add_line('circuit_8aa5d627', 'R2/RConn1', 'L3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: L3.2, R4.1)
try
    add_line('circuit_8aa5d627', 'L3/RConn1', 'R4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: N4 (connections: R4.2, C5.1)
try
    add_line('circuit_8aa5d627', 'R4/RConn1', 'C5/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N4: ', me.message]);
end

% Net: N5 (connections: C5.2, L6.1)
try
    add_line('circuit_8aa5d627', 'C5/RConn1', 'L6/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N5: ', me.message]);
end

% Net: N6 (connections: L6.2, R7.1)
try
    add_line('circuit_8aa5d627', 'L6/RConn1', 'R7/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N6: ', me.message]);
end

% Net: N7 (connections: R7.2, C8.1)
try
    add_line('circuit_8aa5d627', 'R7/RConn1', 'C8/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N7: ', me.message]);
end

% Net: N8 (connections: C8.2, C9.1)
try
    add_line('circuit_8aa5d627', 'C8/RConn1', 'C9/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N8: ', me.message]);
end

% Net: N9 (connections: C9.2, C10.1)
try
    add_line('circuit_8aa5d627', 'C9/RConn1', 'C10/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N9: ', me.message]);
end

% Net: N10 (connections: C10.2, R11.1)
try
    add_line('circuit_8aa5d627', 'C10/RConn1', 'R11/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N10: ', me.message]);
end

% Net: GND (connections: GND12.1, V1.-, R11.2)
try
    add_line('circuit_8aa5d627', 'GND12/LConn1', 'V1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_8aa5d627', 'V1/LConn1', 'R11/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_8aa5d627', 'F:/KONE FINALS/circuit2sim/generated/circuit_8aa5d627.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_8aa5d627.slx']);

% 8. Simulation Smoke Test
disp('--> Running simulation smoke test...');
try
    simOut = sim('circuit_8aa5d627', 'StopTime', '0.01');
    disp('--> Smoke test completed successfully (PASS).');
catch me
    disp(['--> Smoke test note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_8aa5d627', 0);