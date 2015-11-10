function[MinMaxHndl,PCNotHndl,MeanHndl,MeanLim]=GetWidthAvgs(MStr,Sl,Vers,Width)

d3dmm
MaxArray=[];
MinArray=[];
OverArray=[];
MeanArray=[];
SDArray=[];
for i=1:length(Vers)			% Get average data
   filename=[MStr 'W'int2str(Width) 'Rho100/TreeSst1V' int2str(Vers(i)) 'MaxGr300X100Z100Sq1Sp10Sl' num2str(Sl) '.dat'];
	M=load(filename);
   i
   GrSize=(M(1,3)-M(1,2)).^3;
	[Y,X]=size(M);
	MaxArray=[MaxArray;M(2:Y,2)'];  
	MinArray=[MinArray;M(2:Y,3)'];   
   OverArray=[OverArray;[GrSize-M(2:Y,4)']];
	MeanArray=[MeanArray;M(2:Y,5)'./1000];   
   SDArray=[SDArray;M(2:Y,6)'./1000];
end
Times=M(2:Y,1);
MaxAvg=mean(MaxArray);		% Get averages and s.d.'s
MinAvg=mean(MinArray);
OverAvg=mean(OverArray);
MeanAvg=mean(MeanArray);
SDAvg=mean(SDArray);
MaxStd=std(MaxArray);
MinStd=std(MinArray);
OverStd=std(OverArray);
MeanStd=std(MeanArray);
SDStd=std(SDArray);
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(Times,MaxAvg,MaxStd,'r');hold on;
errorbar(Times,MinAvg,MinStd,'r:');hold off;
axis('tight'),title('Max and Min');
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,'r');axis('tight');title('# Over');

MeanHndl=subplot('position',[0.05 0.05 0.4 0.4]);
errorbar(Times,MeanAvg,MeanStd,'r');axis('tight');title('Mean Conc.');

SDHndl=subplot('position',[0.55 0.05 0.4 0.4]);
errorbar(Times,SDAvg,SDStd,'r:');axis('tight');title('s.d. Conc.');

filename=[MStr 'W'int2str(Width) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl' num2str(Sl) '.mat'];
save(filename,'Times','MaxAvg','MinAvg','OverAvg','MeanAvg', ...
   'MaxStd','MinStd','OverStd','MeanStd','SDAvg','SDStd','Vers')
return
