% function[NewOs,Cents,len,skip,bad,uns] = ...
%     AdjustOrientsExpt2(Orients,Cents,lens,FrameNum,fn,vObj,TStr,trac,uns,mp,bad)
%
% Orients is the current angle of the frame (in radians)
% Cents is the (x,y) position of the centroid (in pixels)
% lens is the length from centroid to 'head' in pixels
% FramNum is the number of the frame. Because some of the data is in half
% frames, for frame 1 of the video, I needed to have FrameNum= 1 and 2
% essentially, FrameNum=frame*2-1 + 0/1 depednign if I'm doing odd or even
% 
% For a full frame, just do  FrameNum=frame*2-1. This then gets changed
% back at line 38: fr=floor((FrameNum+1)/2);
%
% fn is the name of the video file
% vObj is the VideoReader object
% you need all of these
%
% the rest are optional and have defaults
%
% TStr is some string for the title use (default empty)
% trac are the centroids of preceding and following frames (default empty):
% uns is whether the frame is marked as unsure or not (default 0)
% mp is the bee from which the traces is white, before this the trace is
% blue
% bad is binary whether it's a frame is bad. 

function[NewOs,Cents,len,skip,bad,uns] = ...
    AdjustOrientsExpt2(Orients,Cents,lens,FrameNum,fn,vObj,TStr,trac,uns,mp,bad)
if(nargin<7) TStr=[]; end
if(nargin<8) trac=[]; end
if(nargin<9) uns=0; end
if(nargin<10) mp=[]; end
if(nargin<11) bad=0; end

[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,lens);
EndPt=EndPt+Cents;
% for k=1:length(FrameNum)

fr=floor((FrameNum+1)/2);
im=MyAviRead(fn,fr,vObj);

i=mod(FrameNum,2)+1;
% im=im(i:2:end,:,:);
title(['frame ' int2str(FrameNum) ])
while(1)
    [pts,redo,skip,uns,bad]=AdjustPts([Cents;EndPt],im,FrameNum,...
        TStr,uns,trac,mp,bad);
    if(redo==0)
        Cents=pts(1,:);
        EndPt=pts(2,:);
        break;
    end
end
% end
d=EndPt-Cents;
[NewOs,len]=cart2pol(d(:,1),d(:,2));

function[pts,redo,skip,uns,bad]=AdjustPts(pts,im,fr,TStr,uns,tr,mp,bad)
redo=0;
skip=0;
bwid=50;
adp=2;
cstr='move body instead';
astr='head';
while(1)
    imagesc(im);
    axis square
    a1=pts(1,:)-bwid;
    a2=pts(1,:)+bwid;
    X=[a1(1) a2(1) a1(2) a2(2)];
    axis(X), hold on;
    if(~isempty(tr)) 
        if(isempty(mp)||(size(tr,1)<2))
        plot(tr(:,1),tr(:,2),'b:',tr(2:end,1),tr(2:end,2),'bo')%,tr(1:end-1,1),tr(1:end-1,2),'bo') 
        else
        plot(tr(1:mp,1),tr(1:mp,2),'b:',tr(2:mp,1),tr(2:mp,2),'bo'...
            ,tr(mp:end,1),tr(mp:end,2),'w:',tr(mp:end,1),tr(mp:end,2),'wo')%,tr(1:end-1,1),tr(1:end-1,2),'bo') 
        end
    end;
    plot(pts(:,1),pts(:,2),'g',pts(1,1),pts(1,2),'g.')
    hold off

    if(uns)
        ystr='UNSURE';
    else
        ystr=[''];
    end
    if(bad==1)
        TStr2='FRAME TO BE REMOVED';
    else
        TStr2=TStr;
    end
    title([TStr2 ': click to move ' astr ', Return done,  u unsure, c ' cstr])
    xlabel('x toggle remove, n next criterion, a change axis, r re-do')
    ylabel(['Fr ' int2str(fr) '; path: Blue->White; ' ystr])
    [p,q,b]=ginput(1);
    if(char(b)=='c')
        if(adp==1) 
            adp=2;
            astr='head';
            cstr='move body instead';
        else adp=1;
            astr='body';
            cstr='move head instead';
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
    elseif(char(b)=='x')
        if(bad==0)
            title('FRAME TO BE REMOVED? y to confirm')
            [dum,dum,resp]=ginput(1);
            if(char(resp)=='y')
                bad=mod(bad+1,2);
            end
        else
%             title('FRAME TO BE UNREMOVED? y to confirm')
            bad=0;
        end
%         skip=1;
%         break;
    elseif(char(b)=='u')
        uns=mod(uns+1,2);
    elseif(char(b)=='n')
        skip=1;
        break;
    elseif(isempty(p)) 
        break;
    else
        % only doing the head
        pts(adp,:)=[p q];
        
        % this to do nearest point
%         vs=pts-ones(length(pts),1)*[p,q];
%         ds=sum(vs.^2,2);
%         [mini_d,i_m]=min(ds);
%         pts(i_m,:)=[p q];
    end
end