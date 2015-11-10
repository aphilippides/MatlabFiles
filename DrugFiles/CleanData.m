function CleanData(M)

M=GetRidOfZeros(M);
%M=GetRidOf4s(M);
%M=GetRidOfHighDoubles(M);
IDs=M(:,1);
Fs=M(:,end);
save CleanDataSet1NZ.mat M 
save CleanDataSet1NZ.dat M -ascii
idsfs=[IDs Fs];
save CleanDataSet1NZ_IDAndF.dat idsfs -ascii
save CleanDataSet1NZ_IDAndF.mat IDs Fs 

function[NewM]=GetRidOfHighDoubles(M)
IDs=M(:,1);
Fs=M(:,end);
NewChems=[];
for i=1:length(IDs)
   i
   Pos=find(IDs==IDs(i));
   if(length(Pos)>1)
      [MinF MinFNum]=min(Fs(Pos));
      Chem=Pos(MinFNum);
   else
      Chem=Pos;
   end
   NewChems=[NewChems Chem];
end
NewChems=unique(NewChems);
NewM=M(NewChems,:);

function[NewM]=GetRidOf4s(M)
Fs=M(:,end);
Is=find(Fs~=4.0);
NewM=M(Is,:);

function[NewM]=GetRidOfZeros(M)
SumCols=sum(abs(M));
NonZeros=find(SumCols~=0);
NewM=M(:,NonZeros);
