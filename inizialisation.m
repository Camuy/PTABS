function [A, B, Fgal, dumper] = inizialisation(c_pto, k_pto, y)
%INIZIALISATION c_pto [N/m/s]
%   Function to innizialize the problem
%   geometrical definitions and 

% load information of the bodies from the simulation
for i = {'constraint', 'pto', 'simu', 'body'}
    filename = '/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/Data/' + string(i) + '.mat';
    load(filename);
end

disp("Inizialisation started")
%% DEFINITION OF THE GEOMETRIC PARAMETER

disp("Load .stl geometry")

% Import .stl models and get geometrical and inertial informations
float_stl = stlread('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/geometry/Float_high_quality.stl');
%stlPlot(float_stl.Points, float_stl.ConnectivityList, 'Float');
spear_stl = stlread('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/geometry/Plate_high_quality.stl');
%stlPlot(spear_stl.Points, spear_stl.ConnectivityList, 'Spear');

%% Volume function def
load('Vol.mat', 'Vol')
for i = 1:length(Vol.z)
Vol.advanced.d(1, i) = Vol.spar_vol(1, i) + (Vol.spar_max_vol(1, i) - Vol.spar_vol(1, i))*(1-exp(-(Vol.z(i)+Vol.z(5300))/1.5));
Vol.advanced.e(1, i) = Vol.spar_vol(1, i) + (Vol.spar_max_vol(1, i) - Vol.spar_vol(1, i))*(1-exp(-(Vol.z(i)+Vol.z(4500))/0.3));
end

Vol.advanced.d = [Vol.spar_vol(1:4700), Vol.advanced.d(4701:10000)];
Vol.advanced.e = [Vol.spar_vol(1:5500), Vol.advanced.e(5501:10000)];

% creation of Fgal
Fgal.z = Vol.z;
Fgal.normal = simu.gravity.*simu.rho.*[Vol.float_vol; Vol.spar_vol];
Fgal.advanced.e = simu.gravity.*simu.rho.*Vol.advanced.e;
Fgal.advanced.d = simu.gravity.*simu.rho.*Vol.advanced.d;
Fgal.advanced.max = simu.gravity.*simu.rho.*Vol.spar_max_vol;

%plot(Vol.z, Vol.float_vol, Vol.z, Vol.spar_vol, Vol.z, Vol.spar_max_vol, Vol.z, Vol.advanced.e,  Vol.z, Vol.advanced.d), grid on, hold on
%legend('Float', 'Spar_{normal}', 'Spar_{adv-max}', 'Spar_{adv-e}', 'Spar_{adv-d}'), hold on


%% Matrix definitions
disp("Matrixes definition")
a_1 = 18*1000;
a_2 = 1.67*1000;
body(1).mass = body(1).mass; %*0.8;
body(2).mass = body(2).mass; %*1.2;
fprintf('density normal float:\t\t%f [kg/m^3]\ndensity normal spar:\t\t%f [kg/m^3]\ndensity advanced spar:\t\t%f [kg/m^3]\n', (body(1).mass)/Vol.float_vol(end),(body(2).mass)/(Vol.spar_vol(end)), (body(2).mass)/(Vol.spar_max_vol(end)))
fprintf('density normal system:\t\t%f [kg/m^3]\ndensity advanced system:\t%f [kg/m^3]\n', (body(1).mass + body(2).mass)/(Vol.spar_vol(end) + Vol.float_vol(end)), (body(1).mass + body(2).mass)/(Vol.spar_max_vol(end) + Vol.float_vol(end)))

M = [[body(1).mass + a_1, 0]; [0, body(2).mass + a_2]];

if (body(1).mass + body(2).mass)/(Vol.spar_vol(end) + Vol.float_vol(end)) > 1000
    fprintf('error wrong density: system = %f [kg/m^3]\n', (body(1).mass + body(2).mass)/(Vol.spar_vol(end) + Vol.float_vol(end)))
end
A = [M, zeros(2); zeros(2), M];

%C = [[c_pto + c_1, -c_pto];[-c_pto, c_pto + c_2]]
C = [[c_pto, -c_pto];[-c_pto, c_pto]];

% to define the rho matrix changing over time

Fg = simu.gravity.*[body(1).mass; body(2).mass];

% definition forces
save('Fgal.mat', "Fgal")

%Fgal.normal = smoothdata(Fgal.normal, 2);
%Fgal.ex = smoothdata(Fgal.ex);

Fgal.normal = Fgal.normal - ones(1, length(Fgal.advanced.e)).*Fg;
Fgal.advanced.max = Fgal.advanced.max - ones(1, length(Fgal.advanced.max)).*Fg(2);
%% Force evaluation
% Trova lo zero della funzione interpolata nell'intervallo specificato
fx_0 = @(x) interp1(Fgal.z, Fgal.normal(1, :) + Fgal.normal(2, :), x);
Fgal.x_0 = fzero(fx_0, 0);

%Fgal.diff = [diff(Fgal.normal(1, :), 1)./(Fgal.z(2)-Fgal.z(1)); diff(Fgal.normal(2, :), 1)./(Fgal.z(2)-Fgal.z(1))];
%Fgal.diff_ex = diff(Fgal.ex, 1)./(Fgal.z(2)-Fgal.z(1));

%Fgal.diff = smoothdata(Fgal.diff, 2, 'gaussian');
%Fgal.diff_ex = smoothdata(Fgal.diff_ex,1, 'gaussian');


%Fgal.zdot = linspace(Fgal.z(1), Fgal.z(length(Fgal.z)), length(Fgal.z)-1);

%Fgal.diff_x0 = [interp1(Fgal.zdot, Fgal.diff(1, :), Fgal.x_0); interp1(Fgal.zdot, Fgal.diff(2, :), Fgal.x_0)];
K = [[k_pto, -k_pto]; [-k_pto, k_pto]];

B = [C, K; -M, zeros(2)];

Fgal.b = [1.8 * 1000 * 0.785; 3000];

Fgal.g.z = [linspace(-1000, 0.001, 100), linspace(0, 1000, 100)];
Fgal.g.d = [zeros(1, 100), ones(1, 100)];
Fgal.g.e = [ones(1, 100), zeros(1, 100)];
%Fgal.a.z = [linspace(-4, 0.001, 100), linspace(0, 4, 100)];
%Fgal.a.a = -Fgal.a.z./4;

[Fgal.a.z.xd,Fgal.a.z.xdd] = meshgrid(flip(linspace(-2, 2, 1000)), flip(linspace(min(y)*(1.1), max(y)*(1.1), 1000)));

Fgal.a.a = (-(Fgal.a.z.xd + Fgal.a.z.xd(1)).^(1/2)).*((Fgal.a.z.xdd + Fgal.a.z.xdd(1)).^2);
%Fgal.a.a = ((Fgal.a.z.xd + Fgal.a.z.xd(1)).^(4)).*(-(Fgal.a.z.xdd + Fgal.a.z.xdd(1)).^(1/4));
Fgal.a.a = Fgal.a.a./max(Fgal.a.a(1));

%mesh(Fgal.a.z.xd ,Fgal.a.z.xdd ,Fgal.a.a)
%plot(Fgal.g.z, Fgal.g.d, Fgal.g.z, Fgal.g.e);

%% Dumper functions
% 1: down       2: up

k = pto.hardStops.lowerLimitStiffness/100;
c = pto.hardStops.lowerLimitDamping/100;
dumper.l = 0.3;
dumper.x1 = -1; %constraint.hardStops.lowerLimitBound;
dumper.x2 = 2; %constraint.hardStops.upperLimitBound;
dumper.z = [linspace(-10, 0.001, 10), linspace(0, 10, 1000)];
dumper.k1 = [zeros(1, 10), ones(1, 1000)].*k;
dumper.k2 = [zeros(1, 10), ones(1, 1000)].*k;
dumper.c1 = [zeros(1, 10), ones(1, 1000)].*c;
dumper.c2 = [zeros(1, 10), ones(1, 1000)].*c;

[dumper.stop.xd1, dumper.stop.xd2] = meshgrid(flip(linspace(-2, 2, 1000)));
dumper.stop.z  = [zeros(length(dumper.stop.xd1)/2), zeros(length(dumper.stop.xd1)/2); zeros(length(dumper.stop.xd1)/2), ones(length(dumper.stop.xd1)/2)];
%mesh(dumper.stop.xd1, dumper.stop.xd2, dumper.stop.z)
dumper.stop.c = dumper.stop.z*c/100;
dumper.stop.k = dumper.stop.z*k/100;


%% Plot forces results
%figure(2)
%plot(x0(1, :)), hold on;
%plot(x0(2, :)), grid on;
disp("First plot set")
figure(9)
sp(1) = subplot(212);
plot(Fgal.z, Fgal.normal, Fgal.z, Fgal.advanced.max), grid on, hold on;
legend('Fgal_{float}', 'Fgal_{spar}', 'Fgal_{adv-max}');
title('Forces')
ylabel("Galileo's Force [N]")
xlabel('Displacement [m]')

sp(2) = subplot(211);
plot(Vol.z, Vol.float_vol, Vol.z, Vol.spar_vol, Vol.z, Vol.spar_max_vol), grid on, hold on
legend('Float', 'Spar_{normal}', 'Spar_{adv-max}'), hold on
%plot(Fgal.zdot, Fgal.diff(1,:), Fgal.zdot, Fgal.diff(2,:), Fgal.zdot, Fgal.diff_ex), grid on;
%legend('Fgal_{float} diff', 'Fgal_{spar} diff');
title('Volume')
ylabel('Volume [m^3]')
xlabel('Displacement [m]')

disp("Inizialisation ended")
end