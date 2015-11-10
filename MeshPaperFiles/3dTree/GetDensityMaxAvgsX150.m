function GetDensityMaxAvgsX150(Dens,Sl,Vers,StoreAvgs,MStr)

dmm3d
if(nargin<5) MStr='Max';end;
MaxArray=[];
MinArray=[];
OverArray=[];
MeanArray=[];
SDArray=[];
for i=1:length(Vers)			% Get average data
   filename=[MStr 'TreeRho'x2str(Dens) '/TreeV' int2str(Vers(i)) 'MaxGr300Sq1Sl' num2str(Sl) '.dat'];
	M=load(filename);
    Vers(i)
   GrSize=(M(1,3)-M(1,2)).^3;
	MaxArray=[MaxArray;M(2:end,2)'];  
	MinArray=[MinArray;M(2:end,3)'];   
   OverArray=[OverArray;[GrSize-M(2:end,4)']];
end
Times=M(2:end,1);
MaxAvg=mean(MaxArray).*1.324e-4;		% Get averages and s.d.'s
MinAvg=mean(MinArray).*1.324e-4;
OverAvg=mean(OverArray);
MaxStd=std(MaxArray).*1.324e-4;
MinStd=std(MinArray).*1.324e-4;
OverStd=std(OverArray);
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
ErrorMax(Times,MaxAvg,MaxStd,MinMaxHndl,1,'b');hold on;
errorbar(Times,MinAvg,MinStd,'b:');hold off;
axis('tight'),title('Max and Min');
OverHndl=subplot('position',[0.55 0.55 0.4 0.4]);
errorbar(Times,OverAvg,OverStd,'r');axis('tight');title('# Over');

MeanHndl=subplot('position',[0.05 0.05 0.4 0.4]);
SDHndl=subplot('position',[0.55 0.05 0.4 0.4]);
if(nargin<4) StoreAvgs =0; end;
if(StoreAvgs)
filename=[MStr 'TreeRho'x2str(Dens) '/TreeAvgsSst1MaxGr300X150Z150Sq1Sp10Sl' num2str(Sl) '.mat'];
save(filename,'Times','MaxAvg','MinAvg','OverAvg','MaxStd','MinStd','OverStd','Vers')
end
return
