function temp
dtube;
Diams=[4,3,1];
for i=1:length(Diams)
    d=Diams(i);
    fn=['TubeSurfaceConcTimeDiam' x2str(d) '1B0_1T0_001_60.mat'];
    load(fn)
%    plot(Times,SurfaceConc./SurfaceConc(end));
    plot(Times,SurfaceConc);
    hold on
end
plot([Times(1) Times(end)],[2.5e-7 2.5e-7],'g--')
SetYTicks(gca,4,1e6)
hold off
setbox
ylabel('Fraction of peak concentration')
ylabel('Concentration (\muM)')
xlabel('Synthesis duration (s)')

function dumm
Q=[2:4 6:9 11:15];
for i=1:length(Q)
   GLOBE(Q(i));
   AllLims(Q(i)); 
end
    d=Diams(i);
    fn=['TubeSurfaceConcTimeDiam' x2str(d) 'B0_1T0_001_0_1'];
    load(fn);
    ec=ErrConc;
    sc=SurfaceConc;
    t=Times;
    fname=['Meshpaper/Fig1Data/TubeSurfaceConcTimeDiam'x2str(d) 'B60T0_1_60.mat'];
    load(fname);
    SurfaceConc=[sc SurfaceConc(2:end)];
    Times=[t Times(2:end)];
    ErrConc=[ec ErrConc(2:end)];
    fn=['TubeSurfaceConcTimeDiam' x2str(d) '1B0_1T0_001_60.mat'];
    save(fn,'SurfaceConc','Times','ErrConc')
    figure
    AxisBreakX(Times,SurfaceConc./SurfaceConc(end),1,59.9);
