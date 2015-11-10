function[TNotPAvg ,TNotPStd,TNotFAvg, TNotFStd]= PerpTree0Times(Slice)
Versions=1:32;
for i=1:length(Versions)
   P=load(['MaxPerpRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl' int2str(Slice) '.dat']);
	TimesP=P(:,1);
   TNotP(i)=TimesP(min(find(P(:,4)==0)));
end
Versions=[1,2,3,4,5,16,17,18,19,20,33,34];
for i=1:length(Versions)
F=load(['../3dMaxMin/MaxTreeRho100/TreeV' int2str(Versions(i)) 'MaxGr300Sq1Sl' int2str(Slice) '.dat']);
   TimesF=F(:,1);
   TNotF(i)=TimesF(min(find(F(:,4)==0)));
end
% Get approx data
TNotPAvg=mean(TNotP)
TNotPStd=std(TNotP)
TNotFAvg=mean(TNotF)
TNotFStd=std(TNotF)