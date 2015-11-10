function ShowWidthAvgDiffs2d(Sl)

Slices=[50,100,150,200,250,300];
d2dmm
wid=[4 8];
Cols=['r','b'];
Col=Cols(1);
fn=['MaxTreeRho100/TreeSst0_125MaxAvgsGr2500X800Sq1W'x2str(wid(1)) 'Sl'x2str(Sl) '.mat'];
load(fn);
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(Times,MaxAvg,MaxStd,Col);hold on;
errorbar(Times,MinAvg,MinStd,[Col ':']);hold off;axis('tight');
title(['Max and Min: Inner ' int2str(Slices(Sl+1)) ' \mum']);
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,Col);axis('tight');title('# Over');

Col=Cols(2);
fn=['MaxTreeRho100/TreeSst0_125MaxAvgsGr2500X800Sq1W'x2str(wid(2)) 'Sl'x2str(Sl) '.mat'];
load(fn);
subplot(MinMaxHndl);	hold on;
errorbar(Times,MaxAvg,MaxStd,Col);
errorbar(Times,MinAvg,MinStd,[Col ':']);axis('tight');hold off;

subplot(OverHndl);hold on;
errorbar(Times,OverAvg,OverStd,Col);axis('tight');hold off;
