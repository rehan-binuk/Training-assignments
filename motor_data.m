motor_spec  = readmatrix("data\Motor Spec\ac_25_motor_spec.xlsx");
input_power_map = readmatrix("data\Motor Spec\ac_25_motor_spec.xlsx", 'Sheet',2);
efficiency_map  = readmatrix("data\Motor Spec\ac_25_motor_spec.xlsx", 'Sheet',3);
max_torque_map  = readmatrix("data\Motor Spec\ac_25_motor_spec.xlsx", 'Sheet',4);
max_regen_torque_map  = readmatrix("data\Motor Spec\ac_25_motor_spec.xlsx", 'Sheet',5);

motor_inpwr_W_map = input_power_map(2:end,2:end);
motor_eff_map = efficiency_map(2:end,2:end);
motor_trq_map = input_power_map(1,2:end);
motor_speed_map = input_power_map(2:end,1);
motor_speed_map = transpose(motor_speed_map);

% output_power_map = interp2(motor_trq_map,motor_speed_map,motor_inpwr_W_map, torque, speed_rad_per_s);
 output_efficiency_map = interp2(motor_trq_map,motor_speed_map,motor_eff_map, torque, speed_rad_per_s);

voltage = motor_spec(1,2);
max_current = motor_spec(2,2);
max_speed = motor_spec(3,2);

input_power = inpwr(torque,speed_rad_per_s);
current_req = current_cal(input_power, voltage);
output_power = outpwr(output_efficiency_map,input_power);
torque_out = trq_out(output_power,speed_rad_per_s);
heat_loss = h_l(input_power,output_power);

contourf(motor_trq_map,motor_speed_map,motor_eff_map);

