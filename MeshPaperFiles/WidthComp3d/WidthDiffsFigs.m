function WidthDiffsFigs

Slices=[50,100,150,200,250,300];
d3dmm
wid=[1 4];
Cols=['r:','b '];
h1=figure;
set(h1,'Units','centimeters');
X=get(h1,'Position');
set(h1,'Position',[X(1) X(2) 10 10]);
set(h1,'PaperPositionMode','auto');
PlotMaxFig(h1,Cols,wid);

h2=figure;
set(h2,'Units','centimeters');
X=get(h2,'Position');
set(h2,'Position',[X(1) X(2) 10 10]);
set(h2,'PaperPositionMode','auto');
PlotOverFig(h2,1,Cols,wid);

h3=figure;
set(h3,'Units','centimeters');
X=get(h3,'Position');
set(h3,'Position',[X(1) X(2) 10 10]);
set(h3,'PaperPositionMode','auto');
PlotOverFig(h3,4,Cols,wid);

function PlotMaxFig(FHdl,Cols,wid);
Sl=4;
figure(FHdl);
h=subplot('Position',[0.15 0.3 0.8 0.6]);
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
SetLegend(Cols',{'Source width=1\mum';'Source width=4\mum'},1)
h=subplot('Position',[0.15 0.05 0.8 0.1]);
DrawSynthPulse(h,[Times(1),Times(end)],[0 2],20);

function PlotOverFig(FHdl,Sl,Cols,wid);
figure(FHdl);
h=subplot('Position',[0.15 0.3 0.8 0.6]);
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
SetLegend(Cols',{'Source width=1\mum';'Source width=4\mum'},1)

legend('Source width = 1\mum','Source width = 4\mum',2)
h=subplot('Position',[0.15 0.05 0.8 0.1]);
DrawSynthPulse(h,[Times(1),Times(end)],[0 2],20);
