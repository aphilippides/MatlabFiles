function ProductionRatePics

dthesisdat;
[h1,h2]=SubPlot2(gcf);

subplot(h2)
load hsp_10_Q;
Fs=1.0e-6./(maxes);
PRs=Fs.*0.04
ProdRates=PRs*1.324e-4/PRs(3)
plot(inners,PRs,'b- .')
SPt=Pt3dss(0.5,5);
SPt10=Pt3dss(10,5);
Vs=pi.*4*[0.125, 1000, 1000-6^3]/3;
Pts=1e-6./[PtSS(0.5,5),PtSS(10,5),PtSS(10,5)]
PtPRs=Pts./Vs
xlabel('Inner radius (\mum)')
ylabel('Production rate, Q\rho (x10^{-4} mol\mum^{-3}s^{-1})')
axis tight
SetYTicks(gca,5,1e4,2)
%SetXTicks(gca,4,1,1,inners)
Setbox
subplot(h1)
DataNeeded=0;
if(DataNeeded) 
    [HSpConc,tsp]=HolSphereTime(eps,15,15,10,6,10,100);
    [PtConc,tpt]=Pt3dTime(eps,1,15,0.5,100);
    HSpConc=HSpConc*1e-6/max(HSpConc);
    PtConc=PtConc./0.00331;
    save ProdRateData.mat HSpConc tsp tpt PtConc ProdRates inners
end
load ProdRateData.mat;
plot(tsp,HSpConc,'b')%,tpt,PtConc,'r:')
%legend('Hollow sphere','Point Source');
axis tight
xlabel('Time (s)')
ylabel('Concentration (\muM)')
SetYTicks(gca,4,1e6)
Setbox

function[C]=PtSS(x,t_half)

k=-sqrt(log(2)/(3300*t_half));
C=(1/(4.*pi.*x.*3300)).*exp(k.*x);
