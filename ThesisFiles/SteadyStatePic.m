function SteadyStatePic(TPt,RPt,TSp,RSp,Rad,NumPts)

if(nargin<6) NumPts=1000; end;
if(nargin<4) RSp=50; end;
if(nargin<5) Rad=50; end;
if(nargin<3) TSp=5; end;
if(nargin<2) RPt=0.5; end;
if(nargin<1) TPt=0.25; end;

dthesisdat
[h1,h2]=SubPlot2(gcf);
DataNeeded=0;
if(DataNeeded)
    GetPtData(TPt,RPt,NumPts);
end
fn=['SteadyStatePicPtDataD' x2str(RPt) 'T'x2str(TPt) '.mat'];
load(fn);
subplot(h1);
plot(T,Conc./SSVal,[T(1) T(end)],[1 1],'r:');
set(gca,'Box','off','TickDir','out')
h=legend('3D pt source','Steady-state',4),
SetYLim(gca,0,1.01)
SetXLim(gca,-0.005,TPt)
ylabel('Concentration (% of steady-state)')
xlabel('Time (s)')
SetXTicks(gca,6)
SetYTicks(gca,5,100)
ConcsPC=Conc(1:20)*100./SSVal
T(1:20)*1000

subplot(h2);
DataNeeded=0;
if(DataNeeded)
    GetSpData(TSp,RSp,Rad,NumPts);
end
fn=['SteadyStatePicSpDataD' x2str(RSp) 'T'x2str(TSp) 'Rad'x2str(Rad) '.mat'];
load(fn);
plot(T,Conc./max(Conc));
set(gca,'Box','off','TickDir','out')
h=legend('Solid sphere',4),
SetYLim(gca,0,1)
SetXLim(gca,-0.01,TSp)
ylabel('Concentration (% of maximum)')
xlabel('Time (s)')
SetXTicks(gca,6)
SetYTicks(gca,5,100)

function GetPtData(TPt,RPt,NumPts)
GLOBE;
global LAM;
t_half=log(2)/LAM;
[Conc,T]=Pt3dTime(0,TPt,TPt,RPt,NumPts);
SSVal=Pt3dSS(RPt,t_half)*0.00331;
fn=['SteadyStatePicPtDataD' x2str(RPt) 'T'x2str(TPt) '.mat'];
save(fn,'T','Conc','SSVal');

function GetSpData(TSp,RSp,Rad,NumPts)

[Conc,T]=SolSphereTime(0,TSp,TSp,RSp,Rad,NumPts);
fn=['SteadyStatePicSpDataD' x2str(RSp) 'T'x2str(TSp) 'Rad'x2str(Rad) '.mat'];
save(fn,'T','Conc');
