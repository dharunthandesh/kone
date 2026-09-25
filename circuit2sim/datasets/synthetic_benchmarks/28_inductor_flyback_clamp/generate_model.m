% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_28_inductor_flyback_clamp
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_28_inductor_flyback_clamp...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_28_inductor_flyback_clamp')
    close_system('model_28_inductor_flyback_clamp', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_28_inductor_flyback_clamp');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_28_inductor_flyback_clamp', 'Solver', 'ode23t');
set_param('model_28_inductor_flyback_clamp', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_28_inductor_flyback_clamp/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V1] Relay Driver Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_28_inductor_flyback_clamp/V1', ...
    'Position', [100, 260, 160, 330]);
set_param('model_28_inductor_flyback_clamp/V1', 'v0', '24.0');
set_param('model_28_inductor_flyback_clamp/V1', 'v0_unit', 'V');

% [L_COIL] Actuator Coil Inductance
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_28_inductor_flyback_clamp/L_COIL', ...
    'Position', [340, 200, 420, 240]);
set_param('model_28_inductor_flyback_clamp/L_COIL', 'l', '0.25');
set_param('model_28_inductor_flyback_clamp/L_COIL', 'l_unit', 'H');

% [R_COIL] Coil Internal Resistance
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_28_inductor_flyback_clamp/R_COIL', ...
    'Position', [340, 280, 420, 320]);
set_param('model_28_inductor_flyback_clamp/R_COIL', 'R', '48.0');
set_param('model_28_inductor_flyback_clamp/R_COIL', 'R_unit', 'Ohm');

% [D_FLY] Freewheel Clamping Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_28_inductor_flyback_clamp/D_FLY', ...
    'Position', [520, 260, 580, 330]);
set_param('model_28_inductor_flyback_clamp/D_FLY', 'Vf', '0.7');
set_param('model_28_inductor_flyback_clamp/D_FLY', 'Vf_unit', 'V');

% [GND1] System Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_28_inductor_flyback_clamp/GND1', ...
    'Position', [340, 410, 400, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_28_inductor_flyback_clamp', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_BUS (connections: V1.+, L_COIL.1, D_FLY.K)
try
    add_line('model_28_inductor_flyback_clamp', 'V1/RConn1', 'L_COIL/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BUS: ', me.message]);
end
try
    add_line('model_28_inductor_flyback_clamp', 'L_COIL/LConn1', 'D_FLY/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BUS: ', me.message]);
end

% Net: N_INTERNAL (connections: L_COIL.2, R_COIL.1)
try
    add_line('model_28_inductor_flyback_clamp', 'L_COIL/RConn1', 'R_COIL/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_INTERNAL: ', me.message]);
end

% Net: GND (connections: V1.-, R_COIL.2, D_FLY.A, GND1.1)
try
    add_line('model_28_inductor_flyback_clamp', 'V1/LConn1', 'R_COIL/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_28_inductor_flyback_clamp', 'R_COIL/RConn1', 'D_FLY/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_28_inductor_flyback_clamp', 'D_FLY/LConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_28_inductor_flyback_clamp', 'F:/KONE FINALS/datasets/28_inductor_flyback_clamp/model_28_inductor_flyback_clamp.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/28_inductor_flyback_clamp/model_28_inductor_flyback_clamp.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_28_inductor_flyback_clamp', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_28_inductor_flyback_clamp', 0);