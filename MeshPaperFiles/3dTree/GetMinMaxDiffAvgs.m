function GetMinMaxDiffAvgs(X,Sl,Vers,StoreAvgs,Dens)

d3dmm
if(nargin<5) MStr='Max';end;
Differ=[];
RelDiff=[];
for i=1:length(Vers)			% Get average data
   filename=['MaxTreeRho' int2str(Dens) '/TreeSst1V' int2str(Vers(i)) 'MaxGr300X'int2str(X) 'Z'int2str(X) 'Sq1Sp10Sl' num2str(Sl) '.dat'];
   fn2=['MinTreeRho' int2str(Dens) '/TreeSst1V' int2str(Vers(i)) 'MaxGr300X'int2str(X) 'Z'int2str(X) 'Sq1Sp10Sl' num2str(Sl) '.dat'];
	M=load(filename);
    M2=load(fn2);
    [o1,T]=NumOver(M);
    o2=NumOver(M2);
   Differ=[Differ;[o1-o2]']
   RelDiff=[RelDiff;[(o1-o2)./o1]']
end

DiffAvg=mean(Differ);
RelDAvg=mean(RelDiff);
DiffStd=std(Differ);
RelDStd=std(RelDiff);
if(nargin<4) StoreAvgs =0; end;
dthesisdat
if(StoreAvgs)
filename=['MinMaxDiffsRho' int2str(Dens) 'Sst1MaxGr300X'int2str(X) 'Z'int2str(X) 'Sq1Sp10Sl' num2str(Sl) '.mat'];
save(filename,'T','Differ','RelDiff','DiffAvg','RelDAvg','DiffStd','RelDStd','Vers')
end
plot(T,RelDAvg*100)


