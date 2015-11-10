% function[dat]=PositionOnRetina(Pos,Cents,sOr)
%
% function gets the retinal position of each row of Positions in Pos
% it needs Cents (nx2 matrix, each row is (x,y) position) and sOr
% which is the body orientation, nx1 column vector (it's arranged in this 
% way as these are the variable names and organisation used to get the
% retinal positions of landmarks in GetAllDataxx.m)
% 
% the 4th argument is optional. It is because one very often data has been 
% re-scaled to make the nest the origin, distances in cm and body
% orientation relative to North. Rescaling of distances doesn't matter but 
% rotation of sOr does as the angle to the position is calculated relative
% to the matlab axes (ie standard)

function[dat]=PositionOnRetina(Pos,Cents,sOr,compassDir)

if(nargin>3)
    sOr=sOr+compassDir;
end
for i=1:size(Pos,1)
    dat(i).Pos=Pos(i,:);
    dat(i).VToLM=[Pos(i,1)-Cents(:,1),Pos(i,2)-Cents(:,2)];
    dat(i).DToLM=sqrt(sum(dat(i).VToLM.^2,2));
    dat(i).OToLM=cart2pol(dat(i).VToLM(:,1),dat(i).VToLM(:,2));
    dat(i).LMOnRetina=AngularDifference(dat(i).OToLM,sOr');
end
% dat=dat(i).LMOnRetina;