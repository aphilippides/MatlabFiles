function JitterEffect(J)
dmat
cd ..\DiffEqun\MeshTube\Mushroom\Mush
cmin=0;cmax =2e-3;
x=50, y=150;
for t=5:5:50
    nj=load(['Jitter0SSt1B3Gr1000Inn10Out20T' int2str(t) '.dat']);
    j=load(['Jitter' int2str(J) 'SSt1B3Gr1000Inn10Out20T' int2str(t) '.dat']);
    subplot(1,2,1),
    pcolor(nj(x:y,x:y)),caxis([cmin cmax]);shading interp;
    subplot(1,2,2)
    pcolor(j(x:y,x:y)),caxis([cmin cmax]);shading interp;
    figure
end
    