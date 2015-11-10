function[Arcs]=SelectArcs(os,t,Othresh,Tthresh,Plotting)
if(nargin<3) Othresh=0.349; end;
% if(nargin<3) Othresh=0.0873; end;
% if(nargin<3) Othresh=0.1745; end;
if(nargin<4) Tthresh=0.05; end;
% if(nargin<4) Tthresh=0.1; end;
if(nargin<5) Plotting=1; end;

if(size(os,1)>size(os,2)) os=os'; end;
os=AngleWithoutFlip(os);
[ma_t,ma_s,mi_t,mi_s]=GetArcs(os,t,Othresh,Tthresh,Plotting);
[ot is]=sort([ma_t mi_t]);
oa=[ma_s mi_s];
oa=oa(is);

Arcs=[ot;oa]';
xs=[];
while 0%1
    [sel,i]=GetNearestClickedPoint([[ot;oa]';xs],[t;os]');
    if(i==-2) 
        Arcs = RemoveRow(Arcs,[],sel);
        xs = RemoveRow(xs,[],sel);
    elseif(i==-1) break;
    elseif(i==0)
        if(isempty(xs)) xs=sel; 
        else xs=union(xs,sel,'rows');
        end
        if(isempty(Arcs)) Arcs=sel;
        else Arcs=union(Arcs,sel,'rows');
        end
    else
        if(isempty(Arcs)) Arcs=sel;
        else Arcs=union(Arcs,sel,'rows');
        end
    end;
    if(Plotting)
        plot(t,AngleWithoutFlip(os),ot,oa,'r.')
        if(~isempty(Arcs))
            hold on; plot(Arcs(:,1),Arcs(:,2),'ko'); hold off
        end
    end
end
for i=1:size(Arcs,1) Arcs(i,3)=find(t==Arcs(i,1),1); end
% tmpscriptBees

function[pt,i]=GetNearestClickedPoint(xs,alls)
title('Click near a point; right select new; else to delete')
pt=[];
[p,q,r]=ginput(1);
if(~isempty(p))
    if(r==1)
        if(p<xs(1,1)) 
            pt=xs;
            i=1;
        else
        ds=CartDist(xs,[p q]);
        [m i]=min(ds);
        pt=xs(i,:);
        end
    elseif(r==3)
        i=0;
        ds=CartDist(alls,[p q]);
        [m j]=min(ds);
        pt=alls(j,:);
    else
        ds=CartDist(xs,[p q]);
        [m i]=min(ds);
        pt=xs(i,:);
        i=-2;
    end
else i=-1;
end