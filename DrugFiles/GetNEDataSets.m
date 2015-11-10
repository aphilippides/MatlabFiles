function[TrainSet,TestSet]=GetNEDataSets(Equal,NumTrain,NumTest);

load(['NCI_NZEq'x2str(Equal) '.mat;']);
eval(['M=NCIEq' x2str(Equal) 'Data;']);
[X,Y]=size(M);
RPerm=RandPerm(X);
TrainPermEq=RPerm(1:NumTrain);
TestPermEq=RPerm(NumTrain+1:NumTrain+NumTest);
TrainSetEq=M(TrainPermEq,:);
TestSetEq=M(TestPermEq,:);

load(['NCI_NZNot'x2str(Equal) '.mat;']);
eval(['N=NCINot' x2str(Equal) 'Data;']);
[X2,Y]=size(N);
RPerm=RandPerm(X2);
TrainPermNot=RPerm(1:NumTrain);
TestPermNot=RPerm(NumTrain+1:NumTrain+NumTest);
TrainSetNot=N(TrainPermNot,:);
TestSetNot=N(TestPermNot,:);

Bads=find(TrainSetNot(:,end)==Equal)
Bads=find(TestSetNot(:,end)==Equal)
Bads=find(TrainSetEq(:,end)~=Equal)
Bads=find(TestSetEq(:,end)~=Equal)

TSet=[TrainSetEq;TrainSetNot];
rp=randperm(2*NumTrain);
TrainSet=TSet(rp,:);
TSet=[TestSetEq;TestSetNot];
rp=randperm(2*NumTest);
TestSet=TSet(rp,:);

save NERndDataSet.mat TrainSetEq TrainSetNot TestSetEq TestSetNot TrainSet TestSet
