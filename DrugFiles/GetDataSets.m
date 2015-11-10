function GetDataSets(M)

L=GetNonZeroes(M);
GetSets(L);


function[NonZeroData]=GetNonZeroes(M)

[DRs,CHs]=size(M);
SumCols=sum(M);
NonZeroCols=find(SumCols~=0);
NonZeroData=M(:,NonZeroCols);
save NCINonZero.mat NonZeroData NonZeroCols;

function GetSets(M)

% Randomly Permute M
[ND,NC]=size(M);
RPerm=RandPerm(ND);

% Get Random Sets
SetSize=1000;
NSets=ceil(ND/SetSize);
for i=1:NSets-1
   eval(['Perm'int2str(i) '=RPerm(1+(i-1)*SetSize:i*SetSize);']);
   eval(['NZRandSet'int2str(i) '=M(Perm'int2str(i) ',:);']);
   eval(['save NZRandSet'int2str(i) '.mat NZRandSet'int2str(i) ' Perm'int2str(i) ' RPerm;']);
end
eval(['Perm'int2str(NSets) '=RPerm(1+(NSets-1)*SetSize:ND);']);
eval(['NZRandSet'int2str(NSets) '=M(Perm'int2str(NSets) ',:);']);
eval(['save NZRandSet'int2str(NSets) '.mat NZRandSet'int2str(NSets) ' Perm'int2str(NSets) ' RPerm;']);


function dummy
RPermTrain=RPerm(1:9000)
RPermVal=RPerm(9001:18000)
RPermTest=RPerm(19:ND)
TrainSet=M(RPermTrain,:);
ValidateSet=M(RPermVal,:);
TestSet=M(RPermTest,:);

save NCITrainNonZ.mat TrainSet RPermTrain RPerm;
save NCIValidateNonZ.mat ValidateSet RPermVal RPerm;
save NCITestNonZ.mat TestSet RPermTest RPerm;