function TempPatPic

PlotContours
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 18 5]);
set(FigHdl,'PaperPositionMode','auto');

function PlotContours

FigWid=0.2;
FigHt=0.72;
StartY=0.1;
StartY2=0.1;
x1=450;
x2=550;

DataNeeded=0;
if(DataNeeded==1)
	[M1,max1,min1]=GetLobeDat(2,10,4,125,x1,x2);
	[M2,max2,min2]=GetLobeDat(2,10,4,250,x1,x2);
	[M3,max2,min2]=GetLobeDat(2,10,4,500,x1,x2);
	[M4,max2,min2]=GetLobeDat(2,10,4,1000,x1,x2);
	[M5,max3,min3]=GetLobeDat(2,10,4,1500,x1,x2);
	[M6,max3,min3]=GetLobeDat(2,10,4,1250,x1,x2);
	[M7,max4,min4]=GetLobeDat(2,10,4,2000,x1,x2);
   save('MeshPaper/Fig3Data/Fig3LobePatPicsData.mat','M1','M2','M3','M4','M5','M6','M7', ...
      'max1','max2','max3','max4','min1','min2','min3','min4')
else
   load('MeshPaper/Fig3Data/Fig3LobePatPicsData.mat');
end
AxLims=[min1 max4];
%AxLims=[0 max4];		% Makes the single pics brighter
TitleAdj=-0.06;

h=subplot('Position',[0.025 StartY FigWid FigHt]);
LobePic(M2,AxLims)
set(h,'XTickLabel','','YTickLabel','')

h=subplot('Position',[0.25 StartY FigWid FigHt]);
LobePic(M3,AxLims);
set(h,'XTickLabel','','YTickLabel','')

h=subplot('Position',[0.475 StartY FigWid FigHt]);
LobePic(M5,AxLims);
set(h,'XTickLabel','','YTickLabel','')
h=subplot('Position',[0.7 StartY FigWid FigHt]);
LobePic(M7,AxLims);
set(h,'XTickLabel','','YTickLabel','')
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
axis tight
hold off

function[MData,MDataMax,MDataMin]=GetLobeDat(Sq,Sp,X,T,x1,x2)

r1=1;
dsmall
y1=x1;y2=x2;r2=r1;
fname=['Lobe/MeshSSt1Gr1000X'int2str(X) 'Sq'num2str(Sq) 'Sp'num2str(Sp) 'T'num2str(T) '.dat'];
M=load(fname);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
fname=['SingleSource/MeshSSt1Gr1000Sq'num2str(Sq) 'SingT'num2str(T) '.dat'];
%M=load(fname);
SData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
dtube
