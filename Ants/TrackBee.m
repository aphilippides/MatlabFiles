function[sfn] = TrackBee(fn,nums,t)
% dwork;
% cd GantryProj\Bees
% cd GantryProj\Video\Tape\
fi=aviinfo(fn);
NumFrames=fi.NumFrames
if(nargin<2) nums=1:NumFrames; end;
if(nargin<3) t=0.5; end;

% sfn=[fn(1:end-5) 'AvgImProgDataT' num2str(t) '_' int2str(nums(1)) '_' int2str(nums(end)) '.mat']
k=strfind(fn,'.avi');
sfn=[fn(1:k-1) 'ProgDataT' num2str(t) '_' int2str(nums(1)) '_' int2str(nums(end)) '.mat']
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];Eccent=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];
MaxBInd=0;
MaxD=20
refim=aviread(fn,1);
% BlurIm=zeros(size(refim(:,:,1)));

for num=nums
    f=aviread(fn,num);
    dif=imsubtract(refim.cdata,f.cdata);
    for i=[2 1]
        %         [a,c,o,s,e,n,b]=FindBee(dif(i:2:end,i:2:end,:),f.cdata);
        [a,c,o,s,e,n,b]=FindBee(dif(i:2:end,i:2:end,:),t);
        c=c*2;
        e=e*2;
        if(i==1) 
            c=c-1; 
            e=e-1;
        end;
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
        end

      save(sfn,'FrameNum','Eccent', 'WhichB', ...
            'Areas','NumBees','Cents','Orients','EndPt','Bounds');
    end
        [num n]

end

% Uncomment this if majoraxis thing not working
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;

save(sfn,'FrameNum','Areas','NumBees','Cents','Orients', ...
    'WhichB','EndPt','Bounds','Eccent');%

function[mi] = AverageCols(i)
mi=imlincomb(0.5,i(:,1:end-1,:),0.5,i(:,2:end,:));