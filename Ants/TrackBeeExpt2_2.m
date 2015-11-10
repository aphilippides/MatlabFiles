function[sfn] = TrackBeeExpt2(fn,nums,thresh)
% dwork;
% cd GantryProj\Bees
% cd GantryProj\Video\Tape\

Check=0;
k=strfind(fn,'.avi');
sfn=[fn(1:k-1) '_Prog_2_th' int2str(thresh) '.mat']
% return;
Areas=[];NumBees=[];Cents=[];Orients=[];MaxDif=[];WhichB=[];
EndPt=[];Bounds=[];FrameNum=[];BPos=[];BInds=[];
area_e=[];EPt=[];elips=[];odev=[];ang_e=[];len_e=[];

MaxBInd=0;
MaxD=20;
picwid=25;
lmn=[fn(1:k-1) 'NestLMData.mat']
% [inf,NumFrames]=MyAviInfo(fn);
tmp=aviinfo(fn);
NumFrames=tmp.NumFrames;
if(isfile(lmn))
    load(lmn);
    refim
%     [refim]=MyAviRead(fn,refim+1,1);
    [refim]=aviread(fn,refim+1);refim=refim.cdata;
else [refim]=MyAviRead(fn,NumFrames,1);    
end

if(nargin<2) nums=1:NumFrames; end;
if(nargin<3) thresh=0.5; end;
h= fspecial('gaussian',5,1);
for num=nums
%     f=MyAviRead(fn,num,1);
    f=aviread(fn,num);
    f=f.cdata;
    dif=imsubtract(refim,f);
    for i=[2 1]
        [a,c,o,md,e,n,b,ae,ee,oe,ell,len,g1]=FindBeeExpt2_2(dif(i:2:end,:,:),mod(i,2),thresh);
%         br=imfilter(refim(i:2:end,:,:),h);
%         bf=imfilter(f(i:2:end,:,:),h);        
%         d=imsubtract(br,bf);
%         [a,c,o,md,e,n,b,ae,ee,oe,ell,len,g3,g4]=FindBeeExpt2_2(d(i:2:end,:,:),mod(i,2),f);
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
        MaxDif=[MaxDif;md];
        WhichB=[WhichB w];
        elips=[elips ell];
        area_e=[area_e ae];
        ang_e=[ang_e oe];
        EPt=[EPt;ee];
        len_e=[len_e;g1];
        for j=1:n
            FrameNum=[FrameNum 2*num+1-i];
            odev=[odev mod(i,2)];
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

        save(sfn,'FrameNum','MaxDif', 'WhichB', ...
            'Areas','NumBees','Cents','Orients','EndPt','Bounds', ...
            'area_e','EPt','elips','odev','ang_e','len_e');
    end
    [num n]
end

% Uncomment this if majoraxis thing not working
% [EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
% EndPt=EndPt+Cents;

save(sfn,'FrameNum','MaxDif', 'WhichB', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds', ...
    'area_e','EPt','elips','odev','ang_e','len_e');