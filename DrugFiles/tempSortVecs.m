function tempSortVecs(M,N)
IDs1=M(:,1);
IDs2=N(:,1);
check=setdiff(IDs1,IDs2)
FVals1=M(:,end);
FVals2=N(:,end);
NewChems=[];
for i=1:length(IDs1)
   i
   NewP=find(IDs2==IDs1(i));
   if(length(NewP)>1) 
      [MinF MinFNum]=min(FVals2(NewP));
      Chem=NewP(MinFNum);
   elseif(length(NewP)==0)
      Chem=[];
   else
      Chem=NewP;
   end
   NewChems=[NewChems Chem];
end
IDs2=IDs2(NewChems);
check2=max(abs(IDs1-IDs2))
FVals2=FVals2(NewChems);
M2=M;
M2(:,end)=FVals2;
IDsAndFs=[IDs2 FVals2];
IDsAndAllFs=[IDs1 FVals1 FVals2];

save CleanDataSet2.dat M2 -ascii;
save CleanDataSet2_IDAndF.dat IDsAndFs -ascii;
save CleanDataAllScores.dat IDsAndAllFs -ascii;

save CleanDataSet2.mat M2 ;
save CleanDataSet2_IDAndF.mat IDs2 FVals2 ;
save CleanDataAllScores.mat IDs1 FVals1 FVals2 ;
