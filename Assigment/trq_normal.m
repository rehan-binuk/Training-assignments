function torque = trq_normal(torque_max,power_max,w_power_max,w_torque_max,w_normal)
torque = (torque_max - (power_max * (w_normal - w_torque_max).^2)/(2*w_power_max^2*(w_power_max - w_torque_max)));
end