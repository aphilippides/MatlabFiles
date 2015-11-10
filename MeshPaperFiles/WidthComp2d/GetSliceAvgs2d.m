function GetSliceAvgs2d(Timee,Vers,Width)

d2dmm
Slices=[];
for i=1:length(Vers)			% Get average data
   i
   fn=['MaxTreeRho100/TreeSst0_125V'x2str(Vers(i)) 'SliceGr2500X800Sq1W'x2str(Width) '.dat'];
   M=load(fn);
   Line=find(Timee==(M(:,1)*4));
   Slices=[Slices;M(Line,2:end)];
end
SliceAvg=mean(Slices);		% Get averages and s.d.'s
SliceStd=std(Slices);
fn=['MaxTreeRho100/TreeSst0_125SliceAvgsGr2500X800Sq1W'x2str(Width) 'T'int2str(Timee) '.mat'];
save(fn,'Slices','SliceAvg','SliceStd','Vers','Timee')
