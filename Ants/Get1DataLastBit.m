function Get1DataLastBit(AllN)

load(AllN)
vidfn=[AllN(1:end-7) '.avi'];
[vO,vObj]=VideoReaderType(vidfn);

finp=ForceNumericInput('have you checked shadows? 1 to check; 0 skip: ',1);
if(finp==1)
    % Check Shadow Data: first argument is whether to check data 'live' or not
    proc=CheckShadowsBySize(1,Areas,sLevel,vidfn,vObj,AllN,FrameNum,thresh,Cents,EPt,EndPt,elips);
    if(proc)
        load(AllN)
    end
end

if(finp~=1)
    finp=ForceNumericInput('have you checked gaps? 1 to check; 0 skip: ',1);
end
if(finp==1)
    % check any gaps
    isadd=beecoordsCheckGaps(vidfn,FRLEN,vObj);
    if(isadd)
        load(AllN);
    end
end

if(finp~=1)
    finp=ForceNumericInput('have you checked bees over the nest? 1 to check; 0 skip: ',1);
end
if(finp==1)
    % check whether any bees that are on the nest have been missed
    isadd=beecoordsCheckNest(vidfn,FRLEN,vObj);
    if(isadd)
        load(AllN);
    end
end

if(finp~=1)
    finp=ForceNumericInput('have you checked flips? 1 to check; 0 skip: ',1);
end

if(finp==1)

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

    % show and flip bees: this is currently not used hence i've not put it
    % ShowAndFlipBees in it's own m-file
    if(isequal(checkflips,5))
                
        [ang_e,EPt]=ShowAndFlipBees(vidfn,t,FrameNum,Cents,EPt,elips,vObj,...
            len_e,ang_e,AllN);
        load AllN;
    end
    copyfile(AllN,[AllN(1:end-7) 'Check.mat']);
end

% Smooth the data
sm_len=0.1;
[ang_e,Cents,len_e,bads,unsure,ignore,setvals,nx]=SmoothOsExpt2(ang_e,t,Cents,len_e,vidfn,...
    sm_len,eccent,area_e,vObj,FrameNum,1);

save(AllN,'ang_e','Cents','len_e','bads','unsure','ignore','setvals','nx','sm_len','-append')

% this is a change from 16-11-2013
% decision is to smooth the data *AFTER* the final adjustment
% however will still smooth here so we can display that in the 
% final check AdjOrients2012

% Re-do the smooth without unsure ones
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
% change 16-11-2013
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

% now smooth the data: change 16-11-2013 - prior to this this was done in
% before the final ADjustOrients

% smooth then re-do the smooth without unsure ones
o=AngleWithoutFlip(ang_e);
sOr=TimeSmooth(o,t,sm_len);
is=setdiff(1:length(ang_e),unsure);
sOr(is)=TimeSmooth(o(is),t(is),sm_len);

% now process the rest of the data and finish
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
clear i f s fn is i_out a bads
save(AllN)
a=AngleWithoutFlip(sOr)*180/pi;
plot(t,a,'g',t(unsure),a(unsure),'r.');


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

