function[Fitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,EqOrNot,Thresh,GAOrTest,Used)

Epsi=[.001];
[tr,te,Class]=ScData(TrainSet,TestSet,Scale,Thresh,Used);	%Scale the data
[train,ftrain,IDtrain]=GetChData(tr);
[test,ftest,IDtest]=GetChData(te);
if(EqOrNot==0)  %if using data that discriminates between eg 4's and not 4's or not
	LabelsTrain=GetLabels(ftrain,Class,[1,2]);
   LabelsTest=GetLabels(ftest,Class,[1,2]);
else
   LabelsTrain=GetLabelsEq(ftrain,Class,[1, 2]);
   LabelsTest=GetLabelsEq(ftest,Class,[1,2]);
end

if(GAOrTest==0)  % if using the score for GA evaluation or for a test 
	[Fitness,MSvs]=GetRbfSVCXVal(train',LabelsTrain,5,5,Gamma,C,Epsi);
else
   [Fitness,MLs,sc,Labs,TSvs]=GetRbfSVC(train',LabelsTrain,test',LabelsTest,Gamma,C,Epsi);
end

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

function[MisLabsAll_1_2]= StatOuts(Misses,Labels,sc,LabsPred)

Ones=find(Labels==1);
Twos=find(Labels==2);
Mis1s=intersect(Ones,Misses);
Mis2s=intersect(Twos,Misses);
MisLabsAll_1_2=[length(Labels),length(Mis1s),length(Mis2s)];

function[tr,te,Class]=ScData(TrainSet,TestSet,ScaleType,FNum,Used)

if(ScaleType<3)
   [tr,te,Class]=ScaleData2GA(TrainSet,TestSet,ScaleType,FNum,Used);
   %[tr,te,Class]=ScaleData2(TrainSet,TestSet,ScaleType,FNum,Used);
elseif(ScaleType<5)
   [tr,te,Class]=ScaleData(TrainSet,TestSet,ScaleType,FNum);
elseif(ScaleType<=7)
   [tr,te,Class]=ScaleDataChems(TrainSet,TestSet,ScaleType,FNum);
end
