function [P] = power_balancing(x_ad, y, x_d, x_ex_d, c_pto, time, F, F_v_time)
%POWER_BALANCING Summary of this function goes here
%   Detailed explanation goes here
disp('Power balancing started')

for i = {'body', 'output', 'simu', 'waves'}
    filename = '/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/Data/' + string(i) + '.mat';
    load(filename);
end 
%for i = 1:length(F_v_time.body2.normal)
%    F_v(i) = F_v_time.body2.advanced(i) - F_v_time.body2.normal(i);
%end
F_v = F_v_time.body2.advanced;

%% PTO Power extraction
time_d = linspace(0, time(end), length(time)-1);
time_dd = linspace(0, time(end), length(time)-2);
%Fpto = Ftot(1,:) - Ftot(2,:);

%E_pto = x.*Fpto; % Energy extracted

%P_pto = diff(E_pto, 1); % Power extracted
F_c = c_pto.*x_d;
P.c = -abs(c_pto.*x_d.^2);

F_c_ad = c_pto.*x_ex_d;
P.c_ad = -abs(c_pto.*x_ex_d.^2);

x_h_m = 6; % 3*1.5/2;

h = real(y - x_ad(2) + x_h_m);

P_p = diff(h.*F_v(:), 1)/(time(2)-time(1));

for i = 1:length(time_d)
    P.ad(1,i) = P_p(i) - abs(interp1(time_d, P.c_ad, time_d(i)));
end

P_med = [trapz(real(P.c))/length(time)*ones(size(P.c)); trapz(real(P.ad))/length(time)*ones(size(P.ad))]; % avaraged power extraction
%P_med = [mean(P.c, 2).*ones(size(P.ad)); mean(P.ad, 2).*ones(size(P.ad))];

figure(8)
%plot(linspace(0,3*waves.period, length(P_pto)), real(P_pto)), grid on, hold on
sp(1) = subplot(211);
plot(time_d, real(P.c), time_d, real(P.c_ad), time_d, real(P.ad), time_d, P_med), grid on, hold on
xlabel('time [s]');
ylabel('Power [W]');
legend('P_{pto}', 'P_{pto-AD}', 'P_{AD-tot}', 'P_{med}', 'P_{AD-med-tot}');
title('Advanced Model Power Extraction');

sp(2) = subplot(212);
plot(output.ptos.time, -c_pto.*output.ptos.velocity(:, 3).^2, output.ptos.time, trapz(-c_pto.*output.ptos.velocity(:, 3).^2)./length(output.ptos.time)*ones(length(output.ptos.time))), grid on, hold on;
xlabel('time');
ylabel('Power [W]');
legend('P_{simulation}', 'P_{med}');
title('Simulation Power Extraction');



%% Define the volume changing energy 

% p = - g*rho_w*(h_0);

%figure(7)
%sp(1) = subplot(211);
%fplot(real(h_0))
%xlabel('time [s]')
%ylabel('meter [m]')
%legend('h_{0_2}')

%sp(1) = subplot(212);
%fplot(real(p))
%xlabel('time [s]')
%ylabel('Pressure [Pa]')
%legend('p_2')


% E = p.*(A*[0; 0; 1]).*(h*[0; 0; 1]);
%P_in = p.*diff(A*[0; 0; 1], t).*(h*[0; 0; 1]); % power to move the mechanism

%P = P_ext + P_in;
%P_med = vpaintegral(P, [-pi pi])/(2*pi);
%P_in_med = vpaintegral(P_in, [-pi pi])/(2*pi);

%figure(6)
%sp(1) = subplot(211);
%fplot(real(P_ext)), grid on, hold on,
%fplot(real(P_in)), grid on, hold on,
%fplot(real(P)), grid on, hold on,
%fplot(real(P_med)), grid on, hold on,
%fplot(real(P_in_med)), grid on, hold off,
%xlabel('time [s]')
%ylabel('Power [W]')
%legend('P_{ext}', 'P_{in}', 'P_{net}', 'P_{med}', 'P_{in-med}')



%sp(2) = subplot(212);
%xlabel('time [s]')
%ylabel('Energy [J]')
%plot(real(E)), grid on, hold on,

%fplot(real(E)), grid on, hold on,
%fplot(imag(P_in)), grid on, hold on,
%fplot(imag(P)), grid on, hold off
%legend('P_{ext}', 'P_{in}', 'P_{net}')


disp('Power balancing ended')

end

