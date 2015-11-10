function SolPics(Ts,Thresh,MaxW,DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScape\Image' int2str(DirNum)]);
cd(dn);
m=load('MindSc_Gr2000SSt1B4TSt10Max.dat');
cmax=max(m(:,2))

mov=avifile('Im10Movie2.avi','fps',10,'compression','None');
%for t=Ts
for t=[40:1600:60000]
    tbmp=t/40;
    if(tbmp<10) fn=['10 00' int2str(tbmp) '.bmp']
    elseif(tbmp<100) fn=['10 0' int2str(tbmp) '.bmp']
    else fn=['10 ' int2str(tbmp) '.bmp']
    end
    [i,cmap]=imread(fn);
    j=load(['MindSc_Gr2000SSt1B4TSt10T' int2str(t) '.dat']);
    s=round(j*MaxW./cmax);
    newi=double(i);
    newi(:,:,1)=newi(:,:,1)+s;
    newi(:,:,2)=newi(:,:,2)+s;
    newi(:,:,3)=newi(:,:,3)+s;
    newi=uint8(newi);
    figure,pcolor(s),shading interp
    % imshow(newi)
    if(tbmp<10) fn2=['10 00' int2str(tbmp) 'WGas.bmp']
    elseif(tbmp<100) fn2=['10 0' int2str(tbmp) 'WGas.bmp']
    else fn2=['10 ' int2str(tbmp) 'WGas.bmp']
    end
%     frame=getframe(gca);
%     mov = addframe(mov,frame);
    %imwrite(newi,fn2,'bmp');
    M(tbmp) = im2frame(newi,cmap);
    clear j s i newi
end
mov=close(mov);
% 
% for t=Ts
%     j=load(['MindSc_Gr1000SSt1B10TSt1T' int2str(t) '.dat']);
%     pcolor(j),caxis([cmin cmax]);shading interp;
%     SquareAx
%     figure
% end
