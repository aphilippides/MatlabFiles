function doubleloopstats(fltsec)
% load 2east_doubleloopsData
% [l1all,l2all]=Get1Data(fltsec);
load doubleloopstatstemp;
HandedDifferences(l1s,l2s,0.2)

l1all=l1s;l2all=l2s;
cd ../2' west'/
% load 2westdoubleloopsData;
% [l1s,l2s]=Get1Data(fltsec);
load doubleloopstatstemp;
l1all=[l1all;l1s];l2all=[l2all;l2s];
cd ../'north 8'/
% load north8_doubleloopsData;
% [l1s,l2s]=Get1Data(fltsec);
load doubleloopstatstemp;
l1all=[l1all;l1s];l2all=[l2all;l2s];
cd ../Ci'rcling files'/
Rateplots(l1all,l2all);
% allplots(l1all,l2all);

function HandedDifferences(l1s,l2s,td)

sm=3;
da=AngularDifference([l2s.angout],[l1s.angin]);
cw2aw=find(([l1s.hand]==1)&([l2s.hand]==-1));
aw2cw=find(([l1s.hand]==-1)&([l2s.hand]==1));
cw2cw=find(([l1s.hand]==1)&([l2s.hand]==1));
aw2aw=find(([l1s.hand]==-1)&([l2s.hand]==-1));

for i=1:length(l1s)
    ang1=circ_median(l1s(i).co(1:sm));
    ang2=circ_median(l2s(i).co(end-sm+1:end));
    dmed(i)=AngularDifference(ang2,ang1);
    ang1=MeanAngle(l1s(i).co(1:sm));
    ang2=MeanAngle(l2s(i).co(end-sm+1:end));
    dmea(i)=AngularDifference(ang2,ang1);
    dt(i)=l2s(i).t(1)-l1s(i).t(end);
end
if(td>0)
    cw2aw=cw2aw(dt(cw2aw)<=td);
    aw2cw=aw2cw(dt(aw2cw)<=td);
end
[y,x]=AngHist(da(cw2aw)*180/pi);y1=y/sum(y);
[y,x]=AngHist(da(aw2cw)*180/pi);y2=y/sum(y);
[y,x]=AngHist(dmea(cw2aw)*180/pi);ym1=y/sum(y);
[y,x]=AngHist(dmea(aw2cw)*180/pi);ym2=y/sum(y);
[y,x]=AngHist(dmed(cw2aw)*180/pi);yd1=y/sum(y);
[y,x]=AngHist(dmed(aw2cw)*180/pi);yd2=y/sum(y);
subplot(3,1,1),plot(x,y1,x,y2,'r:'),,axis tight,xlabel('raw angles')
title(['loops less than ' num2str(td) 'apart. cw to ccw = ' int2str(length(cw2aw)) ...
    '; ccw to cw = ' int2str(length(aw2cw)) '; total = ' int2str(length(l1s))])
subplot(3,1,2),plot(x,ym1,x,ym2,'r:'),axis tight,xlabel('mean angles')
subplot(3,1,3),plot(x,yd1,x,yd2,'r:'),axis tight,xlabel('median angles')
figure(2),plot(x,yd1,x,yd2,'r:'),axis tight,
title(['loops less than ' num2str(td) 'apart. cw to ccw = ' int2str(length(cw2aw)) ...
    '; ccw to cw = ' int2str(length(aw2cw)) '; total = ' int2str(length(l1s))])

function Rateplots(l1s,l2s)

ra_s=[];ra_sm=[];
ra_c=[];ra_cm=[];
ra_f=[];ra_fm=[];
meanrates=[];
for i=1:length(l1s)
    ra_s=[ra_s l1s(i).rates];
    ra_c=[ra_c l1s(i).ratec];
    ra_f=[ra_f l1s(i).ratef];
    meanrates=[meanrates; ...
        mean(abs(l1s(i).rates)) mean(abs(l1s(i).ratec)) mean(abs(l1s(i).ratef)) ...
        median(abs(l1s(i).rates)) median(abs(l1s(i).ratec)) median(abs(l1s(i).ratef))];

    ra_s=[ra_s l2s(i).rates];
    ra_c=[ra_c l2s(i).ratec];
    ra_f=[ra_f l2s(i).ratef];
    meanrates=[meanrates; ...
        mean(abs(l2s(i).rates)) mean(abs(l2s(i).ratec)) mean(abs(l2s(i).ratef)) ...
        median(abs(l2s(i).rates)) median(abs(l2s(i).ratec)) median(abs(l2s(i).ratef))];
end
save doublelooprates

function[l1s,l2s]=Get1Data(fltsec)
% if(nargin<1)
%     % Get Data file
%     fs=dir('Loops*.mat');
%     WriteFileOnScreen(fs,1);
%     Picked=input('select output file; return for all:  ');
%     if(isempty(Picked)) Picked=1:length(fs); end;
%     fns=fs(Picked);
% else fns=1;
% end
% origdir=cd;

rs=[];rsm=[];ra_s=[];ra_sm=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];

nolook=[];nolooki=[];pcN=[];pcNind=[];pcL=[];
majax=[];a2nest=[];maxds=[];XPts=[];loopt=[];a2lm=[];looplen=[];
allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

allpsin=[];allpsi=[];
l1s=[];l2s=[];
for i=1:length(fltsec)
    %     cmpdir=4.93;%0.6;%
    %     cmpdir=fltsec(i).cmpdir;
    load(fltsec(i).fn);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fltsec(i).fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fltsec(i).fn,t,OToNest,[],[]);
    end
    if(exist('compassDir')) fltsec(i).cmpdir=compassDir;
    else fltsec(i).cmpdir=4.94;
    end
    fdir=AngularDifference(Cent_Os,sOr);
    co=Cent_Os;so=sOr;
    lm=fltsec(i).lm;
    lmo=LMOrder(lm);
    lm=lm(lmo,:);
    LMs=LMs(lmo);
    as=AngleWithoutFlip(so)*180/pi;
    ac=AngleWithoutFlip(co)*180/pi;
    af=AngleWithoutFlip(fdir)*180/pi;
    asm=TimeSmooth(as,t,0.1);
    acm=TimeSmooth(ac,t,0.1);
    afm=TimeSmooth(af,t,0.1);
    
    rs=[rs max(as)-min(as)];
    rsm=[rsm max(asm)-min(asm)];
    c_os=[c_os max(ac)-min(ac)];
    csm=[csm max(acm)-min(acm)];
    fs=[fs max(af)-min(af)];
    fsm=[fsm max(afm)-min(afm)];
    
    smm=3;
    ra_c=[MyGradient(ac,t)];
    ra_f=[MyGradient(af,t)];
    ra_s=[MyGradient(as,t)];

    %     ra_s=[ra_s MyGradient(as,t(is))];
%     ra_c=[ra_c MyGradient(ac,t(is))];
%     ra_f=[ra_f MyGradient(af,t(is))];
        %             ra_sm=[ra_sm medfilt1(MyGradient(as,t(is)),smm)];
        %             ra_cm=[ra_cm medfilt1(MyGradient(ac,t(is)),smm)];
        %             ra_fm=[ra_fm medfilt1(MyGradient(af,t(is)),smm)];
        

    for j=1:length(fltsec(i).fsec);
        cs=fltsec(i).fsec(j).cs;
        is=fltsec(i).fsec(j).is;
        t_s=t(is);
        fltsec(i).fsec(j).t=t_s;
%         figure(1)
        l1=LoopAngles(cs,is,fltsec(i).fsec(j).co,t_s,fltsec(i).cmpdir,1);
        iend=size(cs,1):-1:1;
        l2=LoopAngles(cs(iend,:),is,fltsec(i).fsec(j).co,t_s,fltsec(i).cmpdir,0);
        if(~isempty(l1)&&(~isempty(l2)))
            l1.psi=fdir(l1.is)';
        l1.ratec=ra_c(l1.is);
        l1.ratef=ra_f(l1.is);
        l1.rates=ra_s(l1.is);
        l1.rangec=max(ac(l1.is))-min(ac(l1.is));
        l1.rangef=max(af(l1.is))-min(af(l1.is));
        l1.o2n=OToNest(l1.is);
%         hold on;
        l2.psi=fdir(l2.is)';
        l2.ratec=ra_c(l2.is);
        l2.ratef=ra_f(l2.is);
        l2.rates=ra_s(l2.is);
        l2.rangec=max(ac(l2.is))-min(ac(l2.is));
        l2.rangef=max(af(l2.is))-min(af(l2.is));
        l2.o2n=OToNest(l2.is);
        
        l1s=[l1s;l1];
        l2s=[l2s;l2];
        end
%         figure(2)
%         l2ts=-l2s(end).ts+l2s(end).ts(end);
%         plot(l1s(end).ts-l1s(end).ts(1),l1s(end).co,'b',...
%             l2ts,l2s(end).co,'r-x',l2ts(end),l2s(end).angout,'rd',...
%             0,l1s(end).angin,'bd')
        % 
        
        
        %             psi=[psi fdir(is)'];
        %             abf=abs(fdir(is))*180/pi;
        %             maxpsi=[maxpsi;mean(abf) prctile(abf,[50, 75, 90, 95,99]) max(abf)];
        %             sos=[sos so(is)];
        %             cos=[cos co(is)'];
        %             allcs=[allcs; co(is)];
        %             o2n=[o2n; OToNest(is)];
        %             nors=[nors [loops(i).nor(is)]'];
        %             psinest=[psinest fdir(intersect(is,in))'];
        %             allLM(1).LM=LM;
        %             for lm=1:nLM
        %                 allLM(lm).LMOnRetina=[allLM(lm).LMOnRetina;LMs(lm).LMOnRetina(is)];
        %                 allLM(lm).OToLM=[allLM(lm).OToLM;LMs(lm).OToLM(is)];
        %                 allLM(lm).psilm=[allLM(lm).psilm fdir(intersect(is,ils(lm).is))'];
        %             end
        
        %             df=AngularDifference(co(is),majax(end));
%         df=AngularDifference(co(is));
%         relfs=[relfs df'];
        
%         figure(1);
%         PlotNestAndLMs(fltsec(i).lm,fltsec(i).lmw,[0 0],0);    hold on;
%         plot(xp(1),xp(2),'x',[xp(1) px],[xp(2) py],cs(:,1),cs(:,2),'r-x'),
%         hold off;axis equal
%         figure(2),plot(t(is),fdir(is)*180/pi,t(is(1:end-1)),df*180/pi,'r')%,t(is), ...
%         %                 AngularDifference(so(is),0)*180/pi,'g',t(is),loops(i).nor(is)*180/pi,'k')
%         axis tight; grid
%         figure(3),plot(t(is),co(is)*180/pi,t(is(1:end-1)),df*180/pi,'r-x')%,t(is), ...
%         %             figure(3),plot(fdir(is)*180/pi,df*180/pi,'b-o', ...
%         %                 fdir(is)*180/pi,loops(i).nor(is)*180/pi,'r-x')
%         %             axis tight; grid
    end
end
save doubleloopstatstemp

function allplots(l1s,l2s)

h11=[];h12=[];h21=[];h22=[];
p11=[];p12=[];p21=[];p22=[];
c11=[];c12=[];c21=[];c22=[];
relf1=[];relf2=[];relf3=[];
relf4=[];relf5=[];relf6=[];
t1=[];t2=[];ma1=[];ma2=[];d1=[];d2=[];a1=[];a2=[];
p1=[];p2=[];th1=[];th2=[];pthr=10*pi/180;fthr=10*pi/180;
figure(1),hold off,hold on;
figure(2),hold off,hold on;
for i=1:length(l1s)
l1=ceil(0.5*length(l1s(i).is));
h11=[h11 l1s(i).co(1:l1)'];
h12=[h12 l1s(i).co(l1+1:end)'];
p11=[p11 l1s(i).psi(1:l1)];
p12=[p12 l1s(i).psi(l1+1:end)];
ma1=[ma1 MeanAngle(l1s(i).co(1:l1)')];
ma2=[ma2 MeanAngle(l1s(i).co(l1+1:end)')];
l1=ceil(0.5*length(l2s(i).is));
h21=[h21 l2s(i).co(1:l1)'];
h22=[h22 l2s(i).co(l1+1:end)'];
p21=[p21 l2s(i).psi(1:l1)];
p22=[p22 l2s(i).psi(l1+1:end)];

ma1=[ma1 MeanAngle(l2s(i).co(1:l1)')];
ma2=[ma2 MeanAngle(l2s(i).co(l1+1:end)')];
f2nest1=AngularDifference(l1s(i).co,l1s(i).o2n)';
f2nest2=AngularDifference(l2s(i).co,l2s(i).o2n)';
relf1=[relf1 AngularDifference(l1s(i).co,l1s(i).ang)'];
relf2=[relf2 f2nest1];
relf3=[relf3 AngularDifference(l1s(i).co,l1s(i).xangle)'];
relf4=[relf4 AngularDifference(l2s(i).co,l2s(i).ang)'];
relf5=[relf5 f2nest2];
relf6=[relf6 AngularDifference(l2s(i).co,l2s(i).xangle)'];
is=find((abs(l1s(i).psi)<pthr)&(abs(f2nest1)<fthr));
if(l1s(i).hand==1)
    figure(1),plot(l1s(i).cs(is,1),l1s(i).cs(is,2),'b- .')
    c11=[c11;l1s(i).cs(is,:)];
p1=[p1 l1s(i).psi];
th1=[th1 (l1s(i).ts-l1s(i).ts(1))/l1s(i).t];
else
    figure(2),plot(l1s(i).cs(is,1),l1s(i).cs(is,2),'b- .')
c12=[c12;l1s(i).cs(is,:)];
    p2=[p2 l1s(i).psi];
    th2=[th2 (l1s(i).ts-l1s(i).ts(1))/l1s(i).t];
end
is=find((abs(l2s(i).psi)<pthr)&(abs(f2nest2)<fthr));
if(l2s(i).hand==1)
    figure(1),plot(l2s(i).cs(is,1),l2s(i).cs(is,2),'r- .')
c21=[c21;l2s(i).cs(is,:)];
    p1=[p1 l2s(i).psi];
th1=[th1 (l2s(i).ts-l2s(i).ts(1))/l2s(i).t];
else
    figure(2),plot(l2s(i).cs(is,1),l2s(i).cs(is,2),'r- .')
c22=[c22;l2s(i).cs(is,:)];
    p2=[p2 l2s(i).psi];
    th2=[th2 (l2s(i).ts-l2s(i).ts(1))/l2s(i).t];
end
t1=[t1 (l1s(i).ts-l1s(i).ts(1))/l1s(i).t];
t2=[t2 (l2s(i).ts-l2s(i).ts(1))/l2s(i).t];
d1=[d1 l1s(i).ds'/max(l1s(i).ds)];
d2=[d2 l2s(i).ds'/max(l2s(i).ds)];
x=l1s(i).cs(:,1)-l1s(i).xp(1);y=l1s(i).cs(:,2)-l1s(i).xp(2);
a1=[a1 cart2pol(x,y)'];
x=l2s(i).cs(:,1)-l2s(i).xp(1);y=l2s(i).cs(:,2)-l2s(i).xp(2);
a2=[a2 cart2pol(x,y)'];
% ma1=[ma1 l1s(i).dds'/max(l1s(i).dds)];
% ma2=[ma2 l2s(i).dds'/max(l2s(i).dds)];
%     p1in(i)=l1s(i).psi(1);
% p1out(i)=l1s(i).psi(end);
% p2in(i)=l2s(i).psi(1);
% p2out(i)=l2s(i).psi(end);
end
[y1,x]=AngHist([h11 h21]*180/pi);
[y2,x]=AngHist([h12 h22]*180/pi);
[y3,x]=AngHist([p11 p21]*180/pi);
[y4,x]=AngHist([p12 p22]*180/pi);
subplot(1,2,1),plot(x,y3,x,y4,'k - o'),axis tight
subplot(1,2,2),plot(x,y1,x,y2,'k - o'),axis tight
% [y3,x]=AngHist(h21*180/pi);
% [y4,x]=AngHist(h22*180/pi);
psi2=[[l1s.psi]*180/pi [l2s.psi]*180/pi];
[D,xs,ys,xps,yps]=Density2D([l1s.psi]*180/pi,relf1*180/pi,-180:10:180,-180:10:180);
[D,xs,ys,xps,yps]=Density2D(psi2,[relf1 relf4]*180/pi,-180:10:180,-180:10:180);
[D,xs,ys,xps,yps]=Density2D(psi2,[t1 t2],-180:10:180,0:0.025:1);
[D,xs,ys,xps,yps]=Density2D([relf2 relf5]*180/pi,[t1 t2],-180:10:180,0:0.025:1);
[D,xs,ys,xps,yps]=Density2D(p1*180/pi,[th1],-180:10:180,0:0.025:1);
[D,xs,ys,xps,yps]=Density2D(p2*180/pi,[th2],-180:10:180,0:0.025:1);
[D,xs,ys,xps,yps]=Density2D(psi2,[d1 d2],-180:10:180,0:0.025:1);
[D,xs,ys,xps,yps]=Density2D(psi2,[a1 a2]*180/pi,-180:10:180,-180:10:180);
[D,xs,ys,xps,yps]=Density2D(psi2,[relf2 relf5]*180/pi,-180:10:180,-180:10:180);
contourf(xps,yps,-D+max(D(:)))

rf=[relf1 relf4]*180/pi;
psi0=find(abs(psi2)<10);
[y1,x]=AngHist(rf);
[y2,x]=AngHist(rf(psi0));
[y3,x]=AngHist(psi2);
plot(x,y1/sum(y1),x,y2/sum(y2),'r:',x,y3/sum(y3),'k--o'),axis tight

i1s=find([l1s.hand]==1)
a1s=[l1s(i1s).a2nest];
[y5,x]=AngHist([l1s(i1s).cpang]*180/pi)
i2s=find([l2s.hand]==1)
a2s=[l2s(i2s).a2nest];
[y6,x]=AngHist([l2s(i2s).cpang]*180/pi)
i3s=find([l1s.hand]==-1)
a3s=[l1s(i3s).a2nest];
[y7,x]=AngHist([l1s(i3s).cpang]*180/pi)
i4s=find([l2s.hand]==-1)
a4s=[l2s(i4s).a2nest];
[y8,x]=AngHist([l2s(i4s).cpang]*180/pi)
[y1,x]=AngHist(a1s*180/pi);[y2,x]=AngHist(a2s*180/pi);
[y3,x]=AngHist(a3s*180/pi);[y4,x]=AngHist(a4s*180/pi);

plot(0,0,'x')
hold on
for i=i1s plot(l1s(i).xp(1),l1s(i).xp(2),'o'); end;
for i=i2s plot(l2s(i).xp(1),l2s(i).xp(2),'ro'); end;
for i=i3s plot(l1s(i).xp(1),l1s(i).xp(2),'x'); end;
for i=i4s plot(l2s(i).xp(1),l2s(i).xp(2),'rx'); end;

plot(c11(:,1),c11(:,2),'bx',c21(:,1),c21(:,2),'k.')
plot(c12(:,1),c12(:,2),'bx',c22(:,1),c22(:,2),'k.')

set(gca,'YDir','reverse'),axis equal,grid
hold off

a=[l2s(i4s).xp];ax=a(1:2:end);ay=a(2:2:end);
a=[l1s(i3s).xp];ax=a(1:2:end);ay=a(2:2:end);
subplot(2,2,1)
[D1,xs,ys,xps,yps]=Density2D(c11(:,1),c11(:,2),-20:2:20,-20:2:20);
contourf(xps,yps,-D+max(D(:)))
set(gca,'YDir','reverse'),axis equal
subplot(2,2,2)
[D,xs,ys,xps,yps]=Density2D(c21(:,1),c21(:,2),-20:2:20,-20:2:20);
contourf(xps,yps,-D+max(D(:)))
set(gca,'YDir','reverse'),axis equal
subplot(2,2,3)
[D2,xs,ys,xps,yps]=Density2D(c12(:,1),c12(:,2),-20:2:20,-20:2:20);
contourf(xps,yps,-D+max(D(:)))
set(gca,'YDir','reverse'),axis equal
subplot(2,2,4)
[D,xs,ys,xps,yps]=Density2D(c22(:,1),c22(:,2),-20:2:20,-20:2:20);
contourf(xps,yps,-D1+max(D1(:)))
set(gca,'YDir','reverse'),axis equal
contourf(xps,yps,D1-D2)
colormap default


subplot(2,1,1)
plot(x,y1/sum(y1),x,y2/sum(y2),'r:'),axis tight
xlabel('hand = 1'),title('Angle from nest to loop start. blue is loop1, red dotted loop2')
subplot(2,1,2)
plot(x,y3/sum(y3),x,y4/sum(y4),'r:'),axis tight
xlabel('hand = -1')
subplot(2,1,1)
plot(x,y5/sum(y5),x,y6/sum(y6),'r:'),axis tight
xlabel('hand = 1'),title('Angle from loop start to mid pt.blue is loop1, red dotted loop2')
subplot(2,1,2)
plot(x,y7/sum(y7),x,y8/sum(y8),'r:'),axis tight
xlabel('hand = -1')



a1i=[];a2i=[];a1o=[];a2o=[];
load doubleloopstatstemp
subplot(1,2,1)
plot([l1s.angin]*180/pi,[l2s.angout]*180/pi,'o',[0 360],[0 360],'k')
xlabel('loop 1 in');ylabel('loop 2 out'),axis tight,axis equal
subplot(1,2,2)
plot([l1s.angout]*180/pi,[l2s.angin]*180/pi,'o',[0 360],[0 360],'k')
xlabel('loop 1 out');ylabel('loop 2 in'),axis tight,axis equal
% subplot(1,2,1)
% plot([l1s.angin]*180/pi,[l2s.angin]*180/pi,'o',[0 360],[0 360],'k')
% xlabel('loop 1 in');ylabel('loop 2 in'),axis tight,axis equal
% subplot(1,2,2)
% plot([l1s.angout]*180/pi,[l2s.angout]*180/pi,'o',[0 360],[0 360],'k')
% xlabel('loop 1 out');ylabel('loop 2 out'),axis tight,axis equal

a1i=[a1i [l1s.angin]*180/pi];
a1o=[a1o [l1s.angout]*180/pi];
a2i=[a2i [l2s.angin]*180/pi];
a2o=[a2o [l2s.angout]*180/pi];

subplot(1,2,1)
plot(a1i,a2o,'o',[0 360],[0 360],'k')
[D,xs,ys,xps,yps]=Density2D(a1i,a2o,0:20:360,0:20:360)
contourf(xps,yps,D)
xlabel('loop 1 in');ylabel('loop 2 out'),axis tight,axis equal
subplot(1,2,2)
plot(a1o,a2i,'o',[0 360],[0 360],'k')
[D,xs,ys,xps,yps]=Density2D(a1o,a2i,0:10:360,0:10:360)
contourf(xps,yps,D)
xlabel('loop 1 out');ylabel('loop 2 in'),axis tight,axis equal



% plot psis for nesrtt looking and lm looking for loops and all data
[y,xxs]=AngHist(psi*180/pi,0:10:360,0,0);ya=y./sum(y);
y=AngHist(allpsi*180/pi,0:10:360,0,0);aya=y./sum(y);
y=AngHist(psinest*180/pi,0:10:360,0,0);yn=y./sum(y);
y=AngHist(allpsin*180/pi,0:10:360,0,0);ayn=y./sum(y);
for lm=1:length(allLM)
    y=AngHist(allLM(lm).psilm*180/pi,0:10:360,0,0);yl(lm,:)=y./sum(y);
    y=AngHist(allLM(lm).allpsilm*180/pi,0:10:360,0,0);ayl(lm,:)=y./sum(y);
end
figure(1),plot(xxs,yn,xxs,yl(1,:),'r:',xxs,ya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight,
title('loops: nest looking vs lm looking (dotted) vs all (dashed)')
figure(2),plot(xxs,yn,xxs,ya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight
title('loops: nest looking vs all (dashed)')
figure(3),plot(xxs,yl,xxs,ya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight
title('loops: LM looking vs all (dashed)')
figure(4),plot(xxs,ayn,xxs,ayl(1,:),'r:',xxs,aya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight,
title('all: nest looking vs lm looking (dotted) vs all (dashed)')
figure(5),plot(xxs,ayn,xxs,aya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight
title('all: nest looking vs all (dashed)')
figure(6),plot(xxs,ayl,xxs,aya,'k--'),xlabel('psi'),ylabel('frequency'),Setbox,axis tight
title('all: LM looking vs all (dashed)')


BeeFDirPlot(sos,cos,nors*180/pi,allLM,10,'loops: ',o2n,20:30)
return
figure(2), subplot(1,2,1)
[d,a,b,x1,y]=Density2D(psi*180/pi,relfs*180/pi,[-180:10:180],[-180:10:180]);
contourf(x1,y,d)
xlabel('\psi');ylabel('Flight Dir relative to zz major axis')
axis equal
axis tight
xlim([-90 90])
subplot(1,2,2)%,figure(4),
[d,a,b,x1,y]=Density2D(psi*180/pi,nors*180/pi,[-180:10:180],[-180:10:180]);
contourf(x1,y,d)
xlabel('\psi');ylabel('Retinal nest position')
axis equal
axis([-90 90 -90 90])
figure(3), subplot(1,2,1)
[d,a,b,x1,y]=Density2D(psi*180/pi,dloop,[-180:10:180],[-.1:0.05:1.1]);
contourf(x1,y,d)
xlabel('\psi');ylabel('distance from start point (normalised)')
axis tight
xlim([-90 90])
subplot(1,2,2)
[d,a,b,x1,y]=Density2D(psi*180/pi,daxis,[-180:10:180],[-.1:0.05:1.1]);
contourf(x1,y,d)
xlabel('\psi');ylabel('distance along major axis (normalised)')
axis tight
xlim([-90 90])
keyboard


plot([XPts(:,1) maxds(:,3)]',[XPts(:,2) maxds(:,4)]','b-')
hold on
plot(XPts(:,1),XPts(:,2),'x')
PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0);     hold on;
axis equal
hold off
d=AngularDifference(majax,a2nest);
c=1;tb=2;clear th r n
ang=abs(d)
ang=majax;
for t=0:tb:(max(loopt)+1)
    is=find((loopt>=t)&(loopt<(t+tb)));
    n(c)=length(is);
    if(~isempty(is))
        
        [th(c),r(c)]=cart2pol(mean(cos(ang(is))),mean(sin(ang(is))));
        c=c+1;
    end
end
plot(tb*[1:length(th)],th*180/pi,tb*[1:length(th)],r*100,'r')
keyboard



function[loops]=LoopAngles(cs,inds,co,ts,cmpdir,l1)
loops=[];

is=1:size(cs,1);
if(isempty(is)) return; end;
smlo=1;
smhi=2;
for i=1:(length(is)-1)
    js=(i+3):size(cs,1)-1;%GetTimes(t(1:end-1),t1+tlim);
    for j=js
        if(isCross(cs(is(i):is(i)+1,:),cs(j:j+1,:)))
            if(l1) ils=is(i):j+1;
            else
                i2s=size(cs,1):-1:1;
                cs=cs(i2s,:);
                ils=i2s(j+1):i2s(is(i));
            end
            len=length(ils);
            len2=floor(0.5*len);
            loops.is=inds(ils);
            loops.cs=cs(ils,:);
            loops.co=co(ils);
            loops.ts=ts(ils);
            loops.ds=CartDist(cs(ils,:),cs(ils(1),:));
            loops.len=max(loops.ds);
            loops.t=ts(ils(end))-ts(ils(1));
            loops.xp=GetXPt(ils(1),ils(end),cs);
            
            loops.angin=co(ils(1));
            loops.angout=co(ils(end-1));

            st=max(is(1),ils(1)-smlo);
            en=ils(1)+min(smhi,len2);
            loops.angsin=co(st:en);
            
            en=min(length(is),len-1+smlo);
            st=len-1-min(smhi,len2);
            loops.angsout=co(st:en);
            
            loops.angdiff=AngularDifference(loops.angout+pi,loops.angin);
            loops.xangle=MeanAngle([loops.angout+pi loops.angin]);
            if(loops.angdiff<0) loops.hand=-1;
            else loops.hand=1;
            end
            
            vs=cs(ils,:) - ones(length(ils),1)*loops.xp;           
            [area,axes,angles,ellip] = ellipse(cs(ils,1),cs(ils,2),[],0.8535);
            [gx,gy]=pol2cart(angles(1),1);
            dds=vs*[gx;gy]; dds([1 end])=0;
            loops.dds=dds;
            [maxi,maxind]=max(abs(dds));
            if(dds(maxind)<0) angles(1)=mod(angles(1)-pi,2*pi);end
            [px,py]=pol2cart(angles(1),maxi);
            
%             dloop=[dloop [abs(dvs)/max(dvs)]'];
%             daxis=[daxis [abs(dds)/maxi]'];
            
            loops.ep=loops.xp+[px py];
            loops.ept=ts(ils(maxind));
            loops.len2=maxi;
            loops.ang=mod(angles(1)-cmpdir,2*pi);
            
            loops.cp=mean(cs(ils,:),1);
            mpv=loops.cp-loops.xp;
            loops.cpang=mod(cart2pol(mpv(1),mpv(2))-cmpdir,2*pi);
            loops.a2nest=mod(cart2pol(loops.xp(1),loops.xp(2))-cmpdir,2*pi);
        %             a2lm=[a2lm
        %             mod(cart2pol(loops(i).LM(1,1)-xp(1),loops(i).LM(1,2)-xp(2))-loops(i).cd,2*pi)];
            if(0)
            [tmpx,tmpy]=pol2cart(loops.xangle+cmpdir,loops.len);
            lxs=[loops.xp;loops.xp+[tmpx,tmpy]];            
            plot(cs(:,1),cs(:,2),'r--',loops.cs(:,1),loops.cs(:,2),'k- .');hold on;
            plot(lxs(:,1),lxs(:,2),loops.xp(1),loops.xp(2),'bs',...
                loops.cp(1),loops.cp(2),'rx',loops.ep(1),loops.ep(2),'bo')
            title(['Hand ' int2str(loops.hand)])
            CompassAndLine('k',1); axis equal; hold off
            drawnow;
            end
            return;
        end
    end
end


function changedir(fn)
if(isequal(fn(1:4),'2E20')) cd ../2' east all'/
elseif(isequal(fn(1:4),'2w20')) cd ../'2 west'/
elseif(isequal(fn(1:2),'W8')) cd ../'west 8'/
elseif(isequal(fn(1:2),'N8')) cd ../'north 8'/
elseif(isequal(fn(1:2),'E8')) cd ../'east 8'
elseif(isequal(fn(1:2),'s8')) cd ../'south 8'
end

function Someplots
load loopstatstemp
plot(looplen,maxds(:,1),'o')
plot(looplen,maxpsi(:,1),'o')
plot(looplen,maxpsi(:,3),'go')
hist(maxpsi(:,3),40)
hist(maxpsi(:,4),40)

soN=AngularDifference(sos,o2n)*180/pi;
y1=AngHist(soN);
psiN=AngularDifference(cos,o2n)*180/pi;
y2=AngHist(psiN);
ts=-170:10:180;
soAll=AngularDifference(allsos,allo2n)*180/pi;
y3=AngHist(soAll);
psiAll=AngularDifference(allcos,allo2n)*180/pi;
y4=AngHist(psiAll);
ts=-170:10:180;
plot(ts,y1./sum(y1),ts,y2./sum(y2),'r'),axis tight
hold on;
plot(ts,y3./sum(y3),'b:',ts,y4./sum(y4),'r:'),axis tight
hold off


function[cr]=isCross(l1,l2)

x1=l1(1,1); y1=l1(1,2);
x2=l1(2,1); y2=l1(2,2);
x3=l2(1,1); y3=l2(1,2);
x4=l2(2,1); y4=l2(2,2);

[x,y]=IntersectionPoint(x1,x2,x3,x4,y1,y2,y3,y4);

cr=0;
if((x>=min(x1,x2))&&(x<=max(x1,x2)))
    if((y>=min(y1,y2))&&(y<=max(y1,y2)))
        if((x>=min(x3,x4))&&(x<=max(x3,x4)))
            if((y>=min(y3,y4))&&(y<=max(y3,y4))) cr=1; end
        end
    end
end


function[pcN,pcL,pcNind,nolook,nolooki]= LookPts(t,loop,cs,in,ils,inds,pic,LM,LMWid)

nL=length(loop)
% divide arcs into10
narc=10;
nls=zeros(nL,2*narc);
nlind=zeros(nL,2*narc);
nt_is=zeros(nL,2*narc);
nolook=[];nolooki=[];pcN=[];pcNind=[];
for i=1:length(ils)
    pcL(i).nolook=[];pcL(i).nolooki=[];pcL(i).pc=[];pcL(i).pci=[];
end
for k=1:nL
    if(pic(k))
        % time based loop
        is=loop(k).is;
        tr=[t([is(1) is(end)])];
        tl=tr(2)-tr(1);
        t_is=GetTimes(t,tr);
        lks=intersect(t_is,in);
        if(~isempty(lks)) pcN=[pcN (t(lks)-tr(1))/tl];
        else nolook=[nolook; k tr(1) tl];
        end;
        lks=intersect(t_is,inds);
        if(~isempty(lks)) pcNind=[pcNind (t(lks)-tr(1))/tl];
        else nolooki=[nolooki; k tr(1) tl];
        end;
        for i=1:length(ils)
            lks=intersect(t_is,ils(i).is);
            if(~isempty(lks)) pcL(i).pc=[pcL(i).pc (t(lks)-tr(1))/tl];
            else pcL(i).nolook=[pcL(i).nolook k];
            end;
            lks=intersect(t_is,ils(i).meanTind);
            if(~isempty(lks)) pcL(i).pci=[pcL(i).pci (t(lks)-tr(1))/tl];
            else pcL(i).nolooki=[pcL(i).nolooki k];
            end;
        end
        
        ds=CartDist(cs(is,:),cs(is(1),:));
        figure(1),plot(t(is),ds);
        lks=intersect(t_is,in);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(t(lks),d2,'r.');  hold off
        end
        lks=intersect(t_is,ils(1).is);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(t(lks),d2,'gs');  hold off
        end
        title(num2str(tr))
        
        figure(2),plot(cs(is,1),cs(is,2));
        lks=intersect(t_is,in);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(cs(lks,1),cs(lks,2),'r.');  hold off
        end
        lks=intersect(t_is,ils(1).is);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(cs(lks,1),cs(lks,2),'gs');  hold off
        end
        hold on; PlotNestAndLMs(LM,LMWid,[0 0],0);
        
        
        hold off
        
        axis equal
        title(num2str(tr))
        
        %     tr=[mi2ma(i,1) mi2ma(i,4)];
        %     ts =(tr(2)-tr(1))/narc;
        %     for j=1:narc
        %         t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
        %         lks=intersect(t_is,ils);
        %         nt_is(k,j)=nt_is(k,j)+length(t_is);
        %         nls(k,j)=nls(k,j)+length(lks);
        %         lks=intersect(t_is,inds);
        %         nlind(k,j)=nlind(k,j)+length(lks);
        %     end
        %     tr=[mi2ma(i,4) mi2ma(i+1,1)];
        %     ts =(tr(2)-tr(1))/narc;
        %     for j=1:narc
        %         t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
        %         nt_is(k,j+narc)=nt_is(k,j+narc)+length(t_is);
        %         lks=intersect(t_is,ils);
        %         nls(k,j+narc)=nls(k,j+narc)+length(lks);
        %         lks=intersect(t_is,inds);
        %         nlind(k,j+narc)=nlind(k,j+narc)+length(lks);
        %     end
    end
end
% keyboard


function[X]=GetXPt(i1,i2,c)
[x,y]=IntersectionPoint(c(i1,1),c(i1+1,1),c(i2,1),c(i2-1,1),...
    c(i1,2),c(i1+1,2),c(i2,2),c(i2-1,2));
X=[x y];