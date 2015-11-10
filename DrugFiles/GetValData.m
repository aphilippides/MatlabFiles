function GetValData(Thresh,NumPts)

load FValNCIData.mat 
V=1:29;
IDs=[]; NewData=[];
%[Num,is,js,vals]=NumInRange(FValues,Thresh,1000);
[Num,is,js,vals]=NumInRange(FValues,-1000,Thresh);
rp=randperm(Num);
NewIs=is(rp);
NewJs=js(rp);
for i=1:NumPts
   i
   eval(['load NZRandSet'int2str(V(NewJs(i))) '.mat;']);
   eval(['M=NZRandSet'int2str(V(NewJs(i))) ';']);
   NewData=[NewData;M(NewIs(i),:)];
   clear M NZRandSet* Perm1 RPerm
end
IDs=[NewIs(1:NumPts) NewJs(1:NumPts)];
%eval(['NCIHigh' x2str(Thresh) 'Data=NewData;']);
%eval(['save NCI_NZHigh'x2str(Thresh) '.mat NCIHigh' x2str(Thresh) 'Data IDs;']);
eval(['NCILow' x2str(Thresh) 'Data=NewData;']);
eval(['save NCI_NZLow'x2str(Thresh) '.mat NCILow' x2str(Thresh) 'Data IDs;']);
