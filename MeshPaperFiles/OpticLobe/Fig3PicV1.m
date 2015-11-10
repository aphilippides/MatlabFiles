% function to draw Figure3

function Fig3PicV1

close(gcf)
FigWid=0.24;
FigHt=0.375;
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
Timez=[0.1,1,5]
XT=2:15;
NumTs=XT.^2;
subplot('Position',[0.08 0.6 FigWid FigHt])
for i=1:length(Timez)
   AffVol=GetLobeAffVolumes(NumTs,Timez(i),2,Space);
   plot(NumTs,AffVol,Colors(i,:))
   hold on
end
axis tight
hold off
xlabel('Number of Tubes of Area 4')
ylabel('Affected Area')
ylabel('Affected Area (\mum^2x10^5)')
TickStr=get(gca,'YTickLabel');
set(gca,'YTickLabel',TickStr,'TickDir','out')
h=legend('B=0.1s','B=1s','B=5s',2)
set(h,'Visible','off')
XT=2:8%15;
NumTs=XT.^2;
subplot('Position',[0.08 0.1 FigWid FigHt])
for i=1:length(Timez)
   AffVol=GetLobeAffVolumes(NumTs,Timez(i),3,Space);
   plot(NumTs,AffVol,Colors(i,:))
   hold on
end
axis tight
hold off
xlabel('Number of Tubes of Area 9')
ylabel('Affected Area (\mum^2x10^5)')
TickStr=get(gca,'YTickLabel');
set(gca,'YTickLabel',TickStr,'TickDir','out')
h=legend('B=0.1s','B=1s','B=5s',2)
set(h,'Visible','off')

Version1(FigWid,FigHt)
%Version2(FigWid,FigHt)

function Version1(FigWid,FigHt)

subplot('Position',[0.67 0.05 FigWid FigHt])
AxLims=LobePicLast(2,10,4,2000,FigWid,FigHt)
title('4 tubes;area 4;T=2s')
h=subplot('Position',[0.92 0.05 0.015 FigHt])
colorbar(h)
ylabel('Concentration(M)')
subplot('Position',[0.385 0.55 FigWid FigHt])
LobePic(2,10,4,500,AxLims)
title('4 tubes;area 4;T=0.5s')
subplot('Position',[0.67 0.55 FigWid FigHt])
LobePic(2,10,4,1000,AxLims)
title('4 tubes;area 4;T=1s')
subplot('Position',[0.385 0.05 FigWid FigHt])
LobePic(2,10,4,1500,AxLims)
title('4 tubes;area 4;T=1.5s')

function Version2

subplot(2,3,2)
AxLims=LobePicLast(2,10,4,2000);
subplot(2,3,3)
LobePic(2,10,4,500,AxLims)
subplot(2,3,5)
LobePic(2,10,4,1000,AxLims)
subplot(2,3,6)
LobePic(2,10,4,1500,AxLims)


function[AffVol]= GetLobeAffVolumes(NumTs,Time,Square,Space)

dsmall
for i=1:length(NumTs)
   filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat'];
   M=load(filename);
   [X,Y]=size(M);
   Timez=M(2:X,1);
   NumOver=1e6-M(2:X,4);
   AffVol(i)=NumOver(find(Timez==Time));
end

function LobePic(Square,Space,NumSources,Time,AxLims)

r1=1;
x1=475;
x2=525;
dsmall
y1=x1;y2=x2;r2=r1;
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat'];
M=load(filename);
Maxim=max(max(M))
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
caxis(AxLims)
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight
hold off
caxis

function[PeakConc]=LobePicLast(Square,Space,NumSources,Time,FigWid,FigHt)

r1=1;
x1=475;
x2=525;
dsmall
y1=x1;y2=x2;r2=r1;
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight
hold off
PeakConc=caxis;

