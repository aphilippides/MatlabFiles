% function[NewObj]=RndEnvironment(NumObj,ArenaRng,RadRng)
%
% function[NewObj]=RndEnvironment(NumObj,ArenaRng,RadRng,Objects)
%
% function[NewObj]=RndEnvironment(NumObj,ArenaRng,RadRng,Objects,OverlapSelf)
%
% function to generate NumObj circular objects in a 2d random environment
% of range ArenaRng (real-valued positions). The objects have randomly
% generated radii in the range RadRng. If RadRng is a single value not a
% range, all objects are of this radius.
%
% Objects are output as a row of a NumObj x 3 matrix each row of which
% specifies (x,y,radius) for an object
%
% New objects will not overlap with any objects that are specified in
% Objects (specified in same format as the output format; default is empty
% matrix.
%
% If OverlapSelf is true (=1; default is false = 0), New objects
% will not overlap each other.
%
% If the environment cannot fit new objects (100 tries to fit a single
% object), a [-100 -100 -100] flag is returned.
%
% USAGE:    obj = RndEnvironment(20,[1 100],[1 20])
%           if(obj(1,3)>0) objects=obj; end;

function[NewObj]=RndEnvironment(NumObj,ArenaRng,RadRng,Objects,OverlapSelf)

if(nargin<4) Objects=[]; end;
if(nargin<5) OverlapSelf=0; end;

% Generate object radii. Don't regenerate this in the loop as I want the
% environment to return cluttered without biasing towards small objects
if(length(RadRng)==1) ObjRs = ones(NumObj,1)*RadRng;
else ObjRs = RndRange([NumObj,1],RadRng);
end

% for debugging;
Drawing=0;

NewObj=[];
for i=1:NumObj

    % set the radius. If random radii to be generated change this bit
    rad=ObjRs(i);

    % check Objects isn't empty and start a loop checking for overlaps
    count=0;
    n=size(Objects,1);
    if(isempty(Objects)) ObjPos = RndRange([1,2],ArenaRng);
    else
        while((n>0)&(count<100))

            % generate a random position
            ObjPos = RndRange([1,2],ArenaRng);

            % get distance to all other positions
            Obj2Others = Objects(:,[1 2]) - ones(size(Objects,1),1)*ObjPos;
            DistToObj = sqrt(sum(Obj2Others.^2,2));

            % count number of overlapping positions
            Overlaps=find(DistToObj<=(Objects(:,3)+rad));
            n=length(Overlaps);
            count=count+1;
        end
    end

    % if environment too cluttered to find a non-overlapping position
    % after 100 goes, return a bad flag and return else add to the object
    % list
    if(count==100)
        NewObj = [-100 -100 -100];
        return;
    elseif(isempty(Objects)) 
        ObjPos = RndRange([1,2],ArenaRng);
        NewObj = [NewObj;ObjPos rad];
    else  NewObj = [NewObj;ObjPos rad];
    end

    % if objects shouldn't overlap themselves, add new obj to Object list
    if(OverlapSelf) Objects = [Objects;ObjPos rad]; end;
end

if(Drawing)
    hold off
    for i=1:NumObj
        MyCircle(NewObj(i,[1 2]),NewObj(i,3),'g')
        hold on;
    end
    for i=1:size(Objects,1)
        MyCircle(Objects(i,[1 2]),Objects(i,3),'r')
    end
    hold off
end