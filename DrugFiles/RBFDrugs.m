function RBFDrugs

%[tr,test]=GetLowHighDataSets(4.0,150,5);
load LowHighRndDataSet;
[tr,test,Class]=ScaleData(TrainSet,TestSet,4.0);
[x,y]=size(tr);
Ins=y-2;
Outs=1;
Hidden=100;
Opts=[1,0.01,0.01,0,1];
Opts(14)=20;
[X,Fs,Ind]=GetChData(tr);
Cents=GetNumCentres(X,Opts);
StartNet=rbf(Ins,Hidden,Outs,'gaussian')
TrainedNet=rbftrain(StartNet,Opts,X,Fs)
[X,Fs,Ind]=GetChData(test);
Out=rbffwd(TrainedNet,X)
Out2=rbffwd(StartNet,X)
plot(Out,'ro',Fs,'bx')
figure,plot(Out2,'ro',Fs,'bx')


function[NumCents]
centres=kmeans(centres,X,Opts);

function[Targs]=GetTargets(F,C)


