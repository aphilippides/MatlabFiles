function CompareFit(n)

%dvolsig1;
%DirNs={'VS_OrigData';'VS_FlatData';'VS_ExpData'};
%DirNs={'VS_OrigData';'VS_HalfFlat2';'VS_HalfFlat3';'HalfFlatControl';'VS_OrigDataBug'};
%DirNs={'VS_OrigData';'VS_HalfFlatAll';'HalfFlatControl';'VS_ExpData';'VS_OrigDataBug'};
DirNs={'VS_OrigData';'EmitDec';'Delay';'VS_HalfFlatAll'};
if (nargin<1) n=length(DirNs); end
%CompPlot(DirNs,n);
OutputStats(DirNs,n)


function CompPlot(DirNs,n)
for i=1:n
   DirEx=char(DirNs(i)); 
	fn=['Data/' DirEx '/RunLengths.dat']; 
	M=load(fn);
   RLens(:,i)=M(1:20,2);
end
SLens=sort(RLens);
plot(M(1:20,1),SLens);
axis tight
xlabel('Runs (Sorted)')
ylabel('Generations')
legend(char(DirNs),1)
meds=median(RLens)
means=mean(RLens)
TStr=['median 'int2str(meds) ' mean ' num2str(means) ];
title(TStr)

OutputStats(DirNs,n)

function OutputStats(DirNs,n)

for i=1:n
   DirEx=char(DirNs(i)); 
	fn=['Data/' DirEx '/RunLengths.dat']; 
	M=load(fn);
    l=M(:,2);
    if (i==1) l=M(1:40,2); end
   best(i)=min(l);
   numruns(i)=size(M,1)
   worst(i)=max(l)
   means(i)=mean(l)
   medians(i)=median(l)
   sds(i)=std(l)
end
dthesisdat
save RunLengthDataCompAll.mat best numruns worst means  sds medians DirNs 
save RunLengthDataCompAll.dat best numruns worst means  sds medians -ascii
[h1,h2]=SubPlot2(gcf);
subplot(h1)
bar(medians)
xlabel('Type of network')
ylabel('Median run length (generations)')
legend(char(DirNs),1)
Setbox
subplot(h2)
errorbar(1:n,means,sds)
xlabel('Type of network')
ylabel('Mean run length (generations)')
Setbox;
dvolsig1
%legend(char(DirNs),1)