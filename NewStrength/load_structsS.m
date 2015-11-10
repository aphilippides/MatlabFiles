% file which loads data created by hol_sphere2.m and kept in Structuresdata/
% has data for pt tube and sphere

function load_structsS(temp)

%hold off;

%Times =[0.0025,0.005, .0075,0.01,0.0125,0.015,0.020, 0.025, 0.05 , 0.1,0.20,0.3,0.4,0.5,1,2,4]
Times =[0.0125,0.025, 0.0375, 0.05, 0.0625, 0.075, 0.0875, 0.1, 0.125, 0.15, 0.2, 0.25, 0.3, 0.5, 1, 2, 4, 8]
nin =[''];
BURST_LENGTH =0.55;

for k=1:4

%temp = Times(k);
%hol_sphere2(temp);
%temp = Times(temp);

%filename = ['StructuresdataS/holsp_100burst_' num2str(BURST_LENGTH) 't_' num2str(temp) '.mat'];
filename = ['StructuresdataS/SP2' int2str(k) '_sp_30burst_' num2str(BURST_LENGTH) 't_' num2str(temp) '.mat'];
eval(['load ' filename ]);
sphere_conc = sphere_conc*0.00331;
%tube_conc = tube_conc*0.00331;
%plot(Dist, tube_conc, Dist, sphere_conc); 
plot(Dist, sphere_conc);
%plot(Dist, tube_conc);
hold on;
newn =[ num2str(temp)];
nin = [nin ', ' newn];
end

%titl = ['sphere+ spike burst ' num2str(BURST_LENGTH) ', t= ' nin];
titl = ['sphere no spike burst ' num2str(BURST_LENGTH) ', t= ' nin];
title(titl);
xlabel('Distance (micronss)')
ylabel('Concentration (M)')
hold off;

