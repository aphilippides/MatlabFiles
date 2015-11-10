function CalcNeutrality(Dn)
dvolsig
%Dns={'VS_HalfFlat2';'VS_OrigData'};
cd(Dn);
[All,Bests]=GetElites;
for i=1:length(All)
    [NonNeut(i),Neut1(i),Neut2(i)]=CalcNeut(i);
end
AvgNon=mean(NonNeut) 
AvgN1=mean(Neut1)
AvgN2=mean(Neut2)
SDNon=std(NonNeut)
SDN1=std(Neut1)
SDN2=std(Neut2)
save ConnScoreAllFlat.mat All NonNeut Neut1 Neut2 AvgNon AvgN1 AvgN2 SDNon SDN1 SDN2

length(Bests)
AvgNon=mean(NonNeut(Bests)) 
AvgN1=mean(Neut1(Bests))
AvgN2=mean(Neut2(Bests))
SDNon=std(NonNeut(Bests))
SDN1=std(Neut1(Bests))
SDN2=std(Neut2(Bests))
save ConnScoreEliteFlat.mat Bests NonNeut Neut1 Neut2 AvgNon AvgN1 AvgN2 SDNon SDN1 SDN2
mean(Neut2/NonNeut)

function[NNot,N1,N2]=CalcNeut(R)

fn=['NeutralDataRun' int2str(R) '.dat'];
M=load(fn);
NNot=length(find(M(2:end,4:end)==-1))
N1=length(find(M(2:end,4:end)==0))+length(find(M(2:end,4:end)==1))
N2=length(find(M(2:end,4:end)==2))

function[All,Bests]=GetElites

M=load('RunLengths.dat');
[i]=find(M(:,2)<9999);
All=M(:,1);
Bests=M(i,1);


    