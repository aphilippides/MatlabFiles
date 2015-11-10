function CheckDiffs(Times)

d3dmm;
for i=1:length(Times)
   fname1=(['MinTreeRho100/TreeSSt1Gr50X25Z25Sq1Sp10T' int2str(Times(i)) '.dat'])
   fname2=(['CheckTStMax/TSt8SSt1Gr300X100Sq1Sp10T' int2str(Times(i)) '.dat'])
   %fname1=(['MaxTreeRho100/TreeSSt1Gr50X25Z25Sq1Sp10T' int2str(Times(i)) '.dat'])
   %fname1=(['../MaxMinPerp/Check/MeshSSt1Gr50X1Z25Sq2Sp0T' int2str(Times(i)) '.dat'])
   M1=load(fname1);
   %M1=M1(1:25,:);
   whos
   %fname2=(['MinTreeRho100/TreeSSt1Gr50X25Z25Sq1Sp10T' int2str(Times(i)) '.dat'])
   fname2=(['CheckTStMax/TSt4SSt1Gr300X100Sq1Sp10T' int2str(Times(i)) '.dat'])
   %fname2=(['../3dPerp/Check/MeshSSt1Gr50X25Z25Sq2Sp10Sl2T' int2str(Times(i)) '.dat'])
   M2=load(fname2);
   Diffs=M1-M2;
   ShowDiffs(M1,M2,Diffs);
   Not0=find(Diffs);
   bad(i)=length(Not0)
end

function ShowDiffs(L,M,D)
subplot(1,3,1),pcolor(L),shading interp,colorbar 
subplot(1,3,2),pcolor(M),shading interp,colorbar 
subplot(1,3,3),pcolor(D),shading interp,colorbar 
