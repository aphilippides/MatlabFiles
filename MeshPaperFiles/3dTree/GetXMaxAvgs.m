function GetXMaxAvgs(X,Sl,Vers,StoreAvgs,MStr)

d3dmm
if(nargin<5) MStr='Max';end;
MaxArray=[];
MinArray=[];
OverArray=[];
MeanArray=[];
SDArray=[];
for i=1:length(Vers)			% Get average data
   filename=[MStr 'TreeRho100/TreeSst1V' int2str(Vers(i)) 'MaxGr300X'int2str(X) 'Z'int2str(X) 'Sq1Sp10Sl' num2str(Sl) '.dat'];
	M=load(filename);
   GrSize=(M(1,3)-M(1,2)).^3;
	MaxArray=[MaxArray;M(2:end,2)'];  
	MinArray=[MinArray;M(2:end,3)'];   
   OverArray=[OverArray;[GrSize-M(2:end,4)']];
	MeanArray=[MeanArray;M(2:end,5)'./1000];   
   SDArray=[SDArray;M(2:end,6)'./1000];
end
Times=M(2:end,1);
MaxAvg=mean(MaxArray).*1.324e-4;		% Get averages and s.d.'s
MinAvg=mean(MinArray).*1.324e-4;
OverAvg=mean(OverArray);
MeanAvg=mean(MeanArray).*1.324e-4;
SDAvg=mean(SDArray).*1.324e-4;
MaxStd=std(MaxArray).*1.324e-4;
MinStd=std(MinArray).*1.324e-4;
OverStd=std(OverArray);
MeanStd=std(MeanArray).*1.324e-4;
SDStd=std(SDArray).*1.324e-4;
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
ErrorMax(Times,MaxAvg,MaxStd,MinMaxHndl,1,'b');hold on;
errorbar(Times,MinAvg,MinStd,'b:');hold off;
axis('tight'),title('Max and Min');
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,'r');axis('tight');title('# Over');

MeanHndl=subplot('position',[0.05 0.05 0.4 0.4]);
errorbar(Times,MeanAvg,MeanStd,'r');axis('tight');title('Mean Conc.');

SDHndl=subplot('position',[0.55 0.05 0.4 0.4]);
errorbar(Times,SDAvg,SDStd,'r');axis('tight');title('s.d. Conc.');
if(nargin<4) StoreAvgs =0; end;
if(StoreAvgs)
filename=[MStr 'TreeRho100/TreeAvgsSst1MaxGr300X'int2str(X) 'Z'int2str(X) 'Sq1Sp10Sl' num2str(Sl) '.mat'];
save(filename,'Times','MaxAvg','MinAvg','OverAvg','MeanAvg', ...
   'MaxStd','MinStd','OverStd','MeanStd','SDAvg','SDStd','Vers')
end
return
