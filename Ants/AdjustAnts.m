% function TrackAnts_Steven(fn,nums,Check)
%
% function whihc tracks ants in file fn.
%
% It has 3 optional parameters. nums is a vector containgin the frames
% whihc are to be processes. Default is all frames.
%
% Setting Check to be other than 0 (the default) will plot the ant position
% as it processes it and waits for return to be pressed. Good for debugging.

function AdjustAnts(fn,nums,Check)

% set up output file
k=strfind(fn,'.avi');

% get the number of frames and set defaults if undefined
info=aviinfo(fn);
NumFrames=info.NumFrames;

for i=1:NumFrames
    AntPts(i).Bodies=[];
    AntPts(i).Heads=[];
    NAnts(i)=0;
end
% default frame nums
if(nargin<2) nums=1:NumFrames; end;
% default Check is off
if(nargin<3) Check=0; end;

sfn=[fn(1:k-1) '_Prog' int2str(nums(1)) '_' int2str(nums(end)) '.mat']
refim=MyAviRead(fn,1,1);
load(sfn);

%Pick start point
subplot(1,2,1)
plot(FrameNum,NumAnts)
while 1
    s=input('enter start point; return to end:   ')
    if(isempty(s)) break; end;
    sp=s;
    subplot(1,2,2)
    fst=MyAviRead(fn,sp,1);  
    imagesc(fst)
end
oldax=[];
% Initialise points
outfn=[fn(1:k-1) '_Adj' int2str(nums(1)) '_' int2str(nums(end)) 'Sp' int2str(sp) '.mat']
if(isfile(outfn)) load(outfn); 
    bpts=AntPts(sp).Bodies;
    hpts=AntPts(sp).Heads;
else
    [bpts,hpts,oldax]=SelectPtsAnt(fst,[],[],oldax);
    AntPts(sp).Bodies=bpts;
    AntPts(sp).Heads=hpts;
end
Init=0;
fold=fst;
NAnts(FrameNum)=NumAnts;

% forward pass
AntPts=CorrelatePoints(bpts,hpts,oldax,fold,Init,1,outfn,AntPts,nums,sp,NAnts,sfn,fn,Check);
% backward pass
AntPts=CorrelatePoints(bpts,hpts,oldax,fold,Init,-1,outfn,AntPts,nums,sp,NAnts,sfn,fn,Check);

function[AntPts]=CorrelatePoints(bpts,hpts,oldax,fold,Init,inc,outfn,...
    AntPts,nums,sp,NAnts,sfn,fn,Check);

load(sfn)
if(isfile(outfn)) load(outfn); end

if(inc<0) numend=nums(1)+inc;
else numend=nums(end)+inc;
end
num=sp+inc;
while(num~=numend)

    % read in frame num: you may get an error here, so you may have to use
    % functions from PsychToolBox
    f=MyAviRead(fn,num,1);    
    n=NAnts(num);
    [num n]    
    if(n>0)
        if(Init)
            [bpts,hpts,oldax]=SelectPtsAnt(f,[],[],oldax);
            Init=0;
            fold=f;
        else
            if(~isempty(AntPts(num).Bodies))
                bpts=AntPts(num).Bodies;
                hpts=AntPts(num).Heads;
            else
                bpts=double(cpcorr(bpts,bpts,f,fold));
                hpts=double(cpcorr(hpts,hpts,f,fold));
            end
            if(Check)
%                 [bpts,hpts]=SelectPtsAnt(f,newpts([1 2],:),newpts([3 4],:));
                fif=stdfilt(f);
                [bpts,hpts,oldax] = GetBPts(f,fif,100,bpts,hpts);
            end
        end
        fold=f;
        if(isempty(bpts)) Init=1;
        else
            AntPts(num).Bodies=bpts;
            AntPts(num).Heads=hpts;
            num=num+inc;
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
%     if(mod(num,1)==1)
        save(outfn,'FrameNum','MeanCol', 'WhichB', ...
            'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','ang_e','len_e','eccent','AntPts','NAnts','sp');
%     end
end

save(outfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','ang_e','len_e','eccent','AntPts','NAnts','sp');

function[bpts,hpts,ax]=SelectPtsAnt(f,bpts,hpts,oldax)

fif=stdfilt(f);
subplot(1,2,2), imagesc(fif), axis image
subplot(1,2,1), imagesc(f); axis image
if((nargin==4)&(~isempty(oldax))) axis(oldax); end;
[bpts,hpts,ax]=GetBPts(f,fif,100,bpts,hpts);
if(isempty(bpts))
    hpts=[];
    return;
end

function[bpts,hpts,ax] = GetBPts(f,fif,wid,bpts,hpts)

[my,mx]=size(f);
if(isempty(bpts))
    title('select body points')
    [x,y,b]=ginput;
    x=min(max(x,1),mx);
    y=min(max(y,1),my);
    bpts=([x y]);
end
if(isempty(hpts))
    title('select head points')
    [x,y,b]=ginput;
    x=min(max(x,1),mx);
    y=min(max(y,1),my);
    hpts=([x y]);
end
lb=size(bpts,1);
while 1
    pts=[bpts;hpts];
    m=round(mean(pts));
    subplot(1,2,2),
    ax=plotBits(fif,m,wid,bpts,hpts);
    subplot(1,2,1),
    ax=plotBits(f,m,wid,bpts,hpts);
    [i_m,b,p,q] = GetNearestClickedPt(pts,'Click near any point to move; return to end');%; c to re-init');
    if(i_m==0) break;
%     elseif(isequal(char(b),'c'))
%         pts=[];
%         break;
    else
        p=min(max(p,1),mx);
        q=min(max(q,1),my);
        pts(i_m,:)=[p,q];
    end;
    bpts=pts(1:lb,:);
    hpts=pts(lb+1:end,:);
end
    
function[ax]=plotBits(fif,m,wid,pts,pts2);
imagesc(fif),
hold on;
plot(pts(:,1),pts(:,2),'w-x','LineWidth',2)
if(~isempty(pts2)) plot(pts2(:,1),pts2(:,2),'k-x','LineWidth',2); end
hold off
axis image,
ax=[m(1)-wid m(1)+wid m(2)-wid m(2)+wid];
axis(ax)
