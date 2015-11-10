% Makes a movie of Diff equn plots

function MeshMovieNew(Square,Spacing,X)

dsmall
if(nargin<3) X=16; end;
if(nargin<2) Spacing=10; end;
if(nargin<1) Square=2; end;
x1=25;
x2=175;
Skiprate=1;  		
Times=0:2:200;
%Times(1)=-1;
L=length(Times);
FigHndl=figure;
set(FigHndl,'Units','centimeters','Position',[0.75 7 26 11.1])
subplot(1,2,2)
LotsContour(Square,Spacing,X, -1,x1,x2,Skiprate);
set(gca,'Units','normalized','Position',[ 0.5 0.1 0.4 0.85 ])
subplot(1,2,1)
LotsContour(Square,Spacing,1,-1,x1,x2,Skiprate);
set(gca,'Units','normalized','Position',[ 0.05 0.1 0.4 0.85 ])
MovieMatrix(1) = getframe(FigHndl);
for  i=1:L
    subplot(1,2,2)
	LotsContour(Square,Spacing,X,Times(i),x1,x2,Skiprate);
	set(gca,'Units','normalized','Position',[ 0.5 0.1 0.4 0.85 ])
  subplot(1,2,1)
   LotsContour(Square,Spacing,1,Times(i),x1,x2,Skiprate);
   set(gca,'Units','normalized','Position',[ 0.05 0.1 0.4 0.85 ])
 MovieMatrix(i+1) = getframe(FigHndl);
    i 
 end 
%filename=['Sq' num2str(Square) 'Sp' num2str(Spacing) '/MeshSingSq' num2str(Square) 'Sp' num2str(Spacing) 'T0_8Movie2.mat']
filename=['MovieFiles/MeshSingSq' num2str(Square) 'Sp' num2str(Spacing) 'T0_1Movie.mat']
%save(filename ,'MovieMatrix');
close all
movie(MovieMatrix,5,1)

function LotsContour(Sq,Sp,X,Time,x1,x2,r1);

y1=x1;y2=x2;r2=r1;
filename=['MovieFiles/Mesh2dSSt1Gr1000X' int2str(X) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'T' num2str(Time) '.dat']
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

