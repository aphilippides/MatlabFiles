function GetMeanCleanData()

SumX=0;
SumXSq=0;
NumChems=0;
load CleanDataSet1NZ;
MaxChems=max(M(:,2:end));
MinChems=min(M(:,2:end));
NumChems=size(M,1);
SumX=sum(M(:,2:end));
SumXSq=sum(M(:,2:end).^2);
MeanChems=SumX./NumChems;
VarChems=SumXSq./NumChems-MeanChems.^2;
SDChems=sqrt(VarChems);

save NCIMeanCleanData.mat MeanChems VarChems SDChems MaxChems MinChems NumChems




