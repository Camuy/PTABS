function [H_1, H_2, H_12] = H_eval(w_w, M, C, K, Fy)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

syms f

disp("H evaluation started")
w = 2*pi*f;
Lambda = -w.^2.*M + 1i.*w.*C + K;
    
H = Lambda\Fy;
H_1 = [1,0]*H;
H_2 = [0,1]*H;
H_12 = [1,-1]*H;

figure(5)

sp(1) = subplot(211);
fsurf(abs(H_1), [-2*pi/w_w 2*pi/w_w 0 1], 'red'), grid on, hold on
fsurf(abs(H_2), [-2*pi/w_w 2*pi/w_w 0 1], 'green'), grid on, hold on
fsurf(abs(H_12), [-2*pi/w_w 2*pi/w_w 0 1], 'blue'), grid on, hold off
legend('H_1', 'H_2', 'H_{1-2}')
xlabel('time [s]')
ylabel('frequency [Hz]')
zlabel('function resoponce')

sp(2) = subplot(212);
fsurf(90 - angle(H_1)*180/pi, [-2*pi/w_w 2*pi/w_w 0 1], 'red'), grid on, hold on
fsurf(90 - angle(H_2)*180/pi, [-2*pi/w_w 2*pi/w_w 0 1], 'green'), grid on, hold on
fsurf(90 - angle(H_12)*180/pi, [-2*pi/w_w 2*pi/w_w 0 1], 'blue'), grid on, hold off
legend('H_1', 'H_2', 'H_{1-2}')
xlabel('time [s]')
ylabel('frequency [rad/s]')
zlabel('angle resoponce')

disp('H evaluation ended')

end

