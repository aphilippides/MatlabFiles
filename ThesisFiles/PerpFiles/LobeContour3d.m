% function which plots parts of matrices as flat maps   
% for Jn fig 11 args are DEcontour(1,35,475,1,550,1,1,1)

function LobeContour3d(Square,Space,NumSources,Time,x1,x2,r1)
spacestep = 0.1;
y1=x1;y2=x2;r2=r1;
%filename=['Lobe/MeshSSt1Gr300X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
filename=['LobeMin/MeshSSt2Gr300X' int2str(NumSources) 'Z150Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
M=load(filename);
MData= M;%(x1:r1:x2,y1:r2:y2)*1.324e-4;
%maxim=max(max(MData))
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
%caxis([0 aff]);
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight
%[c,h]=contour(MData);
%clabel(c,h),
colorbar
hold off
return

