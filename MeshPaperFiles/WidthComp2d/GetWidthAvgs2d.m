function[MinMaxHndl,PCNotHndl,MeanHndl,MeanLim]=GetWidthAvgs2d(Sl,Vers,Width)

d2dmm
MaxArray=[];
MinArray=[];
OverArray=[];
MeanArray=[];
SDArray=[];
for i=1:length(Vers)			% Get average data
   filename=['MaxTreeRho100/TreeSst0_125V' int2str(Vers(i)) 'MaxGr2500X800Sq1W'x2str(Width) 'Sl'x2str(Sl) '.dat'];
	M=load(filename);
   GrSize=(M(1,3)-M(1,2)).^2;
	[Y,X]=size(M);
	MaxArray=[MaxArray;M(2:Y,2)'];  
	MinArray=[MinArray;M(2:Y,3)'];   
   OverArray=[OverArray;[GrSize-M(2:Y,4)']];
end
Times=M(2:Y,1);
MaxAvg=mean(MaxArray);		% Get averages and s.d.'s
MinAvg=mean(MinArray);
OverAvg=mean(OverArray);
MaxStd=std(MaxArray);
MinStd=std(MinArray);
OverStd=std(OverArray);
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(Times,MaxAvg,MaxStd,'r');hold on;
errorbar(Times,MinAvg,MinStd,'r:');hold off;
axis('tight'),title('Max and Min');
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,'r');axis('tight');title('# Over');


filename=['MaxTreeRho100/TreeSst0_125MaxAvgsGr2500X800Sq1W'x2str(Width) 'Sl'x2str(Sl) '.mat'];
save(filename,'Times','MaxAvg','MinAvg','OverAvg','MaxStd','MinStd','OverStd','Vers')
return
