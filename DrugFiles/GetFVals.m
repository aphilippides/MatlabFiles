function[Histo]= GetFVals
%Histo=GraphFData;
%GetLowData(4);
GetHighData(4);
%GetLowHighDataSets(4,100,25);
%Histo=0;

function[NumInC]=GraphFData

x=1;
load FValNCIData.mat 
Classes=-3:x:14;
for i=2:length(Classes)
   NumInC(i-1)=NumInRange(FValues,Classes(i-1),Classes(i));
end
bar(Classes(2:end)-x/2,NumInC)

function[Fs,Inds]=GetFData(V)

Chems=[];Fs=[];Inds=[];
for i=1:length(V)
   eval(['load NZRandSet'int2str(V(i)) '.mat;']);
   eval(['M=NZRandSet'int2str(V(i)) ';']);
   Inds=[Inds M(:,1)];
   Fs=[Fs M(:,end)];
   clear M NZRandSet* Perm1 RPerm
end

function GetHighData(Thresh)

load FValNCIData.mat 
V=1:29;
IDs=[]; HighData=[];
for i=1:29
   [Num,is,js,vals]=NumInRange(FValues(:,i),Thresh+.001,1000);
	eval(['load NZRandSet'int2str(V(i)) '.mat;']);
   eval(['M=NZRandSet'int2str(V(i)) ';']);
   HighData=[HighData;M(is,:)];
   IDs=[IDs;[is ones(length(is),1)*V(i)]];
end
eval(['NCIHigh' x2str(Thresh) 'Data=HighData;']);
eval(['save NCI_NZHigh'x2str(Thresh) '.mat NCIHigh' x2str(Thresh) 'Data IDs;']);
whos


function GetLowData(Thresh)

load FValNCIData.mat 
V=1:29;
IDs=[];LowData=[]; HighData=[];
for i=1:29
   [Num,is,js,vals]=NumInRange(FValues(:,i),-1000,Thresh);
	eval(['load NZRandSet'int2str(V(i)) '.mat;']);
   eval(['M=NZRandSet'int2str(V(i)) ';']);
   LowData=[LowData;M(is,:)];
   IDs=[IDs;[is ones(length(is),1)*V(i)]];
end
eval(['NCILow' x2str(Thresh) 'Data=LowData;']);
eval(['save NCI_NZLow'x2str(Thresh) '.mat NCILow' x2str(Thresh) 'Data IDs;']);
whos
