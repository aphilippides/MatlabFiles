function StrengthCompFig

SingPlot(gcf);
dmat 
cd NewStrength/Structuresdatas
load holsp_100burst_0.01d_100;
max(sphere_conc)
plot(time,sphere_conc*100./max(sphere_conc),'b- .')
SquareConc=sphere_conc;
T=time;
hold on
load S_sp_100burst_0.01d_100;
max(sphere_conc)
plot(time,sphere_conc*100./max(sphere_conc),'r:x')
hold off
SetXLim(gca,0,0.02)
xlabel('Time (s)');
ylabel('Concentration (% of CMax)');
Setbox;
SpikeConc=sphere_conc;
dthesisdat
save SpikeVsSquareData.mat SpikeConc T SquareConc