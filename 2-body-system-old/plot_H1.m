
function plot_H(H, freq)
% plot the H(w) function
H_mod = abs(H);
H_ang = angle(H);

figure
sp(1)=subplot(211);
plot(freq, H_mod), grid on, 
legend('H_1', 'H_2', 'H_{1-2}')
ylabel('|H((w)| [1/m]')
title('Frequency response function')
sp(2)=subplot(212);
plot(freq, 90 - H_ang*180/pi), grid on
legend('H_1', 'H_2', 'H_{1-2}')
ylabel('\phi [deg]')
xlabel('[Hz]')


end

