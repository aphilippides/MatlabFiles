function DrugAllGA(TrainS,TestS,Thresh,Equal,SaveFName,Scale)

XRate=0.2;
MRate=0.01;
NumGens=100;
global POPSIZE DUMPEVERY CMAX CMIN MINGAM MAXGAM SCALES;
global SDMUT MEANC SDC MEANGAM SDGAM;
POPSIZE=100;
DUMPEVERY=10;
CMAX=1e4; CMIN=0.1; MEANC=100; SDC=50;
MINGAM=0.05; MAXGAM=1e4; MEANGAM=200; SDGAM=100;
if(Scale<0)
   SCALES=0:7;
else
   SCALES=ones(1,8).*Scale;
end
SDMUT=5;
IndLen=220;  % Gamma, C, Scale, 216 Chems, Fitness
Pop=zeros(POPSIZE,IndLen);
Pop=GetInitialPop(Pop,0.5,TrainS,TestS,Thresh,Equal);
OutputPopStats(Pop,0,0,SaveFName,TrainS,TestS,Thresh,Equal);

for Gen=1:NumGens
   for i=1:POPSIZE
      Ch=CreateChild(Pop,XRate,MRate);
      Ch(end)=TestRbfX(Ch,TrainS,TestS,Thresh,Equal);
      Pop=UpdatePop(Pop,Ch);
      OutputPopStats(Pop,Gen,i,SaveFName,TrainS,TestS,Thresh,Equal);  
	end
end

function[Fitness]=TestRbfX(Ind,TrainS,TestS,Thresh,Equal)
Used=[find(Ind(4:end-1)) 217];
NonZeros=[1 [find(Ind(4:end-1))+1] 218];
Gamma=Ind(1);
C=Ind(2);
Scale=Ind(3);
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
[Fitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,0,Used);

function[TFitness]=TestRbf(Ind,TrainS,TestS,Thresh,Equal)
Used=[find(Ind(4:end-1)) 217];
NonZeros=[1 [find(Ind(4:end-1))+1] 218];
Gamma=Ind(1);
C=Ind(2);
Scale=Ind(3);
TrainSet=TrainS(:,NonZeros);
TestSet=TestS(:,NonZeros);
[TFitness]=RbfSVM_GA(Scale,Gamma,C,TrainSet,TestSet,Equal,Thresh,1,Used);

function[Child]=CreateChild(Pop,XRate,MRate)
if(rand<XRate)
   Child=SelectPsAndX(Pop);
else
   Child=SelectParent(Pop);
end
Child=MutateChild(Child,MRate);

function[MutCh]=MutateChild(Ch,MRate)
global CMAX CMIN MINGAM MAXGAM SCALES SDMUT;
if(rand<MRate)
   NewGam=randn*SDMUT+Ch(1);
   NewGam=min(MAXGAM,NewGam);
   Ch(1)=max(MINGAM,NewGam);
end
if(rand<MRate)
   NewC=randn*SDMUT+Ch(2);
   NewC=min(CMAX,NewC);
   Ch(2)=max(CMIN,NewC);
end
if(rand<1)%MRate)
   Ch(3)=SCALES(min(8,IRnd(8)+1));
   Ch(3)=SCALES(min(8,8+1));
end
MutCh=[Ch(1:3) MutateBinary(Ch(4:end-1),MRate) 0];

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

function OutputPopStats(Pop,Gen,PopNum,FileN,TrainS,TestS,Thresh,Equal)
global POPSIZE DUMPEVERY;
if(Gen==0)
   Inds=Gen;
   MeanFs=mean(Pop(:,end));
   BestFs=Pop(1,end);
   WorstFs=Pop(end,end);
   StdFs=std(Pop(:,end));
   BestInds=Pop(1,:);
   TestBest=TestRbf(Pop(1,:),TrainS,TestS,Thresh,Equal);
   dummy=[Inds MeanFs(end) BestFs(end) WorstFs(end) StdFs(end) TestBest]
	save(FileN,'Inds','MeanFs','BestFs','WorstFs','StdFs','BestInds','TestBest','Pop','Thresh','Equal');
elseif(mod(PopNum,DUMPEVERY)==0)
   load(FileN,'MeanFs','BestFs','WorstFs','StdFs','BestInds','TestBest');
   Inds=0:DUMPEVERY:(Gen-1)*POPSIZE+PopNum;
   MeanFs=[MeanFs mean(Pop(:,end))];
   BestFs=[BestFs Pop(1,end)];
   WorstFs=[WorstFs Pop(end,end)];
   StdFs=[StdFs std(Pop(:,end))];
   BestInds=[BestInds;Pop(1,:)];
   TestF=TestRbf(Pop(1,:),TrainS,TestS,Thresh,Equal);
   TestBest=[TestBest TestF];
	dummy=[Gen MeanFs(end) BestFs(end) WorstFs(end) StdFs(end) TestF]
   save(FileN,'Inds','MeanFs','BestFs','WorstFs','StdFs','BestInds','Pop','TestBest','Thresh','Equal');
end

function[NewPop]=GetInitialPop(Pop,Ratio,TrainS,TestS,Thresh,Equal)
global CMAX CMIN MINGAM MAXGAM SCALES MEANC SDC MEANGAM SDGAM;
[X,Y]=size(Pop);
Pop=rand(X,Y);
Pop=Pop<Ratio;				% Get the binary bits of the genome
Pop(:,end)=zeros(X,1);

Gams=randn(X,1).*(SDGAM)+MEANGAM;
Gams=max(MINGAM,Gams);
Pop(:,1)=min(MAXGAM,Gams);		% Get the Gamma bits

Cs=randn(X,1).*(SDC)+MEANC;
Cs=max(CMIN,Cs);
Pop(:,2)=min(CMAX,Cs);		% Get the C bits

Scales=floor(rand(X,1).*8)+1;
Scales=SCALES(min(7,Scales));	
Pop(:,3)=Scales';		% Get the Scale types

for i=1:size(Pop,1)
   Pop(i,end)=TestRbfX(Pop(i,:),TrainS,TestS,Thresh,Equal);
end
NewPop=SortPop(Pop);

function[NewPop]=SortPop(Pop)
Fits=Pop(:,end);
[Y,I]=sort(Fits);
I=invert(I);
NewPop=Pop(I,:);