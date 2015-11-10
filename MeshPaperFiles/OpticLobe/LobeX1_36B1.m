% function to draw Figure4 at time Timez

function LobeX1_36B1(Time)
FHt=14;
FWid=9;
figure
set(gcf,'Units','centimeters');
X=get(gcf,'Position');
set(gcf,'Position',[X(1) X(2)-3 FWid FHt]);
set(gcf,'PaperPositionMode','auto');

if(nargin<1) Time=1;end;
Space=10;
Sq=2;
h=subplot('Position',[0.225 0.815 0.55 0.18]);
XT=1:10;
NumTs=XT.^2;
DataNeeded=1;
if(DataNeeded==1)
   AffVol100nM=GetLobeAffVolumesDiffThresh(NumTs,Time,Sq,Space,1e-7);
   dmat;
   save MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat AffVol100nM -append; 
end
dmat
load MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat
SynthArea=(XT*(Space+Sq)-Space).^2;
plot(NumTs,AffVol100nM,['k- .']);

axis tight
SetXTicks(h,0,1,-1,[1 25:25:100]) 
SetYTicks(h,3,1e-4) 
%SetTickLength(h,2.5);
h=xlabel('Number of sources');
MoveXYZ(h,0,0.02,0);
h=ylabel({'Affected volume';'(\mum^3 x10^4)'},'Units','normalized');
MoveXYZ(h,-0.075,-0.05,0);
set(gca,'TickDir','out','Box','off')

AffVolPics(Time*1000,FHt,FWid)

function[AffVol]= GetLobeAffVolumes(NumTs,Time,Square,Space)
dsmall
for i=1:length(NumTs)
   if(NumTs(i)==1)
      AffVol(i)=0;
   else      
      filename=['Lobe/MeshSSt1Gr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' int2str(Time) '.dat'];
      M=load(filename)*1.3240e-4;
      [X,Y]=size(M);
      Timez=M(2:X,1);
      NumOver=1e6-M(2:X,4);
      AffVol(i)=NumOver(find(Timez==Time));
   end
end
dtube

function[AffVol]= GetLobeAffVolumesDiffThresh(NumTs,Time,Square,Space,Thresh)
dsmall
t=Time*1000;
for i=1:length(NumTs)
      filename=['Lobe/Mesh2dCheckSSt1Gr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' int2str(t) '.dat'];
      M=load(filename)*1.3240e-4;
      AffVol(i)=length(find(M>=Thresh));
end
dtube

function AffVolPics(T,FHt,FWid)

colormap(FullGrayMap)
%colormap(imadjust(FullGrayMap,[],[],0.35))
%colormap(gray)
% dmat; load MeshPaperFiles/OPticLobe/LobeX1_36B1CMap;
% colormap(map)
FigWid=0.318;
Gap=0.04;
FigHt=FigWid*FWid/FHt;
StartY=0.01;
StartX=0.075;
Sp=0.075;
x1=64;      % x1 and x2 define limits of the pictures i.e from x1 to x2
x2=236;

dtube
DataNeeded=0;
if(DataNeeded==1)
	[M1,max1,min1]=GetLobeDat(2,10,1,T,x1,x2);
	[M2,max2,min2]=GetLobeDat(2,10,4,T,x1,x2);
	[M3,max3,min3]=GetLobeDat(2,10,9,T,x1,x2);
	[M4,max4,min4]=GetLobeDat(2,10,16,T,x1,x2);
	[M5,max5,min5]=GetLobeDat(2,10,25,T,x1,x2);
	[M6,max6,min6]=GetLobeDat(2,10,36,T,x1,x2);
   save('MeshPaper/Fig4Data/Fig4LobePicsData1_36.mat','M1','M2','M3','M4','M5','M6', ...
      'max1','max2','max3','max4','max5','max6','min1','min2','min3','min4','min5','min6')
else
   load('MeshPaper/Fig4Data/Fig4LobePicsData1_36.mat');
end

TitleAdj=-0.06;

x=10;
y=161;
AxisSize=[10 161 10 162];

min1=0%min(min(M1(x:y,x:y)));
AxLims=[min1 max6]
h=subplot('Position',[StartX StartY+2*(FigHt+Gap) FigWid FigHt]);
LobePic(M1,AxLims,1)
set(h,'XTickLabel','','YTickLabel','')
DrawLengthBar(h,50/(x2-x1+1),0.1,0.1,'w',2)
h=title(['1 Source']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[FigWid+Sp+StartX StartY+2*(FigHt+Gap) FigWid FigHt]);
LobePic(M2,AxLims,4);
set(h,'XTickLabel','','YTickLabel','')
h=title(['4 Sources']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[StartX StartY+FigHt+Gap FigWid FigHt]);
LobePic(M3,AxLims,9);
set(h,'XTickLabel','','YTickLabel','')
h=title(['9 Sources']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[(FigWid+Sp)+StartX StartY+FigHt+Gap FigWid FigHt]);
LobePic(M4,AxLims,16);
set(h,'XTickLabel','','YTickLabel','')
h=title(['16 Sources']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[StartX StartY FigWid FigHt]);
LobePic(M5,AxLims,25);
set(h,'XTickLabel','','YTickLabel','')
h=title(['25 Sources']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[(FigWid+Sp)+StartX StartY FigWid FigHt]);
LobePic(M6,AxLims,36);
set(h,'XTickLabel','','YTickLabel','')
h=title(['36 Sources']);
MoveXYZ(h,0,TitleAdj,0);
axis(AxisSize)

h=subplot('Position',[0.8 StartY+2*(FigHt+Gap) 0.035 FigHt]);
colorbar(h)
XLim=get(h,'YLim');
LMid=(AxLims(2)+AxLims(1))/2;
XTLabs=sort([AxLims(1) LMid 2.5e-7 AxLims(2)]);
XTPos=GetTickPos(XLim,AxLims,XTLabs)';
Labs=num2str((XTLabs.*1e6)',2);
SetYTicks(h,0,1e6,2,XTPos,Labs);
set(h,'TickLength',[0 0],'FontSize',8,'Box','off')
ylabel('Concentration (\muM)')

h=subplot('Position',[0.8 StartY+(FigHt+Gap)  0.035 FigHt]);
colorbar(h)
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

function LobePic(MData,AxLims,XS)

aff=2.5e-7;
pcolor(log(5e7*MData+1));
caxis(log(5e7*AxLims+1))
log(5e7*AxLims+1)
% pcolor(imadjust(MData,[],[],0.5));
% caxis(imadjust(AxLims,[],[],0.5))
% pcolor(MData);
% caxis(AxLims)
shading interp
hold on
% [c,h]=contour(MData,[aff aff],'g');
[X,Y]=size(MData);
DrawSources(XS,X,Y,0);
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
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'Inn300Data.mat'];
load(filename);
eval(['M=M2dT' int2str(Time) ';']);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
dtube

function DrawSources(XS,X,Y,edge)
Sp=10;
centx=X/2-edge+0.5;
centy=Y/2-edge+0.5;
Xl=(ceil(sqrt(XS))-1)/2;
left=centx-Xl*Sp;
right=centx+Xl*Sp;
bott=centy-Xl*Sp;
top=centy+Xl*Sp;
hold on
% XLine=[left right right left left];
% YLine=[bott bott top top bott];
% plot(XLine,YLine,'k')
Xes=left:Sp-0.5:right;
Ys=bott:Sp-.5:top;
for i=1:length(Xes)
   Xs=ones(1,length(Ys))*Xes(i);
   h=plot(Xs,Ys,'w+','MarkerSize',1);
end
hold off;
