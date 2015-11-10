function KNNDrugs

[tr,test]=GetLowHighDataSets(4.0,150,5);
%KnnBinary(tr,test);
KnnScale(tr,test);

function KnnScale(tr,test)
[tr,test,Class]=ScaleData(tr,test,4.0);
MyKnn(tr,test,Class,20)

function KnnBinary(tr,test)
tr=MkDataBinary(tr);
test=MkDataBinary(test);
MyKnn(tr,test,4.0,20)

function KNNRawData
Train=[10];
Val=[15 16];
Test=100;
Classes=4.0;
K=8;
[XTrain,FTrain,IndsTrain]=GetRndData(Train);
[XVal,FVal,IndsVal]=GetRndData(Val);
%[XTest,FTest,IndsTest]=GetRndData(Test);
ClassTrain=GetClassLabs(FTrain,Classes);
ClassVal=GetClassLabs(FVal,Classes);
ValLabs=GetClasses(ClassVal);
Labels=knn(XTrain,XVal,ClassTrain,K);

for i=1:K
   MisClass=abs(Labels(:,i)-ValLabs');
   SMisClass(i)=sum(MisClass);
   FVal(find(MisClass>0))
end
plot(SMisClass)
LowTrains=FTrain(find(FTrain<4))
LowFS=FVal(find(FVal<4))
keyboard

function[Chems,Fs,Inds]=GetRndData(V)

Chems=[];Fs=[];Inds=[];
for i=1:length(V)
   eval(['load NZRandSet'int2str(V(i)) '.mat;']);
   eval(['M=NZRandSet'int2str(V(i)) ';']);
   Inds=[Inds;M(:,1)];
   Chems=[Chems;M(:,1:end-1)];
   Fs=[Fs;M(:,end)];
   clear M NZRandSet*
end

function[CLabs]=GetClassLabs(F,Classes)   

CLabs=F<Classes(1);
for i=2:length(Classes)
	Cs=F>=Classes(i-1);
   Cs=Cs<Classes(i);
   CLabs=[CLabs Cs];
end
Cs=F>=Classes(end);
CLabs=[CLabs Cs];

function[Class]=GetClasses(NLabs)

[X,Y]=size(NLabs);
for i=1:X
   Class(i)=find(NLabs(i,:)==1);
end
