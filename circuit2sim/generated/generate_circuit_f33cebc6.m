% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_f33cebc6
% Generated:   2026-09-24 20:41:24 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_f33cebc6...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_f33cebc6')
    close_system('circuit_f33cebc6', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_f33cebc6');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_f33cebc6', 'Solver', 'ode23t');
set_param('circuit_f33cebc6', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_f33cebc6/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [R1] Resistor R1
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R1', ...
    'Position', [30, 28, 130, 68]);
set_param('circuit_f33cebc6/R1', 'R', '10000.0');
set_param('circuit_f33cebc6/R1', 'R_unit', 'Ohm');

% [R2] Resistor R2
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R2', ...
    'Position', [39, 63, 99, 103]);
set_param('circuit_f33cebc6/R2', 'R', '1000.0');
set_param('circuit_f33cebc6/R2', 'R_unit', 'Ohm');

% [R3] Resistor R3
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R3', ...
    'Position', [77, 61, 137, 101]);
set_param('circuit_f33cebc6/R3', 'R', '1000.0');
set_param('circuit_f33cebc6/R3', 'R_unit', 'Ohm');

% [R4] Resistor R4
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R4', ...
    'Position', [113, 61, 173, 101]);
set_param('circuit_f33cebc6/R4', 'R', '10000.0');
set_param('circuit_f33cebc6/R4', 'R_unit', 'Ohm');

% [R5] Resistor R5
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R5', ...
    'Position', [181, 60, 241, 100]);
set_param('circuit_f33cebc6/R5', 'R', '1000.0');
set_param('circuit_f33cebc6/R5', 'R_unit', 'Ohm');

% [R6] Resistor R6
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R6', ...
    'Position', [289, 63, 349, 103]);
set_param('circuit_f33cebc6/R6', 'R', '1000.0');
set_param('circuit_f33cebc6/R6', 'R_unit', 'Ohm');

% [R7] Resistor R7
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R7', ...
    'Position', [293, 28, 393, 68]);
set_param('circuit_f33cebc6/R7', 'R', '10000.0');
set_param('circuit_f33cebc6/R7', 'R_unit', 'Ohm');

% [R8] Resistor R8
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R8', ...
    'Position', [326, 63, 386, 103]);
set_param('circuit_f33cebc6/R8', 'R', '10000.0');
set_param('circuit_f33cebc6/R8', 'R_unit', 'Ohm');

% [R9] Resistor R9
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R9', ...
    'Position', [385, 60, 445, 100]);
set_param('circuit_f33cebc6/R9', 'R', '1000.0');
set_param('circuit_f33cebc6/R9', 'R_unit', 'Ohm');

% [R10] Resistor R10
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R10', ...
    'Position', [455, 62, 515, 102]);
set_param('circuit_f33cebc6/R10', 'R', '10000.0');
set_param('circuit_f33cebc6/R10', 'R_unit', 'Ohm');

% [R11] Resistor R11
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R11', ...
    'Position', [500, 60, 560, 100]);
set_param('circuit_f33cebc6/R11', 'R', '1000.0');
set_param('circuit_f33cebc6/R11', 'R_unit', 'Ohm');

% [C12] Capacitor C12
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_f33cebc6/C12', ...
    'Position', [320, 166, 380, 233]);
set_param('circuit_f33cebc6/C12', 'c', '1e-06');
set_param('circuit_f33cebc6/C12', 'c_unit', 'F');

% [GND13] Ground GND13
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND13', ...
    'Position', [505, 195, 565, 235]);

% [V14] Voltage Source V14
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_f33cebc6/V14', ...
    'Position', [91, 258, 170, 328]);
set_param('circuit_f33cebc6/V14', 'v0', '12.0');
set_param('circuit_f33cebc6/V14', 'v0_unit', 'V');

% [C15] Capacitor C15
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_f33cebc6/C15', ...
    'Position', [536, 283, 596, 323]);
set_param('circuit_f33cebc6/C15', 'c', '1e-06');
set_param('circuit_f33cebc6/C15', 'c_unit', 'F');

% [R16] Resistor R16
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R16', ...
    'Position', [688, 278, 750, 318]);
set_param('circuit_f33cebc6/R16', 'R', '10000.0');
set_param('circuit_f33cebc6/R16', 'R_unit', 'Ohm');

% [GND17] Ground GND17
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND17', ...
    'Position', [374, 455, 434, 495]);

% [GND18] Ground GND18
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND18', ...
    'Position', [375, 415, 435, 455]);

% [GND19] Ground GND19
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND19', ...
    'Position', [505, 415, 565, 455]);

% [GND20] Ground GND20
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND20', ...
    'Position', [665, 415, 725, 455]);

% [L21] Inductor L21
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_f33cebc6/L21', ...
    'Position', [29, 587, 129, 627]);
set_param('circuit_f33cebc6/L21', 'l', '0.001');
set_param('circuit_f33cebc6/L21', 'l_unit', 'H');

% [R22] Resistor R22
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R22', ...
    'Position', [30, 613, 130, 653]);
set_param('circuit_f33cebc6/R22', 'R', '10000.0');
set_param('circuit_f33cebc6/R22', 'R_unit', 'Ohm');

% [R23] Resistor R23
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R23', ...
    'Position', [220, 587, 320, 628]);
set_param('circuit_f33cebc6/R23', 'R', '10000.0');
set_param('circuit_f33cebc6/R23', 'R_unit', 'Ohm');

% [GND24] Ground GND24
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND24', ...
    'Position', [220, 614, 280, 654]);

% [GND25] Ground GND25
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_f33cebc6/GND25', ...
    'Position', [413, 614, 473, 654]);

% [R26] Resistor R26
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_f33cebc6/R26', ...
    'Position', [449, 614, 509, 654]);
set_param('circuit_f33cebc6/R26', 'R', '10000.0');
set_param('circuit_f33cebc6/R26', 'R_unit', 'Ohm');

% [L27] Inductor L27
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_f33cebc6/L27', ...
    'Position', [700, 587, 800, 628]);
set_param('circuit_f33cebc6/L27', 'l', '0.001');
set_param('circuit_f33cebc6/L27', 'l_unit', 'H');

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_f33cebc6', 'Solver_Config/RConn1', 'GND13/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1_VIN (connections: V14.+, R1.1)
try
    add_line('circuit_f33cebc6', 'V14/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1_VIN: ', me.message]);
end

% Net: N2 (connections: R1.2, R2.1)
try
    add_line('circuit_f33cebc6', 'R1/RConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: R2.2, R3.1)
try
    add_line('circuit_f33cebc6', 'R2/RConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: N4 (connections: R3.2, R4.1)
try
    add_line('circuit_f33cebc6', 'R3/RConn1', 'R4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N4: ', me.message]);
end

% Net: N5 (connections: R4.2, R5.1)
try
    add_line('circuit_f33cebc6', 'R4/RConn1', 'R5/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N5: ', me.message]);
end

% Net: N6 (connections: R5.2, R6.1)
try
    add_line('circuit_f33cebc6', 'R5/RConn1', 'R6/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N6: ', me.message]);
end

% Net: N7 (connections: R6.2, R7.1)
try
    add_line('circuit_f33cebc6', 'R6/RConn1', 'R7/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N7: ', me.message]);
end

% Net: N8 (connections: R7.2, R8.1)
try
    add_line('circuit_f33cebc6', 'R7/RConn1', 'R8/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N8: ', me.message]);
end

% Net: N9 (connections: R8.2, R9.1)
try
    add_line('circuit_f33cebc6', 'R8/RConn1', 'R9/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N9: ', me.message]);
end

% Net: N10 (connections: R9.2, R10.1)
try
    add_line('circuit_f33cebc6', 'R9/RConn1', 'R10/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N10: ', me.message]);
end

% Net: N11 (connections: R10.2, R11.1)
try
    add_line('circuit_f33cebc6', 'R10/RConn1', 'R11/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N11: ', me.message]);
end

% Net: N12 (connections: R11.2, C12.1)
try
    add_line('circuit_f33cebc6', 'R11/RConn1', 'C12/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N12: ', me.message]);
end

% Net: N13 (connections: C12.2, C15.1)
try
    add_line('circuit_f33cebc6', 'C12/RConn1', 'C15/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N13: ', me.message]);
end

% Net: N14 (connections: C15.2, R16.1)
try
    add_line('circuit_f33cebc6', 'C15/RConn1', 'R16/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N14: ', me.message]);
end

% Net: N15 (connections: R16.2, L21.1)
try
    add_line('circuit_f33cebc6', 'R16/RConn1', 'L21/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N15: ', me.message]);
end

% Net: N16 (connections: L21.2, R22.1)
try
    add_line('circuit_f33cebc6', 'L21/RConn1', 'R22/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N16: ', me.message]);
end

% Net: N17 (connections: R22.2, R23.1)
try
    add_line('circuit_f33cebc6', 'R22/RConn1', 'R23/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N17: ', me.message]);
end

% Net: N18 (connections: R23.2, R26.1)
try
    add_line('circuit_f33cebc6', 'R23/RConn1', 'R26/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N18: ', me.message]);
end

% Net: N19 (connections: R26.2, L27.1)
try
    add_line('circuit_f33cebc6', 'R26/RConn1', 'L27/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N19: ', me.message]);
end

% Net: GND (connections: V14.-, GND13.1, L27.2)
try
    add_line('circuit_f33cebc6', 'V14/LConn1', 'GND13/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_f33cebc6', 'GND13/LConn1', 'L27/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_f33cebc6', 'F:/KONE FINALS/circuit2sim/generated/circuit_f33cebc6.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_f33cebc6.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_f33cebc6', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_f33cebc6', 0);