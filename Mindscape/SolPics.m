function SolPics(Ts,Vers,MaxW,DirNum,Tstep,Thresh,MinW,dstr)
cmin=0;
cmax=0;
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
m=load(['MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'Max.dat']);
% m=load('MindSc_Gr2000SSt1B4TSt10Max.dat');
cmax=max(m(:,2))%/MFrac

if(DirNum<10) nstr=['0' int2str(DirNum)];
else nstr=[int2str(DirNum)];
end
for t=Ts
% for t=[40:6400:65000]
    tbmp=t/Tstep;
    if(tbmp<10) fn=['K:\ScratchX\image5\' nstr ' 00' int2str(tbmp) '.bmp']
    elseif(tbmp<100) fn=['K:\ScratchX\image5\' nstr ' 0' int2str(tbmp) '.bmp']
    else fn=['K:\ScratchX\image5\' nstr ' ' int2str(tbmp) '.bmp']
    end
    [i,cmap]=imread(fn);
    j=load(['MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'T' int2str(t) '.dat']);
    % j=load(['MindSc_Gr2000SSt1B4TSt10T' int2str(t) '.dat']);
%    s=min(round(j*MaxW./cmax),MaxW);
     %s=round((j-Thresh)*(MaxW-MinW)./(cmax-Thresh)+MinW).*(j>=Thresh);
    s=round((j-Thresh)*(MaxW-MinW)./(cmax-Thresh)+MinW).*(j>=Thresh)+round(j*MinW./Thresh).*(j<Thresh);
    newi=double(i);
    newi(:,:,1)=newi(:,:,1)+s;
    newi(:,:,2)=newi(:,:,2)+s;
    newi(:,:,3)=newi(:,:,3)+s;
    newi=uint8(newi);
    %imshow(i)
    % figure,pcolor(s),shading interp
    %imshow(newi)
    if(tbmp<10) fn2=['K:\ScratchAll\lincolns\sols\image5\' dstr '\' nstr ' 00' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<100) fn2=['K:\ScratchAll\lincolns\sols\image5\' dstr '\' nstr ' 0' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    else fn2=['K:\ScratchAll\lincolns\sols\image5\' dstr '\' nstr ' ' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    end
    imwrite(newi,fn2,'bmp');
    % M(tbmp) = im2frame(newi,cmap);
    clear j s i newi
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
