% function to draw Figure3

function Fig3PicV4

close(gcf)
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
h=subplot('Position',[0.2 0.725 0.775 0.25]);
[NumOver,Time]=GetNumOver(4,2,Space);
plot(Time,NumOver)
SetXAxis(h,0,2,Time,NumOver);
SetXTicks(h,0,1,[0:0.5:2]);
xlabel('Synthesis length (s)')
YH=ylabel({'Affected area';'(\mum^2)'});
MoveXYZ(YH,-0.115,0,0);
set(h,'Box','off','TickDir','out')
PlotContours
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 10 10]);
set(FigHdl,'PaperPositionMode','auto');

function PlotContours

colormap(gray)
FigWid=0.225;
FigHt=0.225;
StartY=0.375;
StartY2=0.1;
x1=485;
x2=514;

DataNeeded=0;
if(DataNeeded==1)
	[M1,S1,max1,min1]=GetLobeDat(2,10,4,125,x1,x2);
	[M2,S2,max2,min2]=GetLobeDat(2,10,4,1000,x1,x2);
	%[M3,S3,max3,min3]=GetLobeDat(2,10,4,1500,x1,x2);
	[M3,S3,max3,min3]=GetLobeDat(2,10,4,1250,x1,x2);
	[M4,S4,max4,min4]=GetLobeDat(2,10,4,2000,x1,x2);
   save('MeshPaper/Fig3Data/Fig3LobePicsData.mat','M1','M2','M3','M4','S1','S2', ...
      'S3','S4','max1','max2','max3','max4','min1','min2','min3','min4')
else
   load('MeshPaper/Fig3Data/Fig3LobePicsData.mat');
end
AxLims=[min1 max4];
%AxLims=[0 max4];		% Makes the single pics brighter
TitleAdj=-0.06;

h=subplot('Position',[0.025 StartY FigWid FigHt]);
LobePic(M1,AxLims)
set(h,'XTickLabel','','YTickLabel','')
h=title('T=0.125');
MoveXYZ(h,0,TitleAdj,0);
h=subplot('Position',[0.025 StartY2 FigWid FigHt]);
LobePic(S1,AxLims)
set(h,'XTickLabel','','YTickLabel','')
DrawLengthBar(h,(1/3),0.15,0.15,'w',2)

h=subplot('Position',[0.3 StartY FigWid FigHt]);
LobePic(M2,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title('T=1');
MoveXYZ(h,0,TitleAdj,0);
h=subplot('Position',[0.3 StartY2 FigWid FigHt]);
LobePic(S2,AxLims);
set(h,'XTickLabel','','YTickLabel','')

h=subplot('Position',[0.575 StartY FigWid FigHt]);
LobePic(M4,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=title('T=2s');
MoveXYZ(h,0,TitleAdj,0);
h=subplot('Position',[0.575 StartY2 FigWid FigHt]);
LobePic(S4,AxLims);
set(h,'XTickLabel','','YTickLabel','')

h=subplot('Position',[0.825 StartY2 0.025 FigHt]);
colorbar(h)
XLim=get(h,'YLim');
LMid=(AxLims(2)+AxLims(1))/2;
XTLabs=sort([AxLims(1) LMid 2.5e-7 AxLims(2)])
XTPos=GetTickPos(XLim,AxLims,XTLabs)';
Labs=num2str((XTLabs.*1e6)',2);
SetYTicks(h,0,1e6,2,XTPos,Labs);
set(h,'TickLength',[0 0],'FontSize',8,'Box','off')
h=ylabel({'Concentration';'(\muM)'});
MoveXYZ(h,0.85,0,0);

h=subplot('Position',[0.825 StartY 0.025 FigHt]);
colorbar(h)
SetYTicks(h,0,1e6,2,XTPos,Labs);
set(h,'TickLength',[0 0],'FontSize',8,'Box','off')
h=ylabel({'Concentration';'(\muM)'});
MoveXYZ(h,0.85,0,0);

function[XTPos]=GetTickPos(XLim,AxLims,XTLabs)

Fact=AxLims(2)-AxLims(1);
for i=1:length(XTLabs)
   Facts(i,1)=(AxLims(2)-XTLabs(i))/Fact;
   Facts(i,2)=(XTLabs(i)-AxLims(1))/Fact;
end
XTPos=Facts*XLim';

function[NumOver,Timez]= GetNumOver(NumTubes,Square,Space)

dsmall
filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumTubes) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat'];
M=load(filename);
[X,Y]=size(M);
Timez=M(2:X,1);
NumOver=1e6-M(2:X,4);
dtube

function LobePic(MData,AxLims)

aff=2.5e-7;
pcolor(MData);
caxis(AxLims)
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight
hold off

function[MData,SData,MDataMax,MDataMin]=GetLobeDat(Sq,Sp,X,T,x1,x2)

r1=1;
dsmall
y1=x1;y2=x2;r2=r1;
fname=['Lobe/MeshSSt1Gr1000X'int2str(X) 'Sq'num2str(Sq) 'Sp'num2str(Sp) 'T'num2str(T) '.dat'];
M=load(fname);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
fname=['SingleSource/MeshSSt1Gr1000Sq'num2str(Sq) 'SingT'num2str(T) '.dat'];
M=load(fname);
SData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
dtube
