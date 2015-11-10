% function[NewBPos,NewBInds,WhichB] = ...
%     MatchAntsToPos(BPos,Cents,MaxD,BInds,MaxBInd)
% 
% function to match ants from old frame to new frame. It works pretty
% simply by just checking which is the nearest ant in olde and new
% positions. The only wrinkle is that when an ant is picked as being the
% same in subsequent frames, it is removed from the list of matchees.
% This could cause problems when they stop and touch but could be fixed
% 'easil;y' enough
%
% Key to the function is that bees are labelled with an index when
% identified. This is stored in WhichB. It means that if I want to extract
% all the ants which are the ant 3, say, I do: is=find(WhichB==3)
% See PlotAntPaths for an example of it working.
% Unmatched ants are given a new index
%
% input variables are (in order): ant positions from previous frame,
% centroids of new ants, Maximum distance allowed for an ant to be
% considered a match, the old labels and the maximum previous label
%
% output variables are (respectively): ant positions and labels, ordered so
% they match up and so they can be used as input positions and labels for
% the next frame, WhichB which holds the label data

function[NewBPos,NewBInds,WhichB] = ...
    MatchAntsToPos(BPos,Cents,MaxD,BInds,MaxBInd)

% INitialise variables
nb=size(BPos,1);
nc=size(Cents,1);
WhichB=zeros(1,nc);
NewBPos=[];
NewBInds=[];
i=1;
CPos=[1:nc];

% while there are still ants to match
while((nb>0)&(nc>0))
    
    % find the nearest ant position to centres
    d=[];ind=[];
    for j=1:nb
        [d(j),ind(j)]=min(sqrt((BPos(j,1)-Cents(:,1)).^2+(BPos(j,2)-Cents(:,2)).^2));
    end

    % find closest of the centres
    [md,mi]=min(d);

    % if it is within ant distance tolerance, add it to new bee list
    if(md<MaxD)
        NewBPos(i,:)=Cents(ind(mi),:);
        NewBInds(i)=BInds(mi);
        i=i+1;
        WhichB(CPos(ind(mi)))=BInds(mi);
        
        % rmove the matched ant from the list of potential matchers and matchees
        % could change this if ants are allowed to match with multiple
        % others
        BPos=RemoveRow(BPos,mi);
        BInds=RemoveRow(BInds',mi)';
        Cents=RemoveRow(Cents,ind(mi));
        CPos=RemoveRow(CPos',ind(mi))';
    else  break;
    end

    nb=size(BPos,1);
    nc=size(Cents,1);
end

% add in the remaining centres as bee positions
% as they have no previous position, make old position = new position
NewBPos=[NewBPos; Cents];
newinds=MaxBInd+[1:size(Cents,1)];
NewBInds=[NewBInds newinds];
WhichB(CPos)=newinds;