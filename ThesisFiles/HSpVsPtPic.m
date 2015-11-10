function HSpVsPtPic(in,out,t)

DataNeeded=0;
Burst=0.1;
in=6;out=10;t=0.1
if(DataNeeded)
    [PtConc,r]=Pt3dDist(0,20,Burst,t,20)
    [HSpConc,r1]=HolSphereDist(0,20,Burst,t,in,out,20)
    dthesisdat
    PtConc=PtConc*4*pi*(out^3-in^3)./3;
    save SteadyStateSpPtData1 PtConc t HSpConc in out r Burst
end
DataNeeded=0;
Burst=0.1;
in=6;out=10;t=0.2
if(DataNeeded)
    [PtConc,r]=Pt3dDist(0,20,Burst,t,20)
    [HSpConc,r1]=HolSphereDist(0,20,Burst,t,in,out,20)
    dthesisdat
    PtConc=PtConc*4*pi*(out^3-in^3)./3;
    save SteadyStateSpPtData2 PtConc t HSpConc in out r Burst
end
load SteadyStateSpPtData1
[h1,h2]=SubPlot2(gcf);
C=MirrorVec(PtConc);
C1=MirrorVec(HSpConc);
r=MirrorVecMinus(r);
subplot(h1)
plot(r,C,'b',r,C1,'r:')
Setbox;
xlabel('Distance (\mum)')
ylabel('Concentration (\muM)');
legend('Point-source','Hollow sphere');
SetYTicks(gca,4,1e6)
SetXTicks(gca,5)


load SteadyStateSpPtData2
C=MirrorVec(PtConc);
C1=MirrorVec(HSpConc);
r=MirrorVecMinus(r);
subplot(h2)
plot(r,C,'b',r,C1,'r:')
Setbox;
xlabel('Distance (\mum)')
ylabel('Concentration (\muM)');
legend('Point-source','Hollow sphere');
SetYTicks(gca,4,1e6)
SetXTicks(gca,5)