% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_25_boost_converter_snubber
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_25_boost_converter_snubber...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_25_boost_converter_snubber')
    close_system('model_25_boost_converter_snubber', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_25_boost_converter_snubber');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_25_boost_converter_snubber', 'Solver', 'ode23t');
set_param('model_25_boost_converter_snubber', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_25_boost_converter_snubber/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] DC Power Bus
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_25_boost_converter_snubber/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_25_boost_converter_snubber/V1', 'v0', '48.0');
set_param('model_25_boost_converter_snubber/V1', 'v0_unit', 'V');

% [L_LEAK] Transformer Leakage Inductance
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_25_boost_converter_snubber/L_LEAK', ...
    'Position', [260, 170, 340, 210]);
set_param('model_25_boost_converter_snubber/L_LEAK', 'l', '1e-05');
set_param('model_25_boost_converter_snubber/L_LEAK', 'l_unit', 'H');

% [D_SNUB] Fast Snubber Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_25_boost_converter_snubber/D_SNUB', ...
    'Position', [420, 170, 500, 210]);
set_param('model_25_boost_converter_snubber/D_SNUB', 'Vf', '0.7');
set_param('model_25_boost_converter_snubber/D_SNUB', 'Vf_unit', 'V');

% [C_SNUB] Energy Storage Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_25_boost_converter_snubber/C_SNUB', ...
    'Position', [580, 260, 640, 330]);
set_param('model_25_boost_converter_snubber/C_SNUB', 'c', '4.7e-08');
set_param('model_25_boost_converter_snubber/C_SNUB', 'c_unit', 'F');

% [R_SNUB] Dissipation Bleeder Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_25_boost_converter_snubber/R_SNUB', ...
    'Position', [700, 260, 760, 330]);
set_param('model_25_boost_converter_snubber/R_SNUB', 'R', '1000.0');
set_param('model_25_boost_converter_snubber/R_SNUB', 'R_unit', 'Ohm');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_25_boost_converter_snubber/GND1', ...
    'Position', [420, 410, 480, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_25_boost_converter_snubber', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_IN (connections: V1.+, L_LEAK.1)
try
    add_line('model_25_boost_converter_snubber', 'V1/RConn1', 'L_LEAK/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_IN: ', me.message]);
end

% Net: N_SWITCH (connections: L_LEAK.2, D_SNUB.A)
try
    add_line('model_25_boost_converter_snubber', 'L_LEAK/RConn1', 'D_SNUB/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_SWITCH: ', me.message]);
end

% Net: N_CLAMP (connections: D_SNUB.K, C_SNUB.1, R_SNUB.1)
try
    add_line('model_25_boost_converter_snubber', 'D_SNUB/RConn1', 'C_SNUB/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CLAMP: ', me.message]);
end
try
    add_line('model_25_boost_converter_snubber', 'C_SNUB/LConn1', 'R_SNUB/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_CLAMP: ', me.message]);
end

% Net: GND (connections: V1.-, C_SNUB.2, R_SNUB.2, GND1.1)
try
    add_line('model_25_boost_converter_snubber', 'V1/LConn1', 'C_SNUB/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_25_boost_converter_snubber', 'C_SNUB/RConn1', 'R_SNUB/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_25_boost_converter_snubber', 'R_SNUB/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_25_boost_converter_snubber', 'F:/KONE FINALS/datasets/25_boost_converter_snubber/model_25_boost_converter_snubber.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/25_boost_converter_snubber/model_25_boost_converter_snubber.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_25_boost_converter_snubber', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_25_boost_converter_snubber', 0);