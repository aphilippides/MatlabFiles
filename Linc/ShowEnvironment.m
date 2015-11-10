function ShowEnvironment

NPts=100;

x1=1; x2=100;
y1=x1;y2=x2;
[Obj]=RndEnvironment(10,[x1 x2],[1 10],[50,50,20;10,10,10],1);
if(Obj(1,3)<0)
    disp('environment too cluttered!')
    return;
end

for i=x1:(x2-x1)/NPts:x2
    for j=y1:(y2-y1)/NPts:y2
        
    end
end

function ObjectsSeen
% 90 facets, 4 degrees each
Object = 1 % if more than 50% of facet covered

function CalcALV(LMs)

% ALV = average of unit vectors to the left hand of each object