function CalcNeutrality(Dn)
dvolsig
%Dns={'VS_HalfFlat2';'VS_OrigData'};
cd(Dn);
Bests=1:5;
for i=1:length(Bests)
    [Neut3(i,:)]=CalcNeutFitGene(Bests(i));
end
[All,Bests]=GetElites;
for i=1:length(All)
    %[NonNeut(i),Neut1(i),Neut2(i)]=CalcNeut(i);
end
for i=1:length(All)
    [NonNeut(i,:),Neut0(i,:),Neut1(i,:),Neut2(i,:)]=CalcNeutGene(i);
end
AvgNon=mean(NonNeut) 
AvgN0=mean(Neut0)
AvgN1=mean(Neut1)
AvgN2=mean(Neut2)
SDNon=std(NonNeut)
SDN0=std(Neut0)
SDN1=std(Neut1)
SDN2=std(Neut2)
%save NeutralityAll.mat All NonNeut Neut0 Neut1 Neut2 AvgNon AvgN1 AvgN2 SDNon SDN1 SDN2
save NeutralityGeneAll.mat All NonNeut Neut0 Neut1 Neut2 AvgNon AvgN0 AvgN1 AvgN2 SDNon SDN0 SDN1 SDN2
errorbar(AvgN2,SDN2)

clear N* A* S*
for i=1:length(Bests)
    %[NonNeut(i),Neut1(i),Neut2(i)]=CalcNeut(i);
end
for i=1:length(Bests)
    [NonNeut(i,:),Neut0(i,:),Neut1(i,:),Neut2(i,:)]=CalcNeutGene(Bests(i));
end
figure
AvgNon=mean(NonNeut) 
AvgN0=mean(Neut0)
AvgN1=mean(Neut1)
AvgN2=mean(Neut2)
AvgN3=mean(Neut3)
SDNon=std(NonNeut)
SDN0=std(Neut0)
SDN1=std(Neut1)
SDN2=std(Neut2)
SDN3=std(Neut3)
%save NeutralityElite.mat Bests NonNeut Neut0 Neut1 Neut2 AvgNon AvgN1 AvgN2 SDNon SDN1 SDN2
save NeutralityGeneElite.mat Bests NonNeut Neut0 Neut1 Neut2 Neut3 AvgNon AvgN0 AvgN1 AvgN2 AvgN3 SDNon SDN0 SDN1 SDN2 SDN3
errorbar(AvgN3,SDN3)


function[NNot,N1,N2]=CalcNeut(R)

fn=['NeutralDataRun' int2str(R) '.dat'];
M=load(fn);
NNot=length(find(M(2:end,4:end)==-1));
N1=length(find(M(2:end,4:end)==0))+length(find(M(2:end,4:end)==1));
N2=length(find(M(2:end,4:end)==2));

function[N]=CalcNeutFitGene(R)

NumGenes=21
fn=['NeutralDataRun' int2str(R) '.dat'];
M=load(fn);
nodes=M(1,2)
for i=1:NumGenes
    N(i)=length(find(M(nodes*(i-1)+2:nodes*i+1,7)==M(1,7)))/nodes;
end

function[NNot,N0,N1,N2]=CalcNeutGene(R)

NumGenes=21
fn=['NeutralDataRun' int2str(R) '.dat'];
M=load(fn);
nodes=M(1,2)
for i=1:NumGenes
    NNot(i)=length(find(M(nodes*(i-1)+2:nodes*i+1,4:end)==-1))/nodes;
    N0(i)=length(find(M(nodes*(i-1)+2:nodes*i+1,4:end)==0))/nodes;
    N1(i)=length(find(M(nodes*(i-1)+2:nodes*i+1,4:end)==1))/nodes;
    N2(i)=length(find(M(nodes*(i-1)+2:nodes*i+1,4:end)==2))/nodes;
end

function[All,Bests]=GetElites

M=load('RunLengths.dat');
[i]=find(M(:,2)<9999);
All=M(:,1);
Bests=M(i,1);


    