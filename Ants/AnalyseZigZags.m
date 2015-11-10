function AnalyseZigZags(out)

% GetLookData
athresh = 10;
NestArc=30;

% Get Data file
% if((nargin<1)||(out==0)) 
%     ino=1;
%     fs=dir('*ZigZagData.mat');
%     fn=['in'];
% else
%     ino=0;
%     fs=dir('*ZZLoopData.mat');
%     fn=['out'];
% end;
% WriteFileOnScreen(fs,1);
% Picked=input('select output file:  ');
% 
% OutFn=fs(Picked).name;
% load(OutFn)

load 2westexamplesoutZZLoopData.mat% 1northZigZagData

InitialDataL(loops)

% [is,is2,is3]=InitialData(zigzag);
% 
% LookPtsV1(zigzag(is))
% LookPtsV1(zigzag(is2))
% LookPtsV1(zigzag(is3))

function InitialDataL(loops)

athresh = 0; 
NestArc=10:5:50;

tdzig=[];tzzig=[];
tdzag=[];tzzag=[];
tdzigL=[];tzzigL=[];
relzigas=[];relzagas=[];

f=[];
mlzig=0;
mlzag=0;
goods=find([loops(:).good]==1);
% cla,
% hold on
for i=1:length(goods)
    %     if(loops(i).good==1)
    compassDir=4.9393;
    if(~isequal(f,loops(goods(i)).fn))
        f=loops(goods(i)).fn;
        load(f);
        lmo=LMOrder(LM);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,f,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,f,t,OToNest,[],[]);
        end
    end
    iall=loops(goods(i)).is;
    
    sp=Cents(iall(1),:);
    c=mean(Cents(iall,:));
    figure(1)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    title(['flight ' f])
    plot(Cents(iall,1),Cents(iall,2),'r')
%     plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'ko','MarkerFaceColor','k')
%     plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'ro','MarkerFaceColor','r')
%     PlotAngLine(ang,c);
    axis equal
            text(Cents(iall(1),1),Cents(iall(1),2),'Start')
            text(Cents(iall(end),1),Cents(iall(end),2),'End','Color','r')
    hold off
end
%     PlotNestAndLMs(LM,LMWid,nest);
% axis equal
zdirs=[zigzag(goods).angs];
zdirs=zdirs(1:2:end);
is=find(((zdirs*180/pi)>230)&((zdirs*180/pi)<320));
is2=find(abs(Ang2Circ(:,5))<=10)';
is3=find(closeps<=5);


function[is,is2,is3]=InitialData(zigzag)

athresh = 0; 
NestArc=10:5:50;

tdzig=[];tzzig=[];
tdzag=[];tzzag=[];
tdzigL=[];tzzigL=[];
relzigas=[];relzagas=[];

f=[];
mlzig=0;
mlzag=0;
goods=find([zigzag(:).good]==1);
% cla,
% hold on
for i=1:length(goods)
    %     if(zigzag(i).good==1)
    compassDir=4.9393;
    if(~isequal(f,zigzag(goods(i)).fn))
        f=zigzag(goods(i)).fn;
        load(f);
        lmo=LMOrder(LM);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,f,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,f,t,OToNest,[],[]);
        end
    end
    iall=zigzag(goods(i)).is;
    
    zigzag(goods(i))=ReCalcZigzags(Cents,Cent_Os,iall,zigzag(goods(i)),compassDir,LM,LMWid,nest)
    sp=Cents(iall(1),:);
    c=mean(Cents(iall,:));
    ang=zigzag(goods(i)).angles(1);
    relzigas=[relzigas AngularDifference(ang,[zigzag(goods(i)).zigas])];
    relzagas=[relzagas AngularDifference(ang,[zigzag(goods(i)).zagas])];

    for j=1:length(NestArc)
        hold on
        [Ang2Circ(i,j),tn]=Ang2Nest(NestArc(j),ang,c,sp);
    end
    [closeps(i),cp]=ClosestPointToNest(c,ang)
%     plot(cp(1),cp(2),'r*')
%     hold off
end
    PlotNestAndLMs(LM,LMWid,nest);
axis equal
zdirs=[zigzag(goods).angs];
zdirs=zdirs(1:2:end);
is=find(((zdirs*180/pi)>230)&((zdirs*180/pi)<320));
is2=find(abs(Ang2Circ(:,5))<=10)';
is3=find(closeps<=5);

function[zz]=ReCalcZigzags(Cents,Cent_Os,iall,zz,compassDir,LM,LMWid,nest)

athresh = 0; 
if(nargin<6) Plotting =0; 
else Plotting=1;
end;
[area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
ep=Cents(iall(1),:);
sp=Cents(iall(end),:);
t2s=cart2pol(sp(1)-ep(1),sp(2)-ep(2));
if(abs(AngularDifference(t2s,angles(1)))>(pi/2)) angles=angles+pi;end
angles=mod(angles,2*pi);
angs=mod(angles-compassDir,2*pi);
dang=AngularDifference(angs(1),Cent_Os(iall))*180/pi;
zigs=iall(find(dang<-athresh));
zags=iall(find(dang>athresh));
[zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,Cents);
[zag1,zag2,lzag,zagas]=GetZigOrZag(zags,Cents);
c=mean(Cents(iall,:));
zz.angs=angs;
zz.zigs=zigs;
zz.zags=zags;
zz.angles=angles;
zz.t2nest=dang;
zz.lzig=lzig;
zz.zigas=zigas;
zz.lzag=lzag;
zz.zagas=zagas;

if(Plotting)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    plot(Cents(iall,1),Cents(iall,2));
    axis equal
    hold off
end

function LookPtsV1(zigzag)

load LookingPtExpt2Data

athresh = 0; 
NestArc=30;

tdzig=[];tzzig=[];
tdzag=[];tzzag=[];
tdzigL=[];tzzigL=[];
tdzagL=[];tzzagL=[];
NoRZi1=[];LoRZi1=[];soRZi1=[];
NoRZi2=[];LoRZi2=[];soRZi2=[];
NoRZa1=[];LoRZa1=[];soRZa1=[];
NoRZa2=[];LoRZa2=[];soRZa2=[];
noRlks=[];loRlks=[];soRlks=[];danglks=[];
noRlksL=[];loRlksL=[];soRlksL=[];danglksL=[];
pcziglks=[];pczaglks=[];pcziglksL=[];pczaglksL=[];
LookDiff=[];LookDiffL=[];
NoR=[];LoR=[];sOrs=[];DAngs=[];fdirZZ=[];
lzigs=[];lzigsL=[];lzags=[];lzagsL=[];
norzz=[];lorzz=[];sorzz=[];coszz=[];dangszz=[]; relsorzz=[];
zzdirs=[];relsorlks=[];relsorlksL=[];

count=0;
for j=1:length(lkpts)
    f=lkpts(j).fn;
    j
    is=[];
    % Check matxhing files
    for i=1:length(zigzag)
        if(isequal(zigzag(i).fn,f))
            if(zigzag(i).good==1) is=[is i]; end;
        end;
    end

    lks=lkpts(j).meanTind;
    lksp=lkpts(j).in;
    lksLM=lkpts(j).ils(1).meanTind;
    lkspLM=lkpts(j).ils(1).is;
    
%     if(~isempty(lks))
    for i=1:length(is)
        if(i==1)
            compassDir=4.9393;
            load(f);
            lmo=LMOrder(LM);
            if(exist('cmPerPix'))
                [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                    ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
            else
                [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                    ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
            end
%             [EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,0.5);
%             EndPt=EndPt+Cents;
%             NoR=[NoR NestOnRetina'];LoR=[LoR LMOnRetina'];sOrs=[sOrs sOr];
        end
        iall=zigzag(is(i)).is;

        zigzag(is(i))=ReCalcZigzags(Cents,Cent_Os,iall,zigzag(is(i)),compassDir,LM,LMWid,nest)
        zzdir=mod(zigzag(is(i)).angs(1),2*pi);
        zzdirs=[zzdirs zzdir];

        [area,axes,angles,ellip] = ellipse(Cents(iall,1),Cents(iall,2),[],0.8535);
      
        dang=AngularDifference(zzdir,Cent_Os(iall))*180/pi;
        zigs=iall(find(dang<-athresh));
        zags=iall(find(dang>=athresh));
        [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,Cents);
        [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,Cents);
        
        NoRZi1=[NoRZi1 NestOnRetina(zig1)'];
        LoRZi1=[LoRZi1 LMOnRetina(zig1)'];
        soRZi1=[soRZi1 sOr(zig1)];
        NoRZi2=[NoRZi2 NestOnRetina(zig2)'];
        LoRZi2=[LoRZi2 LMOnRetina(zig2)'];
        soRZi2=[soRZi2 sOr(zig2)];

        NoRZa1=[NoRZa1 NestOnRetina(zag1)'];
        LoRZa1=[LoRZa1 LMOnRetina(zag1)'];
        soRZa1=[soRZa1 sOr(zag1)];
        NoRZa2=[NoRZa2 NestOnRetina(zag2)'];
        LoRZa2=[LoRZa2 LMOnRetina(zag2)'];
        soRZa2=[soRZa2 sOr(zag2)];
                
        sp=Cents(iall(1),:);
        c=mean(Cents(iall,:));
        % get angle to circle around nest
        [dng,tn]=Ang2Nest(NestArc,angles(1),c,sp);
        
        PlotNestAndLMs(LM,LMWid,nest);
        hold on;
        plot(Cents(iall,1),Cents(iall,2));
        plot(EndPt(lks,1),EndPt(lks,2),'b.')%o','MarkerFaceColor','k')
        plot([Cents(lks,1) EndPt(lks,1)]',[Cents(lks,2) EndPt(lks,2)]','r')
        plot(Cents([zig1 zig2],1),Cents([zig1 zig2],2),'kx')%,'MarkerFaceColor','k')
        plot(Cents([zag1 zag2],1),Cents([zag1 zag2],2),'rx')%,'MarkerFaceColor','r')

        dangs=AngularDifference(zzdir,Cent_Os)*180/pi;
        relso=AngularDifference(zzdir,sOr)*180/pi;
        
        DAngs=[DAngs dangs];
        zzs=[zigs zags];
        inzz=intersect(zzs,lksp);
        noRlks=[noRlks NestOnRetina(inzz)'];
        loRlks=[loRlks LMOnRetina(inzz)'];
        soRlks=[soRlks sOr(inzz)];
        danglks=[danglks dangs(inzz)];
        relsorlks=[relsorlks relso(inzz)];
        
        norzz=[norzz NestOnRetina(zzs)'];lorzz=[lorzz LMOnRetina(zzs)'];
        sorzz=[sorzz sOr(zzs)];coszz=[coszz Cent_Os(zzs)'];  
        dangszz=[dangszz dangs(zzs)];
        relsorzz=[relsorzz relso(zzs)];

        iel=setdiff(iall,zzs);
        NoR=[NoR NestOnRetina(iel)'];LoR=[LoR LMOnRetina(iel)'];sOrs=[sOrs sOr(iel)];
        
        for k=1:length(lks)
            lk=lks(k);
            [td,tz,zz]=Whichzigzag(lk,zig1,zig2,zag1,zag2,t);
            if(zz~=0) LookDiff=[LookDiff dangs(lk)]; end;
            if(zz==1)
                tdzig=[tdzig td];
                tzzig=[tzzig tz];
                lzigs=[lzigs lkpts(j).len(k)];
                pczig=round(100*td/tz)
                text(EndPt(lk,1),EndPt(lk,2)-3,int2str(pczig))
            elseif(zz==2)
                tdzag=[tdzag td];
                tzzag=[tzzag tz];
                lzags=[lzags lkpts(j).len(k)];
                pczag=round(100*td/tz)
                text(EndPt(lk,1),EndPt(lk,2)-3,int2str(pczag))
%             else count=count+1
            end
        end
        for k=1:length(inzz)
            lk=inzz(k);
            [td,tz,zz]=Whichzigzag(lk,zig1,zig2,zag1,zag2,t);
            if(zz==1) pcziglks=[pcziglks round(100*td/tz)];
            elseif(zz==2) pczaglks=[pczaglks round(100*td/tz)];
            end
        end

        inzz=intersect([zigs zags],lkspLM);
        noRlksL=[noRlksL NestOnRetina(inzz)'];
        loRlksL=[loRlksL LMOnRetina(inzz)'];
        soRlksL=[soRlksL sOr(inzz)];
        danglksL=[danglksL dangs(inzz)];
        relsorlksL=[relsorlksL relso(inzz)];
        
        for k=1:length(lksLM)
            lk=lksLM(k);
            [td,tz,zz]=Whichzigzag(lk,zig1,zig2,zag1,zag2,t);
            if(zz~=0) LookDiffL=[LookDiffL dangs(lk)]; end;
            if(zz==1)
                tdzigL=[tdzigL td];
                tzzigL=[tzzigL tz];
                lzigsL=[lzigsL lkpts(j).ils(1).len(k)];
            elseif(zz==2)
                tdzagL=[tdzagL td];
                tzzagL=[tzzagL tz];
                lzagsL=[lzagsL lkpts(j).ils(1).len(k)];
            end
        end      
        for k=1:length(inzz)
            lk=inzz(k);
            [td,tz,zz]=Whichzigzag(lk,zig1,zig2,zag1,zag2,t);
            if(zz==1) pcziglksL=[pcziglksL round(100*td/tz)];
            elseif(zz==2) pczaglksL=[pczaglksL round(100*td/tz)];
            end
        end

        axis equal
        hold off

    end
%     end
end
pczag=round(100*tdzag./tzzag);
pczig=round(100*tdzig./tzzig);
pczigL=round(100*tdzigL./tzzigL);
pczagL=round(100*tdzagL./tzzagL);
keyboard
% save LookPtsDataArcs45

function[td,tz,zz] = Whichzigzag(lk,zig1,zig2,zag1,zag2,t)
for i=1:length(zig1)
    if((zig1(i)<=lk)&((zig2(i)>=lk)))
        td=t(lk)-t(zig1(i));
        tz=t(zig2(i))-t(zig1(i));
        zz=1;
        return;
    end
end
for i=1:length(zag1)
    if((zag1(i)<=lk)&((zag2(i)>=lk)))
        td=t(lk)-t(zag1(i));
        tz=t(zag2(i))-t(zag1(i));
        zz=2;
        return;
    end
end
td=NaN;
tz=NaN;
zz=0;


% j=1;
% while(j<=length(zigzag))
%     j
%     f=zigzag(j).fn;
%     is=j;
%     % Check Others
%     for i=(j+1):length(zigzag)
%         if(isequal(zigzag(i).fn,f)) is=[is i]; end;
%     end
%     j=j+length(is);
%     LookingPtLocations
% end

function LookPts(zigzag)

load LookingPtExpt2Data
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

  
% figure(2),
% for i=1:size(zzangs,1)
%     a=zzangs(i,1);
%     [xs,ys]=pol2cart([a,a+pi],30);
%     plot(xs,ys)
%     hold on
% end;
% hold off

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

function GetLookData
fn=dir('*All.mat')
for j=1:length(fn)
    [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn(j).name,10);
    lkpts(j).fn=fn(j).name;
    lkpts(j).meanT=meanT;
    lkpts(j).meanT=meanT;
    lkpts(j).meanTind=meanTind;
    lkpts(j).in=in';
    lkpts(j).sn=sn;
    lkpts(j).en=en;
    lkpts(j).len=len;
    lkpts(j).ils=ils;
    save LookingPtExpt2Data
end
    
function[fla]=FlushResponse
while 1
    inp=input('0: next file; 1: do another bit; r: redo whole file; z, go back:  ','s');
    if(isequal(inp,'0'))
        fla=0;
        break;
    elseif(isequal(inp,'1'))
        fla=1;
        break;
    elseif(isequal(inp,'r'))
        fla=2;
        break;
    elseif(isequal(inp,'z'))
        fla=3;
        break;
    end
end

function[d,tn]=Ang2Nest(rad,th,p,sp)

a=1;
b=2*p(1)*cos(th)+2*p(2)*sin(th);
c=sum(p.^2)-rad^2;

r1=(-b+sqrt(b^2-4*a*c))/(2*a);
r2=(-b-sqrt(b^2-4*a*c))/(2*a);
x=[r1 r2]*cos(th)+p(1);
y=[r1 r2]*sin(th)+p(2);

[xs,ys]=pol2cart([th,th+pi],30);
xs=xs+p(1);ys=ys+p(2);
d=CartDist([x' y'],sp);
[m,i]=min(d);
x=x(i);
y=y(i);
tn=cart2pol(-x,-y);
d=AngularDifference(tn,th)*180/pi;

t=0:.1:2*pi;
[xs,ys]=pol2cart([th+pi],[0 30]);
xs=xs+p(1);ys=ys+p(2);
% plot(xs,ys,'k',xs(2),ys(2),'ko')%,rad*cos(t),rad*sin(t),p(1),p(2),'rx',[0 x],[0 y],'r-s',sp(1),sp(2),'go')

function[zig1,zig2,lzig,zang]=GetZigOrZag(zigs,cents,lt,br)
zig1=[];zig2=[];lzig=[];zang=[];
if(isempty(zigs)) return; end;

if(nargin<3) lt = 3; end
if(nargin<4) br = 1; end

d=diff(zigs);
bps=find(d>br);

if(isempty(bps)) 
    zig1=zigs(1);
    zig2=zigs(end);
    lzig=zig1-zig2+1;
else
    zig1=[1 bps+1];
    zig2=[bps length(zigs)];
    lzig=zigs(zig2)-zigs(zig1)+1;
    is=find(lzig>=lt);
    zig1=zigs(zig1(is));
    zig2=zigs(zig2(is));
    lzig=lzig(is);
end
for i =1:length(zig1)
    cs=cents(zig1(i):zig2(i),:);
    [area,axes,angles,ellip] = ellipse(cs(:,1),cs(:,2),[],0.8535);
    x=cs(end,1)-cs(1,1);
    y=cs(end,2)-cs(1,2);
    t=cart2pol(x,y);
    if(abs(AngularDifference(t,angles(1)))>(pi/2)) angles=angles+pi; end;
    angles=mod(angles,2*pi);
    zang(i)=angles(1);
    d=sqrt(x^2+y^2);
    [xs,ys]=pol2cart(zang(i),[0 d]);
%     plot(xs+cs(1,1),ys+cs(1,2))
end

function[d,cp] = ClosestPointToNest(c,ang)
[x,y]=pol2cart(ang,1);
m=y/x;
if(isinf(m)) 
    cp=[c(1) 0];
    d=c(1);
elseif(m==0) 
    cp=[0 c(2)];
    d=c(2);
else
    interc=c(2)-m*c(1);   %intercept
    cp(1)=-interc/(m+1/m);
    cp(2)=-cp(1)/m;
    d=sqrt(sum(cp.^2));
end
    
function PlotAngLine(angs,c)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',xs([2 4]),ys([2 4]),'g')