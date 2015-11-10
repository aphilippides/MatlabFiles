function[outf]=GetPathsExpt2(f)

fn=[f '_Prog.mat'];
fnm=[f '.avi'];
lmn=[f 'NestLMData.mat'];
load(fn);
% lmn=GetNestAndLMData(f); 
load(lmn)

% match ends with near starts
ToTry = unique(WhichB);
while(~isempty(ToTry))
    StartPts=[];EndPts=[];vel=[];PathLength=[];
    ilist=unique(WhichB);
    for j=1:length(ilist)
        v=ilist(j);
        is = find(WhichB==v);
        StartPts(j) = is(1);
        EndPts(j) = is(end);
        if(length(is)>1)
            vel(j,:)=Cents(is(end),:)-Cents(is(end-1),:);
            vs=diff(Cents(is,:))./[diff(FrameNum(is))' diff(FrameNum(is))'];
            sps = sqrt(sum(vs.^2,2));
            d=min(10,length(sps)-1);
            medspeed(j) = median(sps(end-d:end));
        else
            vel(j,:) = [0 0];
            medspeed(j) = 0;
        end
        PathLength(j) = length(is);
%         medspeed(j) = median(sqrt(sum(vel.^2,2)));
    end
    i=ToTry(1);
    ind=find(ilist==i);
    Noti=setdiff(1:length(ilist),ind);
    %    [IsS,iS]=IsEndPt(EndPts(ind),StartPts(Noti),FrameNum,Cents,vel(ind,:));
    [IsS,iS]=IsEndPtPred(EndPts(ind),StartPts(Noti),FrameNum,Cents,vel(ind,:),medspeed(ind));
    if(IsS)
        WhichB=JoinPaths(i,ilist(Noti(iS)),WhichB);
        ToTry=setdiff(ToTry,ilist(Noti(iS)));
    else
        ToTry=setdiff(ToTry,i);
    end
end

ilist=unique(WhichB);

Vels=zeros(size(Cents));
for i=ilist
    is = find(WhichB==i);
    if(length(is)>1)
%         v=diff(Cents(is,:))./[diff(FrameNum(is))' diff(FrameNum(is))'];
%         Vels(is,:)=[v;v(end,:)];
%         Vels(end,:)=Vels(end-1,:);
        v1=MyGradient(Cents(is,1),FrameNum(is));
        v2=MyGradient(Cents(is,2),FrameNum(is));
        Vels(is,:)=[v1' v2'];
    end
end
[Cent_Os,Speeds]=cart2pol(Vels(:,1),Vels(:,2));

% for all paths, check which orientation is consistent
% when bee enters and use that to determine flip

for i=1:length(ilist)
    is = find(WhichB==ilist(i));
    o1s=CleanOrients(Orients(is));
    o2s=CleanOrients(Orients(is),1);
    if(0)%OutofBounds(Bounds(is(1),:),lmn)==1)
        m=min(10,length(is));
        [AvgDir,rel]=MeanAngle(Vels(is(1:m),1),Vels(is(1:m),2));
        d1=abs(AngularDifference(MeanAngle(o1s(1:m)),AvgDir));
        d2=abs(AngularDifference(MeanAngle(o2s(1:m)),AvgDir));
        if(d1<d2) Orients(is) = o1s;
        else Orients(is) = o2s;
        end
    elseif(0)%OutofBounds(Bounds(is(end),:),lmn)==1)
        m=max(1,length(is)-9);
        [AvgDir,rel]=MeanAngle(Vels(is(m:end),1),Vels(is(m:end),2));
        d1=abs(AngularDifference(MeanAngle(o1s(m:end)),AvgDir));
        d2=abs(AngularDifference(MeanAngle(o2s(m:end)),AvgDir));
        if(d1<d2) Orients(is) = o1s;
        else Orients(is) = o2s;
        end
    else
        d1s=AngularDifference(o1s',Cent_Os(is));
        d2s=AngularDifference(o2s',Cent_Os(is));
        b1=length(find(abs(d1s)>(pi/2)));
        b2=length(find(abs(d2s)>(pi/2)));
        if(b1<b2) Orients(is) = o1s;
        else Orients(is) = o2s;
        end
    end
end

% for all paths, check which orientation is consistent
% when bee enters and use that to determine flip
if(~exist('ang_e'))
    [ang_e,len_e]=cart2pol(EPt(:,1),EPt(:,2));
end
for i=1:length(ilist)
    is = find(WhichB==ilist(i));
    o1s=CleanOrients(ang_e(is));
    o2s=CleanOrients(ang_e(is),1);
    d1s=AngularDifference(o1s',Cent_Os(is));
    d2s=AngularDifference(o2s',Cent_Os(is));
    b1=length(find(abs(d1s)>(pi/2)));
    b2=length(find(abs(d2s)>(pi/2)));
    if(b1<b2) ang_e(is) = o1s;
    else ang_e(is) = o2s;
    end
end

[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;

[EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
EPt=EPt+Cents;

outf=[f 'Path.mat'];
save(outf)

ShowBeePathExpt2_Flip(outf,1,2)

% ,'FrameNum','Areas','NumBees','Cents','Orients', ...
%     'WhichB','EndPt','Bounds','MaxDif','Speeds','Vels','Cent_Os',...
%     'nest','LM','LMWid','NestWid','area_e','EPt','elips','odev','ang_e','len_e');

function[Nw]=JoinPaths(st,en,w)
is=find(w==en);
Nw=w;
Nw(is)=st;

function[IsStart, IStart] = IsEndPt(EndPt,StartPts,frames,Cents,vel)
dfns = frames(StartPts)-frames(EndPt);
for i=1:length(StartPts)
    ds(i)=sqrt(sum((Cents(EndPt,:)-Cents(StartPts(i),:)).^2));
end
ifns=find((dfns>0)&(dfns<=8));
if(isempty(ifns))
    IsStart = 0;
    IStart=0;
else
    [md,mi] = min(ds(ifns));
    if(md<(vel*dfns(i)))
        IsStart = 1;
        IStart=ifns(mi);
    else
        IsStart = 0;
        IStart=0;
    end
end

function[IsStart, IStart] = IsEndPtPred(EndPt,StartPts,frames,Cents,vel,sp)
sp=max(sp,20);
dfns = frames(StartPts)-frames(EndPt);
for i=1:length(StartPts)
    PredPos=Cents(EndPt,:)+dfns(i)*vel;
    ds(i) = sqrt(sum((PredPos-Cents(StartPts(i),:)).^2));
end
ifns=find((dfns>0)&(dfns<=16));
if(isempty(ifns))
    IsStart = 0;
    IStart=0;
else
    %    [md,mi] = min(ds(ifns));
    %     if(md<sp)
    %         IsStart = 1;
    %         IStart=ifns(mi);
    poss_is=find(ds(ifns)<sp*1.5);
    if(~isempty(poss_is))
        IsStart = 1;
        [md,mi]=min(dfns(ifns(poss_is)));
        IStart=ifns(mi);
    else
        IsStart = 0;
        IStart=0;
    end
end