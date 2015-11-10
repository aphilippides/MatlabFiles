function GetAllData_2012

UseAvi=0;
if(UseAvi)
    FList12=dir('*.avi');
    disp('**** using avis not FileList ****')
else
    load FileList.mat;
end

% vO=1 means use videoReader, 0 = use mmread (slow)
% this is now defunct as I'm doing a check but leave this for reference
% vO=0;

x=cd;
IntS=[];
IntFs=[];

% time between half-frames
FRLEN=0.02;

if(isempty(FList12)) 
    disp(['No Files to process in folder ' x]); 
end;
for i=1:length(FList12)
    fn=FList12(i).name;
    bfn=ProcessBeeFileName2012(fn);
%     if(i>3)
    [int2str(i) ':  ' fn]
    pn=fn(1:end-4);
    ProgN=[pn '_Prog.mat'];
%     ProgN=[pn '_ProgWhole.mat'];
    PathN=[pn 'Path.mat'];
    AllN=[pn 'All.mat'];
    inp=1;
    if(~isfile(ProgN))
        disp(['File ' ProgN ' does not exist. Skipping to next file']);
    elseif(isfile(AllN)) 
        disp(['File ' AllN ' exists. Skipping to next file']);
%         inp=input('type 1 to overwrite, else to continue\n');
%     end
%     if(inp==1)
    elseif(bfn.ftype~=1)
%         RemoveAllEdges(ProgN,fn);
%        RemoveAllShadows(ProgN,fn);
    %     GetNestAndLMData(pn); 
        s=dir(ProgN);
        sze=s.bytes/1e6;
        if(sze<10)


            % old - in here for reference
            %             if(vO)
            %                 vObj=VideoReader(fn);
            %             else
            %                 vObj=[];
            %             end
            if(exist('vO','var'))
                [vO,vObj]=VideoReaderType(fn,vO);
            else
                [vO,vObj]=VideoReaderType(fn);
            end
            if 1%(~isfile(PathN))
                [d,rms]=GetPathsExpt2(pn,ProgN,FRLEN,vObj);
            else
                d=0;
                rms=[];
            end
            if(d==-1) disp(['No Bees in file ' ProgN ' !!!'])
            else
                bs=[];%input('enter which bees to remove, or return: ');
                ts=[];%input('enter which times to remove, or return: ');
                %             flips=input('enter which times to flip, or return')
                flips=[];
                Get1Data(PathN,bs,ts,flips,rms,AllN,pn,FRLEN,fn,vObj);
                disp(['File ' AllN ' generated']);%Press return to continue']);
            end
        end
%         pause;
    end
%     if(CheckInterferingShadows(pn,vObj)) 
%         IntS=[IntS i]; 
%         IntFs=s(IntS);
%         save InterferingShadows IntS IntFs
%     end;
%     if(isfile([pn 'ALev.mat'])) 
%         
% %         GetShadData(AllN,pn,vObj);
% %         GetShadDataWhole(AllN,pn,vObj);
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


function[ang_e,EPt]=ShowAndFlipBees(fn,t,fra,Cents,EPt,elips,...
    vObj,len_e,ang_e,AllN)
sp=1;
figs=[2,1,3];
badang=60;
while 1
    % find all 'bad' points
    ds=AngularDifference(ang_e)*180/pi;
    ovs=find(abs(ds)>=badang);
    
    % plot the angle in fig 3
    as=AngleWithoutFlip(ang_e)*180/pi;
    figure(figs(3))
    subplot(2,1,1)
    plot(fra,as,fra(ovs),'b.-',as(ovs),'k*');
    ylabel('body angle unwrapped')
    subplot(2,1,2)
    plot(fra,ang_e*180/pi,'b.-',fra(ovs),ang_e(ovs)*180/pi,'k*');
    ylabel('body angle')

    % find first and 2nd 'bad' point past previous start
    nx=find(ovs>=sp,1);
    if(isempty(nx))
        ep=length(ang_e);
    else
        sp=max(ovs(nx)-2,1);
        if(length(ovs)>nx)
            ep=ovs(nx+1);
        else
            ep=length(ang_e);
        end
    end
    % suggest this as a start pt and force non-empty input
    while 1
        inp=input(['enter start point, suggest' int2str(sp) '; -1 to end']);
        if(isempty(inp))
        elseif(isequal(inp,-1))
            return;
        else
            sp=inp;
            break;
        end
    end
    
    % plot the whole trace in fig 1
    hold off
    figure(figs(2))
    f=MyAviRead(fn,floor(0.5*(fra(sp)+1)),vObj);
    imagesc(f);
    hold on;
    is=sp:ep;
    plot(EPt(:,1),EPt(:,2),'k.',EPt(is,1),EPt(is,2),'r.')
    plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]','r')
    
    % plot the individual bees in fig 2 and get a start point
    sp=ShowSingleBees(sp,fn,fra,Cents,EPt,elips,vObj,'start',figs);
    if(~isempty(sp))
        % get the next end point
        nx=find(ovs>sp,1);
        if(isempty(nx))
            ep=max(length(ang_e)-3,sp);
        else
            ep=max(ovs(nx)-2,sp);
        end
        while 1
            % get an end flip point
            inp=input(['enter end point, suggest' int2str(ep) ...
                '; -1 to skip']);
            if(isempty(inp))
            elseif(inp>0)
                ep=ShowSingleBees(inp,fn,fra,Cents,EPt,elips,vObj,'end',figs);
                % flip the angles and move on
                if(~isempty(ep))
                    is=sp:ep;
                    ang_e(is)=ang_e(is)+pi;
                    ang_e(ang_e>pi)=ang_e(ang_e>pi)-2*pi;
                    sp=ep;
                    [EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
                    EPt=EPt+Cents;
                    save(AllN,'ang_e','EPt','-append')
                    break;
                end
            else
                break;
            end
        end
    end
% % old version
% while 1
%     ds=AngularDifference(ang_e,Cent_Os)*180/pi;
%     as=AngleWithoutFlip(ang_e)*180/pi;
%     asd=as+abs(ds);
%     ovs=abs(ds)>=90;
%     figure(1)
%     plot(t,as,t,asd,'r',t(ovs),asd(ovs),'k.')
%     figure(2),plot(t,abs(ds));
%     flips=input('enter which times to flip, or return to end')
%     if(isempty(flips)) break; end;
%     % flip any that need flipping
%     iflips=GetTimes(t,flips);
%     for i=iflips
%         if(ang_e(i)<0) ang_e(i)= ang_e(i)+pi;
%         else ang_e(i)= ang_e(i)-pi;
%         end
%     end
% end
% [EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
% EPt=EPt+Cents;
% save(AllN,'ang_e','EPt','-append')

end



function[nsp]=ShowSingleBees(sp,fn,FrameNum,Cents,EPt,elips,vObj,str,figs)
figure(figs(2))
hold on
nsp=[];
while 1
    fr=floor(0.5*(FrameNum(sp)+1));
    f=MyAviRead(fn,fr,vObj);
    figure(figs(1))
    imagesc(f);
    hold on
    plotb(sp,Cents,EPt,[],elips,'b')
    hold off
    figure(figs(2))
    plot(EPt(sp,1),EPt(sp,2),'ko')
    
    inp=input(['i = ' int2str(sp) '; return more bees; 0 to stop;' ...
        'value for ' str ' of flip']);
    if(isempty(inp))
        sp=sp+1;
        if(sp>length(FrameNum))
            break;
        end
    elseif(inp==0)
        break
    else
        nsp=inp;
        break;
    end;
end



function[l]=Get1Data(PathN,bees_out,TsRemoved,flips,rms,AllN,ff,FRLEN,vidfn,vObj)

% load the direction of north and the scaling factor
load([AllN(1:end-7) 'NestLMData.mat'],'cmPerPix','compassDir')

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
edges=[];%find(OutofBounds(Bounds,[ff 'NestLMData.mat'])==1);
removed=union([is edges rms],GetTimes(t,TsRemoved));
% Remove all unwanted points
RemoveData(PathN,AllN,removed,FRLEN)
load(AllN)
save(AllN,'cmPerPix','compassDir','-append')

while 1
    badbs=find(diff(FrameNum)==0);
    if(isempty(badbs))
        break;
    else
        CheckDoubles(AllN,FrameNum,badbs,vidfn,vObj,...
            Cents,EPt,EndPt,elips,FRLEN)
        load(AllN)
    end
end

for i=1:length(FrameNum)
    if(ismember(FrameNum(i),FrameNum(i+1:end)))
        badbs=[badbs i];
    end
end
if(~isempty(badbs))
    disp('problem with checking doubles; exit, move this file for processing later and email Andy')
    keyboard;
end

% eval('ThreshV=thresh');
% Check Shadow Data: first argument is whether to check data 'live' or not
proc=CheckShadowsBySize(1,Areas,sLevel,vidfn,vObj,AllN,FrameNum,thresh,Cents,EPt,EndPt,elips);
if(proc)
    load(AllN)
end

% check any gaps
disp(' ')
disp('Now checking for any gaps in the bee trace')
isadd=beecoordsCheckGaps(vidfn,FRLEN,vObj);
if(isadd)
    load(AllN);
end

% check whether any bees that are on the nest have been missed
disp(' ')
disp('Now checking for any gaps when bees are over the nest')
isadd=beecoordsCheckNest(vidfn,FRLEN,vObj);
if(isadd)
    load(AllN);
end

% better clean orients: should probably use the velocity here depending on
% if it seems to need it
% CleanOrients_Better;
% first find all gaps of greater than 1 frame
gaps=[1 find(diff(FrameNum)>2)+1 length(FrameNum)+1];
for i=1:(length(gaps)-1)    
    is = gaps(i):(gaps(i+1)-1);
    o1s=CleanOrients(ang_e(is));
    o2s=CleanOrients(ang_e(is),1);
    d1s=AngularDifference(o1s',Cent_Os(is));
    d2s=AngularDifference(o2s',Cent_Os(is));
    b1=length(find(abs(d1s)>(pi/2)));
    b2=length(find(abs(d2s)>(pi/2)));
    if(b1<b2) 
        ang_e(is) = o1s;
    else
        ang_e(is) = o2s;
    end
end

num2plot=[2 4];
disp('  ')
disp('  ')
disp('Now put the cursor over the figure to look for flips') 
[checkflips]=PlotBeesSeq(vidfn,AllN,ang_e,len_e,WhichB,EPt,Cents,LM,LMWid,nest,NestWid,...
    EndPt,elips,FrameNum,FRLEN,vObj,num2plot);
load(AllN)

% show and flip bees: this is currently not used
if(isequal(checkflips,5))
    [ang_e,EPt]=ShowAndFlipBees(vidfn,t,FrameNum,Cents,EPt,elips,vObj,...
        len_e,ang_e,AllN);
    load AllN;
end


copyfile(AllN,[AllN(1:end-7) 'Check.mat']);
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
sm_len=0.1;
% [ang_e,Cents,len_e,bads,unsure]=SmoothAll_Expt2(ang_e,t,Cents,len_e,[ff '.avi'],sm_len);
[ang_e,Cents,len_e,bads,unsure,ignore,setvals,nx]=SmoothOsExpt2(ang_e,t,Cents,len_e,vidfn,...
    sm_len,eccent,area_e,vObj,FrameNum);

save(AllN,'ang_e','Cents','len_e','bads','unsure','ignore','setvals','nx','sm_len','-append')

% RemoveData(AllN,AllN,bads,FRLEN);
% load(AllN)
% unsure=unsure(setdiff(1:length(ang_e),bads));
% unsure=find(unsure);

% Re-do the smooth without unsure ones
% this has changed from 16-11-2013
goodis=setdiff(1:length(ang_e),bads);
o=AngleWithoutFlip(ang_e);
sOr=o;
sOr(goodis)=TimeSmooth(o(goodis),t(goodis),sm_len);
is=setdiff(goodis,unsure);
sOr(is)=TimeSmooth(o(is),t(is),sm_len);

% Final Check for any really bad ones
while(1)
    a=input('input 0 to continue\n','s');
    if(isequal(a,'0')) break; end;
end 
[ang_e,unsure,Cents,len_e,bads]=AdjOrients2012(ang_e,Cents,FrameNum,vidfn,...
    unsure,len_e,vObj,bads,sOr,AllN);
% [sOr,unsure,Cents,len_e,bads]=AdjOrients2012(sOr,Cents,FrameNum,vidfn,...
%     unsure,len_e,vObj,bads);
save(AllN,'ang_e','Cents','len_e','bads','unsure','-append')

% get the unsure frames and the ignore frames
unsure=setdiff(unsure,bads);
[ignore i]=setdiff(ignore,bads);
setvals=setvals(i);

% get the frame numbers of the unsure/ignore
unsureFrs=FrameNum(unsure);
ignoreFrs=FrameNum(ignore);
save(AllN,'unsure','ignore','ignoreFrs','setvals','unsureFrs','-append');

%then remove the bad ones
RemoveData(AllN,AllN,bads,FRLEN);
% sOr=sOr(setdiff(1:length(sOr),bads));
load(AllN)

% get the new frames of the unsure/ignore
clear unsure ignore bads
unsure=[];
for i=1:length(unsureFrs)
    unsure(i)=find(FrameNum==unsureFrs(i));
end
% not really sure why I'm doing the ignore bits: kind of just in case but
% shouldn't really redo this bit
ignore=[];
for i=1:length(ignoreFrs)
    ignore(i)=find(FrameNum==ignoreFrs(i));
end
save(AllN,'unsure','ignore','setvals','-append')

% now smooth the data: change 16-11-2013 - prior to this this was done 
% before the final ADjustOrients

% smooth then re-do the smooth without unsure ones
o=AngleWithoutFlip(ang_e);
sOr=TimeSmooth(o,t,sm_len);
is=setdiff(1:length(ang_e),unsure);
sOr(is)=TimeSmooth(o(is),t(is),sm_len);

% now process the rest of the data and finish
[EndPt(:,1),EndPt(:,2)]=pol2cart(sOr,len_e);
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

clear i f s fn is i_out a bads
save(AllN)
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');
input('Press return to continue');


function CheckDoubles(AllN,FrameNum,badbs,vidfn,vObj,Cents,EPt,EndPt,elips,FRLEN)
rms=[];
%     inp=input('Enter 0 to check doubles. -1 for keyboard');
%     if(inp==-1)
%         keyboard;
%     elseif(inp==0)
disp(' ');
disp('Checking doubles');
figure(2);clf;
figure(3);clf;
for i1=badbs
    i2=i1+1;
    figure(2)
    fr=floor(0.5*(FrameNum(i1)+1));
    f=MyAviRead(vidfn,fr,vObj);
    imagesc(f);
    plotb(i1,Cents,EPt,EndPt,elips,'g')
    figure(3)
    imagesc(f);
    plotb(i2,Cents,EPt,EndPt,elips,'g')
%     inp=input(['t = ' num2str(FrameNum(i1)*FRLEN) ...
%         '; press 2 to remove fig 2, 3 for fig 3, 0 for both, -1  keyboard']);
    inp=input('2 to remove fig 2; 3: fig 3; 0: both: -1 keyboard: ');
    if(isequal(inp,-1))
        keyboard;
    elseif(isequal(inp,2))
        rms=[rms i1];
    elseif(isequal(inp,3))
        rms=[rms i2];
    else
        rms=[rms i1 i2];
    end
    %         end
end;
RemoveData(AllN,AllN,rms,FRLEN)

function RemoveData(fnin,fnout,i_out,FRLEN,set_os)
load(fnin);
is=setdiff(1:length(WhichB),i_out);
FrameNum=FrameNum(is);
t=FrameNum*FRLEN;
Areas=Areas(is);
Cents=Cents(is,:);
if(nargin<5) 
    Orients=Orients(is);
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
