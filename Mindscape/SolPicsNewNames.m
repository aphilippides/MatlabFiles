function SolPics(Ts,Vers,MaxW,DirNum,Tstep,Thresh,MinW,dstr)
cmin=0;
cmax=0;
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
m=load(['MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'Max.dat']);
cmax=max(m(:,2));

if(DirNum<10) nstr=['0' int2str(DirNum)];
else nstr=[int2str(DirNum)];
end
for t=Ts
    tbmp=t/Tstep;
%    f=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\master\' int2str(DirNum) ' 001.bmp '];
    f=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\master\export 001.bmp '];
    if(tbmp<10) fn=[f '00' int2str(tbmp) '.bmp']
    elseif(tbmp<100) fn=[f '0' int2str(tbmp) '.bmp'];
    else fn=[f int2str(tbmp) '.bmp']
    end
    [i,cmap]=imread(fn);
    j=load(['MindSc_Gr1500SSt1B1TSt' int2str(Tstep) 'T' int2str(t) '.dat']);
    % j=load(['MindSc_Gr2000SSt1B4TSt10T' int2str(t) '.dat']);
%    s=min(round(j*MaxW./cmax),MaxW);
     s=round((j-Thresh)*(MaxW-MinW)./(cmax-Thresh)+MinW);
     s=s.*(j>=Thresh);
    newi=double(i);
    newi(:,:,1)=newi(:,:,1)+s;
    newi(:,:,2)=newi(:,:,2)+s;
    newi(:,:,3)=newi(:,:,3)+s;
    newi=uint8(newi);
    f=['K:\ScratchAll\lincolns\sols\image' int2str(DirNum) '\' dstr '\' nstr];
%    f=['G:\MindscapeMany\image' int2str(DirNum) '\' dstr '\' nstr];
    if(tbmp<10) fn2=[f ' 000' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<100) fn2=[f ' 00' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    elseif(tbmp<1000) fn2=[f ' 0' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    else fn2=[f ' ' int2str(tbmp) 'WGas' int2str(Vers) '.bmp']
    end
    imwrite(newi,fn2,'bmp');
    clear j s i newi
end