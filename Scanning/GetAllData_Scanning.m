function GetAllData_Scanning
% MakeSmallFiles
% return
alls=dir('*All.mat');
shads=dir('*Shad.mat');
s=dir('*.mov'); %%%%%% '.mov'

numdone=[length(s) length(alls) length(shads)];
% Stuff to check whihc done and which areen't
for i=1:length(s)
    fn=s(i).name;
    pn=fn(1:strfind(fn,'.mov')-1);
    % ProgN=[pn '_Prog.mat'];
	ShN=[pn 'Shad.mat'];
    AllN=[pn 'All.mat'];
    HandN=[pn 'Hand.mat'];
    SkN=[pn 'SkHand.mat'];
    if(isequal(fn(4),'L')&isequal(fn(6:8),'TrL')) class(i)=1;
    elseif(isequal(fn(4),'L')&isequal(fn(6:8),'TrN')) class(i)=2;    
    elseif(isequal(fn(4),'R')&isequal(fn(6:8),'TrL')) class(i)=3;    
    elseif(isequal(fn(4),'R')&isequal(fn(6:8),'TrN')) class(i)=4;    
    elseif(isequal(fn(4),'N')&isequal(fn(6:8),'TrL')) class(i)=5;    
    elseif(isequal(fn(4),'N')&isequal(fn(6:8),'TrN')) class(i)=6;    
    end
%     if(isfile(ShN)) proc(i)=2;
    if(isfile(SkN)) proc(i)=3;
    elseif(isfile(HandN)) proc(i)=4;
    elseif(isfile([pn 'ALev.mat'])) proc(i)=2;
    elseif(isfile(AllN)) proc(i)=1;
    elseif(isfile(ShN)) proc(i)=5;
    else proc(i)=0;
    end
    nscan(i)=str2num(fn(10:11));
end
frequencies(proc)
figure(10)
subplot(2,2,1)
hist(nscan(proc>-1),0:9)
axis tight
title('all'),subplot(2,2,2)
hist(nscan(proc==1),0:9)
axis tight
title('done')
subplot(2,2,3)
hist(nscan(proc==2),0:9)
axis tight
title('shads')
subplot(2,2,4)
[y1,x]=hist(class(proc==1),1:6),axis tight
[y2,x]=hist(class(proc==2),1:6),axis tight
[y3,x]=hist(class(proc==0),1:6),axis tight
bar(x,[y1;y2;y3]')
labs={'L TrL';'L TrN';'R TrL';'R TrN';'N TrL';'N TrN'}
SetXTicks(gca,1,[],[],1:6,labs)
legend('processed','shdows')

% s=dir('2E20 11*.avi');
x=cd;
IntS=[];IntFs=[];
FRLEN=0.004;
shads=1;
clf
load SkipListShad
% % % reprocess=ones(1,length(s))*-1;
if(isempty(s)) disp(['No Files to process in folder ' x]); end;
% for i=1:196%length(s)
for i=1:length(s)
%     if(i>3)
    fn=s(i).name;[int2str(i) ':  ' fn]
    pn=fn(1:strfind(fn,'.mov')-1);
    % ProgN=[pn '_Prog.mat'];
	ProgN=[pn '_ProgWhole.mat'];
    PathN=[pn 'Path.mat'];
    AllN=[pn 'All.mat'];
    LmN=[pn 'NestLMData.mat'];
    HandN=[pn 'Hand.mat'];
    SkN=[pn 'SkHand.mat'];
    
    inp=1;
    if(~shads)
        if(isfile(AllN))
            disp(['File ' AllN ' exists. Skipping to next file']);
            %         inp=input('type 1 to overwrite, else to continue\n');
            %     end
            %     if(inp==1)
        else
            %         RemoveAllEdges(ProgN,fn);
            %        RemoveAllShadows(ProgN,fn);
            %     GetNestAndLMData(pn);
            if(isfile(SkN))
                keyboard;
            elseif(isfile(HandN))
                keyboard;
            end
            if(ismember(class(i),[1:6])&nscan(i)>-1)
                [d,rms]=GetPathsScanning(ProgN,PathN,fn,LmN,FRLEN)
                if(d==-1) disp(['No Ants in file ' ProgN ' !!!'])
                else
                    bs=input('enter which ants to remove, or return: ')
                    ts=input('enter which times to remove, or return: ')
                    %             flips=input('enter which times to flip, or return')
                    flips=[];
                    Get1Data(PathN,fn,bs,ts,flips,rms,AllN,pn,FRLEN);
                    disp(['File ' AllN ' generated.\nPress return to continue']);
                end
                pause;
            end
        end
    else
        %     if(CheckInterferingShadows(pn))
        %         IntS=[IntS i];
        %         IntFs=s(IntS);
        %         save InterferingShadows IntS IntFs
        %     end;
%         CheckFiles(AllN,fn)
        if(isfile([pn 'ALev.mat']))

            %         GetShadData(AllN,pn);
%                     GetShadDataWhole(AllN,pn);
            if 1%(SkipList(i)~=1)
                nscan=str2num(pn(10:11));
                if 1%(nscan>0)
%                     if(reprocess(i)==-1)
%                         reprocess(i)=CheckSLevel(AllN,fn,LmN);
%                         save SkipListShad reprocess -append
%                     end
%%%   This bit does the shadow processing
% prob best to then check them by hand via the below
% %                     ProcessShadowsScanning
% %                     Get1DataLastBit(AllN,fn,LmN);
                    if 1%(reprocess(i)~=2)
                        if((~isfile(HandN))&&(~isfile(SkN)))
                            figure(1)
                            Get1DataLastBitHand(SkN,AllN,fn,LmN);
                            disp(['File ' SkN ' generated.\nPress return to continue']);
                            pause;
                       end
                    end
%                     delete([pn 'ALev.mat'])
                end
            end
        end
    end
    %     end
end

function MakeSmallFiles

s=dir('*.mov'); %%%%%% '.mov'
for i=1:length(s)
%     if(i>3)
    fn=s(i).name;
    pn=fn(1:strfind(fn,'.mov')-1);
    % ProgN=[pn '_Prog.mat'];
	ProgN=[pn '_ProgWhole.mat'];
    PathN=[pn 'Path.mat'];
    AllN=[pn 'All.mat'];
    LmN=[pn 'NestLMData.mat'];
    HandN=[pn 'Hand.mat'];
    SkN=[pn 'SkHand.mat'];
    inp=1;
    if(isfile(HandN)) 
        inf=HandN;
    elseif(isfile(SkN))
        inf=SkN;
    elseif(isfile(AllN)) 
        inf=AllN;
    end
    if 1%(~isfile([pn 'ALev.mat']))
        outf=['SmallFiles/' pn 'Small.mat'];
        if(~isfile(outf))
            [int2str(i) ':  ' fn]
            clear('sOr','Cents','Vels','Speeds','Cent_Os','FRLEN','EndPt');
            load(inf)
            save(outf,'sOr','Cents','Vels','Speeds','Cent_Os','FRLEN','EndPt');
        end
    end
    %     end
end



function[l]=Get1Data(PathN,vidfn,bees_out,TsRemoved,flips,rms,AllN,ff,FRLEN)
load(PathN);
% Get data to get rid of
is=[];
% Select bees to get rid of
for i=bees_out 
    is=union(is,find(WhichB==i)); 
end;

% Get rid of certain times
t=FrameNum*FRLEN;

% Get rid of data too close to the boundary
[dumdum,edges,inNest]=OutofBoundsScanning(Bounds,[ff 'NestLMData.mat']);
% [dumdum,edges,inNest]=deal(0,[],0);
removed=union([is edges' rms],GetTimes(t,TsRemoved));
% Remove all unwanted points
RemoveData(PathN,AllN,removed,FRLEN)

load(AllN)
badbs=find(diff(FrameNum)==0);
if(~isempty(badbs))
    rms=[];
    inp=input('Enter 0 to check doubles. -1 for keyboard');
    if(inp==-1) keyboard;
    elseif(inp==0)
        for i1=badbs
            i2=i1+1;
            figure(2)
            PlotBEllipse(vidfn,i1,FrameNum,Cents,EPt,EndPt,elips,'g');
            figure(3)
            PlotBEllipse(vidfn,i2,FrameNum,Cents,EPt,EndPt,elips,'g');
            inp=input(['t = ' num2str(FrameNum(i1)*FRLEN) '; press 2 to rmove fig 2, 3 for fig 3, 0 for both']);
            if(inp==2) rms=[rms i1]
            elseif(inp==3) rms=[rms i2];
            else rms=[rms i1 i2];
            end
        end
    end;
    RemoveData(AllN,AllN,rms,FRLEN)
    load(AllN)
    keyboard
end

while 1
    ds=AngularDifference(ang_e,Cent_Os)*180/pi;
    as=AngleWithoutFlip(ang_e)*180/pi;
    asd=as+abs(ds);
    ovs=abs(ds)>=90;
    figure(1)
    plot(t,as,t,asd,'r',t(ovs),asd(ovs),'k.')
    axis tight;
    xlabel('time');
    ylabel('angle');
    title('dots mean body (blue) >90 from ant path (red)')
    figure(2),plot(t,abs(ds));
    axis tight;
    xlabel('time');
    ylabel('angle');
    title('difference between body and ant path')
    flips=input('enter which times to flip, or return to end')
    if(isempty(flips)) break; end;
    % flip any that need flipping
    iflips=GetTimes(t,flips);
    for i=iflips
        if(ang_e(i)<0) ang_e(i)= ang_e(i)+pi;
        else ang_e(i)= ang_e(i)-pi;
        end
    end
end
[EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
EPt=EPt+Cents;
save(AllN,'ang_e','EPt','-append')

% Check Shadow Data
% sfile=[AllN(1:(end-8)) 'SLev.mat'];
% if(isfile(sfile))
%     load(sfile);
%     save(AllN,'sLevel','shads','-append');
% end
% sLevel=85;

if(sLevel~=200)
    [sas,i1]=sort(Areas,'descend');
    load([ff 'NestLMData.mat']);
    % Get area level
    figure(1),
    plot(Areas(i1))
    ylabel('ant areas sorted in descending size')
    axis tight;
    aLevel=500;
    while 1
        s=input('enter area cut off; areas ABOVE this to be re-processed; return to skip');
        if(~isempty(s))
            aLevel=s;
            ind=find(sas<=aLevel,1);
            if(isempty(ind)) ind=i1(1);
            else ind=i1(ind);
            end
            figure(2)
            PlotBEllipse(vidfn,ind,FrameNum,Cents,EPt,EndPt,elips,'g');
        else break;
        end
    end
    ind=i1(1);
    fr=FrameNum(ind);%floor(0.5*(FrameNum(ind)+1));
    f=MyAviRead(vidfn,fr,1);
    s=size(f);
    a1=max(round(Cents(ind,:)-50),[1 1]);
    a2=min(round(Cents(ind,:)+50),s([2,1]));
    im=f(a1(2):a2(2),a1(1):a2(1),:);
    imbw=double(rgb2gray(im));
    while 1
        figure(1)
        BW=double(imbw<sLevel);
        [B,L] = bwboundaries(BW,'noholes');
        imagesc(im)
        axis equal;
        hold on
        title(['Shadow level ' num2str(sLevel)])
        for k = 1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'g');
        end
        hold off
        ninp=input(['Shadow level ' num2str(sLevel) '; enter new level or return']);
        if(isempty(ninp)) break;
        else sLevel=ninp;
        end
    end
    ShadN=[ff 'Shad.mat'];
    copyfile(AllN,ShadN);
    save(ShadN,'sLevel','aLevel','refim','-append');
    if(aLevel<=max(Areas))
        save([ff 'ALev.mat'],'aLevel');
        return;
    end
end

% % Check data close to the nest
% VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
% DToNest=sqrt(sum(VToNest.^2,2));
% onNest=find(DToNest<=(NestWid+2));
% if(~isempty(onNest))
%     [Orients(onNest),badFrames,bads] = AdjustOrients(Orients(onNest),Cents(onNest,:),FrameNum(onNest),[ff '.avi']);
%     save(AllN,'Orients','-append')
% %    save(PathN,'Orients','-append')
%     onNest=onNest(bads);
%     RemoveData(AllN,AllN,onNest,FRLEN);
%     clear badFrames bads
%     load(AllN)
% end

% Smooth the data
sm_len=0.03;
[ang_e,Cents,len_e,bads,unsure]=SmoothOsScanning(ang_e,t,Cents,len_e,...
    vidfn,sm_len,eccent,area_e,FrameNum);
% RemoveData(AllN,AllN,bads,FRLEN);
% load(AllN)
% unsure=unsure(setdiff(1:length(ang_e),bads));
% unsure=find(unsure);

% unsure=[];
sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
is=setdiff(1:length(sOr),unsure);
sOr(is)=TimeSmooth(AngleWithoutFlip(ang_e(is)),t(is),sm_len);
save(AllN,'ang_e','Cents','len_e','bads','unsure','sOr','-append')

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
figure(4)
cs=[0 0;diff(Cents)];
d=(CartDist(cs));
subplot(2,1,1)
plot(FrameNum,d,'k'); axis tight;
subplot(2,1,2)
plot(FrameNum,cumsum(d),'k'); axis tight;
xlabel('time'); ylabel('distance')
figure(2)
[sOr,unsure,Cents] = AdjOrientsScanning(sOr,Cents,FrameNum,vidfn,unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
axis tight;
% input('Press return to continue');

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
clear i f s fn is i_out a
save(AllN)

% function[OutOrNest,IndList] = OutofBoundsScanning(Bounds,fn)
%
% fn is Nest and LM file
% Function to check if out of bounds or at the nest
% returns list of 1 for at edge, 2 for nest and 0 else
% Could change Tol to adjust bee finding

function[OutOrNest,IndList,isIn] = OutofBoundsScanning(Bounds,fn)

OutOrNest=zeros(1,size(Bounds,1));
IndList=[];
Tol=1;

% Old version. for mo do path of least resistance

% load([fn '_NestAndBoundData.mat'])
% RightEdge = floor(RightTop(1)/2);
% TopEdge = floor(RightTop(2)/2);
% NestLeft = floor(Nest(1)/2);
% NestBott = floor(Nest(2)/2);
% NestRight = ceil(Nest(3)/2);
% NestTop = ceil(Nest(4)/2);

load(fn)
RightEdge = 512;
TopEdge = 384;

disp(['removing edges image = ' int2str(RightEdge) ' x ' int2str(TopEdge)])

NestLeft = floor((nest(1)-0.5*NestWid)/2);
NestRight = ceil((nest(1)+0.5*NestWid)/2);
NestBott = floor((nest(2)-0.5*NestWid)/2);
NestTop = ceil((nest(2)+0.5*NestWid)/2);

b=floor(Bounds);
lefts = floor(b(:,1));
bottoms = floor(b(:,2));
rights = 1+lefts+b(:,3);
tops = 1+bottoms+b(:,4);

IndList=find(lefts<=(1+Tol));
IndList=[IndList; find(bottoms<=(1+Tol))];
IndList=[IndList; find(rights>=(RightEdge-Tol))];
IndList=[IndList; find(tops>=(TopEdge-Tol))];
OutOrNest(IndList)=1;

isL = find((lefts<=NestLeft)&(rights>=NestLeft));
isR = find((lefts<=NestRight)&(rights>=NestRight));
isLR=union(isL,isR);

isB = find((bottoms<=NestBott)&(tops>=NestBott));
isT = find((bottoms<=NestTop)&(tops>=NestTop));
isTB=union(isB,isT);

isIn=intersect(isLR,isTB);
OutOrNest(isIn)=2;
IndListAll=union(IndList,isIn)';

function RemoveData(fnin,fnout,i_out,FRLEN,set_os)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
t=FrameNum*FRLEN;
Areas=Areas(is);
Cents=Cents(is,:);
if(nargin<5) Orients=Orients(is);
else 
    Orients=set_os;
    clear set_os;
end
WhichB=WhichB(is);
EndPt=EndPt(is,:);
Bounds=Bounds(is,:);
MeanCol=MeanCol(is);
NLess=NLess(is);
len_e=len_e(is);
area_e=area_e(is);
EPt=EPt(is,:);
elips=elips(is);
% odev=odev(is);
ang_e=ang_e(is);
eccent=eccent(is);
v1=MyGradient(Cents(:,1),FrameNum);
v2=MyGradient(Cents(:,2),FrameNum);
Vels=[v1' v2'];
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

clear i_out fnin;
save(fnout)


function GetShadData(AllN,ff);
load([ff 'ALev.mat'])
% Check Shadow Data
if(aLevel~=500)
    load(AllN)
    load([ff 'NestLMData.mat']);
    [refim]=MyAviRead([ff '.avi'],refim,1);
    sAdjusted=find(Areas>aLevel);
    AllN
    for ind=sAdjusted
        fr=floor(0.5*(FrameNum(ind)+1));
        f=MyAviRead([ff '.avi'],fr,1);
        dif=imsubtract(refim,f);
        if(odev(ind))
            [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                FindBeeExpt2_Shadow(dif(1:2:end,:,:),1,f(1:2:end,:,:),sLevel);
        else
            [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
                FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
        end
        if(nb==1)
%             imagesc(f);
%             plotb(ind,Cents,EPt,EndPt,elips,'g')
%             hold on;plotb(1,c,ep,a,el,'b')
            Cents(ind,:)=c;
            area_e(ind)=ae;
            EPt(ind,:)=ep;
            elips(ind)=el;
            len_e(ind)=le;
            eccent(ind)=ec;
            d=abs(AngularDifference(ang_e(ind),oe));
            if(d>pi/2)
                if(oe<0) ang_e(ind)=oe+pi;
                else ang_e(ind)=oe-pi;
                end
                d=d-pi;
            else ang_e(ind)=oe;
            end
            [ind sAdjusted(end) d*180/pi]
            save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
                'len_e','Cents','-append');
        end
    end
%     sAdjusted=[];
%     for ind=i1
%         figure(1),plot(Areas(i1)),hold on
%         plot(find(ind==i1),Areas(ind),'rs','MarkerFaceColor','r');hold off
%         figure(2)
%         fr=floor(0.5*(FrameNum(ind)+1));
%         f=MyAviRead([ff '.avi'],fr,1);
%         imagesc(f);
%         plotb(ind,Cents,EPt,EndPt,elips,'g')
%         dif=imsubtract(refim,f);
%         sAdjusted=[sAdjusted ind];
%         if(odev(ind))
%             [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
%                 FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
%         else
%             [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]= ...
%                 FindBeeExpt2_Shadow(dif(2:2:end,:,:),0,f(2:2:end,:,:),sLevel);
%         end
%         if(nb==1)
%             plotb(1,c,ep,a,el,'b')
%             inp=input('enter 1 to stop; return to accept and continue','s');
%             if(isequal(inp,'1')) break;
%             else
%                 Cents(ind,:)=c;
%                 area_e(ind)=ae;
%                 EPt(ind,:)=ep;
%                 elips(ind)=el;
%                 len_e(ind)=le;
%                 eccent(ind)=ec;
%                 if(abs(AngularDifference(ang_e(ind),oe))>pi/2)
%                     if(oe<0) ang_e(ind)=oe+pi;
%                     else ang_e(ind)=oe-pi;
%                     end
%                 else ang_e(ind)=oe;
%                 end
%                 save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
%                     'len_e','Cents','-append');
%             end
%         end
%     end
%     clear refim f a oe dif i1 fr inp sas ae ep el c ec
end


function CheckFiles(AllN,vidfn)
load(AllN)
% Smooth the data
sm_len=0.03;
[ang_e,Cents,len_e,bads,unsure,changed]=SmoothOsScanning(ang_e,t,Cents,len_e,...
    vidfn,sm_len,eccent,area_e,FrameNum,1);

sOrNew=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
sOr(changed)=sOrNew(changed);
save(AllN,'ang_e','Cents','len_e','sOr','-append')
figure(3)
plot(Cents(:,1),Cents(:,2),'b.-')
axis equal
set(gca,'YDir','reverse');
figure(4)
cs=[0 0;diff(Cents)];
d=(CartDist(cs));
subplot(2,1,1)
plot(FrameNum,d,'k'); axis tight;
subplot(2,1,2)
plot(FrameNum,cumsum(d),'k'); axis tight;
xlabel('time'); ylabel('distance')
figure(2)
plot(t,sOr);
axis tight;

function[todo]=CheckSLevel(AllN,vidfn,Lmn)
ThreshVal=25;
load(AllN)
sLev=sLevel;
load(Lmn)
[refim]=MyAviRead(vidfn,refim);
ind=1;
fr=FrameNum(ind);
f=MyAviRead(vidfn,fr);
dif=imsubtract(refim,f);
[dif,addx]=Constrain2BBox(dif,Bounds(ind,:));
[f,addx]=Constrain2BBox(f,Bounds(ind,:));
while 1
    FindAntScanningShadow(dif,f,sLevel,ThreshVal,1);
    title(['Slevel=' int2str(sLevel) '; fr=' int2str(fr) '; arrows slev, n=+5, 0=bad, return end'])
    [x,y,b]=ginput(1);
    if(isempty(x))
        break;
    elseif(b==30)
        sLevel=sLevel+1;
    elseif(b==31)
        sLevel=sLevel-1;
    elseif(b==31)
        sLevel=sLevel-1;
    elseif(b==48)
        todo=2;
        return;
    elseif(b==110)
        ind=min(length(FrameNum),ind+5);
        fr=FrameNum(ind);
        f=MyAviRead(vidfn,fr);
        dif=imsubtract(refim,f);
        [dif,addx]=Constrain2BBox(dif,Bounds(ind,:));
        [f,addx]=Constrain2BBox(f,Bounds(ind,:));
    end
end
if(sLev~=sLevel)
    save(AllN,'sLevel','-append')
    todo=1;
else
    todo=0;
end

function Get1DataLastBitHand(HandN,AllN,vidfn,Lmn,AlevN)

load(AllN)

% % Get rid of data too close to the boundary
% [dumdum,removed,inNest]=OutofBoundsScanning(Bounds,Lmn);
% % Remove all unwanted points
% RemoveData(AllN,HandN,removed,FRLEN)

% Smooth the data
sm_len=0.03;
% [ang_e,Cents,auto_ang_e,auto_Cents,len_e,bads,unsure]=SmoothOsScanningHand(ang_e,t,Cents,len_e,...
%     vidfn,sm_len,eccent,area_e,FrameNum);

[ang_e,Cents,auto_ang_e,auto_Cents,len_e,bads,unsure]=SmoothOsScanningHandSkip(ang_e,t,Cents,len_e,...
    vidfn,sm_len,eccent,area_e,FrameNum);
skip=3;
% RemoveData(AllN,AllN,bads,FRLEN);
% unsure=unsure(setdiff(1:length(ang_e),bads));
% unsure=find(unsure);

% unsure=[];
sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
is=setdiff(1:length(sOr),unsure);
sOr(is)=TimeSmooth(AngleWithoutFlip(ang_e(is)),t(is),sm_len);
save(HandN)%,'auto_ang_e','auto_Cents','ang_e','Cents','len_e','bads','unsure','sOr','-append')

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
figure(3)
plot(Cents(:,1),Cents(:,2),'b.-')
axis equal
set(gca,'YDir','reverse');
figure(4)
cs=[0 0;diff(Cents)];
d=(CartDist(cs));
subplot(2,1,1)
plot(FrameNum,d,'k'); axis tight;
subplot(2,1,2)
plot(FrameNum,cumsum(d),'k'); axis tight;
xlabel('time'); ylabel('distance')
figure(2)
[sOr,unsure,Cents]=AdjOrientsScanning(sOr,Cents,FrameNum,vidfn,unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
axis tight;
% input('Press return to continue');

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
clear i f s fn is i_out a
save(HandN)


function Get1DataLastBit(AllN,vidfn,Lmn,AlevN)

load(AllN)

% Get rid of data too close to the boundary
[dumdum,removed,inNest]=OutofBoundsScanning(Bounds,Lmn);
% Remove all unwanted points
RemoveData(AllN,AllN,removed,FRLEN)

load(AllN)
% Smooth the data
sm_len=0.03;
[ang_e,Cents,len_e,bads,unsure]=SmoothOsScanning(ang_e,t,Cents,len_e,...
    vidfn,sm_len,eccent,area_e,FrameNum);
% RemoveData(AllN,AllN,bads,FRLEN);
% unsure=unsure(setdiff(1:length(ang_e),bads));
% unsure=find(unsure);

% unsure=[];
sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
is=setdiff(1:length(sOr),unsure);
sOr(is)=TimeSmooth(AngleWithoutFlip(ang_e(is)),t(is),sm_len);
save(AllN,'ang_e','Cents','len_e','bads','unsure','sOr','-append')

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
figure(3)
plot(Cents(:,1),Cents(:,2),'b.-')
axis equal
set(gca,'YDir','reverse');
figure(4)
cs=[0 0;diff(Cents)];
d=(CartDist(cs));
subplot(2,1,1)
plot(FrameNum,d,'k'); axis tight;
subplot(2,1,2)
plot(FrameNum,cumsum(d),'k'); axis tight;
xlabel('time'); ylabel('distance')
figure(2)
[sOr,unsure,Cents] = AdjOrientsScanning(sOr,Cents,FrameNum,vidfn,unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
axis tight;
% input('Press return to continue');

[EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,len_e);
EndPt=EndPt+Cents;
VToNest=[nest(1)-Cents(:,1),nest(2)-Cents(:,2)];
DToNest=sqrt(sum(VToNest.^2,2));
OToNest=cart2pol(VToNest(:,1),VToNest(:,2));
NestOnRetina=AngularDifference(OToNest,sOr');

for i=1:size(LM,1)
    LMs(i).LM=LM(i,:);
    LMs(i).LMWid=LMWid(i);
    LMs(i).VToLM=[LM(i,1)-Cents(:,1),LM(i,2)-Cents(:,2)];
    LMs(i).DToLM=sqrt(sum(LMs(i).VToLM.^2,2));
    LMs(i).OToLM=cart2pol(LMs(i).VToLM(:,1),LMs(i).VToLM(:,2));
    LMs(i).LMOnRetina=AngularDifference(LMs(i).OToLM,sOr');
end
if(size(LM,1)==1)
    VToLM=[LM(1)-Cents(:,1),LM(2)-Cents(:,2)];
    DToLM=sqrt(sum(VToLM.^2,2));
    OToLM=cart2pol(VToLM(:,1),VToLM(:,2));
    LMOnRetina=AngularDifference(OToLM,sOr');
end
clear i f s fn is i_out a
save(AllN)

% function GetShadDataWhole(AllN,ff);
% load([ff 'ALev.mat'])
% % Check Shadow Data
% if(aLevel~=500)
%     load(AllN)
%     load([ff 'NestLMData.mat']);
%     [refim]=MyAviRead([ff '.avi'],refim,1);
%     sAdjusted=find(Areas>aLevel);
%     AllN
%     for ind=sAdjusted
%         fr=floor(0.5*(FrameNum(ind)+1));
%         f=MyAviRead([ff '.avi'],fr,1);
%         dif=imsubtract(refim,f);
%         [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]=FindBeeExpt2_WholeShadow(dif,f,sLevel);
%         if(nb==1)
%             Cents(ind,:)=c;
%             area_e(ind)=ae;
%             EPt(ind,:)=ep;
%             elips(ind)=el;
%             len_e(ind)=le;
%             eccent(ind)=ec;
%             d=abs(AngularDifference(ang_e(ind),oe));
%             if(d>pi/2)
%                 if(oe<0) ang_e(ind)=oe+pi;
%                 else ang_e(ind)=oe-pi;
%                 end
%                 d=d-pi;
%             else ang_e(ind)=oe;
%             end
%             [ind sAdjusted(end) d*180/pi]
%             save(AllN,'sAdjusted','ang_e','elips','area_e','EPt','eccent',...
%                 'len_e','Cents','-append');
%         end
%     end
% end

function[interf]=CheckInterferingShadows(pn)
imagesc(MyAviRead(pn,1,1))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end