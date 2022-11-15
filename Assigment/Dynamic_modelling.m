% Assumptions
% car moves in straight line so speed of wheel is equal to speed of vehicle

    mass_vehicle = 2000;
    rolling_radius = 0.5;
    wheel_radius = 0.203;
    friction_coeff = 0.5;
    g = 9.81;
    air_density = 1.225;
    drag_coeff = 0.4;
    frontal_area = 1.2;
    pi = 3.14;

% drive cycle input

    data = readmatrix("drive_cycle.xlsx");
    speed = data(1:12,2);
    time = data(1:12,1);
    w_normal = velocity_conv(speed); % rad/s

% Data for Graphs 
 
    % angular velocity is depicted as tour par min which is French for RPM
    % so data should be depicted as RPM vs time plots
    v_car = speed.*(5/18);
    w_rad_per_sec = v_car.*0.5;
    N_wheels = (60*w_rad_per_sec)/2*pi;

% Engine control

    torque_max = 174;
    power_max = 103;
    w_power_max = 660;  % converted to rad/s
    w_torque_max = 450;
    
    engine_torque = trq_normal(torque_max,power_max,w_power_max,w_torque_max,w_normal);
    power = pwr_normal(engine_torque, w_normal);

% Transmission System

    w_wheels_normal = w_normal;
    traction_force = friction_coeff*mass_vehicle*g;
    traction_torque = traction_force.*wheel_radius;
    
    max_speed_of_motor = 5000;
    gear_cal = (max_speed_of_motor * 2 * pi)/(power_max * 60 * 1.1);
    gear_ratio = round(gear_cal,0);
    w_motor = w_wheels_normal * gear_ratio;  % w_m
    N_motor = (60*w_motor)/(2*pi);

% Battery 
    
    battery_voltage = 232.926;
    R_bat = 0.1075;
    time_constant = 30;    % in seconds
    K = 0.06068;
    Q_max = 20;     % in Ah
    A = 18.266;
    B = 1.531;
    

    i_bat = battery_voltage / R_bat;
    Q = i_bat*time_constant;

    alpha_bat = (K*Q_max)/(Q- 0.1*Q_max);
    beta_bat = (K*Q_max)/(Q_max - Q);
    
    % R_bat*i_bat = 23.22 matlab cal error

    v_bat = 232.926 - 23.22; % alpha_bat*time_constant; - beta_bat*Q + A*exp(-B*Q) = 0
    
% DC/DC Converter

    % Assume
    alpha_r = 0.5;
    
    v_in = v_bat;
    v_out = v_in/(1-alpha_r);
    u = 0.5/1;       % time_period = 1s
    pwm = 0.25;

            %   L_r = (v_in - (1-0.5)*v_out)/i_h;  % Battery cal
            
            %   inv_inductance = (v_in - (1-pwm)*v_out)/i_h;
            
            %   inv_capacitance = (i_h(1-u) - i_bat)/v_out;

% Inverter 
    
    phase_angle_diff = 90;
    d_di = 0.5;
    d_qi = 0.25;
    v_dc = v_out;
    v_dm = d_di*v_dc;
    v_qm = d_qi*v_dc;
    eff_inv = 0.957;    % at max power for battery voltage
               %     i_inv = (1/eff_inv)*1.5*(d_di*i_dm + d_qi*i_qm);
    

% Electric Motor 

    % Assume
    number_of_coils = 100;

    % Given data
    d_axis_inductance = 0.002;
    q_axis_inductance = 0.002;
    stator_resistance = 0.04;
    poles = 6;
    moment_interia = 0.05;
    rotor_magnetic_flux_motor = 0.1252;
    inverter_freq = poles*w_motor;

%   current_per_phase = battery_voltage/sqrt(stator_resistance^2 + d_axis_inductance^2);

    flux_linkage = rotor_magnetic_flux_motor*number_of_coils;

    i_dm = rotor_magnetic_flux_motor/d_axis_inductance;
    i_qm = rotor_magnetic_flux_motor/q_axis_inductance;
    
    I_dm = (v_dm - stator_resistance*i_dm + inverter_freq*q_axis_inductance*i_qm)/d_axis_inductance;
    I_qm = (v_qm - stator_resistance*i_qm + inverter_freq*(d_axis_inductance*i_dm + flux_linkage))/q_axis_inductance;
    electromagnetic_trq = 1.5*poles*flux_linkage*I_qm;
    
    % Get B from aerodynamic force
    aero_force = 0.5*drag_coeff*air_density*frontal_area.*speed.^2;
    % aero_force = viscous force 
    % B = aero_force./speed;
    shaft_trq = 0.5*traction_torque;
    friction_trq = friction_coeff*mass_vehicle*g*1; % unit revolution

            %     syms t
            %     f = moment_interia*t + B + friction_trq + shaft_trq;
            %     d = diff(f);
            %     w_m = w_motor;
            %     mechanical_trq = subs(d,t,w_m);


% Generator
    
    %Given
    rated_power =92;
    moment_interia_gen = 0.05;
    moment_interia_ICE = 0.08;
    eff_gen = 0.85;
    friction_trq_gen = rated_power*0.15/2;
    w_rg = (engine_torque - gear_ratio*(electromagnetic_trq + friction_trq_gen)/(moment_interia_ICE + gear_ratio^2*moment_interia_gen));
    w_g = poles*w_rg;


    

    


    % Rectifier

    i_rec = 1.5*eff_inv*(d_di*i_dm + d_qi*i_qm);

    % DC voltage

            %     i_h = v_dc + i_inv - i_rec;

    
    

    
    
    t_g = 0:2;
    t_m = linspace(0,0.55,12);
    plot(time,speed)
    plot(time,N_wheels)
    plot(t_m,N_motor)
    plot(electromagnetic_trq)
%     plot(t_g,w_g)
    plot(time,v_dc);



