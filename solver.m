function [x, x_d] = solver(y, time, A, B, F, dumper)
disp("Solver started")

for i = {'waves'}
    filename = '/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/Data/' + string(i) + '.mat';
    load(filename);
end

x0 = [0; -0.5; 0; 0];

[tout, xout] = ode45(f_ode(A, B, F, y, time, dumper), time, x0);

x = xout(:, :).';
time = tout;
for i = 1:length(x(1,:))
    Ftot.body1(i) = interp1(F.z, F.normal(1, :), real(y(i) - x(3, i)));
    Ftot.body2.normal(i) = interp1(F.z, F.normal(2, :), real(y(i) - x(4, i)));
    x_12(i) = [1,-1]*x(3:4, i);
end

t_d = linspace(0, time(end), length(x)-1);
t_dd = linspace(0, time(end), length(x)-2);
a(1, :) = diff(x(1, :) , 1)/(time(2)-time(1));
a(2, :) = diff(x(2, :) , 1)/(time(2)-time(1));
x_d = diff(x_12, 1)/(time(2)-time(1));
x_dd = diff(x_d, 1)/(t_d(2)-t_d(1));



figure(11)

sp(1)=subplot(211);
plot(time, Ftot.body1, time, Ftot.body2.normal), grid on, hold on
title('Total Forces')
ylabel('Total Forces [N]')
xlabel('time [s]')

sp(2)=subplot(212);
plot(time, real(x(3:4, :))), grid on, hold on
plot(time, real(x_12)), grid on, hold on
legend('x_1', 'x_2', 'x_{1-2}')
title('Model Responce')
ylabel('x model [m]')
xlabel('time [s]')

figure(12)
sp(1) = subplot(211);
plot(time, real(x(1:2, :))), grid on, hold on
plot(t_d, real(x_d)), grid on, hold on
legend('v_1', 'v_2', 'v_{2-1}')
title('Velocity')
ylabel('v_{pto} [m/s]')
xlabel('time [s]')

sp(2) = subplot(212);
plot(t_d, real(a)), grid on, hold on
plot(t_dd, real(x_dd)), grid on
legend('a_1', 'a_2', 'a_{2-1}')
title('Aceleration')
ylabel('a_{pto} [m/s^2]')
xlabel('time [s]')

x = x(3:4, :);

disp("Solver ended")
end