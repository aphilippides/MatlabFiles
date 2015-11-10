function CoincidentPoints

% GetLorData
% PlotLorData
% return

origdir=cd;
lsl=[];lsz=[];pcz=[];pcl=[];
% cols=['b';'g';'r';'k';'c';'c';'c'];
for i=[1:5]
%     subplot(111)
% figure(i)
    changedir(i);
%     DuplicateFilesProper(i)
    pcz=[pcz; RangeOfStraightLines('CoRangeDatIn.mat','k',0)];
    pcl=[pcl; RangeOfStraightLines('CoRangeDatOut.mat','k:',1)];
%     [pcl(i,:),nfl(i,:),l]=ProcessNestCoin('NestCoDatOutFinal.mat','k',1);
%     lsl=[lsl l];
%     [pcz(i,:),nfz(i,:),l]=ProcessNestCoin('NestCoDatFinal.mat','k:',0);
%     lsz=[lsz l];
%     pcl=[pcl; PercentLOrZZ('NestCoDatOutFinal.mat',1)];
%     pcz=[pcz; PercentLOrZZ('NestCoDatFinal.mat',0)];
%     CheckCoincidentPonts('NestCoDatOut.mat',0)
%     CheckCoincidentPonts('NestCoDat.mat',1)
% lts=[lts;lt];y2s=[y2s;y2];o2s=[o2s;o2];zys=[zys;zy];oys=[oys;oy];ts=[ts;t];

%     lts=[lts lt];y2s=[y2s y2];oys=[oys oy];o2s=[o2s o2];zys=[zys zy];ts=[ts t];
%     
%     getfnames('NestCoDatOutFinal.mat','loopstatstemp.mat',i,0)
%     getfnames('NestCoDatFinal.mat','loopStatsIn.mat',i,1)

    str=cd;sp=findstr(str,'\');
    title(str(sp(end)+1:end))
    cd(origdir);
end
% pcztot=100*sum(pcz)/sum(pcz(:))
% pcltot=100*sum(pcl)/sum(pcl(:))
pclmean=mean(pcl)
pczmean=mean(pcl)
% save tempCoinPtsPCs.mat pc* nfz nfl
% [sum(pcz(:)) sum(pcl(:))]
return;
gnc=~isnan(pcl(:,1));
ga=~isnan(pcl(:,5));
pcinL_ZZAll_Outs=mean(pcl(ga,5:9))
pcinL_ZZNotClose_Outs=mean(pcl(gnc,1:4))
nonz=pcl(:,2)>0;
pcinL_ZZNotClose_NonZero_Outs=mean(pcl(nonz,1:4))
gnc=~isnan(pcz(:,1));
ga=~isnan(pcz(:,5));
pcinL_ZZAll_Ins=mean(pcz(ga,5:9))
pcinL_ZZNotClose_Ins=mean(pcz(gnc,1:4))
nonz=pcz(:,4)>0;
pcinL_ZZNotClose_NonZero_Ins=mean(pcz(nonz,1:4))
% save pcinLoopOrZZFinal pc*
k=3;
subplot(2,1,1),
[da,x]=StatsOverX(pcl(:,10),double(pcl(:,1)>0),0.5:k:15);
[da2,x]=StatsOverX(pcz(:,10),double(pcz(:,1)>0),0.5:k:15);
plot(x,[da.me]*100,'k',x,[da2.me]*100,'k:'),xlabel('flight number');ylabel('% flights w loop')
round([x;[da.me]*100;[da.n];[da2.me]*100;[da2.n]])
ylim([50 100])
subplot(2,1,2),
[da,x]=StatsOverX(pcl(:,10),double(pcl(:,2)>0),0.5:k:15);
[da2,x]=StatsOverX(pcz(:,10),double(pcz(:,2)>0),0.5:k:15);
round([x;[da.me]*100;[da.n];[da2.me]*100;[da2.n]])
plot(x,[da.me]*100,'k',x,[da2.me]*100,'k:'),xlabel('flight number');ylabel('% flights w loop')
ylim([50 100])
keyboard

function[out]=RangeOfStraightLines(outfn,cst,io)
load(outfn);
r3=[corangeDat.mdco];
r2=[corangeDat.ran];
r1=[corangeDat.rmse];
out=[r1' r2' r3'];



function[cw,aw,cwis,awis] = Handednes(d,smlen)
if(smlen>0.02)
    sma=[];
    for i=1:length(d)
        sma=[sma TimeSmooth([d(i).ra_co],[d(i).t],smlen)];
    end
else
    sma=[d.ra_co];
end
cwis=sma>=0;
awis=~cwis;
n=[d.nor];
p=[d.psi];
f=[d.f2n];
l=[d.lmor];
cw.nor=n(cwis);
cw.psi=p(cwis);
cw.f2n=f(cwis);
cw.lmor=l(:,cwis);
aw.nor=n(awis);
aw.psi=p(awis);
aw.f2n=f(awis);
aw.lmor=l(:,awis);
return


function PlotLorData
load 2e2wLorNorPsiF2n
sls=0.02:0.04:0.2;
% handedness checks
% la=[wlaw;elaw];
% za=[wzaw;ezaw];
% lc=[wlcw;elcw];
% zc=[wzcw;ezcw];
% for i=1:length(sls)
%     [cl,aw]=Handednes(lc,sls(i));
%     [cz,aw]=Handednes(zc,sls(i));
%     [du,al]=Handednes(la,sls(i));
%     [du,az]=Handednes(za,sls(i));
%     acc(i,:)=[length([cl.f2n])/length([lc.f2n]) length([cz.f2n])/length([zc.f2n]) ...
%         length([al.f2n])/length([la.f2n]) length([az.f2n])/length([za.f2n])]
% end

keyboard
l=elaw([elaw.coin]==1);
z=ezaw([ezaw.coin]==1);
l=wlcw([wlcw.coin]==0);
z=wzcw([wzcw.coin]==0);
l=wnlall;
z=wnzall;
[cl,al]=Handednes(l,sls(3));
[cz,az]=Handednes(z,sls(3));
l=cl;z=cz;
l=al;z=az;

opt=1;
h(1)=subplot(1,3,1);
plotOverf2n([l.f2n],[l.psi],'k',1,'psi',opt)
plotOverf2n([z.f2n],[z.psi],'k:',0,'psi',opt)
h(2)=subplot(1,3,2);%figure(6)
plotOverf2n([l.f2n],[l.nor],'k',1,'nest on ret',opt)
plotOverf2n([z.f2n],[z.nor],'k:',0,'nest on ret',opt)
h(3)=subplot(1,3,3);%figure(7)
llor=[l.lmor];llor=llor(1,:);
zlor=[z.lmor];zlor=zlor(1,:);
plotOverf2n([l.f2n],llor,'k',1,'LM on ret',opt)
plotOverf2n([z.f2n],zlor,'k:',0,'LM on ret',opt)
SetHeightWid(h),
figure(1)

% non-coincident
% l=elcw([elcw.coin]==0);
% z=ezcw([ezcw.coin]==0);
% l=wlcw([wlcw.coin]==0);
% z=wzcw([wzcw.coin]==0);
l=elaw([elaw.coin]==0);
z=ezaw([ezaw.coin]==0);
l=wlaw([wlaw.coin]==1);
z=wzaw([wzaw.coin]==1);


% figure(8)
% plotOverf2n([l.f2n],[l.nor],'k',1,'psi')
% plotOverf2n([z.f2n],[z.nor],'k:',0,'psi')
% figure(9)
% plotOverf2n([l.f2n],[l.nor],'k',1,'nest on ret')
% plotOverf2n([z.f2n],[z.nor],'k:',0,'nest on ret')
figure(11)
llor=[l.lmor];llor=llor(1,:);
zlor=[z.lmor];zlor=zlor(1,:);
plotOverf2n([l.f2n],llor,'k',1,'LM on ret')
plotOverf2n([z.f2n],zlor,'k:',0,'LM on ret')


function GetLorData

load ../2' east all'/temp2ELoopPhaseDataAll.mat
elcw=datcw;
elaw=dataw;
enlall=GetDat(NestCo,1);
enl=GetDat(NestCo,2);

load ../2' east all'/temp2EZZPhaseDataAll.mat
ezcw=zatcw;
ezaw=zataw;
load ../2' east all'/LoopInPhaseDataAll
enzall=GetDat(NestCo,1);
enz=GetDat(NestCo,2);

enzall_wbeg=GetDat(NestCo,3);
enz_wbeg=GetDat(NestCo,4);


load ../2' west'/temp2WLoopPhaseDataAll;
wlcw=datcw;
wlaw=dataw;
wnlall=GetDat(NestCo,1);
wnl=GetDat(NestCo,2);

load ../2' west'/temp2WZZPhaseDataAll;
wzcw=zatcw;
wzaw=zataw;
load ../2' west'/LoopInPhaseDataAll
wnzall=GetDat(NestCo,1);
wnz=GetDat(NestCo,2);
save 2e2wLorNorPsiF2n.mat en* wn* elcw elaw ezcw ezaw wlcw wlaw wzcw wzaw 

function[dat]=GetDat(NestCo,o)
dat=[];
for i=1:length(NestCo)
    ia=1:length(NestCo(i).t);
    if(o==1); is=setdiff(ia,[NestCo(i).lallis NestCo(i).begis NestCo(i).zallis]);
    elseif(o==2); is=setdiff(ia,[NestCo(i).lis NestCo(i).begis NestCo(i).zis]);
    elseif(o==3); is=setdiff(ia,[NestCo(i).lallis NestCo(i).zallis]);
    else is=setdiff(ia,[NestCo(i).lis NestCo(i).zis]);
    end
    d.f2n=NestCo(i).f2n(is)';
    d.psi=NestCo(i).psi(is)';
    d.nor=NestCo(i).nor(is);
    d.lmor=NestCo(i).lmor(:,is);
    d.co=NestCo(i).co(is)';
    d.t=NestCo(i).t(is);
    d.ra_co=MyGradient(AngleWithoutFlip(NestCo(i).co(is)),NestCo(i).t(is));
    dat=[dat;d];
end


function[d]=GetDatV2(NestCo,o)
d.f2n=[];
d.psi=[];
d.nor=[];
d.lmor=[];
d.co=[];
d.t=[];
d.ra_co=[];
for i=1:length(NestCo)
    ia=1:length(NestCo(i).t);
    if(o==1); is=setdiff(ia,[NestCo(i).lallis NestCo(i).begis NestCo(i).zallis]);
    elseif(o==2); is=setdiff(ia,[NestCo(i).lis NestCo(i).begis NestCo(i).zis]);
    elseif(o==3); is=setdiff(ia,[NestCo(i).lallis NestCo(i).zallis]);
    else is=setdiff(ia,[NestCo(i).lis NestCo(i).zis]);
    end
    d.f2n=[d.f2n NestCo(i).f2n(is)'];
    d.psi=[d.psi NestCo(i).psi(is)'];
    d.nor=[d.nor NestCo(i).nor(is)];
    d.lmor=[d.lmor NestCo(i).lmor(:,is)];
    d.co=[d.co NestCo(i).co(is)'];
    d.t=[d.t NestCo(i).t(is)];
    d.ra_co=[d.ra_co MyGradient(AngleWithoutFlip(NestCo(i).co(is)),NestCo(i).t(is))];
end

function[pca]=PercentLOrZZ(outfn,ino)
% [d isfile(outfn)]
% return
load(outfn)% NestCoDat
nlND=length(NestCoChND);
pc2=reshape([NestCoChND.pc2]',8,nlND)';
pc1=reshape([NestCoChND.pcs]',10,nlND)';

for i=1:length(NestCoChND)
    [out,bee(i),fnum(i)]=ProcessBeeFilename(NestCoChND(i).fn,ino);
end

% ***DONT KNOW WHAT TO DO ABPOUT END BI OF INS FOR PARITY ****
% this is % in all loops, picked loops, all zz, picked zz. 
% 1st 4 values w.o end bit (correct for loops) ?? for zz
% 2nd 4 for whole flight. Last values is % in end bit
% Final numbers are flight number then bee number 
pca=[pc2(:,1:4) pc1(:,[1:5]) fnum' bee'];

% below is eg of how to get mean number of 
% [da,x]=StatsOverX(pca(:,10),double(pca(:,1)>0),0.5:1:(max(fnum)+1));
% plot(x,[da.me]*100),xlabel('flight number');ylabel('% flights w loop')


function[cc,ppsi,s2n]=getparams(dat,m,isho,fnums,cst)
dfs=[];dc=[];dr=[];dfr=[];dcr=[];drr=[];dfd=[];dctp=[];
relf=[];relc=[];relt100=[];relt60=[];tts=[];cc=[];rellm=[];tst=[];
ra_f2f2n=[];
l1=[];len=[];len2tp=[];relt=[];relt1=[];relt2=[];l2=[];ddd=[];so=[];
o2n=[];o2lm=[];s2n=[];ds=[];reld=[];rafs=[];f2ncw=[];
is100=~isnan(m(:,29));
is60=~isnan(m(:,27));
d1=180/pi*AngularDifference(m(is100,24)*pi/180,m(is100,29)*pi/180);
d2=180/pi*AngularDifference(m(is60,24)*pi/180,m(is60,27)*pi/180);
s100=AngularDifference(m(is100,29)*pi/180,0)*180/pi;
s60=AngularDifference(m(is60,27)*pi/180,0)*180/pi;
td20=m(:,36)-m(:,37);
td40=m(:,36)-m(:,38);
td60=m(:,36)-m(:,39);
td80=m(:,36)-m(:,40);
td100=m(:,36)-m(:,41);
d60=m(:,42)-m(:,45);
d100=m(:,42)-m(:,47);
for k=1:length(dat)
    inds=dat(k).is;
    inds=1:length(dat(k).t);
    rf=(dat(k).f2n(inds)*pi/180)';
    relf=[relf rf];
    rellm=[rellm -dat(k).f2lm(:,inds)];
    o2lm=[o2lm dat(k).o2lm(:,inds)];
    o2n=[o2n dat(k).o2n(inds)'];
%     if(isho)
    if(isequal(cst,'k'))
        nor=dat(k).s2n(inds)'*pi/180;
    else
        nor=-dat(k).s2n(inds)'*pi/180;
    end
    s2n=[s2n nor];
    co=(dat(k).co(inds)*pi/180)';
    so=[so (dat(k).so(inds)*pi/180)'];
    cc=[cc co];
    relc=[relc AngularDifference(co,m(k,24)*pi/180)];
    t=dat(k).t(inds)-m(k,36);
    t_st=dat(k).t(inds)-dat(k).t(1);
    tts=[tts t];
    relt100=[relt100 t/td100(k)];
    relt60=[relt60 t/td60(k)];
    len=[len dat(k).t(end)-dat(k).t(1)];
    len2tp=[len2tp m(k,36)-dat(k).t(1)];
    l1=[l1 dat(k).t(inds(end))-dat(k).t(inds(1))];
    l2=[l2 m(k,36)-dat(k).t(inds(1))];
    relt=[relt t/len(k)];
    tst=[tst t_st/len(k)];
    relt1=[relt1 t/l1(k)];
    relt2=[relt2 t/l2(k)];
    cs =dat(k).cs;
    cd=diff(cs(inds,:));
    d1=[0 cumsum(CartDist(cd))'];
    ds=[ds d1];
    reld=[reld d1/d1(end)];
    ddd(k)=d1(end);
    
    raf=MyGradient(rf,t_st,1);
    rafs=[rafs raf];
    f2ncw=[f2ncw rf(1)];
    
    ra_f2f2n=[ra_f2f2n MyGradient(co,rf)];
end
ppsi=AngularDifference(cc,so);
plotbits(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_f2f2n,isho,cst,fnums)


function[pca,nfwLorZZ,ls]=ProcessNestCoin(outfn,cst,io)
% [d isfile(outfn)], return
load(outfn);
nlND=length(NestCoChND)
cs=[];
for i=1:nlND
    fs(i,:)=Frequencies(NestCoChND(i).CoinType,1:5);
    pcs(i,:)=100*fs(i,1:4)./sum(fs(i,1:4));
    NestCoChND(i).f2n=[NestCoChND(i).f2n]';
    NestCoChND(i).psi=[NestCoChND(i).psi]';
%     cs=[cs;NestCoChND(i).cs];
end

% vals are={'ZZ';'LOOP';'BOTH';'NONE';'EXCLUDED'};
s=sum(fs(:,1:4));
pca=[100*s/sum(s) mean(pcs(~isnan(pcs(:,1)),:))]
% f2n=[NestCoChND.f2n];
ls=[NestCoChND.Lincids];
% get # flights with: ZZs, Loops, coincident, #flights
nfwLorZZ=[sum((pcs(:,1)+pcs(:,3))>0) sum((pcs(:,2)+pcs(:,3))>0) ...
    sum(~isnan(pcs(:,1))) size(pcs,1)];
% pca=nol;

% ppsi=[NestCoChND.psi];
% pca=sum(fs(:,1:4));
% nor=AngularDifference(f2n,ppsi);
% % plotOverf2n(f2n,ppsi,cst,io)
% plotOverf2n(f2n,nor,cst,io)

function getfnames(ofn,lfn,d,ino)
load(lfn)
load(ofn)
clear NestCoChND nondup 
nondup=[];
NestCoChND=NestCoCh;
for i=1:length(loops)
    filelist(i).fn=loops(i).fn;
    NestCoChND(i).fn=loops(i).fn;
    if(~SortDuplicateFiles(d,loops(i).fn,ino))
        nondup=[nondup i];
    end
end
NestCoChND=NestCoChND(nondup);
save(ofn,'filelist','NestCoChND','nondup','-append');


function[isdup]=SortDuplicateFiles(d,fn,ino)

% files to exclude
dup_files(1).name='2E20';
dup_files(1).indups={'2E20 12-07-07 15-00 36 in5All.mat'};
dup_files(1).outdups={'2E20 12-07-07 13-00 32 out2-aAll.mat'};

dup_files(2).name='2w20';
dup_files(2).indups=...
    {'2w20 13-07-07 16-05 37 in4-bAll.mat';...
    '2w20 12-07-07 19-11 37 in2-cAll.mat';...
    '2w20 12-07-07 19-00 34 in1-bAll.mat';...
    '2w20 12-07-07 19-00 34 in1-outAll.mat'};   
% the last one is the REAL FILE but NEEDs RENAMING TO EXCLUDE FROM INS

dup_files(5).name='E8';
dup_files(5).outdups={'E8 10-8-07 1701 6 out8All.mat'};   

dup_files(6).name='s8';
dup_files(6).indups={'s8 6-08-07 17-34 50 in3All.mat'}; 

if(ino==0)
    s=dup_files(d).outdups;
else
    s=dup_files(d).indups;
end    
if(isempty(strmatch(fn,s)))
    isdup=0;
else
    fn
    [d ino]
    isdup=1;
end


function changedir(fn)
if(fn==1) cd ../2' east all'/
elseif(fn==2) cd ../'2 west'/
elseif(fn==3) cd ../'west 8'/
elseif(fn==4) cd ../'north 8'/
elseif(fn==5) cd ../'east 8'
elseif(fn==6) cd ../'south 8'
elseif(fn==7) cd ../../'bees 2008'/'1 north 2008 all'/
end


function[mf]=MeanFlightAng(co)
for i=1:length(co)
    mf(i)=MeanAngle(co(1:i));
end


function[NestCo]=GetCoincidentPoints(lfname)

if(nargin<1) 
    lfname='loopstatstemp.mat';
    load(lfname)
    if(isfile('processzigzagsout.mat'))
        load('processzigzagsout.mat');
        zz=fltsec;
    else
        zz=[];
    end
    if(isfile('processflightsecOut'))
        load('processflightsecOut');
    else
        fltsec=[];
    end
    infiles=0;
else
    infiles=1;
    zzfile='processzigzagsin';
    load(zzfile)
    zz=fltsec;
    load(lfname)
    if(isfile('processflightsecIn'))
        load('processflightsecIn');
    else
        fltsec=[];
    end
end

nf=0;
PhDat.c=zeros(1,4);numloop=0;
nloops=length(loops);
for i=1:nloops
    ps=find([loops(i).Picked]);
    co=AngularDifference(loops(i).Co,0);
    so=AngularDifference([loops(i).so]',0);
    cs=loops(i).cs;
    ppsi=loops(i).fdir;
    f2n=loops(i).f2n;
    s2n=loops(i).nor;
    o2n=loops(i).o2n;
    t=loops(i).t;
    ds=CartDist(cs);

    % get all coincident points
    [pall0]=Thru0Pts(ppsi,t,pi/18,[],0.08);
    [fall0]=Thru0Pts(f2n,t,pi/18,[],0.08);
    ball=intersect(pall0,fall0);
    [dum,dum,blenall,imidall]=StartFinish(t,ball,0.05);
    NestCo(i).co=co;
    NestCo(i).t=t;
    NestCo(i).cs=cs;
    NestCo(i).psi=ppsi;
    NestCo(i).f2n=f2n;
    NestCo(i).inds=ball;
    NestCo(i).incids=[imidall;blenall];
    NestCo(i).is=1:length(t);
    if(infiles)
        revd=ds(end:-1:1);
        sp=length(t)-find(revd>5,1)+1;
        NestCo(i).begis=sp+1:length(t);
    else
        NestCo(i).begis=1:find(ds>5,1)-1;
    end
    
    NestCo(i).cutoff=find(ds<2.5,1);
    
    if(isempty(loops(i).loop))
        NestCo(i).lallis=[];
        NestCo(i).lis=[];
        NestCo(i).loo=[];
        NestCo(i).ps=[];
    else
        NestCo(i).lallis=unique([loops(i).loop.is]);
        NestCo(i).lis=unique([loops(i).loop(ps).is]);
        NestCo(i).loo=loops(i).loop;
        NestCo(i).ps=loops(i).Picked;
    end
    NestCo(i).Lallincids=intersect(imidall,NestCo(i).lallis);
    NestCo(i).Lallinds=intersect(ball,NestCo(i).lallis);
    
    % find the correct zz file  
    fn=loops(i).fn;
    NestCo(i).zallis=[];
    NestCo(i).zis=[];
    NestCo(i).zst=[];
    NestCo(i).lst=[];
    NestCo(i).allzst=[];
    NestCo(i).zzf=0;
    NestCo(i).zz=[];
    for k=1:length(zz)
        if(isequal(fn,zz(k).fn))
            if(~isempty(zz(k).fsec))
                NestCo(i).zz=zz(k).fsec;
                NestCo(i).zzf=1;
                NestCo(i).zallis=unique([zz(k).fsec.is]);
                for z=1:length(zz(k).fsec)
                    zis=zz(k).fsec(z).is;
                    NestCo(i).allzst(z)=t(zis(1));
                    if(length(zis)>=4)
                        NestCo(i).zst=[NestCo(i).zst t(zis(1))];
                        NestCo(i).zis=unique([NestCo(i).zis zis]);
                    end
                end
            end
            break;
        end
    end

    % get %ages of flights
    NestCo(i).lens=[length(t) length(NestCo(i).lallis) length(NestCo(i).lis) ...
        length(NestCo(i).zallis) length(NestCo(i).zis) length(NestCo(i).begis)];
    
    % get # and %ages of coincident points
    NestCo(i).nlks=[length(imidall) length(NestCo(i).Lallincids) ...
        length(intersect(imidall,NestCo(i).lis)) length(intersect(imidall,NestCo(i).zallis)) ...
        length(intersect(imidall,NestCo(i).zis)) length(intersect(imidall,NestCo(i).begis))];
    NestCo(i).pcs=100*[NestCo(i).lens(2:end)/NestCo(i).lens(1) ...
        NestCo(i).nlks(2:end)/NestCo(i).nlks(1)];
    
    n1=NestCo(i).lens(1)-NestCo(i).lens(6);
    n2=NestCo(i).nlks(1)-NestCo(i).nlks(6);
    NestCo(i).pc2=100*[NestCo(i).lens(2:end-1)/n1 ...
        NestCo(i).nlks(2:end-1)/n2];
    NestCo(i).LM=loops(i).LM;
    NestCo(i).LMw=loops(i).LMw;

    NestCo(i).Lincids=[];
    NestCo(i).Linds=[];

    % check all coincident points
%     NestCoCh(i)=CheckAllCoin(NestCo(i),i,nloops);
%     save NestCoDat  NestCo nloops -append
    
%     SelectAllZigZags(co,cs,t,imidall,loops(i).LM,loops(i).LMw,ds)
%     keyboard
    
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);
    ra_co=MyGradient(AngleWithoutFlip(co),t);
    ra_so=MyGradient(AngleWithoutFlip(so),t);
    
    % find the correct straight file  
    lnum=-1;
    fn=loops(i).fn;
    for k=1:length(fltsec)
        if(isequal(fn,fltsec(k).fn))
            if(isempty(fltsec(k).fsec))
                lnum=-1;
            else
                lnum=k;
            end
            break;
        end
    end
    % get the indices of all the straight lines
    if(lnum>0)
        fsec=fltsec(lnum).fsec;
        is_str=[fsec.is];
        fsecs=[];
        for k=1:length(fsec)
            fsecs=[fsecs k*ones(size(fsec(k).is))];
        end
    end

    if(sum(ps)) nf=nf+1; end
    for j=1:length(ps)
        numloop=numloop+1;
        is=loops(i).loop(ps(j)).is;
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        sp=is(1);ep=is(end);
                
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
        [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
        b=intersect(psi0,f2n0);
        NestCoin(numloop).coin=is(b);
        NestCoin(numloop).lk=~isempty(b);
        NestCo(i).lst=[NestCo(i).lst t(is(1))];
        
        % get incidents from frames
        [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
        [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
        [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
        [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        NestCo(i).Lincids=[NestCo(i).Lincids [is(imids);blens]];
        NestCo(i).Linds=[NestCo(i).Linds is(b)];
          
    end
end

function CheckCoincidentPonts(outfn,inout)

% outfn='NestCoDat.mat';
% keyboard;
% ProcessNestCoin(outfn)
% load('NestCoDataIn 2east1_13.mat');

if(isfile(outfn))
    inp=1;
%     while(~isequal(inp,0))
%         inp=input(['Using file ' outfn '; enter 0 to continue']);
%     end
    disp(['Using file ' outfn]);
    load(outfn);
else
    inp=1;
    while(~isequal(inp,0))
        inp=input(['about to overwrite file ' outfn '; enter 0 to continue']);
    end
    if(inout==1)
        NestCo=GetCoincidentPoints('loopstatsIn');
    else
        NestCo=GetCoincidentPoints;
    end
    nloops=length(NestCo);
    save(outfn,'NestCo','nloops');
end
for i=1:nloops
    if((exist('NestCoCh','var'))&&(length(NestCoCh)>=i))%NestCoCh(i).checked==1)
        NestCoCh(i)=CheckAllCoin(NestCoCh(i),i,nloops);
%         save('NestCoDatTemp.mat','NestCoCh');
    else
        NestCoCh(i)=CheckAllCoin(NestCo(i),i,nloops);
        save(outfn,'NestCoCh','-append');
    end
end



function plotOverf2n(relf,ppsi,cst,isho,str,opt)%,so,rellm,cc,o2lm,o2n,s2n,spee,ra_co,ra_so,fs)

thf=-190:20:190;
thp=thf;
% [Dpsi,xs,ys,xps,yps]=Density2DAng(relf*180/pi,ppsi*180/pi,thf,thf);
[dp,np]=StatsOverX(relf,ppsi,thf*pi/180);g=[7 13];
% r=[max(ppsi) min(ppsi)]*180/pi
v=[10 50 70]*pi/180;
i1s=abs(relf)<v(1);
i4s=(abs(relf)>=v(2))&(abs(relf)<v(3));
i2s=(relf>=v(2))&(relf<v(3));
i3s=(relf<=-v(2))&(relf>-v(3));
% subplot(1,2,1)
% contourf(xps,yps,Dpsi)
% axis tight;xlabel('f to nest');ylabel('psi')


if((opt==2)||(opt==0))
    if(opt==0); subplot(2,2,2); end;
    [y,x]=AngHist(ppsi(i1s)*180/pi,[],[],0);%(da1(10).x*180/pi,[],[],0);
    plot(x,y/sum(y),cst)
    Setbox;axis tight;title([ str ' when flying towards nest'])
    if(isho); hold on; else hold off; end
elseif((opt==3)||(opt==0))
    if(opt==0); subplot(2,2,3); end;
    [y1,x]=AngHist(ppsi(i2s)*180/pi,[],[],0);%(da1(g(1)).x*180/pi,[],[],0);
    [y2,x]=AngHist(ppsi(i3s)*180/pi,[],[],0);%(da1(g(2)).x*180/pi,[],[],0);
    % plot(x,y1/sum(y1),cst,x,y2/sum(y2),cst)
    % Setbox;axis tight;title([str ' when flying \pm60^o to nest'])
    plot(x,y1/sum(y1),cst)
    Setbox;axis tight;title([str ' when flying 60^o to nest'])
    if(isho); hold on; else hold off; end
elseif((opt==4)||(opt==0))
    if(opt==0); subplot(2,2,4); end;
    plot(x,y2/sum(y2),cst)
    Setbox;axis tight;title([str ' when flying -60^o to nest'])
    % [y,x]=AngHist(ppsi(i4s)*180/pi,[],[],0);%(da1(10).x*180/pi,[],[],0);
    % plot(x,y/sum(y),cst)
    % Setbox;axis tight;title([str 'when flying \pm60^o to nest')
    if(isho); hold on; else hold off; end
elseif((opt==1)||(opt==0))
    if(opt==0); subplot(2,2,1); end;
    % if(isho); MotifFigs(gcf,1); end
    ma=140;
    np=np*180/pi;
    mea_ang=[dp.meang]*180/pi;
    plot(np,mea_ang,cst,np,ma+[dp.angsd]*180/pi,cst, ...
        np([1 end]), [ma ma],'k','LineWidth',0.75)
    grid on;axis tight;title([str])
    if(isho); hold on; else hold off; end
    ylim([-190 200])
    dat=[mea_ang;[dp.n]]
        % plot n's as a percentage. Need to scale them all
        % slot is 90degs = 20% so 1%=90/20=4.5 Take off 190 to put at bottom
%         ma=-100;
%         pc=100*[dp.n]./sum([dp.n]);
%         plot(np,pc*4.5-190,cst,np([1 end]), [ma ma],'k')
elseif(opt==5)
        % plot n's as a percentage. the top bar is 20% so scale to that
        pc=100*[dp.n]./sum([dp.n]);
        plot(np,pc,cst,'LineWidth',0.75);
        axis tight
        if(isho); hold on; else hold off; end
        ylim([0 20])
        % slot is 90degs = 20% so 1%=90/20=4.5 Take off 190 to put at bottom
end
return;

%         ylabel(char(tst(vs(i),:)))


% subst='subplot(4,3,i)';
% vs=1:12;
subst='subplot(1,3,i)';
vs=[1 7:8];
% subst='MotifFigs(gcf,1)';
% subst='figure(fs(i));MotifFigs(gcf,1)';
% vs=[12];
hists=1;
if(fs(1)>40)
    g=13;
else
    g=7;
end
g=[7 13];
[da1,n]=StatsOverX(relf,ppsi,[-190:20:190]*pi/180);
% [da2,n]=StatsOverX(relf,cc,[-190:20:190]*pi/180);
% [da3,n]=StatsOverX(relf,so,[-190:20:190]*pi/180);
% [da4,n]=StatsOverX(relf,o2n,[-190:20:190]*pi/180);
% [da5,n]=StatsOverX(relf,o2lm(1,:),[-190:20:190]*pi/180);
% [da6,n]=StatsOverX(relf,o2lm(2,:),[-190:20:190]*pi/180);
[da7,n]=StatsOverX(relf,s2n,[-190:20:190]*pi/180);
[da8,n]=StatsOverX(relf,rellm(1,:),[-190:20:190]*pi/180);
% [da9,n]=StatsOverX(relf,rellm(2,:),[-190:20:190]*pi/180);
% [da10,n]=StatsOverX(relf,spee,[-190:20:190]*pi/180);
[da11,n]=StatsOverX(relf,abs(ra_co),[-190:20:190]*pi/180);
[da12,n]=StatsOverX(relf,abs(ra_so),[-190:20:190]*pi/180);
np=n*180/pi;
% figure(fs(1))
% plot(np,[da1.meang]*180/pi,np,[da2.meang]*180/pi,'r:',np,[da3.meang]*180/pi,'k:',np,-[da4.meang]*180/pi,'b:x')
% grid on,axis tight
if(ischar(fs(1)))
    save(fs);
    return;
end
tst={'psi';'fdir';'body';'o to nest';'o to NLM';'o to SLM';'nest ret';'N LM ret';...
    'S LM ret';'speed';'df/dt';'dflight/df2nest'};%'dbody/dt'};
figure(fs(1))
for i=1:length(vs)
    eval(subst);
    eval(['dp=da' int2str(vs(i))]);
%     plot(np,dp.meang*180/pi,cst)
    if(vs(i)<10) 
%         errorbar(np,[dp.meang]*180/pi,[dp.angsd]*180/pi,cst)
        % plot data and sd's
        ma=140;
        plot(np,[dp.meang]*180/pi,cst,np,ma+[dp.angsd]*180/pi,cst, ...
            np([1 end]), [ma ma],'k')

        % plot n's as a percentage. Need to scale them all
        % slot is 90degs = 20% so 1%=90/20=4.5 Take off 190 to put at bottom
%         ma=-100;
%         pc=100*[dp.n]./sum([dp.n]);
%         plot(np,pc*4.5-190,cst,np([1 end]), [ma ma],'k')
    else
%         errorbar(np,[dp.me],[dp.sd],cst)
        plot(np,[dp.med],cst)
    end
    grid on;
    axis tight;
    if(isho) 
        hold on;
    else
        hold off;
    end
%     ylabel(char(tst(vs(i),:)))
     title(char(tst(vs(i),:)))

    if(vs(i)<10) 
        ylim([-190 200])
    end
    
%     xlabel('f rel 2 nest')
end
if hists
    figure(fs(2))
    for i=1:length(vs)
        eval(subst);
        eval(['dp=da' int2str(vs(i))]);
        if(vs(i)<10)
            [y,x]=AngHist(dp(10).x*180/pi,[],[],0);
        else
%             [y,x]=hist(dp(10).x,20);
            [y,x]=hist(dp(10).x,0:.1:2);
        end
        plot(x,y/sum(y),cst)
        Setbox;
        axis tight;
        if(isho)
            hold on;
        else
            hold off;
        end
        ylabel(char(tst(vs(i),:)))
    end
    figure(fs(3))
    for i=1:length(vs)
        eval(subst);
        eval(['dp=da' int2str(vs(i))]);
        if(vs(i)<10)
            [y,x]=AngHist(dp(g(1)).x*180/pi,[],[],0);
            [y1,x]=AngHist(dp(g(2)).x*180/pi,[],[],0);
        else
%             [y,x]=hist(dp(g(1)).x,20);
            [y,x]=hist(dp(g(1)).x,0:.1:2);
            [y1,x]=hist(dp(g(2)).x,x);
        end
        %     plot(x,y/sum(y),cst)%,x,y1/sum(y1),cst)
        plot(x,y/sum(y),cst,x,y1/sum(y1),cst)
        axis tight;
        Setbox;
        if(isho)
            hold on;
        else
            hold off;
        end
        ylabel(char(tst(vs(i),:)))
    end
end


function DuplicateFilesProper(f)
sbit={'2E20';'2w20';'W8 ';'N8 ';'E8 ';'s8 '};
s=dir([char(sbit(f)) '*All.mat']);
if 1%(~isfile('tempDat.mat'))
    for i=1:length(s)
        i
        load(s(i).name)
        dat(i).t=t;
        dat(i).cs=Cents;
        clear t Cents
    end
    save tempDat dat s
else
    load tempdat
end
for i=1:length(dat)
    lt=length(dat(i).t);
    ot=dat(i).t;
    ocs=dat(i).cs;
%     m=round(length(ot)*0.4):round(length(ot)*0.6);
    m=round(length(ot)*0.4):min(round(length(ot)*0.4)+20,length(ot));
    i
    for j=i+1:length(dat)
        % find start point
            cs=dat(j).cs;
        d=CartDist(cs,ocs(m(1),:));
        [ind,mv]=find(d<1);
        for k=1:length(ind)
            m2=ind(k):(ind(k)+length(m)-1);
            if(m2(end)<=length(dat(j).t))
               if(sum(CartDist(cs(m2,:),ocs(m,:)))<5) 
            subplot(1,2,1)
            plot(ocs(m,1),ocs(m,2),cs(m2,1),cs(m2,2),'r:')
            subplot(1,2,2)
            plot(ocs(:,1),ocs(:,2),cs(:,1),cs(:,2),'r:')
                disp(s(i).name)
                disp(s(j).name)
            keyboard;     
               end
            end
        end
%         if(length(dat(j).t)==lt)
% %             cs=dat(j).cs;
%             if(sum(CartDist(cs(m,:),ocs(m,:)))<1)
%                 plot(ocs(:,1),ocs(:,2),cs(:,1),cs(:,2),'r:')
%                 disp(s(i).name)
%                 disp(s(j).name)
%                 keyboard;
%             end
%         end
    end
end

function DuplicateFiles
% load processzigzagsin
% load processflightsecIn
% isequal(fltsec.fn,zz.fn)
% for i=1:16
%     is(i)=isequal(fltsec(i).fn,zz(i).fn)
% %     gfiles{i}=fltsec(i).fn;
% end
clear
load tempzz
load loopstatsInOrigWDuplicates
zzfiles=strvcat(zz.fn)
origfiles=strvcat(loops.fn);
for i=1:length(loops)
    if(isempty(strmatch(loops(i).fn,zzfiles,'exact')))
        b(i)=1;
    else
        b(i)=0;
    end
end
duplicatefiles=origfiles(b==1,:)
loops=loops(b==0)
% save loopstatsIn
clear
load processzigzagsin
zzfiles=strvcat(fltsec.fn);
load loopstatstemp
c=strvcat(loops.fn);
% f=dir('E8*All.mat');
f=dir('2w20*All.mat');
allf=strvcat(zzfiles,c);
for i=1:length(f)
    if(isempty(strmatch(f(i,:).name,allf,'exact')))
        b(i)=1;
    else
        b(i)=0;
    end
end
dup=strvcat(f(b==1).name)
[length(loops) size(zzfiles,1) length(f) size(dup,1)]



function[NestCo]=CheckAllCoin(NestCo,nf,numf)
NestCo.checked=0;
co=NestCo.co;
if(isempty(NestCo.incids))
    NestCo.checked=1;
    NestCo.znum=[];
    NestCo.lnum=[];
    NestCo.nznum=[];
    NestCo.nlnum=[];
    NestCo.CoinType=[];
    NestCo.BegType=[];
    NestCo.zzsec.is=[];
    NestCo.lsec.is=[];
    return
else
    coin=NestCo.incids(1,:);
end
cs=NestCo.cs;
t=NestCo.t;
zinds=NestCo.zis;
linds=NestCo.lis;
begs=NestCo.begis;

% Select the turning points
% mf=MeanFlightAng(co);
% [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(mf,t,0.17,0.04,0);
% ex=[ma mi];

if(isfield(NestCo,'CoinType'))
    CoinType=NestCo.CoinType;
    BegType=NestCo.BegType;
    for j=1:length(coin)
        zzsec(j).is=NestCo.zzsec(j).is;
        lsec(j).is=NestCo.lsec(j).is;
    end
else
    
    CoinType=zeros(size(coin))*NaN;
    BegType=zeros(size(coin));
    NestCo.znum=zeros(size(coin));
    NestCo.lnum=zeros(size(coin));
    NestCo.nznum=zeros(size(coin));
    NestCo.nlnum=zeros(size(coin));
    for j=1:length(coin)
        zzsec(j).is=[];
        lsec(j).is=[];
    end
end
i=1;
sc=coin(i);
intp=50;
intm=50;
maxi=length(t);
tstr={'ZZ';'LOOP';'BOTH';'NONE';'EXCLUDED'};
while 1
    is=max(1,sc-intm):min(maxi,sc+intp);
    coint=intersect(coin,is);
    zis=intersect(zinds,is);
    lis=intersect(linds,is);
    zls=intersect(zis,lis);
    bis=intersect(begs,is);
    nzis=intersect([zzsec.is],is);
    nlis=intersect([lsec.is],is);

    if(isnan(CoinType(i)))
        if(ismember(sc,zls))
            CoinType(i)=3;
            for j=1:length(NestCo.zz)
                if(ismember(sc,NestCo.zz(j).is))
                    NestCo.znum(i)=j;
                    break
                end
            end
            for j=1:length(NestCo.loo)
                if((NestCo.ps(j))&&(ismember(sc,NestCo.loo(j).is)))
                    NestCo.lnum(i)=j;
                    break;
                end
            end
        elseif(ismember(sc,zis))
            CoinType(i)=1;
            for j=1:length(NestCo.zz)
                if(ismember(sc,NestCo.zz(j).is))
                    NestCo.znum(i)=j;
                    break
                end
            end
        elseif(ismember(sc,lis))
            CoinType(i)=2;
            for j=1:length(NestCo.loo)
                if((NestCo.ps(j))&&(ismember(sc,NestCo.loo(j).is)))
                    NestCo.lnum(i)=j;
                    break;
                end
            end
        elseif(ismember(sc,[zzsec.is]))
            CoinType(i)=1;
            for j=1:length(zzsec)
                if(ismember(sc,zzsec(j).is))
                    NestCo.nznum(i)=j;
                    break
                end
            end
        elseif(ismember(sc,[lsec.is]))
            CoinType(i)=2;
            for j=1:length(lsec)
                if(ismember(sc,lsec(j).is))
                    NestCo.nlnum(i)=j;
                    break
                end
            end
        else
            CoinType(i)=4;
        end
        if(ismember(sc,bis))
            BegType(i)=1;
        end
    end
    PlotNestAndLMs(NestCo.LM,NestCo.LMw,[0 0],0);
    hold on;
    plot(cs(is,1),cs(is,2),'b',cs(coint,1),cs(coint,2),'ro','MarkerSize',8)
    plot(cs(lis,1),cs(lis,2),'k.',cs(nlis,1),cs(nlis,2),'r.',...
        cs(zis,1),cs(zis,2),'kx',cs(nzis,1),cs(nzis,2),'rx',...
        cs(sc,1),cs(sc,2),'g*',cs(bis,1),cs(bis,2),'g','MarkerSize',8,'LineWidth',1.5) 
    text(cs(is(1),1),cs(is(1),2),'START');
    axis equal
    hold off
    xlabel('z=ZZ; l=loop; b=both; n=none; x=excluded; u=back; return=done; cursors add points')
    ts=(['file ' int2str(nf) '/' int2str(numf) '; point ' int2str(i) '/' ...
        int2str(length(coin)) ' is a ' char(tstr(CoinType(i)))]);
    if(BegType(i))
        ts=[ts '; START'];
    end
    title(ts);
    [x,y,inp]=ginput(1);
    if(isempty(inp))  % move on
        i=i+1;
        if(i>length(coin))
            break;
        else
            sc=coin(i);
            intp=25;
            intm=25;
        end
    elseif(isequal(inp,122)) % zigzag
        CoinType(i)=(1);
        if(~ismember(sc,zis))
            if(~ismember(sc,[zzsec.is]))
                hold on
                zzsec(i).is=SelectFlightSectionV2(cs,is,'ZZ');
                NestCo.nznum(i)=i;
                hold off
            else
                for j=1:length(zzsec)
                    if(ismember(sc,zzsec(j).is))
                        NestCo.nznum(i)=j;
                        break
                    end
                end
            end
        end
    elseif(isequal(inp,108)) % loop
        CoinType(i)=(2);
        if(~ismember(sc,lis))
            if(ismember(sc,[lsec.is]))
                for j=1:length(lsec)
                    if(ismember(sc,lsec(j).is))
                        NestCo.nlnum(i)=j;
                        break
                    end
                end
            elseif(ismember(sc,[NestCo.lallis]))
                j=1;
                while 1
                    tlis=NestCo.loo(j).is;
                    if(ismember(sc,tlis))
                        hold on;
                        h=plot(cs(tlis,1),cs(tlis,2),'r.');
                        hold off;
                        title('y = pick this loop; return next loop')
                        [x,y,b]=ginput(1);
                        delete(h);
                        if(isequal(b,121))
                            lsec(i).is=tlis;
                            NestCo.nlnum(i)=i;
                            break;
                        end
                    end
                    j=j+1;
                    if(j>length(NestCo.loo))
                        j=1;
                    end
                end
            else
                hold on
                lsec(i).is=SelectFlightSectionV2(cs,is,'loop');
                NestCo.nlnum(i)=i;
                hold off
            end
        end
    elseif(isequal(inp,98))  % both
        CoinType(i)=(3);
    elseif(isequal(inp,110))  % none
        CoinType(i)=(4);
    elseif(isequal(inp,120))  % excluded
        CoinType(i)=(5);
    elseif(isequal(inp,30))  % add points in front
        intp=intp+3;
    elseif(isequal(inp,31))  % add points in back
        intm=intm+3;
    elseif(isequal(inp,117)) % go back one point
        i=i-1;
        sc=coin(i);
    end
end
NestCo.checked=1;
NestCo.CoinType=CoinType;
NestCo.BegType=BegType;
NestCo.zzsec=zzsec;
NestCo.lsec=lsec;


function[sels]=SelectFlightSectionV2(cs,is,str)
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click start of ' str]);
    if(ind~=0)
        fss=is(ind);
        h=plot(cs(fss,1),cs(fss,2),'ks');
        break;
    end
end
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click end of ' str]);
    if(ind~=0)
        delete(h);
        fse=is(ind);
        if(fse<fss)
            tmp=fss;
            fss=fse;
            fse=fss;
        end
        sels=fss:fse;
        h=plot(cs(sels,1),cs(sels,2),'k-s');
        break
    end
end

while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),'click near ends to adjust; return to end');
    if(ind==0)
        delete(h);
        break;
    else
        ind=is(ind);
        if(abs(fse-ind)<abs(fss-ind))
            fse=ind;
        else
            fss=ind;
        end
        sels=fss:fse;   
        delete(h);
        h=plot(cs(sels,1),cs(sels,2),'k-s');
    end
end

function[sels]=SelectFlightSection(cs,is,str)
fss=[]; h=[]; 
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click start of ' str '; return to end']);
    if(ind==0)
        if(~isempty(fss))
            break;
        end
    else
        delete(h);
        fss=is(ind);
        h=plot(cs(fss,1),cs(fss,2),'ks');
    end
end
h=[]; fse=[];
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click end of ' str '; return to end']);
    if(ind==0)
        if(~isempty(fse))
            break;
        end
    else
        delete(h);
        fse=is(ind);
        sels=fss:fse;
        h=plot(cs(sels,1),cs(sels,2),'k-s');
    end
end


function SelectAllZigZags(co,cs,t,imids,LM,LMw,Speeds)

% Select the turning points
mf=MeanFlightAng(co);
[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(mf,t,0.17,0.04,0);
ex=[ma mi];
subplot(1,2,1)
PlotNestAndLMs(LM,LMw,[0 0],0);
hold on;
plot(cs(:,1),cs(:,2),cs(ex,1),cs(ex,2),'o',cs(imids,1),cs(imids,2),'rx')
axis equal
hold off
sp=1;
while 1
    subplot(1,2,1)
    [ind,b]=GetNearestClickedPt(cs(ex,:),'click end of ZZ; return to stop');
    if(ind==0)
        meana=mf(en);
        break;
    else
        en=ex(ind);
        is=sp:en;
        subplot(1,2,2)
        PlotNestAndLMs(LM,LMw,[0 0],0);
        hold on;
        plot(cs(is,1),cs(is,2),cs(ex(1:ind),1),cs(ex(1:ind),2),'o')%,cs(imids,1),cs(imids,2),'rx')
        axis equal
        hold off
    end
end
dco=AngularDifference(meana,co(is));
% get the zigzag
ztimeP=[];
zdsP=[];
[rspzz,ztimeP,zdsP,rtz,izP,rtzA,rtDat]=GetZZData2(dco,cs(is),t(is),ztimeP,zdsP,Speeds(is)',co(is));
[zztime2,ztime2,zds2,tz2,iz2,zzd]=GetZZData(dang2,10,cs,ts,zztime2,ztime2,zds2,tz2);
 

function[zzls,zls,zds,tzz,izz,zzds]=GetZZData(dang,athresh,cs,ts,zzls,zls,zds,tzz)

% zigs=find(dang<-athresh);
% zags=find(dang>athresh);
% [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,cs);
% [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,cs);

tps=find(diff(dang>0));

tpts=ts(tps);
zls=[zls diff(tpts)];
zds=[zds diff(diff(tpts))];
c=1;
zzds=[];
for i=1:(length(tps)-1)
    is=tps(i):tps(i+1);
    ds=diff(cs(is,:));
    zzds(i)=sum(CartDist(ds));
end
izz=[];
allt=[];
while 1
    if(length(tps)>=c+2) 
        zzls=[zzls ts(tps(c+2)-1)-ts(tps(c))];
        is=tps(c):tps(c+2)-1;   
        relt=(ts(is)-ts(is(1)))/zzls(end);
        allt=[allt relt];
        tzz=[tzz relt];
        izz=[izz is];    
        c=c+1;
    else break;
    end
end

function[relsp,zls,zds,tzz,izz,tzza,rtdat,zzds,zzang,zzangl]= ...
    GetZZData2(dang,cs,ts,zls,zds,sp,fdir)

% figure(1),
[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetArcs(dang,ts,pi/20,0.03,0);
tps=sort([ma mi]);
pm=sin(dang(tps))>0;
c=1;
while(c<length(tps))
    s=mod(pm(c)+1,2);
    if(pm(c+1)==s) c=c+1;
    else
        tps=tps([1:c c+2:end]);
        pm=sin(dang(tps))>0;
    end
end
% figure(2),plot(cs(:,1),cs(:,2),cs(mi,1),cs(mi,2),'gs',cs(ma,1),cs(ma,2),'ro'...
%     ,cs(tps,1),cs(tps,2),'k*')
tpts=ts(tps);
zls=[zls diff(tpts)];
zds=[zds diff(diff(tpts))];
zzds=[];izz=[];relsp=[];tzz=[];zzang=[];zzangl=[];
if(length(tps)>1)
    for i=1:(length(tps)-1)
        is=tps(i):(tps(i+1)-1);
        ds=diff(cs(is,:));
        zzds(i)=sum(CartDist(ds));
        sp(i)=ts(is(1));
        relt=ts(is)-ts(is(1));
        maxrel(i)=max(relt);
        tzz=[tzz relt/maxrel(i)];
        izz=[izz is];
        prc90(i)=prctile(sp(is),90);
        relsp=[relsp sp(is)/prc90(i)];
        fd=fdir(is);
        [zzang(i),zzangl(i)]=MeanAngle(fd(abs(dang(is))<=(pi/18)));
    end

    % approximate 1st bit
    is=1:(tps(1)-1);
    if(~isempty(is))
        rtdat.len1=max(maxrel(1),ts(is(end))-ts(is(1)));
        rtdat.sp1=ts(is(end))-rtdat.len1;
        relt=ts(is)-rtdat.sp1;
        tzza=[relt/rtdat.len1 tzz];
    else
        tzza=tzz;
        rtdat.len1=maxrel(1);
        rtdat.sp1=sp(1);        
    end
    % relsp=[sp(is)/prc90(1) relsp];

    % approximate last bit
    is=(tps(end)):length(ts);
    if(~isempty(is))
        rtdat.sp2=ts(is(1));        
        relt=ts(is)-rtdat.sp2;
        rtdat.len2=max(maxrel(end),relt(end));
        tzza=[tzza relt/rtdat.len2];
    else
        rtdat.len2=maxrel(end);
        rtdat.sp2=sp(end);        
    end
else
    rtdat.sp1=ts(1);
    rtdat.sp2=ts(1);
    relt=ts-ts(1);
    mr=max(relt);
    rtdat.len1=mr;
    rtdat.len2=mr;
    tzza=relt/mr;
end


function[s,e,l,med_ind]=StartFinish(t,is,th)
s=[];e=[];l=[];med_ind=[];
if(isempty(is)) return; end;
i=1;
while 1
    s=[s is(i)];
    ex=find(diff(t(is(i:end)))>th,1);
    if(isempty(ex)) 
        e=[e is(end)];
        break;
    else e=[e is(i+ex-1)];
    end
    i=i+ex;
end
l=e-s+1;
for i=1:length(s)
    med_ind(i)=GetTimes(t,median(t(s(i):e(i))));
end

function SetHeightWid(hdls)

for i=hdls
    set(i,'Units','centimeters');
    p=get(i,'Position');
    p([3 4])=[5.9078 4.0384];
    set(i,'Position',p);
end

function MotifFigs(h,ty)

% openfig('2WCCW LoopsVsZZs NLMOnRet Over FToNest');
% return

if(ty==1)  % non contour-plot)
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\StraightLineAngles In Loops And ZZs.fig',1)
    % p1=get(gcf,'Position')
    % set(gca,'Units','centimeters');Pos=get(gca,'Position')
    p1=[215 407 311 190];
    p2=[1.5334 0.6081 5.9078 4.0384];
else   % contour plot
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\FDirVsPsiContour Straights Ins.fig',1)
    % Pos=get(gcf,'Position')
    p1=[217 407 311 267];
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\StraightLineAngles In Loops And ZZs.fig',1)
    % set(gca,'Units','centimeters');Pos=get(gca,'Position')
    p2=[1.5334 0.6081 5.9078 5.9078];
end
set(h,'Position',p1);
set(gca,'Units','centimeters','Position',p2);
