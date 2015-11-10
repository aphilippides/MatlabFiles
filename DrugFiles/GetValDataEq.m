function GetValDataEq(Thresh,NumPts)

load FValNCIData.mat 
V=1:29;
IDs=[]; NewData=[];
[Num,is,js,vals]=NumEqual(FValues,Thresh,1);
%[Num,is,js,vals]=NumEqual(FValues,Thresh,0);
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
eval(['NCIEq' x2str(Thresh) 'Data=NewData;']);
eval(['save NCI_NZEq'x2str(Thresh) '.mat NCIEq' x2str(Thresh) 'Data IDs;']);
%eval(['NCINot' x2str(Thresh) 'Data=NewData;']);
%eval(['save NCI_NZNot'x2str(Thresh) '.mat NCINot' x2str(Thresh) 'Data IDs;']);
