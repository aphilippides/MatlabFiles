function MetaDrugGA

SaveFName=('RbfSvmGAPopData.mat');
SaveFName2=('RbfSvmGAPopData2.mat');
SaveFName3=('RbfSvmGAPopData3.mat');
Gamma=.01;
Scale=7;
C=100;
Equal=0;
load LowHighRndDataSet.mat;
Thresh=4.0;
%DrugGA(TrainSet,TestSet,1,5,Thresh,6,Equal,SaveFName2)
DrugGA(TrainSet,TestSet,Gamma,C,Thresh,Scale,Equal,SaveFName)
%DrugGA(TrainSet,TestSet,200,1,Thresh,5,Equal,SaveFName3)

