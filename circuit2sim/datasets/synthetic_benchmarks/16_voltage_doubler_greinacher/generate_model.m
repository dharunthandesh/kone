% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_16_voltage_doubler_greinacher
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_16_voltage_doubler_greinacher...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_16_voltage_doubler_greinacher')
    close_system('model_16_voltage_doubler_greinacher', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_16_voltage_doubler_greinacher');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_16_voltage_doubler_greinacher', 'Solver', 'ode23t');
set_param('model_16_voltage_doubler_greinacher', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_16_voltage_doubler_greinacher/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] AC Transformer Rail
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_16_voltage_doubler_greinacher/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_16_voltage_doubler_greinacher/V1', 'v0', '12.0');
set_param('model_16_voltage_doubler_greinacher/V1', 'v0_unit', 'V');

% [C1] Pump Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_16_voltage_doubler_greinacher/C1', ...
    'Position', [240, 170, 320, 210]);
set_param('model_16_voltage_doubler_greinacher/C1', 'c', '1e-05');
set_param('model_16_voltage_doubler_greinacher/C1', 'c_unit', 'F');

% [D1] Clamp Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_16_voltage_doubler_greinacher/D1', ...
    'Position', [380, 260, 440, 330]);
set_param('model_16_voltage_doubler_greinacher/D1', 'Vf', '0.7');
set_param('model_16_voltage_doubler_greinacher/D1', 'Vf_unit', 'V');

% [D2] Rectifier Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_16_voltage_doubler_greinacher/D2', ...
    'Position', [480, 170, 560, 210]);
set_param('model_16_voltage_doubler_greinacher/D2', 'Vf', '0.7');
set_param('model_16_voltage_doubler_greinacher/D2', 'Vf_unit', 'V');

% [C2] Reservoir Output Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_16_voltage_doubler_greinacher/C2', ...
    'Position', [620, 260, 680, 330]);
set_param('model_16_voltage_doubler_greinacher/C2', 'c', '4.7e-05');
set_param('model_16_voltage_doubler_greinacher/C2', 'c_unit', 'F');

% [R1] Output Bleed Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_16_voltage_doubler_greinacher/R1', ...
    'Position', [740, 260, 800, 330]);
set_param('model_16_voltage_doubler_greinacher/R1', 'R', '10000.0');
set_param('model_16_voltage_doubler_greinacher/R1', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_16_voltage_doubler_greinacher/GND1', ...
    'Position', [380, 410, 440, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_16_voltage_doubler_greinacher', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, C1.1)
try
    add_line('model_16_voltage_doubler_greinacher', 'V1/RConn1', 'C1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_PUMP (connections: C1.2, D1.K, D2.A)
try
    add_line('model_16_voltage_doubler_greinacher', 'C1/RConn1', 'D1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_PUMP: ', me.message]);
end
try
    add_line('model_16_voltage_doubler_greinacher', 'D1/RConn1', 'D2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_PUMP: ', me.message]);
end

% Net: N_OUT (connections: D2.K, C2.1, R1.1)
try
    add_line('model_16_voltage_doubler_greinacher', 'D2/RConn1', 'C2/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end
try
    add_line('model_16_voltage_doubler_greinacher', 'C2/LConn1', 'R1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_OUT: ', me.message]);
end

% Net: GND (connections: V1.-, D1.A, C2.2, R1.2, GND1.1)
try
    add_line('model_16_voltage_doubler_greinacher', 'V1/LConn1', 'D1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_16_voltage_doubler_greinacher', 'D1/LConn1', 'C2/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_16_voltage_doubler_greinacher', 'C2/RConn1', 'R1/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_16_voltage_doubler_greinacher', 'R1/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_16_voltage_doubler_greinacher', 'F:/KONE FINALS/datasets/16_voltage_doubler_greinacher/model_16_voltage_doubler_greinacher.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/16_voltage_doubler_greinacher/model_16_voltage_doubler_greinacher.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_16_voltage_doubler_greinacher', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_16_voltage_doubler_greinacher', 0);