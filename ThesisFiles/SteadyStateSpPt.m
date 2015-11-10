function SteadyStateSpPt(Rad,d)

DataNeeded=0;
Burst=2;
if(DataNeeded)
    [PtConc,t]=Pt3dTime(0,4,Burst,d,100)
    [SpConc,t1]=SolSphereTime(0,4,Burst,d,Rad,100)
    dthesisdat
    save SteadyStateSpPtData PtConc t SpConc Rad d Burst
end
dthesisdat
load SteadyStateSpPtData
a=max(PtConc)
C=PtConc./a;
b=max(SpConc)
C1=SpConc./b;
SingPlot(gcf)
plot(t,C*100,'b',t,C1*100,'r:')
Setbox;
xlabel('Time (s)')
ylabel('Concentration (% of max concentration)');
legend('Virtual sphere','Real sphere');
SetYTicks(gca,5)