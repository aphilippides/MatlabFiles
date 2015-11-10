function Visit1_3dPlot(Scale)

close
global FSize;FSize=8;
FWid=0.21;
FHt2=0.4;
FHt1=0.25;
Ht2=0.54;
Ht1=0.11;
C=[0.1 1 5 10 50 100 150 200 500 1000 1e4 1e5];
Gamm=[0.01 0.1 0.5 1 2 2.5:2.5:10 25:25:100 150:50:500 1e3 5e3 1e4];
xtpos=[1:3:12];
ytpos=[1:4:24];
%load(['RBFSVMSc' int2str(Scale) '_LH4.mat']);
load(['RBFSVMSc' int2str(Scale) '_LHNot4.mat']);
CMax=max(max([Rate MRate]));
CMin=min(min([Rate MRate]));
Cs=[CMin CMax];
h=figure;
set(h,'Units','centimeters','Position',[5 10 16 6])

h=subplot('position',[.075 Ht2 FWid FHt2]);pcolor(MRate);
set(h,'XTick',xtpos,'XTickLabel',C(xtpos));
set(h,'YTick',ytpos,'YTickLabel',Gamm(ytpos));
h=xlabel('C','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1) Pos(2)+.05 Pos(3)])
h=ylabel('Gamma','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1)+.015 Pos(2) Pos(3)])
h=title('Cross-Validation','Units','normalized');
Pos=get(h,'Position');set(h,'Position',[Pos(1) 1.02 Pos(3)])
set(gca,'FontSize',FSize)
caxis(Cs);h=colorbar;set(h,'FontSize',FSize)

h=subplot('position',[.42 Ht2 FWid FHt2]);pcolor(Rate);
set(h,'XTick',xtpos,'XTickLabel',C(xtpos));
set(h,'YTick',ytpos,'YTickLabel',Gamm(ytpos));
h=xlabel('C','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1) Pos(2)+.05 Pos(3)])
h=ylabel('Gamma','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1)+.015 Pos(2) Pos(3)])
h=title('Test','Units','normalized');
Pos=get(h,'Position');set(h,'Position',[Pos(1) 1.02 Pos(3)])
set(gca,'FontSize',FSize)
caxis(Cs);h=colorbar;set(h,'FontSize',FSize)

RatioOfBads=MLabsAll_1_2(:,:,2)./(MLabsAll_1_2(:,:,2)+MLabsAll_1_2(:,:,3));
h=subplot('position',[.75 Ht2 FWid FHt2]);pcolor(RatioOfBads);
set(h,'XTick',xtpos,'XTickLabel',C(xtpos));
set(h,'YTick',ytpos,'YTickLabel',Gamm(ytpos));
h=xlabel('C','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1) Pos(2)+.05 Pos(3)])
h=ylabel('Gamma','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1)+.015 Pos(2) Pos(3)])
h=title('Ratio of Mis-labelled Data','Units','normalized');
Pos=get(h,'Position');set(h,'Position',[Pos(1) 1.02 Pos(3)])
set(gca,'FontSize',FSize)
h=colorbar;set(h,'FontSize',FSize)

h=subplot('position',[.075 Ht1 FWid FHt1]);plot(MRate);
axis tight;box off;
set(h,'XTick',ytpos,'XTickLabel',Gamm(ytpos),'TickDir','out');
h=xlabel('Gamma','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1) Pos(2)+.05 Pos(3)])
h=ylabel('Score','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1)+.015 Pos(2) Pos(3)])
h=title('Cross-Validation','Units','normalized');
Pos=get(h,'Position');set(h,'Position',[Pos(1) 1.02 Pos(3)])
set(gca,'FontSize',FSize)

h=subplot('position',[.4 Ht1 .55 FHt1]);BarTops(Scale,12,Gamm)
Rate
MRate
eval(['print -depsc Visit13dSc' int2str(Scale) 'LHNot4.eps'])
%eval(['print -dai Visit13dSc' int2str(Scale) '.ai'])

function BarTops(Scale,TopNum,Gamm)
global FSize;
load(['RBFSVMSc' int2str(Scale) '_LHNot4.mat']);
%load(['RBFSVMSc' int2str(Scale) '_LH4.mat']);
TopTen=GetMaxVals(MRate,TopNum,1);
N=size(TopTen,1);
for i=1:N
   RateTen(i)=Rate(TopTen(i,2),TopTen(i,3));
end
bar(1:N,[TopTen(:,1) RateTen'])
YMax=1.05*max(max([TopTen(:,1) RateTen']));
YMin=0.9*min(min([TopTen(:,1) RateTen']));
YMin=0.5;
YMax=0.75;
box off
TitleStr=['Best ' num2str(TopNum) ' SVMs'];
h=ylabel('Score','Units','normalized');Pos=get(h,'Position');
set(h,'Position',[Pos(1)+.005 Pos(2) Pos(3)])
h=title(TitleStr,'Units','normalized');
Pos=get(h,'Position');set(h,'Position',[Pos(1) 1.02 Pos(3)])
TopTen(:,2)
set(gca,'YLim',[YMin YMax],'TickDir','out','XTickLabel',Gamm(TopTen(:,2)'),'FontSize',FSize); 
h=legend('Cross-Validation','Test',1);
set(h,'FontSize',7,'Box','off')

for i=1:N
   TextStr=num2str(C(TopTen(i,3)));
   if(C(TopTen(i,3))==1000) TextStr='1e3';
   elseif(C(TopTen(i,3))==10000) TextStr='1e4';
   elseif(C(TopTen(i,3))==100000) TextStr='1e5';
   end
   x=length(TextStr)/2;
   text(i/(N+1)-x*.015,-.35,TextStr,'Units','normalized','FontSize',FSize);   
end
text(-.075,-.17,'Gamma =','Units','normalized','FontSize',FSize);   
text(-.0,-.34,'C =','Units','normalized','FontSize',FSize);   
