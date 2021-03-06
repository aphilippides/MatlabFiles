% function[outf,rms]=GetPathsScanning(fn,outf,vidf,lmn)
%  
% function gets and joins paths from the auto extraction of the data
% fn is the datafile to be processed, outf is the 'Path' 1st stage output
% file, vidf is the videofile, lmn is the nest data file

function[outf,rms]=GetPathsScanning(fn,outf,vidf,lmn,FRLEN)

load(fn);
if(sum(NumBees)==0) outf=-1; rms=[]; return; end;
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

save(outf,'FrameNum','MeanCol', 'WhichB', ...
    'Areas','NumBees','Cents','Orients','EndPt','Bounds','NLess', ...
    'area_e','EPt','elips','odev','ang_e','len_e','eccent',...
    'Speeds','Vels','Cent_Os','nest','LM','LMWid','NestWid');

if(nargin<1) rms=ShowAntPath(outf,FRLEN);
else rms=ShowAntPath(outf,FRLEN,vidf,1,2,lmn);
end

function[rms]=ShowAntPath(fnm,FRLEN,vidf,PrettyPic,x,NestLMfn)
rms=[];
load(fnm);
i=strfind(fnm,'Path');
fi=fnm(1:i-1);
if(nargin<6) load([fi 'NestLMData.mat']);
else load(NestLMfn);
end

if(nargin < 5) x=1; end
if(nargin < 4) PrettyPic=1; end

figure(1);
hold off;
if(PrettyPic)
    fn=[fi '.mov'];
    f=MyAviRead(fn,1,1);
    imagesc(f);axis equal
    hold on;
    MyCircle(nest,NestWid/2,'g');
    MyCircle(LM,LMWid/2,'r');
else
    MyCircle(nest,NestWid/2,'g');
    hold on;
    MyCircle(LM,LMWid/2,'r');
    axis equal
end
[EndPt(:,1) EndPt(:,2)]=pol2cart(Orients,10);
EndPt=EndPt+Cents;
[EPt(:,1) EPt(:,2)]=pol2cart(ang_e,len_e);
EPt=EPt+Cents;

cs = ['b';'g';'r';'c';'y'];
ilist=unique(WhichB);
count=1;
str=[];
inp=[];
for i=ilist
    is=[];
    ks = find(WhichB==i);
    is=ks(1:x:end);
    col=cs(mod(count,5)+1,:);
    figure(1);
    hold on;
    %for is=1:n
    plot(EPt(is,1),EPt(is,2),[col '.'])
    plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
    str=[str int2str(i) ' ' int2str(FrameNum(is(1))) ' ' col ' ' int2str(length(is)) '; '];
    text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
    %end
    %     for k=1:100:length(is)
    if(isempty(inp)|inp==0)
        figure(2)
        for k=1:4:length(is)
            fr=FrameNum(is(k));
            f=MyAviRead(fn,fr,1);
            figure(2)
            imagesc(f);axis equal
            plotb(is(k),Cents,EPt,EndPt,elips,col)
            figure(1),plot(EPt(is(k),1),EPt(is(k),2),'k.')
            inp=input(['t = ' num2str(FrameNum(is(k))*FRLEN) '; return to continue; 0 to stop; -1 to end']);
%             inp=input(['Frame: ' int2str(FrameNum(is(k))) '; return to continue; 0 to stop; -1 to end']);
            if((inp==0)|(inp==-1)) break; end;
        end
    end
    count = count + 1;
end
figure(1)
xlabel(str)
hold off;
title(fi)
str
% [rms,xLevel]=RemoveEdges(Cents,EPt,EndPt,elips,fnm);
[shads,sLevel]=RemoveShadows(MeanCol,Cents,EPt,EndPt,elips,fnm,FrameNum,fn);
figure(1)
rms=union(shads,rms);
goods =setdiff([1:length(ang_e)],rms);
if(~isempty(rms))
    ilist=unique(WhichB(goods));
    count=1;
    str=[];
    inp=[];
    figure(1),hold off; imagesc(f);
    for i=ilist
        is=[];
        ks = find(WhichB==i);
        ks = intersect(goods,ks);
        is=ks(1:x:end);
        col=cs(mod(count,5)+1,:);
        figure(1);
        hold on;
        %for is=1:n
        plot(EPt(is,1),EPt(is,2),[col '.'])
        plot([Cents(is,1) EPt(is,1)]',[Cents(is,2) EPt(is,2)]',col)
        str=[str int2str(i) ' ' num2str(FrameNum(is(1))*FRLEN) ' ' col ' ' int2str(length(is)) '; '];
        text(Cents(is(1),1),Cents(is(1),2),int2str(i),'Color',col)
        %end
        %     for k=1:100:length(is)
        if(isempty(inp)|inp==0)
            figure(2)
            for k=1:4:length(is)
                figure(2)
                PlotBEllipse(fn,is(k),FrameNum,Cents,EPt,EndPt,elips,col)
                figure(1),plot(EPt(is(k),1),EPt(is(k),2),'k.')
                inp=input(['t = ' num2str(FrameNum(is(k))*FRLEN) '; return to continue; 0 to stop; -1 to end']);
                if((inp==0)|(inp==-1)) break; end;
            end
        end
        count = count + 1;
    end
    figure(1)
    xlabel(str)
    hold off;
    title(fi)
    str
end

% badbs=find(diff(FrameNum(goods))==0);
% if(~isempty(badbs))
%     inp=input('Enter 0 to check doubles. -1 for keyboard');
%     if(inp==-1) keyboard;    
%     elseif(inp==0)
%         for i1=badbs
%             i2=i1+1;
%             figure(2)
%             fr=floor(0.5*(FrameNum(i1)+1));
%             f=MyAviRead(fn,fr,1);
%             imagesc(f);
%             plotb(i1,Cents,EPt,EndPt,elips,col)
%             figure(3)
%             imagesc(f);
%             plotb(i2,Cents,EPt,EndPt,elips,col)
%             inp=input(['t = ' num2str(FrameNum(i1)*FRLEN) '; press 2 to remove fig 2, 3 for fig 3, 0 for both']);
%             if(inp==2) rms=[rms i1]
%             elseif(inp==3) rms=[rms i2];
%             else rms=[rms i1 i2];
%             end
%         end
%     end;
% end

function[shads,sLevel]=RemoveShadows(MeanCol,Cents,EPt,EndPt,elips,fnm,FrameNum,fn)
figure(3),hist(MeanCol,40)
shads=[];
sLevel=200;
while 1
    s=input('enter shadow level; return to skip');
    if(~isempty(s))
        sLevel=s;
        shads=find(MeanCol>=sLevel);
        if(isempty(shads)) 
%             sLevel=200;
            break;
        end
        [m,i]=min(MeanCol(shads));
        ind=shads(i(1));
        figure(2)
        PlotBEllipse(fn,ind,FrameNum,Cents,EPt,EndPt,elips,'g');
    else 
        break;
    end
end
save(fnm,'sLevel','shads','-append');

function[edges,xLevel]=RemoveEdges(Cents,EPt,EndPt,elips,fnm)
edges=[];
xLevel=2000;
while 1
    s=input('enter edge level; return to skip');
    if(~isempty(s))
        xLevel=s;
        if(xLevel>700) edges=find(Cents(:,1)>=xLevel)';
        else edges=find(Cents(:,1)<=xLevel)';
        end
    else break;
    end
end
save(fnm,'xLevel','edges','-append');

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
sp=max(sp,50);
dfns = frames(StartPts)-frames(EndPt);
for i=1:length(StartPts)
    PredPos=Cents(EndPt,:)+dfns(i)*vel;
    ds(i) = sqrt(sum((PredPos-Cents(StartPts(i),:)).^2));
end
ifns=find((dfns>0)&(dfns<=40));
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