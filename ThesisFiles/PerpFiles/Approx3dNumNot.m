function Approx3dNumNot(In,TestSet,All,T)

if(All==1)
   for i=1:32
      [FactAvg(i),FactStd(i),F,P,t1,t2]=Approx3dNumNotFunc(In,1:i,T);
   end
   subplot(1,1,1)
   errorbar(FactAvg,FactStd)
   figure
end
[Avg(i),Standards(i),TwodOver,ThreedOver,TwodDist,ThreedDist]=Approx3dNumNotFunc(In,TestSet,T)
SaveData=1;
V=1:32;
if(SaveData)
    fn=['Fin2InfRandX150T' int2str(T*1000) 'Sl2Data.mat'];
save(fn,'TwodOver','ThreedOver','FactAvg','FactStd','V','TwodDist','ThreedDist');
end


function[FactAvg,FactStd,FOver,POver,FDist2thresh,PDist2thresh]= Approx3dNumNotFunc(In,TestSet,T)
d3dperp;
Versions=1:32;
for i=1:length(Versions)
   if(In==1)
   P=load(['MaxPerpRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl2.dat']);
   F=load(['../Fast/MaxTreeRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl0.dat']);
	else
   P=load(['MaxPerpRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl5.dat']);
   F=load(['../Fast/MaxTreeRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl1.dat']);
   end

   TimesP=P(:,1);
   TimesF=F(:,1);
   TNotP(i)=TimesP(min(find(P(:,4)==0)));
   TNotF(i)=TimesF(min(find(F(:,4)==0)));

   POver(i)=NumOver(T,P);
   FOver(i)=NumOver(T,F);
end
% Get approx data
if (isempty(TestSet))
   TestSet=1:32;
   DataSet=1:32;
else
   DataSet=setdiff(Versions,TestSet);
end

PDist2thresh=(0.75.*POver./pi).^(1/3);
FDist2thresh=sqrt(FOver./pi);
%testP=TNotP(TestSet);
%dataP=TNotP(DataSet);
%testF=TNotF(TestSet);
%dataF=TNotF(DataSet);
testP=POver(TestSet);
dataP=POver(DataSet);
testF=FOver(TestSet);
dataF=FOver(DataSet);

Factors=testP./testF;
FactAvg=mean(Factors)
FactStd=std(Factors)
TNotPAvg=mean(dataP)
TNotPStd=std(dataP)
TNotApprox=dataF*FactAvg;
TNotApproxAvg=mean(TNotApprox)
TNotApproxStd=std(TNotApprox)
ApproxDiffs=abs(dataP-TNotApprox);
DiffAvg=mean(ApproxDiffs)
DiffStd=std(ApproxDiffs)



function ShowMaxMinNot(In)

if(In==1)
	Pe0=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl0.mat') ;
	Pe1=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl1.mat') ;
	Pe2=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl2.mat') ;
   Fa1=load('../Fast/MaxTreeRho100/TreeAvgsGr300Sq1Sl0.mat') ;
else
	Pe0=load('MaxPerpRho100/AvgPerpDataOutGr300Sq1Sl0.mat') ;
	Pe1=load('MaxPerpRho100/AvgPerpDataOutGr300Sq1Sl1.mat') ;
	Pe2=load('MaxPerpRho100/AvgPerpDataInnGr300Sq1Sl2.mat') ;
   Fa1=load('../Fast/MaxTreeRho100/TreeAvgsGr300Sq1Sl1.mat') ;
end
Pe0.Times=Pe0.Times*0.004;
Pe1.Times=Pe1.Times*0.004;
Pe2.Times=Pe2.Times*0.004;

TimeNot0=Pe0.Times(min(find(Pe0.NotAvg==0)))
TimeNot1=Pe1.Times(min(find(Pe1.NotAvg==0)))
TimeNot2=Pe2.Times(min(find(Pe2.NotAvg==0)))
TimeNotF=Fa1.Times(min(find(Fa1.NotAvg==0)))
plot([0 1 2],[TimeNot0 TimeNot1 TimeNot2],0,TimeNotF,'rx')
