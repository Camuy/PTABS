disp("Definition of high quality force function")

addpath '/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS'

float_stl = stlread('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/geometry/Float_high_quality.stl');
spar_stl = stlread('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/geometry/Plate_high_quality.stl');
spar_ex_stl = stlread('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/Sim/simulation_1.1_high/geometry/Plate_ex_high_quality.stl');
%stlPlot(spar_ex_stl.Points, spar_ex_stl.ConnectivityList, 'Spar');
load workspace.mat simu

Vol.z = linspace(-10, 10, 10000);
f = waitbar(0,"Galileo's function definition");

for i = 1:length(Fgal.z)
    Vol.spar_vol(1, i) = volcalc(spar_stl, Fgal.z(i));
    Vol.spar_max_vol(1, i) = volcalc(spar_ex_stl, Fgal.z(i));
    Vol.float_vol(1, i) = volcalc(float_stl, Fgal.z(i));
    waitbar(i/length(Fgal.z), f, sprintf("Galileo's function definition"));
end
close(f);

plot(Vol.z, Vol.spar_vol, Vol.z, Vol.spar_max_vol, Vol.z, Vol.float_vol), grid on
%plot(Fgal.z, Fgal.normal, Fgal.z, Fgal.ex);

save('/Users/riccardo/Library/CloudStorage/OneDrive-PolitecnicodiMilano/Ingegneria/Triennale/Thisis/Code_Model/PTABS/Vol.mat', "Vol")
clear all