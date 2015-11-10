function WidthDiffsThes

[h1,h2,h3,h4]=SubPlot4(gcf);
Ws=[1,2,3,4,5];
subplot(h1)
PlotDelays
subplot(h2)
PlotOvers(Ws)
subplot(h3)
PlotMaxes(Ws)
subplot(h4)
ShowSliceAvgDiffs3d(1000,20,150,200)


function PlotDelays
load Times2RiseV50_79SSt1Gr300X100Sq1;
errorbar(wid,AvgT*1000,SDT*1000);
xlabel('Diameter (\mum)');
ylabel('Time (ms)');
Setbox;
axis tight

function PlotOvers(W)
for i=1:length(W)
    fn=['MaxW'x2str(W(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl1.mat'];
	load(fn);
    ind=find(Times==1);
    o1(i)=OverAvg(ind);   
    s1(i)=OverStd(ind);
    fn=['MaxW'x2str(W(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl4.mat'];
	load(fn);
    ind=find(Times==1);
    o4(i)=OverAvg(ind);   
    s4(i)=OverStd(ind);
end
errorbar([W;W]',[o1;o4]',[s1;s4]',['b-';'r:']');
legend('Synth vol.','Whole vol',4)
xlabel('Diameter (\mum)');
ylabel('Volume over threshold (x10^5 \mum^3)');
SetYTicks(gca,5,1e-5,1,[5:8]*1e5)
Setbox;
axis tight

function PlotMaxes(W)
for i=1:length(W)
    fn=['MaxW'x2str(W(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl1.mat'];
	load(fn);
    ind=find(Times==1);
    o1(i)=MaxAvg(ind)  
    s1(i)=MaxStd(ind);
end
o1(3)=o1(3)/1.324e-4;
s1(3)=s1(3)/1.324e-4;
errorbar([W],[o1]*1.324e2,[s1]*1.324e2);
Setbox;
xlabel('Diameter (\mum)');
ylabel('Maximum concentration (\muM)');
axis tight
