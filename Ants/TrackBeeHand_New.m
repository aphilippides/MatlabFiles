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

function TrackBeeHand(fn,nums,OneClick)

dwork;
% % cd GantryProj\Bees
cd ../
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
cplot=[];eplot=[];

MaxBInd=0;
MaxD=20

refim=aviread(fn,1);
doubling=1;HandData=0;
SquareAx;
bsize=40;

for num=nums
    num
    f=aviread(fn,num);
    dif=imsubtract(refim.cdata,f.cdata);
%     figure(1),imagesc(f.cdata);
% % [x1,x2,y1,y2]=SetBigBBox([720 730 500 510],bsize,bsize,wid,ht);
% axis([500 900 300 800]),axis square
%     figure(2),imagesc(dif)
% % [x1,x2,y1,y2]=SetBigBBox([720 730 500 510],bsize,bsize,wid,ht);
% axis([500 900 300 800]),axis square
if(doubling)
        for i=[2 1]
            % [a,c,o,s,e,n,b]=FindBeeIndoor(dif(i:2:end,i:2:end,:),f.cdata);
            [a,c,o,s,e,n,b]=FindBee(dif(i:2:end,i:2:end,:),f.cdata);
            c=c*2;
            e=e*2;
            if(i==1)
                c=c-1;
                e=e-1;
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
            for j=1:n
                FrameNum=[FrameNum 2*num+1-i];
                if(HandData)
                    redo=2;
                    while(redo~=1)
                        im=f.cdata;
                        cplot=[cplot;c(j,:)];
                        [endh,tiph,but] = GetHandData1click(im,b(j,:)*2,wid,ht,c,e);
                        xlabel(['Frame ' int2str(num) ' out of ' int2str(NumFrames)])
                        hold on
                        plot([endh(1) tiph(1)],[endh(2) tiph(2)],'g')
                        plot(tiph(1),tiph(2),'g.')
                        hold off
                        title('left click/return if ok. Right-click to re-do');
                        [d,d,redo]=ginput(1);
                    end
                    EndsEntered=[EndsEntered; endh];
                    TipsEntered=[TipsEntered; tiph];
%                     Button=[Button but(end)];
                    FrameEntered=[FrameEntered 2*num+1-i];
                    iEntered=[iEntered size(Cents,1)-n+1];                    
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
% axis([2*x1,2*x2,y1,y2])
axis([x1,x2,y1,y2])
[p,q,but]=ginput(2);
endh=[p(1) q(1)];
tiph=[p(2) q(2)];

function[cent,tip,but] = GetHandData1click(im,bbox,wid,ht,cent,tip)

% Change the bsize to get a bigger pic
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

function SquareAx(fhdl,n)

if(nargin<1) fhdl = gcf; end;
if(nargin<2) SquareF = 1; end;
if(nargin<3) n=0.8; end;

X=get(gcf,'Position');
if(X(3)<X(4))
    if(SquareF)
        X(4)=X(3);
        set(gcf,'Position',X);
    end
    nval=n*X(3)/X(4);
    set(gca,'Position',[0.1 0.1 n nval]);
else
    if(SquareF)
        X(3)=X(4);
        set(gcf,'Position',X);
    end
    set(gcf,'Position',X);
    nval=n*X(4)/X(3);
    set(gca,'Position',[0.1 0.1 nval n]);
end