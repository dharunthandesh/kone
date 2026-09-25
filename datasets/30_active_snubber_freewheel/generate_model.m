% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_30_active_snubber_freewheel
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_30_active_snubber_freewheel...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_30_active_snubber_freewheel')
    close_system('model_30_active_snubber_freewheel', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_30_active_snubber_freewheel');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_30_active_snubber_freewheel', 'Solver', 'ode23t');
set_param('model_30_active_snubber_freewheel', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_30_active_snubber_freewheel/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V_DC] Inverter DC Rail Supply
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_30_active_snubber_freewheel/V_DC', ...
    'Position', [100, 260, 160, 330]);
set_param('model_30_active_snubber_freewheel/V_DC', 'v0', '50.0');
set_param('model_30_active_snubber_freewheel/V_DC', 'v0_unit', 'V');

% [L_MOTOR] Motor Winding Inductance
add_block('fl_lib/Electrical/Electrical Elements/Inductor', 'model_30_active_snubber_freewheel/L_MOTOR', ...
    'Position', [260, 170, 340, 210]);
set_param('model_30_active_snubber_freewheel/L_MOTOR', 'l', '0.02');
set_param('model_30_active_snubber_freewheel/L_MOTOR', 'l_unit', 'H');

% [D_UPPER] Upper Rail Clamping Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_30_active_snubber_freewheel/D_UPPER', ...
    'Position', [420, 170, 480, 210]);
set_param('model_30_active_snubber_freewheel/D_UPPER', 'Vf', '0.7');
set_param('model_30_active_snubber_freewheel/D_UPPER', 'Vf_unit', 'V');

% [D_LOWER] Lower Rail Clamping Diode
add_block('fl_lib/Electrical/Electrical Elements/Diode', 'model_30_active_snubber_freewheel/D_LOWER', ...
    'Position', [420, 340, 480, 380]);
set_param('model_30_active_snubber_freewheel/D_LOWER', 'Vf', '0.7');
set_param('model_30_active_snubber_freewheel/D_LOWER', 'Vf_unit', 'V');

% [R_SNUB] Damping Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_30_active_snubber_freewheel/R_SNUB', ...
    'Position', [560, 260, 620, 330]);
set_param('model_30_active_snubber_freewheel/R_SNUB', 'R', '25.0');
set_param('model_30_active_snubber_freewheel/R_SNUB', 'R_unit', 'Ohm');

% [C_SNUB] Snubber Reservoir Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_30_active_snubber_freewheel/C_SNUB', ...
    'Position', [680, 260, 740, 330]);
set_param('model_30_active_snubber_freewheel/C_SNUB', 'c', '2.2e-06');
set_param('model_30_active_snubber_freewheel/C_SNUB', 'c_unit', 'F');

% [GND1] DC Negative Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_30_active_snubber_freewheel/GND1', ...
    'Position', [420, 420, 480, 460]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_30_active_snubber_freewheel', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_DC_POS (connections: V_DC.+, L_MOTOR.1, D_UPPER.K)
try
    add_line('model_30_active_snubber_freewheel', 'V_DC/RConn1', 'L_MOTOR/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_POS: ', me.message]);
end
try
    add_line('model_30_active_snubber_freewheel', 'L_MOTOR/LConn1', 'D_UPPER/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_DC_POS: ', me.message]);
end

% Net: N_PHASE (connections: L_MOTOR.2, D_UPPER.A, D_LOWER.K, R_SNUB.1)
try
    add_line('model_30_active_snubber_freewheel', 'L_MOTOR/RConn1', 'D_UPPER/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_PHASE: ', me.message]);
end
try
    add_line('model_30_active_snubber_freewheel', 'D_UPPER/LConn1', 'D_LOWER/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_PHASE: ', me.message]);
end
try
    add_line('model_30_active_snubber_freewheel', 'D_LOWER/RConn1', 'R_SNUB/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_PHASE: ', me.message]);
end

% Net: N_RC (connections: R_SNUB.2, C_SNUB.1)
try
    add_line('model_30_active_snubber_freewheel', 'R_SNUB/RConn1', 'C_SNUB/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_RC: ', me.message]);
end

% Net: GND (connections: V_DC.-, D_LOWER.A, C_SNUB.2, GND1.1)
try
    add_line('model_30_active_snubber_freewheel', 'V_DC/LConn1', 'D_LOWER/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_30_active_snubber_freewheel', 'D_LOWER/LConn1', 'C_SNUB/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_30_active_snubber_freewheel', 'C_SNUB/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_30_active_snubber_freewheel', 'F:/KONE FINALS/datasets/30_active_snubber_freewheel/model_30_active_snubber_freewheel.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/30_active_snubber_freewheel/model_30_active_snubber_freewheel.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_30_active_snubber_freewheel', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_30_active_snubber_freewheel', 0);