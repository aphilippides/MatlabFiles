function ShowWidthAvgDiffs(Sl)

Slices=[50,100,150,200,250,300];
d3dmm
wid=[1 4];
Cols=['r','b'];
Col=Cols(1);
fn=['MaxW'x2str(wid(1)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
load(fn);
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(Times,MaxAvg,MaxStd,Col);hold on;
errorbar(Times,MinAvg,MinStd,[Col ':']);hold off;axis('tight');
title(['Max and Min: Inner ' int2str(Slices(Sl+1)) ' \mum']);
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,Col);axis('tight');title('# Over');
MeanHndl=subplot('position',[0.05 0.05 0.4 0.4]);
errorbar(Times,MeanAvg,MeanStd,Col);axis('tight');title('mean Conc');
SDHndl=subplot('position',[0.55 0.05 0.4 0.4]);
errorbar(Times,SDAvg,SDStd,Col);axis('tight');title('s.d. conc');

Col=Cols(2);
fn=['MaxW'x2str(wid(2)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
load(fn);
subplot(MinMaxHndl);	hold on;
errorbar(Times,MaxAvg,MaxStd,Col);
errorbar(Times,MinAvg,MinStd,[Col ':']);axis('tight');hold off;

subplot(OverHndl);hold on;
errorbar(Times,OverAvg,OverStd,Col);axis('tight');hold off;
subplot(MeanHndl);hold on;
errorbar(Times,MeanAvg,MeanStd,Col);axis('tight');hold off;
subplot(SDHndl);hold on;
errorbar(Times,SDAvg,SDStd,Col);axis('tight');hold off;
