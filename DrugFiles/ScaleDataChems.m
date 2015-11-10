function[Scaled1,Scaled2,ScaledF]=ScaleDataChems(RawData1,RawData2,ScaleType,F);

if(ScaleType==5)
   [Scaled1,Scaled2,ScaledF]=ScaleDataChem1(RawData1,RawData2,F);
elseif(ScaleType==6)
   [Scaled1,Scaled2,ScaledF]=ScaleDataChem2(RawData1,RawData2,F);
else 
   [Scaled1,Scaled2,ScaledF]=ScaleDataBinary(RawData1,RawData2,F);  
end  


function[Scaled1,Scaled2,ScaledF]=ScaleDataChem1(RawData1,RawData2,F);

SumChems=sum(RawData1(:,2:end-1),2);
[x,y]=size(RawData1);
Inds=RawData1(:,1);
Fs=RawData1(:,end);

NewDat=zeros(x,y-2);
for i=1:x
   if(SumChems(i)==0)
      NewDat(i,:)=RawData1(i,2:end-1);
   else
      NewDat(i,:)=RawData1(i,2:end-1)./SumChems(i);
   end
end
Scaled1=[Inds NewDat Fs];

SumChems2=sum(RawData2(:,2:end-1),2);
[x2,y2]=size(RawData2);
Inds2=RawData2(:,1);
Fs2=RawData2(:,end);

NewDat2=zeros(x2,y2-2);
for i=1:x2
   if(SumChems2(i)==0)
      NewDat2(i,:)=RawData2(i,2:end-1);
   else
      NewDat2(i,:)=RawData2(i,2:end-1)./SumChems2(i);
   end
end
Scaled2=[Inds2 NewDat2 Fs2];

ScaledF=F;


function[Scaled1,Scaled2,ScaledF]=ScaleDataChem2(RawData1,RawData2,F);

Maxes=max(RawData1(:,2:end-1),2);
[x,y]=size(RawData1);
Inds=RawData1(:,1);
Fs=RawData1(:,end);

NewDat=zeros(x,y-2);
for i=1:x
   if(Maxes(i)==0)
      NewDat(i,:)=RawData1(i,2:end-1);
   else
      NewDat(i,:)=RawData1(i,2:end-1)./Maxes(i);
   end
end
Scaled1=[Inds NewDat Fs];

Maxes2=max(RawData2(:,2:end-1),2);
[x2,y2]=size(RawData2);
Inds2=RawData2(:,1);
Fs2=RawData2(:,end);

NewDat2=zeros(x2,y2-2);
for i=1:x2
   if(Maxes2(i)==0)
      NewDat2(i,:)=RawData2(i,2:end-1);
   else
      NewDat2(i,:)=RawData2(i,2:end-1)./Maxes2(i);
   end   
end
Scaled2=[Inds2 NewDat2 Fs2];

ScaledF=F;

function[Scaled1,Scaled2,ScaledF]=ScaleDataBinary(RawData1,RawData2,F)

Scaled1=MkDataBinary(RawData1);
Scaled2=MkDataBinary(RawData2);
ScaledF=F;
