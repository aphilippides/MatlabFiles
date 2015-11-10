% ino plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: ino('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function ZigZags(fn,Plotting)

if(nargin<1) fn=['in']; end;
if(nargin<2) Plotting=1; end;

GetData(fn,Plotting);
LookPts
% TRates(fn,Plotting)
% PlotTrates
% PlotDataDists
% keyboard;

function PlotTrates
load TurnRateDataIn
figure(1),
hist(mrs,100),xlim([-600 600])
figure(2),
hist(ralls,100),xlim([-750 750])
figure(3),
hist(rmids,100),xlim([-750 750])
figure(4),
hist(rfasts,100),xlim([-750 750])
keyboard


function TRates(fn,Plotting)

if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end

mrs=[];l1s=[];l2s=[];ralls=[];rfasts=[];rmids=[];
for i=1:4 lm(i).lm=[]; end

for j=1:length(fn)
    j
    load(fn(j).name);
    lmo=LMOrder(LM)
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
    end
    figure(1),[ArcBody]=SelectArcs(sOr,t);
    if(size(ArcBody,1)>1)
        [mr,p,p,p,p,l1,l2,rall,rmid,rfast]=TurnRates(ArcBody,sOr,t,'b',NestOnRetina,OToNest);
        l1s=[l1s l1];  
        l2s=[l2s l2];  
        mrs=[mrs mr];  
        ralls=[ralls rall];
        rmids=[rmids rmid];
        rfasts=[rfasts rfast];
    end
%     save TurnRateDataIn
end

function GetData(fn,Plotting)

if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end

mas=[];mis=[];t_mas=[];t_mis=[];ma2mis=[];c=1;
for i=1:4 lm(i).lm=[]; end

for j=1:length(fn)
    j
    load(fn(j).name);
    lmo=LMOrder(LM)
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
    end
    
    if(Plotting)
        figure(2);
        [arcs,ma,mi,ma2mi,mi2ma]=SelectArcsDist(DToNest,t,0.1,0.1);
    else [arcs,ma,mi,ma2mi,mi2ma]=SelectZigZags(DToNest,t,0.1,0.1);
    end
    
    tn=find(DToNest>5,1);
    if(isempty(tn)|DToNest(1)>5) TNest(j,1)=NaN; 
    else TNest(j,1)=t(tn);
    end
    TNest(j,2)=max(t);
    if(~isempty(ma))
        mas=[mas;[ma(:,1)/max(t) ma]];
        if(isnan(TNest(j,1))) t_mas=[t_mas;[ma(:,1)/max(t) ma]];
        else
            is=find(ma(:,1)>TNest(j,1));
            t_mas=[t_mas;[ma(is,1)/max(t) ma(is,:)]];
        end
    end
    if(~isempty(mi))
        mis=[mis;[mi(:,1)/max(t) mi]];
        if(isnan(TNest(j,1))) t_mis=[t_mis;[mi(:,1)/max(t) mi]];
        else
            is=find(mi(:,1)>TNest(j,1));
            t_mis=[t_mis;[mi(is,1)/max(t) mi(is,:)]];
        end
    end
    if(~isempty(ma2mi))
        ma2mis=[ma2mis; ma2mi ma2mi(:,[1 4])/max(t) ...
            Cents(ma2mi(:,3),:) Cents(ma2mi(:,6),:)];
    end
%     if(~isempty(ma2mi))
%         mi2mas=[mi2mas; mi2ma mi2ma(:,[1 4])/max(t) ...
%             Cents(mi2ma(:,3),:) Cents(mi2ma(:,6),:)];
%     end
    for i=1:size(ma2mi,1)
        ma2miP(c).fnum=j;
        ma2miP(c).is=ma2mi(i,3):ma2mi(i,6);
        ma2miP(c).l=ma2mi(i,6)-ma2mi(i,3);
        ma2miP(c).path=Cents(ma2miP(c).is,:);
        c=c+1;
    end
    
    [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn(j).name,10);
    mi2mas(j).mi2ma=mi2ma;
    mi2mas(j).t=t;
    mi2mas(j).meanT=meanT;
    mi2mas(j).meanTind=meanTind;
    mi2mas(j).in=in;
    mi2mas(j).len=len;
    mi2mas(j).ils=ils;
    
    save DistLoopdataIns
end


function LookPts

load DistLoopdataNest
% divide arcs
narc=10;
nls=zeros(55,2*narc);
nlind=zeros(55,2*narc);
nt_is=zeros(55,2*narc);
for k=1:55
    t=[mi2mas(k).t];
%     ils=[mi2mas(k).ils.is];
%     inds=[mi2mas(k).ils.meanTind];
%     mi2ma=mi2mas(k).mi2ma;
    ils=[mi2mas(k).in];
    inds=[mi2mas(k).meanTind];
    mi2ma=mi2mas(k).mi2ma;
    for i=1:(size(mi2ma,1)-1)
        tr=[mi2ma(i,1) mi2ma(i,4)];
        ts =(tr(2)-tr(1))/narc;
        for j=1:narc
            t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
            lks=intersect(t_is,ils);
            nt_is(k,j)=nt_is(k,j)+length(t_is);
            nls(k,j)=nls(k,j)+length(lks);
            lks=intersect(t_is,inds);
            nlind(k,j)=nlind(k,j)+length(lks);
        end
        tr=[mi2ma(i,4) mi2ma(i+1,1)];
        ts =(tr(2)-tr(1))/narc;
        for j=1:narc
            t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
            nt_is(k,j+narc)=nt_is(k,j+narc)+length(t_is);
            lks=intersect(t_is,ils);
            nls(k,j+narc)=nls(k,j+narc)+length(lks);
            lks=intersect(t_is,inds);
            nlind(k,j+narc)=nlind(k,j+narc)+length(lks);
        end
    end
end
pc=100*nls./nt_is;
gs=find(~isnan(pc(:,1)));
mpc=mean(pc(gs,:));
figure(1)
bar(mpc);
tls=sum(nls,2);
pcls=100*nls./(tls*ones(1,2*narc));
gl=find(~isnan(pcls(:,1)));
mpl=mean(pcls(gl,:));
figure(2)
bar(mpl);
tls=sum(nlind,2);
pcind=100*nlind./(tls*ones(1,2*narc));
gl=find(~isnan(pcind(:,1)));
mpi=mean(pcind(gl,:));
figure(3)
bar(mpi);
keyboard

function PlotDataDists
load DistLoopdata
% Nest phase stuff
figure(1)
gs=find(~isnan(TNest(:,1)));
numNotNan=length(gs)
median(TNest(gs,1))
max(TNest(gs,1))
iqr(TNest(gs,1))
plot(TNest(:,1),TNest(:,2),'o')
grid
axis tight
[r,p] = corrcoef(TNest(gs,1),TNest(gs,2))
p(1,2)
[b,conf,res,rint,stats]=regress(TNest(gs,2),[ones(length(gs),1) TNest(gs,1)]);
hold on
plot([0 25],b(1)+b(2)*[0 25],'r')
[r,stats]=robustfit(TNest(gs,1),TNest(gs,2));
plot([0 25],r(1)+r(2)*[0 25],'k')
xlabel('Nest phase')
ylabel('Flight length')
hold off
% hist(TNest(gs,1),30)
plot(mas(:,2),mas(:,3),'.',mis(:,2),mis(:,3),'ro')
plot(t_mis(:,2),t_mis(:,3),'ro',t_mas(:,2),t_mas(:,3),'.')
plot(mas(:,1),mas(:,3),'.',mis(:,1),mis(:,3),'ro')
plot(t_mis(:,1),t_mis(:,3),'ro',t_mas(:,1),t_mas(:,3),'.')

dis=[0:30];
tb=0.25;cs=0:tb:(1-tb);
for k=1:length(cs)
    c=cs(k);
    is=find((mis(:,1)>c)&(mis(:,1)<=c+tb));
    smi(k,:) = prctile(mis(is,3),[2.5 25 50 75 97.5]);
    mif(k,:)= hist(mis(is,3),dis);
 
    is=find((mas(:,1)>c)&(mas(:,1)<=c+tb));
    sma(k,:) = prctile(mas(is,3),[2.5 25 50 75 97.5]);
    maf(k,:)=hist(mas(is,3),dis);

    is=find((t_mis(:,1)>c)&(t_mis(:,1)<=c+tb));
    tsmi(k,:) = prctile(t_mis(is,3),[2.5 25 50 75 97.5]);
    is=find((t_mas(:,1)>c)&(t_mas(:,1)<=c+tb));
    tsma(k,:) = prctile(t_mas(is,3),[2.5 25 50 75 97.5]);
    
    is=find((ma2mis(:,7)>c)&(ma2mis(:,7)<=c+tb));
%     inds(i).is=is;
%     figure(2*k)
%     plot(ma2mis(is,[9 11])',ma2mis(is,[10 12])','b',...
%         ma2mis(is,9),ma2mis(is,10),'bo',ma2mis(is,11),ma2mis(is,12),'b.')
%     hold on,PlotNestAndLMs(LM,LMWid,nest);hold off; axis equal
%     for i=is'
%         figure(2*k+1)
%         plot(ma2miP(i).path(:,1),ma2miP(i).path(:,2),'b', ...
%             ma2miP(i).path(1,1),ma2miP(i).path(1,2),'bo', ...
%             ma2miP(i).path(end,1),ma2miP(i).path(end,2),'b.')
%         hold on
%     end
%     PlotNestAndLMs(LM,LMWid,nest);
%     hold off; axis equal
end
figure(1)
subplot(2,1,1),bar(cs+0.5*tb,maf),axis tight
subplot(2,1,2),bar(cs+0.5*tb,mif),axis tight
figure(2)
subplot(2,1,1),plot(dis,maf,'LineWidth',2),axis tight
subplot(2,1,2),plot(dis,mif,'LineWidth',2),axis tight

keyboard