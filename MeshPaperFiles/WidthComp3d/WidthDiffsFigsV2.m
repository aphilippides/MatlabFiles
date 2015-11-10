function WidthDiffsFigsV2

Slices=[50,100,150,200,250,300];
d3dmm
wid=[1 5];
Cols=['r:','b '];
SingPLot(gcf)

PlotMaxFig(gcf,Cols,wid);

FigHdl=figure;
[h1,h2]=SubPlot2(FigHdl);
subplot(h1)
Times=PlotOverFig(1,Cols,wid);
subplot(h2)
Times=PlotOverFig(4,Cols,wid);
%h=subplot('Position',[0.1 0.05 0.375 0.1]);
%DrawSynthPulse(h,[Times(1),Times(end)],[0 2],20);
%h=subplot('Position',[0.6 0.05 0.375 0.1]);
%DrawSynthPulse(h,[Times(1),Times(end)],[0 2],20);

function[Times]=PlotMaxFig(FHdl,Cols,wid);
Sl=4;
figure(FHdl);
%h=subplot('Position',[0.15 0.3 0.8 0.6]);
for i=1:2
	Col=Cols(:,i);
	fn=['MaxW'x2str(wid(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
	load(fn);
	errorbar(Times,MaxAvg*1.324e-4,MaxStd*1.324e-4,Col);hold on;
   axis('tight');
end
hold off;
SetYTicks(gca,5,1e6)
ylabel('Max concentration (\muM)');
xlabel('Time (s)');
set(gca,'Box','off','TickDir','out')
SetLegend(Cols',{'1\mum';'5\mum'},1)
%subplot('Position',[0.15 0.05 0.8 0.1]);
%DrawSynthPulse(h,[Times(1),Times(end)],[0 2],20);
SetXLim(gca,0,2)

function[Times]=PlotOverFig(Sl,Cols,wid);

for i=1:2
	Col=Cols(:,i);
	fn=['MaxW'x2str(wid(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
	load(fn);
	errorbar(Times,OverAvg,OverStd,Col);hold on;
   axis('tight');
end
hold off;
ylabel('Volume over threshold (x10 ^5 \mum^3)');
SetYTicks(gca,5,1e-5);
Y=get(gca,'YLim')
axis([0 2.5 0 Y(2)])
xlabel('Time (s)');
set(gca,'Box','off','TickDir','out')
%SetLegend(Cols',{'Source width=1\mum';'Source width=4\mum'},1)
SetLegend(Cols',{'1\mum';'5\mum'},1)
SetXLim(gca,0,2)
%legend('1\mum','5\mum',2)
