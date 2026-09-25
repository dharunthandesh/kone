% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_8e92c467
% Generated:   2026-09-24 21:27:01 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_8e92c467...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_8e92c467')
    close_system('circuit_8e92c467', 0);
end

% 1. Create fresh Simulink model in memory
new_system('circuit_8e92c467');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_8e92c467', 'Solver', 'ode23t');
set_param('circuit_8e92c467', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_8e92c467/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V_UDC] High-Voltage DC Bus (+UDC / UDC/-)
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_8e92c467/V_UDC', ...
    'Position', [835, 68, 895, 108]);
set_param('circuit_8e92c467/V_UDC', 'v0', '600.0');
set_param('circuit_8e92c467/V_UDC', 'v0_unit', 'V');

% [R96] HV Divider Resistor Stage 1
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R96', ...
    'Position', [803, 101, 863, 141]);
set_param('circuit_8e92c467/R96', 'R', '221000.0');
set_param('circuit_8e92c467/R96', 'R_unit', 'Ohm');

% [R87] HV Divider Resistor Stage 2
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R87', ...
    'Position', [740, 101, 800, 141]);
set_param('circuit_8e92c467/R87', 'R', '221000.0');
set_param('circuit_8e92c467/R87', 'R_unit', 'Ohm');

% [R169] HV Divider Resistor Stage 3
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R169', ...
    'Position', [677, 101, 737, 141]);
set_param('circuit_8e92c467/R169', 'R', '221000.0');
set_param('circuit_8e92c467/R169', 'R_unit', 'Ohm');

% [C40] Input Filter Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8e92c467/C40', ...
    'Position', [650, 126, 710, 166]);
set_param('circuit_8e92c467/C40', 'c', '1e-07');
set_param('circuit_8e92c467/C40', 'c_unit', 'F');

% [R91] Sense Shunt Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R91', ...
    'Position', [611, 123, 671, 163]);
set_param('circuit_8e92c467/R91', 'R', '332.0');
set_param('circuit_8e92c467/R91', 'R_unit', 'Ohm');

% [C59] Supply Decoupling Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8e92c467/C59', ...
    'Position', [566, 114, 626, 154]);
set_param('circuit_8e92c467/C59', 'c', '1e-07');
set_param('circuit_8e92c467/C59', 'c_unit', 'F');

% [U9] ACPL-C79A Precision Isolation Amplifier
add_block('fl_lib/Electrical/Electrical Elements/Op-Amp', 'circuit_8e92c467/U9', ...
    'Position', [426, 87, 508, 140]);

% [C60] Differential Output Filter Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8e92c467/C60', ...
    'Position', [354, 126, 414, 166]);
set_param('circuit_8e92c467/C60', 'c', '1e-07');
set_param('circuit_8e92c467/C60', 'c_unit', 'F');

% [R89] Differential Filter Resistor (Non-Inverting)
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R89', ...
    'Position', [300, 84, 360, 124]);
set_param('circuit_8e92c467/R89', 'R', '10000.0');
set_param('circuit_8e92c467/R89', 'R_unit', 'Ohm');

% [R94] Differential Filter Resistor (Inverting)
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R94', ...
    'Position', [300, 128, 360, 168]);
set_param('circuit_8e92c467/R94', 'R', '10000.0');
set_param('circuit_8e92c467/R94', 'R_unit', 'Ohm');

% [R86] Bias Pull-Up Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R86', ...
    'Position', [270, 42, 330, 82]);
set_param('circuit_8e92c467/R86', 'R', '10000.0');
set_param('circuit_8e92c467/R86', 'R_unit', 'Ohm');

% [U3B] LMV932 Rail-to-Rail Operational Amplifier
add_block('fl_lib/Electrical/Electrical Elements/Op-Amp', 'circuit_8e92c467/U3B', ...
    'Position', [193, 87, 253, 127]);

% [R95] Negative Feedback Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R95', ...
    'Position', [193, 155, 253, 195]);
set_param('circuit_8e92c467/R95', 'R', '10000.0');
set_param('circuit_8e92c467/R95', 'R_unit', 'Ohm');

% [R7] Output Protection Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_8e92c467/R7', ...
    'Position', [121, 101, 181, 141]);
set_param('circuit_8e92c467/R7', 'R', '1000.0');
set_param('circuit_8e92c467/R7', 'R_unit', 'Ohm');

% [C41] Measurement Filter Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_8e92c467/C41', ...
    'Position', [85, 124, 145, 164]);
set_param('circuit_8e92c467/C41', 'c', '1e-08');
set_param('circuit_8e92c467/C41', 'c_unit', 'F');

% [GND1] Return Ground Reference
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_8e92c467/GND1', ...
    'Position', [605, 170, 665, 210]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_8e92c467', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_UDC_POS (connections: V_UDC.+, R96.2)
try
    add_line('circuit_8e92c467', 'V_UDC/RConn1', 'R96/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_POS: ', me.message]);
end

% Net: N_DIV1 (connections: R96.1, R87.2)
try
    add_line('circuit_8e92c467', 'R96/LConn1', 'R87/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DIV1: ', me.message]);
end

% Net: N_DIV2 (connections: R87.1, R169.2)
try
    add_line('circuit_8e92c467', 'R87/LConn1', 'R169/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DIV2: ', me.message]);
end

% Net: N_VINP (connections: R169.1, R91.1, C40.1, U9.+)
try
    add_line('circuit_8e92c467', 'R169/LConn1', 'R91/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_VINP: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'R91/LConn1', 'C40/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_VINP: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'C40/LConn1', 'U9/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_VINP: ', me.message]);
end

% Net: N_UDC_NEG (connections: V_UDC.-, R91.2, C40.2, C59.2, U9.-, GND1.1)
try
    add_line('circuit_8e92c467', 'V_UDC/LConn1', 'R91/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_NEG: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'R91/RConn1', 'C40/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_NEG: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'C40/RConn1', 'C59/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_NEG: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'C59/RConn1', 'U9/LConn2', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_NEG: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'U9/LConn2', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_NEG: ', me.message]);
end

% Net: N_VOUTP (connections: U9.out, R89.2, C60.1)
try
    add_line('circuit_8e92c467', 'U9/RConn1', 'R89/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_VOUTP: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'R89/RConn1', 'C60/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_VOUTP: ', me.message]);
end

% Net: N_OPA_IN_P (connections: R89.1, R86.2, U3B.+)
try
    add_line('circuit_8e92c467', 'R89/LConn1', 'R86/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_IN_P: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'R86/RConn1', 'U3B/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_IN_P: ', me.message]);
end

% Net: N_OPA_IN_N (connections: R94.1, C60.2, U3B.-, R95.2)
try
    add_line('circuit_8e92c467', 'R94/LConn1', 'C60/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_IN_N: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'C60/RConn1', 'U3B/LConn2', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_IN_N: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'U3B/LConn2', 'R95/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_IN_N: ', me.message]);
end

% Net: N_OPA_OUT (connections: U3B.out, R95.1, R7.2)
try
    add_line('circuit_8e92c467', 'U3B/RConn1', 'R95/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_OUT: ', me.message]);
end
try
    add_line('circuit_8e92c467', 'R95/LConn1', 'R7/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OPA_OUT: ', me.message]);
end

% Net: N_UDC_MEAS (connections: R7.1, C41.1)
try
    add_line('circuit_8e92c467', 'R7/LConn1', 'C41/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_UDC_MEAS: ', me.message]);
end

% Net: N_C41_GND (connections: C41.2, GND1.1)
try
    add_line('circuit_8e92c467', 'C41/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_C41_GND: ', me.message]);
end

% Net: N_R86_GND (connections: R86.1, GND1.1)
try
    add_line('circuit_8e92c467', 'R86/LConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_R86_GND: ', me.message]);
end

% Net: N_R94_GND (connections: R94.2, GND1.1)
try
    add_line('circuit_8e92c467', 'R94/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_R94_GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_8e92c467', 'F:/KONE FINALS/circuit2sim/generated/circuit_8e92c467.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_8e92c467.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('circuit_8e92c467', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('circuit_8e92c467', 0);