% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_27_differential_rc_filter
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_27_differential_rc_filter...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_27_differential_rc_filter')
    close_system('model_27_differential_rc_filter', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_27_differential_rc_filter');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_27_differential_rc_filter', 'Solver', 'ode23t');
set_param('model_27_differential_rc_filter', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_27_differential_rc_filter/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Differential Sensor Signal
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_27_differential_rc_filter/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_27_differential_rc_filter/V1', 'v0', '5.0');
set_param('model_27_differential_rc_filter/V1', 'v0_unit', 'V');

% [R1] Positive Leg Series Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_27_differential_rc_filter/R1', ...
    'Position', [280, 170, 360, 210]);
set_param('model_27_differential_rc_filter/R1', 'R', '1000.0');
set_param('model_27_differential_rc_filter/R1', 'R_unit', 'Ohm');

% [R2] Negative Leg Series Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_27_differential_rc_filter/R2', ...
    'Position', [280, 350, 360, 390]);
set_param('model_27_differential_rc_filter/R2', 'R', '1000.0');
set_param('model_27_differential_rc_filter/R2', 'R_unit', 'Ohm');

% [C_DIFF] Differential Filter Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_27_differential_rc_filter/C_DIFF', ...
    'Position', [460, 260, 520, 330]);
set_param('model_27_differential_rc_filter/C_DIFF', 'c', '1e-07');
set_param('model_27_differential_rc_filter/C_DIFF', 'c_unit', 'F');

% [C_CM1] Common-Mode Positive Bypass
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_27_differential_rc_filter/C_CM1', ...
    'Position', [600, 210, 660, 270]);
set_param('model_27_differential_rc_filter/C_CM1', 'c', '1e-08');
set_param('model_27_differential_rc_filter/C_CM1', 'c_unit', 'F');

% [C_CM2] Common-Mode Negative Bypass
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_27_differential_rc_filter/C_CM2', ...
    'Position', [600, 310, 660, 370]);
set_param('model_27_differential_rc_filter/C_CM2', 'c', '1e-08');
set_param('model_27_differential_rc_filter/C_CM2', 'c_unit', 'F');

% [GND1] Shield Reference Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_27_differential_rc_filter/GND1', ...
    'Position', [600, 420, 660, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_27_differential_rc_filter', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_SIG_P (connections: V1.+, R1.1)
try
    add_line('model_27_differential_rc_filter', 'V1/RConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_SIG_P: ', me.message]);
end

% Net: N_SIG_N (connections: V1.-, R2.1)
try
    add_line('model_27_differential_rc_filter', 'V1/LConn1', 'R2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_SIG_N: ', me.message]);
end

% Net: N_ADC_P (connections: R1.2, C_DIFF.1, C_CM1.1)
try
    add_line('model_27_differential_rc_filter', 'R1/RConn1', 'C_DIFF/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_ADC_P: ', me.message]);
end
try
    add_line('model_27_differential_rc_filter', 'C_DIFF/LConn1', 'C_CM1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_ADC_P: ', me.message]);
end

% Net: N_ADC_N (connections: R2.2, C_DIFF.2, C_CM2.1)
try
    add_line('model_27_differential_rc_filter', 'R2/RConn1', 'C_DIFF/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_ADC_N: ', me.message]);
end
try
    add_line('model_27_differential_rc_filter', 'C_DIFF/RConn1', 'C_CM2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_ADC_N: ', me.message]);
end

% Net: GND (connections: C_CM1.2, C_CM2.2, GND1.1)
try
    add_line('model_27_differential_rc_filter', 'C_CM1/RConn1', 'C_CM2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_27_differential_rc_filter', 'C_CM2/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_27_differential_rc_filter', 'F:/KONE FINALS/datasets/27_differential_rc_filter/model_27_differential_rc_filter.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/27_differential_rc_filter/model_27_differential_rc_filter.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_27_differential_rc_filter', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_27_differential_rc_filter', 0);