function GetMaskChoice(fn,vobj,lmfn,fignum)
if(nargin<4)
    fignum=2;
end

% define theshold, area of 'noisy' objects and number of mazes
maskthresh=170;
masksmall=1e4;

% set the number of mazes
nMaze=4;

% set the number of arms of each maze
NumArms=3;

% which frame to use for threshold
maskfr=1;

% read in that frame
refim_im=MyAviRead(fn,maskfr,vobj);

% threshold the image and fill in any 'holes in the objects 
thr=imfill((rgb2gray(refim_im)>170),'holes');

% remove any objects < masksmall in area
mask=uint8(bwareaopen(thr,masksmall,8));

% get all the objects
[L,N] = bwlabeln(mask, 8);
S = regionprops(L,'Area','Centroid');

% sort them in descending order of size and pick out the biggest nMaze of
% them
[ar,is]=sort([S.Area],'descend');
goodIs=is(1:nMaze);

% make a new mask which is only the nMaze biggest objects
mazemask=ismember(L,goodIs);

% get the centroids of the objects and the x/y-coordinates for sorting
S = regionprops(mazemask,'Centroid');
c=[S.Centroid];
x=c(1:2:end);
y=c(2:2:end);

% sort the x-coordinates of the biggest nMaze from left to right of image
[xs,is]=sort(x);

% reorder the indices of the nMaze biggest and the centroids
% so they are from left to right
MazeCent=[x(is)' y(is)'];

% make a new mask which has the objects labelled from 1 to nMaze where 1 is
% the object with the lowest y-value and nMaze is the one with the highest
objmask=zeros(size(mask));
for i=1:nMaze
    objmask=objmask+double(i*(L==is(i)));
end

% get the boundaries of the masks
B=bwboundaries(mazemask);

% now plot everything to check
if 0
    figure(1); clf;
    subplot(2,2,1)
    imagesc(refim_im)
    title('original')
    
    subplot(2,2,2)
    imagesc(mask)
    title(['mask: threshold ' int2str(maskthresh) '; objects > ' int2str(masksmall)])
    
    subplot(2,2,3)
    imagesc(objmask)
    title('objects marked')
end

figure(fignum); clf;
imagesc(refim_im)
hold on
for i=1:nMaze
    % get boundary from the srtucture. 
    boundary= B{i};
    % It returns data as row-column so need to swap x and y
    boundary=boundary(:,[2 1]);
    
    % get the ends of the arms
    [ArmEnds,ArmAngs]=FindMazeArmAngles(boundary,MazeCent(i,:),NumArms);
    
    % now plot
    set(gca,'FontSize',12);
    plot(boundary(:,1), boundary(:,2),'r','LineWidth',1);
    for j=1:size(ArmEnds,1)
        plot([MazeCent(i,1) ArmEnds(j,1)],[MazeCent(i,2) ArmEnds(j,2)],'k-x')
        text(ArmEnds(j,1),ArmEnds(j,2),['Arm ' int2str(j)],'Color','g')
    end
    text(MazeCent(i,1),MazeCent(i,2),['Maze ' int2str(i)],'Color','r')
    
    % check we have enough arms
    if(size(ArmEnds,1)<NumArms)
        disp('problem with getting arms')
        disp('will need to write code to adjust this')
    end
    Maze(i).cent=MazeCent(i,:);
    Maze(i).ArmEnds=ArmEnds;
    Maze(i).ArmAngs=ArmAngs;
end
hold off
title('original with objects')
inp=1;%input('Enter 1 if ok: ');

if(isequal(inp,1))
    save(lmfn,'boundary','maskthresh','Maze','MazeCent',...
        'masksmall','nMaze','maskfr','objmask','mazemask');
end

function[ArmEnds,ArmAngs]=FindMazeArmAngles(boundary,MaskC,NumArms)
% get boundary relative to the mask centre
boundc=[boundary(:,1)-MaskC(1) boundary(:,2)-MaskC(2)];

% get distances to the centre of the maze
dtob=CartDist(boundc);

% start the distances from a minimum (in case one of the arms crosses from
% one side of dtob to the other 
[m,i]=min(dtob);
dtob=dtob([i:end 1:i-1]);

% define how much to smooth the distances and smooth them
sm_len=51;
smd=SmoothVec(dtob,sm_len);

% get the peaks of the smoothed traces. These should be the ends of the
% arms
ma=round(findextrema(smd));

% in case there are any spurious ones, get the 3 biggest
mav=smd(ma);
[s,is]=sort(mav,'descend');
if(length(ma)<NumArms)
    disp('problem with getting arms')
else
    ma=ma(is(1:NumArms));
end
% Now get the x-y positions of the ends and angles relative to matlab axes
bs=boundc([i:end 1:i-1],:); 
ArmEnds=bs(ma,:);
ArmAngs=mod(cart2pol(ArmEnds(:,1),ArmEnds(:,2)),2*pi);

% now sort the ends and angles so we start with the 
% one closest to 0 ie the x-axis and going CW
[s,is]=sort(ArmAngs);
ArmAngs=s;
ArmEnds=ArmEnds(is,:);

% re-centre
ArmEnds=[ArmEnds(:,1)+MaskC(1) ArmEnds(:,2)+MaskC(2)];