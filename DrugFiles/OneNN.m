function OneNN

K=20;
%load NERndDataSet;				% Get Data
load LHRndDataSet;				% Get Data
[tr,te,Class]=ScaleData(TrainSet,TestSet,4.0);	%Scale the data
[train,ftrain,IDtrain]=GetChData(tr);
[test,ftest,IDtest]=GetChData(te);
LabelsTrain=GetLabels(ftrain,Class,[1,2]);
LabelsTest=GetLabels(ftest,Class,[1,2]);
%LabelsTest=GetLabelsEq(ftest,Class,[1,2]);
%LabelsTrain=GetLabelsEq(ftrain,Class,[1,2]);
NNLabelsTr=GetNNLabels(LabelsTrain,[1,2]);
Labels=knn(train,test,NNLabelsTr,K);

for i=1:K
   MisClass=Labels(:,i)-LabelsTest';
   SMisClass(i)=sum(abs(MisClass))/length(ftest)
   NumMisHigh(i)=length(find(MisClass<0))
   NumMisLow(i)=length(find(MisClass>0))
end
Ks=1:K;x=100/length(ftest);
plot(Ks,SMisClass.*100,Ks,NumMisHigh.*(2*x),'r:',Ks,NumMisLow.*(2*x),'k')
legend('total','Highs','Lows',0)

function[NNLabs]=GetNNLabels(Labels,Classes)   

NNLabs=[];
for i=1:length(Classes)
	Cs=(Labels==Classes(i));
   NNLabs=[NNLabs Cs'];
end

