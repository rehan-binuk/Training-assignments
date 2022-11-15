function [speed_mps,speed_rad_per_s] = velocity_conv(v) 
speed_mps = v*(5/18);
speed_rad_per_s = speed_mps/0.5;
end
