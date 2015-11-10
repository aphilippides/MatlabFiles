function StartMovie

%cd('c:/my documents/movie')
Square=2;Spacing=10;
x1=25;
x2=175;
close all
Skiprate=1;  		
filename=['MeshSingSq2Sp10T0_200Movie.mat']
load(filename );
FigHndl=figure;

 set(FigHndl,'Units','centimeters','Position',[0.75 7 26 11.1])
subplot(1,2,2)
LotsContour(Square,Spacing,16,-1,x1,x2,Skiprate);
set(gca,'Units','normalized','Position',[ 0.5 0.1 0.4 0.85 ])
subplot(1,2,1)
LotsContour(Square,Spacing,1,-1,x1,x2,Skiprate);
set(gca,'Units','normalized','Position',[ 0.05 0.1 0.4 0.85 ])
input('press return to continue')
movie(FigHndl,MovieMatrix,100,10)

function LotsContour(Sq,Sp,X,Time,x1,x2,r1);

y1=x1;y2=x2;r2=r1;
filename=['Mesh2dSSt1Gr1000X' int2str(X) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'T' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
caxis([0 aff]);
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight
BarHdl=colorbar;
set(BarHdl,'Units','normalized','Position',[ 0.925 0.1 0.025 0.825 ])
hold off
return

