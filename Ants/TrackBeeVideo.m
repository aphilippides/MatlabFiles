function[bads] = TrackBeeHiSp(ss)
dwork;
cd GantryProj\Video\Tape
CheckIfZoomed;

MaxD=20;
Drawing=1;
Hand=0;
for s=ss
    if(isfile(['RefImData' int2str(s) '.mat']))
        load(['HiSpeedData' int2str(s) '.mat']);
        a=[s m]
    else
        [dn,m,nf] = FolderInfo(s)
        refimi=1;
        %        NumBees=ones(1,m)*-1;
    end
    Areas=[];NumBees=[];Cents=[];Orients=[];Stripes=[];EndPt=[];
    CentsEntered=[];TipsEntered=[];FrameNum=[];
    MajAx=[];MinAx=[];BPos=[];BInds=[];Bounds=[];WhichB=[];
    Eccent=[];
    fn=['C:\_MyDocuments\WorkPrograms\GantryProj\HiSpeed\170106\HiSpeedData' int2str(s) '.mat'];
    if(~isempty(dn))
        cd(dn);
        refim=imread(GetDVRname(1,m));
        [wid ht]=size(refim(:,:,1));
        for i=1:m
            if(~mod(i,10))
                [s i m]
            end
            if(isempty(WhichB)) MaxBInd=0;
            else MaxBInd=max(WhichB);
            end

            %         if(NumBees(i)>0)
            im=imread(GetDVRname(i,m));
            [n,c,a,o,e,en,maj,min,b]=Find1Bee_HiSpeed(refim,im);
            NumBees(i)=n;
            [BPos,BInds,w,unused] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
            Bounds=[Bounds; b];
            Areas=[Areas a];
            Cents=[Cents; c];
            Orients=[Orients o];
            MajAx=[MajAx o];
            MinAx=[MinAx o];
            EndPt=[EndPt;en];
            Eccent=[Eccent e];
            WhichB=[WhichB w];
            FrameNum=[FrameNum i*ones(1,n)];
            save(fn,'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
                'm','nf','Eccent','refimi','EndPt','MajAx','MinAx','FrameNum');%

            if(Drawing|Hand)
                %imagesc(im);
                for j=1:n
                    [x1,x2,y1,y2]=SetBigBBox([c(j,:) 1 1],100,100,wid,ht);
                    axis equal
                    axis([x1,x2,y1,y2])
                    if(Drawing)
                        hold on;
                        plot([c(j,1) en(j,1)],[c(j,2) en(j,2)],'g-x')
                        MyEllipse(maj(j),min(j),c(j,:),o(j));
                        hold off;
                        if(n>1) title(['Bee ' int2str(j) ' out of ' int2str(n)],'FontSize',14); end;
                        isbad=input('press return to continue, 0 for bad point, 1 to stop drawing');
                        if(isbad==1) Drawing=0;
                        elseif(isbad==0) bads=[bads i];
                        end
                    elseif(Hand)
                        title(['click on head then tail. Frame ' int2str(FrameNum) ' out of ' int2str(m)])
                        [p,q]=ginput(2);
                        HeadsEntered=[HeadsEntered; p(1) q(1)];
                        TipsEntered=[TipsEntered; p(2) q(2)];
                        save([fn(1:end-4) 'HandData.mat'],'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
                'm','nf','Eccent','refimi','EndPt','MajAx','MinAx','FrameNum','TipsEntered','HeadsEntered');%
                    end
                end
            end
        end
        ToBeDeleted=find(NumBees==0);
        save(fn,'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds', ...
            'm','nf','ToBeDeleted','Eccent','refimi','EndPt','MajAx','MinAx','FrameNum');%
        cd ../../
    end
end