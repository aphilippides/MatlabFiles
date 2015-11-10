% function to draw Figure3

function Fig3Pic

close(gcf)
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
subplot('Position',[0.1 0.7 0.85 0.25])
[NumOver,Time]=GetNumOver(4,2,Space);
plot(Time,NumOver)
axis tight
xlabel('Synthesis Time (s)')
ylabel('Affected Area ( \mum^2)')
set(gca,'Box','off','TickDir','out')
Version1

function Version1

colormap(gray)
FigWid=0.2;
FigHt=0.3;
StartY=0.225;
x1=485;
x2=515;


[M1,max1,min1]=GetLobeDat(2,10,4,500,x1,x2);
[M2,max2,min2]=GetLobeDat(2,10,4,1000,x1,x2);
[M3,max3,min3]=GetLobeDat(2,10,4,1500,x1,x2);
[M4,max4,min4]=GetLobeDat(2,10,4,2000,x1,x2);
AxLims=[min1 max4];

subplot('Position',[0.04 StartY FigWid FigHt])
LobePic(M1,AxLims)
title('T=0.5s')
subplot('Position',[0.29 StartY FigWid FigHt])
LobePic(M2,AxLims);
title('T=1s')
subplot('Position',[0.54 StartY FigWid FigHt])
LobePic(M3,AxLims);
title('T=1.5s')
subplot('Position',[0.79 StartY FigWid FigHt])
LobePic(M4,AxLims);
title('T=2s')

h=subplot('Position',[0.04 0.1 0.92 0.05]);
colorbar(h)
set(h,'TickDir','out','Box','off')
XLim=get(h,'XLim');
LMid=(AxLims(2)+AxLims(1))/2;
XTLabs=sort([AxLims(1) LMid 2.5e-7 AxLims(2)]);
XTPos=GetTickPos(XLim,AxLims,XTLabs)';
Labs=num2str((XTLabs.*1e6)',2);
set(h,'XTick',XTPos,'XTickLabel',Labs)
xlabel('Concentration (\muM)')

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
