function MyRbfSVM

Gamma=[0.8];
C=[300];
Epsi=[.001]
load NERndDataSet;				% Get Data
%load LHRndDataSet;				% Get Data
[tr,te,Class]=ScaleData2(TrainSet,TestSet,4.0);	%Scale the data
[train,ftrain,IDtrain]=GetChData(tr);
[test,ftest,IDtest]=GetChData(te);
%LabelsTrain=GetLabels(ftrain,Class,[1,2]);
%LabelsTest=GetLabels(ftest,Class,[1,2]);
LabelsTrain=GetLabelsEq(ftrain,Class,[1, 2]);
LabelsTest=GetLabelsEq(ftest,Class,[1,2]);
for i=1:length(Gamma)
   i
   for j=1:length(C)
   %for j=1:length(Epsi)
      j
      [Rate(i,j),MisLabs,sc]=GetSVC(train',LabelsTrain,test',LabelsTest,Gamma(i),C(j),Epsi);
      %[Rate(i,j),MisLabs,sc]=GetSVC(train',LabelsTrain,train',LabelsTrain,Gamma(i),C(j),Epsi);
      %[Rate(i,j),MisLabs,sc]=GetSVC(train',LabelsTrain,test',LabelsTest,Gamma(i),C,Epsi(j));
   PlotOuts(MisLabs,LabelsTest,sc,ftest);
	end
end
figure
Rate
plot(Rate)

function[HRate,MLabs, scores]=GetSVC(Tr,LabTr,Te,LabTe,Gamma,C,Epsilon)

[AlphaY, SVs, Bias, Parameters, Ns]=RbfSVCVerbose(Tr, LabTr,Gamma,C,Epsilon,2);
PCSvs=size(SVs,2)/length(LabTr)
[Labels, scores]= osuSVMClass(Te, Ns, AlphaY, SVs, Bias, Parameters);
MLabs=find(Labels~=LabTe);
HRate=1-length(MLabs)/length(LabTe)
%[ConfMatrix, scores]= osuSVMTest(Te, LabTe, Ns, AlphaY, SVs, Bias, Parameters);

function PlotOuts(Misses,Labels,sc,ftest)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
Hit1s=setdiff(Ones,Mis1s);
Hit2s=setdiff(Twos,Mis2s);
subplot(2,2,1),plot(ftest(Mis1s),'ro'),hold on,plot(sc(Mis1s),'bx'),hold off,title('Misses')
subplot(2,2,2),plot(ftest(Mis2s),'ro'),hold on,plot(sc(Mis2s),'bx'),hold off,title('Misses')
subplot(2,2,3),plot(ftest(Hit1s),'ro'),hold on,plot(sc(Hit1s),'bx'),hold off,title('Hits')
subplot(2,2,4),plot(ftest(Hit2s),'ro'),hold on,plot(sc(Hit2s),'bx'),hold off,title('Hits')
NumbsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)]
%hold on,plot([1 length(Misses)],[Class Class],'b:'),hold off
