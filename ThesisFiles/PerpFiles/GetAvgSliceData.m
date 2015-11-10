function GetAvgSliceData(MStr,GridSize,Density,Slice)
%Versions=[1,2,3,4,5,16,17,18,19,20];
Versions=1:32;
MaxArray=[];
MinArray=[];
NotArray=[];
BinArray=[];

for i=1:length(Versions)
   [Times,maxes,mins,numnots]=GetSliceDataPerp('Max',GridSize,Density,Slice,...
      1,300,Versions(i))
   MaxArray=[MaxArray;maxes]
   MinArray=[MinArray;mins];   
   NotArray=[NotArray;numnots];
   
   % Get averages and s.d.'s
   MaxAvg=mean(MaxArray);
   MinAvg=mean(MinArray);
   NotAvg=mean(NotArray);
   MaxStd=std(MaxArray);
   MinStd=std(MinArray); 
   NotStd=std(NotArray);
   
   filename=[MStr 'PerpRho' num2str(Density) '/AvgPerpDataOutGr' num2str(GridSize) ...
         'Sq1Sl' num2str(Slice) '.mat'];   
   save(filename,'Times','MaxAvg','MinAvg','NotAvg','MaxStd','MinStd','NotStd')  
end

MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);	%plot means and error bars
errorbar(Times,MaxAvg,MaxStd,'r');hold on;
errorbar(Times,MinAvg,MinStd,'r:');hold off;
axis('tight')
PCNotHndl=subplot('position',[0.05 0.05 0.4 0.4]);
errorbar(Times,NotAvg,NotStd,'r');
return


function[Times,Maxes,Mins,NumNot]=GetSliceDataPerp(MStr,GridSize,Density,Slice,x,y,Version)

Sqare=1;
Times=0:25:1250;
for i=1:length(Times)			% Get average data
   filename=[MStr 'PerpRho' num2str(Density) '/TreeV' int2str(Version) ...
         'Sl' num2str(Slice) 'Gr' num2str(GridSize) 'Sq' num2str(Sqare) ...
         'T' int2str(Times(i)) '.dat'];
   M=load(filename);
   M=M(x:y,x:y);
   Maxes(i)=max(max(M));
   Mins(i)=min(min(M));
   [dum,dum2,v]=find(M<=0.00188);
   NumNot(i)=length(v);
end
filename=[MStr 'PerpRho' num2str(Density) '/SliceDataV' num2str(Version) ...
      'Gr' num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' num2str(Slice) '.mat'];
%save(filename,'Times','Maxes','Mins','NumNot')
return
