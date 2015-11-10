function[TrainSet,TestSet]=GetLowHighDataSets(Thresh,NumTrain,DataSet);

load(['NCI_NZLow'x2str(Thresh) '.mat;']);
eval(['M=NCILow' x2str(Thresh) 'Data;']);
[X,Y]=size(M);
RPerm=RandPerm(X);
TrainPermLow=RPerm(1:NumTrain);
TestPermLow=RPerm(NumTrain+1:end);
TrainSetLow=M(TrainPermLow,:);
TestSetLow=M(TestPermLow,:);
eval(['load NZRandSet'int2str(DataSet) '.mat;']);
eval(['H=NZRandSet'int2str(DataSet) ';']);
NewH=setdiff(H,M,'rows');
TrainSetHigh=NewH(1:NumTrain,:);
TestSetHigh=NewH(NumTrain+1:X,:);
Bads=find(NewH(:,end)<Thresh)
TSet=[TrainSetLow;TrainSetHigh];
rp=randperm(2*NumTrain);
TrainSet=TSet(rp,:);
TSet=[TestSetLow;TestSetHigh];
rp=randperm(2*(X-NumTrain));
TestSet=TSet(rp,:);

save LowHighRndDataSet.mat TrainSetLow TrainSetHigh TestSetLow TestSetHigh TrainSet TestSet
