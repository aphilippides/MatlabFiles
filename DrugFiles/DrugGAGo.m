function DrugGAGo

Equal=0;		
load CleanRndDataLH4.mat;
Thresh=4.0;
MidPt=size(TestSet,1)/2;
ValSet=TestSet(1:MidPt,:);
TestSet=TestSet(MidPt+1:end,:);
Scales=7:-1:0
for i=1:8
   i
   SaveFName=(['RbfSvmGAPopDataSc' int2str(Scales(i)) 'TestMin.mat']);
   DrugAllGA_Min(TrainSet,ValSet,TestSet,Thresh,Equal,SaveFName,Scales(i));
   load(SaveFName);
   Ind=BestInds(end,:);
   TestVal(i)=TestRbf(Ind,TrainSet,TestSet,Thresh,Equal)
   save TestVal.mat TestVal
end

function[TFitness]=TestRbf(Ind,TrainS,TestS,Thresh,Equal)
IndLen=220;
Used=[find(Ind(4:end-1)) IndLen-3];
NonZeros=[1 [find(Ind(4:end-1))+1] IndLen-2];
Gamma=Ind(1);
C=Ind(2);
Scale=Ind(3);
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
[TFitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,1,Used);
