function SwidPics(sp1,sp2)
MushBody(sp1,sp2)

function MushBody(pc1,pc2)
dwork
cd DiffEqun\MeshTube\Mushroom\Mush
cmin=0;cmax =0.1237;
x=1, y=300;
% set(gcf,'Units','centimeters');
% X=get(gcf,'Position');
% set(gcf,'Position',[X(1) X(2)-3 10 10]);
% set(gcf,'PaperPositionMode','auto');

for t=5:10:50
    nj=load(['Jitter0Pc' int2str(pc1) 'SSt0_5B5Gr1000Inn25Out85V1T' int2str(t) '.dat']);
    j=load(['Jitter0Pc' int2str(pc2) 'SSt0_5B5Gr1000Inn25Out85V1T' int2str(t) '.dat']);
    figure;
    m=max(max(nj))
    SquareAx(gcf)
    pcolor(nj(x:y,x:y)),shading interp;caxis([cmin cmax]);
%    axis equal
    figure;
    SquareAx(gcf)
    pcolor(j(x:y,x:y)),shading interp;caxis([cmin cmax]);
%    figure
%colorbar(h)
%SetYTicks(h,0,1,2,[0:(4.35e-4)/4:4.35e-4],int2str([0:25:100]'));
end

function GridPics(sp1,sp2)
dmat
cd ..\DiffEqun\MeshTube\Small\BuildUp
cmin=0;cmax =4.35e-4;
x=1, y=200;
set(gcf,'Units','centimeters');
X=get(gcf,'Position');
set(gcf,'Position',[X(1) X(2)-3 10 10]);
set(gcf,'PaperPositionMode','auto');
h1=subplot('Position',[0.1 0.1 0.7 0.7])
h=subplot('Position',[0.85 0.1 0.05 0.7]);

for t=20%:10:20
    nj=load(['Mesh2dSSt1B0Gr1000X100Sq2Sp' int2str(sp1) 'T' int2str(t) '.dat']);
    j=load(['Mesh2dSSt1B0Gr1000X100Sq2Sp' int2str(sp2) 'T' int2str(t) '.dat']);
subplot(h1)
    pcolor(nj(x:y,x:y)),caxis([cmin cmax]);shading interp;
%    axis equal
    fn=['100SourcesSpacing10Time' int2str(t) 'ms.tif'];    
%    figure
colorbar(h)
SetYTicks(h,0,1,2,[0:(4.35e-4)/4:4.35e-4],int2str([0:25:100]'));
    print(gcf,'-dtiff',fn); 
subplot(h1)

pcolor(j(x:y,x:y)),caxis([cmin cmax]);shading interp;
    axis equal
    fn=['100SourcesSpacing20Time' int2str(t) 'ms.tif'];    
    print(gcf,'-dtiff',fn); 
end
    