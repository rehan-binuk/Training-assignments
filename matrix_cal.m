addpath 'C:\Users\Rehan Binu Kuruvilla\Dropbox\My PC (LAPTOP-G5PALJDQ)\Documents\MATLAB\lib\func'

data_1 = readmatrix("data\vehicle_data\Vehicle_data.xlsx");

% Vehicle Selection
flag = 0;
while flag == 0
a = input("Enter vehicle type : \n   1. SUV   2. Sedan   3. Minivan \n");
if a == 1
    fprintf("You have chosen SUV. \n");
    x5 = data_1(1,2);   % mass
    x1 = data_1(1,3);   % drag_coeff
    x3 = data_1(1,4);   % frontal area
    flag = 1;
elseif a == 2
    fprintf("You have chosen Sedan. \n")
    x5 = data_1(2,2);
    x1 = data_1(2,3);
    x3 = data_1(2,4);
    flag = 1;
elseif a == 3
    fprintf("You have chosen Minivan. \n")
    x5 = data_1(3,2);
    x1 = data_1(3,3);
    x3 = data_1(3,4);
    flag = 1;
else
    fprintf("You have to choice from the available options. \n");
    flag = 0;
end
end                                               

% Tyre Selection

tyre_data = readmatrix("data\tyre_data\tyresize.xlsx");
f = 0;
while f == 0
b = input("\nEnter size of tyre: \n   1. 185/55R16  2. 185/55R17  3. 185/50R18 \n ");
if b == 1
    fprintf("You have chosen 185/55R16 tyre. \n");
    tyre_width = tyre_data(1,1);
    profile = tyre_data(1,2);
    rim_radius = tyre_data(1,3);
    f = 1;
elseif b == 2
    fprintf("You have chosen 185/55R17 tyre. \n");
    tyre_width = tyre_data(2,1);
    profile = tyre_data(2,2);
    rim_radius = tyre_data(2,3);
    f = 1;
elseif b == 3
    fprintf("You have chosen 185/50R18 tyre. \n");
    tyre_width = tyre_data(3,1);
    profile = tyre_data(3,2);
    rim_radius = tyre_data(3,3);
    f = 1;
else 
    fprintf("You have to choice from the available options. \n");
    flag = 0;
end
end

x9 = r_r(tyre_width,profile,rim_radius);

% Drive cycle Selection

fl = 0;
while fl == 0
c = input("\nEnter which Drive cycle need to be calculated : \n");
if c == 1
    data = readmatrix("data\drive_cycle\drive_cycle_1.xlsx");
    fl = 1;
elseif c == 2
    data = readmatrix("data\drive_cycle\drive_cycle_2.xlsx");
    fl = 1;
elseif c == 3
    data = readmatrix("data\drive_cycle\drive_cycle_3.xlsx");
    fl = 1;
else 
    fprintf('Wrong option \n');
    fl = 0;
end
end

% Data Set

speed = data(:,2);
%  x1 = 0.4; drag_coeff
x2 = 1.225;
%  x3 = 3; frontal area
x4 = velocity_conv(speed,x9);
%  x5 = 1500; mass of vehicle
x6 = 9.81;
x7 = 0.5;
x8 = 10;
% x9 = 0.25; 

% Calculation

rolling_resistance = rolling_resist(x1,x2,x3,x4,x5,x6,x7,x8);
display(rolling_resistance)
torque = trq(x1,x2,x3,x4,x5,x6,x7,x8,x9);
display(torque)
speed_rad_per_s = velocity_conv(x4,x9);
display(speed_rad_per_s)

run('C:\Users\Rehan Binu Kuruvilla\Dropbox\My PC (LAPTOP-G5PALJDQ)\Documents\MATLAB\motor_data.m')

% % Plot
% 
% speed_vs_torque = plot(speed_rad_per_s,torque,'--');
% xlabel('Speed (rad/s)')
% yyaxis right
% ylabel('Torque (N/m)')
% hold on
% speed_vs_rolling_resistance = plot(speed_rad_per_s, rolling_resistance, '--');
% yyaxis left
% ylabel('Rolling Resistance')
% legend({'y = Torque','y = Rolling Resistance'},'Location','east')
% 
% display(speed_vs_torque)


