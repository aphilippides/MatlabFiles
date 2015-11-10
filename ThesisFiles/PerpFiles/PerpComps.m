function PerpComps(GridSize, Density,Slice,Version)

Sqare=1;
colstr='g'
% Get data
filename=['MaxPerpRho' num2str(Density) '/TreeV' int2str(Version) 'MaxGr' num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.dat']
filename2=['../Fast/MaxTreeRho' num2str(Density) '/TreeV' int2str(Version) 'BinsGr' num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.dat']
M=load(filename);
M2=load(filename2);

[X2,Y2]=size(M2);
[X,Y]=size(M);
BinLim=floor(M(X,2)*10000*1.2)

% Get Mean Data
AvgsNeeded=0;
if(AvgsNeeded==1)
   Outputs=GetAvgPlot(MStr ,GridSize, Density,Slice);
   MinMaxHndl=Outputs(1);
	NotHndl=Outputs(2);
	BinHndl=Outputs(3);
else
   filename=[MStr 'TreeRho' num2str(Density) '/TreeAvgsGr' num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.mat'];
   load( filename)
   a=1
   MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
	errorbar(Times,MaxAvg,MaxStd,'r');hold on;
	errorbar(Times,MinAvg,MinStd,'r:');hold off;
   b=1
	PCNotHndl=subplot('position',[0.05 0.05 0.4 0.4]);
	errorbar(Times,NotAvg,NotStd,'r');
	BinHndl=subplot('position',[0.55 0.05 0.4 0.9]);
   errorbar(BinAvg(1:BinLim),BinStd(1:BinLim),'r');
   c=1
end

Bins=M2(X,1:BinLim);
subplot(MinMaxHndl),hold on;subplot(PCNotHndl),hold on;
PlotMaxes(M,colstr,MinMaxHndl,PCNotHndl);axis('tight')
%subplot(MinMaxHndl),hold off;subplot(PCNotHndl),hold off;subplot(BinHndl),hold off;
subplot(BinHndl),hold on;
plot(Bins,colstr),%hold off;
axis('tight')

function PlotMaxes(M,LineC,h1,h2)

[Y,X]=size(M);
Times=M(2:Y,1);
Thresh=ones(Y-1)*.00188;
Maximums=M(2:Y,2);
Minimums=M(2:Y,3);
NumNot=M(2:Y,4);
subplot(h1);
plot(Times,Maximums,LineC,Times,Minimums,LineC,Times,Thresh)
subplot(h2);
plot(Times,NumNot,LineC);