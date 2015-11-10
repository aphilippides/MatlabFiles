% function[OutOrNest,IndList] = OutofBounds(Bounds,fn)
%
% fn is Nest and LM file
% Function to check if out of bounds or at the nest
% returns list of 1 for at edge, 2 for nest and 0 else
% Could change Tol to adjust bee finding

function[OutOrNest,IndList] = OutofBounds(Bounds,fn)

OutOrNest=zeros(1,size(Bounds,1));
IndList=[];
Tol=1;

% Old version. for mo do path of least resistance

% load([fn '_NestAndBoundData.mat'])
% RightEdge = floor(RightTop(1)/2);
% TopEdge = floor(RightTop(2)/2);
% NestLeft = floor(Nest(1)/2);
% NestBott = floor(Nest(2)/2);
% NestRight = ceil(Nest(3)/2);
% NestTop = ceil(Nest(4)/2);

load(fn)
RightEdge = 360;
TopEdge = 288;
NestLeft = floor((nest(1)-0.5*NestWid)/2);
NestRight = ceil((nest(1)+0.5*NestWid)/2);
NestBott = floor((nest(2)-0.5*NestWid)/2);
NestTop = ceil((nest(2)+0.5*NestWid)/2);

b=floor(Bounds);
lefts = b(:,1);
bottoms = b(:,2);
rights = 1+lefts+b(:,3);
tops = 1+bottoms+b(:,4);

IndList=find(lefts<=(1+Tol));
IndList=[IndList; find(bottoms<=(1+Tol))];
IndList=[IndList; find(rights>=(RightEdge-Tol))];
IndList=[IndList; find(tops>=(TopEdge-Tol))];
OutOrNest(IndList)=1;

isL = find((lefts<=NestLeft)&(rights>=NestLeft));
isR = find((lefts<=NestRight)&(rights>=NestRight));
isLR=union(isL,isR);

isB = find((bottoms<=NestBott)&(tops>=NestBott));
isT = find((bottoms<=NestTop)&(tops>=NestTop));
isTB=union(isB,isT);

isIn=intersect(isLR,isTB);
OutOrNest(isIn)=2;
IndList=union(IndList,isIn)';