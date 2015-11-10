function ShowSliceSDDiffsV2(Timee,NumBins)

if(nargin<2) NumBins=20;end;
if(nargin<1) Timee=1000;end;

wid=[1 5];
colormap('gray');
Pt=150;
d3dmm;
for i=1:2
	fn=['MaxW'x2str(wid(i)) 'Rho100/TreeSst1OneDSlicesGr300X100Z100Sq1Sp10T'x2str(Timee) '.mat'];
	load(fn);
   PtConcs(i,:)=Slices(1:30,Pt)';
end
MinConc=min(min(PtConcs));
MaxConc=max(max(PtConcs));
Inter=(MaxConc-MinConc)/(NumBins-1);
BinCentres=MinConc:Inter:MaxConc
subplot('Position',[0.075 0.1 0.4 0.8])
[FBins,Bins]=hist(PtConcs(1,:)',BinCentres);
MaxF=max(FBins);
bar(Bins*1.324e-4,FBins,1,'b');
axis([[MinConc-.5*Inter MaxConc+.5*Inter]*1.324e-4 0 MaxF])
SetXTicks(gca,5,1e6,2,BinCentres(1:3:end)*1.324e-4)
XLabel('Concentration (\muM)')
YLabel('Frequency')
set(gca,'Box','off','TickDir','out')
h=legend('Width=1 \mum',1);
LegBoxOff(h)

subplot('Position',[0.575 0.1 0.4 0.8])
[FBins,Bins]=hist(PtConcs(2,:)',BinCentres);
%MyBar(0.005,['g'],Bins*1.324e-4,FBins,1);
bar(Bins*1.324e-4,FBins,1,'g');
axis([[MinConc-.5*Inter MaxConc+.5*Inter]*1.324e-4 0 MaxF])
SetXTicks(gca,5,1e6,2,BinCentres(1:3:end)*1.324e-4)
XLabel('Concentration (\muM)')
YLabel('Frequency')
set(gca,'Box','off','TickDir','out')
h=legend('Width=5 \mum',1);
LegBoxOff(h)
