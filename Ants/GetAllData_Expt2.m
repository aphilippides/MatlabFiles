function GetAllData_Expt2
s=dir('*.avi');
% s=dir('2E20 11*.avi');
x=cd;
IntS=[];IntFs=[];

FRLEN=0.02;
disp('do FRLEN thing')
keyboard;
if(isempty(s)) disp(['No Files to process in folder ' x]); end;
for i=7%1:length(s)
    bfn=ProcessBeeFileName2012(s(i).name);
%     if(i>3)
    fn=s(i).name;[int2str(i) ':  ' fn]
    pn=fn(1:strfind(fn,'.avi')-1);
    ProgN=[pn '_Prog.mat'];
%     ProgN=[pn '_ProgWhole.mat'];
    PathN=[pn 'Path.mat'];
    AllN=[pn 'All.mat'];
    inp=1;
    if(isfile(AllN)) 
        disp(['File ' AllN ' exists. Skipping to next file']);
%         inp=input('type 1 to overwrite, else to continue\n');
%     end
%     if(inp==1)
    elseif(bfn.ftype~=1)
%         RemoveAllEdges(ProgN,fn);
%        RemoveAllShadows(ProgN,fn);
    %     GetNestAndLMData(pn); 
        [d,rms]=GetPathsExpt2(pn,ProgN);
        if(d==-1) disp(['No Bees in file ' ProgN ' !!!'])
        else
            bs=input('enter which bees to remove, or return')
            ts=input('enter which times to remove, or return')
%             flips=input('enter which times to flip, or return')
            flips=[];
            Get1Data(PathN,bs,ts,flips,rms,AllN,pn);
            disp(['File ' AllN ' generated.\nPress return to continue']);
        end
        pause;
    end
%     if(CheckInterferingShadows(pn)) 
%         IntS=[IntS i]; 
%         IntFs=s(IntS);
%         save InterferingShadows IntS IntFs
%     end;
%     if(isfile([pn 'ALev.mat'])) 
%         
% %         GetShadData(AllN,pn);
% %         GetShadDataWhole(AllN,pn);
%           Get1DataLastBit(AllN,pn);
%           disp(['File ' AllN ' generated.\nPress return to continue']);
%          pause;
%           delete([pn 'ALev.mat'])
%      end

    %     end
end

function plotb(is,c1,e1,e2,ell,col)
bw=50;
hold on;
plot(e1(is,1),e1(is,2),[col '.'])%,e2(is,1),e2(is,2),'w.')
plot([c1(is,1) e1(is,1)]',[c1(is,2) e1(is,2)]',col)
% plot([c1(is,1) e2(is,1)]',[c1(is,2) e2(is,2)]','w')
for i=is 
    plot(ell(i).elips(:,1),ell(i).elips(:,2),col) 
end
a1=round(mean(c1(is,:),1)-bw);
a2=round(mean(c1(is,:),1)+bw);
axis([a1(1) a2(1) a1(2) a2(2)])
hold off

function[l]=Get1Data(PathN,bees_out,TsRemoved,flips,rms,AllN,ff);
load(PathN);
% Get data to get rid of
is=[];
% Select bees to get rid of
for i=bees_out 
    is=union(is,find(WhichB==i)); 
end;

% Get rid of certain times
t=FrameNum*0.02;

% Get rid of data too close to the boundary
edges=[];%find(OutofBounds(Bounds,[ff 'NestLMData.mat'])==1);
removed=union([is edges rms],GetTimes(t,TsRemoved));
% Remove all unwanted points
RemoveData(PathN,AllN,removed)

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
            fr=floor(0.5*(FrameNum(i1)+1));
            f=MyAviRead([ff '.avi'],fr,1);
            imagesc(f);
            plotb(i1,Cents,EPt,EndPt,elips,'g')
            figure(3)
            imagesc(f);
            plotb(i2,Cents,EPt,EndPt,elips,'g')
            inp=input(['t = ' num2str(FrameNum(i1)*0.02) '; press 2 to rmove fig 2, 3 for fig 3, 0 for both']);
            if(inp==2) rms=[rms i1]
            elseif(inp==3) rms=[rms i2];
            else rms=[rms i1 i2];
            end
        end
    end;
    RemoveData(AllN,AllN,rms)
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
    figure(2),plot(t,abs(ds));
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
    figure(1),plot(Areas(i1))
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
            fr=floor(0.5*(FrameNum(ind)+1));
            f=MyAviRead([ff '.avi'],fr,1);
            imagesc(f);
            plotb(ind,Cents,EPt,EndPt,elips,'g')
        else break;
        end
    end
    ind=i1(1);
    fr=floor(0.5*(FrameNum(ind)+1));
    f=MyAviRead([ff '.avi'],fr,1);
    a1=round(mean(Cents(ind,:),1)-50);
    a2=round(mean(Cents(ind,:),1)+50);
    im2=f(a1(2):2:a2(2),a1(1):2:a2(1),:);
    im=f(a1(2):a2(2),a1(1):a2(1),:);
    imbw2=double(rgb2gray(im2));
    imbw=double(rgb2gray(im));
    while 1
        figure(1)
        BW=double(imbw<sLevel);
        [B,L] = bwboundaries(BW,'noholes');
        imagesc(im)
        hold on
        title(['Shadow level ' num2str(sLevel)])
        for k = 1:length(B)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'g');
        end
        hold off
        figure(2)
        BW=double(imbw2<sLevel);
        [B,L] = bwboundaries(BW,'noholes');
        imagesc(im2)
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
    save(AllN,'sLevel','-append')
    save(AllN,'aLevel','refim','-append');
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
%     RemoveData(AllN,AllN,onNest);
%     clear badFrames bads
%     load(AllN)
% end

% Smooth the data
sm_len=0.1;
% [ang_e,Cents,len_e,bads,unsure]=SmoothAll_Expt2(ang_e,t,Cents,len_e,[ff '.avi'],sm_len);
[ang_e,Cents,len_e,bads,unsure]=SmoothOsExpt2(ang_e,t,Cents,len_e,...
    [ff '.avi'],sm_len,eccent,area_e,[],FrameNum);

% RemoveData(AllN,AllN,bads);
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

disp(' this has been changed in GetAllData_2012 to remove bads etc')
disp(' prob need to update to AdjOrients2012')
% [sOr,unsure,Cents,len_e,bads]=AdjOrients2012(sOr,Cents,FrameNum,vidfn,...
%    unsure,len_e,vObj,bads);
keyboard;
[sOr,unsure,Cents] = AdjOrients(sOr,Cents,FrameNum,[ff '.avi'],unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
input('Press return to continue');

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

function RemoveData(fnin,fnout,i_out,set_os)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
t=FrameNum*0.02;
Areas=Areas(is);
Cents=Cents(is,:);
if(nargin<4) Orients=Orients(is);
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
odev=odev(is);
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

function Get1DataLastBit(AllN,ff);
load(AllN)
% Smooth the data
sm_len=0.1;
% [ang_e,Cents,len_e,bads,unsure]=SmoothAll_Expt2(ang_e,t,Cents,len_e,[ff '.avi'],sm_len);
[ang_e,Cents,len_e,bads,unsure]=SmoothOsExpt2(ang_e,t,Cents,len_e,...
    [ff '.avi'],sm_len,eccent,area_e,[],FrameNum);

sOr=TimeSmooth(AngleWithoutFlip(ang_e),t,sm_len);
is=setdiff(1:length(sOr),unsure);
sOr(is)=TimeSmooth(AngleWithoutFlip(ang_e(is)),t(is),sm_len);
save(AllN,'ang_e','Cents','len_e','bads','unsure','sOr','sm_len','-append')
% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
[sOr,unsure] = AdjOrients(sOr,Cents,FrameNum,[ff '.avi'],unsure,len_e,AllN);
% unsure=union(bads,unsure);
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
input('Press return to continue');

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
clear i is a
save(AllN)

function GetShadDataWhole(AllN,ff);
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
        [a,c,a,a,a,nb,a,a,ae,ep,oe,el,le,ec]=FindBeeExpt2_WholeShadow(dif,f,sLevel);
        if(nb==1)
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
end

function[interf]=CheckInterferingShadows(pn)
imagesc(MyAviRead(pn,1,1))
n=input('1 if interfering; else if not','s');
if(isequal(n,'1')) interf=1;
else interf=0;
end