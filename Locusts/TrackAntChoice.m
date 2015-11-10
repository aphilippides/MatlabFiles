% There are two main changes to TrackBeeExpt2
% First is that line 47 has been changed from
%
%     for i=[2 1]
% to:
%
%     for i=[1 2]
%
% as the frame seems to be split the 'correct' way round this time
% also Chnaged line 79: to  FrameNum=[FrameNum 2*num-2+i];
% and changed MaxD to 1200. Might be too big
%
% 2nd thing is to add an input argument which allows you to specify whether
% whole frame or half-frame. This now uses FindBee2012 which, if the odeven
% input argument is -1 does whole frames

function[sfn] = TrackAntChoice(fn,FullFrame,vObj,ThreshV,nums,Check,sm_opt)

% Make Check=1 to have a look at the data. This used to check that 
% threshoilds etc are at the right level
if(nargin<6)
    Check=0;
    sm_opt=0;
end

% Check then sets opt. If opt is not 0, then the outlines of the objects
% found is returned in outl so they cna be plotted
if(Check)
    opt=1;
else
    opt=0;
end

% default is processing half-frames
if(nargin<2)
    FullFrame=1;
end

if(nargin<3)
vObj=[];
end

if(nargin<4) 
    ThreshV=100; 
    sfn=[fn(1:end-4) '_Prog.mat']
elseif((nargin<6)||(sm_opt(1)==0)) 
    sfn=[fn(1:end-4) '_ProgThresh' int2str(ThreshV) '.mat']
else
    sfn=[fn(1:end-4) '_ProgThresh' int2str(ThreshV) 'S' int2str(sm_opt(1)) 'W' x2str(sm_opt(2)) '.mat']
end
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];NumFrs=[];
area_e=[];EPt=[];elips=[];odev=[];ang_e=[];len_e=[];eccent=[];

MaxD=5;
lmn=[fn(1:end-4) 'NestLMData.mat']


% set stuff up for if using half-frames or whole-frames
% including setting the default size to remove big or small objects
if(FullFrame==0)
    disp('*** USING HALF FRAMES ***');
    disp(' ');
    is=[1 2];
    bigsmall=[50 2];
else
    disp('*** USING FULL FRAMES ***');
    disp(' ');
    is=1;
%     bigsmall=bigsmall*2;
    bigsmall=[1e3 30];
end

save(lmn,'bigsmall','-append');

% [vidO,vObj]=VideoReaderType(fn);
% if(vidO)
% %     vObj=VideoReader(fn);
%     NumFrames = get(vObj, 'NumberOfFrames');
% else
% %     vObj=[];
%     [inf,NumFrames]=MyAviInfo(fn);
% end
load(lmn);
% refim_im=MyAviRead(fn,StartEnd(1),vObj);
% orefim_im=MyAviRead(fn,StartEnd(1),vObj);

if(nargin<5) 
    nfr=MyAviInfo(fn);
    nums=1:nfr; 
end;
% BlurIm=zeros(size(refim(:,:,1)));
StartEnd=nums([1 end]);

% next erode the maze mask to avoid pixels at the edge
% base how much to erode on how much smoothing is being done but with a min
% of 1
erodeamount=max(1,ceil(mean(sm_opt)));
mazemask=imerode(mazemask,ones(erodeamount));
for num=nums
    f=MyAviRead(fn,num,vObj);
    
%     % if the frame you're processing is close to on end use that end
%     % could do some smoothing over frames a la CTrax here
%     dtoend=abs(num-StartEnd);
%     if(dtoend(2)<dtoend(1))
%         dif=imsubtract(orefim_im,f);
%     else
%         dif=imsubtract(refim_im,f);
%     end

    % thesholding based on the image only
    dif=f;
    
    for i=is
        if 0%(FullFrame==0)
%             [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,outl]= ...
%                 FindAntChoice(dif(i:2:end,:,:),mod(i,2),f(i:2:end,:,:),ThreshV,bigsmall,maskim,opt);
        else
            % put odeven=-1 to get whole frames; 
            [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,outl]= ...
                FindAntChoice(dif,-1,sm_opt,ThreshV,bigsmall,mazemask,opt);
        end
        if(isempty(WhichB)) 
            MaxBInd=0;
        else
            MaxBInd=max(WhichB);
        end
        [BPos,BInds,w] = MatchAntToPos(BPos,c,MaxD,BInds,MaxBInd);
        NumBees=[NumBees n];
        if(FullFrame)
            % don't do this if there are ones with half frames!!!
            NumFrs=[NumFrs num];
        else
            NumFrs=[NumFrs 2*num-2+i];
        end
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
            
            % if whole-frames then this makes FrameNum=2*num-1 as i=1
            % so num=1, 2, 3 gives FrameNum = 1, 3, 5
            % it is transformed back by fr=floor((FrameNum+1)/2) =
            % so fr=floor(2*num/2) =floor(num) = num
            % 
            % if half-frames we get for num=1, 2 ..., i = 1 then 2 so 
            % gives FrameNum = 2*(num-1) + i so: 1,2, then 3, 4 etc 
            %
            % *** THIS IS NOT NEEDED HERE HENCE THE IF ***
            %
            % NB this is for use with bees where there are flights with 
            % half frames. For ants we can use full frames 
            if(FullFrame) % don't do this if there are ones with half frames!!!             
                FrameNum=[FrameNum num];
            else
                FrameNum=[FrameNum 2*num-2+i];
            end
            odev=[odev mod(i,2)];
        end
        if((n>0)&&Check)
            figure(1)
            imagesc(f)
            title(['Frame Num = ' int2str(num) '; num bees = ' num2str(n)])
            hold on,
            for j=1:n
                PlotBee(c(j,:),e(j,:),'b',100)
                PlotBee(c(j,:),ee(j,:),'r',100)
                plot(ell(j).elips(:,1),ell(j).elips(:,2),'g')
                boundary = outl{j};
                plot(boundary(:,2), boundary(:,1), 'w');
            end
            hold off;
            axis auto
            keyboard
        end

    end
    if(~Check&&(mod(num,100)==1))
        disp([fn ': ' int2str([num n])])
        save(sfn,'FrameNum','MeanCol', 'WhichB','sm_opt', ...
            'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','odev','ang_e','len_e','eccent','ThreshV'...
            ,'objmask','mazemask','StartEnd','bigsmall','FullFrame','NumFrs');
%         keyboard
    end
end

% Uncomment this if majoraxis thing not working
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;

if(~Check)
save(sfn,'FrameNum','MeanCol', 'WhichB','sm_opt', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent','ThreshV'...
    ,'objmask','mazemask','StartEnd','bigsmall','FullFrame','NumFrs');
end

% currently this is a duplicate of MatcheBeesToPos just to have all the
% files in the same place. However I could change it in the future to
% incorporate only having the nearest ant picked
function[NewBPos,NewBInds,WhichB,OldBPos] = MatchAntToPos(BPos,c,MaxD,BInds,MaxBInd)

Cents=c;
nb=size(BPos,1);
nc=size(Cents,1);
WhichB=zeros(1,nc);
NewBPos=[];
OldBPos=[];
NewBInds=[];
i=1;
CPos=[1:nc];
% while there are still bees to match
while((nb>0)&(nc>0))
    % find the nearest bee position to centres
    % Could do position plus last speed
    % Or something more sophisticated involving kalman filters 

    d=[];ind=[];
    for j=1:nb
        [d(j),ind(j)]=min(sqrt((BPos(j,1)-Cents(:,1)).^2+(BPos(j,2)-Cents(:,2)).^2));
    end

    % find closest of the centres
    [md,mi]=min(d);

    % if it is within bee distance tolerance, add it to new bee list
    if(md<MaxD)
        OldBPos(i,:)=BPos(mi,:);
        NewBPos(i,:)=Cents(ind(mi),:);
        NewBInds(i)=BInds(mi);
        i=i+1;
        WhichB(CPos(ind(mi)))=BInds(mi);
        BPos=RemoveRow(BPos,mi);
        BInds=RemoveRow(BInds',mi)';
        Cents=RemoveRow(Cents,ind(mi));
        CPos=RemoveRow(CPos',ind(mi))';
    else
        break;
    end

    nb=size(BPos,1);
    nc=size(Cents,1);
end
% add in the remaining centres as bee positions
% as they have no previous position, make old position = new position

NewBPos=[NewBPos; Cents];
OldBPos=[OldBPos; Cents];
BSpeed=NewBPos-OldBPos;
newinds=MaxBInd+[1:size(Cents,1)];
NewBInds=[NewBInds newinds];
WhichB(CPos)=newinds;