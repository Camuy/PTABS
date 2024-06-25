function [M, C, K, h, A, V, rho] = inizialisation(c_pto, k_pto)
%INIZIALISATION c_pto [N/m/s]
%   Function to innizialize the problem

% Data geometry
% booth geometries are cylinders
global g rho_w

r_11 = 1; % [m]
r_12 = 3; % [m]
h_1= 2;

A_1 = pi*(r_12^2-r_11^2);
V_1 = A_1*h_1;

r_21 = 1; % [m]
h_2 = 15;
r_22 = 3; % [m]

A_2 = pi*(r_22^2-r_21^2);
V_2 = A_2*h_2;


h = [h_1, h_2];
A = [A_1, A_2];
V = [V_1, V_2];

rho = [600,600];

% Data Dynamic System
m = V.*rho;
a_12 = 0;
a_21 = 0;

M = [[m(1), a_12]; [a_21, m(2)]]


c_d = 1.15;
c_1 = 0; %2*rho_w*A(1); % dumping factor related to the sharestress value
c_2 = 0; %2*rho_w*A(2); % incert the value of the Drag force

c = [c_1, c_2];

C = [[c_pto + c_1, -c_pto];[-c_pto, c_pto + c_2]]

% to define the rho matrix changing over time

k_1 = rho_w*g*A(1);
k_2 = rho_w*g*A(2);

K = [[k_pto - k_1, -k_pto];[-k_pto, k_pto - k_2]]
end

