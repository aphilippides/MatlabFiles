function[inObj,Overlaps,V2Nearest,MinDist,MinInd]=InsideObject(Objects,agent)

Obj2Others = Objects(:,[1 2]) - ones(size(Objects,1),1)*agent([1 2]);
DistToObj = sqrt(sum(Obj2Others.^2,2));
Overlaps=find(DistToObj<=(Objects(:,3)+agent(3)));
inObj=sum(Overlaps)>0;
[MinDist,MinInd]=min(DistToObj);
V2Nearest=Obj2Others(MinInd,:);