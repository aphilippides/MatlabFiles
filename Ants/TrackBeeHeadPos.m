function[bads] = TrackBeeHeadPos(ss,ns)
% dwork;
% cd GantryProj\Bees\Head

MaxD=20;
Drawing=0;
Hand=1;
for s=ss
    if(isfile(['HiSpeedData' int2str(s) '.mat']))
        load(['HiSpeedData' int2str(s) '.mat']);
        a=[s m]
    else
        [dn,m,nf] = FolderInfo(s)
        refimi=1;
        %        NumBees=ones(1,m)*-1;
    end
    Areas=[];NumBees=[];Cents=[];Orients=[];Stripes=[];Head=[];
    HeadsHand=[];TailsHand=[];FrameNum=[];Neck=[];
    Tail=[];MinAx=[];BPos=[];BInds=[];Bounds=[];WhichB=[];isClicked=[];
    Eccent=[];AntennaeBase=[];AntennaeTips=[];Legs=[];NecksHand=[];    
    if(~isempty(dn))
        cd(dn);
        if(nargin<2) ns=1:m; end;
        refim=imread(GetDVRname(min(ns),m));
        [ht wid]=size(refim(:,:,1));
        fn=['HeadPos' int2str(s) 'Fr' int2str(ns(1)) '_' int2str(ns(end)) '.mat'];
        for i=ns
            if(~mod(i,10))
                [s i m]
            end
            if(isempty(WhichB)) MaxBInd=0;
            else MaxBInd=max(WhichB);
            end

            %         if(NumBees(i)>0)
            %        im=imread(['dvr00' int2str(i) '.tif']);
            im=imread(GetDVRname(i,m));
            [n,c,a,o,e,he,ta,nec,mi,b]=FindBee_HeadPos(refim,im);
            NumBees(i)=n;
            [BPos,BInds,w,unused] = MatchBeesToPos(BPos,c,MaxD,BInds,MaxBInd);
            Bounds=[Bounds; b];
            Areas=[Areas a];
            Cents=[Cents; c];
            Orients=[Orients o];
            Tail=[Tail; ta];
            MinAx=[MinAx mi];
            Head=[Head;he];
            Neck=[Neck;nec];
            Eccent=[Eccent e];
            WhichB=[WhichB w];
            FrameNum=[FrameNum i*ones(1,n)];
            if(~Hand)
                save(fn,'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
                    'm','nf','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum');%
            end;
            if(Drawing|Hand)                
                for j=1:n
                    X=GetBox(c(j,:),75,75,wid,ht);
                    axis equal
                    axis(X)
                    if(Drawing)
                        imagesc(im);
                        hold on;
                        plot([c(j,1) he(j,1)],[c(j,2) he(j,2)],'g-x')
                        MyEllipse(maj(j),mi(j),c(j,:),o(j));
                        hold off;
                        if(n>1) title(['Bee ' int2str(j) ' out of ' int2str(n)],'FontSize',14); end;
                        isbad=input('press return to continue, 0 for bad point, 1 to stop drawing');
                        if(isbad==1) Drawing=0;
                        elseif(isbad==0) bads=[bads i];
                        end
                    elseif(Hand&(n==1))
                        skip=0;
                        while(~skip)
                            redo=0;
                            imagesc(im);
                            axis equal
                            axis(X)
                            hold on;
                            % plot(he(1),he(2),'rx')
                            plot([nec(1) ta(1)],[nec(2) ta(2)],'g-x')
                            hold off

                            title(['Head, antennae bottom-tip, legs. Fr ' int2str(i) '/' int2str(m)])
                            xlabel('s or Return early to skip; r to re-do ')
                            inps=7;
                            [p,q,b]=ginput(inps);
                            if(ismember(114,b)) redo=1;
                            elseif(ismember(115,b)|(length(p)~=inps))
                                skip=1;
                            else
                                pts=[ta;nec;[p q]];
                                %      pts=[ta;nec;[p q]];
                                while(1)
                                    imagesc(im);
                                    axis equal
                                    axis(X)
                                    DrawPoints(pts)
                                    title('Click near any point to adjust, r to re-do, s to skip;')
                                    xlabel('Return to finish, r to re-do all, s to skip;')
                                    [p,q,b]=ginput(1);
                                    if(char(b)=='r')
                                        redo=1;
                                        break;
                                    elseif(char(b)=='s')
                                        skip=1;
                                        break;
                                    elseif(isempty(p)) break;
                                    else
                                        vs=pts-ones(length(pts),1)*[p,q];
                                        ds=sum(vs.^2,2);
                                        [mini_d,i_m]=min(ds);
                                        hold on;
                                        plot(pts(i_m,1),pts(i_m,2),'wo')
                                        hold off;
                                        title('click new position, return to re-do')
                                        [p,q,b]=ginput(1);
                                        if(~isempty(p)) pts(i_m,:)=[p q]; end
                                    end
                                end
                                if((~redo)&(~skip))
                                    TailsHand=[TailsHand; pts(1,:)];
                                    NecksHand=[NecksHand; pts(2,:)];
                                    HeadsHand=[HeadsHand; pts(3,:)];
                                    AntennaeBase=[AntennaeBase; pts([4 6],:)];
                                    AntennaeTips=[AntennaeTips; pts([5 7],:)];
                                    Legs=[Legs; pts([8 9],:)];
                                    isClicked=[isClicked i];
                                    break;
                                end
                            end
                        end
                        save([fn(1:end-4) 'Hand.mat'],'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
                            'm','nf','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum',...
                            'isClicked','TailsHand','HeadsHand','AntennaeBase','AntennaeTips','Legs','NecksHand');%
                    end
                end
            end
        end
        ToBeDeleted=find(NumBees==0);
        if(~Hand)
            save(fn,'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds', ...
                'm','nf','ToBeDeleted','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum');%
        end
        cd ../../
    end
end

function[X]=GetBox(c,wid,ht,mw,mh)
% X=zeros(1,4);
X([1,3])=max([1,1],round(c-[wid,ht]));
X([2,4])=min([mw,mh],round(c+[wid,ht]));

function DrawPoints(pts)
hold on;
plot(pts([1 2],1),pts([1 2],2),'g-x')
plot(pts([4 6],1),pts([4 6],2),'y-o')
plot(pts([5 7],1),pts([5 7],2),'y-o')
plot(pts(3,1),pts(3,2),'r.')
plot(pts([8 9],1),pts([8 9],2),'r-o')

hold off