function[NewOs,Cents,lens,bads,unsure]=CheckOrients2012(Orients,Cents,...
    lens,FrameNum,inds,fn,showO,opt,TStr)
if(nargin<9) 
    TStr=[]; 
end
if(nargin<8) 
    opt=0; 
end
% whether to show the orientation or not
if(nargin<7) 
    showO=1; 
end
% if you've passed in frames *not* the indices of the frames you want to do
% get the indices ***NOT PROPERLY DEBUGGED ***
if(opt==1)
    is=[];
    for f=inds
        is=[is find(FrameNum==f)];
    end
    keyboard
    inds=is;
end
bads=[];
unsure=[];

% if(ismember(i,bads)) uns=1;
% else uns=0;
% end
TrL=2;
maxl=length(Orients);

[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,lens);
EndPt=EndPt+Cents;
for j=1:length(inds)
    k=inds(j);
    fr=floor((FrameNum(k)+1)/2);
    im=MyAviRead(fn,fr,1);
    title(['frame ' int2str(FrameNum(k))])
    TStr=['frame ' int2str(FrameNum(k))];
    uns=0;
    while(1)
        trac=max(1,k-TrL):min(maxl,k+TrL);
        if(showO)
            [pts,redo,skip,uns]=AdjustPts([Cents(k,:);EndPt(k,:)],im,...
                FrameNum(k),TStr,uns,Cents(trac,:));
        else
            [pts,redo,skip,uns]=AdjustPts([Cents(k,:);Cents(k,:)],im,...
                FrameNum(k),TStr,uns,Cents(trac,:));
        end
        if(skip==1)
            bads=[bads k];
            break;
        elseif(skip==-1)
            keyboard
            break;
        elseif(redo==0)
            Cents(k,:)=pts(1,:);
            EndPt(k,:)=pts(2,:);
            if(uns)
                unsure = [unsure k];
            end
            break;
        end
    end
end
d=EndPt-Cents;
[NewOs,lens]=cart2pol(d(:,1),d(:,2));

function[pts,redo,skip,unsure]=AdjustPts(pts,im,fr,TStr,unsure,tr)
redo=0;
skip=0;
bwid=50;
adp=2;
while(1)
    imagesc(im);
    axis equal
    a1=pts(1,:)-bwid;
    a2=pts(1,:)+bwid;
    X=[a1(1) a2(1) a1(2) a2(2)];
    axis(X), hold on;
    if(size(tr,1)>1) 
        plot(tr(:,1),tr(:,2),'b:',tr(2:end,1),tr(2:end,2),'bo')%,tr(1:end-1,1),tr(1:end-1,2),'bo') 
    end;
    plot(pts(:,1),pts(:,2),'g',pts(1,1),pts(1,2),'g.')
    hold off

    title([TStr ': Left click move, right click toggle unsure, c centre, a area'])
    xlabel('Return finish, r re-do, s skip (BAD FRAME), n to try next thing')
    if(unsure) 
        ystr='UNSURE';
    else
        ystr=[];
    end
    ylabel(['Frame ' int2str(fr) ';  ' ystr])
    [p,q,b]=ginput(1);
    if(char(b)=='c')
        if(adp==1) 
            adp=2;
        else
            adp=1;
        end
    elseif(char(b)=='a')
        xlabel('Set axis by clicking away from the bee, ratio 1:5');
        [dx,dy]=ginput(1);
        d=CartDist(pts(1,:),[dx dy]);
        bwid=max(25,5*d);
        bwid=min(250,bwid);
    elseif(char(b)=='r')
        redo=1;
        break;
    elseif(char(b)=='s')
        skip=1;
        break;
    elseif(char(b)=='n')
        skip=-1;
        break;
    elseif(isempty(p)) 
        break;
    else
%         vs=pts-ones(length(pts),1)*[p,q];
%         ds=sum(vs.^2,2);
%         [mini_d,i_m]=min(ds);
%         pts(i_m,:)=[p q];

        % only doing the head
        pts(adp,:)=[p q];
        if(b~=1) 
            unsure=mod(unsure+1,2);
        end;
    end
end