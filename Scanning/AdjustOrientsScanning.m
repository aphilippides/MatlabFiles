function[NewOs,Cents,len,bads,unsure] = ...
    AdjustOrientsScanning(Orients,Cents,lens,FrameNum,fn,TStr,trac,uns)

if(nargin<6) TStr=[]; end
if(nargin<7) trac=[]; end
if(nargin<8) uns=0; end
bads=[];unsure=[];

[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,lens);
EndPt=EndPt+Cents;
for k=1:length(FrameNum)
    fr=FrameNum(k);%floor((FrameNum(k)+1)/2);
    im=MyAviRead(fn,fr,1);

    title(['frame ' int2str(FrameNum(k)) ])
    while(1)
        [pts,redo,skip,uns]=AdjustPts([Cents(k,:);EndPt(k,:)],im,FrameNum(k),TStr,uns,trac);
        if(skip==1)
%             a=input('Definitely skip? 0 to cancel');
%             if(isempty(a)|(a~=0))
                bads=[bads k];
                break;
%             end
        elseif(skip==-1) 
            bads=-1;
            break;
        elseif(redo==0)
            % if the pts are accepted overwrite the data
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
[NewOs,len]=cart2pol(d(:,1),d(:,2));

function[pts,redo,skip,unsure]=AdjustPts(pts,im,fr,TStr,unsure,tr)
redo=0;
skip=0;
if(unsure) ystr='unsure';
else ystr=[];
end
bwid=25;
adp=2;
if(size(tr,1)>5) 
    brob = robustfit(tr(:,1),tr(:,2));
    br=brob(2);
    xtr=tr([1 end],1);
end
while(1)
    imagesc(im);
    axis equal
    a1=pts(1,:)-bwid;
    a2=pts(1,:)+bwid;
    X=[a1(1) a2(1) a1(2) a2(2)];
    axis(X), hold on;
    if(~isempty(tr))
%         % to get the movement line through the centre of the ant
%         tr_c=pts(1,2)-br*pts(1,1);
%         ytr=tr_c+br*xtr;
        % to use the line as estimated through robustfit
        if(size(tr,1)>5) 
            ytr=brob(1)+brob(2)*xtr;
            plot(xtr,ytr,'r--',tr(2:end,1),tr(2:end,2),'r.')%,tr(1:end-1,1),tr(1:end-1,2),'bo')
        else
            plot(tr(:,1),tr(:,2),'r--',tr(2:end,1),tr(2:end,2),'r.')%,tr(1:end-1,1),tr(1:end-1,2),'bo')
        end
    end;
    plot(pts(:,1),pts(:,2),'g',pts(1,1),pts(1,2),'g.')
    hold off

    title([TStr ': Left click move, right click unsure, c centre, a area'])
    xlabel('Return finish, r re-do, s skip (if unsure), n to try next thing')
    ylabel(['Frame ' int2str(fr) ';  ' ystr])
    [p,q,b]=ginput(1);
    if(char(b)=='c')
        if(adp==1) adp=2;
        else adp=1;
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
    elseif(isempty(p)) break;
    else
%         vs=pts-ones(length(pts),1)*[p,q];
%         ds=sum(vs.^2,2);
%         [mini_d,i_m]=min(ds);
%         pts(i_m,:)=[p q];

        % only doing the head
        pts(adp,:)=[p q];
        if(b~=1) 
            unsure=1;
            ystr='unsure';
        end;
    end
end