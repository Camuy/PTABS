
function plot_x()
% plot the H(w) function
H_mod = abs(H);
H_ang = angle(H);

figure
sp(1)=subplot(211);
plot(freq, H_mod), grid on, 
ylabel('|H(x_0(w)/y_0| [m/m]')
title('Frequency response function')
sp(2)=subplot(212);
plot(freq, H_ang*180/pi), grid on
ylabel('\phi [deg]')
xlabel('[Hz]')
end

function plot_y()
% plot the H(w) function
H_mod = abs(H);
H_ang = angle(H);

figure
sp(1)=subplot(211);
plot(freq, H_mod), grid on, 
ylabel('|H(x_0(w)/y_0| [m/m]')
title('Frequency response function')
sp(2)=subplot(212);
plot(freq, H_ang*180/pi), grid on
ylabel('\phi [deg]')
xlabel('[Hz]')
end