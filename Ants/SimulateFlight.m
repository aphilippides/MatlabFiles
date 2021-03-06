function SimulateFlight
% SimulateLoop
% SimulateAllLoops
% 
% SimulateZZ
% CheckKLDiv
% GetAllParams
% f2nstats;

% load 2ECCWRetinalRatesNearNest 
% % PlotRetinalRatesSpace(nest,LM,LMWid,xp,yp,RMb4,RMaft,s)
% % caxis
% % this is median of the median data per loop
% cax=[120 320];
% PlotRetinalRatesSpace(nest,LM,LMWid,xp,yp,RMb4,RMaft,s,cax,1)
% this is data medianed over all the points in the loops not per loop
% cax=[100 250];
% PlotRetinalRatesSpace(nest,LM,LMWid,xp,yp,RMb42,RMaft2,s,cax) 
SimulateLoopPhase
% SimulateAllZZs

function GetAllParams
load 2e2wPhaseDataAll
[lfa,lca,lra,lfra,lcra,lrra,lftpa,lctpa,loostat]=...
    getparams([wPhDat.dat1 wPhDat.dat2 wPhDat.dat3 wPhDat.dat4 ...
    ePhDat.dat1 ePhDat.dat2 ePhDat.dat3 ePhDat.dat4],...
    [wPhDat.m1;wPhDat.m2;wPhDat.m3;wPhDat.m4; ...
    ePhDat.m1;ePhDat.m2;ePhDat.m3;ePhDat.m4],1,[20:23],'k');
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zzstat]=...
    getparams([wzPhDat.dat1 wzPhDat.dat2 wzPhDat.dat3 wzPhDat.dat4 ...
    ezPhDat.dat1 ezPhDat.dat2 ezPhDat.dat3 ezPhDat.dat4],...
    [wzPhDat.m1;wzPhDat.m2;wzPhDat.m3;wzPhDat.m4; ...
    ezPhDat.m1;ezPhDat.m2;ezPhDat.m3;ezPhDat.m4],0,[20:23],'k:');
subplot(1,2,1),
contourf(lfa.xps,lfa.yps,lfa.D);g=colormap('gray');colormap(g(end:-1:1,:));
hold on;plot([lfa.me],lfa.xpt,'r',[lfa.med],lfa.xpt,'r:','LineWidth',1.5),hold off
subplot(1,2,2),
contourf(zfa.xps,zfa.yps,zfa.D);g=colormap('gray');colormap(g(end:-1:1,:));
hold on;plot([zfa.me],zfa.xpt,'r',[zfa.med],zfa.xpt,'r:','LineWidth',1.5),hold off

% 
% [lfa,lca,lra,lfra,lcra,lrra,lftpa,lctpa,loostatco]=...
%     getparams([wPhDat.dat1 wPhDat.dat3 ePhDat.dat1 ePhDat.dat3 ],...
%     [wPhDat.m1;wPhDat.m3;ePhDat.m1;ePhDat.m3],1,[20:23],'k');
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zzstatco]=...
%     getparams([wzPhDat.dat1 wzPhDat.dat3 ezPhDat.dat1 ezPhDat.dat3 ],...
%     [wzPhDat.m1;wzPhDat.m3;ezPhDat.m1;ezPhDat.m3],0,[20:23],'k:');


function f2nstats
load temp2e2w_LoopsAndZZs_f2nRelTstats

f2nl=[loostat.f2n];
nor=[loostat.nor];
t=[loostat.ts];
a1=AngularDifference(f2nl(t==-0.6),f2nl(t==-0.2))*180/pi;
a1=(f2nl(t==-0.6)-f2nl(t==-0.2))*180/pi;
a2=AngularDifference(f2nl(t==-0.2),f2nl(t==0.2))*180/pi;
a2=(f2nl(t==-0.2)-f2nl(t==0.2))*180/pi;
l1=abs(a1(~isnan(a1)));
l2=abs(a2(~isnan(a2)));
rl=a2./a1;
rl=rl(~isnan(rl));

f2nl=[zzstat.f2n];
nor=[zzstat.nor];
t=[zzstat.ts];
a1=AngularDifference(f2nl(t==-0.6),f2nl(t==-0.2))*180/pi;
a1=(f2nl(t==-0.6)-f2nl(t==-0.2))*180/pi;
a2=AngularDifference(f2nl(t==-0.2),f2nl(t==0.2))*180/pi;
a2=(f2nl(t==-0.2)-f2nl(t==0.2))*180/pi;
z1=abs(a1(~isnan(a1)));
z2=abs(a2(~isnan(a2)));
rz=a2./a1;
rz=rz(~isnan(rz));

[ra_z,sp_h]=ranksum(l1,l2)
[ra_z,sp_h]=ranksum(z1,z2)
[ra_zl,sp]=ranksum(rl,rz)
meds=[median(l1) median(l2) median(z1) median(z2) median(rl) median(rz)] 

function CheckKLDiv
sstrs={'2ecw','2eccw','2wcw','2wccw'};
mstr={'relf';'fdir';'Body';'psi';'o2n';'relc';'rellm1';'rellm2'};
for k=3:4
    figure(k);
    sstr=char(sstrs(k));
    for i=1:8
        fs=[sstr '_da_' char(mstr(i)) '_Loops.mat'];
        load(fs,'da*')
        for j=1:12
            eval(['la' int2str(j) '=da' int2str(j) ';'])
        end
        load([sstr '_da_' char(mstr(i)) '_ZZs'],'da*')

        % check bin of retinal nest
        dp=da7;
        lp=la7;
        g=10;
        [y,x]=AngHist(lp(g(1)).x*180/pi,[],[],0);
        [y1,x]=AngHist(dp(g(1)).x*180/pi,[],[],0);
        p1=(y+eps)/sum(y+eps);
        p2=(y1+eps)/sum(y1+eps);
        subplot(3,3,i)
        plot(x,y/sum(y),x,y1/sum(y1),'r:')
        axis tight;
        if(isempty(lp(g(1)).x)||isempty(dp(g(1)).x))
            kl(i)=NaN;
        else
        kl(i)=kldiv(x,p1,p2,'sym');
        end
        title([char(mstr(i)) ': KL Div ' num2str(kl(i),3)])

        %     plot(np,[dp.meang]*180/pi,cst,np,ma+[dp.angsd]*180/pi,cst, ...
        %         np([1 end]), [ma ma],'k')
    end
end

function SimulateAllLoops

load loopstatstemp
fs='SimulateLoopParams.mat';
if(~isfile(fs))
    SimulateLoop;
end
load(fs)
ea=[];
eb=[];
for i=1:length(loops)
    ps=find(loops(i).Picked);
    for j=1:length(ps)
        [e1,e2]=SimulateRealPath(loops,i,ps(j),f2c,f2a,tdiv,xp,rcoc,rcoa);
        if(~isempty(e1))
            ea=[ea;[e1 i j]];
            eb=[eb;[e2 i j]];
        end
%         disp('press any key to continue: ')
%         pause;
    end
end
keyboard

function SimulateAllZZs

load processzigzagsin
fs='SimulateZZParams.mat';
if(~isfile(fs))
    SimulateZZ;
end
load(fs)
ea=[];
eb=[];
for i=1:length(fltsec)
    ps=(fltsec(i).fsec);
    for j=1:length(ps)
        [e1,e2]=SimulateRealZZ(fltsec,i,j,f2c,f2a,tdiv,xp,rcoc,rcoa);
        if(~isempty(e1))
            ea=[ea;[e1 i j]];
            eb=[eb;[e2 i j]];
        end
%         disp('press any key to continue: ')
%         pause;
    end
end
keyboard


function[x,y,f,o2n]=SimulatePath(st,f2n,sp,t)
x(1)=st(1);
y(1)=st(2);

% flight 1
% 2 19; 2 21; 3 3; 4 10;6 12; 7 25;8 23; 8 38
% flight 10
% 16 20; 16 30; 17 28 and the one before
for i=1:(length(t)-1)
    o2n(i)=mod(cart2pol(-x(i),-y(i))-4.9393,2*pi);
    f(i)=mod(f2n(i)+o2n(i),2*pi);
    f(i)=mod(f(i)+4.9393,2*pi);
    td=t(i+1)-t(i);
    [dx,dy]=pol2cart(f(i),sp(i)*td);
    x(i+1)=x(i)+dx;
    y(i+1)=y(i)+dy;
end
i=length(t);
o2n(i)=cart2pol(x(i),y(i));
f(i)=mod(f2n(i)+o2n(i),2*pi);

function SimulateZZ

[psicw,psiaw,f2ncw,f2naw,cocw,coaw,tcw,taw,rcocw,rcoaw,...
    spcw,spaw,rspcw,rspaw]=ZZPsi;

divi=-720:60:720;
divi=-30:30:540;
tdiv=0:0.1:1;
thd=20;
figure(3)
[Df2ncw,xs,ys,xps,yps]=Density2D(f2ncw*180/pi,tcw,[-180:thd:190]-thd/2,tdiv);
[Df2naw,xs,ys,xps,yps]=Density2D(f2naw*180/pi,taw,[-180:thd:190]-thd/2,tdiv);
[datc,xp]=StatsOverX(tcw,f2ncw,tdiv);
[data,xp]=StatsOverX(taw,f2naw,tdiv);
f2c=[datc.meang];
f2a=[data.meang];
subplot(2,2,1),contourf(xps,yps,Df2ncw);hold on;plot(f2c*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,2),contourf(xps,yps,Df2naw);hold on;plot(f2a*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
[Dspcw,xs,ys,xps,yps]=Density2D(rspcw,tcw,tdiv,tdiv);
[Dspaw,xs,ys,xps,yps]=Density2D(rspaw,taw,tdiv,tdiv);
[dspc,xp]=StatsOverX(tcw,rspcw,tdiv);
[dspa,xp]=StatsOverX(taw,rspaw,tdiv);
spc=[dspc.med].^1;
spa=[dspa.med].^1;
subplot(2,2,3),contourf(xps,yps,Dspcw);hold on;plot(spc,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,4),contourf(xps,yps,Dspaw);hold on;plot(spa,xp,'w','LineWidth',2);hold off;axis tight;

figure(7),
rcocw=mod(rcocw,2*pi);
rcoaw=mod(rcoaw,2*pi);
[Df2ncw,xs,ys,xps,yps]=Density2D(rcocw*180/pi,tcw,[0:thd:370]-thd/2,tdiv);
[Df2naw,xs,ys,xps,yps]=Density2D(rcoaw*180/pi,taw,[0:thd:370]-thd/2,tdiv);
[datc,xp]=StatsOverX(tcw,rcocw,tdiv);
[data,xp]=StatsOverX(taw,rcoaw,tdiv);
rcoc=mod([datc.meang],2*pi);rcoc(1)=0;
rcoa=mod([data.meang],2*pi);rcoa(1)=0;
subplot(2,2,1),contourf(xps,yps(2:end),Df2ncw(2:end,:));hold on;plot(rcoc*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,2),contourf(xps,yps(2:end),Df2naw(2:end,:));hold on;plot(rcoa*180/pi,xp,'w','LineWidth',2);hold off;axis tight;


spa=spa*50;spc=spc*50;

figure(4)
stp=[50 50];
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
[xa,ya,f,o2n]=SimulatePath([xc(end) yc(end)],f2a,ones(size(f2a))*median(spa),xp);
[xas,yas,f,o2n]=SimulatePath([xcs(end) ycs(end)],f2a,spa,xp);
subplot(2,1,1),plot([xc xa],[yc ya],'r:',[xcs xas],[ycs yas])
axis equal,set(gca,'YDir','reverse')
% subplot(2,2,2),plot(xa,ya,'r:',xas,yas),axis equal
stp=[-50 50];
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
[xa,ya,f,o2n]=SimulatePath([xc(end) yc(end)],f2a,ones(size(f2a))*median(spa),xp);
[xas,yas,f,o2n]=SimulatePath([xcs(end) ycs(end)],f2a,spa,xp);
subplot(2,1,2),plot([xc xa],[yc ya],'r:',[xcs xas],[ycs yas])
axis equal,set(gca,'YDir','reverse')
% subplot(2,2,4),plot(xa,ya,'r:',xas,yas),axis equal
save SimulateZZParams f2a f2c rcoc rcoa xp tdiv


function[err,errs]=SimulateRealZZ(zz,i,j,f2c,f2a,tdiv,xp,rcoc,rcoa)

co=zz(i).fsec(j).co;
o2n=zz(i).o2n;
izz=zz(i).fsec(j).is;
if(length(izz)<4)
    err=[];errs=[];
    return
end    

cs=zz(i).cs;
t=zz(i).t;
v1=MyGradient(cs(:,1),t);
v2=MyGradient(cs(:,2),t);
[Cent_Os,sp]=cart2pol(v1,v2);
co=Cent_Os-4.9393;
% f2n=AngularDifference(co,o2n(1:end-1));
f2n=AngularDifference(co,o2n);

ist=[izz(1)-1 izz izz(end)+1];
if(ist(end)>length(t))
    err=[];errs=[];
    return
end
[x,y,f,o2n]=SimulatePath2(mean(cs([izz(1) izz(1)-1],:)),f2n(izz),sp(izz),t(ist));
[rxc,ryc]=SimulatePathC(cs(izz(1),:),co(izz),sp(izz),t(ist));
% [x,y,f,o2n]=SimulatePath2((cs(is(1)-1,:)),f2n(is),sp(is),t(ist));
figure(5),
subplot(2,1,1),
plot(cs(izz,1),cs(izz,2),rxc,ryc,'r:'),axis equal,axis tight
title(['flight ' int2str(i) '; zz ' int2str(j)]);
subplot(2,1,2),plot(cs(izz,1),cs(izz,2),rxc,ryc,'r:'),axis equal,axis tight

relt=zz(i).fsec(j).reltDang2;
sps=find(relt==0);
eps=find(relt==1);
if(eps(1)<=sps(1)) eps=eps(2:end); end;
if(eps(end)<=sps(end)) sps=sps(1:end-1); end;
figure(6)
for k=1:length(sps)
    is=izz(sps(k):eps(k));
    tdi=tdiv*(t(is(end))-t(is(1)));
    % xp=0.05:.1:.95;
    t_is=xp*(t(is(end))-t(is(1)))+t(is(1));
    spi=interp1(t(is),sp(is),t_is);
    spx=interp1(t(is),cs(is,1),tdi+t(is(1)));
    spy=interp1(t(is),cs(is,2),tdi+t(is(1)));

    rcoc=rcoc+co(is(1));
    rcoa=rcoa+co(is(1));
    [h,ad1 ad2] = LoopHandednes(co(is));
    if(ad2(1)<0)
        h=-1;
        cstr='anti-clock';
    else
        h=1;
        cstr='clock';
    end

    if(h==-1)
        [xc,yc]=SimulatePath2(cs(is(1),:),f2a,spi,tdi);
        [rxc,ryc]=SimulatePathC(cs(is(1),:),rcoa,spi,tdi);
        subplot(2,1,1),plot(cs(is,1),cs(is,2),xc,yc,'r:'),
        axis equal,axis tight,Setbox,hold on
        subplot(2,1,2),plot(cs(is,1),cs(is,2),rxc,ryc,'r:'),
        axis equal,axis tight,Setbox,hold on
    else
        [xa,ya]=SimulatePath2(cs(is(1),:),f2c,spi,tdi);
        [rxa,rya]=SimulatePathC(cs(is(1),:),rcoc,spi,tdi);
        subplot(2,1,1),plot(cs(is,1),cs(is,2),xa,ya,'r:')
        axis equal,axis tight,Setbox,hold on
        subplot(2,1,2),plot(cs(is,1),cs(is,2),rxa,rya,'r:')
        axis equal,axis tight,Setbox,hold on
    end
end
subplot(2,1,1),hold off;%plot(cs(is,1),cs(is,2),xa,ya,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to nest')
title(['flight ' int2str(i) '; zz ' int2str(j)]);
subplot(2,1,2),hold off;%plot(cs(is,1),cs(is,2),rxa,rya,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to compass')
title(['Distance ' num2str(CartDist(cs(izz(1),:)))]);
            

% exc=sqrt(sum((xc-spx).^2+(yc-spy).^2));
% exa=sqrt(sum((xa-spx).^2+(ya-spy).^2));
% erc=sqrt(sum((rxc-spx).^2+(ryc-spy).^2));
% era=sqrt(sum((rxa-spx).^2+(rya-spy).^2));
% 
h=1;
errs=[];err=[];%h exc exa erc era];
% if(h==1) err=[exc erc];
% else err=[exa era];
% end


function[err,errs]=SimulateRealPath(loops,i,j,f2c,f2a,tdiv,xp,rcoc,rcoa)

co=loops(i).Co;
o2n=loops(i).o2n;
is=loops(i).loop(j).is
cs=loops(i).cs;
t=loops(i).t;
v1=MyGradient(cs(:,1),t);
v2=MyGradient(cs(:,2),t);
[h] = LoopHandednes(co(is));
% v1=diff(cs(:,1));
% v2=diff(cs(:,2));

[Cent_Os,sp]=cart2pol(v1,v2);
% co=Cent_Os-4.9393;
% f2n=AngularDifference(co,o2n(1:end-1));
% f2n=AngularDifference(co,o2n);
f2n=loops(i).f2n;
% [x,y,f,o2n]=SimulatePath(cs(is(1),:),f2n(is+1),sp(is),t(is));
% [x,y,f,o2n]=SimulatePath(cs(is(1),:),f2n(is),sp(is)*50,t(is));
ist=[is(1)-1 is is(end)+1];
if(ist(end)>length(t))
    err=[];errs=[];
    return
end
[x,y,f,o2n]=SimulatePath2(mean(cs([is(1) is(1)-1],:)),f2n(is),sp(is),t(ist));
    [rxc,ryc]=SimulatePathC(cs(is(1),:),co(is),sp(is),t(ist));
% [x,y,f,o2n]=SimulatePath2((cs(is(1)-1,:)),f2n(is),sp(is),t(ist));
figure(5),
subplot(2,1,1),
plot(cs(is,1),cs(is,2),rxc,ryc,'r:'),axis equal,axis tight
title(['flight ' int2str(i) '; loop ' int2str(j)]);
subplot(2,1,2),plot(cs(is,1),cs(is,2),rxc,ryc,'r:'),axis equal,axis tight

% plot(t(is),sp(is)),axis tight

tdiv=tdiv*(t(is(end))-t(is(1)));
% xp=0.05:.1:.95;
t_is=xp*(t(is(end))-t(is(1)))+t(is(1));
spi=interp1(t(is),sp(is),t_is);
spx=interp1(t(is),cs(is,1),tdiv+t(is(1)));
spy=interp1(t(is),cs(is,2),tdiv+t(is(1)));

rcoc=rcoc+co(is(1));
rcoa=rcoa+co(is(1));
% if(h==1) 
    [xc,yc]=SimulatePath2(cs(is(1),:),f2a,spi,tdiv);
    [rxc,ryc]=SimulatePathC(cs(is(1),:),rcoa,spi,tdiv);
%     else
        [xa,ya]=SimulatePath2(cs(is(1),:),f2c,spi,tdiv);
        [rxa,rya]=SimulatePathC(cs(is(1),:),rcoc,spi,tdiv);
% end
% [h [f2n(is(1)) f2a(1) f2c(1)]*180/pi]

exc=sqrt(sum((xc-spx).^2+(yc-spy).^2));
exa=sqrt(sum((xa-spx).^2+(ya-spy).^2));
erc=sqrt(sum((rxc-spx).^2+(ryc-spy).^2));
era=sqrt(sum((rxa-spx).^2+(rya-spy).^2));

errs=[h exc exa erc era];
if(h==1) err=[exc erc];
else err=[exa era];
end

figure(6),
if(h==1)
subplot(2,1,1),plot(cs(is,1),cs(is,2),xc,yc,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to nest')
title(['flight ' int2str(i) '; loop ' int2str(j)]);
subplot(2,1,2),plot(cs(is,1),cs(is,2),rxc,ryc,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to compass')
title(['Distance ' num2str(CartDist(cs(is(1),:)))]);
else
subplot(2,1,1),plot(cs(is,1),cs(is,2),xa,ya,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to nest')
title(['flight ' int2str(i) '; loop ' int2str(j)]);
subplot(2,1,2),plot(cs(is,1),cs(is,2),rxa,rya,'r:'),axis equal,axis tight,Setbox
xlabel('f dir rel to compass')
title(['Distance ' num2str(CartDist(cs(is(1),:)))]);
end
% subplot(2,2,3),plot(cs(is,1),cs(is,2),rxc,ryc,'r:'),axis equal,axis tight,Setbox
% subplot(2,2,4),plot(cs(is,1),cs(is,2),rxa,rya,'r:'),axis equal,axis tight,Setbox




rcoc(1)=0;
% keyboard;

function[x,y,f,o2n]=SimulatePath2(st,f2n,sp,t)
x(1)=st(1);
y(1)=st(2);

for i=1:(length(f2n))
    o2n(i)=mod(cart2pol(-x(i),-y(i))-4.9393,2*pi);
    f(i)=mod(f2n(i)+o2n(i),2*pi);
    f(i)=mod(f(i)+4.9393,2*pi);
%     td=0.5*(t(i+2)-t(i));
    td=(t(i+1)-t(i));
    [dx,dy]=pol2cart(f(i),sp(i)*td);
    x(i+1)=x(i)+dx;
    y(i+1)=y(i)+dy;
end
% i=length(t);
% o2n(i)=cart2pol(x(i),y(i));
f(i)=mod(f2n(i)+o2n(i),2*pi);


function[x,y,o2n]=SimulatePathC(st,f,sp,t)
x(1)=st(1);
y(1)=st(2);

for i=1:(length(f))
    td=(t(i+1)-t(i));
    [dx,dy]=pol2cart(f(i)+4.9393,sp(i)*td);
    x(i+1)=x(i)+dx;
    y(i+1)=y(i)+dy;
end
% i=length(t);
% o2n(i)=cart2pol(x(i),y(i));



function SimulateLoopPhase

% [psicw,psiaw,f2ncw,f2naw,cocw,coaw,tcw,taw,rcocw,rcoaw,spcw,spaw,rfcw,rfaw]=LoopPsi;
% save looppsitemp;

% *****THESE FILES NEED REPROCESSING ****
% load ../2' east all'/temp2ELoopPhaseDataAll.mat

load 2e2wPhaseDataAll
% PhDat=ezPhDat;
figure(7)
% [df,dc,dr,dfr,dcr,drr,dftp,dctp,drtp]=getparams(ePhDat.dat1,ePhDat.m1,1,[55:57],'k',1);
%  title('2E CW loops')
% figure(107)
[df,dc,dr,dfr,dcr,drr,dftp,dctp,drtp]=...
    getparams([ePhDat.dat1 ePhDat.dat2],[ePhDat.m1;ePhDat.m2],1,155:157,1,'k',1);
% [df,dc,dr,dfr,dcr,drr,dftp,dctp,drtp]=getparams(ePhDat.dat2,ePhDat.m2,1,155:157,1,'b',1);
figure(8)
% [dfa,dca,dra,dfra,dcra,drra,dftpa,dctpa,drtpa]=...
%     getparams(ePhDat.dat3,ePhDat.m3,1,[60:62],1,'b',0);
% figure(108)
[dfa,dca,dra,dfra,dcra,drra,dftpa,dctpa,drtpa]=...
    getparams([ePhDat.dat3 ePhDat.dat4],[ePhDat.m3;ePhDat.m4],1,160:162,1,'k',0);
% [dfa,dca,dra,dfra,dcra,drra,dftpa,dctpa,drtpa]=...
%     getparams([ePhDat.dat4],[ePhDat.m4],1,160:162,1,'b',0);

st=[drtp;drtpa];

% % 
% title('2E CCW loops')
% % % % 
keyboard
 
% ePhDat=PhDat;
% load ../2' east all'/temp2EZZPhaseDataAll.mat;
figure(9)
% [zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=...
%     getparams(ezPhDat.dat1,ezPhDat.m1,0,[55:57],'r:',1);
% figure(109)
[zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=...
    getparams([ezPhDat.dat1 ezPhDat.dat2],[ezPhDat.m1;ezPhDat.m2],0,155:157,0,'r:',1);
% [zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=...
%     getparams([ezPhDat.dat2],[ezPhDat.m2],0,155:157,0,'r:',1);
title('2E CW ZZ')
% figure(9)
% [zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=...
% getparams([PhDat.dat1 PhDat.dat2],[PhDat.m1;PhDat.m2],0,[35:37],0,'r:',1);
figure(10)
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
%     getparams(ezPhDat.dat3,ezPhDat.m3,0,[60:62],0,'r:',0);
% figure(110)
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
    getparams([ezPhDat.dat3 ezPhDat.dat4],[ezPhDat.m3;ezPhDat.m4],0,160:162,0,'r:',0);
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
%     getparams([ezPhDat.dat4],[ezPhDat.m4],0,160:162,0,'r:',0);
title('2E CCW ZZ')

figure(6),
t=df.t;
plot([df.a]*180/pi,t,'k',[dfa.a]*180/pi,t,'k',[zf.a]*180/pi,t,'k:',[zfa.a]*180/pi,t,'k:');
figure(16),
t=df.t;
plot([df.a]*180/pi,t,'k',[dfa.a]*180/pi,t,'k',[zf.a]*180/pi,t,'k:',[zfa.a]*180/pi,t,'k:');

% ezPhDat=PhDat;

% load ../2' west'/temp2WLoopPhaseDataAll.mat
% wPhDat=PhDat;
figure(11)
[df,dc,dr,dfr,dcr,drr,dftp,dctp,drtp]=getparams(wPhDat.dat1,wPhDat.m1,1,[35:5:45],1,'b',1);
figure(111)
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
% getparams([wPhDat.dat1 wPhDat.dat2],[wPhDat.m1;wPhDat.m2],1,135:5:145,1,'b',1);
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=getparams(wPhDat.dat2,wPhDat.m2,1,135:5:145,1,'b',1);
% title('2W CW loops')
figure(12)
[dfa,dca,dra,dfra,dcra,drra,dftpa,dctpa,drtpa]=getparams(wPhDat.dat3,wPhDat.m3,1,[20:23],1,'b',0);
figure(112)
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
%     getparams([wPhDat.dat3 wPhDat.dat4],[wPhDat.m3;wPhDat.m4],1,120:123,1,'b',0);
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=...
    getparams([wPhDat.dat4],[wPhDat.m4],1,120:123,1,'b',0);
% load ../2' west'/temp2WZZPhaseDataAll;
% wzPhDat=PhDat;
% title('2W CCW loops')
figure(13)
[zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=getparams(wzPhDat.dat1,wzPhDat.m1,0,[35:5:45],0,'r:',1);
title('2W CW ZZ')
figure(113)
% [zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=...
% getparams([wzPhDat.dat1 wzPhDat.dat2],[wzPhDat.m1;wzPhDat.m2],0,135:5:145,0,'r:',1);
[zf,zc,zr,zfr,zcr,zrr,zftp,zctp,zrtp]=getparams(wzPhDat.dat2,wzPhDat.m2,0,135:5:145,0,'r:');
figure(14)
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=getparams(wzPhDat.dat3,wzPhDat.m3,0,[20:23],0,'r:');
title('2W CCW ZZ')
figure(114)
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=getparams([wzPhDat.dat3 wzPhDat.dat4],[wzPhDat.m3;wzPhDat.m4],0,120:123,0,'r:');
[zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zrtpa]=getparams(wzPhDat.dat4,wzPhDat.m4,0,120:123,0,'r:');
figure(15),
t=df.t;
plot([df.a]*180/pi,t,'k',[dfa.a]*180/pi,t,'k',[zf.a]*180/pi,t,'k:',[zfa.a]*180/pi,t,'k:');
figure(16),
t=df.t;hold on;
plot([df.a]*180/pi,t,'r',[dfa.a]*180/pi,t,'r',[zf.a]*180/pi,t,'r:',[zfa.a]*180/pi,t,'r:');
hold on

% plot body orientations and flight directions for loops and zzs
% figure(1),
% save 2E2WPhDats wPhDat ePhDat ezPhDat wzPhDat
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,loostat]=...
%     getparams([wPhDat.dat1 wPhDat.dat2 wPhDat.dat3 wPhDat.dat4 ...
%     ePhDat.dat1 ePhDat.dat2 ePhDat.dat3 ePhDat.dat4],...
%     [wPhDat.m1;wPhDat.m2;wPhDat.m3;wPhDat.m4; ...
%     ePhDat.m1;ePhDat.m2;ePhDat.m3;ePhDat.m4],1,[20:23],'k');
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zzstat]=...
%     getparams([wzPhDat.dat1 wzPhDat.dat2 wzPhDat.dat3 wzPhDat.dat4 ...
%     ezPhDat.dat1 ezPhDat.dat2 ezPhDat.dat3 ezPhDat.dat4],...
%     [wzPhDat.m1;wzPhDat.m2;wzPhDat.m3;wzPhDat.m4; ...
%     ezPhDat.m1;ezPhDat.m2;ezPhDat.m3;ezPhDat.m4],0,[20:23],'k:');
% 
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,loostatco]=...
%     getparams([wPhDat.dat1 wPhDat.dat3 ePhDat.dat1 ePhDat.dat3 ],...
%     [wPhDat.m1;wPhDat.m3;ePhDat.m1;ePhDat.m3],1,[20:23],'k');
% [zfa,zca,zra,zfra,zcra,zrra,zftpa,zctpa,zzstatco]=...
%     getparams([wzPhDat.dat1 wzPhDat.dat3 ezPhDat.dat1 ezPhDat.dat3 ],...
%     [wzPhDat.m1;wzPhDat.m3;ezPhDat.m1;ezPhDat.m3],0,[20:23],'k:');
% 
% 
% % save temp2e2w_LoopsAndZZs_bodyandflightdirections loo zz
% save temp2e2w_LoopsAndZZs_f2nRelTstats loostat zzstat loostatco zzstatco


return;
figure(1)
plot([df.a]*180/pi,[df.t],'b',[zf.a]*180/pi,[zf.t],'r:')%,...
   % [dfa.a]*180/pi,[dfa.t],'b',[zfa.a]*180/pi,[zfa.t],'r:')
axis tight;
figure(2)
plot([dfr.a]*180/pi,[dfr.t],'b',[zfr.a]*180/pi,[zfr.t],'r:',...
    [dfra.a]*180/pi,[dfra.t],'b',[zfra.a]*180/pi,[zfra.t],'r:')
% plot([dcc.a]*180/pi,[dcc.t],[zcc.a]*180/pi,[zcc.t],'r:')
axis tight;
figure(3)
plot([dftp.a]*180/pi,[dftp.t],'b',[zftp.a]*180/pi,[zftp.t],'r:',...%)
    [dftpa.a]*180/pi,[dftpa.t],'b',[zftpa.a]*180/pi,[zftpa.t],'r:')
% plot([drc.a]*180/pi,[drc.t],[zrc.a]*180/pi,[zrc.t],'r:')
axis tight;

figure(4),contourf(dfr.xps,dfr.yps,max(dfr.D,dfra.D),[0:10:80]/1);
hold on;plot(dfr.a*180/pi,dfr.t,'w',dfra.a*180/pi,dfra.t,'w','LineWidth',2);hold off;axis tight;
ylim([-0.4 0.3])
figure(5),contourf(dftp.xps,dftp.yps,max(dftp.D,dftpa.D),[0:8:64]);
figure(5),contourf(dftp.xps,dftp.yps,max(dftp.D,dftpa.D),[0:15:100]);
hold on;plot(dftp.a*180/pi,dftp.t,'w',dftpa.a*180/pi,dftpa.t,'w','LineWidth',2);hold off;axis tight;
ylim([-0.9 0.5])
figure(6),contourf(zfr.xps,zfr.yps,max(zfr.D,zfra.D),[0:3:21]/2);
hold on;plot(zfr.a*180/pi,zfr.t,'w',zfra.a*180/pi,zfra.t,'w','LineWidth',2);hold off;axis tight;
ylim([-0.4 0.3])
figure(7),contourf(zftp.xps,zftp.yps,max(zftp.D,zftpa.D),[0:4:28])%,[0:4:28]);
hold on;plot(zftp.a*180/pi,zftp.t,'w',zftpa.a*180/pi,zftpa.t,'w','LineWidth',2);hold off;axis tight;
ylim([-0.9 0.5])
% subplot(2,2,4),contourf(xps,yps,Dspaw);hold on;plot(spa,xp,'w','LineWidth',2);hold off;axis tight;


divi=-720:60:720;
divi=-30:30:540;
tdiv=0:0.1:1;
% tdiv=-0.05:0.1:1.05;

return
figure(7),
rcocw=mod(rcocw,2*pi);
rcoaw=mod(rcoaw,2*pi);
% rfcw=mod(rfcw,2*pi);
% rfaw=mod(rfaw,2*pi);

% load looppsitemp
% [Dspcw,xs,ys,xps,yps]=Density2D(spcw,tcw,tdiv,tdiv);
% [Dspaw,xs,ys,xps,yps]=Density2D(spaw,taw,tdiv,tdiv);
% [dspc,xp]=StatsOverX(tcw,spcw,tdiv);
% [dspa,xp]=StatsOverX(taw,spaw,tdiv);
spc=1;%[dspc.med].^2;
spa=1;%[dspa.med].^3;
% spc=[dspc.med];
% spa=[dspa.med];

% [dum,maxind]=max(Dspcw');
% spc=xps(maxind);
% [dum,maxind]=max(Dspaw');
% spa=xps(maxind);
% 
% subplot(2,2,3),contourf(xps,yps,Dspcw);hold on;plot(spc,xp,'w','LineWidth',2);hold off;axis tight;
% subplot(2,2,4),contourf(xps,yps,Dspaw);hold on;plot(spa,xp,'w','LineWidth',2);hold off;axis tight;

spa=spa*50;spc=spc*50;

stp=[5 -5];
[xa,ya,f,o2n]=SimulatePath(stp,f2a,ones(size(f2a))*median(spa),xp);
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xas,yas,f,o2n]=SimulatePath(stp,f2a,spa,xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
figure(2)
subplot(2,2,1),plot(xc,yc,'r:',xcs,ycs),axis equal
subplot(2,2,2),plot(xa,ya,'r:',xas,yas),axis equal

stp=[15 50];
[xa,ya,f,o2n]=SimulatePath(stp,f2a,ones(size(f2a))*median(spa),xp);
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xas,yas,f,o2n]=SimulatePath(stp,f2a,spa,xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
subplot(2,2,3),plot(xc,yc,'r:',xcs,ycs),axis equal
subplot(2,2,4),plot(xa,ya,'r:',xas,yas),axis equal

save SimulateLoopParamsPh f2a f2c rcoc rcoa xp tdiv


function[ret_rates,rb4,raft]=RetRatesOfChange(cs,t,xpos,ypos,so,ib4,iaft,nor,lor,rs2n,rlmn)
sOr=so+4.9393;
ret_rates=zeros([length(t) size(xpos)]);
rb4=zeros([size(xpos)]);
raft=zeros([size(xpos)]);
for i=1:size(ret_rates,2)
    for j=1:size(ret_rates,3)
        VToP=[xpos(i,j)-cs(:,1),ypos(i,j)-cs(:,2)];
        DToP=CartDist(VToP);
        OToP=cart2pol(VToP(:,1),VToP(:,2));
        POnRet=AngularDifference(OToP,sOr);
        mg=abs(MyGradient(POnRet,t,1));
%         mg=(MyGradient(POnRet,t,1));
        ret_rates(:,i,j)=mg;
        rb4(i,j)=median(mg(ib4==1));
        raft(i,j)=median(mg(iaft==1));
    end
end

function PlotRetinalRatesSpace(nest,LM,LMWid,xp,yp,RMb4,RMaft,str,cax,noax)

RMb4=RMb4*180/pi;
RMaft=RMaft*180/pi;
if(nargin<10)
    noax=0;
end
if(nargin<9)
    mi=min([RMb4(:);RMaft(:)]);
    ma=max([RMb4(:);RMaft(:)]);
    cax=[mi ma];
end
subplot(1,2,1)
set(gca,'FontName','arial')
imagesc(xp,yp,RMb4)
axis equal;axis tight;
caxis(cax);
g=colormap('gray'); 
colormap(g(end:-1:1,:)); 
if(~noax)
    hold on; PlotNestAndLMs(LM,LMWid,nest); hold off
    title([str 'Turns towards nest'])
    colorbar
else
    axis off
end
subplot(1,2,2)
set(gca,'FontName','arial')
imagesc(xp,yp,RMaft)
axis equal;axis tight;
caxis(cax)
colormap(g(end:-1:1,:)); 
if(~noax)
    hold on; PlotNestAndLMs(LM,LMWid,nest); hold off
    title([str 'Turns away from nest'])
    colorbar
else
    axis off
end

function[dfs,dc,dr,dfr,dcr,drr,dfd,dctp,f2ncw]=getparams(dat,m,isho,fnums,isloo,cst,iscw)
dfs=[];dc=[];dr=[];dfr=[];dcr=[];drr=[];dfd=[];dctp=[];
relf=[];relc=[];relt100=[];relt60=[];tts=[];cc=[];rellm=[];tst=[];
ra_f2f2n=[];ra_s2n=[];ra_lmn=[];
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
d2n=[];
d2lm=[];
ra_int=[15 45];  
% interval in degrees of body orientation relative to nest over whiuch
% to comapare retinal rates of change of various things in towards nest 
% vs away from nest bits of loops
%
% this is the interval for towards nest/before the 0 point in CW loops
%  -ra_int is interval for 'away/after' for CW loops. 
% CCW is the opposite
%
% need to make this negative if using flight direction relative to nest
%
% see function GetRateStats

xp=-20:1:20; yp=xp;
[xpos,ypos]=meshgrid(xp);
xpos=[0,17];ypos=[0,-10];
ret_rates=[];
ib4=[];
iaft=[];
ret_b4=zeros([size(xpos) length(dat)]);
ret_aft=ret_b4;

for k=1:length(dat)
    inds=dat(k).is;
    inds=1:length(dat(k).t);
    rf=(dat(k).f2n(inds)*pi/180)';
    relf=[relf rf];
    rellm=[rellm -dat(k).f2lm(:,inds)];
    o2lm=[o2lm dat(k).o2lm(:,inds)];
    o2n=[o2n dat(k).o2n(inds)'];
%     if(isho)

% for both loops and ZZs, we want nest on retina/body rel 2 nest
% is 0 if image of nest falls on front of retina, +ve if on right,
% -ve if on left. 
%
% however because at some point in the processing, loops and zzs are
% different, bidy rel 2 nest is the wrong way round for ZZs hence this if
% statememt
%
% I HAVE CHECKED THIS AND THIS IS CORRECT AS IT IS AND MAKES LOOPS AND ZZS
% IN SAME COORDINATES
    if(isloo==1)
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
    
    % d(flight dir rel 2 nest)/dt
    raf=MyGradient(rf,t_st,1);
    rafs=[rafs raf];
    f2ncw=[f2ncw rf(1)];

    % d(Nest onretina)/dt and d(N LM on retina)/dt
    rs2n=MyGradient(nor,dat(k).t,1);
    ra_s2n=[ra_s2n rs2n];
    rlmn=MyGradient(dat(k).lmor(1,:),dat(k).t,1);
    ra_lmn=[ra_lmn rlmn];
    
    ra_f2f2n=[ra_f2f2n MyGradient(co,rf,1)];
    
    stats(k).ts = [-0.6 -0.2 0.2];
    stats(k).f2n =interp1(t/len(k),AngleWithoutFlip(rf),stats(k).ts);
    stats(k).nor =interp1(t/len(k),AngleWithoutFlip(nor),stats(k).ts);

%     ratestats(k,:)=GetRateStats(ra_int,iscw,rf,dat(k).ra_so(inds),dat(k).ra_co(inds),...
%         rlmn,rs2n,raf);

    d2n=[d2n;CartDist(cs)];
    d2lm=[d2lm;CartDist(cs(:,1)-17,cs(:,2)+10)];
    [ratestats(k,:),i1,i2,sb4(k,:)]=GetRateStats(ra_int,iscw,nor,dat(k).ra_so(inds),dat(k).ra_co(inds),...
        rlmn,rs2n,raf,d2n,d2lm);
    ib4=[ib4;i1'];
    iaft=[iaft;i2'];
    [rrm,rb4,raft]=RetRatesOfChange...
        (cs,dat(k).t,xpos,ypos,dat(k).so(inds)*pi/180,i1,i2,nor,dat(k).lmor(1,:),rs2n,rlmn);
    ret_b4(:,:,k)=rb4;
    ret_aft(:,:,k)=raft;
    ret_rates=[ret_rates; rrm];
    
    
    % this it to check what the start values are for CW vs CCW
    start_v(k,:)=[nor(1) rf(1)];
    % Both flight direction rel 2 nest and body orient rel 2 nest (=nest on
    % retina) are 0 when flight dir/body orient points at nest
    % is +ve if the direction is going to the right of the nest
    % and -ve if on the left.
    %
    % directions work the same as nest/LM on retina
    % 0 if image of nest/LM falls on front of retina, +ve if on right, -ve on left
    %
    % Flight direction relative to the nest goes 
    % go from -ve to +ve for CW  and +ve to -ve for CCW 
    %
    % Body orientation relative to the nest goes the OTHER way
    % +Ve to -ve for CW  and -ve to +ve for CCW

    %     plot(rf*180/pi,t_st/len(k)), hold on;
%     plot(rf*180/pi,d1/d1(end)), hold on;
%     subplot(2,2,1),plot(rf*180/pi,t_st/len(k)), hold on;
%     subplot(2,3,2),plot(rf*180/pi,t/len(k)), hold on;
%     subplot(2,3,3),plot(rf*180/pi,t), hold on;
%     subplot(2,3,4),plot(rf*180/pi,t/l2(k)), hold on;
%     subplot(2,3,5),plot(rf*180/pi,t/td60(k)), hold on;
%     subplot(2,3,6),plot(rf*180/pi,t/td100(k)), hold on;
    
%     plot(t/td100(k),dat(k).f2n(inds),'r:',...
%         t/td100(k),dat(k).co(inds))
end
clear f2ncw
for i=1:size(ret_b4,1)
    for j=1:size(ret_b4,2)
        a=ret_b4(i,j,:);
        RMb4(i,j)=nanmedian(a);
        a=ret_aft(i,j,:);
        RMaft(i,j)=nanmedian(a);
        a=ret_rates(ib4==1,i,j);
        RMb42(i,j)=nanmedian(a);
        a=ret_rates(iaft==1,i,j);
        RMaft2(i,j)=nanmedian(a);
    end
end
LM=[17 -10;17,10];LMWid=[3 3];nest=[0 0];
if(iscw) 
    s='2E CW; ';
%     save 2ECWRetinalRatesNearNest ret_* RM* s ib4 iaft ra_int xpos ypos xp yp LM LMWid nest
else
    s='2E CCW; ';
%     save 2ECCWRetinalRatesNearNest ret_* RM* s ib4 iaft ra_int xpos ypos xp yp LM LMWid nest
end
PlotRetinalRatesSpace(nest,LM,LMWid,xp,yp,RMb4,RMaft,s)

% f2ncw=stats;
f2ncw=ratestats;
lmor=[dat.lmor];
% 
% f2ncw.co=cc;
% f2ncw.so=so;
% f2ncw.s2n=s2n;
% f2ncw.f2n=relf;
% [y1,x]=AngHist(f2ncw.co*180/pi,[],[],0);
% [y2,x]=AngHist(f2ncw.so*180/pi,[],[],0);
% [y3,x]=AngHist(f2ncw.f2n*180/pi,[],[],0);
% [y4,x]=AngHist(f2ncw.s2n*180/pi,[],[],0);
% f2ncw.y1=y1;
% f2ncw.y2=y2;
% f2ncw.y3=y3;
% f2ncw.y4=y4;
% 
% for i=1:4
%     subplot(2,2,i)
%     eval(['y=y' int2str(i) '/sum(y' int2str(i) ');']);
%     plot(x,y,cst);
%     if(isho)
%         hold on;
%     else
%         hold off
%         axis tight
%     end
% end

nppppp=[length(dat) length(relf)]
% figure(50);
spee=[dat.spee];
ra_co=[dat.ra_co];
ra_so=[dat.ra_so];

div=[-1:.1:1.05]-.05;
% divr=[-.7:0.05:.7]+.025;
divr=[-.7:0.1:.7]+.05;
% divs=[0:0.05:1.05]-.025;
divs=[0:0.1:1.1]-.05;
divtp=[-1:.1:1.05]-.05;


% stuff to get the rate of change of flight direction relative to the nest
[D,xs,ys,xps,yps]=Density2D(abs(rafs)*180/pi,tst,-50:100:1050,divs);
[da,xpt]=StatsOverX(tst,abs(rafs)*180/pi,divs);
dfs.D=D;
dfs.xps=xps;
dfs.yps=yps;
dfs.xpt=xpt;
dfs.me=[da.me];
dfs.med=[da.med];
dfs.n=[da.n];
% return


x=relf;
df=getsdat(tts,x,div);
dfr=getsdat(relt,x,divr);
dfs=getsdat(tst,x,divs);
% dftp=getsdat(relt2,x,divtp);
dfd=getsdat(reld,x,divs);
% [da60,xp60]=StatsOverX(relt60,x,[0:0.1:2]);
% [da100,xp100]=StatsOverX(relt100,x,[0:0.05:1]);

x=cc;
dc=getsdat(tts,x,div);
dcr=getsdat(relt,x,divr);
% dcs=getsdat(tst,x,divs);
dctp=getsdat(relt2,x,divtp);
% [da60,xp60]=StatsOverX(relt60,x,[0:0.1:2]);
% [da100,xp100]=StatsOverX(relt100,x,[0:0.05:1]);

x=relc;
dr=getsdat(tts,x,div);
drr=getsdat(relt,x,divr);
% drs=getsdat(tst,x,divs);
% drtp=getsdat(relt2,x,divtp);

[D,xs,ys,xps,yps]=Density2D(abs(rafs)*180/pi,tst,0:20:100,divs);

%     df.D=D;
%     df.xps=xps;
%     df.yps=yps;
% 
% x=rellm(1,:);
% dl1=getsdat(tts,x,div);
% dl1r=getsdat(relt,x,divr);
% dl1s=getsdat(tst,x,divs);
% dl1tp=getsdat(relt2,x,divtp);
% 
% x=rellm(2,:);
% dl2=getsdat(tts,x,div);
% dl2r=getsdat(relt,x,divr);
% dl2s=getsdat(tst,x,divs);
% dl2tp=getsdat(relt2,x,divtp);

% figure(5)
x=dfs.xps;
y=dfs.yps;
t=dfs.t;

% plot([dfs.a]*180/pi,t,'k',[dfs.med]*180/pi,t,'k:');
% title(['num zz/loop ' int2str(length(dat)) '; num pts ' int2str(length(relf))])
% subplot(2,2,3),contourf(x,y,dfs.D),title('f rel 2 nest')
% hold on,plot([dfs.a]*180/pi,t,'w')%,[dfs.med]*180/pi,t,'k:');
% subplot(2,2,2),plot([dfs.a]*180/pi,t,'k',[dfs.med]*180/pi,t,'k:',...
%     [dfd.a]*180/pi,t,'r',[dfd.med]*180/pi,t,'r:');
% subplot(2,2,4),contourf(x,y,dfd.D),title('f rel nest Distance')
% hold on,plot([dfd.a]*180/pi,t,'w')%,[dfs.med]*180/pi,t,'k:');
% for i=1:4 
%     subplot(2,2,i),
%     axis tight, 
%     hold off; 
% end
% subplot(2,2,1)
% % plot(dfr.a*180/pi,t,'k',[dfr.med]*180/pi,t,'k:');
% plot(dfs.sc,t,'k',dfd.sc,t,'r:')
% subplot(2,2,2)

ppsi=AngularDifference(cc,so);
[D,xs,ys,xps,yps]=Density2DAng(relf*180/pi,ppsi*180/pi,-190:20:190,-185:10:185);
contourf(xps,yps,D)
% subplot(2,3,1),contourf(x,y,dfs.D),title('f rel 2 nest')
% subplot(3,2,2),contourf(x,y,dcs.D),title('f dir')
% subplot(3,2,3),contourf(x,y,drs.D),title('f dir rel 2 start')
% subplot(3,2,4),contourf(x,y,dl1s.D),title('f rel 2 N LM')
% % subplot(3,2,5),contourf(x,y,dl2s.D),title('f rel 2 S LM')
% subplot(3,2,5),contourf(x,y,dfd.D),title('f rel nest Distance')
% subplot(3,2,6),
% plot(t,dfs.sc,t,dcs.sc,'r--',t,drs.sc,'k:', ...
%     t,dl1s.sc,'r:*',t,dfd.sc,'g:s');%,t,dl2s.sc,'g:s');
% axis tight;yl=ylim;ylim([0 yl(2)])
% plot([df.a]*180/pi,[df.t],[dc.a]*180/pi,[dc.t],'r:',[dr.a]*180/pi,[dr.t],'k--')

% KLDivScript(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,fnums,relc);
% plotbits(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,fnums)

% this one is current!!
% plotbits(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_f2f2n,isho,cst,fnums)
% plotbits(relf,so,lmor,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_f2f2n,isho,cst,fnums)

% this one is the one for doing rates for headmovement paper
plotbitsRates(s2n,spee,abs(ra_co),abs(ra_so),abs(rafs),abs(ra_s2n),...
    abs(ra_lmn),abs(ra_f2f2n),isho,cst,fnums,d2n,d2lm)

% this one is old
% plotbits(rellm(2,:),so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,fnums)

function KLDivScript(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,...
    ra_co,ra_so,isho,cst,fnums,relc)
keyboard;
sstr='2wcw';
% estr='_ZZs';
estr='_Loops';
plotbits(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_relf' estr])
plotbits(cc,so,rellm,relf,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_fdir' estr])
plotbits(so,relf,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_Body' estr])
plotbits(ppsi,so,rellm,cc,relf,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_psi' estr])
plotbits(o2n,so,rellm,cc,ppsi,o2lm,relf,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_o2n' estr])
plotbits(relc,so,rellm,relf,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_relc' estr])
plotbits(rellm(1,:),so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_rellm1' estr])
plotbits(rellm(2,:),so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,[sstr '_da_rellm2' estr])


function plotbits(relf,so,rellm,cc,ppsi,o2lm,o2n,s2n,spee,ra_co,ra_so,isho,cst,fs)

% subst='subplot(4,3,i)';
% vs=1:12;
% subst='subplot(1,3,i)';
% vs=[1 7:8];
% subst='MotifFigs(gcf,1)';
subst='figure(fs(i));MotifFigs(gcf,1)';
vs=[12];
hists=0;
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
% np=n7*180/pi;
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
    

function plotbitsRates(relf,spee,ra_co,ra_so,rafs,ra_s2n,ra_lmn,raf2f2n,...
    isho,cst,fs,d2n,d2lm)

% this plots all the rates of change plus distance to LM and nest as sanity
% check
% subst='subplot(3,2,i)';
% vs=[3 5 6 8 9];
% vs=1:12;

% this plots just the rates of change as per head movement figure
subst='subplot(3,1,i)';
vs=[3 5 6];
% vs=[1 7:8];
% subst='MotifFigs(gcf,1)';
% subst='figure(fs(i));MotifFigs(gcf,1)';
hists=0;
if(fs(1)>40)
    g=13;
else
    g=7;
end
g=[7 13];
[da1,n]=StatsOverX(relf,spee,[-190:20:190]*pi/180);
[da2,n]=StatsOverX(relf,(ra_co)*180/pi,[-190:20:190]*pi/180);
[da3,n]=StatsOverX(relf,(ra_so)*180/pi,[-190:20:190]*pi/180);
[da4,n]=StatsOverX(relf,rafs*180/pi,[-190:20:190]*pi/180);
[da5,n]=StatsOverX(relf,ra_s2n*180/pi,[-190:20:190]*pi/180);
[da6,n]=StatsOverX(relf,ra_lmn(1,:)*180/pi,[-190:20:190]*pi/180);
[da7,n]=StatsOverX(relf,raf2f2n*180/pi,[-190:20:190]*pi/180);
[da8,n]=StatsOverX(relf,d2n,[-190:20:190]*pi/180);
[da9,n]=StatsOverX(relf,d2lm,[-190:20:190]*pi/180);
np=n*180/pi;
% np=n7*180/pi;
% figure(fs(1))
% plot(np,[da1.meang]*180/pi,np,[da2.meang]*180/pi,'r:',np,[da3.meang]*180/pi,'k:',np,-[da4.meang]*180/pi,'b:x')
% grid on,axis tight
if(ischar(fs(1)))
    save(fs);
    return;
end
tst={'speed';'df/dt';'dbody/dt';'df2n/dt';'d NestOnRet/dt';'d NLMOnRet/dt';...
    'dflight/df2nest';'d2nest';'d2NLM'};
figure(fs(1))
set(gcf,'Position',[379   110   232   553]);
for i=1:length(vs)
    eval(subst);
    set(gca,'FontName','Arial');
    eval(['dp=da' int2str(vs(i))]);
    % plot data and sd's
    plot(np,[dp.med],cst,np,[dp.p25],[cst ':'],np,[dp.p75],[cst ':'],'LineWidth',1)
%     plot(np,[dp.me],cst,np,[dp.me]-[dp.sd],[cst ':'],np,[dp.me]+[dp.sd],[cst ':'])

%         % plot data and sd's with sd's above the line
%         ma=140;
%         plot(np,[dp.meang]*180/pi,cst,np,ma+[dp.angsd]*180/pi,cst, ...
%             np([1 end]), [ma ma],'k')

        % plot n's as a percentage. Need to scale them all
        % slot is 90degs = 20% so 1%=90/20=4.5 Take off 190 to put at bottom
%         ma=-100;
%         pc=100*[dp.n]./sum([dp.n]);
%         plot(np,pc*4.5-190,cst,np([1 end]), [ma ma],'k')
    grid on;
    axis tight;
    if(isho) 
        hold on;
    else
        hold off;
    end
    ylabel(char(tst(vs(i),:)))
%      title(char(tst(vs(i),:)))

    if(ismember(vs(i),[3 5 6])) 
          ylim([0 425])
    else
        ylow(0)
    end
    xlim([-90 90])
%     xlabel('f rel 2 nest')
end
if hists
    figure(fs(2))
    for i=1:length(vs)
        eval(subst);
        eval(['dp=da' int2str(vs(i))]);
        [y,x]=hist(dp(10).x,20);
%         [y,x]=hist(dp(10).x,0:.1:2);
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
        [y,x]=hist(dp(g(1)).x,20);
%         [y,x]=hist(dp(g(1)).x,0:.1:2);
        [y1,x]=hist(dp(g(2)).x,x);
        %     plot(x,y/sum(y),cst)%,x,y1/sum(y1),cst)
        plot(x,y/sum(y),cst,x,y1/sum(y1),[cst ':'])
        axis tight;
        Setbox;
        if(isho)
            hold on;
        else
            hold off;
        end
        ylabel(char(tst(vs(i),:)))
        title('f2n=[-70:-50]; f2n=[50:70] (dots)')  
    end
end


function[df]=getsdat(tts,x,p);
thd=10;
t3=[-180:thd:180+thd]-thd/2;
thd=20;
t2=[-180:thd:180+thd]-thd/2;
if(nargin<3)
    [da,xpt]=StatsOverX(tts,x);
else
    [da,xpt]=StatsOverX(tts,x,p);
    [D,xs,ys,xps,yps]=Density2DAng(x*180/pi,tts,t2,p);
    df.D=D;
    df.xps=xps;
    df.yps=yps;
end
df.a=[da.meang];
df.r=[da.meangL];
df.med=[da.medang];
df.n=[da.n];
df.t=xpt;
df.sc=[da.angsd]*180/pi;



% this function gets the retinal rates of change of various  parameters etc
% for portions of manevoures towards/away from the nest
% 
% these portions ar calculated rorm flgiht direction or body orient rel 2
% nest
%
% interval in degrees of body orientation relative to nest over whiuch
% to comapare retinal rates of change of various things in towards nest 
% vs away from nest bits of loops
%
% this is the interval for towards nest/before the 0 point in CW loops
%  -ra_int is interval for 'away/after' for CW loops. 
% CCW is the opposite
%
% need to make this negative if using flight direction relative to nest

function[d,i1,i2,s1]=GetRateStats(raint,cw,rf,ra_so,ra_co,rlmn,rs2n,raf,d2n,d2lm)

l=raint*pi/180;
x=1:length(rf);
r=rf*180/pi;
if(cw)
    i1=(rf>=l(1))&(rf<=l(2));
    i2=(rf>=-l(2))&(rf<=-l(1));
%     plot(x,r,'k',x(i1),r(i1),'bs',x(i2),r(i2),'rx')
else
    i2=(rf>=l(1))&(rf<=l(2));
    i1=(rf>=-l(2))&(rf<=-l(1));
%     plot(x,r,'g',x(i1),r(i1),'bs',x(i2),r(i2),'rx')
end
dat=abs([ra_so;rs2n;rlmn])';%;ra_co;raf])';
s1=median(dat(i1,:),1);
s2=median(dat(i2,:),1);
d=[s1-s2 s1(:,2)-s1(:,3) s2(:,2)-s2(:,3)];
if(length(d)>=3)
    title(num2str(d(1:3)))
end
s1=mean(dat(i1,:),1);
s2=mean(dat(i2,:),1);
d=[d s1-s2 s1(:,2)-s1(:,3) s2(:,2)-s2(:,3)];


function SimulateLoop
load loopstatstemp

% [psicw,psiaw,f2ncw,f2naw,cocw,coaw,tcw,taw,rcocw,rcoaw,spcw,spaw,rfcw,rfaw]=LoopPsi;
% save looppsitemp;
load looppsitemp;
divi=-720:60:720;
divi=-30:30:540;
tdiv=0:0.1:1;
% tdiv=-0.05:0.1:1.05;
thd=20;
figure(1)
[Df2ncw,xs,ys,xps,yps]=Density2D(f2ncw*180/pi,tcw,[-180:thd:190]-thd/2,tdiv);
[Df2naw,xs,ys,xps,yps]=Density2D(f2naw*180/pi,taw,[-180:thd:190]-thd/2,tdiv);
[datc,xp]=StatsOverX(tcw,f2ncw,tdiv);
[data,xp]=StatsOverX(taw,f2naw,tdiv);
f2c=[datc.meang];
f2a=[data.meang];
subplot(2,2,1),contourf(xps,yps,Df2ncw);hold on;plot(f2c*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,2),contourf(xps,yps,Df2naw);hold on;plot(f2a*180/pi,xp,'w','LineWidth',2);hold off;axis tight;

figure(7),
rcocw=mod(rcocw,2*pi);
rcoaw=mod(rcoaw,2*pi);
[Df2ncw,xs,ys,xps,yps]=Density2D(rcocw*180/pi,tcw,[0:thd:370]-thd/2,tdiv);
[Df2naw,xs,ys,xps,yps]=Density2D(rcoaw*180/pi,taw,[0:thd:370]-thd/2,tdiv);
[datc,xp]=StatsOverX(tcw,rcocw,tdiv);
[data,xp]=StatsOverX(taw,rcoaw,tdiv);
rcoc=mod([datc.meang],2*pi);rcoc(1)=0;
rcoa=mod([data.meang],2*pi);rcoa(1)=0;
subplot(2,2,1),contourf(xps,yps(2:end),Df2ncw(2:end,:));hold on;plot(rcoc*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,2),contourf(xps,yps(2:end),Df2naw(2:end,:));hold on;plot(rcoa*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
rfcw=mod(rfcw,2*pi);
rfaw=mod(rfaw,2*pi);
[Df2ncw,xs,ys,xps,yps]=Density2D(rfcw*180/pi,tcw,[0:thd:370]-thd/2,tdiv);
[Df2naw,xs,ys,xps,yps]=Density2D(rfaw*180/pi,taw,[0:thd:370]-thd/2,tdiv);
[datc,xp]=StatsOverX(tcw,rfcw,tdiv);
[data,xp]=StatsOverX(taw,rfaw,tdiv);
rcoc=mod([datc.meang],2*pi);rcoc(1)=0;
rcoa=mod([data.meang],2*pi);rcoa(1)=0;
subplot(2,2,3),contourf(xps,yps(2:end),Df2ncw(2:end,:));hold on;plot(rcoc*180/pi,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,4),contourf(xps,yps(2:end),Df2naw(2:end,:));hold on;plot(rcoa*180/pi,xp,'w','LineWidth',2);hold off;axis tight;


[Dspcw,xs,ys,xps,yps]=Density2D(spcw,tcw,tdiv,tdiv);
[Dspaw,xs,ys,xps,yps]=Density2D(spaw,taw,tdiv,tdiv);
[dspc,xp]=StatsOverX(tcw,spcw,tdiv);
[dspa,xp]=StatsOverX(taw,spaw,tdiv);
spc=[dspc.med].^2;
spa=[dspa.med].^3;
spc=[dspc.med];
spa=[dspa.med];

[dum,maxind]=max(Dspcw');
spc=xps(maxind);
[dum,maxind]=max(Dspaw');
spa=xps(maxind);

subplot(2,2,3),contourf(xps,yps,Dspcw);hold on;plot(spc,xp,'w','LineWidth',2);hold off;axis tight;
subplot(2,2,4),contourf(xps,yps,Dspaw);hold on;plot(spa,xp,'w','LineWidth',2);hold off;axis tight;

spa=spa*50;spc=spc*50;

stp=[5 -5];
[xa,ya,f,o2n]=SimulatePath(stp,f2a,ones(size(f2a))*median(spa),xp);
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xas,yas,f,o2n]=SimulatePath(stp,f2a,spa,xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
figure(2)
subplot(2,2,1),plot(xc,yc,'r:',xcs,ycs),axis equal
subplot(2,2,2),plot(xa,ya,'r:',xas,yas),axis equal

stp=[15 50];
[xa,ya,f,o2n]=SimulatePath(stp,f2a,ones(size(f2a))*median(spa),xp);
[xc,yc,f,o2n]=SimulatePath(stp,f2c,ones(size(f2c))*median(spc),xp);
[xas,yas,f,o2n]=SimulatePath(stp,f2a,spa,xp);
[xcs,ycs,f,o2n]=SimulatePath(stp,f2c,spc,xp);
subplot(2,2,3),plot(xc,yc,'r:',xcs,ycs),axis equal
subplot(2,2,4),plot(xa,ya,'r:',xas,yas),axis equal

save SimulateLoopParams f2a f2c rcoc rcoa xp tdiv

function[psicw,psiaw,f2ncw,f2naw,cocw,coaw,tcw,taw,rcocw,rcoaw,spcw,spaw, ...
    rspcw,rspaw]=ZZPsi;
load processzigzagsin
zz=fltsec;
psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];
tcw=[];taw=[];spcw=[];spaw=[];rspcw=[];rspaw=[];rcocw=[];rcoaw=[];
for i=1:length(zz)
    o2n=zz(i).o2n;
    t=zz(i).t;
    cs=zz(i).cs;
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);

    for j=1:length(zz(i).fsec)
        is=zz(i).fsec(j).is;
        if(length(is)>=4)
            ts=t(is);
            co=AngularDifference(zz(i).fsec(j).co,0);
            so=AngularDifference(zz(i).fsec(j).so',0);
%             cs=zz(i).fsec(j).cs;
            ppsi=AngularDifference(zz(i).fsec(j).co,[zz(i).fsec(j).so]');
            f2n=AngularDifference(zz(i).fsec(j).co,o2n(is));
            relt=zz(i).fsec(j).reltDang2;
            %             relt=zz(i).fsec(j).reltDco;
            sps=find(relt==0);
            eps=find(relt==1);
            if(eps(1)<=sps(1)) eps=eps(2:end); end;
            if(eps(end)<=sps(end)) sps=sps(1:end-1); end;
            for k=1:length(sps)
                izz=sps(k):eps(k);
                [h,ad1 ad2] = LoopHandednes(co(izz));
                if(ad2(1)<0)
                    h=-1;
                    cstr='anti-clock';
                else
                    h=1;
                    cstr='clock';
                end
                relsp=spee(is(izz));

                if(h==1)
                    tcw=[tcw;relt(izz)'];
                    cocw=[cocw;co(izz)];
                    spcw=[spcw;relsp'];
                    rspcw=[rspcw;relsp'/prctile(relsp,90)];
                    rcocw=[rcocw;AngularDifference(co(izz),co(izz(1)))];
                    psicw=[psicw;ppsi(izz)];
                    f2ncw=[f2ncw;f2n(izz)];
                else
                    taw=[taw;relt(izz)'];
                    rcoaw=[rcoaw;AngularDifference(co(izz),co(izz(1)))];
                    spaw=[spaw;relsp'];
                    rspaw=[rspaw;relsp'/prctile(relsp,90)];
                    coaw=[coaw;co(izz)];
                    psiaw=[psiaw;ppsi(izz)];
                    f2naw=[f2naw;f2n(izz)];
                end
            end
        end
    end
end




function[psicw,psiaw,f2ncw,f2naw,cocw,coaw,tcw,taw,rcocw,rcoaw,...
    spcw,spaw,rfcw,rfaw]=LoopPsi

load loopstatstemp
psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];
tcw=[];taw=[];spcw=[];spaw=[];rcocw=[];rcoaw=[];rfcw=[];rfaw=[];
for i=1:length(loops)
    ps=find([loops(i).Picked]);
%     co=loops(i).Co;
    co=[loops(i).so]';
    cs=loops(i).cs;
    ppsi=loops(i).fdir;
    f2n=loops(i).f2n;
    t=loops(i).t;
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);

    for j=1:length(ps)
        is=loops(i).loop(ps(j)).is;
        [h,ad1 ad2] = LoopHandednes(co(is));
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        relsp=spee(is)/prctile(spee(is),90);
        sp=is(1);ep=is(end);

        if(h==1)
            tcw=[tcw;relt'];
            cocw=[cocw;co(is)];
            spcw=[spcw;relsp'];
            rcocw=[rcocw;AngularDifference(co(is),co(is(1)))];
            rfcw=[rfcw;AngularDifference(f2n(is),f2n(is(1)))];
            psicw=[psicw;ppsi(is)];
            f2ncw=[f2ncw;f2n(is)];
        else
            taw=[taw;relt'];
            rcoaw=[rcoaw;AngularDifference(co(is),co(is(1)))];
            rfaw=[rfaw;AngularDifference(f2n(is),f2n(is(1)))];
            spaw=[spaw;relsp'];
            coaw=[coaw;co(is)];
            psiaw=[psiaw;ppsi(is)];
            f2naw=[f2naw;f2n(is)];
        end
        te=[te;h,ad1];
    end
end

function MotifFigs(h,ty)

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

function[hand,angdiff,mad] = LoopHandednes(co)

smlen=2;
len=length(co);
en=min(1+smlen,len);
st=max(1,len-smlen);
angin=MeanAngle(co(1:en));
angout=MeanAngle(co(st:end));
angdiff=AngularDifference(angout+pi,angin);
if(angdiff<0) hand=-1;
else hand=1;
end
angdiff=round(angdiff*180/pi);
ad=medfilt1(gradient(AngleWithoutFlip(co)));
mad=round([median(ad) mode(ad)]*180/pi);

