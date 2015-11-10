function[Scaled1,Scaled2,ScaledF]=ScaleData2(RawData1,RawData2,ScaleType,F)

if(ScaleType==0)			% No Scaling
	[Scaled1,Scaled2,ScaledF]=ScaleDataAll3(RawData1,RawData2,F);
elseif(ScaleType==1)			% Scale by the Range of all data
	[Scaled1,Scaled2,ScaledF]=ScaleDataAll1(RawData1,RawData2,F);
else	   						% Scale by the SD of all data
   [Scaled1,Scaled2,ScaledF]=ScaleDataAll2(RawData1,RawData2,F);
end


function[Scaled1,Scaled2,ScaledF]=ScaleDataAll1(RawData1,RawData2,F);

if(~IsFile('NCIMeanData1_30.mat'))
   GetNCIMeanData([1:30]);
end
load NCIMeanData1_30.mat;

[x,y]=size(RawData1);
[x2,y2]=size(RawData2);
Inds=RawData1(:,1);

Ranges=MaxChems-MinChems;
NonZeros=find(Ranges~=0);
NewDat=zeros(x,y-1);
for i=1:x
   NewDat(i,NonZeros)=(RawData1(i,NonZeros+1)-MeanChems(NonZeros))./Ranges(NonZeros);
end
Scaled1=[Inds NewDat];

Inds2=RawData2(:,1);
NewDat2=zeros(x2,y-1);
for i=1:x2
   NewDat2(i,NonZeros)=(RawData2(i,NonZeros+1)-MeanChems(NonZeros))./Ranges(NonZeros);
end
Scaled2=[Inds2 NewDat2];
ScaledF=(F-MeanChems(end))/Ranges(end);

function[Scaled1,Scaled2,ScaledF]=ScaleDataAll2(RawData1,RawData2,F);

if(~IsFile('NCIMeanData1_30.mat'))
   GetNCIMeanData([1:30]);
end
load NCIMeanData1_30.mat;

[x,y]=size(RawData1);
[x2,y2]=size(RawData2);
Inds=RawData1(:,1);

NonZeros=find(SDChems~=0);
NewDat=zeros(x,y-1);
for i=1:x
   NewDat(i,NonZeros)=(RawData1(i,NonZeros+1)-MeanChems(NonZeros))./SDChems(NonZeros);
end
Scaled1=[Inds NewDat];

Inds2=RawData2(:,1);
NewDat2=zeros(x2,y-1);
for i=1:x2
   NewDat2(i,NonZeros)=(RawData2(i,NonZeros+1)-MeanChems(NonZeros))./SDChems(NonZeros);
end
Scaled2=[Inds2 NewDat2];
ScaledF=(F-MeanChems(end))/SDChems(end);

function[Scaled1,Scaled2,ScaledF]=ScaleDataAll3(RawData1,RawData2,F);

Scaled1=RawData1;
Scaled2=RawData2;
ScaledF=F;
