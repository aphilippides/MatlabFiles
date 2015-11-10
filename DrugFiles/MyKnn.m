function MyKnn(Train,Test,Classes,K)

[XTrain,FTrain,IndsTrain]=GetChData(Train);
[XVal,FVal,IndsVal]=GetChData(Test);
ClassTrain=GetClassLabs(FTrain,Classes);
ClassVal=GetClassLabs(FVal,Classes);
ValLabs=GetClasses(ClassVal);
Labels=knn(XTrain,XVal,ClassTrain,K);

for i=1:K
   MisClass=abs(Labels(:,i)-ValLabs');
   SMisClass(i)=sum(abs(MisClass));
   NumNeg(i)=length(find(MisClass<0));
   NumPos(i)=length(find(MisClass>0));
end
x=100/length(FVal);
Ks=1:K;
plot(Ks,SMisClass.*x,Ks,NumNeg.*(2*x),'r:',Ks,NumPos.*(2*x),'k')
legend('total','Highs','Lows',0)
LowTrains=length(find(FTrain<4));
LowFS=find(FVal<4);
SMisClass.*x

function[CLabs]=GetClassLabs(F,Classes)   

CLabs=F<Classes(1);
for i=2:length(Classes)
	Cs=(F>=Classes(i-1))&(F<Classes(i));
   CLabs=[CLabs Cs];
end
Cs=F>=Classes(end);
CLabs=[CLabs Cs];
ProblemWithThisFunction

function[Class]=GetClasses(NLabs)

[X,Y]=size(NLabs);
for i=1:X
   Class(i)=find(NLabs(i,:)==1);
end
