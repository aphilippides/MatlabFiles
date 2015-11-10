% FinalCheck('4 dig white 30-07-07 12-56 53 out 3')

function FinalCheck(fn);
pn=[fn 'All.mat'];
CheckLastBit(pn,fn); 

function CheckLastBit(AllN,ff);
load(AllN)

[sOr,unsure,Cents] = AdjOrients(sOr,Cents,FrameNum,[ff '.avi'],unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
input('Press return to continue');

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
clear i is a
save(AllN)