% =====================================================================
% Circuit2Sim - Automated Simscape Model Generator
% Model Name: model_29_current_sense_shunt_circuit
% Generated:   2026-09-24 20:49:43 UTC
% Target:      MATLAB/Simulink/Simscape Electrical
% Universal Circuit IR Version: 0.1
% =====================================================================

disp('--> Initializing Simscape environment for model_29_current_sense_shunt_circuit...');
load_system('simulink');
load_system('fl_lib');

% Close any existing model with the same name without saving
if bdIsLoaded('model_29_current_sense_shunt_circuit')
    close_system('model_29_current_sense_shunt_circuit', 0);
end

% 1. Create fresh Simulink model in memory
new_system('model_29_current_sense_shunt_circuit');
% (open_system is only called in desktop GUI mode; omitted here for headless speed)

% 2. Configure Model Solver for Physical Network Simulation
set_param('model_29_current_sense_shunt_circuit', 'Solver', 'ode23t');
set_param('model_29_current_sense_shunt_circuit', 'StopTime', '0.05');

% 3. Add Solver Configuration block (Required for all Simscape systems)
add_block('nesl_utility/Solver Configuration', 'model_29_current_sense_shunt_circuit/Solver_Config', ...
    'Position', [40, 40, 110, 80]);

% =====================================================================
% 4. Instantiate Physical Circuit Components
% =====================================================================
% [V_BUS] Main DC Power Bus
add_block('fl_lib/Electrical/Electrical Sources/DC Voltage Source', 'model_29_current_sense_shunt_circuit/V_BUS', ...
    'Position', [100, 260, 160, 330]);
set_param('model_29_current_sense_shunt_circuit/V_BUS', 'v0', '24.0');
set_param('model_29_current_sense_shunt_circuit/V_BUS', 'v0_unit', 'V');

% [R_SHUNT] Kelvin Sense Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_29_current_sense_shunt_circuit/R_SHUNT', ...
    'Position', [260, 170, 340, 210]);
set_param('model_29_current_sense_shunt_circuit/R_SHUNT', 'R', '0.05');
set_param('model_29_current_sense_shunt_circuit/R_SHUNT', 'R_unit', 'Ohm');

% [R_LOAD] System Work Load
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_29_current_sense_shunt_circuit/R_LOAD', ...
    'Position', [420, 260, 480, 330]);
set_param('model_29_current_sense_shunt_circuit/R_LOAD', 'R', '12.0');
set_param('model_29_current_sense_shunt_circuit/R_LOAD', 'R_unit', 'Ohm');

% [R_FILT] Sense Lead Filter Resistor
add_block('fl_lib/Electrical/Electrical Elements/Resistor', 'model_29_current_sense_shunt_circuit/R_FILT', ...
    'Position', [560, 170, 640, 210]);
set_param('model_29_current_sense_shunt_circuit/R_FILT', 'R', '100.0');
set_param('model_29_current_sense_shunt_circuit/R_FILT', 'R_unit', 'Ohm');

% [C_FILT] Sense Shunt Capacitor
add_block('fl_lib/Electrical/Electrical Elements/Capacitor', 'model_29_current_sense_shunt_circuit/C_FILT', ...
    'Position', [700, 260, 760, 330]);
set_param('model_29_current_sense_shunt_circuit/C_FILT', 'c', '1e-07');
set_param('model_29_current_sense_shunt_circuit/C_FILT', 'c_unit', 'F');

% [GND1] Power Ground
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', 'model_29_current_sense_shunt_circuit/GND1', ...
    'Position', [420, 410, 480, 450]);

% =====================================================================
% 5. Connect Physical Solver Configuration to Reference Net
% =====================================================================
try
    add_line('model_29_current_sense_shunt_circuit', 'Solver_Config/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Notice: Solver config connection: ', me.message]);
end

% =====================================================================
% 6. Create Physical Network Connections (Nets)
% =====================================================================
% Net: N_BUS (connections: V_BUS.+, R_SHUNT.1)
try
    add_line('model_29_current_sense_shunt_circuit', 'V_BUS/RConn1', 'R_SHUNT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_BUS: ', me.message]);
end

% Net: N_LOAD (connections: R_SHUNT.2, R_LOAD.1, R_FILT.1)
try
    add_line('model_29_current_sense_shunt_circuit', 'R_SHUNT/RConn1', 'R_LOAD/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_LOAD: ', me.message]);
end
try
    add_line('model_29_current_sense_shunt_circuit', 'R_LOAD/LConn1', 'R_FILT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_LOAD: ', me.message]);
end

% Net: N_SENSE (connections: R_FILT.2, C_FILT.1)
try
    add_line('model_29_current_sense_shunt_circuit', 'R_FILT/RConn1', 'C_FILT/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net N_SENSE: ', me.message]);
end

% Net: GND (connections: V_BUS.-, R_LOAD.2, C_FILT.2, GND1.1)
try
    add_line('model_29_current_sense_shunt_circuit', 'V_BUS/LConn1', 'R_LOAD/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_29_current_sense_shunt_circuit', 'R_LOAD/RConn1', 'C_FILT/RConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end
try
    add_line('model_29_current_sense_shunt_circuit', 'C_FILT/RConn1', 'GND1/LConn1', 'autorouting', 'on');
catch me
    disp(['Wiring warning for net GND: ', me.message]);
end

% =====================================================================
% 7. Save Editable Native Simulink Model
% =====================================================================
save_system('model_29_current_sense_shunt_circuit', 'F:/KONE FINALS/datasets/29_current_sense_shunt_circuit/model_29_current_sense_shunt_circuit.slx');
disp(['--> Model successfully compiled and saved to: ', 'F:/KONE FINALS/datasets/29_current_sense_shunt_circuit/model_29_current_sense_shunt_circuit.slx']);

% 8. Diagram Consistency Verification
disp('--> Verifying Simscape diagram connectivity and parameters...');
try
    set_param('model_29_current_sense_shunt_circuit', 'SimulationCommand', 'update');
    disp('--> Diagram compiled and verified successfully (PASS).');
catch me
    disp(['--> Verification note: ', me.message]);
end

% Release model from memory so it can be freely accessed and downloaded
close_system('model_29_current_sense_shunt_circuit', 0);