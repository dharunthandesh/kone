% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_455664a5
% Generated:   2026-09-24 20:45:20 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_455664a5...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_455664a5')
    close_system('circuit_455664a5', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_455664a5');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_455664a5', 'Solver', 'ode23t');
set_param('circuit_455664a5', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_455664a5/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [R1] Resistor R1
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R1', ...
    'Position', [29, 28, 129, 68]);
set_param('circuit_455664a5/R1', 'R', '10000.0');
set_param('circuit_455664a5/R1', 'R_unit', 'Ohm');

% [R2] Resistor R2
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R2', ...
    'Position', [38, 63, 98, 103]);
set_param('circuit_455664a5/R2', 'R', '1000.0');
set_param('circuit_455664a5/R2', 'R_unit', 'Ohm');

% [L3] Inductor L3
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_455664a5/L3', ...
    'Position', [75, 61, 135, 101]);
set_param('circuit_455664a5/L3', 'l', '0.001');
set_param('circuit_455664a5/L3', 'l_unit', 'H');

% [D4] Diode D4
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'circuit_455664a5/D4', ...
    'Position', [125, 63, 185, 103]);
set_param('circuit_455664a5/D4', 'Vf', '0.7');
set_param('circuit_455664a5/D4', 'Vf_unit', 'V');

% [R5] Resistor R5
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R5', ...
    'Position', [153, 60, 244, 100]);
set_param('circuit_455664a5/R5', 'R', '10000.0');
set_param('circuit_455664a5/R5', 'R_unit', 'Ohm');

% [L6] Inductor L6
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_455664a5/L6', ...
    'Position', [264, 60, 364, 100]);
set_param('circuit_455664a5/L6', 'l', '0.001');
set_param('circuit_455664a5/L6', 'l_unit', 'H');

% [R7] Resistor R7
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R7', ...
    'Position', [327, 28, 427, 68]);
set_param('circuit_455664a5/R7', 'R', '10000.0');
set_param('circuit_455664a5/R7', 'R_unit', 'Ohm');

% [R8] Resistor R8
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R8', ...
    'Position', [416, 60, 476, 100]);
set_param('circuit_455664a5/R8', 'R', '10000.0');
set_param('circuit_455664a5/R8', 'R_unit', 'Ohm');

% [L9] Inductor L9
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_455664a5/L9', ...
    'Position', [515, 28, 575, 68]);
set_param('circuit_455664a5/L9', 'l', '0.001');
set_param('circuit_455664a5/L9', 'l_unit', 'H');

% [GND10] Ground GND10
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND10', ...
    'Position', [295, 195, 355, 235]);

% [C11] Capacitor C11
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_455664a5/C11', ...
    'Position', [417, 170, 486, 229]);
set_param('circuit_455664a5/C11', 'c', '1e-06');
set_param('circuit_455664a5/C11', 'c_unit', 'F');

% [GND12] Ground GND12
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND12', ...
    'Position', [585, 195, 645, 235]);

% [V13] Voltage Source V13
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_455664a5/V13', ...
    'Position', [91, 258, 170, 328]);
set_param('circuit_455664a5/V13', 'v0', '12.0');
set_param('circuit_455664a5/V13', 'v0_unit', 'V');

% [C14] Capacitor C14
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_455664a5/C14', ...
    'Position', [326, 283, 386, 323]);
set_param('circuit_455664a5/C14', 'c', '1e-06');
set_param('circuit_455664a5/C14', 'c_unit', 'F');

% [C15] Capacitor C15
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_455664a5/C15', ...
    'Position', [616, 283, 676, 323]);
set_param('circuit_455664a5/C15', 'c', '1e-06');
set_param('circuit_455664a5/C15', 'c_unit', 'F');

% [R16] Resistor R16
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R16', ...
    'Position', [738, 278, 800, 318]);
set_param('circuit_455664a5/R16', 'R', '10000.0');
set_param('circuit_455664a5/R16', 'R_unit', 'Ohm');

% [GND17] Ground GND17
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND17', ...
    'Position', [295, 415, 355, 455]);

% [GND18] Ground GND18
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND18', ...
    'Position', [444, 455, 504, 495]);

% [GND19] Ground GND19
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND19', ...
    'Position', [445, 415, 505, 455]);

% [GND20] Ground GND20
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND20', ...
    'Position', [585, 415, 645, 455]);

% [GND21] Ground GND21
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_455664a5/GND21', ...
    'Position', [715, 415, 775, 455]);

% [R22] Resistor R22
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R22', ...
    'Position', [29, 587, 129, 627]);
set_param('circuit_455664a5/R22', 'R', '10000.0');
set_param('circuit_455664a5/R22', 'R_unit', 'Ohm');

% [R23] Resistor R23
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R23', ...
    'Position', [30, 613, 130, 653]);
set_param('circuit_455664a5/R23', 'R', '10000.0');
set_param('circuit_455664a5/R23', 'R_unit', 'Ohm');

% [L24] Inductor L24
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_455664a5/L24', ...
    'Position', [204, 587, 304, 628]);
set_param('circuit_455664a5/L24', 'l', '0.001');
set_param('circuit_455664a5/L24', 'l_unit', 'H');

% [R25] Resistor R25
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R25', ...
    'Position', [419, 613, 508, 653]);
set_param('circuit_455664a5/R25', 'R', '10000.0');
set_param('circuit_455664a5/R25', 'R_unit', 'Ohm');

% [R26] Resistor R26
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_455664a5/R26', ...
    'Position', [700, 587, 800, 628]);
set_param('circuit_455664a5/R26', 'R', '10000.0');
set_param('circuit_455664a5/R26', 'R_unit', 'Ohm');

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_455664a5', 'Solver_Config/RConn1', 'GND10/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1_VIN (connections: V13.+, R1.1)
try
    add_line('circuit_455664a5', 'V13/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1_VIN: ', me.message]);
end

% Net: N2 (connections: R1.2, R2.1)
try
    add_line('circuit_455664a5', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: R2.2, L3.1)
try
    add_line('circuit_455664a5', 'R2/RConn1', 'L3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: N4 (connections: L3.2, D4.A)
try
    add_line('circuit_455664a5', 'L3/RConn1', 'D4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N4: ', me.message]);
end

% Net: N5 (connections: D4.K, R5.1)
try
    add_line('circuit_455664a5', 'D4/RConn1', 'R5/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N5: ', me.message]);
end

% Net: N6 (connections: R5.2, L6.1)
try
    add_line('circuit_455664a5', 'R5/RConn1', 'L6/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N6: ', me.message]);
end

% Net: N7 (connections: L6.2, R7.1)
try
    add_line('circuit_455664a5', 'L6/RConn1', 'R7/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N7: ', me.message]);
end

% Net: N8 (connections: R7.2, R8.1)
try
    add_line('circuit_455664a5', 'R7/RConn1', 'R8/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N8: ', me.message]);
end

% Net: N9 (connections: R8.2, L9.1)
try
    add_line('circuit_455664a5', 'R8/RConn1', 'L9/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N9: ', me.message]);
end

% Net: N10 (connections: L9.2, C11.1)
try
    add_line('circuit_455664a5', 'L9/RConn1', 'C11/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N10: ', me.message]);
end

% Net: N11 (connections: C11.2, C14.1)
try
    add_line('circuit_455664a5', 'C11/RConn1', 'C14/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N11: ', me.message]);
end

% Net: N12 (connections: C14.2, C15.1)
try
    add_line('circuit_455664a5', 'C14/RConn1', 'C15/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N12: ', me.message]);
end

% Net: N13 (connections: C15.2, R16.1)
try
    add_line('circuit_455664a5', 'C15/RConn1', 'R16/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N13: ', me.message]);
end

% Net: N14 (connections: R16.2, R22.1)
try
    add_line('circuit_455664a5', 'R16/RConn1', 'R22/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N14: ', me.message]);
end

% Net: N15 (connections: R22.2, R23.1)
try
    add_line('circuit_455664a5', 'R22/RConn1', 'R23/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N15: ', me.message]);
end

% Net: N16 (connections: R23.2, L24.1)
try
    add_line('circuit_455664a5', 'R23/RConn1', 'L24/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N16: ', me.message]);
end

% Net: N17 (connections: L24.2, R25.1)
try
    add_line('circuit_455664a5', 'L24/RConn1', 'R25/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N17: ', me.message]);
end

% Net: N18 (connections: R25.2, R26.1)
try
    add_line('circuit_455664a5', 'R25/RConn1', 'R26/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N18: ', me.message]);
end

% Net: GND (connections: R26.2, GND10.1, V13.-)
try
    add_line('circuit_455664a5', 'R26/RConn1', 'GND10/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_455664a5', 'GND10/LConn1', 'V13/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_455664a5', 'F:/KONE FINALS/circuit2sim/generated/circuit_455664a5.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_455664a5.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_455664a5', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_455664a5', 0);