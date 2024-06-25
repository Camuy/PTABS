
function plot_H(H_1, H_2, H_3, freq)
% plot the H(w) function
H_1 = symvar(H_1);
H_2 = symvar(H_2);
H_3 = symvar(H_3);

H_1_abs = abs(H_1);
H_1_ang = 90 - angle(H_1)*180/pi;

H_2_abs = abs(H_2);
H_2_ang = 90 - angle(H_2)*180/pi;

H_3_abs = abs(H_3);
H_3_ang = 90 - angle(H_3)*180/pi;


figure(2)
sp(1)=subplot(211);
mesh(H_1_abs), grid on, hold on
mesh(H_2_abs), grid on, hold on
mesh(H_3_abs), grid on
legend('H_1', 'H_2', 'H_{1-2}')
zlabel('|H((w)| [1/m]')
ylabel('[Hz]')
xlabel('time')
title('Frequency response function')
hold off

sp(2)=subplot(212);
mesh(90 - angle(H_1)*180/pi), grid on, hold on
mesh(90 - angle(H_2)*180/pi), grid on, hold on
mesh(90 - angle(H_3)*180/pi), grid on
legend('H_1', 'H_2', 'H_{1-2}')
zlabel('\phi [deg]')
ylabel('[Hz]')
xlabel('time')
hold off



end

