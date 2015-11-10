function Perpdiffs(In)

if(In==1)
	Pe0=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl0.mat') ;
	Pe1=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl1.mat') ;
	Pe2=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl2.mat') ;
   Fa1=load('../Fast/MaxTreeRho100/TreeAvgsGr300Sq1Sl0.mat') ;
else
	Pe0=load('MaxPerpRho100/AvgPerpDataOutGr300Sq1Sl0.mat') ;
	Pe1=load('MaxPerpRho100/AvgPerpDataOutGr300Sq1Sl1.mat') ;
   Fa1=load('../Fast/MaxTreeRho100/TreeAvgsGr300Sq1Sl1.mat') ;
end

Pe0.Times=Pe0.Times*0.004;
Pe1.Times=Pe1.Times*0.004;
Pe2.Times=Pe2.Times*0.004;
%Fact1=(max(Fa1.MaxAvg)/max(Pe0.MaxAvg))
Fact1=1
Pe0.MaxAvg=Pe0.MaxAvg*Fact1;
%Fact2=(max(Fa1.MaxAvg)/max(Pe1.MaxAvg))
Fact2=1
Pe1.MaxAvg=Pe1.MaxAvg*Fact2;


Thresh=0.0019;
ThreshV=[Thresh Thresh];
TThresh=[0 5];

MinMaxMeans=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means 
plot(Pe0.Times,Pe0.MaxAvg,'b',Pe1.Times,Pe1.MaxAvg,'g--',Pe2.Times,Pe2.MaxAvg,'y',Fa1.Times,Fa1.MaxAvg,'r:', ...
   Pe0.Times,Pe0.MinAvg,'b',Pe1.Times,Pe1.MinAvg,'g--',Pe2.Times,Pe2.MinAvg,'y',Fa1.Times,Fa1.MinAvg,'r:', ...
   TThresh,ThreshV,'k')
axis('tight')

MinMaxErrs=subplot('position',[0.55 0.55 0.4 0.4]);	%plot means and errbars
errorbar(Pe0.Times,Pe0.MaxAvg,Pe0.MaxStd,'b'),hold on;
errorbar(Pe1.Times,Pe1.MaxAvg,Pe1.MaxStd,'g--');
errorbar(Pe2.Times,Pe2.MaxAvg,Pe2.MaxStd,'y');
errorbar(Fa1.Times,Fa1.MaxAvg,Fa1.MaxStd,'r:');

errorbar(Pe0.Times,Pe0.MinAvg,Pe0.MinStd,'b');
errorbar(Pe1.Times,Pe1.MinAvg,Pe1.MinStd,'g--');
errorbar(Pe2.Times,Pe2.MinAvg,Pe2.MinStd,'y');
errorbar(Fa1.Times,Fa1.MinAvg,Fa1.MinStd,'r:');
plot(TThresh,ThreshV,'k')
axis('tight'),hold off

NumNotMeans=subplot('position',[0.05 0.05 0.4 0.4]);	%plot number not 
plot(Pe0.Times,Pe0.NotAvg,Pe1.Times,Pe1.NotAvg,'g--',Pe2.Times,Pe2.NotAvg,'y',...
   Fa1.Times,Fa1.NotAvg,'r:')
axis('tight')

NumNotErrs=subplot('position',[0.55 0.05 0.4 0.4]);	%plot means and errbars
errorbar(Pe0.Times,Pe0.NotAvg,Pe0.NotStd,'b'),hold on;
errorbar(Pe1.Times,Pe1.NotAvg,Pe1.NotStd,'g--');
errorbar(Pe2.Times,Pe2.NotAvg,Pe2.NotStd,'y');
errorbar(Fa1.Times,Fa1.NotAvg,Fa1.NotStd,'r:');
axis('tight'),hold off
return
