function [speed_mps,speed_rad_per_s] = velocity_conv(v,rolling_radius) 
speed_mps = v*(5/18);
speed_rad_per_s = speed_mps/rolling_radius;
end
