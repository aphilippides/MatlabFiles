function ThreshLimsPic

colors=[];
load Fig1Data/LimitsB1.mat
subplot(1,2,1)
plot(TubeRadii*2,RThresh./TubeRadii,'g--')
hold on
subplot(1,2,2)
plot(TubeRadii*2,RThresh,'g--')
hold on

Burst=4
fname2=['Fig1Data\TubeThreshLimitsDiam2_50B' x2str(Burst) '.mat'];
load(fname2)
whos
subplot(1,2,1)
plot(TubeRadii*2,ThresholdRadii)
subplot(1,2,2)
plot(TubeRadii*2,ThresholdDist)

Burst=5
fname2=['Fig1Data\TubeThreshLimitsDiam2_50B' x2str(Burst) '.mat'];
load(fname2)
subplot(1,2,1)
plot(TubeRadii*2,ThresholdRadii,'r:')
xlabel('Tube Diameter (\mu m)')
ylabel('Threshold Distance (no. of radii from centre)')
legend('Burst=1s','Burst=4s','Burst=5s',0)
subplot(1,2,2)
plot(TubeRadii*2,ThresholdDist,'r:')
xlabel('Tube Diameter (\mu m)')
ylabel('Threshold Distance (\mu m from centre)')
legend('Burst=1s','Burst=4s','Burst=5s',0)
