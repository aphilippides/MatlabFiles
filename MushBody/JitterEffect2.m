function JitterEffect2(J,pc)
dmat
cd ..\DiffEqun\MeshTube\Mushroom\Mush
cmin=0;cmax =4.78e-4;
x=1, y=100;
for t=[5 15 40]
    j=load(['Jitter' int2str(J) 'Pc' int2str(pc) 'SSt1B5Gr1000Inn10Out20T' int2str(t) '.dat']);
    pcolor(j(x:y,x:y)),caxis([cmin cmax]);shading interp;
    SquareAx
    %colorbar(h)
    %SetYTicks(h,0,1,2,[0:(4.35e-4)/4:4.35e-4],int2str([0:25:100]'));
    fn=['HollowTube' int2str(pc) 'PerCentOnTime' int2str(t) 'ms.tif'];    
    print(gcf,'-dtiff',fn); 
    figure
end