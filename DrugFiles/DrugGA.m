function DrugGA(TrainS,TestS,Gamma,C,Thresh,Scale,Equal,SaveFName)

XRate=0.2;
MRate=0.01;
NumGens=10000;
global POPSIZE DUMPEVERY;
POPSIZE=100;
DUMPEVERY=10;
IndLen=216;
Pop=zeros(POPSIZE,IndLen+1);
Pop=GetInitialPop(Pop,0.5,TrainS,TestS,Gamma,C,Thresh,Scale,Equal);
OutputPopStats(Pop,0,0,SaveFName,TrainS,TestS,Gamma,C,Thresh,Scale,Equal);

for Gen=1:NumGens
   for i=1:POPSIZE
      Ch=CreateChild(Pop,XRate,MRate);
      [Ch(end)]=Test(Ch,TrainS,TestS,Gamma,C,Thresh,Scale,Equal);
      Pop=UpdatePop(Pop,Ch);
      OutputPopStats(Pop,Gen,i,SaveFName,TrainS,TestS,Gamma,C,Thresh,Scale,Equal);  
	end
end

function[Fitness]=Test(Ind,TrainS,TestS,Gamma,C,Thresh,Scale,Equal)

NonZeros=[1 [find(Ind(1:end-1))+1] 218];
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
[Fitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,0,NonZeros);

function[TFitness]=RbfTest(Ind,TrainS,TestS,Gamma,C,Thresh,Scale,Equal)

NonZeros=[1 [find(Ind(1:end-1))+1] 218];
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
[TFitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,1,NonZeros);

function[Child]=CreateChild(Pop,XRate,MRate)
if(rand<XRate)
   Child=SelectPsAndX(Pop);
else
   Child=SelectParent(Pop);
end
Child=[MutateBinary(Child(1:end-1),MRate) 0];

function[NewPop]=UpdatePop(Pop,NewInd)
Ranks=(1:size(Pop,1)-1);
Dead=RouletteSelectParent(Ranks)+1;
Pop(Dead,:)=NewInd;
NewPop=SortPop(Pop);

function[Parent]=SelectParent(Pop)
Ranks=size(Pop,1):-1:1;
PInd=RouletteSelectParent(Ranks);
Parent=Pop(PInd,:);

function[Child]=SelectPsAndX(Pop)
Ranks=size(Pop,1):-1:1;
PInd1=RouletteSelectParent(Ranks);
Ranks=size(Pop,1)-1:-1:1;
PInd2=RouletteSelectParent(Ranks);
if(PInd2>=PInd1)
   PInd2=PInd2+1;
end
P1=Pop(PInd1,:);
P2=Pop(PInd2,:);
Child=Crossover(P1,P2);

function OutputPopStats(Pop,Gen,PopNum,FileN,TrainS,TestS,Gamma,C,Thresh,Scale,Equal)
global POPSIZE DUMPEVERY;

if(Gen==0)
   Inds=Gen;
   MeanFs=mean(Pop(:,end));
   BestFs=Pop(1,end);
   WorstFs=Pop(end,end);
   StdFs=std(Pop(:,end));
   BestInds=Pop(1,:);
   TestBest=RbfTest(Pop(1,:),TrainS,TestS,Gamma,C,Thresh,Scale,Equal);
   dummy=[Inds MeanFs(end) BestFs(end) WorstFs(end) StdFs(end) TestBest]
	save(FileN,'Inds','MeanFs','BestFs','WorstFs','StdFs','BestInds','TestBest','Pop','Gamma','C','Scale','Thresh','Equal');
elseif(mod(PopNum,DUMPEVERY)==0)
   load(FileN,'MeanFs','BestFs','WorstFs','StdFs','BestInds','TestBest');
   Inds=0:DUMPEVERY:(Gen-1)*POPSIZE+PopNum;
   MeanFs=[MeanFs mean(Pop(:,end))];
   BestFs=[BestFs Pop(1,end)];
   WorstFs=[WorstFs Pop(end,end)];
   StdFs=[StdFs std(Pop(:,end))];
   BestInds=[BestInds;Pop(1,:)];
   TestF=RbfTest(Pop(1,:),TrainS,TestS,Gamma,C,Thresh,Scale,Equal);
   TestBest=[TestBest TestF];
	dummy=[Gen MeanFs(end) BestFs(end) WorstFs(end) StdFs(end) TestF]
   save(FileN,'Inds','MeanFs','BestFs','WorstFs','StdFs','BestInds','Pop','TestBest','Gamma','C','Scale','Thresh','Equal');
end

function[NewPop]=GetInitialPop(Pop,Ratio,TrainS,TestS,Gamma,C,Thresh,Scale,Equal)
[X,Y]=size(Pop);
Pop=rand(X,Y);
Pop=Pop<Ratio;
Pop(:,end)=zeros(X,1);
for i=1:size(Pop,1)
   Pop(i,end)=Test(Pop(i,:),TrainS,TestS,Gamma,C,Thresh,Scale,Equal);
end
NewPop=SortPop(Pop);

function[NewPop]=SortPop(Pop)
Fits=Pop(:,end);
[Y,I]=sort(Fits);
I=invert(I);
NewPop=Pop(I,:);
