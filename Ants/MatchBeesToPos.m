function[NewBPos,NewBInds,WhichB,OldBPos] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd)

Cents=c;
nb=size(BPos,1);
nc=size(Cents,1);
WhichB=zeros(1,nc);
NewBPos=[];
OldBPos=[];
NewBInds=[];
i=1;
CPos=[1:nc];
% while there are still bees to match
while((nb>0)&(nc>0))
    % find the nearest bee position to centres
    % Could do position plus last speed
    % Or something more sophisticated involving kalman filters 

    d=[];ind=[];
    for j=1:nb
        [d(j),ind(j)]=min(sqrt((BPos(j,1)-Cents(:,1)).^2+(BPos(j,2)-Cents(:,2)).^2));
    end

    % find closest of the centres
    [md,mi]=min(d);

    % if it is within bee distance tolerance, add it to new bee list
    if(md<MaxD)
        OldBPos(i,:)=BPos(mi,:);
        NewBPos(i,:)=Cents(ind(mi),:);
        NewBInds(i)=BInds(mi);
        i=i+1;
        WhichB(CPos(ind(mi)))=BInds(mi);
        BPos=RemoveRow(BPos,mi);
        BInds=RemoveRow(BInds',mi)';
        Cents=RemoveRow(Cents,ind(mi));
        CPos=RemoveRow(CPos',ind(mi))';
    else
        break;
    end

    nb=size(BPos,1);
    nc=size(Cents,1);
end
% add in the remaining centres as bee positions
% as they have no previous position, make old position = new position

NewBPos=[NewBPos; Cents];
OldBPos=[OldBPos; Cents];
BSpeed=NewBPos-OldBPos;
newinds=MaxBInd+[1:size(Cents,1)];
NewBInds=[NewBInds newinds];
WhichB(CPos)=newinds;