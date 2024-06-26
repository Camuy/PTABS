clear global
close all

for i = {'body', 'constraint', 'mooring', 'output', 'pto', 'simu', 'waves'}
    filename = '/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/Data/' + string(i) + '.mat';
    load(filename);
end

% wave data

[time, y] = import_wave('real');     % select one of between: 'real', '3/8', 'sin', 'zero'

pto.damping = 10000;

[A, B, F, dumper] = inizialisation(pto.damping, pto.stiffness*0, y); % pto.dumping = 10000, pto.stiffness = 100000

% Create a function to optimize c_pto and k_pto over time.

[x, x_d] = solver(y, time, A, B, F, dumper);

[x_ad, x_ad_d, F_v_time] = solver_advanced(y, time, A, B, F, dumper);

P = power_balancing(x_ad, y, x_d, x_ad_d, pto.damping*1, time, F, F_v_time);

fprintf("\nMechanism evaluated\n\n")