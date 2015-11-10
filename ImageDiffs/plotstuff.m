function plotstuff

% AllRes('Bin1Obj');
dwork;
cd New\unwrappedOz\'route 1 - open'/
% st=cell(4,4);
st=[];
cd ../'route 1 - open'/
st=RunScript(1,st);
cd ../'route 2 - open'/
st=RunScript(2,st);
cd ../'route 4 - mediumV2'/
st=RunScript(3,st);
cd ../'route 3 - tussocky'\
st=RunScript(4,st);
% [p1,a1,stats1]=anovan(st(:,1),{st(:,4) st(:,5)},'model','full')
% multcompare(stats1)
% [p2,a2,stats2]=anovan(st(:,2),{st(:,4) st(:,5)},'model','interaction')
% multcompare(stats2)



function[st]=RunScript(pp,st)
AllRes('Bin1Obj');
return;
% AllRes('BinAll');
s=dir('I*RSC.mat');
goal=round(0.5*length(s));
goal=floor(0.5*length(s));

skycs=[0:50:250];
mc=[];
for skyc=250%skycs
%     fn=['AllResSkyC' int2str(skyc) 'V2Bin1Obj.mat'];
%     fn=['AllResSkyC' int2str(skyc) 'V2Bin1ObjNoSmooth.mat'];
%     fn=['AllResSkyC' int2str(skyc) 'V2Bin1ObjNoSmoothLowestCA.mat'];
    fn=['AllResSkyC' int2str(skyc) 'V2Bin1ObjLowestCA.mat'];
    load(fn)
% %     mc=[mc;median(cadiff(:,[3,4])) median(rca(:,[3,4]))];
%     for i=1:length(s)
%         imdiffsBlurBin(i,1);
% %         imdiffsBlurBin(i,2);
% %         imdiffsBinaryOneObj(i,1,skyc);
%     end
end
% raw and high skyline are rows 4 and 6, nearest min errors rows 11 and 12
rs=[4 6];rnm=[11 12];
% ins=find(nrca(4,:)>10);ds=0:length(ins)-1;
ins=1:21;ds=0:20;ns=nrca(4,ins);
% figure(1),subplot(4,1,pp)
% % plot(ds,ca50(rs,ins),ds,ca25(rs,ins),'r--',ds,ca75(rs,ins),'k--')%...
% %     ,ds,ca5(rs,ins),':',ds,ca95(rs,ins),':')
% L=ca50(rs,ins)-ca25(rs,ins);U=ca75(rs,ins)-ca50(rs,ins);
% errorbar(ds,ca50(4,ins),L(1,:),U(1,:),'b')
% hold on, errorbar(ds,ca50(6,ins),L(2,:),U(2,:),'r--'),hold off
% axis tight,Setbox,xlabel('distance (m)'),ylabel('IDF (normalised)')
% figure(7),subplot(4,1,pp);m1=max(craw50(4,ins));m2=max(craw50(6,ins));
% L=craw50(rs,ins)-craw25(rs,ins);U=craw75(rs,ins)-craw50(rs,ins);
% errorbar(ds,craw50(4,ins)/m1,L(1,:)/m1,U(1,:)/m1,'b'),hold on
% errorbar(ds,craw50(6,ins)/m2,L(2,:)/m2,U(2,:)/m2,'r--'),hold off
% axis tight,Setbox,xlabel('distance (m)'),ylabel('IDF (normalised)')
% figure(2),subplot(4,1,pp)
% % plot(ds,rca50(rs,ins),ds,rca25(rs,ins),'r--',ds,rca75(rs,ins),'k--')%...
% %     ,ds,rca5(rs,ins),':',ds,rca95(rs,ins),':')
% L=rca50(rnm,ins)-rca25(rnm,ins);U=rca75(rnm,ins)-rca50(rnm,ins);
% errorbar(ds,rca50(4,ins),L(1,:),U(1,:),'b')
% hold on, errorbar(ds,rca50(6,ins),L(2,:),U(2,:),'r--'),hold off
% axis tight,Setbox,xlabel('distance (m)'),ylabel('error (degrees)'),ylim([0 120])
% figure(3),subplot(4,1,pp)
% % plot(ds,rca50(rnm,ins),ds,rca25(rnm,ins),'r--',ds,rca75(rnm,ins),'k--')%...
% %     ,ds,rca5(rnm,ins),':',ds,rca95(rnm,ins),':')
% L=rca50(rnm,ins)-rca25(rnm,ins);U=rca75(rnm,ins)-rca50(rnm,ins);
% errorbar(ds,rca50(11,ins),L(1,:),U(1,:),'b')
% hold on, errorbar(ds,rca50(12,ins),L(2,:),U(2,:),'r--'),hold off
% axis tight,Setbox,xlabel('distance (m)'),ylabel('error (degrees)'),ylim([0 120])
% 
% % a=[median(cadiff(:,[4,6])) median(rca(:,[11:14]))];
% 
% % load AllResBin1Obj%All%
% % load AllResBinAll%
dr=cd;
cd('C:\MATLAB\R2007b\toolbox\stats');
figure(1),
% subplot(4,2,(2*pp)-1),boxplot(cadiff(:,[4,6])),ylim([0 length(s)])
% subplot(4,1,pp),boxplot(cadiff(:,[4,6,11,13])),ylim([0 16]),Setbox;
subplot(4,1,pp),boxplot(cadiff(:,[4,6])),ylim([0 16]),Setbox;
ylabel('Catchment radius (m)')
xlabel('')
SetXTicks(gca,2,[],[],[1 2],{'raw';'skyline'}),ylim([0 16]),Setbox
figure(2)
subplot(4,1,pp),boxplot(rca(:,[11,12])),ylim([0 16]),Setbox;
ylabel('Catchment radius (m)')
xlabel('')
SetXTicks(gca,2,[],[],[1 2],{'raw';'skyline'}),ylim([0 16]),Setbox
figure(3)
subplot(2,2,pp),
boxplot(rca(:,[13,14]))
hold on,
m1=median(rca(:,11));
m2=median(rca(:,12));
plot([0.5 1.5],[m1 m1], 'k--',[1.5 2.5],[m2 m2], 'k--'),
hold off
ylabel('Catchment radius (m)')
xlabel('')
SetXTicks(gca,2,[],[],[1 2],{'raw';'skyline'}),ylim([0 16]),Setbox
% % title('DID CA')
% % figure(2),
% % subplot(4,3,(3*pp)-2),boxplot(cadiff(:,[4,6,7])),ylim([0 length(s)])
% % subplot(4,3,3*pp-1),boxplot(rca(:,[11,12,15])),ylim([0 length(s)])
% % subplot(4,3,(3*pp)),boxplot(rca(:,[13,14])),ylim([0 length(s)])
cd(dr)
% figure(1)
% subplot(4,1,pp),getResults2(['Goal' int2str(goal) 'SkyC250Bin1Obj.mat'],goal,1,1,2)
% title('Rot CA')
% plot(skycs,mc),mc
% st(pp,1)={cadiff(:,4)};
% st(pp,2)={cadiff(:,6)};
% st(pp,3)={rca(:,11)};
% st(pp,4)={rca(:,12)};

route=ones(2*length(s),1)*pp;
raworsky=[ones(length(s),1);ones(length(s),1)*2];
s=[[cadiff(:,4);cadiff(:,6)] [rca(:,11);rca(:,12)] ...
    [rca(:,13);rca(:,14)] route raworsky];
st=[st;s];

medca=median(cadiff(:,[4,6]))
% praw=signrank(rca(:,13)-rca(:,11))
% psky=signrank(rca(:,14)-rca(:,12))

%     fn=['AllResSkyC' int2str(skyc) 'V2Bin1Obj'];
%     load(fn)
% a=[a;median(cadiff(:,[4,6])) median(rca(:,[11:14]))]

% figure(2),boxplot(rca)%(:,[2,4,6]))

% subplot(4,1,i)
% load Goal1Med1Bin1Obj
% plot(es_all([4 7],:)')
% plot(dscale([4 7],:)')
% axis tight,Setbox,%ylim([-180 180])


function AllRes(fend)
s=dir('I*RSC.mat');
meds=[1];% 3 5 9 15];
meds=[250]% 0 100 200 150 50];

% NoMin=1;  % calculates the  IDF based CAs without spurious minima
NoMin=2;  % calculates the minimal IDF based CAs
for j=1:length(meds)
%     ca_raw=zeros(length(s),1);
%     ca_sky=zeros(length(s),1);
    cadiff=[];
    rca=[];
    errdist(12,length(s)).err=[];
    errdist(12,length(s)).erc=[];
    errdist(12,length(s)).eraw=[];
    for i=1:length(s)
%         outfile=['Goal' int2str(i) 'Med' int2str(meds(j)) 'V2.mat'];
%         [ca_raw(i,:),ca_sky(i,:),rca(i,:)]=getResults(outfile);
%         outfile=['Goal' int2str(i) 'Med' int2str(meds(j)) fend '.mat'];
        outfile=['Goal' int2str(i) 'SkyC' int2str(meds(j)) fend '.mat'];
%         outfile=['Goal' int2str(i) 'Med' int2str(meds(j)) 'BinAll.mat'];
        [ca,rc,ed,edc]=getResults2(outfile,i,0,3,NoMin);
%         [ca,rc,ed]=getResults2(outfile,i,1,1);
        for m=1:size(ed,1)
            for k=1:size(ed,2) 
                errdist(m,k).err=[errdist(m,k).err ed(m,k).err];
            end
        end
        for m=1:size(edc,1)
            for k=1:size(ed,2)
                errdist(m,k).erc=[errdist(m,k).erc edc(m,k).err];
                errdist(m,k).eraw=[errdist(m,k).eraw edc(m,k).eraw];
            end
        end
                
        cadiff=[cadiff;ca];
        rca=[rca;rc];
    end
    %     dat(j).ca_raw=ca_raw;
    for m=1:size(ed,1)
        for k=1:size(ed,2)
            errs=abs([errdist(m,k).err]);
            mrca(m,k)=[mean(errs)];
            srca(m,k)=[std(errs)];
            nrca(m,k)=[length(errs)];
            grca(m,k)=[length(find(errs<45))];
            rca50(m,k)=prctile(errs,50);
            rca25(m,k) = prctile(errs,25);
            rca75(m,k) = prctile(errs,75);
            rca5(m,k) = prctile(errs,5);
            rca95(m,k) = prctile(errs,95);
        end
    end
    for m=1:size(edc,1)
        for k=1:size(edc,2)
            errc=abs([errdist(m,k).erc]);
            mca(m,k)=mean(errc);
            sca(m,k)=std(errc);
            ca50(m,k)=prctile(errc,50);
            ca25(m,k) = prctile(errc,25);
            ca75(m,k) = prctile(errc,75);
            ca5(m,k) = prctile(errc,5);
            ca95(m,k) = prctile(errc,95);
            errc=abs([errdist(m,k).eraw]);
            mcraw(m,k)=mean(errc);
            scraw(m,k)=std(errc);
            craw50(m,k)=prctile(errc,50);
            craw25(m,k) = prctile(errc,25);
            craw75(m,k) = prctile(errc,75);            
        end
    end

    dat(j).cadiff=cadiff;
    dat(j).rca=rca;
    %     save(['AllRes' fend '.mat'])%Bin1Obj%All%
    %     save(['AllResSkyC' int2str(meds(j)) fend '.mat'])%Bin1Obj%All%
    %      save(['AllResSkyC250V2' fend '.mat'])
    if(NoMin==1) save(['AllResSkyC250V2' fend 'NoSmoothNoBadMin.mat']);
%     elseif(NoMin==2) save(['AllResSkyC250V2' fend 'NoSmoothLowestCA.mat']);
    elseif(NoMin==2) save(['AllResSkyC250V2' fend 'LowestCA.mat']);
    else save(['AllResSkyC250V2' fend 'NoSmooth.mat']);
    end
end
% 


function[cadiff,rca,errdist,errca]=getResults2(fn,goal,pl,mfilt,minmin)

load(fn);
le=size(dscale,1);
for i=1:le
    [cadiff(i),CA(i).is]=GetCA2(dscale(i,:),goal,mfilt,minmin);
end
for i=4:6
    [cadiff(i-3+le),CA(i-3+le).is]=GetCA_Diff(dscale(i,:),goal,mfilt,minmin);
end
Tol=45;
rca=sum(abs(es_all)<=Tol,2)';
ds_all=abs([1:size(es_all,2)]-goal);


% % this bit does smoothed skylines - doesn't add much to the answers
% [ys,is]=VisCompSkylinesPS(skyhi,goal);
% s=sum(abs(ys)<=Tol);
% rca=[rca s];

% this gets continuos rot ca
[s1,isca1]=GetRCA(es_all(4,:),goal,Tol,mfilt);
[s2,isca2]=GetRCA(es_all(6,:),goal,Tol,mfilt);
[s5,isca5]=GetRCA(es_all(7,:),goal,Tol,mfilt);
rca=[rca s1 s2];
% this gets nearest minimum errors and then continuous rcas
tol2=0.05;nummin=3;%pl=0;
if(pl) figure(3); end;
es4=GetRCAErrsNM(dd4,goal,tol2,pl,nummin);
if(pl) figure(4); end;
es6=GetRCAErrsNM(dd6,goal,tol2,pl,nummin);

% es6=GetRCAErrsNM(dd7,goal,tol2,pl);

[s3,isca3]=GetRCA(es4,goal,Tol,mfilt);
[s4,isca4]=GetRCA(es6,goal,Tol,mfilt);
rca=[rca s3 s4 s5];

% get errors over distance
es_all=[es_all;es4;es6];
for j=0:(size(es_all,2)-1)
    inds=ds_all==j;
    for i=1:size(es_all,1)
        errdist(i,j+1).err=es_all(i,inds);
    end
    for i=1:size(dscale,1)
        errca(i,j+1).err=dscale(i,inds);
        errca(i,j+1).eraw=dall(i,inds);
    end
end

nfraw=prctile(dall([4],:),80)
nsky=prctile(dall([6],:),80)
if((nargin<3)|pl)
    figure(1)
    plot(is-goal,dscale(4,:),'k-',(CA(4).is)-goal,dscale(4,CA(4).is),'ks',...
        is-goal,dscale(6,:),'r-',(CA(6).is)-goal,dscale(6,CA(6).is),'ro')
%         is,dscale(4,:),'b-',CA(4).is,dscale(4,CA(4).is),'bd',...
    xlabel('distance (m)');ylabel('IDF (normalised)');
    axis tight,xlim([-15 16]),Setbox
% % %     title(int2str(cadiff([2,4,6])));Setbox
%     figure(1)
%     plot(is-goal,es_all(4,:),'k',isca1-goal,es_all(4,isca1),'ks',...
%          is-goal,es_all(6,:),'r',isca2-goal,es_all(6,isca2),'ro'), ...%,is,es_all(4,:),'r')
% %         isca3-goal,es4(isca3),'k--.',isca4-goal,es6(isca4),'r--x',...
% % %         is,es_all(7,:),'r',isca2,es_all(7,isca2),'ro'), ...%,is,es_all(4,:),'r')
%     xlabel('distance (m)');ylabel('error (degrees)');
%     axis tight,xlim([-15 16]),ylim([-180 180]),Setbox
%         xlim([0 32])

%     title(int2str(rca([2,4,6,8])));Setbox
end

function[ca,isca]=GetCA2(df2,goal,rvals,opt)
% counterL=0; counterR=0;

if(nargin<3) rvals=3; end;
l=length(df2);
vR=medfilt1(df2([1 1:l l]),rvals);
vR=vR(2:end-1);
vR(goal)=0;
n=gradient(vR([goal goal:l l]));
dR=n(2:end-1);
n=gradient(vR([goal goal:-1:1 1]));
dL=n(2:end-1);

caR=find(dR<0,1);
caL=find(dL<0,1);

if(isempty(caR)) caR=l-goal;
else caR=caR-2;
end

if(isempty(caL)) caL=goal-1;
else caL=caL-2;
end

% get rid of 'spurious' minima ie 11011 counting as 2 (opt=1)
% or use the minimal area within which a gradient applies (opt=2)
if(opt==1)
    if(caL==1) caL=0;end
    if(caR==1) caR=0;end
elseif(opt==2)
    caL=max(caL-1,0);
    caR=max(caR-1,0);    
end

% if necessary (opt =-1) calculates the catchment area not radius 
if(opt==-1) ca=caL+caR; 
else ca=0.5*(caL+caR);  
end
isca=[max(goal-caL,1):min(goal+caR,l)];


function[ca,isca]=GetCA_Diff(df2,goal,rvals,opt)
if(nargin<3) rvals=3; end;
l=length(df2);
vR=medfilt1(df2([1 1:l l]),rvals);
vR=vR(2:end-1);
vR(goal)=0;
dR=diff(vR([goal:l]));
dL=diff(vR([goal:-1:1]));

caR=find(dR<0,1);
caL=find(dL<0,1);
if(isempty(caR)) caR=l-goal;
else caR=caR-1;
end
if(isempty(caL)) caL=goal-1;
else caL=caL-1;
end

% get rid of 'spurious' minima ie 11011 counting as 2 (opt=1)
% or use the minimal area within which a gradient applies (opt=2)
if(opt==1)
    if(caL==1) caL=0;end
    if(caR==1) caR=0;end
elseif(opt==2)
    caL=max(caL-1,0);
    caR=max(caR-1,0);    
end

% if necessary (opt =-1) calculates the catchment area not radius 
if(opt==-1) ca=caL+caR; 
else ca=0.5*(caL+caR);  
end

isca=[max(goal-caL,1):min(goal+caR,l)];
% plot(1:length(df2),df2,'-x',isca,df2(isca),'rs')

function[rca,isca]=GetRCA(es,goal,th,rvals)
if(nargin<4) rvals=3; end;
l=length(es);
se=medfilt1(abs(es([1 1:l l])),rvals);
se=se(2:end-1);
se(goal)=0;
caR=find(se(goal:end)>th,1);
caL=find(se(goal:-1:1)>th,1);
if(isempty(caR)) caR=l-goal;
else caR=caR-2;
end
if(isempty(caL)) caL=goal-1;
else caL=caL-2;
end

opt=1;
% if necessary (opt =-1) calculates the catchment area not radius 
if(opt==-1) rca=caL+caR; 
else rca=0.5*(caL+caR);  
end

isca=[max(goal-caL,1):min(goal+caR,l)];
% plot(1:length(es),es,'r-x',isca,es(isca),'bs')


function[ca_raw,ca_sky,rca]=getResults(fn)
load(fn);
% randim=ig(:,randperm(360));
% randd=sum(sum((randim-ig).^2));
% randim2=newim(:,randperm(360));
% randd2=sum(sum((randim2-ig).^2));
pv=90;
rval=prctile(dnew,pv);%min(randd,randd2);

% skyg=skylines(goal,:);
% for i=1:size(skylines,1) 
%     randds(i)=sum((skyg-skylines(i,randperm(360))).^2); 
% end
rvals=prctile(df2,pv);%median(randds);
[ca_raw,CAr]=GetCA2(dnew,goal);
[ca_sky,CAs]=GetCA2(df2,goal);
% figure(1)
% plot(is,df2/rvals,'k--',CAs,df2(CAs)/rvals,'k-s',...
%     is,dnew/rval,'b--',CAr,dnew(CAr)/rval,'b-s')
% xlabel('distance (m)');ylabel('error (degrees)');Setbox
% figure(2)
rca=RotCA(skylines,goal,mini,mini2);

function[rca,s,r,o]=RotCA(skylines,goal,mini,mini2,Tol)
if(nargin<5) Tol=45; end;

[ys,is]=VisCompSkylinesPS(skylines,goal);
s=find(abs(ys)<=Tol);
[es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
r=find(abs(es1)<=Tol);
[es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
o=find(abs(es2)<=Tol);
rca=[length(r) length(s) length(o)];

% plot(is,ys,'k',is,es1,'b',is,es2,'r',...
%     is(s),ys(s),'ks',is(r),es1(r),'bo',is(o),es2(o),'rd')
% xlabel('distance (m)');ylabel('error (degrees)');Setbox

function[em1,ks]=VisCompSkylinesPS(s,goal)

m=medfilt1(s,3);
ig=s(goal,:);
igm=m(goal,:);
len=size(s,1);
for i=1:len 
   [m1(i),rim,imin,mind(i),d(i,:)]=VisualCompass(igm,m(i,:));  
%      [mini2(i),rim2,imin2,mind2(i),dd2(i,:)]=VisualCompass(s(i,:),s((min(len,i+1)),:));
%      [m2(i),rim2,imin2,mind2(i),d2(i,:)]=VisualCompass(m(i,:),m((min(len,i+1)),:));
end; 
[em1,ns]=min([m1-1;361-m1]);is=find(ns==2);
em1(is)=em1(is)*-1;
ks=1:len;


function[ca,isca]=GetCA(df2,goal,rvals)
if(nargin<3) rvals=3; end;
l=length(df2);
n=gradient(df2([goal goal:l l]));
vR=medfilt1(n,rvals);
vR=vR(2:end-1);

n=gradient(df2([goal goal:-1:1 1]));
vL=medfilt1(n,rvals);
vL=vL(2:end-1);

caR=find(vR<0,1);
caL=find(vL<0,1);
if(((l-goal)<2)||isempty(caR)) caR=100+l-goal;
else caR=caR-2;
end
if((goal<3)||isempty(caL)) caL=100+goal-1;
else caL=caL-2;
end
ca=[caL,caR];
isca=[max(goal-caL,1):min(goal+caR,l)];



function talkpics
fn1='Pos1RSC_med1_s5';
% fn2='PosEndRSC_med1_s5';
fn2='Pos22RSC_med1_s5';
% dummy(fn1)
% figure(1), hold on
% dummy(fn2)
% figure(1), hold off

% function dummy(fn)
load(fn1)
figure(1);
plot(is,df2/median(df2(bs)),'k','LineWidth',1.5)
% plot(is,df/median(df(bs)),'k',is,df2/median(df2(bs)),'k:x',is,dnew/median(dnew(bs)),'r-s',is,sd/median(sd(bs)),'b--*')
set(gca,'FontSize',14)
xlabel('distance (m)')
ylabel('error ')
axis tight
Setbox
figure(2)
[ys,xs]=VisCompSkylinesPS(skylines,goal)
plot(xs,ys,'k','LineWidth',1.5)
xlabel('distance (m)')
ylabel('error (degrees)')
axis tight
Setbox
[es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
[es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
figure(3)
plot(is,es1,'k','LineWidth',1.5)
xlabel('distance (m)')
ylabel('error (degrees)')
axis tight
Setbox
load(fn2)
ep=22;%length(s);
figure(1); hold on
plot(is(1:ep),df2(ep:-1:1)/median(df2(bs)),'r','LineWidth',1.5)
% plot(is,df/median(df(bs)),'k',is,df2/median(df2(bs)),'k:x',is,dnew/median(dnew(bs)),'r-s',is,sd/median(sd(bs)),'b--*')
set(gca,'FontSize',14)
xlabel('distance (m)')
ylabel('error ')
axis tight
Setbox
hold off
figure(2)
[ys,xs]=VisCompSkylinesPS(skylines,goal)
hold on
plot(xs(1:ep),ys(ep:-1:1),'r','LineWidth',1.5)
xlabel('distance (m)')
ylabel('error (degrees)')
axis tight
Setbox
[es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
[es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
hold off;
figure(3),hold on
plot(is,es1,'r','LineWidth',1.5)
xlabel('distance (m)')
ylabel('error (degrees)')
axis tight
Setbox
hold off