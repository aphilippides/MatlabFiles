% function TrackBeeHand(fn)
% function TrackBeeHand(fn,nums)
% function TrackBeeHand(fn,nums,OneClick)
%
% Function to track bee orientations by hand from avi file fn
% enter nums to say which frames to track, default does all of them
%
% click on the bottom then the head of the bee
% right click to show unsureness. Ctrl C to stop when bored
%
% After points selected, result is shown.
% Left click if ok, right click to re-do
%
% Set OneClick=1 if you only want to click head of the bee (program then
% connects the centre of bee to head). Natalie reports this is
% less accurate than doing 2 clicks
%
% NOTES: change how much of the image is shown by changing 'bsize'
% BUG: when more than one bee found, need to ensure same bee selected

function TrackBeeHand_Expt2(fn,nums,OneClick)

% dwork; cd ../

fi=aviinfo(fn);
NumFrames=fi.NumFrames
wid=fi.Width;ht=fi.Height;
if(nargin<2) nums=1:NumFrames; end;
if(nargin<3) OneClick=0; end;
if(OneClick) sfn=[fn(1:end-4) '1ClickHandData.mat'];
else sfn=[fn(1:end-4) 'HandData.mat'];
end

Areas=[];NumBees=[];Cents=[];Orients=[];Eccent=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];
EndsEntered=[];TipsEntered=[];Button=[];
FrameEntered=[];iEntered=[];

MaxBInd=0;
MaxD=20

refim=aviread(fn,NumFrames);
doubling=1;HandData=1;
bsize=40;

for num=nums
    num
    f=aviread(fn,num);
    dif=imsubtract(refim.cdata,f.cdata);
    if(doubling)
        for i=[2 1]
            % [a,c,o,s,e,n,b]=FindBeeIndoor(dif(i:2:end,i:2:end,:),f.cdata);
            [a,c,o,s,e,n,b]=FindBeeExpt2(dif(i:2:end,:,:),f.cdata);
            eo=e; co=c;
            if(~isempty(c))
                c(:,2)=c(:,2)*2;
                e(:,2)=e(:,2)*2;
                if(i==1)
                    c(:,2)=c(:,2)-1;
                    e(:,2)=e(:,2)-1;
                end
            end
            if(isempty(WhichB)) MaxBInd=0;
            else MaxBInd=max(WhichB);
            end
            [BPos,BInds,w,unused] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
            NumBees=[NumBees n];
            Bounds=[Bounds; b];
            Areas=[Areas a];
            Cents=[Cents; c];
            Orients=[Orients o];
            EndPt=[EndPt;e];
            Eccent=[Eccent s];
            WhichB=[WhichB w];
            if(isempty(c))
                imagesc(f.cdata)
                title('No Bee?')
            else
                for j=1:n
                    FrameNum=[FrameNum 2*num+1-i];
                    if(HandData)
                        im=f.cdata;
                        im=im(i:2:end,:,:);
%                         if(i==2) im(1:2:end,:,:)=255;
%                         else im(0:2:end,:,:)=255;
%                         end
                        AxL=[c(1)-bsize c(1)+bsize [c(2)-bsize c(2)+bsize]*0.5];
                        xlabel(['Frame ' int2str(num) ' out of ' int2str(NumFrames)])
                        [pts,redo,skip]=AdjustPts([eo(j,:); co(j,:)],im,AxL)
                        if(skip) break;
                        elseif(redo==0)
                            EndsEntered=[EndsEntered; pts(2,:)];
                            TipsEntered=[TipsEntered; pts(1,:)];
                            FrameEntered=[FrameEntered 2*num+1-i];
                            iEntered=[iEntered size(Cents,1)-n+1];
                        end
                    end
                end
            end
        end

        save(sfn,'EndsEntered','Button','TipsEntered','FrameEntered',...
            'iEntered','FrameNum','Eccent', 'WhichB', 'Areas','NumBees', ...
            'Cents','Orients','EndPt','Bounds');
    end
end

ds=TipsEntered-EndsEntered;
os=cart2pol(ds(:,1),ds(:,2));

save(sfn,'EndsEntered','Button','TipsEntered','os','FrameEntered',...
    'iEntered','FrameNum','Eccent', 'WhichB', 'Areas','NumBees', ...
    'Cents','Orients','EndPt','Bounds');

figure;
subplot(1,2,1)
plot(os)
hold
plot(Orients,'r')
subplot(1,2,2)
plot(abs(os'-Orients))

function[endh,tiph,but] = GetHandData(im,bbox,wid,ht,cent,tip)

% Change the bsize to get a bigger pic
bsize=40;
[x1,x2,y1,y2]=SetBigBBox(bbox,bsize,bsize,wid,ht);
imagesc(im);
axis([x1 x2 y1 y2])
title('Click bottom then head. Right-click if unsure');
axis square
hold on;

% Plot centres
plot(cent(:,1),cent(:,2),'r.')
l=-e+2*c;
plot([l(j,1) e(j,1)]',[l(j,2) e(j,2)]','g')
hold off;
axis([x1,x2,y1,y2])
[p,q,but]=ginput(2);
endh=[p(1) q(1)];
tiph=[p(2) q(2)];

function[pts,redo,skip]=AdjustPts(pts,im,X)
redo=0;
skip=0;
while(1)
    imagesc(im);
    axis equal
    axis(X), hold on;
    plot(pts(:,1),pts(:,2),'g-',pts(2,1),pts(2,2),'go')
    hold off

    title('Click near any point to adjust')
    xlabel('Return to finish, r to re-do all, s to skip;')
    [p,q,b]=ginput(1);
    if(char(b)=='r')
        redo=1;
        break;
    elseif(char(b)=='s')
        skip=1;
        break;
    elseif(isempty(p)) break;
    else
        vs=pts-ones(length(pts),1)*[p,q];
        ds=sum(vs.^2,2);
        [mini_d,i_m]=min(ds);
        pts(i_m,:)=[p q];
    end
end

function[cent,tip,but] = GetHandData1click(im,bbox,wid,ht,cent,tip)

% Change  bsize to get a bigger pic
bsize=50;
[x1,x2,y1,y2]=SetBigBBox(bbox,bsize,bsize,wid,ht);
imagesc(im);
title('Click head only. Right-click if unsure');
axis square
hold on;

% Plot centres
plot([cent(:,1) tip(:,1)],[cent(:,2) tip(:,2)],'r')
plot(tip(:,1),tip(:,2),'r.')
hold off;
axis([x1,x2,y1,y2])
[p,q,but]=ginput(1);
if(~isempty(p)) tip = [p,q]; end;