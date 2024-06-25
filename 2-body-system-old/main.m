clear all
close all
global g rho_w 
% Data Environment
g = 9.81; % [m/s^2]
rho_w = 1000; % [kg/m^3]
rho_air = 1.2;

    % wave data
f_w = 0.5;
w_w = 2*pi*f_w;
amp_w = 1;

[M, C, K, h, A, V, rho] = inizialisation(20000, 600000);


% Data eleboration

%t = (0:0.01:40).';
% o = [1,-1];
% x_0 = o(1).*v(1,:).*exp(1i.*w_0(1).*t) + o(2).*v(2,:).*exp(1i.*w_0(2).*t);
%
%figure(2)
%sb(1) = subplot(211);
%plot(t, x_0), grid on
%legend('x{0 1}', 'x_{0 2}')
%
% omogeneus response
%
%[v, w, x_0]  = omog_resp(M, C, K, t);
%sb(2) = subplot(212);
%plot(t, x_0), grid on
%legend('x_{0 1c}', 'x_{0 2c}')

%for ii = 1:length(x_w01(1))
%x_w01(3, ii) = x_w01(1, ii) - x_w01(2, ii);
%end

%figure(2)
%sp(1) = subplot(211);
%plot(t, x_w01), grid on,
%legend('x_1', 'x_2', 'x_{1-2}')

freq = (0:0.0001:2);
w = 2*pi*freq.';

for ii = 1:length(freq)
    % Forcing factor
F = -rho_w*g*A;

    % define the frequency responce function

Lambda = -w(ii).^2.*M + 1i.*w(ii).*C + K; %- 1/2*V.*rho*g;
H_0 = 0;
X_0dY_0 = Lambda\F.';

H(1, ii) = X_0dY_0(1);
H(2, ii) = X_0dY_0(2);
H(3, ii) = X_0dY_0(1) - X_0dY_0(2);

end

plot_H1(H, freq)

    % define the movement of the mechanism
Lambda = -w_w.^2.*M + 1i.*w_w.*C + K;
F = -rho_w*g*A ;
H = Lambda\F.';

t = linspace(0, 20, 500);

x_0 = Lambda\(-1/2.*V.*rho*g).';
x = H.*amp_w.*exp(1i.*w_w.*t) + x_0;

for ii=1:length(t)
%x(1, ii) = H(1).*(- V(1).*rho(1)*g + (1i*w_w.*c(1) - g*rho(1).*A(1))*amp_w.*exp(1i.*w_w.*t(1, ii)));
%x(2, ii) = H(2).*(- V(2).*rho(2)*g + (1i*w_w.*c(2) - g*rho(2).*A(2))*amp_w.*exp(1i.*w_w.*t(1, ii)));
x(3, ii) = x(1, ii) - x(2, ii);
end


figure(3)
sp(1)=subplot(211);
plot(t, real(amp_w.*exp(1i.*w_w.*t))), grid on
legend('wave')
title('Sea wave function')
ylabel('y wave [m]')
xlabel('time [s]')
sp(2)=subplot(212);
plot(t, real(x)), grid on
legend('x_1', 'x_2', 'x_{1-2}')
title('Model responce')
ylabel('x model [m]')
xlabel('time [s]')