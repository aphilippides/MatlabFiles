% function to draw Figure4 at time Timez

function LobeX9_36B1(Time)

SingPlot(gcf)
if(nargin<1) Time=1;end;
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
Sq=2;
h=subplot('Position',[0.15 0.785 0.8 0.2]);
XT=1:10;
NumTs=XT.^2;
DataNeeded=0;
if(DataNeeded==1)
   AffVol=GetLobeAffVolumes(NumTs,Time,Sq,Space);
   dmat;
   save MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat AffVol; 
end
dmat
load MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat
SynthArea=(XT*(Space+Sq)-Space).^2;

plot(NumTs,AffVol,['b- .']);

axis tight
SetXTicks(h,0,1,-1,[1 25:25:100]) 
%SetTickLength(h,2.5);
h=xlabel('Number of sources');
MoveXYZ(h,0,0.02,0);
h=ylabel({'Affected volume';'(synthesising vol.)'},'Units','normalized');
MoveXYZ(h,-0.15,-0.175,0);
set(gca,'TickDir','out','Box','off')

AffVolPics(Time*1000)

FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 10 10]);
set(FigHdl,'PaperPositionMode','auto');

function[AffVol]= GetLobeAffVolumes(NumTs,Time,Square,Space)

dsmall
for i=1:length(NumTs)
   if(NumTs(i)==1)
      AffVol(i)=0;
   else      
      filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat'];
      M=load(filename);
      [X,Y]=size(M);
      Timez=M(2:X,1);
      NumOver=1e6-M(2:X,4);
      AffVol(i)=NumOver(find(Timez==Time));
   end
end
dtube

function AffVolPics(T)

colormap(gray)
FigWid=0.28;
FigHt=FigWid;
StartY2=0.35;
StartY=0.015;
StartX=0.125;
Sp=0.075;
x1=413;
x2=587;

dtube
DataNeeded=0;
if(DataNeeded==1)
	[M1,max1,min1]=GetLobeDat(2,10,9,T,x1,x2);
	[M2,max2,min2]=GetLobeDat(2,10,16,T,x1,x2);
	[M3,max3,min3]=GetLobeDat(2,10,25,T,x1,x2);
	[M4,max4,min4]=GetLobeDat(2,10,36,T,x1,x2);
   save('MeshPaper/Fig4Data/Fig4LobePicsData.mat','M1','M2','M3','M4', ...
      'max1','max2','max3','max4','min1','min2','min3','min4')
else
   load('MeshPaper/Fig4Data/Fig4LobePicsData.mat');
end

TitleAdj=-0.06;

AxLims=[min1 max4];
h=subplot('Position',[StartX StartY2 FigWid FigHt]);
LobePic(M1,AxLims)
set(h,'XTickLabel','','YTickLabel','')
DrawLengthBar(h,0.2857,0.1,0.1,'w',2)
h=title(['9 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[FigWid+Sp+StartX StartY2 FigWid FigHt]);
LobePic(M2,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['16 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[StartX StartY FigWid FigHt]);
LobePic(M3,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['25 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[(FigWid+Sp)+StartX StartY FigWid FigHt]);
LobePic(M4,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['36 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[0.8 StartY2 0.035 FigHt]);
colorbar(h)
XLim=get(h,'YLim');
LMid=(AxLims(2)+AxLims(1))/2;
XTLabs=sort([AxLims(1) LMid 2.5e-7 AxLims(2)]);
XTPos=GetTickPos(XLim,AxLims,XTLabs)';
Labs=num2str((XTLabs.*1e6)',2);
SetYTicks(h,0,1e6,2,XTPos,Labs);
set(h,'TickLength',[0 0],'FontSize',8,'Box','off')
ylabel('Concentration (\muM)')

h=subplot('Position',[0.8 StartY 0.035 FigHt]);
colorbar(h)
SetYTicks(h,0,1e6,2,XTPos,Labs);
set(h,'TickLength',[0 0],'FontSize',8,'Box','off')
ylabel('Concentration (\muM)')

function[XTPos]=GetTickPos(XLim,AxLims,XTLabs)

Fact=AxLims(2)-AxLims(1);
for i=1:length(XTLabs)
   Facts(i,1)=(AxLims(2)-XTLabs(i))/Fact;
   Facts(i,2)=(XTLabs(i)-AxLims(1))/Fact;
end
XTPos=Facts*XLim';

function LobePic(MData,AxLims)

aff=2.5e-7;
pcolor(MData);
caxis(AxLims)
shading interp
hold on
[c,h]=contour(MData,[aff aff],'w');
axis tight
hold off
XLim=get(gca,'XLim');
X1=XLim(1);
X2=XLim(length(XLim));
XPos=floor([X1 ((X1+X2)/2) X2]);
set(gca,'XTick',XPos,'XTickLabel',XPos-1)
set(gca,'YTick',XPos,'YTickLabel',XPos-1)

function[MData,MDataMax,MDataMin]=GetLobeDat(Square,Space,NumSources,Time,x1,x2)

r1=1;
dsmall
y1=x1;y2=x2;r2=r1;
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
dtube


function DrawLobeOutline(XS,Sq,Sp,T)

x1=400;
x2=600;
DataNeeded=0;
fname=['MeshPaper/Fig4Data/Fig4OutLineDataSq' int2str(Sq) 'Sp'int2str(Sp) '.mat'];
VarName=['ConcX'int2str(XS) 'T'int2str(T)];
if(DataNeeded)
   eval([VarName '=GetLobeDat(Sq,Sp,XS,T,x1,x2);']);
   a=dir(fname);
   if(length(a)==0)
   	save(fname,VarName)
	else
   	save(fname,VarName,'-append')
   end
end
load(fname);
eval(['M=' VarName ';']);
edge=40;
[X,Y]=size(M);
MData=M(edge+1:X-edge,edge+1:Y-edge);
aff=2.5e-7;
SynthArea=(sqrt(XS)*(Sp+Sq)-Sp);
pcolor(MData<aff);
caxis([-3 1])
colormap(gray)
shading interp
hold on

centx=X/2-edge;
centy=Y/2-edge;
Xl=(sqrt(XS)-1)/2;
left=centx-Xl*Sp;
right=centx+Xl*Sp;
bott=centy-Xl*Sp;
top=centy+Xl*Sp;

% Draw White
XW=[left right right left left];
YW=[bott bott top top bott];
%h=patch(XW,YW,'r'),set(h,'EdgeColor','b')

XRow=sqrt(XS);
DrawSources(left,right,top,bott,Sp,XRow)
%DrawBox(left,right,top,bott,XRow,Sp)

[c,h]=contour(MData,[aff aff],'k--');
axis square
hold off
set(gca,'TickLength',[0 0],'XTickLabel','','YTickLabel','','Box','off')
axis off

function DrawSources(left,right,top,bott,Sp,X)

hold on
XLine=[left right right left left];
YLine=[bott bott top top bott];
plot(XLine,YLine,'k')
Xes=left:Sp:right;
Ys=bott:Sp:top;
for i=1:length(Xes)
   Xs=ones(1,X)*Xes(i);
  h=plot(Xs,Ys,'bo');
  set(h,'MarkerSize',3,'MarkerFaceColor','b')
end

function DrawBox(left,right,top,bott,X)

Xes=left:(Sp):right;
Ys=bott:(Sp):top;
botts=ones(1,X)*bott;
tops=ones(1,X)*top;
rights=ones(1,X)*right;
lefts=ones(1,X)*left;
SourceX=[Xes rights invert(Xes) lefts];
SourceY=[botts Ys tops invert(Ys)];
plot(SourceX,SourceY,'b:o')

