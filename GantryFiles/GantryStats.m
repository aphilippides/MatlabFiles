function GantryStats(is)
dvolsig;
%Overlap;
%MutantFitnesses
%ConnectivityPatterns
%Plots(is)
plotZnonz

function plotZnonz
load VS_HF2OnePtZeroNonZFitsMeans
load VS_HF2OnePtZeroNonZNums
% load VS_OrigOnePtZeroNonZFitsMeans
% load VS_OrigOnePtZeroNonZNums

% bar([ MeanBothNonZero' MeanOnlyElecNonZero' MeanOnlyGasNonZero' MeanBothZero'])
ms=[mean(MeanBothNonZero) mean(MeanOnlyElecNonZero) mean(MeanOnlyGasNonZero) ];% mean(MeanBothZero)]
sds=[std(MeanBothNonZero) std(MeanOnlyElecNonZero) std(MeanOnlyGasNonZero) ];% std(MeanBothZero)]

figure
Singplot
set(gca,'FontSize',16)
barerrorbar([],ms,sds),setbox,YLim([0 1])
% figure
% [n,x]=hist(GasNonZero,50)
% bar(x,n/NumAll),title('Gas non-zero only');
% figure
% [n,x]=hist(ElecNonZero,50)
% bar(x,n/NumAll),title('Elec non-zero only');
% figure
% [n,x]=hist(BothNonZero,50)
% bar(x,n/NumAll),title('Both non-zero');

figure
Singplot
set(gca,'FontSize',16)
% bar([ MeanBothNonZero' MeanOnlyElecNonZero' MeanOnlyGasNonZero' MeanBothZero'])
ms=[mean(NumBothNonZero./NumAll) mean(NumElecNonZero./NumAll) mean(NumGasNonZero./NumAll) ]%mean(MeanBothZero)]
sds=[std(NumBothNonZero./NumAll) std(NumElecNonZero./NumAll) std(NumGasNonZero./NumAll) ]%std(MeanBothZero)]
barerrorbar([],ms,sds),setbox,YLim([0,0.2])
% [n,x]=hist(GasNonZero,50)
% bar(x,n/NumAll),title('Gas non-zero only');
% figure
% [n,x]=hist(ElecNonZero,50)
% bar(x,n/NumAll),title('Elec non-zero only');
% figure
% [n,x]=hist(BothNonZero,50)
% bar(x,n/NumAll),title('Both non-zero');

function Plots(ilist)
load AllOnePtFitnesses;
fso=[];fsv=[];
for i=1:length(ilist)
    fsv=[fsv OnePtFitnessesV(ilist(i),:)];
end
for i=1:length(ilist)
    if(ilist(i)<14) fso=[fso OnePtFitnessesO(ilist(i),:)];
    elseif(ilist(i)>15) fso=[fso OnePtFitnessesO(ilist(i)-2,:)];
    end
end
[y1,x1]=hist(fso,50);
[y2,x2]=hist(fsv,50);
maxht=1.1*max(max(y1/length(fso)),max(y2/length(fsv)));
subplot(2,1,1),bar(x1,y1/length(fso)),SetYLim(gca,0,maxht);
subplot(2,1,2),bar(x2,y2/length(fsv)),SetYLim(gca,0,maxht);

function MutantFitnesses
cd VS_HalfFlat2
OnePtFitnessesV=[];gasv=[];OnePtFitnessesO=[];gaso=[];
for i=1:10
  %  figure
    %[genescoreVS(i,:),genestdVS(i,:)]=MutantFitnessV(i);
    [e,g]=MutantFitnessV(i);
    OnePtFitnessesV=[OnePtFitnessesV e];
    gasv=[gasv g];
end
cd ../VS_OrigData
for i=1:10
 %   figure;
    [newe,g]=MutantFitnessO(i);
    OnePtFitnessesO=[OnePtFitnessesO newe];
    gaso=[gaso g];
end
save ../AllOnePtFitnesses.mat  OnePtFitnessesO OnePtFitnessesV

function[genescore,genestd]=MutantFitnessV(i)
p=load(['MutantDataRun' int2str(i) '.dat']);
fs=p(2:end,7:end);
numn=p(1,1);
m=mean(fs');
%bar(frequencies(m));
f=numn*100;
elecs=[2*f+1:8*f 17*f+1:18*f];
gs=[11*f+1:15*f 19*f+1:21*f];
for i=0:20
    genescore(i+1,:)=m([i*f+1:(i+1)*f]);
end
    genestd=m(gs);
    %mean(m([i*f+1:(i+1)*f]));
    %std(m([i*f+1:(i+1)*f]));
%figure,errorbar(genescore,genestd)

function[genescore,genestd]=MutantFitnessO(i)
p=load(['MutantDataRun' int2str(i) '.dat']);
fs=p(2:end,7:end);
numn=p(1,1);
m=mean(fs');
%bar(frequencies(m));
f=numn*100;
elecs=[2*f+1:8*f 17*f+1:18*f];
gs=[11*f+1:13*f 19*f+1:21*f];
for i=[0:12]
    genescore(i+1,:)=m([i*f+1:(i+1)*f]);
end
for i=[15:20]
    news(i-14,:)=m([i*f+1:(i+1)*f]);
end
genescore=[genescore;news];

genestd=m(gs);

function Overlap
cd VS_HalfFlat2
for i=1:20
    c(i)=CheckOverlap(i);
end
cd ../VS_HalfFlat3
for i=1:20
    d(i)=CheckOverlap(i);
end
VSCorrcoeffAll=[c d];
% bar(VSCouplingAll)
VSCorrcoeffElite=VSCorrcoeffAll([1:3 5:23 25:35 37:40]);
cd ../VS_OrigData
for i=1:40
%     CouplingOrigAll(i)=CheckOverlap(i);
    CorrcoeffOrigAll(i)=CheckOverlap(i);
end
% CouplingOrigElite=CouplingOrigAll([1:2 4:17 20:21 24 26:35 37:40]);
% save ../NewCouplingStats.mat VSCouplingAll CouplingOrigAll CouplingOrigElite VSCouplingElite
% figure, bar(CouplingOrigAll)

CorrcoeffOrigElite=CorrcoeffOrigAll([1:2 4:17 20:21 24 26:35 37:40]);
save ../NewCorrcoeffStats.mat VSCorrcoeffAll CorrcoeffOrigAll CorrcoeffOrigElite VSCorrcoeffElite
mean(CorrcoeffOrigElite)
mean(VSCorrcoeffElite)
std(CorrcoeffOrigElite)
std(VSCorrcoeffElite)

figure, bar([CorrcoeffOrigAll; VSCorrcoeffAll])
figure, bar([CorrcoeffOrigElite; VSCorrcoeffElite])


function[comm]=CheckOverlap(i)

p=load(['Run' int2str(i) '/PosActivFrom.dat']);
n=load(['Run' int2str(i) '/NegActivFrom.dat']);
g=load(['Run' int2str(i) '/GasConcFrom.dat']);
e=abs(p-n);
% for i=1:size(g,2)
%     [c,p]=corrcoef([e(:,i) g(:,i)]);
%     corr(i)=c(1,2)
%     pval(i)=p(1,2)
% end
num_e=length(find(e>0))
num_g=length(find(abs(g)>0))
num_both=length(find((abs(g).*e)>0))
%subplot(3,1,1),pcolor(e),shading flat
%subplot(3,1,2),pcolor(abs(g)),shading flat
%subplot(3,1,3),pcolor(abs(g).*e),shading flat
comm=num_both/num_g

function ConnectivityPatterns
cd VS_HalfFlat2
NumAll=0;GasNonZero=[];ElecNonZero=[];BothNonZero=[];
for i=1:10
    %[MeanOnlyGasNonZero(i),MeanOnlyElecNonZero(i),MeanBothZero(i),MeanBothNonZero(i),MeanOneNonZero(i),MeanAll(i)]=ConnectivityPattern(i,0)
    [gnz,enz,bnz,na]=ConnectivityPattern(i,0);
    GasNonZero = [GasNonZero gnz'];
    ElecNonZero = [ElecNonZero enz'];
    BothNonZero = [BothNonZero bnz'];
    NumAll=NumAll+na;
end
%save ../VS_HF2OnePtZeroNonZFitsMeans.mat MeanOnlyGasNonZero MeanOnlyElecNonZero MeanBothZero MeanBothNonZero MeanOneNonZero MeanAll
save ../VS_HF2OnePtZeroNonZFitsV2.mat GasNonZero ElecNonZero BothNonZero NumAll

cd ../VS_OrigData
NumAll=0;GasNonZero=[];ElecNonZero=[];BothNonZero=[];
for i=1:10
    [gnz,enz,bnz,na]=ConnectivityPattern(i,1);
    GasNonZero = [GasNonZero gnz'];
    ElecNonZero = [ElecNonZero enz'];
    BothNonZero = [BothNonZero bnz'];
    NumAll=NumAll+na;
end
save ../VS_OrigOnePtZeroNonZFitsV2.mat GasNonZero ElecNonZero BothNonZero NumAll

function[og,oe,bnz,all]=ConnectivityPattern(i,orig)
p=load(['Run' int2str(i) '/OnePtConnDiffs.dat']);
q=load(['MutantDataRun' int2str(i) '.dat']);
numn=q(1,1);
NonIdenticals=find(q(2:end,5));
fa=numn*100;
if(orig)
    is=[2:13*fa+1 15*fa+2:21*fa+1];
else
    is=[2:21*fa+1];
end
es=p(is,4)+p(is,5);
g=p(is,6);
f=mean(q(is,7:end),2);

nonz=find(es>0);
zs=find(es==0);
nonzg=find(g>0);
zsg=find(g==0);

% onlyg=intersect(zs,nonzg);
% onlye=intersect(zsg,nonz);
% bothnz=intersect(nonzg,nonz);
% bothz=intersect(zsg,zs);
% onenz=union(nonzg,nonz);

onlyg=union(intersect(zs,nonzg),NonIdenticals);
onlye=union(intersect(zsg,nonz),NonIdenticals);
bothnz=union(intersect(nonzg,nonz),NonIdenticals);
bothz=union(intersect(zsg,zs),NonIdenticals);
onenz=union(union(nonzg,nonz),NonIdenticals);

og=size(onlyg,1)
oe=size(onlye,1)
bnz=size(bothnz,1)
onez=size(onenz,1)
bz=size(bothz,1)
all=size(f,1)

oe=f(onlye);
bnz=f(bothnz);
bz=f(bothz);
og=f(onlyg);
onenz=f(onenz);
% figure
% [n,x]=hist(f(onenz),50);
% bar(x,n/onez),title('all non zeros')
% figure
% [n,x]=hist(f(onlye),50);
% bar(x,n/oe),title('only elec non zero')
% figure
% [n,x]=hist(f(onlyg),50);
% bar(x,n/og),title('only gas non zero')
% figure
% [n,x]=hist(f(bothnz),50);
% bar(x,n/bnz),title('both non zero')

