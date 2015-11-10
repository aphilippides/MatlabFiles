% function which plots parts of matrices as flat maps   
% for Jn fig 11 args are DEcontour(1,35,475,1,550,1,1,1)

function ThreeDDiffs(Square,Space,Time,Grid);

spacestep = 0.1;
filename=['CheckLine/MeshGr' num2str(Grid) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
%filename=['LineCheck/LineGr300B500T' num2str(Time) '.dat']
%filename=['CheckGrad/MeshGr10Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
filename2=['../Fast/LineCheck/LineGr' num2str(Grid) 'B500T' num2str(Time) '.dat']
MData=load(filename);
M2=load(filename2);
%maxim=max(max(MData))
%MData=M(startx:r1:startx+x2-1,y1:r2:y2);
%pcolor((M2-MData)),shading interp
subplot(1,3,1),pcolor(M2),colorbar,shading interp,subplot(1,3,2),pcolor(MData),shading interp,subplot(1,3,3),pcolor((M2-MData))
shading interp
hold on
aff=2.5e-7./(0.00331*.04)
%[c,h]=contour(MData,[aff aff],'k');
%[c,h]=contour(MData);
%clabel(c,h),
colorbar
hold off
return
