function ShowSliceSDDiffs(Timee,NumBins)

if(nargin<2)
   NumBins=15;
end
if(nargin<1)
   Timee=1;
end

wid=[1 4];
Cols=['r:','b '];
Pt=150;
d3dmm;
T=Timee*1000;
for i=1:2
	fn=['MaxW'x2str(wid(i)) 'Rho100/TreeSst1OneDSlicesGr300X100Z100Sq1Sp10T'x2str(T) '.mat'];
	load(fn);
   PtConcs(i,:)=Slices(:,Pt)';
end
MinConc=min(min(PtConcs));
MaxConc=max(max(PtConcs));
BinCentres=MinConc:(MaxConc-MinConc)/(NumBins-1):MaxConc;
[FBins,Bins]=hist(PtConcs',BinCentres)
for i=1:2
%   [FBins(i,:),Bins]=NumInBins(MinConc,MaxConc,NumBins,PtConcs(i,:))
end
%Bins1=[Bins(1) Bins];
%Bins2=[Bins Bins(end)];
MyBar(0.005,['b','g'],Bins*1.324e-4,FBins,1);
axis tight
SetXTicks(gca,6,1e6)
XLabel('Concentration (\muM)')
YLabel('Frequency')
set(gca,'Box','off','TickDir','out')
legend('Width=1','Width=4')