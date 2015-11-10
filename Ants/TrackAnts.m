% function TrackAnts_Steven(fn,nums,Check,t)
%
% function whihc tracks ants in file fn.
%
% It has 3 optional parameters. nums is a vector containgin the frames
% whihc are to be processes. Default is all frames.
%
% Setting Check to be other than 0 (the default) will plot the ant position
% as it processes it and waits for return to be pressed. Good for debugging.
%
% t is the threshold ant colour.
% It defaults to 150 (CHANGE THIS AFTER EXPERIMENTING

function TrackAnts(fn,nums,Check,t)

% set up output file
k=strfind(fn,'.avi');

% set up variables
Areas=[];NumAnts=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];
area_e=[];EPt=[];elips=[];ang_e=[];len_e=[];eccent=[];

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
    [BPos,BInds,w] = MatchAntsToPos(BPos,c,MaxD,BInds,MaxBInd);
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
    for j=1:n  FrameNum=[FrameNum num]; end

    [num n]    
    if(n>0)
        % plot each ant if chcek is 1
        if(Check)
            wid=100;
            imagesc(f)
            m=round(mean(c,1));
%             hold on;
%             plot(bpts(:,1),bpts(:,2),'w-x','LineWidth',2)
%             plot(hpts(:,1),hpts(:,2),'k-x','LineWidth',2)
%             hold off
            axis image,
            axis([m(1)-wid m(1)+wid m(2)-wid m(2)+wid])
            drawnow
        end
    end
    num=num+1;
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
