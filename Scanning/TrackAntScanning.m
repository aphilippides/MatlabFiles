function[sfn] = TrackAntScanning(fn,nums,t)
% dwork;
% cd GantryProj\Bees
% cd GantryProj\Video\Tape\

Check=0;
k=strfind(fn,'.mov');
sfn=[fn(1:k-1) '_ProgWhole.mat']
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];MeanCol=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];NLess=[];
area_e=[];EPt=[];elips=[];odev=[];ang_e=[];len_e=[];eccent=[];

MaxBInd=0;
MaxD=20;
picwid=25;
lmn=[fn(1:k-1) 'NestLMData.mat']
[inf,NumFrames]=MyAviInfo(fn);
if(isfile(lmn))
    load(lmn);
    refim
    [refim]=MyAviRead(fn,refim,1);
    if(isempty(refim))
       refim=MyAviRead(fn,1,1); 
    end
else
    [refim]=MyAviRead(fn,NumFrames,1);
end

if(nargin<2) nums=1:NumFrames; end;
if(nargin<3) t=0.5; end;
% BlurIm=zeros(size(refim(:,:,1)));
CheckThresh=0;

ThreshVal=25;
for num=nums
    f=MyAviRead(fn,num,1);
    if(isempty(f))
        return;
    end
    dif=imsubtract(refim,f);
        [a,c,o,md,e,n,b,nlss,ae,ee,oe,ell,len,ecc]= FindAntScanning(dif,f,ThreshVal);
%         eo=e; co=c;
%         if(~isempty(c))
%             c(:,2)=c(:,2)*2;
%             e(:,2)=e(:,2)*2;
%             if(i==1)
%                 c(:,2)=c(:,2)-1;
%                 e(:,2)=e(:,2)-1;
%             end
%         end
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
        MeanCol=[MeanCol md];
        WhichB=[WhichB w];
        elips=[elips ell];
        area_e=[area_e ae];
        ang_e=[ang_e oe];
        EPt=[EPt;ee];
        len_e=[len_e len];
        NLess=[NLess nlss];
        eccent=[eccent ecc];
        if(n>1)
            CheckThresh=1;
        elseif((CheckThresh==0)&&(n==0))
            CheckThresh=1;
        end
        for j=1:n
            
            if 0%(CheckThresh)
                ThreshVal=GetThreshValue(refim,f,ThreshVal,c(j,:));
                CheckThresh=0;
            end
%             FrameNum=[FrameNum 2*num-1];%because of half frame
%             interlacing
            FrameNum=[FrameNum num];
%             odev=[odev mod(i,2)];
            if(Check)
                figure(1)
                imagesc(f)
                title(['Frame Num = ' int2str(num) ';    num bees = ' num2str(n)])
%                 hold on, PlotBee(c(j,:),e(j,:),picwid)
%                 hold off
%                 figure(2)
%                 imagesc(dif(i:2:end,:,:))
                hold on, 
                PlotBee(c(j,:),e(j,:),'b')
                PlotBee(c(j,:),ee(j,:),'r')
                plot(ell(j).elips(:,1),ell(j).elips(:,2),'g')
                hold off
                pause
            end
        end

        save(sfn,'FrameNum','MeanCol', 'WhichB', ...
            'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
            'area_e','EPt','elips','odev','ang_e','len_e','eccent');
    [num n]
end

% Uncomment this if majoraxis thing not working
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;

save(sfn,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent');

function[ThreshVal] = GetThreshValue(refim,f,ThreshVal,c)
imdiff=imsubtract(refim,f);
d=double(rgb2gray(imdiff));
origim=double(rgb2gray(f));

while 1
    figure(1)
    BW=double(d>ThreshVal);
    [B,L] = bwboundaries(BW,'noholes');
    imagesc(d)
    axis equal;
%     axis([c(1)-35 c(1)+35 c(2)-35 c(2)+35])
    hold on
    title(['Thresh level ' num2str(ThreshVal)])
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'g');
    end
    colorbar;
    hold off
    
    figure(2)
    imagesc(f);
    axis equal;
    axis([c(1)-35 c(1)+35 c(2)-35 c(2)+35])
    hold on
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'g');
    end
    hold off

    disp(['Thresh level = ' num2str(ThreshVal)]);
    ninp=input(['enter new level or return:  ']);
    if(isempty(ninp)) break;
    else ThreshVal=ninp;
    end
end