% function TrackAnts_Steven(fn,nums,t,Check)
%
% function whihc tracks ants in file fn.
%
% It has 3 optional parameters. nums is a vector containgin the frames
% whihc are to be processes. Default is all frames.
%
% t is the threshold ant colour.
% It defaults to 10 (CHANGE THIS AFTER EXPERIMENTING
%
% Setting Check to be other than 0 (the default) will plot the ant position
% as it processes it and waits for return to be pressed. Good for debugging.

function TrackAnts(fn,nums,Check,t)

% set up output file
k=strfind(fn,'.avi');

% set up variables
Areas=[];NumAnts=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];
area_e=[];EPt=[];elips=[];ang_e=[];len_e=[];eccent=[];

Bodies=[];Heads=[];
% initialising some params
MaxBInd=0;
% max distance (in pixels) that an ant can move between frames. Used for
% matching across frames
MaxD=30;
picwid=25;

% get the number of frames and set defaults if undefined
info=aviinfo(fn);
NumFrames=info.NumFrames;

% default frame nums
if(nargin<2) nums=1:NumFrames; end;
% default ant threshold
if(nargin<4) t=150; end;
% default Check is off
if(nargin<3) Check=0; end;

sfn=[fn(1:k-1) '_Prog' int2str(nums(1)) '_' int2str(nums(end)) '.mat']
refim=MyAviRead(fn,1,1);
Init=1;

% load(sfn);

% for every frame
num=nums(1);
while(num<=nums(end))

    % read in frame num: you may get an error here, so you may have to use
    % functions from PsychToolBox
    f=MyAviRead(fn,num,1);
    %     f=f.cdata;
    %
    %     % Process that frame for the ant

    [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc]= FindAnt(f,t);
    if(isempty(WhichB)) MaxBInd=0;
    else MaxBInd=max(WhichB);
    end

    % Match the new ants with old ant positions
    t=GetSecs;
    [BPos,BInds,w] = MatchAntsToPos(BPos,c,MaxD,BInds,MaxBInd);
    GetSecs-t
    % update the variables
    NumAnts=[NumAnts n];
    Bounds=[Bounds; b];
    Areas=[Areas a];
    Cents=[Cents; c];
    Orients=[Orients o];
    EndPt=[EndPt;e];
    MeanCol=[MeanCol md];
    WhichB=[WhichB w];
    elips=[elips ell];
    area_e=[area_e ae];
    ang_e=[ang_e oe];
    EPt=[EPt;ee];
    len_e=[len_e len];
    NLess=[NLess nlss];
    eccent=[eccent ecc];
    for j=1:n  
        FrameNum=[FrameNum num]; 
    end

    [num n]    
    if(n>0)
        if(Init)
            if(exist('oldax')) [bpts,hpts]=SelectPtsAnt(f,[],[],oldax);
            else [bpts,hpts]=SelectPtsAnt(f,[],[]);
            end
            Init=0;
            fold=f;
        else
            newpts=double(cpcorr([bpts;hpts],[bpts;hpts],f,fold));
            if(Check)
%                 [bpts,hpts]=SelectPtsAnt(f,newpts([1 2],:),newpts([3 4],:));
fif=stdfilt(f);
                [newpts,oldax] = GetBPts(f,fif,100,newpts);
            end
            if(isempty(newpts))
                bpts=[];
                hpts=[];
            else
            bpts=newpts([1 2],:);
            hpts=newpts([3 4],:);
            end
        end
        fold=f;
        if(isempty(bpts)) Init=1;
        else
            num=num+1;
            Bodies=[Bodies;bpts(1,:) bpts(2,:)];
            Heads=[Heads;hpts(1,:) hpts(2,:)];
        end
        % plot each ant if chcek is 1
        if(~Check)
            wid=100;
            imagesc(f)
            m=round(mean(bpts));
            hold on;
            plot(bpts(:,1),bpts(:,2),'w-x','LineWidth',2)
            plot(hpts(:,1),hpts(:,2),'k-x','LineWidth',2)
            hold off
            axis image,
            axis([m(1)-wid m(1)+wid m(2)-wid m(2)+wid])
            drawnow
        end
    else num=num+1;
    end

    % save the data every 10 steps:
    % Increase this if this slows the program too much
    % NB USE tic and toc, or the profiler to check time to save
    if(mod(num,1)==1)
        save(sfn,'FrameNum','MeanCol', 'WhichB', ...
            'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','ang_e','len_e','eccent');
    end
end

save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','ang_e','len_e','eccent');

function[bpts,hpts]=SelectPtsAnt(f,bpts,hpts,oldax)

fif=stdfilt(f);

subplot(1,2,2), imagesc(fif), axis image
subplot(1,2,1), imagesc(f); axis image
title('select body points')
if(nargin==4) axis(oldax); end
bpts=GetBPts(f,fif,100,bpts);
if(isempty(bpts))
    hpts=[];
    return;
end
title('select head points')
hpts=GetBPts(f,fif,50,hpts);
if(isempty(hpts)) bpts=[]; end


function[pts,ax] = GetBPts(f,fif,wid,pts)

[my,mx]=size(f);
if(isempty(pts))
    [x,y,b]=ginput(2);
    x=min(max(x,1),mx);
    y=min(max(y,1),my);
    pts=([x y]);
end
while 1
    m=round(mean(pts));
    subplot(1,2,2),
    ax=plotBits(fif,m,wid,pts);
    subplot(1,2,1),
    ax=plotBits(f,m,wid,pts);
    [i_m,b,p,q] = GetNearestClickedPt(pts,'Click near any point to move; return to end; c to re-init');
    if(i_m==0) break;
    elseif(isequal(char(b),'c'))
        pts=[];
        break;
    else
        p=min(max(p,1),mx);
        q=min(max(q,1),my);
        pts(i_m,:)=[p,q];
    end;
end
    
function[ax]=plotBits(fif,m,wid,pts);
imagesc(fif),
hold on;
plot(pts([1 2],1),pts([1 2],2),'w-x','LineWidth',2)
if(size(pts,1)>2) plot(pts([3 4],1),pts([3 4],2),'k-x','LineWidth',2); end
hold off
axis image,
ax=[m(1)-wid m(1)+wid m(2)-wid m(2)+wid];
axis(ax)
