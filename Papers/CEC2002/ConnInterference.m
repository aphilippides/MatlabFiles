function ConnInterference(Dn)
dvolsig
%Dns={'VS_HalfFlat2';'VS_OrigData'};
cd(Dn);
[All,Bests]=GetElites;
for i=1:length(All)
    [ElecChem(i),PosChem(i),NegChem(i),NumPos(i),NumNeg(i),NumChem(i),NumEl(i)]=ConnScore(i);
    %[NonNeut(i),Neut1(i),Neut2(i)]=CalcNeutrality(i);
end
AvgEl=mean(ElecChem) 
AvgPos=mean(PosChem)
AvgNeg=mean(NegChem)
SDEl=std(ElecChem)
SDPos=std(PosChem)
SDNeg=std(NegChem)
save ConnScoreAll.mat All ElecChem PosChem NegChem AvgEl AvgPos AvgNeg SDEl SDPos SDNeg NumPos NumNeg NumChem NumEl

clear N* A* S*;
for i=1:length(Bests)
    [ElecChem(i),PosChem(i),NegChem(i),NumPos(i),NumNeg(i),NumChem(i),NumEl(i)]=ConnScore(Bests(i));
    %[NonNeut(i),Neut1(i),Neut2(i)]=CalcNeutrality(i);
end

length(Bests)
AvgEl=mean(ElecChem) 
AvgPos=mean(PosChem)
AvgNeg=mean(NegChem)
SDEl=std(ElecChem)
SDPos=std(PosChem)
SDNeg=std(NegChem)
save ConnScoreElite.mat Bests ElecChem PosChem NegChem AvgEl AvgPos AvgNeg SDEl SDPos SDNeg NumPos NumNeg NumChem NumEl
[mean(NumEl) std(NumEl)]
[mean(NumChem) std(NumChem)]

function[El,Pos,Neg,np,nn,nc,ne]=ConnScore(R)
fn=['ConnMatrixRun' int2str(R) '.dat'];
M=load(fn);
N=size(M,2)-1;
PosC=M(1:N,2:end);
np=length(find(PosC>0))/N;
NegC=M(N+1:2*N,2:end);
nn=length(find(NegC>0))/N;
CemC=M(2*N+1:3*N,2:end)>0;
nc=length(find(CemC>0))/N;
PN=PosC|NegC;
ne=length(find(PN>0))/N;
PNC=PN&CemC;
PC=PosC&CemC;
NC=NegC&CemC;
El=2*sum(sum(PNC))/(sum(sum(PN))+sum(sum(CemC)));
Pos=2*sum(sum(PC))/(sum(sum(PosC))+sum(sum(CemC)));
Neg=2*sum(sum(NC))/(sum(sum(NegC))+sum(sum(CemC)));

function[N1,N2,NNot]=CalcNeutrality(R)

fn=['ConnMatrixRun' int2str(R) '.dat'];
M=load(fn);
NNot=length(find(M(2:end,4:end)==-1));
N1=length(find(M(2:end,4:end)==0))+length(find(M(2:end,4:end)==1));
N2=length(find(M(2:end,4:end)==2));

function[All,Bests]=GetElites

M=load('RunLengths.dat');
[i]=find(M(:,2)<9999);
All=M(:,1);
Bests=M(i,1);


    