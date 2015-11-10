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

function[sfn] = TrackAntPathInt(fn,FullFrame,thresh,nums)

% Make Check=1 to have a look at the data. This used to check that 
% threshoilds etc are at the right level
Check=0;

% Check then sets opt. If opt is not 0, then the outlines of the objects
% found is returned in outl so they cna be plotted
if(Check)
    opt=1;
else
    opt=0;
end
k=strfind(fn,'.avi');

% default is processing half-frames
if(nargin<2)
    FullFrame=1;
end

if(nargin<3) 
    thresh=10; 
    sfn=[fn(1:k-1) '_Prog.mat']
else
    sfn=[fn(1:k-1) '_ProgThresh' int2str(thresh) '.mat']
end
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];NumFrs=[];
area_e=[];EPt=[];elips=[];odev=[];ang_e=[];len_e=[];eccent=[];

MaxD=5;
lmn=[fn(1:k-1) 'NestLMData.mat']


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
    bigsmall=[100 15];
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
vObj=[];
load(lmn);
refim_im=MyAviRead(fn,StartEnd(1),vObj);
orefim_im=MyAviRead(fn,StartEnd(1),vObj);

if(nargin<4) 
    nums=StartEnd(1):StartEnd(end); 
end;
% BlurIm=zeros(size(refim(:,:,1)));

for num=nums
    f=MyAviRead(fn,num,vObj);
    
    % if the frame you're processing is close to on end use that end
    % could do some smoothing over frames a la CTrax here
    dtoend=abs(num-StartEnd);
    if(dtoend(2)<dtoend(1))
        dif=imsubtract(orefim_im,f);
    else
        dif=imsubtract(refim_im,f);
    end
    
    for i=is
        if 0%(FullFrame==0)
            [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,outl]= ...
                FindAntPathInt(dif(i:2:end,:,:),mod(i,2),f(i:2:end,:,:),thresh,bigsmall,maskim,opt);
        else
            % put odeven=-1 to get whole frames; 
            [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc,outl]= ...
                FindAntPathInt(dif,-1,f,thresh,bigsmall,maskim,opt);
        end
        if(isempty(WhichB)) 
            MaxBInd=0;
        else
            MaxBInd=max(WhichB);
        end
        [BPos,BInds,w] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
        NumBees=[NumBees n];
        NumFrs=[NumFrs 2*num-2+i];
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
            FrameNum=[FrameNum 2*num-2+i];

            odev=[odev mod(i,2)];
            if(Check)
                figure(1)
                imagesc(f)
                title(['Frame Num = ' int2str(num) ';    num bees = ' num2str(n)])
                hold on, 
                PlotBee(c(j,:),e(j,:),'b',100)
                PlotBee(c(j,:),ee(j,:),'r',100)
                plot(ell(j).elips(:,1),ell(j).elips(:,2),'g')
%                 hold off
%                 pause
            end
        end
        if((n>0)&&Check)
            for j=1:length(outl)
                boundary = outl{k};
                plot(boundary(:,2), boundary(:,1), 'w');
            end
            hold off;
            keyboard
        end

    end
    if(mod(num,20)==0)
        save(sfn,'FrameNum','MeanCol', 'WhichB', ...
            'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','odev','ang_e','len_e','eccent','thresh'...
            ,'refim','StartEnd','bigsmall','FullFrame','NumFrs');
%         keyboard
    end
    [num n]
end

% Uncomment this if majoraxis thing not working
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;

save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent','thresh'...
    ,'refim','StartEnd','bigsmall','FullFrame','NumFrs');
