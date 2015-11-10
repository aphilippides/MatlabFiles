function GetNCIMeanData(V)

SumX=0;
SumXSq=0;
NumChems=0;
MaxChems=[];
MinChems=[];
for i=1:length(V)
   eval(['load NZRandSet'int2str(V(i)) '.mat;']);
   eval(['M=NZRandSet'int2str(V(i)) ';']);
   [x,y]=size(M);
   MaxChems=max([MaxChems;M(:,2:end)]);
   MinChems=min([MinChems;M(:,2:end)]);
	NumChems=NumChems+x;
   SumX=SumX+sum(M(:,2:end));
   SumXSq=SumXSq+sum(M(:,2:end).^2);
   clear M NZRandSet* *Perm*
end
MeanChems=SumX./NumChems;
VarChems=SumXSq./NumChems-MeanChems.^2;
SDChems=sqrt(VarChems);

save NCIMeanData1_30.mat MeanChems VarChems SDChems MaxChems MinChems NumChems




