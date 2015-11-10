function Visit1BestPlots

Scales=[0:7];
TopNum=10;
for i=1:1
   BarTopVals(Scales(i),TopNum)
end

function BarTopVals(Scale,TopNum)
load(['RBFSVMSc' int2str(Scale) '_LH4.mat']);
TopTen=GetMaxVals(MRate,TopNum,1);
N=size(TopTen,1);
for i=1:N
   RateTen(i)=Rate(TopTen(i,2),TopTen(i,3));
end
bar(1:N,[TopTen(:,1) RateTen'])
YMax=1.05*max(max([TopTen(:,1) RateTen']));
YMin=0.9*min(min([TopTen(:,1) RateTen']));
set(gca,'YLim',[YMin YMax],'TickDir','out','XTickLabel',[]); 
legend('CrossVal','Test')
colormap('winter')

h=xlabel(['Gammas = ' num2str(Gamma(TopTen(:,2))')]); 
set(h,'Units','normalized')
X=get(h,'Position');
set(h,'Position',[X(1) X(2)+.025 0])
TextStr=['   Cs = ' num2str(C(TopTen(:,3)))];
text(X(1)-.5,X(2)-.05,TextStr,'Units','normalized'); 
title(['Scale Type = ' int2str(Scale) ]);
%eval(['print -depsc LH4Sc' int2str(Scale) '.eps']);
