function MyLinSVM

C=10000;%[0.1,.25,0.5, 1:10 20:10:100 200:100:1000 5000 10000 1e5] 
Epsi=[.001]
%load NERndDataSet;				% Get Data
load LHRndDataSet;				% Get Data
[tr,te,Class]=ScaleData2(TrainSet,TestSet,4.0);	%Scale the data
[train,ftrain,IDtrain]=GetChData(tr);
[test,ftest,IDtest]=GetChData(te);
LabelsTrain=GetLabels(ftrain,Class,[1,2]);
LabelsTest=GetLabels(ftest,Class,[1,2]);
%LabelsTrain=GetLabelsEq(ftrain,Class,[1, 2]);
%LabelsTest=GetLabelsEq(ftest,Class,[1,2]);
for j=1:length(C)
   %for j=1:length(Epsi)
   j
   [MRate(j),MSvs(j)]=GetSVCXVal(train',LabelsTrain,80,5,C(j),Epsi);
   [Rate(j),MisLabs,sc,LabsPred,TestSvs(j)]=GetSVC(train',LabelsTrain,test',LabelsTest,C(j),Epsi);
   MLabsAll_1_2(j,:)=PlotOuts(MisLabs,LabelsTest,sc,LabsPred);
   %save LinearSVM.mat Rate MRate TestSvs MSvs C MLabsAll_1_2;
end
figure
Rate
MRate
plot([Rate' MRate'])

function[HRate,MLabs, scores,Labels,PCSvs]=GetSVC(Tr,LabTr,Te,LabTe,C,Epsilon)

[AlphaY, SVs, Bias, Parameters, Ns]=LinearSVC(Tr,LabTr, C);
PCSvs=size(SVs,2)/length(LabTr)
[Labels, scores]= osuSVMClass(Te, Ns, AlphaY, SVs, Bias, Parameters);
MLabs=find(Labels~=LabTe);
HRate=1-length(MLabs)/length(LabTe)
Labs_1_2=[length(find(Labels==1)) length(find(Labels==2))]
%[ConfMatrix, scores]= osuSVMTest(Te, LabTe, Ns, AlphaY, SVs, Bias, Parameters);

function[MeanRate,MeanSvs]=GetSVCXVal(Tr,LabTr,SetSize,NumXVal,C,Epsilon)

NumSets=length(LabTr)/SetSize;
RPSets=RandPerm(NumSets);
for i=1:NumXVal
   i
	[tr,trlabs,te,telabs]=XValDataSet(SetSize,RPSets(i),Tr,LabTr);
   [Rate(i),MLabs,sc,Lab,PCSvs(i)]=GetSVC(tr,trlabs,te,telabs,C,Epsilon);   
   StatOuts(MLabs,telabs,sc,Lab);
end
MeanSvs=mean(PCSvs)
MeanRate=mean(Rate)

function[MisLNumbsAll_1_2]=PlotOuts(Misses,Labels,sc,LabsPred)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
Hit1s=setdiff(Ones,Mis1s);
Hit2s=setdiff(Twos,Mis2s);
subplot(1,2,1),plot(sc(Mis2s),'ro'),hold on,plot(sc(Hit1s),'bx'),hold off,title('Ones')
subplot(1,2,2),plot(sc(Mis1s),'ro'),hold on,plot(sc(Hit2s),'bx'),hold off,title('Twos')
MisLNumbsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)]

function[MisLabsAll_1_2]= StatOuts(Misses,Labels,sc,LabsPred)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
MisLabsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)]
