function [time, y] = import_wave(name)
% IMPORT_WAVE Summary of this function goes here
%   Detailed explanation goes here
switch name
    case 'real'
        load('Wave_time_Tirieste.mat');
        time = Wave_Spectrum_trieste(1, :);
        y = Wave_Spectrum_trieste(2, :);
    case '3/8'
        load('Wave_normal_3_8.mat');
        time = Wave_normal_3_8(1, :);
        y = Wave_normal_3_8(2, :);
    case 'sin'
        time = linspace(0, 90, 900);
        T = 5;
        A = 1;
        y = A*sin(2*pi()/T*time);
    case 'zero'
        time = linspace(0, 90, 900);
        y = zeros(1, length(time));
end

figure(1)
title("Wave Elevetrion")
plot(time, y), grid on, hold on;
xlabel('time [s]')
ylabel('elevation [m]')
legend('wave')

end

