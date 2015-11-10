function[loops]=loopstats(loops,outfn)

if((nargin<1)||isempty(loops))
    % Get Data file
    fs=dir('Loops*.mat');
    WriteFileOnScreen(fs,1);
    Picked=input('select output file; return for all:  ');
    if(isempty(Picked)) Picked=1:length(fs); end;
    fns=fs(Picked);
else fns=1;
end
origdir=cd;

rs=[];rsm=[];ra_s=[];ra_sm=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];ra_f2n=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];
ts=[];meanrates=[];

nolook=[];nolooki=[];pcN=[];pcNind=[];pcL=[];loopdist=[];
majax=[];a2nest=[];a2mid=[];maxds=[];XPts=[];loopt=[];a2lm=[];looplen=[];
allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

allpsin=[];allpsi=[];

midpts=[];eptsAngc=[];eptsMid=[];angcs=[];dangcs=[];
xpds=[];pxpd=[];npts=[]; LoopProps=[];relloopt=[];lspeed=[];relspeed=[];

for k=1:length(fns)
    if(~isequal(fns,1))
        load(fns(k).name);
        changedir(loops(1).fn);
    end
    for i=1:length(loops)
        i
        l=loops(i).loop;
        pic=loops(i).Picked;
        fn=loops(i).fn;
        load(fn);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        fdir=AngularDifference(Cent_Os,sOr);
        [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);
        %
        if(i==1)
            nLM=length(LMs);
            for lm=1:nLM
                if(length(allLM)<lm)
                    allLM(lm).LMOnRetina=[];
                    allLM(lm).OToLM=[];
                    allLM(lm).psilm=[];
                    allLM(lm).allpsilm=[];
                end
            end
        end

        loops(i).so=sOr;
        loops(i).Co=Cent_Os;
        loops(i).cs=Cents;
        loops(i).es=EndPt;
        loops(i).fdir=fdir;
        loops(i).o2n=OToNest;
        loops(i).f2n=AngularDifference(Cent_Os,OToNest);
        loops(i).t=t;
        loops(i).nor=NestOnRetina;
        loops(i).lor=LMs;
        loops(i).in=in;
        loops(i).ils=ils;
        loops(i).len=len;
        loops(i).meanTind=meanTind;
        loops(i).meanT=meanT;
        loops(i).meanC=meanC;

        loops(i).LM=LM;
        loops(i).LMw=LMWid;
        
        if(exist('compassDir')) loops(i).cd=compassDir;
        else loops(i).cd=4.9393;
        end
        cmpdir=loops(i).cd;
        
        so=loops(i).so;
        co=loops(i).Co;
        cs=loops(i).cs;%=Cents;
        es=loops(i).es;
        fdir=loops(i).fdir;%=fdir;
        t=loops(i).t;
        ftonest=AngularDifference(co,OToNest);

        allsos=[allsos so];
        allcos=[allcos co'];
        allo2n=[allo2n OToNest'];
        allpsi=[allpsi fdir'];
        allpsin=[allpsin fdir(in)'];
        for lm=1:nLM 
            allLM(lm).allpsilm=[allLM(lm).allpsilm fdir(ils(lm).is)']; 
        end;

        %     allcs=[allcs; loops(i).cs];
        gs=find(DToNest>8);
        %      allcs=[allcs; co(gs)];

        %     o2n=[o2n; OToNest];
        %     o2lm=[o2lm; LMs(1).OToLM];
        %     [p,pl,pni,nol,noli]=LookPts(t,l,cs,loops(i).in,loops(i).ils,loops(i).meanTind,pic,LM,LMWid);
        %     pcN=[pcN p];pcL=[pcL pl];pcNind=[pcNind pni];
        %     nolook=[nolook;nol];nolooki=[nolooki;noli];

        alloopt=[];
        looppict=[];
        for j=1:length(l)
            if(pic(j))
                is=l(j).is;
                looppict=union(looppict,is);

                as=AngleWithoutFlip(so(is))*180/pi;
                ac=AngleWithoutFlip(co(is))*180/pi;
                af=AngleWithoutFlip(fdir(is))*180/pi;
                af2n=AngleWithoutFlip(ftonest(is))*180/pi;
                asm=TimeSmooth(as,t(is),0.1);
                acm=TimeSmooth(ac,t(is),0.1);
                afm=TimeSmooth(af,t(is),0.1);

                rs=[rs max(as)-min(as)];
                rsm=[rsm max(asm)-min(asm)];
                c_os=[c_os max(ac)-min(ac)];
                csm=[csm max(acm)-min(acm)];
                fs=[fs max(af)-min(af)];
                fsm=[fsm max(afm)-min(afm)];

                smm=5;
                gr_as=MyGradient(as,t(is));
                gr_ac=MyGradient(ac,t(is));
                gr_af=MyGradient(af,t(is));
                gr_af2n=MyGradient(af2n,t(is));
                ra_s=[ra_s gr_as];
                ra_c=[ra_c gr_ac];
                ra_f=[ra_f gr_af];
                ra_f2n=[ra_f2n gr_af2n];
                
                meanrates=[meanrates; ...
                    mean(abs(gr_as)) mean(abs(gr_ac)) mean(abs(gr_af)) ...
                    median(abs(gr_as)) median(abs(gr_ac)) median(abs(gr_af)) ...
                    mean(abs(gr_af2n)) median(abs(gr_af2n))];
                    
                ra_sm=[ra_sm medfilt1(gr_as)];
                ra_cm=[ra_cm medfilt1(gr_ac)];
                ra_fm=[ra_fm medfilt1(gr_af)];
                
                xp=GetXPt(is(1),is(end),cs);
                XPts=[XPts; xp];
                
                [area,axes,angles,ellip] = ellipse(cs(is,1),cs(is,2),[],0.8535);
                vs=cs(is,:) - ones(length(is),1)*xp;
                [gx,gy]=pol2cart(angles(1),1);
                dds=vs*[gx;gy];
                dds([1 end])=0;
                [maxi,maxind]=max(abs(dds));
                if(dds(maxind)<0) angles(1)=mod(angles(1)-pi,2*pi);end
                majax=[majax mod(angles(1)-loops(i).cd,2*pi)];
                [px,py]=pol2cart(angles(1),maxi);
                px=px+xp(1);py=py+xp(2);
                maxds=[maxds;maxi maxind px py];
                
                % central point of loop
                c_pt=mean(cs(is,:));
                midpts=[midpts;c_pt];
                
                vm=c_pt-xp;
                [angc,dum]=cart2pol(vm(1),vm(2));
                angloop=cart2pol(vs(:,1),vs(:,2));
                dvs=CartDist(vs);
                dcs=CartDist(cs(is,:));
                lc=CartDist(vm);
                lx=CartDist(xp);
                igs=dvs>=lc;
                gis=is(igs);
                [dum,midi]=min(abs(AngularDifference(angloop(igs),angc)));
                eptsMid=[eptsMid;cs(gis(midi),:) gis(midi) t(gis(midi))];
                l1=[xp;c_pt;cs(gis(midi),:)];
                angc=mod(angc-cmpdir,2*pi);
                angcs=[angcs,angc];
                dangc=AngularDifference(angc,co(is));
                dangcs=[dangcs dangc];
                indis=find(midi==is);
                
                xpds=[xpds dcs'-lx];
                pxpd=[pxpd 100*(sum((dcs-lx)>0)/length(dvs))];
                npts=[npts length(dvs)];
                
                midi=find((abs(dangc)>=(pi/2))&(dvs'>=(lc)),1);
                eptsAngc=[eptsAngc;cs(is(midi),:) is(midi) t(is(midi))];
                
                dv2s=diff(cs(is,:));
                loopdist=[loopdist sum(CartDist(dv2s))];
%                 figure(1);
%                 PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0);     
%                 hold on;
%                 plot(0,0,'*',cs(is,1),cs(is,2),l1(:,1),l1(:,2),'g-s', ...
%                     cs(is(midi),1),cs(is(midi),2),'kd'),axis equal, %hold off
%                       
                a2nest=[a2nest mod(cart2pol(-xp(1),-xp(2))-loops(i).cd,2*pi)];
                a2mid=[a2mid mod(cart2pol(-c_pt(1),-c_pt(2))-loops(i).cd,2*pi)];
                a2lm=[a2lm mod(cart2pol(loops(i).LM(1,1)-xp(1),loops(i).LM(1,2)-xp(2))-loops(i).cd,2*pi)];
                loopt=[loopt median(t(is))];
                relloopt=[relloopt median(t(is))/max(t)];
                looplen=[looplen t(is(end))-t(is(1))];

                psi=[psi fdir(is)'];
                lspeed=[lspeed Speeds(is)'];
                relspeed=[relspeed (Speeds(is)/prctile(Speeds(is),95))'];
                relt=t(is)-t(is(1));
                ts=[ts relt/max(relt)]; 
                abf=abs(fdir(is))*180/pi;
                maxpsi=[maxpsi;mean(abf) prctile(abf,[50, 75, 90, 95,99]) max(abf)];
                sos=[sos so(is)];
                cos=[cos co(is)'];
                allcs=[allcs; co(is)];
                o2n=[o2n; OToNest(is)];
                nors=[nors [loops(i).nor(is)]'];
                psinest=[psinest fdir(intersect(is,in))'];
                allLM(1).LM=LM;
                for lm=1:nLM
                    allLM(lm).LMOnRetina=[allLM(lm).LMOnRetina;LMs(lm).LMOnRetina(is)];
                    allLM(lm).OToLM=[allLM(lm).OToLM;LMs(lm).OToLM(is)];
                    allLM(lm).psilm=[allLM(lm).psilm fdir(intersect(is,ils(lm).is))'];
                end

                df=AngularDifference(co(is),majax(end));
                relfs=[relfs df'];
                dvs=CartDist(vs);
                %         dvs([0 end])=0;
                dloop=[dloop [abs(dvs)/max(dvs)]'];
                daxis=[daxis [abs(dds)/maxi]'];

%                         figure(1);
%                         PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0);     hold on;
%                         dtonest=(AngularDifference(co(is)',OToNest(is))*180/pi);
%                         ipl=is((abf'<10)&(abs(dtonest)<10));                        
%                         plot(cs(ipl,1),cs(ipl,2),'b. :'),
%                         
%                         figure(2);
%                         PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0);     hold on;
%                         dtonest=(AngularDifference(co(is)',OToNest(is))*180/pi);
%                         ipl=intersect(is((abf'<10)),in);
%                         plot(cs(ipl,1),cs(ipl,2),'b. :'),
% 
%                                                 plot(xp(1),xp(2),'x',[xp(1) px],[xp(2) py],cs(is,1),cs(is,2),'r:'),
%                         hold off;axis equal
%                         figure(2),plot(t(is),fdir(is)*180/pi,t(is),df*180/pi,'r',t(is), ...
%                             AngularDifference(so(is),0)*180/pi,'g',t(is),loops(i).nor(is)*180/pi,'k')
%                         axis tight; grid
% %                         figure(3),plot(fdir(is)*180/pi,df*180/pi,'b-o', ...
% %                             fdir(is)*180/pi,loops(i).nor(is)*180/pi,'r-x')
%                         figure(3)%,SelectArcs(so(is),t(is)), axis tight; 
%                         plot(t(is)-t(is(1)),so(is)*180/pi,t(is)-t(is(1)),co(is)*180/pi)
            end
            is=l(j).is;
            alloopt=union(alloopt,is);
        end
        LoopProps=[LoopProps;length(looppict),length(alloopt),length(t)];
    end
    cd(origdir)
end

if(nargin<2) 
    save loopstatstemp
else
    save(outfn)
end
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


figure(7)
[D,xs,ys,xps,yps]=Density2D(psi*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:)))
figure(8)
[D,xs,ys,xps,yps]=Density2D(AngularDifference(cos,o2n)*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:)))
figure(9)
[D,xs,ys,xps,yps]=Density2D(dangcs*180/pi,ts,-180:10:180,0:0.025:1);
% [D,xs,ys,xps,yps]=Density2D(relfs*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:)))

% some random plots
dms=CartDist(midpts);
dxs=CartDist(XPts);
figure(1)
plot(CartDist(XPts),CartDist(midpts),'o',[0 60],[0 60],'r')
brob = robustfit(CartDist(XPts),CartDist(midpts))
hold on,plot(CartDist(XPts),brob(1)+brob(2)*CartDist(XPts),'k'), 
xlabel('start distance'),ylabel('mid-point distance'),hold off
figure(2),plot(loopt,CartDist(midpts),'o',loopt,CartDist(XPts),'rx')
brob = robustfit(CartDist(XPts),CartDist(midpts))

BeeFDirPlot(sos,cos,nors*180/pi,allLM,10,'loops: ',o2n,20:30)

[y,x]=AngHist(nors*180/pi,[],[],0); ynor=y/sum(y);
figure(20),hold on, plot(x,ynor,'r:');
title('solid = psi0, red dotted all loop'),hold off;
dtonest=AngularDifference(cos,o2n)*180/pi;
[y,x]=AngHist(dtonest,[],[],0); ynor=y/sum(y);
figure(21),hold on, plot(x,ynor,'r:');
title('solid = psi0, red dotted all loop'),hold off;
for i=1:nLM
    [y,x]=AngHist(allLM(i).LMOnRetina*180/pi,[],[],0); ynor=y/sum(y);
    figure(22+i),hold on, plot(x,ynor,'r:');
    title('solid = psi0, red dotted all loop'),hold off;
end
for i=1:nLM
    dtolm=AngularDifference(cos,allLM(i).OToLM)*180/pi;
    [y,x]=AngHist(dtolm,[],[],0); ynor=y/sum(y);
    figure(22+nLM+i),hold on, plot(x,ynor,'r:');
    title('solid = psi0, red dotted all loop'),hold off;
end

function moreplots
figure(1)
[y2,x]=AngHist(AngularDifference(cos,o2n)*180/pi)
[y1,x]=AngHist((dangcs)*180/pi)
[y3,x]=AngHist((relfs)*180/pi)
plot(x,y2,x,y1,'r--',x,y3,'k:'),axis tight
ylim([0 max([y2,y1])])
figure(2)
[y1,x]=AngHist((angcs)*180/pi)
[y2,x]=AngHist(majax*180/pi)
plot(x,y2,x,y1,'r--'),axis tight
% [D,xs,ys,xps,yps]=Density2D(relfs*180/pi,ts,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:)))
figure(3), [y1,x]=AngHist(AngularDifference(a2mid,angcs)*180/pi)
[y2,x]=AngHist(AngularDifference(a2nest,angcs)*180/pi)
[y3,x]=AngHist(AngularDifference(a2mid,majax)*180/pi)
[y4,x]=AngHist(AngularDifference(a2nest,majax)*180/pi)
plot(x,y2,x,y1,'r--'),axis tight
figure(4)
plot(x,y4,x,y3,'r--'),axis tight
% [y1,x]=AngHist(AngularDifference(dangcs)*180/pi)
% [y1,x]=AngHist((dangcs)*180/pi)
% [y2,x]=AngHist(AngularDifference(cos,o2n)*180/pi)
% [y3,x]=AngHist((relfs)*180/pi)
% plot(x,y2,x,y1,'r--',x,y3,'k:'),axis tight
% ylim([0 900])

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

function psi0looks
all=[];al1=[];al2=[];nn=0;nl1=0;nl2=0;nb1=0;nb2=0;
th=0.1745;
for i=1:length(loops)
    all=[all;loops(i).fdir(loops(i).in)];
    %     al1=[al1;loops(i).fdir(loops(i).ils(1).is)];
    %     al2=[al2;loops(i).fdir(loops(i).ils(2).is)];
    nn=nn+length(find(abs(loops(i).fdir(loops(i).in))<th));
    nl1=nl1+length(find(abs(loops(i).fdir(loops(i).ils(1).is))<th));
    nl2=nl2+length(find(abs(loops(i).fdir(loops(i).ils(2).is))<th));
    ib1=intersect(loops(i).ils(1).is,loops(i).in);
    ib2=intersect(loops(i).ils(2).is,loops(i).in);
    nb1=nb1+length(find(abs(loops(i).fdir(ib1))<th));
    nb2=nb2+length(find(abs(loops(i).fdir(ib2))<th));
    al1=[al1;loops(i).fdir(ib1)];
    al2=[al2;loops(i).fdir(ib2)];
end
[y,x]=AngHist(all*180/pi);[y1,x]=AngHist(al1*180/pi);[y2,x]=AngHist(al2*180/pi);
plot(x,y/sum(y),'b',x,y1/sum(y1),'r--',x,y2/sum(y2),'k:','LineWidth',1.5),setbox,axis tight

%
% hist(rs,40)
% figure
% hist(c_os,40)
% figure
% hist(c_os./rs,40)
% hist(c_os./rs,[0:0.25:10])
% hist(c_os./rs,[0:0.25:10]),xlim([0 10])
% y1=hist(rs,0:20:500);
% y2=hist(c_os,[0:10:500]*2);
% y1=hist(rs,0:10:500);
% ang=0:10:500;
% plot(ang,y1,ang,y2,'r')
% y2=hist(c_os*0.5,[0:10:500]);
% plot(ang,y1,ang,y2,'r')
%
%

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