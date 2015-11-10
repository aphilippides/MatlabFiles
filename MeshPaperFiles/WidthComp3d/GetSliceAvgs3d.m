function GetSliceAvgs3d(Timee,Vers,Width)

d3dmm
for i=1:length(Vers)			% Get average data
   fn=['MaxW'x2str(Width) 'Rho100/TreeSst1V'x2str(Vers(i)) 'Gr300X100Z100Sq1Sp10Sl0T'x2str(Timee) '.dat'];
   eval(['M' int2str(Vers(i)) '=load(fn);']);
end
for Line=1:300
   LineCs=[];
	for i=1:length(Vers)			% Get average data
   	eval(['M=M' int2str(Vers(i)) ';']);
   	LineCs=[LineCs;M(Line,:)];
   end
   SliceAvg(Line,:)=mean(LineCs);		% Get averages and s.d.'s
	SliceStd(Line,:)=std(LineCs);
end
fn=['MaxW'x2str(Width) 'Rho100/TreeSst1SliceAvgsGr300X100Z100Sq1Sp10T'x2str(Timee) '.mat'];
save(fn,'SliceAvg','SliceStd','Vers','Timee')
