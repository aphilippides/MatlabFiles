% this function checks frames that are near the nest where there's a gap
% and where there is currently no bee.

% the earlier commented out version was an attempt to update in situ but it
% didn;t work

% function[dat,cout,epout,os,len]=CheckOrientsNest(Cents,EndPt,inds,...
%     isneigh,fn,cs,frs,eps,os,len,vObj,shades)
function[dat]=CheckOrientsNest(Cents,EndPt,inds,...
    isneigh,fn,cs,frs,eps,os,len,vObj,shades)

bads=[];
unsure=[];
fra=[];
TrL=1;
TrR=1;
maxl=size(cs,1);
cout=cs;
epout=eps;
lind=length(inds);
% shades says how much to alter the alternate rows
if(nargin<12)
    shades=[1.2 0.8];
end
for j=1:lind
    fr(j)=floor((inds(j)+1)/2);
    im=MyAviRead(fn,fr(j),vObj);
    oe=mod(inds(j),2);
    if(oe==1)
        s1=1;
        s2=2;
    else
        s2=1;
        s1=2;
    end
    nim=im;
    nim(s1:2:end,:,:)=im(s1:2:end,:,:)*shades(1);
    nim(s2:2:end,:,:)=im(s2:2:end,:,:)*shades(2);
    TStr=['frame ' int2str(fr(j)) ', Fr ' int2str(inds(j)) '; ' ...
        int2str(j) '/' int2str(length(inds))];
    uns=0;
    
    % get the nearest point
%     if 1%(nargin>11)
        b4=find(frs<inds(j),1,'last');
        if(isempty(b4))
            tr_b4=[];
        else        
            tr_b4=max(1,b4-TrL):b4;
        end
        aft=find(frs>inds(j),1);
        if(isempty(aft))
            tr_aft=[];
        else
            tr_aft=aft:min(maxl,aft+TrR);
        end
        
%     else
%         % get 2 points either side of the nearest point
%         % this needs updating to tr_b4 and tr_aft if it's to be used
%         [dum,near]=min(abs(frs-inds(j)));
%         trac=max(1,near-TrL):min(maxl,near+TrR);
%     end
        disp('this frame has no bee; if there is a bee click on it')
    while(1)
        [pts,redo,skip,uns]=AdjustPts([Cents(j,:);EndPt(j,:)],nim,...
            inds(j),TStr,uns,tr_b4,tr_aft,cs,eps,isneigh(j));%,near,cs(near,:));
        if(skip==1)
            bads=[bads j];
            break;
        elseif(redo==0)
            Cents(j,:)=pts(1,:);
            EndPt(j,:)=pts(2,:);
%             if(~isneigh(j))
                fra=[fra j];
                b4=find(frs<inds(j),1,'last');
                if(isempty(b4))
                    frs=[inds(j) frs];
                    cs=[Cents(j,:); cs];
                    eps=[EndPt(j,:); eps];
                else
                    frs=[frs(1:b4) inds(j) frs((b4+1):end)];
                    cs=[cs(1:b4,:); Cents(j,:); cs((b4+1):end,:)];
                    eps=[eps(1:b4,:); EndPt(j,:); eps((b4+1):end,:)];
                end
                % this bit was to do something with neighbouring bees and
                % doesn't work
%             else
%                 frn=find(frs==inds(j));
%                 cout(frn,:)=Cents(j,:);
%                 epout(frn,:)=EndPt(j,:);
%                 d=EndPt(j,:)-Cents(j,:);
%                 [os(frn),len(frn)]=cart2pol(d(:,1),d(:,2));
% %             end
            if(uns)
                unsure = [unsure j];
            end
            break;
        end
    end
end
d=EndPt-Cents;
[NewOs,lens]=cart2pol(d(:,1),d(:,2));
% for i=1:length(fra)
%     dat(i).fr=inds(i);
%     dat(i).cs=Cents(i,:);
%     dat(i).cs=Cents(i,:);
% end
dat.or=NewOs(fra);
dat.len=lens(fra);
dat.fr=inds(fra);
dat.cs=Cents(fra,:);
dat.ep=EndPt(fra,:);


function[pts,redo,skip,unsure]=AdjustPts(pts,im,fr,TStr,unsure,ib4,iaft,...
    cs,es,isneigh)%,near,cn)
redo=0;
skip=0;
bwid=75;

% this specifies default point to start adjusting: 1 = centre, 2 = end
adp=2;
ptstr='head';
% ptstr='body';
while(1)
    imagesc(im);
    axis equal
    a1=pts(1,:)-bwid;
    a2=pts(1,:)+bwid;
    X=[a1(1) a2(1) a1(2) a2(2)];
    axis(X), hold on;
    if(~isempty(ib4))
        plot([cs(ib4,1) es(ib4,1)]',[cs(ib4,2) es(ib4,2)]','b',cs(ib4,1),cs(ib4,2),'b.')
    end
    if(~isempty(iaft))
        plot([cs(iaft,1) es(iaft,1)]',[cs(iaft,2) es(iaft,2)]','w',cs(iaft,1),cs(iaft,2),'w.')

%         plot(cs(ib4,1),cs(ib4,2),'r.-',cs(iaft,1),cs(iaft,2),...
%             'w.-',cs(tr(end),1),cs(tr(end),2),'wo')%,tr(1:end-1,1),tr(1:end-1,2),'bo') 
%         if(near<fr)
%             plot(cn(1),cn(2),'rs')
%         else
%             plot(cn(1),cn(2),'yd')
%         end
    end;
    plot(pts(:,1),pts(:,2),'g',pts(1,1),pts(1,2),'g.')
    hold off

    title([TStr ': n no bee; click 2 move ' ptstr ' (green); c adjust other end'])
    xlabel('return end; u unsure,  a change axis, r re-do, ')
    if(isneigh)
        yss=' ; NEIGHBOUR';
    else
        yss='';
    end
    if(unsure) 
        ystr=['UNSURE' yss];
    else
        ystr=['BLUE before, WHITE after; ' yss];
    end
    ylabel(['Frame ' int2str(fr) '; ' ystr])
    [p,q,b]=ginput(1);
    if(char(b)=='c')
        if(adp==1) 
            adp=2;
            ptstr='head';
        else
            adp=1;
            ptstr='body';
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
    elseif(char(b)=='n')
        skip=1;
        break;
    elseif(isempty(p)) 
        break;
    elseif(char(b)=='u') 
        unsure=mod(unsure+1,2);        
    else
%         vs=pts-ones(length(pts),1)*[p,q];
%         ds=sum(vs.^2,2);
%         [mini_d,i_m]=min(ds);
%         pts(i_m,:)=[p q];

        % only doing the head
        pts(adp,:)=[p q];
    end
end