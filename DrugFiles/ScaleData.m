function[Scaled1,Scaled2,ScaledF]=ScaleData(RawData1,RawData2,ScaleType,F)

if(ScaleType==3)			% Scale by the Range of the Test data
	[Scaled1,Scaled2,ScaledF]=ScaleDataSamp1(RawData1,RawData2,F);
else							% Scale by the SD of the Test data
	[Scaled1,Scaled2,ScaledF]=ScaleDataSamp2(RawData1,RawData2,F);
end

function[Scaled1,Scaled2,ScaledF]=ScaleDataSamp1(RawData1,RawData2,F);

[x,y]=size(RawData1);
[x2,y2]=size(RawData2);
Maxes=max(RawData1(:,2:end-1));
Mins=min(RawData1(:,2:end-1));
Means=mean(RawData1(:,2:end-1));
Ranges=Maxes-Mins;
NonZeros=find(Ranges~=0);

Inds=RawData1(:,1);
Fs=RawData1(:,end);
NewDat=zeros(x,y-2);
for i=1:x
   NewDat(i,NonZeros)=(RawData1(i,NonZeros+1)-Means(NonZeros))./Ranges(NonZeros);
end
Scaled1=[Inds NewDat Fs];

Inds2=RawData2(:,1);
Fs2=RawData2(:,end);
NewDat2=zeros(x2,y-2);
for i=1:x2
   NewDat2(i,NonZeros)=(RawData2(i,NonZeros+1)-Means(NonZeros))./Ranges(NonZeros);
end
Scaled2=[Inds2 NewDat2 Fs2];
ScaledF=F;%(F-Means(end))/Ranges(end);

function[Scaled1,Scaled2,ScaledF]=ScaleDataSamp2(RawData1,RawData2,F);

[x,y]=size(RawData1);
[x2,y2]=size(RawData2);
Maxes=max(RawData1(:,2:end-1));
Mins=min(RawData1(:,2:end-1));
Means=mean(RawData1(:,2:end-1));
Stds=std(RawData1(:,2:end-1));
NonZeros=find(Stds~=0);

Inds=RawData1(:,1);
Fs=RawData1(:,end);
NewDat=zeros(x,y-2);
for i=1:x
   NewDat(i,NonZeros)=(RawData1(i,NonZeros+1)-Means(NonZeros))./Stds(NonZeros);
end
Scaled1=[Inds NewDat Fs];

Inds2=RawData2(:,1);
Fs2=RawData2(:,end);
NewDat2=zeros(x2,y-2);
for i=1:x2
   NewDat2(i,NonZeros)=(RawData2(i,NonZeros+1)-Means(NonZeros))./Stds(NonZeros);
end
Scaled2=[Inds2 NewDat2 Fs2];
ScaledF=(F);%-Means(end))/Stds(end);
