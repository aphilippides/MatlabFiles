% Funciton to produce datasets for crosss-validation

function[Tr,LabTr,Te,LabTe]=XValDataSet(SetSize,SetNum,X,LabX)

Te=X(:,(SetNum-1)*SetSize+1:SetNum*SetSize);
LabTe=LabX((SetNum-1)*SetSize+1:SetNum*SetSize);
Tr1=X(:,1:(SetNum-1)*SetSize);
Tr2=X(:,SetNum*SetSize+1:end);
Tr=[Tr1 Tr2];
LabTr1=LabX(1:(SetNum-1)*SetSize);
LabTr2=LabX(SetNum*SetSize+1:end);
LabTr=[LabTr1 LabTr2];

