function torque = trq (drag_coeff,density_air,frontal_area,velocity,mass,g,friction_coeff,road_gradient,rolling_radius)
torque = (friction_coeff*mass*g + 0.5*drag_coeff*density_air*frontal_area*velocity.^2 + mass*g*sin(road_gradient))*rolling_radius;
end

