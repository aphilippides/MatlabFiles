function GetOneDSliceAvgs3d(Timee,Vers,Width)

d3dmm
for i=1:length(Vers)			% Get average data
   fn=['MaxW'x2str(Width) 'Rho100/TreeSst1V'x2str(Vers(i)) 'Gr300X100Z100Sq1Sp10Sl0T'x2str(Timee) '.dat'];
   eval(['M' int2str(Vers(i)) '=load(fn);']);
end
Slices=[];
for i=1:length(Vers)			% Get average data
   i
   eval(['M=M' int2str(Vers(i)) ';']);
   Slices=[Slices ; M(150,:)];
end
fn=['MaxW'x2str(Width) 'Rho100/TreeSst1OneDSlicesGr300X100Z100Sq1Sp10T'x2str(Timee) '.mat'];
save(fn,'Slices','Vers','Timee')
