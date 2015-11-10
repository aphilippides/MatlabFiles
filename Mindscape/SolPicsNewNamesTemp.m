function SolPicsNewNamesTemp(Ts,Vers,DirNum,dstr)
cmin=0;
cmax=0;
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);

if(DirNum<10) nstr=['0' int2str(DirNum)];
else nstr=[int2str(DirNum)];
end
for t=Ts
% for t=[40:6400:65000]
    tbmp=t;
    f=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr ' '];
    if(tbmp<10) fn=[f '00' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<100) fn=[f '0' int2str(tbmp) 'WGas' int2str(Vers) '.bmp'];
    else fn=[f int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    end
    [i,cmap]=imread(fn);
    %newi=i;
    f=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr];
    if(tbmp<10) fn2=[f ' 000' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<100) fn2=[f ' 00' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<1000) fn2=[f ' 0' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    else fn2=[f ' ' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    end
    imwrite(i,fn2,'bmp');
    delete(fn)
    % M(tbmp) = im2frame(newi,cmap);
    clear j s i %newi
end
% movie(M)
% save FirstMovie.mat M cmax
% 
% for t=Ts
%     j=load(['MindSc_Gr1000SSt1B10TSt1T' int2str(t) '.dat']);
%     pcolor(j),caxis([cmin cmax]);shading interp;
%     SquareAx
%     figure
% end
