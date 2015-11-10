% function to draw Figure4 at time Timez

function ParallelArrayConcs(T,Xs,Sq,Sp)

set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 9 10]);
for x=Xs
    x1=126;      % x1 and x2 define limits of the pictures i.e from x1 to x2
    x2=275;
    dsmall
    m=load(['BuildUp/Mesh2DSSt1Half' int2str(x) 'B1Gr1000X36Sq2Sp10T1000.dat'])*1.324e-4;
%     load(['Lobe/MeshSSt1Gr1000X' int2str(x) 'Sq' num2str(Sq) 'Sp' num2str(Sp) 'Inn300Data.mat']);
%     eval(['m=M2dT' int2str(T) '*1.324e-4;']);
    figure
%     AxLims=[0 1.3e-6];
      colormap(FullGrayMap)
%     pcolor(log(5e7*m+1));
%     caxis(log(5e7*AxLims+1))
    pcolor(m(x1:x2,x1:x2));
%    caxis(AxLims);
    max(max(m))
    shading interp
%    shading flat
    SquareAx
    axis off
end