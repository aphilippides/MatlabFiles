function RbfSVMnt(ScaleType,FName,Gamma,C,DataSet,EqualOrNot)

Epsi=[.001];
load(DataSet);				% Get Data
[tr,te,Class]=ScData(TrainSet,TestSet,ScaleType,4.0);	%Scale the data
[train,ftrain,IDtrain]=GetChData(tr);
[test,ftest,IDtest]=GetChData(te);
if(EqualOrNot==0)
	LabelsTrain=GetLabels(ftrain,Class,[1,2]);
   LabelsTest=GetLabels(ftest,Class,[1,2]);
else
   LabelsTrain=GetLabelsEq(ftrain,Class,[1, 2]);
   LabelsTest=GetLabelsEq(ftest,Class,[1,2]);
end

for i=1:length(Gamma)
   i
   for j=1:length(C)
   %for j=1:length(Epsi)
      j
      [MRate(i,j),MSvs(i,j)]=GetRbfSVCXVal(train',LabelsTrain,5,5,Gamma(i),C(j),Epsi);
		[Rate(i,j),MisLabs,sc,LabsPred,TestSvs(i,j)]=GetRbfSVC(train',LabelsTrain,test',LabelsTest,Gamma(i),C(j),Epsi);
      %[Rate(i,j),MisLabs,sc]=GetSVC(train',LabelsTrain,train',LabelsTrain,Gamma(i),C(j),Epsi);
      %[Rate(i,j),MisLabs,sc]=GetSVC(train',LabelsTrain,test',LabelsTest,Gamma(i),C,Epsi(j));
	   MLabsAll_1_2(i,j,:)=StatOuts(MisLabs,LabelsTest,sc,LabsPred);
   %	save(FName,'Rate','MRate','TestSvs','MSvs','C','MLabsAll_1_2','Gamma');
	end
end
figure
Rate
MRate
plot([Rate' MRate'])

function[HRate,MLabs, scores,Labels,PCSvs]=GetRbfSVC(Tr,LabTr,Te,LabTe,Gamma,C,Epsilon)

[AlphaY, SVs, Bias, Parameters, Ns]=RbfSVCnt(Tr, LabTr,Gamma,C,Epsilon,0);
PCSvs=size(SVs,2)/length(LabTr);
[Labels, scores]= osuSVMClass(Te, Ns, AlphaY, SVs, Bias, Parameters);
MLabs=find(Labels~=LabTe);
HRate=1-length(MLabs)/length(LabTe);
Labs_1_2=[length(find(Labels==1)) length(find(Labels==2))];

function[MeanRate,MeanSvs]=GetRbfSVCXVal(Tr,LabTr,NumSets,NumXVal,Gamma,C,Epsilon)

SetSize=floor(length(LabTr)/NumSets);
RPSets=RandPerm(NumSets);
for i=1:NumXVal
	[tr,trlabs,te,telabs]=XValDataSet(SetSize,RPSets(i),Tr,LabTr);
   [Rate(i),MLabs,sc,Lab,PCSvs(i)]=GetRbfSVC(tr,trlabs,te,telabs,Gamma,C,Epsilon);   
   StatOuts(MLabs,telabs,sc,Lab);
end
MeanSvs=mean(PCSvs);
MeanRate=mean(Rate);

function[MisLNumbsAll_1_2]= PlotOuts(Misses,Labels,sc,ftest)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
Hit1s=setdiff(Ones,Mis1s);
Hit2s=setdiff(Twos,Mis2s);
subplot(1,2,1),plot(sc(Mis2s),'ro'),hold on,plot(sc(Hit1s),'bx'),hold off,title('Ones')
subplot(1,2,2),plot(sc(Mis1s),'ro'),hold on,plot(sc(Hit2s),'bx'),hold off,title('Twos')
MisLNumbsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)]
%hold on,plot([1 length(Misses)],[Class Class],'b:'),hold off

function[MisLabsAll_1_2]= StatOuts(Misses,Labels,sc,LabsPred)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
MisLabsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)];

function[tr,te,Class]=ScData(TrainSet,TestSet,ScaleType,FNum)

if(ScaleType<3)
   [tr,te,Class]=ScaleData2(TrainSet,TestSet,ScaleType,FNum);
elseif(ScaleType<5)
   [tr,te,Class]=ScaleData(TrainSet,TestSet,ScaleType,FNum);
elseif(ScaleType<=7)
   [tr,te,Class]=ScaleDataChems(TrainSet,TestSet,ScaleType,FNum);
end
