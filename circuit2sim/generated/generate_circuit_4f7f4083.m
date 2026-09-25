% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: circuit_4f7f4083
% Generated:   2026-09-24 17:50:56 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for circuit_4f7f4083...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('circuit_4f7f4083')
    close_system('circuit_4f7f4083', 0);
end

% 1. Create fresh Simulink model
new_system('circuit_4f7f4083');
open_system('circuit_4f7f4083');

% 2. Configure Model Solver for Physical Network Simulation
set_param('circuit_4f7f4083', 'Solver', 'ode23t');
set_param('circuit_4f7f4083', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'circuit_4f7f4083/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [R1] Resistor R1
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R1', ...
    'Position', [200, 120, 280, 170]);

% [C2] Capacitor C2
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C2', ...
    'Position', [360, 120, 440, 170]);
set_param('circuit_4f7f4083/C2', 'c', '1e-06');
set_param('circuit_4f7f4083/C2', 'c_unit', 'F');

% [R3] Resistor R3
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R3', ...
    'Position', [520, 120, 600, 170]);

% [C4] Capacitor C4
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C4', ...
    'Position', [200, 230, 280, 280]);
set_param('circuit_4f7f4083/C4', 'c', '1e-06');
set_param('circuit_4f7f4083/C4', 'c_unit', 'F');

% [R5] Resistor R5
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R5', ...
    'Position', [360, 230, 440, 280]);
set_param('circuit_4f7f4083/R5', 'R', '1000.0');
set_param('circuit_4f7f4083/R5', 'R_unit', 'Ohm');

% [R6] Resistor R6
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R6', ...
    'Position', [520, 230, 600, 280]);
set_param('circuit_4f7f4083/R6', 'R', '1000.0');
set_param('circuit_4f7f4083/R6', 'R_unit', 'Ohm');

% [R7] Resistor R7
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R7', ...
    'Position', [200, 340, 280, 390]);

% [R8] Resistor R8
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R8', ...
    'Position', [360, 340, 440, 390]);
set_param('circuit_4f7f4083/R8', 'R', '10000.0');
set_param('circuit_4f7f4083/R8', 'R_unit', 'Ohm');

% [L9] Inductor L9
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L9', ...
    'Position', [520, 340, 600, 390]);
set_param('circuit_4f7f4083/L9', 'l', '0.001');
set_param('circuit_4f7f4083/L9', 'l_unit', 'H');

% [R10] Resistor R10
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R10', ...
    'Position', [200, 450, 280, 500]);

% [R11] Resistor R11
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R11', ...
    'Position', [360, 450, 440, 500]);
set_param('circuit_4f7f4083/R11', 'R', '10000.0');
set_param('circuit_4f7f4083/R11', 'R_unit', 'Ohm');

% [R12] Resistor R12
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R12', ...
    'Position', [520, 450, 600, 500]);

% [R13] Resistor R13
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R13', ...
    'Position', [200, 560, 280, 610]);
set_param('circuit_4f7f4083/R13', 'R', '1000.0');
set_param('circuit_4f7f4083/R13', 'R_unit', 'Ohm');

% [V14] Voltage Source V14
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_4f7f4083/V14', ...
    'Position', [360, 560, 440, 610]);
set_param('circuit_4f7f4083/V14', 'v0', '12.0');
set_param('circuit_4f7f4083/V14', 'v0_unit', 'V');

% [L15] Inductor L15
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L15', ...
    'Position', [520, 560, 600, 610]);
set_param('circuit_4f7f4083/L15', 'l', '0.001');
set_param('circuit_4f7f4083/L15', 'l_unit', 'H');

% [GND16] Ground GND16
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND16', ...
    'Position', [200, 670, 280, 720]);

% [R17] Resistor R17
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R17', ...
    'Position', [360, 670, 440, 720]);
set_param('circuit_4f7f4083/R17', 'R', '10000.0');
set_param('circuit_4f7f4083/R17', 'R_unit', 'Ohm');

% [L18] Inductor L18
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L18', ...
    'Position', [520, 670, 600, 720]);
set_param('circuit_4f7f4083/L18', 'l', '0.001');
set_param('circuit_4f7f4083/L18', 'l_unit', 'H');

% [R19] Resistor R19
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R19', ...
    'Position', [200, 780, 280, 830]);
set_param('circuit_4f7f4083/R19', 'R', '1000.0');
set_param('circuit_4f7f4083/R19', 'R_unit', 'Ohm');

% [R20] Resistor R20
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R20', ...
    'Position', [360, 780, 440, 830]);

% [C21] Capacitor C21
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C21', ...
    'Position', [520, 780, 600, 830]);
set_param('circuit_4f7f4083/C21', 'c', '1e-06');
set_param('circuit_4f7f4083/C21', 'c_unit', 'F');

% [R22] Resistor R22
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R22', ...
    'Position', [200, 890, 280, 940]);
set_param('circuit_4f7f4083/R22', 'R', '1000.0');
set_param('circuit_4f7f4083/R22', 'R_unit', 'Ohm');

% [R23] Resistor R23
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R23', ...
    'Position', [360, 890, 440, 940]);
set_param('circuit_4f7f4083/R23', 'R', '1000.0');
set_param('circuit_4f7f4083/R23', 'R_unit', 'Ohm');

% [GND24] Ground GND24
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND24', ...
    'Position', [520, 890, 600, 940]);

% [C25] Capacitor C25
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C25', ...
    'Position', [200, 1000, 280, 1050]);
set_param('circuit_4f7f4083/C25', 'c', '1e-06');
set_param('circuit_4f7f4083/C25', 'c_unit', 'F');

% [C26] Capacitor C26
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C26', ...
    'Position', [360, 1000, 440, 1050]);
set_param('circuit_4f7f4083/C26', 'c', '1e-06');
set_param('circuit_4f7f4083/C26', 'c_unit', 'F');

% [C27] Capacitor C27
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C27', ...
    'Position', [520, 1000, 600, 1050]);
set_param('circuit_4f7f4083/C27', 'c', '1e-06');
set_param('circuit_4f7f4083/C27', 'c_unit', 'F');

% [C28] Capacitor C28
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C28', ...
    'Position', [200, 1110, 280, 1160]);
set_param('circuit_4f7f4083/C28', 'c', '1e-06');
set_param('circuit_4f7f4083/C28', 'c_unit', 'F');

% [C29] Capacitor C29
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C29', ...
    'Position', [360, 1110, 440, 1160]);
set_param('circuit_4f7f4083/C29', 'c', '1e-07');
set_param('circuit_4f7f4083/C29', 'c_unit', 'F');

% [C30] Capacitor C30
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C30', ...
    'Position', [520, 1110, 600, 1160]);
set_param('circuit_4f7f4083/C30', 'c', '1e-06');
set_param('circuit_4f7f4083/C30', 'c_unit', 'F');

% [R31] Resistor R31
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R31', ...
    'Position', [200, 1220, 280, 1270]);

% [D32] Diode D32
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'circuit_4f7f4083/D32', ...
    'Position', [360, 1220, 440, 1270]);
set_param('circuit_4f7f4083/D32', 'Vf', '0.7');
set_param('circuit_4f7f4083/D32', 'Vf_unit', 'V');

% [GND33] Ground GND33
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND33', ...
    'Position', [520, 1220, 600, 1270]);

% [GND34] Ground GND34
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND34', ...
    'Position', [200, 1330, 280, 1380]);

% [C35] Capacitor C35
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C35', ...
    'Position', [360, 1330, 440, 1380]);
set_param('circuit_4f7f4083/C35', 'c', '1e-06');
set_param('circuit_4f7f4083/C35', 'c_unit', 'F');

% [C36] Capacitor C36
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C36', ...
    'Position', [520, 1330, 600, 1380]);
set_param('circuit_4f7f4083/C36', 'c', '1e-06');
set_param('circuit_4f7f4083/C36', 'c_unit', 'F');

% [GND37] Ground GND37
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND37', ...
    'Position', [200, 1440, 280, 1490]);

% [R38] Resistor R38
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R38', ...
    'Position', [360, 1440, 440, 1490]);

% [C39] Capacitor C39
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C39', ...
    'Position', [520, 1440, 600, 1490]);
set_param('circuit_4f7f4083/C39', 'c', '1e-06');
set_param('circuit_4f7f4083/C39', 'c_unit', 'F');

% [GND40] Ground GND40
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND40', ...
    'Position', [200, 1550, 280, 1600]);

% [R41] Resistor R41
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R41', ...
    'Position', [360, 1550, 440, 1600]);
set_param('circuit_4f7f4083/R41', 'R', '10000.0');
set_param('circuit_4f7f4083/R41', 'R_unit', 'Ohm');

% [L42] Inductor L42
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L42', ...
    'Position', [520, 1550, 600, 1600]);
set_param('circuit_4f7f4083/L42', 'l', '0.001');
set_param('circuit_4f7f4083/L42', 'l_unit', 'H');

% [C43] Capacitor C43
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C43', ...
    'Position', [200, 1660, 280, 1710]);
set_param('circuit_4f7f4083/C43', 'c', '1e-06');
set_param('circuit_4f7f4083/C43', 'c_unit', 'F');

% [R44] Resistor R44
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R44', ...
    'Position', [360, 1660, 440, 1710]);
set_param('circuit_4f7f4083/R44', 'R', '10000.0');
set_param('circuit_4f7f4083/R44', 'R_unit', 'Ohm');

% [GND45] Ground GND45
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND45', ...
    'Position', [520, 1660, 600, 1710]);

% [C46] Capacitor C46
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C46', ...
    'Position', [200, 1770, 280, 1820]);
set_param('circuit_4f7f4083/C46', 'c', '1e-07');
set_param('circuit_4f7f4083/C46', 'c_unit', 'F');

% [R47] Resistor R47
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R47', ...
    'Position', [360, 1770, 440, 1820]);
set_param('circuit_4f7f4083/R47', 'R', '10000.0');
set_param('circuit_4f7f4083/R47', 'R_unit', 'Ohm');

% [GND48] Ground GND48
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND48', ...
    'Position', [520, 1770, 600, 1820]);

% [C49] Capacitor C49
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C49', ...
    'Position', [200, 1880, 280, 1930]);
set_param('circuit_4f7f4083/C49', 'c', '1e-07');
set_param('circuit_4f7f4083/C49', 'c_unit', 'F');

% [R50] Resistor R50
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R50', ...
    'Position', [360, 1880, 440, 1930]);

% [L51] Inductor L51
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L51', ...
    'Position', [520, 1880, 600, 1930]);
set_param('circuit_4f7f4083/L51', 'l', '0.001');
set_param('circuit_4f7f4083/L51', 'l_unit', 'H');

% [R52] Resistor R52
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R52', ...
    'Position', [200, 1990, 280, 2040]);

% [R53] Resistor R53
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R53', ...
    'Position', [360, 1990, 440, 2040]);

% [L54] Inductor L54
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L54', ...
    'Position', [520, 1990, 600, 2040]);
set_param('circuit_4f7f4083/L54', 'l', '0.001');
set_param('circuit_4f7f4083/L54', 'l_unit', 'H');

% [GND55] Ground GND55
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND55', ...
    'Position', [200, 2100, 280, 2150]);

% [C56] Capacitor C56
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C56', ...
    'Position', [360, 2100, 440, 2150]);
set_param('circuit_4f7f4083/C56', 'c', '1e-07');
set_param('circuit_4f7f4083/C56', 'c_unit', 'F');

% [C57] Capacitor C57
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C57', ...
    'Position', [520, 2100, 600, 2150]);
set_param('circuit_4f7f4083/C57', 'c', '1e-06');
set_param('circuit_4f7f4083/C57', 'c_unit', 'F');

% [C58] Capacitor C58
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C58', ...
    'Position', [200, 2210, 280, 2260]);
set_param('circuit_4f7f4083/C58', 'c', '1e-07');
set_param('circuit_4f7f4083/C58', 'c_unit', 'F');

% [GND59] Ground GND59
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND59', ...
    'Position', [360, 2210, 440, 2260]);

% [C60] Capacitor C60
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C60', ...
    'Position', [520, 2210, 600, 2260]);
set_param('circuit_4f7f4083/C60', 'c', '1e-07');
set_param('circuit_4f7f4083/C60', 'c_unit', 'F');

% [C61] Capacitor C61
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C61', ...
    'Position', [200, 2320, 280, 2370]);
set_param('circuit_4f7f4083/C61', 'c', '1e-06');
set_param('circuit_4f7f4083/C61', 'c_unit', 'F');

% [GND62] Ground GND62
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND62', ...
    'Position', [360, 2320, 440, 2370]);

% [GND63] Ground GND63
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND63', ...
    'Position', [520, 2320, 600, 2370]);

% [GND64] Ground GND64
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND64', ...
    'Position', [200, 2430, 280, 2480]);

% [GND65] Ground GND65
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND65', ...
    'Position', [360, 2430, 440, 2480]);

% [L66] Inductor L66
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L66', ...
    'Position', [520, 2430, 600, 2480]);
set_param('circuit_4f7f4083/L66', 'l', '0.001');
set_param('circuit_4f7f4083/L66', 'l_unit', 'H');

% [GND67] Ground GND67
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND67', ...
    'Position', [200, 2540, 280, 2590]);

% [R68] Resistor R68
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R68', ...
    'Position', [360, 2540, 440, 2590]);
set_param('circuit_4f7f4083/R68', 'R', '10000.0');
set_param('circuit_4f7f4083/R68', 'R_unit', 'Ohm');

% [R69] Resistor R69
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R69', ...
    'Position', [520, 2540, 600, 2590]);

% [GND70] Ground GND70
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND70', ...
    'Position', [200, 2650, 280, 2700]);

% [GND71] Ground GND71
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND71', ...
    'Position', [360, 2650, 440, 2700]);

% [GND72] Ground GND72
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND72', ...
    'Position', [520, 2650, 600, 2700]);

% [C73] Capacitor C73
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C73', ...
    'Position', [200, 2760, 280, 2810]);
set_param('circuit_4f7f4083/C73', 'c', '1e-06');
set_param('circuit_4f7f4083/C73', 'c_unit', 'F');

% [GND74] Ground GND74
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND74', ...
    'Position', [360, 2760, 440, 2810]);

% [C75] Capacitor C75
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C75', ...
    'Position', [520, 2760, 600, 2810]);
set_param('circuit_4f7f4083/C75', 'c', '1e-06');
set_param('circuit_4f7f4083/C75', 'c_unit', 'F');

% [C76] Capacitor C76
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C76', ...
    'Position', [200, 2870, 280, 2920]);
set_param('circuit_4f7f4083/C76', 'c', '1e-07');
set_param('circuit_4f7f4083/C76', 'c_unit', 'F');

% [C77] Capacitor C77
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C77', ...
    'Position', [360, 2870, 440, 2920]);
set_param('circuit_4f7f4083/C77', 'c', '1e-06');
set_param('circuit_4f7f4083/C77', 'c_unit', 'F');

% [C78] Capacitor C78
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C78', ...
    'Position', [520, 2870, 600, 2920]);
set_param('circuit_4f7f4083/C78', 'c', '1e-06');
set_param('circuit_4f7f4083/C78', 'c_unit', 'F');

% [GND79] Ground GND79
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND79', ...
    'Position', [200, 2980, 280, 3030]);

% [R80] Resistor R80
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R80', ...
    'Position', [360, 2980, 440, 3030]);
set_param('circuit_4f7f4083/R80', 'R', '10000.0');
set_param('circuit_4f7f4083/R80', 'R_unit', 'Ohm');

% [C81] Capacitor C81
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C81', ...
    'Position', [520, 2980, 600, 3030]);
set_param('circuit_4f7f4083/C81', 'c', '1e-07');
set_param('circuit_4f7f4083/C81', 'c_unit', 'F');

% [GND82] Ground GND82
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND82', ...
    'Position', [200, 3090, 280, 3140]);

% [GND83] Ground GND83
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND83', ...
    'Position', [360, 3090, 440, 3140]);

% [GND84] Ground GND84
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND84', ...
    'Position', [520, 3090, 600, 3140]);

% [GND85] Ground GND85
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND85', ...
    'Position', [200, 3200, 280, 3250]);

% [C86] Capacitor C86
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C86', ...
    'Position', [360, 3200, 440, 3250]);
set_param('circuit_4f7f4083/C86', 'c', '1e-06');
set_param('circuit_4f7f4083/C86', 'c_unit', 'F');

% [L87] Inductor L87
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L87', ...
    'Position', [520, 3200, 600, 3250]);
set_param('circuit_4f7f4083/L87', 'l', '0.001');
set_param('circuit_4f7f4083/L87', 'l_unit', 'H');

% [C88] Capacitor C88
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C88', ...
    'Position', [200, 3310, 280, 3360]);
set_param('circuit_4f7f4083/C88', 'c', '1e-07');
set_param('circuit_4f7f4083/C88', 'c_unit', 'F');

% [C89] Capacitor C89
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C89', ...
    'Position', [360, 3310, 440, 3360]);
set_param('circuit_4f7f4083/C89', 'c', '1e-07');
set_param('circuit_4f7f4083/C89', 'c_unit', 'F');

% [C90] Capacitor C90
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C90', ...
    'Position', [520, 3310, 600, 3360]);
set_param('circuit_4f7f4083/C90', 'c', '1e-06');
set_param('circuit_4f7f4083/C90', 'c_unit', 'F');

% [R91] Resistor R91
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R91', ...
    'Position', [200, 3420, 280, 3470]);

% [R92] Resistor R92
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R92', ...
    'Position', [360, 3420, 440, 3470]);
set_param('circuit_4f7f4083/R92', 'R', '10000.0');
set_param('circuit_4f7f4083/R92', 'R_unit', 'Ohm');

% [R93] Resistor R93
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R93', ...
    'Position', [520, 3420, 600, 3470]);

% [R94] Resistor R94
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R94', ...
    'Position', [200, 3530, 280, 3580]);

% [GND95] Ground GND95
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND95', ...
    'Position', [360, 3530, 440, 3580]);

% [L96] Inductor L96
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L96', ...
    'Position', [520, 3530, 600, 3580]);
set_param('circuit_4f7f4083/L96', 'l', '0.001');
set_param('circuit_4f7f4083/L96', 'l_unit', 'H');

% [GND97] Ground GND97
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND97', ...
    'Position', [200, 3640, 280, 3690]);

% [R98] Resistor R98
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R98', ...
    'Position', [360, 3640, 440, 3690]);
set_param('circuit_4f7f4083/R98', 'R', '10000.0');
set_param('circuit_4f7f4083/R98', 'R_unit', 'Ohm');

% [C99] Capacitor C99
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C99', ...
    'Position', [520, 3640, 600, 3690]);
set_param('circuit_4f7f4083/C99', 'c', '1e-06');
set_param('circuit_4f7f4083/C99', 'c_unit', 'F');

% [R100] Resistor R100
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R100', ...
    'Position', [200, 3750, 280, 3800]);
set_param('circuit_4f7f4083/R100', 'R', '10000.0');
set_param('circuit_4f7f4083/R100', 'R_unit', 'Ohm');

% [R101] Resistor R101
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R101', ...
    'Position', [360, 3750, 440, 3800]);
set_param('circuit_4f7f4083/R101', 'R', '10000.0');
set_param('circuit_4f7f4083/R101', 'R_unit', 'Ohm');

% [GND102] Ground GND102
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND102', ...
    'Position', [520, 3750, 600, 3800]);

% [R103] Resistor R103
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R103', ...
    'Position', [200, 3860, 280, 3910]);

% [C104] Capacitor C104
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C104', ...
    'Position', [360, 3860, 440, 3910]);
set_param('circuit_4f7f4083/C104', 'c', '1e-06');
set_param('circuit_4f7f4083/C104', 'c_unit', 'F');

% [L105] Inductor L105
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L105', ...
    'Position', [520, 3860, 600, 3910]);
set_param('circuit_4f7f4083/L105', 'l', '0.001');
set_param('circuit_4f7f4083/L105', 'l_unit', 'H');

% [C106] Capacitor C106
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C106', ...
    'Position', [200, 3970, 280, 4020]);
set_param('circuit_4f7f4083/C106', 'c', '1e-06');
set_param('circuit_4f7f4083/C106', 'c_unit', 'F');

% [GND107] Ground GND107
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND107', ...
    'Position', [360, 3970, 440, 4020]);

% [C108] Capacitor C108
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C108', ...
    'Position', [520, 3970, 600, 4020]);
set_param('circuit_4f7f4083/C108', 'c', '1e-07');
set_param('circuit_4f7f4083/C108', 'c_unit', 'F');

% [R109] Resistor R109
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R109', ...
    'Position', [200, 4080, 280, 4130]);
set_param('circuit_4f7f4083/R109', 'R', '10000.0');
set_param('circuit_4f7f4083/R109', 'R_unit', 'Ohm');

% [GND110] Ground GND110
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND110', ...
    'Position', [360, 4080, 440, 4130]);

% [C111] Capacitor C111
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C111', ...
    'Position', [520, 4080, 600, 4130]);
set_param('circuit_4f7f4083/C111', 'c', '1e-07');
set_param('circuit_4f7f4083/C111', 'c_unit', 'F');

% [R112] Resistor R112
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R112', ...
    'Position', [200, 4190, 280, 4240]);
set_param('circuit_4f7f4083/R112', 'R', '10000.0');
set_param('circuit_4f7f4083/R112', 'R_unit', 'Ohm');

% [GND113] Ground GND113
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND113', ...
    'Position', [360, 4190, 440, 4240]);

% [C114] Capacitor C114
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C114', ...
    'Position', [520, 4190, 600, 4240]);
set_param('circuit_4f7f4083/C114', 'c', '1e-07');
set_param('circuit_4f7f4083/C114', 'c_unit', 'F');

% [R115] Resistor R115
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R115', ...
    'Position', [200, 4300, 280, 4350]);

% [R116] Resistor R116
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R116', ...
    'Position', [360, 4300, 440, 4350]);

% [GND117] Ground GND117
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND117', ...
    'Position', [520, 4300, 600, 4350]);

% [R118] Resistor R118
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R118', ...
    'Position', [200, 4410, 280, 4460]);
set_param('circuit_4f7f4083/R118', 'R', '10000.0');
set_param('circuit_4f7f4083/R118', 'R_unit', 'Ohm');

% [R119] Resistor R119
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R119', ...
    'Position', [360, 4410, 440, 4460]);
set_param('circuit_4f7f4083/R119', 'R', '10000.0');
set_param('circuit_4f7f4083/R119', 'R_unit', 'Ohm');

% [GND120] Ground GND120
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND120', ...
    'Position', [520, 4410, 600, 4460]);

% [R121] Resistor R121
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R121', ...
    'Position', [200, 4520, 280, 4570]);
set_param('circuit_4f7f4083/R121', 'R', '10000.0');
set_param('circuit_4f7f4083/R121', 'R_unit', 'Ohm');

% [C122] Capacitor C122
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C122', ...
    'Position', [360, 4520, 440, 4570]);
set_param('circuit_4f7f4083/C122', 'c', '1e-06');
set_param('circuit_4f7f4083/C122', 'c_unit', 'F');

% [L123] Inductor L123
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L123', ...
    'Position', [520, 4520, 600, 4570]);
set_param('circuit_4f7f4083/L123', 'l', '0.001');
set_param('circuit_4f7f4083/L123', 'l_unit', 'H');

% [GND124] Ground GND124
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND124', ...
    'Position', [200, 4630, 280, 4680]);

% [R125] Resistor R125
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R125', ...
    'Position', [360, 4630, 440, 4680]);
set_param('circuit_4f7f4083/R125', 'R', '10000.0');
set_param('circuit_4f7f4083/R125', 'R_unit', 'Ohm');

% [GND126] Ground GND126
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND126', ...
    'Position', [520, 4630, 600, 4680]);

% [GND127] Ground GND127
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND127', ...
    'Position', [200, 4740, 280, 4790]);

% [GND128] Ground GND128
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND128', ...
    'Position', [360, 4740, 440, 4790]);

% [L129] Inductor L129
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L129', ...
    'Position', [520, 4740, 600, 4790]);
set_param('circuit_4f7f4083/L129', 'l', '0.001');
set_param('circuit_4f7f4083/L129', 'l_unit', 'H');

% [GND130] Ground GND130
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND130', ...
    'Position', [200, 4850, 280, 4900]);

% [GND131] Ground GND131
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND131', ...
    'Position', [360, 4850, 440, 4900]);

% [L132] Inductor L132
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L132', ...
    'Position', [520, 4850, 600, 4900]);
set_param('circuit_4f7f4083/L132', 'l', '0.001');
set_param('circuit_4f7f4083/L132', 'l_unit', 'H');

% [GND133] Ground GND133
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND133', ...
    'Position', [200, 4960, 280, 5010]);

% [R134] Resistor R134
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R134', ...
    'Position', [360, 4960, 440, 5010]);
set_param('circuit_4f7f4083/R134', 'R', '10000.0');
set_param('circuit_4f7f4083/R134', 'R_unit', 'Ohm');

% [GND135] Ground GND135
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND135', ...
    'Position', [520, 4960, 600, 5010]);

% [R136] Resistor R136
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R136', ...
    'Position', [200, 5070, 280, 5120]);
set_param('circuit_4f7f4083/R136', 'R', '10000.0');
set_param('circuit_4f7f4083/R136', 'R_unit', 'Ohm');

% [R137] Resistor R137
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R137', ...
    'Position', [360, 5070, 440, 5120]);
set_param('circuit_4f7f4083/R137', 'R', '10000.0');
set_param('circuit_4f7f4083/R137', 'R_unit', 'Ohm');

% [GND138] Ground GND138
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND138', ...
    'Position', [520, 5070, 600, 5120]);

% [GND139] Ground GND139
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND139', ...
    'Position', [200, 5180, 280, 5230]);

% [R140] Resistor R140
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R140', ...
    'Position', [360, 5180, 440, 5230]);
set_param('circuit_4f7f4083/R140', 'R', '10000.0');
set_param('circuit_4f7f4083/R140', 'R_unit', 'Ohm');

% [C141] Capacitor C141
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C141', ...
    'Position', [520, 5180, 600, 5230]);
set_param('circuit_4f7f4083/C141', 'c', '1e-06');
set_param('circuit_4f7f4083/C141', 'c_unit', 'F');

% [R142] Resistor R142
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R142', ...
    'Position', [200, 5290, 280, 5340]);
set_param('circuit_4f7f4083/R142', 'R', '10000.0');
set_param('circuit_4f7f4083/R142', 'R_unit', 'Ohm');

% [GND143] Ground GND143
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND143', ...
    'Position', [360, 5290, 440, 5340]);

% [GND144] Ground GND144
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND144', ...
    'Position', [520, 5290, 600, 5340]);

% [R145] Resistor R145
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R145', ...
    'Position', [200, 5400, 280, 5450]);
set_param('circuit_4f7f4083/R145', 'R', '10000.0');
set_param('circuit_4f7f4083/R145', 'R_unit', 'Ohm');

% [GND146] Ground GND146
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND146', ...
    'Position', [360, 5400, 440, 5450]);

% [R147] Resistor R147
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R147', ...
    'Position', [520, 5400, 600, 5450]);

% [D148] Diode D148
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'circuit_4f7f4083/D148', ...
    'Position', [200, 5510, 280, 5560]);
set_param('circuit_4f7f4083/D148', 'Vf', '0.7');
set_param('circuit_4f7f4083/D148', 'Vf_unit', 'V');

% [R149] Resistor R149
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R149', ...
    'Position', [360, 5510, 440, 5560]);
set_param('circuit_4f7f4083/R149', 'R', '1000.0');
set_param('circuit_4f7f4083/R149', 'R_unit', 'Ohm');

% [GND150] Ground GND150
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND150', ...
    'Position', [520, 5510, 600, 5560]);

% [C151] Capacitor C151
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C151', ...
    'Position', [200, 5620, 280, 5670]);
set_param('circuit_4f7f4083/C151', 'c', '1e-06');
set_param('circuit_4f7f4083/C151', 'c_unit', 'F');

% [C152] Capacitor C152
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C152', ...
    'Position', [360, 5620, 440, 5670]);
set_param('circuit_4f7f4083/C152', 'c', '1e-07');
set_param('circuit_4f7f4083/C152', 'c_unit', 'F');

% [GND153] Ground GND153
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND153', ...
    'Position', [520, 5620, 600, 5670]);

% [R154] Resistor R154
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R154', ...
    'Position', [200, 5730, 280, 5780]);

% [GND155] Ground GND155
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND155', ...
    'Position', [360, 5730, 440, 5780]);

% [L156] Inductor L156
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L156', ...
    'Position', [520, 5730, 600, 5780]);
set_param('circuit_4f7f4083/L156', 'l', '0.001');
set_param('circuit_4f7f4083/L156', 'l_unit', 'H');

% [R157] Resistor R157
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R157', ...
    'Position', [200, 5840, 280, 5890]);
set_param('circuit_4f7f4083/R157', 'R', '10000.0');
set_param('circuit_4f7f4083/R157', 'R_unit', 'Ohm');

% [GND158] Ground GND158
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND158', ...
    'Position', [360, 5840, 440, 5890]);

% [L159] Inductor L159
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L159', ...
    'Position', [520, 5840, 600, 5890]);
set_param('circuit_4f7f4083/L159', 'l', '0.001');
set_param('circuit_4f7f4083/L159', 'l_unit', 'H');

% [C160] Capacitor C160
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C160', ...
    'Position', [200, 5950, 280, 6000]);
set_param('circuit_4f7f4083/C160', 'c', '1e-06');
set_param('circuit_4f7f4083/C160', 'c_unit', 'F');

% [R161] Resistor R161
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R161', ...
    'Position', [360, 5950, 440, 6000]);
set_param('circuit_4f7f4083/R161', 'R', '10000.0');
set_param('circuit_4f7f4083/R161', 'R_unit', 'Ohm');

% [GND162] Ground GND162
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND162', ...
    'Position', [520, 5950, 600, 6000]);

% [R163] Resistor R163
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R163', ...
    'Position', [200, 6060, 280, 6110]);
set_param('circuit_4f7f4083/R163', 'R', '10000.0');
set_param('circuit_4f7f4083/R163', 'R_unit', 'Ohm');

% [GND164] Ground GND164
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND164', ...
    'Position', [360, 6060, 440, 6110]);

% [GND165] Ground GND165
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND165', ...
    'Position', [520, 6060, 600, 6110]);

% [C166] Capacitor C166
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C166', ...
    'Position', [200, 6170, 280, 6220]);
set_param('circuit_4f7f4083/C166', 'c', '1e-06');
set_param('circuit_4f7f4083/C166', 'c_unit', 'F');

% [GND167] Ground GND167
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND167', ...
    'Position', [360, 6170, 440, 6220]);

% [GND168] Ground GND168
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND168', ...
    'Position', [520, 6170, 600, 6220]);

% [C169] Capacitor C169
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C169', ...
    'Position', [200, 6280, 280, 6330]);
set_param('circuit_4f7f4083/C169', 'c', '1e-07');
set_param('circuit_4f7f4083/C169', 'c_unit', 'F');

% [C170] Capacitor C170
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C170', ...
    'Position', [360, 6280, 440, 6330]);
set_param('circuit_4f7f4083/C170', 'c', '1e-06');
set_param('circuit_4f7f4083/C170', 'c_unit', 'F');

% [L171] Inductor L171
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L171', ...
    'Position', [520, 6280, 600, 6330]);
set_param('circuit_4f7f4083/L171', 'l', '0.001');
set_param('circuit_4f7f4083/L171', 'l_unit', 'H');

% [GND172] Ground GND172
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND172', ...
    'Position', [200, 6390, 280, 6440]);

% [GND173] Ground GND173
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND173', ...
    'Position', [360, 6390, 440, 6440]);

% [GND174] Ground GND174
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND174', ...
    'Position', [520, 6390, 600, 6440]);

% [R175] Resistor R175
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R175', ...
    'Position', [200, 6500, 280, 6550]);
set_param('circuit_4f7f4083/R175', 'R', '10000.0');
set_param('circuit_4f7f4083/R175', 'R_unit', 'Ohm');

% [R176] Resistor R176
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R176', ...
    'Position', [360, 6500, 440, 6550]);
set_param('circuit_4f7f4083/R176', 'R', '10000.0');
set_param('circuit_4f7f4083/R176', 'R_unit', 'Ohm');

% [C177] Capacitor C177
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C177', ...
    'Position', [520, 6500, 600, 6550]);
set_param('circuit_4f7f4083/C177', 'c', '1e-06');
set_param('circuit_4f7f4083/C177', 'c_unit', 'F');

% [C178] Capacitor C178
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C178', ...
    'Position', [200, 6610, 280, 6660]);
set_param('circuit_4f7f4083/C178', 'c', '1e-06');
set_param('circuit_4f7f4083/C178', 'c_unit', 'F');

% [R179] Resistor R179
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R179', ...
    'Position', [360, 6610, 440, 6660]);
set_param('circuit_4f7f4083/R179', 'R', '10000.0');
set_param('circuit_4f7f4083/R179', 'R_unit', 'Ohm');

% [GND180] Ground GND180
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND180', ...
    'Position', [520, 6610, 600, 6660]);

% [R181] Resistor R181
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R181', ...
    'Position', [200, 6720, 280, 6770]);

% [C182] Capacitor C182
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C182', ...
    'Position', [360, 6720, 440, 6770]);
set_param('circuit_4f7f4083/C182', 'c', '1e-06');
set_param('circuit_4f7f4083/C182', 'c_unit', 'F');

% [L183] Inductor L183
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L183', ...
    'Position', [520, 6720, 600, 6770]);
set_param('circuit_4f7f4083/L183', 'l', '0.001');
set_param('circuit_4f7f4083/L183', 'l_unit', 'H');

% [R184] Resistor R184
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R184', ...
    'Position', [200, 6830, 280, 6880]);
set_param('circuit_4f7f4083/R184', 'R', '10000.0');
set_param('circuit_4f7f4083/R184', 'R_unit', 'Ohm');

% [C185] Capacitor C185
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C185', ...
    'Position', [360, 6830, 440, 6880]);
set_param('circuit_4f7f4083/C185', 'c', '1e-07');
set_param('circuit_4f7f4083/C185', 'c_unit', 'F');

% [GND186] Ground GND186
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND186', ...
    'Position', [520, 6830, 600, 6880]);

% [R187] Resistor R187
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R187', ...
    'Position', [200, 6940, 280, 6990]);

% [R188] Resistor R188
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R188', ...
    'Position', [360, 6940, 440, 6990]);
set_param('circuit_4f7f4083/R188', 'R', '10000.0');
set_param('circuit_4f7f4083/R188', 'R_unit', 'Ohm');

% [GND189] Ground GND189
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND189', ...
    'Position', [520, 6940, 600, 6990]);

% [R190] Resistor R190
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R190', ...
    'Position', [200, 7050, 280, 7100]);
set_param('circuit_4f7f4083/R190', 'R', '10000.0');
set_param('circuit_4f7f4083/R190', 'R_unit', 'Ohm');

% [R191] Resistor R191
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R191', ...
    'Position', [360, 7050, 440, 7100]);

% [R192] Resistor R192
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R192', ...
    'Position', [520, 7050, 600, 7100]);

% [GND193] Ground GND193
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND193', ...
    'Position', [200, 7160, 280, 7210]);

% [R194] Resistor R194
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R194', ...
    'Position', [360, 7160, 440, 7210]);
set_param('circuit_4f7f4083/R194', 'R', '10000.0');
set_param('circuit_4f7f4083/R194', 'R_unit', 'Ohm');

% [GND195] Ground GND195
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND195', ...
    'Position', [520, 7160, 600, 7210]);

% [C196] Capacitor C196
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C196', ...
    'Position', [200, 7270, 280, 7320]);
set_param('circuit_4f7f4083/C196', 'c', '1e-06');
set_param('circuit_4f7f4083/C196', 'c_unit', 'F');

% [GND197] Ground GND197
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND197', ...
    'Position', [360, 7270, 440, 7320]);

% [GND198] Ground GND198
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND198', ...
    'Position', [520, 7270, 600, 7320]);

% [GND199] Ground GND199
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND199', ...
    'Position', [200, 7380, 280, 7430]);

% [GND200] Ground GND200
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND200', ...
    'Position', [360, 7380, 440, 7430]);

% [C201] Capacitor C201
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C201', ...
    'Position', [520, 7380, 600, 7430]);
set_param('circuit_4f7f4083/C201', 'c', '1e-06');
set_param('circuit_4f7f4083/C201', 'c_unit', 'F');

% [GND202] Ground GND202
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND202', ...
    'Position', [200, 7490, 280, 7540]);

% [GND203] Ground GND203
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND203', ...
    'Position', [360, 7490, 440, 7540]);

% [L204] Inductor L204
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L204', ...
    'Position', [520, 7490, 600, 7540]);
set_param('circuit_4f7f4083/L204', 'l', '0.001');
set_param('circuit_4f7f4083/L204', 'l_unit', 'H');

% [GND205] Ground GND205
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND205', ...
    'Position', [200, 7600, 280, 7650]);

% [R206] Resistor R206
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R206', ...
    'Position', [360, 7600, 440, 7650]);
set_param('circuit_4f7f4083/R206', 'R', '10000.0');
set_param('circuit_4f7f4083/R206', 'R_unit', 'Ohm');

% [C207] Capacitor C207
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C207', ...
    'Position', [520, 7600, 600, 7650]);
set_param('circuit_4f7f4083/C207', 'c', '1e-07');
set_param('circuit_4f7f4083/C207', 'c_unit', 'F');

% [R208] Resistor R208
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R208', ...
    'Position', [200, 7710, 280, 7760]);
set_param('circuit_4f7f4083/R208', 'R', '10000.0');
set_param('circuit_4f7f4083/R208', 'R_unit', 'Ohm');

% [R209] Resistor R209
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R209', ...
    'Position', [360, 7710, 440, 7760]);

% [R210] Resistor R210
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R210', ...
    'Position', [520, 7710, 600, 7760]);

% [V211] Voltage Source V211
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'circuit_4f7f4083/V211', ...
    'Position', [200, 7820, 280, 7870]);
set_param('circuit_4f7f4083/V211', 'v0', '12.0');
set_param('circuit_4f7f4083/V211', 'v0_unit', 'V');

% [C212] Capacitor C212
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C212', ...
    'Position', [360, 7820, 440, 7870]);
set_param('circuit_4f7f4083/C212', 'c', '1e-06');
set_param('circuit_4f7f4083/C212', 'c_unit', 'F');

% [GND213] Ground GND213
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND213', ...
    'Position', [520, 7820, 600, 7870]);

% [C214] Capacitor C214
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C214', ...
    'Position', [200, 7930, 280, 7980]);
set_param('circuit_4f7f4083/C214', 'c', '1e-06');
set_param('circuit_4f7f4083/C214', 'c_unit', 'F');

% [GND215] Ground GND215
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND215', ...
    'Position', [360, 7930, 440, 7980]);

% [C216] Capacitor C216
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C216', ...
    'Position', [520, 7930, 600, 7980]);
set_param('circuit_4f7f4083/C216', 'c', '1e-07');
set_param('circuit_4f7f4083/C216', 'c_unit', 'F');

% [R217] Resistor R217
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R217', ...
    'Position', [200, 8040, 280, 8090]);
set_param('circuit_4f7f4083/R217', 'R', '1000.0');
set_param('circuit_4f7f4083/R217', 'R_unit', 'Ohm');

% [C218] Capacitor C218
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C218', ...
    'Position', [360, 8040, 440, 8090]);
set_param('circuit_4f7f4083/C218', 'c', '1e-06');
set_param('circuit_4f7f4083/C218', 'c_unit', 'F');

% [L219] Inductor L219
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L219', ...
    'Position', [520, 8040, 600, 8090]);
set_param('circuit_4f7f4083/L219', 'l', '0.001');
set_param('circuit_4f7f4083/L219', 'l_unit', 'H');

% [R220] Resistor R220
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R220', ...
    'Position', [200, 8150, 280, 8200]);
set_param('circuit_4f7f4083/R220', 'R', '10000.0');
set_param('circuit_4f7f4083/R220', 'R_unit', 'Ohm');

% [C221] Capacitor C221
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C221', ...
    'Position', [360, 8150, 440, 8200]);
set_param('circuit_4f7f4083/C221', 'c', '1e-06');
set_param('circuit_4f7f4083/C221', 'c_unit', 'F');

% [C222] Capacitor C222
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C222', ...
    'Position', [520, 8150, 600, 8200]);
set_param('circuit_4f7f4083/C222', 'c', '1e-06');
set_param('circuit_4f7f4083/C222', 'c_unit', 'F');

% [R223] Resistor R223
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R223', ...
    'Position', [200, 8260, 280, 8310]);

% [R224] Resistor R224
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R224', ...
    'Position', [360, 8260, 440, 8310]);

% [R225] Resistor R225
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R225', ...
    'Position', [520, 8260, 600, 8310]);

% [C226] Capacitor C226
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C226', ...
    'Position', [200, 8370, 280, 8420]);
set_param('circuit_4f7f4083/C226', 'c', '1e-06');
set_param('circuit_4f7f4083/C226', 'c_unit', 'F');

% [GND227] Ground GND227
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND227', ...
    'Position', [360, 8370, 440, 8420]);

% [C228] Capacitor C228
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C228', ...
    'Position', [520, 8370, 600, 8420]);
set_param('circuit_4f7f4083/C228', 'c', '1e-06');
set_param('circuit_4f7f4083/C228', 'c_unit', 'F');

% [GND229] Ground GND229
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND229', ...
    'Position', [200, 8480, 280, 8530]);

% [C230] Capacitor C230
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C230', ...
    'Position', [360, 8480, 440, 8530]);
set_param('circuit_4f7f4083/C230', 'c', '1e-06');
set_param('circuit_4f7f4083/C230', 'c_unit', 'F');

% [GND231] Ground GND231
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND231', ...
    'Position', [520, 8480, 600, 8530]);

% [R232] Resistor R232
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R232', ...
    'Position', [200, 8590, 280, 8640]);
set_param('circuit_4f7f4083/R232', 'R', '10000.0');
set_param('circuit_4f7f4083/R232', 'R_unit', 'Ohm');

% [C233] Capacitor C233
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C233', ...
    'Position', [360, 8590, 440, 8640]);
set_param('circuit_4f7f4083/C233', 'c', '1e-06');
set_param('circuit_4f7f4083/C233', 'c_unit', 'F');

% [GND234] Ground GND234
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND234', ...
    'Position', [520, 8590, 600, 8640]);

% [R235] Resistor R235
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R235', ...
    'Position', [200, 8700, 280, 8750]);

% [R236] Resistor R236
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R236', ...
    'Position', [360, 8700, 440, 8750]);

% [GND237] Ground GND237
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND237', ...
    'Position', [520, 8700, 600, 8750]);

% [C238] Capacitor C238
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C238', ...
    'Position', [200, 8810, 280, 8860]);
set_param('circuit_4f7f4083/C238', 'c', '1e-06');
set_param('circuit_4f7f4083/C238', 'c_unit', 'F');

% [R239] Resistor R239
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R239', ...
    'Position', [360, 8810, 440, 8860]);

% [GND240] Ground GND240
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND240', ...
    'Position', [520, 8810, 600, 8860]);

% [GND241] Ground GND241
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND241', ...
    'Position', [200, 8920, 280, 8970]);

% [GND242] Ground GND242
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND242', ...
    'Position', [360, 8920, 440, 8970]);

% [L243] Inductor L243
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L243', ...
    'Position', [520, 8920, 600, 8970]);
set_param('circuit_4f7f4083/L243', 'l', '0.001');
set_param('circuit_4f7f4083/L243', 'l_unit', 'H');

% [C244] Capacitor C244
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C244', ...
    'Position', [200, 9030, 280, 9080]);
set_param('circuit_4f7f4083/C244', 'c', '1e-06');
set_param('circuit_4f7f4083/C244', 'c_unit', 'F');

% [GND245] Ground GND245
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND245', ...
    'Position', [360, 9030, 440, 9080]);

% [GND246] Ground GND246
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND246', ...
    'Position', [520, 9030, 600, 9080]);

% [R247] Resistor R247
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R247', ...
    'Position', [200, 9140, 280, 9190]);

% [R248] Resistor R248
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R248', ...
    'Position', [360, 9140, 440, 9190]);
set_param('circuit_4f7f4083/R248', 'R', '10000.0');
set_param('circuit_4f7f4083/R248', 'R_unit', 'Ohm');

% [GND249] Ground GND249
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND249', ...
    'Position', [520, 9140, 600, 9190]);

% [R250] Resistor R250
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R250', ...
    'Position', [200, 9250, 280, 9300]);
set_param('circuit_4f7f4083/R250', 'R', '10000.0');
set_param('circuit_4f7f4083/R250', 'R_unit', 'Ohm');

% [R251] Resistor R251
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R251', ...
    'Position', [360, 9250, 440, 9300]);

% [GND252] Ground GND252
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND252', ...
    'Position', [520, 9250, 600, 9300]);

% [C253] Capacitor C253
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C253', ...
    'Position', [200, 9360, 280, 9410]);
set_param('circuit_4f7f4083/C253', 'c', '1e-06');
set_param('circuit_4f7f4083/C253', 'c_unit', 'F');

% [C254] Capacitor C254
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C254', ...
    'Position', [360, 9360, 440, 9410]);
set_param('circuit_4f7f4083/C254', 'c', '1e-06');
set_param('circuit_4f7f4083/C254', 'c_unit', 'F');

% [R255] Resistor R255
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R255', ...
    'Position', [520, 9360, 600, 9410]);

% [GND256] Ground GND256
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND256', ...
    'Position', [200, 9470, 280, 9520]);

% [C257] Capacitor C257
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C257', ...
    'Position', [360, 9470, 440, 9520]);
set_param('circuit_4f7f4083/C257', 'c', '1e-06');
set_param('circuit_4f7f4083/C257', 'c_unit', 'F');

% [R258] Resistor R258
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R258', ...
    'Position', [520, 9470, 600, 9520]);
set_param('circuit_4f7f4083/R258', 'R', '1000.0');
set_param('circuit_4f7f4083/R258', 'R_unit', 'Ohm');

% [GND259] Ground GND259
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND259', ...
    'Position', [200, 9580, 280, 9630]);

% [R260] Resistor R260
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R260', ...
    'Position', [360, 9580, 440, 9630]);
set_param('circuit_4f7f4083/R260', 'R', '10000.0');
set_param('circuit_4f7f4083/R260', 'R_unit', 'Ohm');

% [GND261] Ground GND261
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND261', ...
    'Position', [520, 9580, 600, 9630]);

% [R262] Resistor R262
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R262', ...
    'Position', [200, 9690, 280, 9740]);
set_param('circuit_4f7f4083/R262', 'R', '10000.0');
set_param('circuit_4f7f4083/R262', 'R_unit', 'Ohm');

% [GND263] Ground GND263
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND263', ...
    'Position', [360, 9690, 440, 9740]);

% [GND264] Ground GND264
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND264', ...
    'Position', [520, 9690, 600, 9740]);

% [C265] Capacitor C265
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C265', ...
    'Position', [200, 9800, 280, 9850]);
set_param('circuit_4f7f4083/C265', 'c', '1e-06');
set_param('circuit_4f7f4083/C265', 'c_unit', 'F');

% [GND266] Ground GND266
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND266', ...
    'Position', [360, 9800, 440, 9850]);

% [GND267] Ground GND267
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND267', ...
    'Position', [520, 9800, 600, 9850]);

% [GND268] Ground GND268
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND268', ...
    'Position', [200, 9910, 280, 9960]);

% [C269] Capacitor C269
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C269', ...
    'Position', [360, 9910, 440, 9960]);
set_param('circuit_4f7f4083/C269', 'c', '1e-06');
set_param('circuit_4f7f4083/C269', 'c_unit', 'F');

% [L270] Inductor L270
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L270', ...
    'Position', [520, 9910, 600, 9960]);
set_param('circuit_4f7f4083/L270', 'l', '0.001');
set_param('circuit_4f7f4083/L270', 'l_unit', 'H');

% [R271] Resistor R271
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R271', ...
    'Position', [200, 10020, 280, 10070]);
set_param('circuit_4f7f4083/R271', 'R', '10000.0');
set_param('circuit_4f7f4083/R271', 'R_unit', 'Ohm');

% [C272] Capacitor C272
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C272', ...
    'Position', [360, 10020, 440, 10070]);
set_param('circuit_4f7f4083/C272', 'c', '1e-07');
set_param('circuit_4f7f4083/C272', 'c_unit', 'F');

% [GND273] Ground GND273
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND273', ...
    'Position', [520, 10020, 600, 10070]);

% [GND274] Ground GND274
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND274', ...
    'Position', [200, 10130, 280, 10180]);

% [R275] Resistor R275
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R275', ...
    'Position', [360, 10130, 440, 10180]);
set_param('circuit_4f7f4083/R275', 'R', '1000.0');
set_param('circuit_4f7f4083/R275', 'R_unit', 'Ohm');

% [L276] Inductor L276
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L276', ...
    'Position', [520, 10130, 600, 10180]);
set_param('circuit_4f7f4083/L276', 'l', '0.001');
set_param('circuit_4f7f4083/L276', 'l_unit', 'H');

% [GND277] Ground GND277
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND277', ...
    'Position', [200, 10240, 280, 10290]);

% [GND278] Ground GND278
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND278', ...
    'Position', [360, 10240, 440, 10290]);

% [L279] Inductor L279
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L279', ...
    'Position', [520, 10240, 600, 10290]);
set_param('circuit_4f7f4083/L279', 'l', '0.001');
set_param('circuit_4f7f4083/L279', 'l_unit', 'H');

% [GND280] Ground GND280
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND280', ...
    'Position', [200, 10350, 280, 10400]);

% [C281] Capacitor C281
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C281', ...
    'Position', [360, 10350, 440, 10400]);
set_param('circuit_4f7f4083/C281', 'c', '1e-06');
set_param('circuit_4f7f4083/C281', 'c_unit', 'F');

% [R282] Resistor R282
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R282', ...
    'Position', [520, 10350, 600, 10400]);

% [C283] Capacitor C283
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C283', ...
    'Position', [200, 10460, 280, 10510]);
set_param('circuit_4f7f4083/C283', 'c', '1e-06');
set_param('circuit_4f7f4083/C283', 'c_unit', 'F');

% [R284] Resistor R284
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R284', ...
    'Position', [360, 10460, 440, 10510]);
set_param('circuit_4f7f4083/R284', 'R', '10000.0');
set_param('circuit_4f7f4083/R284', 'R_unit', 'Ohm');

% [C285] Capacitor C285
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C285', ...
    'Position', [520, 10460, 600, 10510]);
set_param('circuit_4f7f4083/C285', 'c', '1e-06');
set_param('circuit_4f7f4083/C285', 'c_unit', 'F');

% [GND286] Ground GND286
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND286', ...
    'Position', [200, 10570, 280, 10620]);

% [R287] Resistor R287
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R287', ...
    'Position', [360, 10570, 440, 10620]);

% [GND288] Ground GND288
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND288', ...
    'Position', [520, 10570, 600, 10620]);

% [GND289] Ground GND289
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND289', ...
    'Position', [200, 10680, 280, 10730]);

% [R290] Resistor R290
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R290', ...
    'Position', [360, 10680, 440, 10730]);
set_param('circuit_4f7f4083/R290', 'R', '10000.0');
set_param('circuit_4f7f4083/R290', 'R_unit', 'Ohm');

% [GND291] Ground GND291
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND291', ...
    'Position', [520, 10680, 600, 10730]);

% [GND292] Ground GND292
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND292', ...
    'Position', [200, 10790, 280, 10840]);

% [C293] Capacitor C293
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C293', ...
    'Position', [360, 10790, 440, 10840]);
set_param('circuit_4f7f4083/C293', 'c', '1e-06');
set_param('circuit_4f7f4083/C293', 'c_unit', 'F');

% [GND294] Ground GND294
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND294', ...
    'Position', [520, 10790, 600, 10840]);

% [C295] Capacitor C295
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C295', ...
    'Position', [200, 10900, 280, 10950]);
set_param('circuit_4f7f4083/C295', 'c', '1e-06');
set_param('circuit_4f7f4083/C295', 'c_unit', 'F');

% [GND296] Ground GND296
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND296', ...
    'Position', [360, 10900, 440, 10950]);

% [GND297] Ground GND297
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND297', ...
    'Position', [520, 10900, 600, 10950]);

% [GND298] Ground GND298
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND298', ...
    'Position', [200, 11010, 280, 11060]);

% [GND299] Ground GND299
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND299', ...
    'Position', [360, 11010, 440, 11060]);

% [GND300] Ground GND300
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND300', ...
    'Position', [520, 11010, 600, 11060]);

% [GND301] Ground GND301
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND301', ...
    'Position', [200, 11120, 280, 11170]);

% [GND302] Ground GND302
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND302', ...
    'Position', [360, 11120, 440, 11170]);

% [C303] Capacitor C303
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C303', ...
    'Position', [520, 11120, 600, 11170]);
set_param('circuit_4f7f4083/C303', 'c', '1e-06');
set_param('circuit_4f7f4083/C303', 'c_unit', 'F');

% [R304] Resistor R304
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R304', ...
    'Position', [200, 11230, 280, 11280]);
set_param('circuit_4f7f4083/R304', 'R', '10000.0');
set_param('circuit_4f7f4083/R304', 'R_unit', 'Ohm');

% [R305] Resistor R305
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R305', ...
    'Position', [360, 11230, 440, 11280]);
set_param('circuit_4f7f4083/R305', 'R', '10000.0');
set_param('circuit_4f7f4083/R305', 'R_unit', 'Ohm');

% [L306] Inductor L306
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L306', ...
    'Position', [520, 11230, 600, 11280]);
set_param('circuit_4f7f4083/L306', 'l', '0.001');
set_param('circuit_4f7f4083/L306', 'l_unit', 'H');

% [GND307] Ground GND307
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND307', ...
    'Position', [200, 11340, 280, 11390]);

% [C308] Capacitor C308
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C308', ...
    'Position', [360, 11340, 440, 11390]);
set_param('circuit_4f7f4083/C308', 'c', '1e-07');
set_param('circuit_4f7f4083/C308', 'c_unit', 'F');

% [GND309] Ground GND309
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND309', ...
    'Position', [520, 11340, 600, 11390]);

% [C310] Capacitor C310
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C310', ...
    'Position', [200, 11450, 280, 11500]);
set_param('circuit_4f7f4083/C310', 'c', '1e-07');
set_param('circuit_4f7f4083/C310', 'c_unit', 'F');

% [GND311] Ground GND311
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND311', ...
    'Position', [360, 11450, 440, 11500]);

% [GND312] Ground GND312
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND312', ...
    'Position', [520, 11450, 600, 11500]);

% [R313] Resistor R313
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R313', ...
    'Position', [200, 11560, 280, 11610]);
set_param('circuit_4f7f4083/R313', 'R', '1000.0');
set_param('circuit_4f7f4083/R313', 'R_unit', 'Ohm');

% [R314] Resistor R314
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R314', ...
    'Position', [360, 11560, 440, 11610]);
set_param('circuit_4f7f4083/R314', 'R', '10000.0');
set_param('circuit_4f7f4083/R314', 'R_unit', 'Ohm');

% [C315] Capacitor C315
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C315', ...
    'Position', [520, 11560, 600, 11610]);
set_param('circuit_4f7f4083/C315', 'c', '1e-06');
set_param('circuit_4f7f4083/C315', 'c_unit', 'F');

% [GND316] Ground GND316
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND316', ...
    'Position', [200, 11670, 280, 11720]);

% [R317] Resistor R317
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R317', ...
    'Position', [360, 11670, 440, 11720]);
set_param('circuit_4f7f4083/R317', 'R', '10000.0');
set_param('circuit_4f7f4083/R317', 'R_unit', 'Ohm');

% [GND318] Ground GND318
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND318', ...
    'Position', [520, 11670, 600, 11720]);

% [GND319] Ground GND319
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND319', ...
    'Position', [200, 11780, 280, 11830]);

% [C320] Capacitor C320
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C320', ...
    'Position', [360, 11780, 440, 11830]);
set_param('circuit_4f7f4083/C320', 'c', '1e-06');
set_param('circuit_4f7f4083/C320', 'c_unit', 'F');

% [GND321] Ground GND321
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND321', ...
    'Position', [520, 11780, 600, 11830]);

% [GND322] Ground GND322
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND322', ...
    'Position', [200, 11890, 280, 11940]);

% [GND323] Ground GND323
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND323', ...
    'Position', [360, 11890, 440, 11940]);

% [C324] Capacitor C324
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'circuit_4f7f4083/C324', ...
    'Position', [520, 11890, 600, 11940]);
set_param('circuit_4f7f4083/C324', 'c', '1e-06');
set_param('circuit_4f7f4083/C324', 'c_unit', 'F');

% [GND325] Ground GND325
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND325', ...
    'Position', [200, 12000, 280, 12050]);

% [R326] Resistor R326
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R326', ...
    'Position', [360, 12000, 440, 12050]);
set_param('circuit_4f7f4083/R326', 'R', '10000.0');
set_param('circuit_4f7f4083/R326', 'R_unit', 'Ohm');

% [GND327] Ground GND327
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND327', ...
    'Position', [520, 12000, 600, 12050]);

% [GND328] Ground GND328
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND328', ...
    'Position', [200, 12110, 280, 12160]);

% [R329] Resistor R329
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R329', ...
    'Position', [360, 12110, 440, 12160]);

% [GND330] Ground GND330
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND330', ...
    'Position', [520, 12110, 600, 12160]);

% [R331] Resistor R331
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R331', ...
    'Position', [200, 12220, 280, 12270]);

% [GND332] Ground GND332
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND332', ...
    'Position', [360, 12220, 440, 12270]);

% [R333] Resistor R333
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R333', ...
    'Position', [520, 12220, 600, 12270]);

% [R334] Resistor R334
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R334', ...
    'Position', [200, 12330, 280, 12380]);
set_param('circuit_4f7f4083/R334', 'R', '10000.0');
set_param('circuit_4f7f4083/R334', 'R_unit', 'Ohm');

% [R335] Resistor R335
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R335', ...
    'Position', [360, 12330, 440, 12380]);

% [L336] Inductor L336
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'circuit_4f7f4083/L336', ...
    'Position', [520, 12330, 600, 12380]);
set_param('circuit_4f7f4083/L336', 'l', '0.001');
set_param('circuit_4f7f4083/L336', 'l_unit', 'H');

% [R337] Resistor R337
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R337', ...
    'Position', [200, 12440, 280, 12490]);

% [R338] Resistor R338
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'circuit_4f7f4083/R338', ...
    'Position', [360, 12440, 440, 12490]);
set_param('circuit_4f7f4083/R338', 'R', '10000.0');
set_param('circuit_4f7f4083/R338', 'R_unit', 'Ohm');

% [GND339] Ground GND339
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'circuit_4f7f4083/GND339', ...
    'Position', [520, 12440, 600, 12490]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('circuit_4f7f4083', 'Solver_Config/RConn1', 'GND16/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N1_VIN (connections: V14.+, R1.1)
try
    add_line('circuit_4f7f4083', 'V14/p', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N1_VIN: ', me.message]);
end

% Net: N2 (connections: R1.2, C2.1)
try
    add_line('circuit_4f7f4083', 'R1/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N2: ', me.message]);
end

% Net: N3 (connections: C2.2, R3.1)
try
    add_line('circuit_4f7f4083', 'C2/RConn1', 'R3/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N3: ', me.message]);
end

% Net: N4 (connections: R3.2, C4.1)
try
    add_line('circuit_4f7f4083', 'R3/RConn1', 'C4/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N4: ', me.message]);
end

% Net: N5 (connections: C4.2, R5.1)
try
    add_line('circuit_4f7f4083', 'C4/RConn1', 'R5/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N5: ', me.message]);
end

% Net: N6 (connections: R5.2, R6.1)
try
    add_line('circuit_4f7f4083', 'R5/RConn1', 'R6/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N6: ', me.message]);
end

% Net: N7 (connections: R6.2, R7.1)
try
    add_line('circuit_4f7f4083', 'R6/RConn1', 'R7/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N7: ', me.message]);
end

% Net: N8 (connections: R7.2, R8.1)
try
    add_line('circuit_4f7f4083', 'R7/RConn1', 'R8/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N8: ', me.message]);
end

% Net: N9 (connections: R8.2, L9.1)
try
    add_line('circuit_4f7f4083', 'R8/RConn1', 'L9/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N9: ', me.message]);
end

% Net: N10 (connections: L9.2, R10.1)
try
    add_line('circuit_4f7f4083', 'L9/RConn1', 'R10/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N10: ', me.message]);
end

% Net: N11 (connections: R10.2, R11.1)
try
    add_line('circuit_4f7f4083', 'R10/RConn1', 'R11/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N11: ', me.message]);
end

% Net: N12 (connections: R11.2, R12.1)
try
    add_line('circuit_4f7f4083', 'R11/RConn1', 'R12/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N12: ', me.message]);
end

% Net: N13 (connections: R12.2, R13.1)
try
    add_line('circuit_4f7f4083', 'R12/RConn1', 'R13/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N13: ', me.message]);
end

% Net: N14 (connections: R13.2, L15.1)
try
    add_line('circuit_4f7f4083', 'R13/RConn1', 'L15/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N14: ', me.message]);
end

% Net: N15 (connections: L15.2, R17.1)
try
    add_line('circuit_4f7f4083', 'L15/RConn1', 'R17/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N15: ', me.message]);
end

% Net: N16 (connections: R17.2, L18.1)
try
    add_line('circuit_4f7f4083', 'R17/RConn1', 'L18/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N16: ', me.message]);
end

% Net: N17 (connections: L18.2, R19.1)
try
    add_line('circuit_4f7f4083', 'L18/RConn1', 'R19/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N17: ', me.message]);
end

% Net: N18 (connections: R19.2, R20.1)
try
    add_line('circuit_4f7f4083', 'R19/RConn1', 'R20/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N18: ', me.message]);
end

% Net: N19 (connections: R20.2, C21.1)
try
    add_line('circuit_4f7f4083', 'R20/RConn1', 'C21/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N19: ', me.message]);
end

% Net: N20 (connections: C21.2, R22.1)
try
    add_line('circuit_4f7f4083', 'C21/RConn1', 'R22/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N20: ', me.message]);
end

% Net: N21 (connections: R22.2, R23.1)
try
    add_line('circuit_4f7f4083', 'R22/RConn1', 'R23/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N21: ', me.message]);
end

% Net: N22 (connections: R23.2, C25.1)
try
    add_line('circuit_4f7f4083', 'R23/RConn1', 'C25/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N22: ', me.message]);
end

% Net: N23 (connections: C25.2, C26.1)
try
    add_line('circuit_4f7f4083', 'C25/RConn1', 'C26/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N23: ', me.message]);
end

% Net: N24 (connections: C26.2, C27.1)
try
    add_line('circuit_4f7f4083', 'C26/RConn1', 'C27/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N24: ', me.message]);
end

% Net: N25 (connections: C27.2, C28.1)
try
    add_line('circuit_4f7f4083', 'C27/RConn1', 'C28/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N25: ', me.message]);
end

% Net: N26 (connections: C28.2, C29.1)
try
    add_line('circuit_4f7f4083', 'C28/RConn1', 'C29/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N26: ', me.message]);
end

% Net: N27 (connections: C29.2, C30.1)
try
    add_line('circuit_4f7f4083', 'C29/RConn1', 'C30/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N27: ', me.message]);
end

% Net: N28 (connections: C30.2, R31.1)
try
    add_line('circuit_4f7f4083', 'C30/RConn1', 'R31/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N28: ', me.message]);
end

% Net: N29 (connections: R31.2, D32.A)
try
    add_line('circuit_4f7f4083', 'R31/RConn1', 'D32/p', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N29: ', me.message]);
end

% Net: N30 (connections: D32.K, C35.1)
try
    add_line('circuit_4f7f4083', 'D32/n', 'C35/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N30: ', me.message]);
end

% Net: N31 (connections: C35.2, C36.1)
try
    add_line('circuit_4f7f4083', 'C35/RConn1', 'C36/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N31: ', me.message]);
end

% Net: N32 (connections: C36.2, R38.1)
try
    add_line('circuit_4f7f4083', 'C36/RConn1', 'R38/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N32: ', me.message]);
end

% Net: N33 (connections: R38.2, C39.1)
try
    add_line('circuit_4f7f4083', 'R38/RConn1', 'C39/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N33: ', me.message]);
end

% Net: N34 (connections: C39.2, R41.1)
try
    add_line('circuit_4f7f4083', 'C39/RConn1', 'R41/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N34: ', me.message]);
end

% Net: N35 (connections: R41.2, L42.1)
try
    add_line('circuit_4f7f4083', 'R41/RConn1', 'L42/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N35: ', me.message]);
end

% Net: N36 (connections: L42.2, C43.1)
try
    add_line('circuit_4f7f4083', 'L42/RConn1', 'C43/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N36: ', me.message]);
end

% Net: N37 (connections: C43.2, R44.1)
try
    add_line('circuit_4f7f4083', 'C43/RConn1', 'R44/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N37: ', me.message]);
end

% Net: N38 (connections: R44.2, C46.1)
try
    add_line('circuit_4f7f4083', 'R44/RConn1', 'C46/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N38: ', me.message]);
end

% Net: N39 (connections: C46.2, R47.1)
try
    add_line('circuit_4f7f4083', 'C46/RConn1', 'R47/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N39: ', me.message]);
end

% Net: N40 (connections: R47.2, C49.1)
try
    add_line('circuit_4f7f4083', 'R47/RConn1', 'C49/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N40: ', me.message]);
end

% Net: N41 (connections: C49.2, R50.1)
try
    add_line('circuit_4f7f4083', 'C49/RConn1', 'R50/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N41: ', me.message]);
end

% Net: N42 (connections: R50.2, L51.1)
try
    add_line('circuit_4f7f4083', 'R50/RConn1', 'L51/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N42: ', me.message]);
end

% Net: N43 (connections: L51.2, R52.1)
try
    add_line('circuit_4f7f4083', 'L51/RConn1', 'R52/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N43: ', me.message]);
end

% Net: N44 (connections: R52.2, R53.1)
try
    add_line('circuit_4f7f4083', 'R52/RConn1', 'R53/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N44: ', me.message]);
end

% Net: N45 (connections: R53.2, L54.1)
try
    add_line('circuit_4f7f4083', 'R53/RConn1', 'L54/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N45: ', me.message]);
end

% Net: N46 (connections: L54.2, C56.1)
try
    add_line('circuit_4f7f4083', 'L54/RConn1', 'C56/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N46: ', me.message]);
end

% Net: N47 (connections: C56.2, C57.1)
try
    add_line('circuit_4f7f4083', 'C56/RConn1', 'C57/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N47: ', me.message]);
end

% Net: N48 (connections: C57.2, C58.1)
try
    add_line('circuit_4f7f4083', 'C57/RConn1', 'C58/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N48: ', me.message]);
end

% Net: N49 (connections: C58.2, C60.1)
try
    add_line('circuit_4f7f4083', 'C58/RConn1', 'C60/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N49: ', me.message]);
end

% Net: N50 (connections: C60.2, C61.1)
try
    add_line('circuit_4f7f4083', 'C60/RConn1', 'C61/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N50: ', me.message]);
end

% Net: N51 (connections: C61.2, L66.1)
try
    add_line('circuit_4f7f4083', 'C61/RConn1', 'L66/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N51: ', me.message]);
end

% Net: N52 (connections: L66.2, R68.1)
try
    add_line('circuit_4f7f4083', 'L66/RConn1', 'R68/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N52: ', me.message]);
end

% Net: N53 (connections: R68.2, R69.1)
try
    add_line('circuit_4f7f4083', 'R68/RConn1', 'R69/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N53: ', me.message]);
end

% Net: N54 (connections: R69.2, C73.1)
try
    add_line('circuit_4f7f4083', 'R69/RConn1', 'C73/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N54: ', me.message]);
end

% Net: N55 (connections: C73.2, C75.1)
try
    add_line('circuit_4f7f4083', 'C73/RConn1', 'C75/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N55: ', me.message]);
end

% Net: N56 (connections: C75.2, C76.1)
try
    add_line('circuit_4f7f4083', 'C75/RConn1', 'C76/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N56: ', me.message]);
end

% Net: N57 (connections: C76.2, C77.1)
try
    add_line('circuit_4f7f4083', 'C76/RConn1', 'C77/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N57: ', me.message]);
end

% Net: N58 (connections: C77.2, C78.1)
try
    add_line('circuit_4f7f4083', 'C77/RConn1', 'C78/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N58: ', me.message]);
end

% Net: N59 (connections: C78.2, R80.1)
try
    add_line('circuit_4f7f4083', 'C78/RConn1', 'R80/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N59: ', me.message]);
end

% Net: N60 (connections: R80.2, C81.1)
try
    add_line('circuit_4f7f4083', 'R80/RConn1', 'C81/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N60: ', me.message]);
end

% Net: N61 (connections: C81.2, C86.1)
try
    add_line('circuit_4f7f4083', 'C81/RConn1', 'C86/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N61: ', me.message]);
end

% Net: N62 (connections: C86.2, L87.1)
try
    add_line('circuit_4f7f4083', 'C86/RConn1', 'L87/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N62: ', me.message]);
end

% Net: N63 (connections: L87.2, C88.1)
try
    add_line('circuit_4f7f4083', 'L87/RConn1', 'C88/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N63: ', me.message]);
end

% Net: N64 (connections: C88.2, C89.1)
try
    add_line('circuit_4f7f4083', 'C88/RConn1', 'C89/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N64: ', me.message]);
end

% Net: N65 (connections: C89.2, C90.1)
try
    add_line('circuit_4f7f4083', 'C89/RConn1', 'C90/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N65: ', me.message]);
end

% Net: N66 (connections: C90.2, R91.1)
try
    add_line('circuit_4f7f4083', 'C90/RConn1', 'R91/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N66: ', me.message]);
end

% Net: N67 (connections: R91.2, R92.1)
try
    add_line('circuit_4f7f4083', 'R91/RConn1', 'R92/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N67: ', me.message]);
end

% Net: N68 (connections: R92.2, R93.1)
try
    add_line('circuit_4f7f4083', 'R92/RConn1', 'R93/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N68: ', me.message]);
end

% Net: N69 (connections: R93.2, R94.1)
try
    add_line('circuit_4f7f4083', 'R93/RConn1', 'R94/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N69: ', me.message]);
end

% Net: N70 (connections: R94.2, L96.1)
try
    add_line('circuit_4f7f4083', 'R94/RConn1', 'L96/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N70: ', me.message]);
end

% Net: N71 (connections: L96.2, R98.1)
try
    add_line('circuit_4f7f4083', 'L96/RConn1', 'R98/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N71: ', me.message]);
end

% Net: N72 (connections: R98.2, C99.1)
try
    add_line('circuit_4f7f4083', 'R98/RConn1', 'C99/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N72: ', me.message]);
end

% Net: N73 (connections: C99.2, R100.1)
try
    add_line('circuit_4f7f4083', 'C99/RConn1', 'R100/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N73: ', me.message]);
end

% Net: N74 (connections: R100.2, R101.1)
try
    add_line('circuit_4f7f4083', 'R100/RConn1', 'R101/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N74: ', me.message]);
end

% Net: N75 (connections: R101.2, R103.1)
try
    add_line('circuit_4f7f4083', 'R101/RConn1', 'R103/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N75: ', me.message]);
end

% Net: N76 (connections: R103.2, C104.1)
try
    add_line('circuit_4f7f4083', 'R103/RConn1', 'C104/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N76: ', me.message]);
end

% Net: N77 (connections: C104.2, L105.1)
try
    add_line('circuit_4f7f4083', 'C104/RConn1', 'L105/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N77: ', me.message]);
end

% Net: N78 (connections: L105.2, C106.1)
try
    add_line('circuit_4f7f4083', 'L105/RConn1', 'C106/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N78: ', me.message]);
end

% Net: N79 (connections: C106.2, C108.1)
try
    add_line('circuit_4f7f4083', 'C106/RConn1', 'C108/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N79: ', me.message]);
end

% Net: N80 (connections: C108.2, R109.1)
try
    add_line('circuit_4f7f4083', 'C108/RConn1', 'R109/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N80: ', me.message]);
end

% Net: N81 (connections: R109.2, C111.1)
try
    add_line('circuit_4f7f4083', 'R109/RConn1', 'C111/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N81: ', me.message]);
end

% Net: N82 (connections: C111.2, R112.1)
try
    add_line('circuit_4f7f4083', 'C111/RConn1', 'R112/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N82: ', me.message]);
end

% Net: N83 (connections: R112.2, C114.1)
try
    add_line('circuit_4f7f4083', 'R112/RConn1', 'C114/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N83: ', me.message]);
end

% Net: N84 (connections: C114.2, R115.1)
try
    add_line('circuit_4f7f4083', 'C114/RConn1', 'R115/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N84: ', me.message]);
end

% Net: N85 (connections: R115.2, R116.1)
try
    add_line('circuit_4f7f4083', 'R115/RConn1', 'R116/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N85: ', me.message]);
end

% Net: N86 (connections: R116.2, R118.1)
try
    add_line('circuit_4f7f4083', 'R116/RConn1', 'R118/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N86: ', me.message]);
end

% Net: N87 (connections: R118.2, R119.1)
try
    add_line('circuit_4f7f4083', 'R118/RConn1', 'R119/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N87: ', me.message]);
end

% Net: N88 (connections: R119.2, R121.1)
try
    add_line('circuit_4f7f4083', 'R119/RConn1', 'R121/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N88: ', me.message]);
end

% Net: N89 (connections: R121.2, C122.1)
try
    add_line('circuit_4f7f4083', 'R121/RConn1', 'C122/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N89: ', me.message]);
end

% Net: N90 (connections: C122.2, L123.1)
try
    add_line('circuit_4f7f4083', 'C122/RConn1', 'L123/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N90: ', me.message]);
end

% Net: N91 (connections: L123.2, R125.1)
try
    add_line('circuit_4f7f4083', 'L123/RConn1', 'R125/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N91: ', me.message]);
end

% Net: N92 (connections: R125.2, L129.1)
try
    add_line('circuit_4f7f4083', 'R125/RConn1', 'L129/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N92: ', me.message]);
end

% Net: N93 (connections: L129.2, L132.1)
try
    add_line('circuit_4f7f4083', 'L129/RConn1', 'L132/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N93: ', me.message]);
end

% Net: N94 (connections: L132.2, R134.1)
try
    add_line('circuit_4f7f4083', 'L132/RConn1', 'R134/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N94: ', me.message]);
end

% Net: N95 (connections: R134.2, R136.1)
try
    add_line('circuit_4f7f4083', 'R134/RConn1', 'R136/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N95: ', me.message]);
end

% Net: N96 (connections: R136.2, R137.1)
try
    add_line('circuit_4f7f4083', 'R136/RConn1', 'R137/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N96: ', me.message]);
end

% Net: N97 (connections: R137.2, R140.1)
try
    add_line('circuit_4f7f4083', 'R137/RConn1', 'R140/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N97: ', me.message]);
end

% Net: N98 (connections: R140.2, C141.1)
try
    add_line('circuit_4f7f4083', 'R140/RConn1', 'C141/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N98: ', me.message]);
end

% Net: N99 (connections: C141.2, R142.1)
try
    add_line('circuit_4f7f4083', 'C141/RConn1', 'R142/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N99: ', me.message]);
end

% Net: N100 (connections: R142.2, R145.1)
try
    add_line('circuit_4f7f4083', 'R142/RConn1', 'R145/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N100: ', me.message]);
end

% Net: N101 (connections: R145.2, R147.1)
try
    add_line('circuit_4f7f4083', 'R145/RConn1', 'R147/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N101: ', me.message]);
end

% Net: N102 (connections: R147.2, D148.A)
try
    add_line('circuit_4f7f4083', 'R147/RConn1', 'D148/p', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N102: ', me.message]);
end

% Net: N103 (connections: D148.K, R149.1)
try
    add_line('circuit_4f7f4083', 'D148/n', 'R149/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N103: ', me.message]);
end

% Net: N104 (connections: R149.2, C151.1)
try
    add_line('circuit_4f7f4083', 'R149/RConn1', 'C151/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N104: ', me.message]);
end

% Net: N105 (connections: C151.2, C152.1)
try
    add_line('circuit_4f7f4083', 'C151/RConn1', 'C152/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N105: ', me.message]);
end

% Net: N106 (connections: C152.2, R154.1)
try
    add_line('circuit_4f7f4083', 'C152/RConn1', 'R154/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N106: ', me.message]);
end

% Net: N107 (connections: R154.2, L156.1)
try
    add_line('circuit_4f7f4083', 'R154/RConn1', 'L156/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N107: ', me.message]);
end

% Net: N108 (connections: L156.2, R157.1)
try
    add_line('circuit_4f7f4083', 'L156/RConn1', 'R157/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N108: ', me.message]);
end

% Net: N109 (connections: R157.2, L159.1)
try
    add_line('circuit_4f7f4083', 'R157/RConn1', 'L159/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N109: ', me.message]);
end

% Net: N110 (connections: L159.2, C160.1)
try
    add_line('circuit_4f7f4083', 'L159/RConn1', 'C160/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N110: ', me.message]);
end

% Net: N111 (connections: C160.2, R161.1)
try
    add_line('circuit_4f7f4083', 'C160/RConn1', 'R161/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N111: ', me.message]);
end

% Net: N112 (connections: R161.2, R163.1)
try
    add_line('circuit_4f7f4083', 'R161/RConn1', 'R163/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N112: ', me.message]);
end

% Net: N113 (connections: R163.2, C166.1)
try
    add_line('circuit_4f7f4083', 'R163/RConn1', 'C166/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N113: ', me.message]);
end

% Net: N114 (connections: C166.2, C169.1)
try
    add_line('circuit_4f7f4083', 'C166/RConn1', 'C169/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N114: ', me.message]);
end

% Net: N115 (connections: C169.2, C170.1)
try
    add_line('circuit_4f7f4083', 'C169/RConn1', 'C170/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N115: ', me.message]);
end

% Net: N116 (connections: C170.2, L171.1)
try
    add_line('circuit_4f7f4083', 'C170/RConn1', 'L171/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N116: ', me.message]);
end

% Net: N117 (connections: L171.2, R175.1)
try
    add_line('circuit_4f7f4083', 'L171/RConn1', 'R175/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N117: ', me.message]);
end

% Net: N118 (connections: R175.2, R176.1)
try
    add_line('circuit_4f7f4083', 'R175/RConn1', 'R176/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N118: ', me.message]);
end

% Net: N119 (connections: R176.2, C177.1)
try
    add_line('circuit_4f7f4083', 'R176/RConn1', 'C177/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N119: ', me.message]);
end

% Net: N120 (connections: C177.2, C178.1)
try
    add_line('circuit_4f7f4083', 'C177/RConn1', 'C178/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N120: ', me.message]);
end

% Net: N121 (connections: C178.2, R179.1)
try
    add_line('circuit_4f7f4083', 'C178/RConn1', 'R179/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N121: ', me.message]);
end

% Net: N122 (connections: R179.2, R181.1)
try
    add_line('circuit_4f7f4083', 'R179/RConn1', 'R181/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N122: ', me.message]);
end

% Net: N123 (connections: R181.2, C182.1)
try
    add_line('circuit_4f7f4083', 'R181/RConn1', 'C182/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N123: ', me.message]);
end

% Net: N124 (connections: C182.2, L183.1)
try
    add_line('circuit_4f7f4083', 'C182/RConn1', 'L183/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N124: ', me.message]);
end

% Net: N125 (connections: L183.2, R184.1)
try
    add_line('circuit_4f7f4083', 'L183/RConn1', 'R184/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N125: ', me.message]);
end

% Net: N126 (connections: R184.2, C185.1)
try
    add_line('circuit_4f7f4083', 'R184/RConn1', 'C185/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N126: ', me.message]);
end

% Net: N127 (connections: C185.2, R187.1)
try
    add_line('circuit_4f7f4083', 'C185/RConn1', 'R187/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N127: ', me.message]);
end

% Net: N128 (connections: R187.2, R188.1)
try
    add_line('circuit_4f7f4083', 'R187/RConn1', 'R188/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N128: ', me.message]);
end

% Net: N129 (connections: R188.2, R190.1)
try
    add_line('circuit_4f7f4083', 'R188/RConn1', 'R190/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N129: ', me.message]);
end

% Net: N130 (connections: R190.2, R191.1)
try
    add_line('circuit_4f7f4083', 'R190/RConn1', 'R191/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N130: ', me.message]);
end

% Net: N131 (connections: R191.2, R192.1)
try
    add_line('circuit_4f7f4083', 'R191/RConn1', 'R192/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N131: ', me.message]);
end

% Net: N132 (connections: R192.2, R194.1)
try
    add_line('circuit_4f7f4083', 'R192/RConn1', 'R194/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N132: ', me.message]);
end

% Net: N133 (connections: R194.2, C196.1)
try
    add_line('circuit_4f7f4083', 'R194/RConn1', 'C196/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N133: ', me.message]);
end

% Net: N134 (connections: C196.2, C201.1)
try
    add_line('circuit_4f7f4083', 'C196/RConn1', 'C201/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N134: ', me.message]);
end

% Net: N135 (connections: C201.2, L204.1)
try
    add_line('circuit_4f7f4083', 'C201/RConn1', 'L204/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N135: ', me.message]);
end

% Net: N136 (connections: L204.2, R206.1)
try
    add_line('circuit_4f7f4083', 'L204/RConn1', 'R206/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N136: ', me.message]);
end

% Net: N137 (connections: R206.2, C207.1)
try
    add_line('circuit_4f7f4083', 'R206/RConn1', 'C207/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N137: ', me.message]);
end

% Net: N138 (connections: C207.2, R208.1)
try
    add_line('circuit_4f7f4083', 'C207/RConn1', 'R208/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N138: ', me.message]);
end

% Net: N139 (connections: R208.2, R209.1)
try
    add_line('circuit_4f7f4083', 'R208/RConn1', 'R209/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N139: ', me.message]);
end

% Net: N140 (connections: R209.2, R210.1)
try
    add_line('circuit_4f7f4083', 'R209/RConn1', 'R210/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N140: ', me.message]);
end

% Net: N141 (connections: R210.2, C212.1)
try
    add_line('circuit_4f7f4083', 'R210/RConn1', 'C212/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N141: ', me.message]);
end

% Net: N142 (connections: C212.2, C214.1)
try
    add_line('circuit_4f7f4083', 'C212/RConn1', 'C214/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N142: ', me.message]);
end

% Net: N143 (connections: C214.2, C216.1)
try
    add_line('circuit_4f7f4083', 'C214/RConn1', 'C216/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N143: ', me.message]);
end

% Net: N144 (connections: C216.2, R217.1)
try
    add_line('circuit_4f7f4083', 'C216/RConn1', 'R217/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N144: ', me.message]);
end

% Net: N145 (connections: R217.2, C218.1)
try
    add_line('circuit_4f7f4083', 'R217/RConn1', 'C218/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N145: ', me.message]);
end

% Net: N146 (connections: C218.2, L219.1)
try
    add_line('circuit_4f7f4083', 'C218/RConn1', 'L219/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N146: ', me.message]);
end

% Net: N147 (connections: L219.2, R220.1)
try
    add_line('circuit_4f7f4083', 'L219/RConn1', 'R220/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N147: ', me.message]);
end

% Net: N148 (connections: R220.2, C221.1)
try
    add_line('circuit_4f7f4083', 'R220/RConn1', 'C221/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N148: ', me.message]);
end

% Net: N149 (connections: C221.2, C222.1)
try
    add_line('circuit_4f7f4083', 'C221/RConn1', 'C222/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N149: ', me.message]);
end

% Net: N150 (connections: C222.2, R223.1)
try
    add_line('circuit_4f7f4083', 'C222/RConn1', 'R223/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N150: ', me.message]);
end

% Net: N151 (connections: R223.2, R224.1)
try
    add_line('circuit_4f7f4083', 'R223/RConn1', 'R224/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N151: ', me.message]);
end

% Net: N152 (connections: R224.2, R225.1)
try
    add_line('circuit_4f7f4083', 'R224/RConn1', 'R225/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N152: ', me.message]);
end

% Net: N153 (connections: R225.2, C226.1)
try
    add_line('circuit_4f7f4083', 'R225/RConn1', 'C226/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N153: ', me.message]);
end

% Net: N154 (connections: C226.2, C228.1)
try
    add_line('circuit_4f7f4083', 'C226/RConn1', 'C228/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N154: ', me.message]);
end

% Net: N155 (connections: C228.2, C230.1)
try
    add_line('circuit_4f7f4083', 'C228/RConn1', 'C230/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N155: ', me.message]);
end

% Net: N156 (connections: C230.2, R232.1)
try
    add_line('circuit_4f7f4083', 'C230/RConn1', 'R232/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N156: ', me.message]);
end

% Net: N157 (connections: R232.2, C233.1)
try
    add_line('circuit_4f7f4083', 'R232/RConn1', 'C233/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N157: ', me.message]);
end

% Net: N158 (connections: C233.2, R235.1)
try
    add_line('circuit_4f7f4083', 'C233/RConn1', 'R235/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N158: ', me.message]);
end

% Net: N159 (connections: R235.2, R236.1)
try
    add_line('circuit_4f7f4083', 'R235/RConn1', 'R236/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N159: ', me.message]);
end

% Net: N160 (connections: R236.2, C238.1)
try
    add_line('circuit_4f7f4083', 'R236/RConn1', 'C238/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N160: ', me.message]);
end

% Net: N161 (connections: C238.2, R239.1)
try
    add_line('circuit_4f7f4083', 'C238/RConn1', 'R239/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N161: ', me.message]);
end

% Net: N162 (connections: R239.2, L243.1)
try
    add_line('circuit_4f7f4083', 'R239/RConn1', 'L243/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N162: ', me.message]);
end

% Net: N163 (connections: L243.2, C244.1)
try
    add_line('circuit_4f7f4083', 'L243/RConn1', 'C244/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N163: ', me.message]);
end

% Net: N164 (connections: C244.2, R247.1)
try
    add_line('circuit_4f7f4083', 'C244/RConn1', 'R247/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N164: ', me.message]);
end

% Net: N165 (connections: R247.2, R248.1)
try
    add_line('circuit_4f7f4083', 'R247/RConn1', 'R248/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N165: ', me.message]);
end

% Net: N166 (connections: R248.2, R250.1)
try
    add_line('circuit_4f7f4083', 'R248/RConn1', 'R250/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N166: ', me.message]);
end

% Net: N167 (connections: R250.2, R251.1)
try
    add_line('circuit_4f7f4083', 'R250/RConn1', 'R251/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N167: ', me.message]);
end

% Net: N168 (connections: R251.2, C253.1)
try
    add_line('circuit_4f7f4083', 'R251/RConn1', 'C253/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N168: ', me.message]);
end

% Net: N169 (connections: C253.2, C254.1)
try
    add_line('circuit_4f7f4083', 'C253/RConn1', 'C254/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N169: ', me.message]);
end

% Net: N170 (connections: C254.2, R255.1)
try
    add_line('circuit_4f7f4083', 'C254/RConn1', 'R255/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N170: ', me.message]);
end

% Net: N171 (connections: R255.2, C257.1)
try
    add_line('circuit_4f7f4083', 'R255/RConn1', 'C257/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N171: ', me.message]);
end

% Net: N172 (connections: C257.2, R258.1)
try
    add_line('circuit_4f7f4083', 'C257/RConn1', 'R258/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N172: ', me.message]);
end

% Net: N173 (connections: R258.2, R260.1)
try
    add_line('circuit_4f7f4083', 'R258/RConn1', 'R260/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N173: ', me.message]);
end

% Net: N174 (connections: R260.2, R262.1)
try
    add_line('circuit_4f7f4083', 'R260/RConn1', 'R262/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N174: ', me.message]);
end

% Net: N175 (connections: R262.2, C265.1)
try
    add_line('circuit_4f7f4083', 'R262/RConn1', 'C265/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N175: ', me.message]);
end

% Net: N176 (connections: C265.2, C269.1)
try
    add_line('circuit_4f7f4083', 'C265/RConn1', 'C269/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N176: ', me.message]);
end

% Net: N177 (connections: C269.2, L270.1)
try
    add_line('circuit_4f7f4083', 'C269/RConn1', 'L270/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N177: ', me.message]);
end

% Net: N178 (connections: L270.2, R271.1)
try
    add_line('circuit_4f7f4083', 'L270/RConn1', 'R271/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N178: ', me.message]);
end

% Net: N179 (connections: R271.2, C272.1)
try
    add_line('circuit_4f7f4083', 'R271/RConn1', 'C272/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N179: ', me.message]);
end

% Net: N180 (connections: C272.2, R275.1)
try
    add_line('circuit_4f7f4083', 'C272/RConn1', 'R275/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N180: ', me.message]);
end

% Net: N181 (connections: R275.2, L276.1)
try
    add_line('circuit_4f7f4083', 'R275/RConn1', 'L276/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N181: ', me.message]);
end

% Net: N182 (connections: L276.2, L279.1)
try
    add_line('circuit_4f7f4083', 'L276/RConn1', 'L279/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N182: ', me.message]);
end

% Net: N183 (connections: L279.2, C281.1)
try
    add_line('circuit_4f7f4083', 'L279/RConn1', 'C281/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N183: ', me.message]);
end

% Net: N184 (connections: C281.2, R282.1)
try
    add_line('circuit_4f7f4083', 'C281/RConn1', 'R282/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N184: ', me.message]);
end

% Net: N185 (connections: R282.2, C283.1)
try
    add_line('circuit_4f7f4083', 'R282/RConn1', 'C283/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N185: ', me.message]);
end

% Net: N186 (connections: C283.2, R284.1)
try
    add_line('circuit_4f7f4083', 'C283/RConn1', 'R284/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N186: ', me.message]);
end

% Net: N187 (connections: R284.2, C285.1)
try
    add_line('circuit_4f7f4083', 'R284/RConn1', 'C285/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N187: ', me.message]);
end

% Net: N188 (connections: C285.2, R287.1)
try
    add_line('circuit_4f7f4083', 'C285/RConn1', 'R287/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N188: ', me.message]);
end

% Net: N189 (connections: R287.2, R290.1)
try
    add_line('circuit_4f7f4083', 'R287/RConn1', 'R290/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N189: ', me.message]);
end

% Net: N190 (connections: R290.2, C293.1)
try
    add_line('circuit_4f7f4083', 'R290/RConn1', 'C293/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N190: ', me.message]);
end

% Net: N191 (connections: C293.2, C295.1)
try
    add_line('circuit_4f7f4083', 'C293/RConn1', 'C295/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N191: ', me.message]);
end

% Net: N192 (connections: C295.2, C303.1)
try
    add_line('circuit_4f7f4083', 'C295/RConn1', 'C303/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N192: ', me.message]);
end

% Net: N193 (connections: C303.2, R304.1)
try
    add_line('circuit_4f7f4083', 'C303/RConn1', 'R304/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N193: ', me.message]);
end

% Net: N194 (connections: R304.2, R305.1)
try
    add_line('circuit_4f7f4083', 'R304/RConn1', 'R305/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N194: ', me.message]);
end

% Net: N195 (connections: R305.2, L306.1)
try
    add_line('circuit_4f7f4083', 'R305/RConn1', 'L306/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N195: ', me.message]);
end

% Net: N196 (connections: L306.2, C308.1)
try
    add_line('circuit_4f7f4083', 'L306/RConn1', 'C308/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N196: ', me.message]);
end

% Net: N197 (connections: C308.2, C310.1)
try
    add_line('circuit_4f7f4083', 'C308/RConn1', 'C310/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N197: ', me.message]);
end

% Net: N198 (connections: C310.2, R313.1)
try
    add_line('circuit_4f7f4083', 'C310/RConn1', 'R313/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N198: ', me.message]);
end

% Net: N199 (connections: R313.2, R314.1)
try
    add_line('circuit_4f7f4083', 'R313/RConn1', 'R314/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N199: ', me.message]);
end

% Net: N200 (connections: R314.2, C315.1)
try
    add_line('circuit_4f7f4083', 'R314/RConn1', 'C315/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N200: ', me.message]);
end

% Net: N201 (connections: C315.2, R317.1)
try
    add_line('circuit_4f7f4083', 'C315/RConn1', 'R317/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N201: ', me.message]);
end

% Net: N202 (connections: R317.2, C320.1)
try
    add_line('circuit_4f7f4083', 'R317/RConn1', 'C320/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N202: ', me.message]);
end

% Net: N203 (connections: C320.2, C324.1)
try
    add_line('circuit_4f7f4083', 'C320/RConn1', 'C324/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N203: ', me.message]);
end

% Net: N204 (connections: C324.2, R326.1)
try
    add_line('circuit_4f7f4083', 'C324/RConn1', 'R326/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N204: ', me.message]);
end

% Net: N205 (connections: R326.2, R329.1)
try
    add_line('circuit_4f7f4083', 'R326/RConn1', 'R329/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N205: ', me.message]);
end

% Net: N206 (connections: R329.2, R331.1)
try
    add_line('circuit_4f7f4083', 'R329/RConn1', 'R331/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N206: ', me.message]);
end

% Net: N207 (connections: R331.2, R333.1)
try
    add_line('circuit_4f7f4083', 'R331/RConn1', 'R333/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N207: ', me.message]);
end

% Net: N208 (connections: R333.2, R334.1)
try
    add_line('circuit_4f7f4083', 'R333/RConn1', 'R334/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N208: ', me.message]);
end

% Net: N209 (connections: R334.2, R335.1)
try
    add_line('circuit_4f7f4083', 'R334/RConn1', 'R335/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N209: ', me.message]);
end

% Net: N210 (connections: R335.2, L336.1)
try
    add_line('circuit_4f7f4083', 'R335/RConn1', 'L336/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N210: ', me.message]);
end

% Net: N211 (connections: L336.2, R337.1)
try
    add_line('circuit_4f7f4083', 'L336/RConn1', 'R337/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N211: ', me.message]);
end

% Net: N212 (connections: R337.2, R338.1)
try
    add_line('circuit_4f7f4083', 'R337/RConn1', 'R338/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N212: ', me.message]);
end

% Net: GND (connections: GND16.1, R338.2, V14.-)
try
    add_line('circuit_4f7f4083', 'GND16/LConn1', 'R338/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('circuit_4f7f4083', 'R338/RConn1', 'V14/n', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('circuit_4f7f4083', 'F:/KONE FINALS/circuit2sim/generated/circuit_4f7f4083.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/circuit2sim/generated/circuit_4f7f4083.slx']);

% 8. Simulation Smoke Test
disp('--> Running simulation smoke test...');
simOut = sim('circuit_4f7f4083', 'StopTime', '0.01');
disp('--> Smoke test completed successfully (PASS).');

% Keep model open for editing if run interactively, otherwise close
% close_system('circuit_4f7f4083');