function SolPicsTestNewNames(Ts,DirNum,MaxW,ImNum,Tstep,Thresh,MinW,With)
if (nargin<8) With = 1; end
cmin=0;
cmax=0;
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);

m=load(['../image' int2str(DirNum) '/MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'Max.dat']);
cmax=max(m(:,2))
% cmax=0.05
if(DirNum<10) nstr=['0' int2str(DirNum)];
else nstr=[int2str(DirNum)];
end
for t=Ts
% for t=[40:6400:65000]
    tbmp=t/Tstep;
%    f=['K:\ScratchAll\lincolns\sols\image' int2str(ImNum) '\master\export 001.bmp '];
    f=['G:\MindscapeMany\Image' int2str(ImNum) '\master\08 001.bmp '];
    if(tbmp<10) fn=[f '00' int2str(tbmp) '.bmp']
    elseif(tbmp<100) fn=[f '0' int2str(tbmp) '.bmp'];
    else fn=[f int2str(tbmp) '.bmp']
    end
    [i,cmap]=imread(fn);
    j=load(['../image' int2str(DirNum) '/MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'T' int2str(t) '.dat']);
    %    s=min(round(j*MaxW./cmax),MaxW);
    %s=round((j-Thresh)*(MaxW-MinW)./(cmax-Thresh)+MinW).*(j>=Thresh);
    s=round((j-Thresh)*(MaxW-MinW)./(cmax-Thresh)+MinW).*(j>=Thresh)+round(j*MinW./Thresh).*(j<Thresh);
    max(max(j))
    if(With) newi=double(i);
    else newi = double(i)*0; 
    end;
    newi(:,:,1)=newi(:,:,1)+s;
    newi(:,:,2)=newi(:,:,2)+s;
    newi(:,:,3)=newi(:,:,3)+s;
    newi=uint8(newi);
    %imshow(i)
    % figure,pcolor(s),shading interp,colormap gray;
    figure,imshow(newi)
%     if(tbmp<10) fn2=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr ' 00' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
%     elseif(tbmp<100) fn2=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr ' 0' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
%     else fn2=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr ' ' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
%     end
    % imwrite(newi,fn2,'bmp');
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
