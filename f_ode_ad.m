function dxdt = f_ode_ad(A, B, Fgal, y, time, dumper)

% load /Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/output/RM3_matlabWorkspace.mat waves

%dxdt =  @(t, x) A\([interp1(Fgal.z, Fgal.normal(1, :), interp1(time, y, t) - x(3)); interp1(Fgal.z, Fgal.ex(:), interp1(time, y, t) - x(4)); 0; 0] - B*x);

h = 0;
% New With Dumpers
dxdt =  @(t, x) A\( ...
    [interp1(Fgal.z, Fgal.normal(1, :), interp1(time, y, t) - x(3)) - interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1)*(dumper.x1 + dumper.l) + interp1(dumper.z, dumper.k2, -(x(4) - x(3) + dumper.l + dumper.x2))*(dumper.x2 - dumper.l); ...
     interp2(Fgal.a.z.xd, Fgal.a.z.xdd, Fgal.a.a, x(2), -interp1(time, y, t)).*interp1(Fgal.z, Fgal.advanced.max(:), interp1(time, y, t) - x(4) - h) + (1-interp2(Fgal.a.z.xd, Fgal.a.z.xdd, Fgal.a.a, x(2), -interp1(time, y, t))).*interp1(Fgal.z, Fgal.normal(2, :), interp1(time, y, t) - x(4) - h) + interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1)*(dumper.x1 + dumper.l) - interp1(dumper.z, dumper.k2, -(x(4) - x(3) + dumper.l + dumper.x2))*(dumper.x2 - dumper.l); ...
    0; ...
    0] - (B + [[1,0;0,1].*Fgal.b + [1,-1;-1,1].*interp2(dumper.stop.xd1, dumper.stop.xd2, dumper.stop.c, x(1), x(2), 'nearest') + [1,-1;-1,1].*interp1(dumper.z, dumper.c1, x(4) - x(3) + dumper.l + dumper.x1) + [1,-1;-1,1].*interp1(dumper.z, dumper.c2, x(3) - x(4) - dumper.l - dumper.x2), [1,-1;-1,1].*interp2(dumper.stop.xd1, dumper.stop.xd2, dumper.stop.k, x(1), x(2), 'nearest') + [1,-1;-1,1].*interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1) + [1,-1;-1,1].*interp1(dumper.z, dumper.k2, x(3) - x(4) - dumper.l - dumper.x2); ...
    -A(1:2, 1:2), zeros(2)])*x);

% singola
%dxdt =  @(t, x) A\( ...
%    [interp1(Fgal.z, Fgal.normal(1, :), interp1(time, y, t) - x(3)) - interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1)*(dumper.x1 + dumper.l) + interp1(dumper.z, dumper.k2, -(x(4) - x(3) + dumper.l + dumper.x2))*(dumper.x2 - dumper.l); ...
%    interp1(Fgal.z, Fgal.advanced.d(:), interp1(time, y, t) - x(4)) + interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1)*(dumper.x1 + dumper.l) - interp1(dumper.z, dumper.k2, -(x(4) - x(3) + dumper.l + dumper.x2))*(dumper.x2 - dumper.l); ...
%    0; ...
%    0] - (B + [[1,0;0,1].*Fgal.b + [1,-1;-1,1].*interp1(dumper.z, dumper.c1, x(4) - x(3) + dumper.l + dumper.x1) + [1,-1;-1,1].*interp1(dumper.z, dumper.c2, x(3) - x(4) - dumper.l - dumper.x2), [1,-1;-1,1].*interp1(dumper.z, dumper.k1, x(4) - x(3) + dumper.l + dumper.x1) + [1,-1;-1,1].*interp1(dumper.z, dumper.k2, x(3) - x(4) - dumper.l - dumper.x2); ...
%    -A(1:2, 1:2), zeros(2)])*x);
end
