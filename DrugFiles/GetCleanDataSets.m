function[TrainSet,TestSet]=GetCleanDataSets(LThresh,NumTrain,HThresh);

load CleanDataSet1NZ;
Lows=find(M(:,end)<LThresh);
Highs=find(M(:,end)>HThresh);
RPLow=Lows(RandPerm(length(Lows)));
RPHigh=Highs(RandPerm(length(Highs)));

TrainSetLow=M(RPLow(1:NumTrain),:);
TestSetLow=M(RPLow(NumTrain+1:length(Lows)),:);

TrainSetHigh=M(RPHigh(1:NumTrain),:);
TestSetHigh=M(RPHigh(NumTrain+1:length(Lows)),:);

Bads=find(TrainSetHigh(:,end)<=HThresh)
Bads=find(TestSetHigh(:,end)<=HThresh)
Bads=find(TrainSetLow(:,end)>=LThresh)
Bads=find(TestSetLow(:,end)>=LThresh)

TSet=[TrainSetLow;TrainSetHigh];
rp=randperm(2*NumTrain);
TrainSet=TSet(rp,:);
TSet=[TestSetLow;TestSetHigh];
rp=randperm(2*(length(Lows)-NumTrain));
TestSet=TSet(rp,:);

save CleanRndDataLH4.mat TrainSetLow TrainSetHigh TestSetLow TestSetHigh TrainSet TestSet

