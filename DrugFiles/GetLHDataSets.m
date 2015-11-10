function[TrainSet,TestSet]=GetLHDataSets(LThresh,NumTrain,HThresh);

load(['NCI_NZLow'x2str(LThresh) '.mat;']);
eval(['M=NCILow' x2str(LThresh) 'Data;']);
[X,Y]=size(M);
RPerm=RandPerm(X);
TrainPermLow=RPerm(1:NumTrain);
TestPermLow=RPerm(NumTrain+1:end);
TrainSetLow=M(TrainPermLow,:);
TestSetLow=M(TestPermLow,:);

load(['NCI_NZHigh'x2str(HThresh) '.mat;']);
eval(['N=NCIHigh' x2str(HThresh) 'Data;']);
[X2,Y]=size(N);
RPerm=RandPerm(X2);
TrainPermHigh=RPerm(1:NumTrain);
TestPermHigh=RPerm(NumTrain+1:X);
TrainSetHigh=N(TrainPermHigh,:);
TestSetHigh=N(TestPermHigh,:);

Bads=find(TrainSetHigh(:,end)<HThresh)
Bads=find(TestSetHigh(:,end)<HThresh)
Bads=find(TrainSetLow(:,end)>=LThresh)
Bads=find(TestSetLow(:,end)>=LThresh)

TSet=[TrainSetLow;TrainSetHigh];
rp=randperm(2*NumTrain);
TrainSet=TSet(rp,:);
TSet=[TestSetLow;TestSetHigh];
rp=randperm(2*(X-NumTrain));
TestSet=TSet(rp,:);

save LHRndDataSet.mat TrainSetLow TrainSetHigh TestSetLow TestSetHigh TrainSet TestSet
