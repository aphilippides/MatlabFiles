function[Fit,TestFit]=TestRbfSvm(Ind,TrainS,TestS,Gamma,C,Thresh,Scale,Equal)

NonZeros=[1 [find(Ind(1:end-1))+1] 218];
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
dummy=0
[Fit]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,0,dummy);
[TestFit]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,1,dummy);
