function[bads] = TrackBeeHeadPos_2(s,ns)
% dwork;
% cd GantryProj\Bees\Head
% 
MaxD=20;
if(isfile(['HiSpeedData' int2str(s) '.mat']))
    load(['HiSpeedData' int2str(s) '.mat']);
    a=[s m]
else
    [dn,m,nf] = FolderInfo(s)
    refimi=1;
end
Areas=[];NumBees=[];Cents=[];Orients=[];Stripes=[];Head=[];
HeadsHand=[];TailsHand=[];FrameNum=[];Neck=[];
Tail=[];MinAx=[];BPos=[];BInds=[];Bounds=[];WhichB=[];isClicked=[];
Eccent=[];AntennaeBase=[];AntennaeTips=[];Legs=[];NecksHand=[];
MidNeck=[];MidNeckHand=[];Width=[];

if(isempty(dn)) return; end;

cd(dn);
if(nargin<2) ns=1:m; end;
refim=imread(GetDVRname(min(ns),m));
[ht wid]=size(refim(:,:,1));
fn=['HeadPos' int2str(s) 'Fr' int2str(ns(1)) '_' int2str(ns(end)) '.mat'];

for i=ns
    if(isempty(WhichB)) MaxBInd=0;
    else MaxBInd=max(WhichB);
    end
    %         if(NumBees(i)>0)
    im=imread(GetDVRname(i,m));
    [n,c,a,o,e,he,ta,nec,mi,b,midn,wide]=FindBee_HeadPos(refim,im);
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
    Width=[Width wide];
    MidNeck=[MidNeck;midn];
    if(n==1)
        skip=0;
        redo=1;
        % Get Antennae
        while(redo)
            redo=0;
            X=DrawIm(im,c,75,75,wid,ht);
            title(['Click each antenna, base then tip. Fr ' int2str(i) '/' int2str(m)])
            xlabel('s or Return early to skip; r to re-do ')
            inps=4;
            [p,q,b]=ginput(inps);
            if(ismember(114,b)) redo=1;
            elseif(ismember(115,b)|(length(p)~=inps))
                break;
            else
                antennae =[p q];
                hold on;
                [antennae,redo,skip]=AdjustPts(antennae,im,X);
                hold off;
                if(~redo)
                    if(~skip)
                        AntennaeBase=[AntennaeBase; antennae([1 3],:)];
                        AntennaeTips=[AntennaeTips; antennae([2 4],:)];
                        isClicked=[isClicked i];
                    end
                    break;
                end;
            end;
        end
        save([fn(1:end-4) 'Hand.mat'],'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
            'm','nf','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum',...
            'isClicked','TailsHand','HeadsHand','AntennaeBase','AntennaeTips',...
            'Width','MidNeck','MidNeckHand','NecksHand');%,'Legs'
    end
end

% Draw Orientation and adjust
for i=isClicked
    j=find(FrameNum==i);
    bod_nec=[Tail(j,:);Neck(j,:)];
    while(1)
        redo=0;
        DrawIm(im,c,75,75,wid,ht);
        title('Click near any point to adjust, return to finish')
        xlabel(['Frame ' int2str(i) ' / ' int2str(max(ns))]);
        hold on;
        DrawOrient(bod_nec(1,:),bod_nec(2,:),Head(j,:),Orients(j),Width(j),MinAx(j));
        hold off;
        [p,q,b]=ginput(1);
        if(isempty(p)) break;
        else
            vs=bod_nec-ones(length(bod_nec),1)*[p,q];
            ds=sum(vs.^2,2);
            [mini_d,i_m]=min(ds);
            hold on; plot(bod_nec(i_m,1),bod_nec(i_m,2),'wo'); hold off;
            title('click new position, return to re-do')
            [p,q,b]=ginput(1);
            if(~isempty(p)) bod_nec(i_m,:)=[p q]; end
        end
    end
    TailsHand=[TailsHand; bod_nec(1,:)];
    NecksHand=[NecksHand; bod_nec(2,:)];
    save([fn(1:end-4) 'Hand.mat'],'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
        'm','nf','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum',...
        'isClicked','TailsHand','HeadsHand','AntennaeBase','AntennaeTips',...
        'Width','MidNeck','NecksHand');%,'Legs'
end

% Click Head and adjust
for i=isClicked
    j=find(FrameNum==i);
    redo=1;
    DrawIm(im,c,75,75,wid,ht);
    hold on; plot(MidNeck(j,1),MidNeck(j,2),'r .'); hold off;
    title(['Click head. Frame ' int2str(i) ' / ' int2str(max(ns))]);
    p=[];
    while(isempty(p)) [p,q,b]=ginput(1); end;
    pts=[MidNeck(j,:);[p q]];
    while(1)        
        DrawIm(im,c,75,75,wid,ht);
        hold on;
        plot(pts(:,1),pts(:,2),'r- .');
        hold off;
        title('Click near any point to adjust, return to end')
        xlabel(['Frame ' int2str(i) ' / ' int2str(max(ns))]);
        [p,q,b]=ginput(1);
        if(isempty(p)) break;
        else
            vs=pts-ones(length(pts),1)*[p,q];
            ds=sum(vs.^2,2);
            [mini_d,i_m]=min(ds);
            hold on; plot(pts(i_m,1),pts(i_m,2),'wo'); hold off;
            title('click new position, return to re-do')
            [p,q,b]=ginput(1);
            if(~isempty(p)) pts(i_m,:)=[p q]; end
        end
    end
    MidNeckHand=[MidNeckHand; pts(1,:)];
    HeadsHand=[HeadsHand; pts(2,:)];
    save([fn(1:end-4) 'Hand.mat'],'dn','Areas','NumBees','Cents','Orients','WhichB','Bounds',...
        'm','nf','Eccent','refimi','Head','Tail','Neck','MinAx','FrameNum',...
        'isClicked','TailsHand','HeadsHand','AntennaeBase','AntennaeTips',...
        'Width','MidNeck','MidNeckHand','NecksHand');%,'Legs'
end

function DrawOrient(tail,neck,hed,o,nwidth,bwidth)
[n1,n2]=pol2cart(o+pi/2,nwidth/2);
[m1,m2]=pol2cart(o-pi/2,nwidth/2);
pts=[neck+[m1 m2];neck+[n1 n2];tail+[n1 n2];tail+[m1 m2];neck+[m1 m2]];
p1=[tail;neck];
p2=[tail;hed];

shou=0.75*neck+0.25*tail; 
[n1,n2]=pol2cart(o+pi/2,bwidth*.9);
[m1,m2]=pol2cart(o-pi/2,bwidth*.9);
p3=[shou+[m1 m2];tail+[m1 m2]];
p4=[shou+[n1 n2];tail+[n1 n2]];

plot(pts(:,1),pts(:,2),'g--',p1(:,1),p1(:,2),'g-x',p3(:,1),p3(:,2),'r--',p4(:,1),p4(:,2),'r--')%,p2(:,1),p2(:,2),'g--')

function DrawPoints(pts)
hold on;
plot(pts([1 2],1),pts([1 2],2),'go')
plot(pts([3 4],1),pts([3 4],2),'ro')
plot(pts([1 3],1),pts([1 3],2),'y-')
plot(pts([2 4],1),pts([2 4],2),'y-')
hold off

function[pts,redo,skip]=AdjustPts(pts,im,X)
redo=0;
skip=0;
while(1)
    imagesc(im);
    axis equal
    axis(X)
    DrawPoints(pts)
    title('Click near any point to adjust')
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

function[X]=GetBox(c,wid,ht,mw,mh)
% X=zeros(1,4);
X([1,3])=max([1,1],round(c-[wid,ht]));
X([2,4])=min([mw,mh],round(c+[wid,ht]));

function[X]=DrawIm(im,c,boxw,boxh,wid,ht)
X=GetBox(c,boxw,boxh,wid,ht);
imagesc(im);
axis equal;
axis(X);