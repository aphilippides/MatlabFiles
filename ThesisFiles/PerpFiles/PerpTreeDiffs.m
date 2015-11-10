function PerpTreeDiffs(GridSize, Density,Slice)

Sqare=1;

filename1=['../3dMaxMin/MaxTreeRho' num2str(Density) '/TreeAvgsGr' ...
      num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.mat']
filename2=['MaxPerpRho' num2str(Density) '/TreeAvgsGr' num2str(GridSize) ...
      'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.mat']
MTree=load(filename1);
MPerp=load(filename2);
Thresh=0.0019;
ThreshV=[Thresh Thresh];
TThresh=[0 5];
MinMaxMeans=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means 
plot(MTree.Times,MTree.MaxAvg,'b',MPerp.Times,MPerp.MaxAvg,'g--', ...
MTree.Times,MTree.MinAvg,'b',MPerp.Times,MPerp.MinAvg,'g--',TThresh,ThreshV,'k')
axis('tight')

MinMaxErrs=subplot('position',[0.55 0.55 0.4 0.4]);	%plot means and errbars
errorbar(MTree.Times,MTree.MaxAvg,MTree.MaxStd,'b'),hold on;
errorbar(MPerp.Times,MPerp.MaxAvg,MPerp.MaxStd,'g--');

errorbar(MTree.Times,MTree.MinAvg,MTree.MinStd,'b');
errorbar(MPerp.Times,MPerp.MinAvg,MPerp.MinStd,'g--');
plot(TThresh,ThreshV,'k')
axis('tight'),hold off

NumNotMeans=subplot('position',[0.05 0.05 0.4 0.4]);	%plot number not 
plot(MTree.Times,MTree.NotAvg,MPerp.Times,MPerp.NotAvg,'g--')
plot(MTree.Times,MTree.NotAvg-MPerp.NotAvg,'g--')
axis('tight')

NumNotErrs=subplot('position',[0.55 0.05 0.4 0.4]);	%plot means and errbars
errorbar(MTree.Times,MTree.NotAvg,MTree.NotStd,'b'),hold on;
errorbar(MPerp.Times,MPerp.NotAvg,MPerp.NotStd,'g--');
axis('tight'),hold off


