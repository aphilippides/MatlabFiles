% function to draw Figure4 at time Time for short paper

function Fig4PicVNatNeuro(Time)

clf
BlackAndWhite = 1; % Printing for black and white?
if(BlackAndWhite) 
    Col=['k'];
else
    Col=['b'];
end
if(nargin<1) Time=1;end;
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
Sq=2;
h=subplot('Position',[0.225 0.785 0.7 0.2]);
ThreshDists(1,Col)

%axis tight
%SetXTicks(h,0,1,-1,[1 25:25:100]) 
%SetTickLength(h,2.5);
%h=xlabel('Number of sources');
%MoveXYZ(h,0,0,0);
%h=ylabel({'Affected volume';'(synthesising vol.)'},'Units','normalized');
%MoveXYZ(h,-0.15,-0.175,0);
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
x1=96;      % x1 and x2 define limits of the pictures i.e from x1 to x2
x2=205;

DataNeeded=0;
if(DataNeeded==1)
   [M1,max1,min1]=GetLobeDat(2,10,1,T,x1,x2);
   [M2,max2,min2]=GetLobeDat(2,10,4,T,x1,x2);
   [M3,max3,min3]=GetLobeDat(2,10,9,T,x1,x2);
   [M4,max4,min4]=GetLobeDat(2,10,16,T,x1,x2);
   save('MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat','-append','M1','M2','M3','M4', ...
      'max1','max2','max3','max4','min1','min2','min3','min4')
else
   load('MeshPaperFiles/OpticLobe/Fig4PaperVShortData.mat');
end
max1
TitleAdj=-0.06;

%AxLims=[min1 max4];
AxLims=[0 max4];

h=subplot('Position',[StartX StartY2 FigWid FigHt]);
LobePic(M1,AxLims)
set(h,'XTickLabel','','YTickLabel','')
DrawLengthBar(h,0.2727,0.1,0.1,'w',2)
h=title(['Single Source']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[FigWid+Sp+StartX StartY2 FigWid FigHt]);
LobePic(M2,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['4 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[StartX StartY FigWid FigHt]);
LobePic(M3,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['9 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[(FigWid+Sp)+StartX StartY FigWid FigHt]);
LobePic(M4,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title(['16 Sources']);
MoveXYZ(h,0,TitleAdj,0);

h=subplot('Position',[0.8 StartY2 0.035 FigHt]);
colorbar(h)
XLim=get(h,'YLim');
LMid=(AxLims(2)+AxLims(1))/2;
XTLabs=sort([AxLims(1) LMid 2.5e-7 AxLims(2)]);
XTPos=GetTickPos(XLim,AxLims,XTLabs)';
Labs=num2str((XTLabs.*1e6)',2)
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
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'Inn300Data.mat'];
load(filename);
eval(['M=M2dT' int2str(Time) ';']);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
dtube

function ThreshDists(Burst,C)
dtube
fname=['MeshPaper\Fig1Data\LimitsRads1_25_25B' x2str(Burst) 'Am.mat'];
load(fname);
%plot(Rads.*2,RThresh./Rads);
%plot(Rads.*2,RThresh);
RDist=min(1,RThresh./Rads-1);
plot(Rads.*2,RThresh./(Rads.*2),C);
%set(gca,'XLim',[Rads(end)*2 30]);
axis([0 30 1 7]);
SetYTicks(gca,0,1,0,[1 3 6])
SetXTicks(gca,4)
xlabel('Source diameter (\mum)')
h=ylabel({'Threshold distance';'(source diameter)'});
MoveXYZ(h,-0.1,0,0);

