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

function TrackAnts_Steven(fn,nums,t,Check)

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
if(nargin<3) t=50; end;
% default Check is off
if(nargin<4) Check=0; end;

sfn=[fn(1:k-1) '_Prog' int2str(nums(1)) '_' int2str(nums(end)) '.mat']

% for every frame
for num=nums

    % read in frame num: you may get an error here, so you may have to use
    % functions from PsychToolBox
    f=aviread(fn,num);
    f=f.cdata;

    % Process that frame for the ant
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

    % plot each ant if chcek is 1
    if(Check)
        figure(1)
        imagesc(f)
        title(['Frame Num = ' int2str(num) ';    num bees = ' num2str(n)])
        hold on,

        % NB for bees blue line was more accurate than red for heading.
        % Here probably doesn't matter but is just for checking
        for j=1:n
            PlotAnt(c(j,:),ee(j,:),[],'b')
            PlotAnt(c(j,:),e(j,:),[],'r')
            plot(ell(j).elips(:,1),ell(j).elips(:,2),'g')
        end
        hold off
        input('press return to continue');
    end

    % save the data every 10 steps:
    % Increase this if this slows the program too much
    % NB USE tic and toc, or the profiler to check time to save
    if(mod(num,10)==1)
        save(sfn,'FrameNum','MeanCol', 'WhichB', ...
            'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','ang_e','len_e','eccent');
    end
    [num n]
end

save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumAnts','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','ang_e','len_e','eccent');

% function to plot an ant. Fairly self-explanatory
% change deafiult plotwid (4 lines down) for a bigger pic
function PlotAnt(c,e,plotwid,col)
if(nargin<3) col='b';
elseif(ischar(plotwid))
    col=plotwid;
    % sets default size of image
    plotwid=25;
elseif(nargin<4) col='r';
end;

plot([c(:,1) e(:,1)]',[c(:,2) e(:,2)]',[col '-'],...
    e(:,1),e(:,2),[col '.'])
axis equal
if(nargin>=3)
    if(~isempty(plotwid))
        axis([c(1)-plotwid  c(1)+plotwid c(2)-plotwid c(2)+plotwid])
    end
end;