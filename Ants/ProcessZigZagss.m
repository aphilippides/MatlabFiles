% function[ang3,ang,eccs] = ProcessZigZags(fltsec,pl,fstr)
function[zzt,zzdist,eccs] = ProcessZigZagss(fltsec,pl,fstr)
if(nargin<2) pl=1; end;
if(nargin<3) fstr='temp'; end;
% function[relfs,mpsi,nors] = ProcessZigZags(fltsec)
ts=-180:10:180;
ang=[];
for i=1:(length(ts)-1)
    sfs(i).so=[];
    sfs(i).co=[];
    sfs(i).a=[];
end
ang2=[];
ang3=[];
eccs=[];
nors=[];
mpsi=[];
relfs=[];relts=[];
cpdata=[];
maxpsi=[];sos=[];allco=[];o2n=[];zzt=[];zzlen=[];zzdist=[];
dangcs=[];dangs=[];dang2s=[];ang2nest=[];angfb=[];dangfbs=[];dangBs=[];
allo2n=[];allsos=[];allcos=[];tzz=[];ftonest=[];

ztime=[];zztime=[];ztime2=[];zztime2=[];ztimec=[];zztimec=[];
ztimefb=[];zztimefb=[];ztimeB=[];zztimeB=[];ztimeP=[];
zds=[];zdsc=[];zds2=[];zdsfb=[];zdsP=[];zdsB=[];
ztimeX=[];zdsX=[];zzfang=[];zzfangl=[];zza.as=[];zza.ls=[];

tz2=[];tzB=[];tzP=[];iz2s=[];izBs=[];izPs=[];zzds=[];isto=[];isaway=[];

ra_s=[];ra_c=[];ra_f=[];meanrates=[];zzspeed=[];
allrelsp=[];allrelts=[];relspzz=[];
allrelspB=[];allreltsB=[];relspzzB=[];
figure(1)
numzz=1;
for i=1:length(fltsec)
    fn=fltsec(i).fn; load(fn);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end
    fltsec(i).o2n=OToNest;
    fltsec(i).nor=NestOnRetina;
    fltsec(i).t=t;
    if(strfind(cd,'2008')) fltsec(i).cmpdir=compassDir;
    else fltsec(i).cmpdir=4.94;
    end
    allsos=[allsos sOr];
    allcos=[allcos Cent_Os'];

    cmpdir=fltsec(i).cmpdir;
    no=fltsec(i).nor;
    t=fltsec(i).t;    
%     allsos=[allsos so];
%     allcos=[allcos co'];
%     allo2n=[allo2n fltsec(i).o2n'];
    allzz=[];zzpict=[];
    for j=1:length(fltsec(i).fsec);
        cs=fltsec(i).fsec(j).cs;
        is=fltsec(i).fsec(j).is;
        if(size(cs,1)>=4)
            ts=t(is);
            psi=AngularDifference(fltsec(i).fsec(j).co,fltsec(i).fsec(j).so);
            psi0=find(abs(psi*180/pi)<=10);
            [area,axes,angles,ellip] = ellipse(cs(:,1),cs(:,2),[],0.8535);
            c_pt=mean(cs);
            ecc=axes(1)/axes(2);
            a=angles(1);
            dv=cs(end,:)-cs(1,:);
            [thang,zzl]=cart2pol(dv(1),dv(2));
            if(abs(AngularDifference(a,thang))>(pi/2))
                if(a>=0) a=a-pi;
                else a=a+pi;
                end
            end
            a=mod(a-cmpdir,2*pi);
            if(a>=pi)
                ang = [ang a-pi];
                a=a-2*pi;
            else ang =[ang a];
            end
            ang3=[ang3 a];         
            ang2=[ang2;MeanAngle(fltsec(i).fsec(j).co)];
            eccs=[eccs ecc];
            dang=AngularDifference(a(1),fltsec(i).fsec(j).co)*180/pi;
            vm=c_pt-cs(1,:);
            [angc,dum]=cart2pol(vm(1),vm(2));             
            angc=mod(angc-cmpdir,2*pi);
            fb=cs(end,:)-cs(1,:);
            angfb=[angfb mod(cart2pol(fb(1),fb(2))-cmpdir,2*pi)];
            dangc=AngularDifference(angc,fltsec(i).fsec(j).co)*180/pi;
            dang2=AngularDifference(ang2(end),fltsec(i).fsec(j).co)*180/pi;
            dangfb=AngularDifference(angfb(end),fltsec(i).fsec(j).co)*180/pi;
            dangB=AngularDifference(fltsec(i).fsec(j).co(1),fltsec(i).fsec(j).co)*180/pi;
            if pl
                figure(1)
                PlotNestAndLMs(fltsec(i).lm,fltsec(i).lmw,[0 0]); hold on
                PlotAngLine([angles(1),ang2(end)+cmpdir],c_pt,cs([1 end],:))
                plot(cs(:,1),cs(:,2),cs(1,1),cs(1,2),'bo','MarkerFaceColor','b')
                title(int2str(a*180/pi))%(int2str([a thang]*180/pi))%title(num2str(ecc))
                axis equal
                hold off
                figure(2)
                plot(ts,psi*180/pi,ts,dang,'r',ts,dangc,'k',ts,dangfb,'g--'),grid on
                axis tight
%                 figure(3), plot(dang,psi*180/pi,'b-o')
                %             xlabel(num2str(a*180/pi))
            end

%             ind=find(hist(a*180/pi,ts))-1;
%             if(ind==0) ind=36; end;
%             sfs(ind).so=[sfs(ind).so;fltsec(i).fsec(j).so'];
%             sfs(ind).a=[sfs(ind).a;ones(length(fltsec(i).fsec(j).so),1)*a];
%             sfs(ind).co=[sfs(ind).co;fltsec(i).fsec(j).co];
%             cpdata=[cpdata;fltsec(i).fsec(j).co fltsec(i).fsec(j).so'];
%             plot(cs(:,1),br(1)+br(2)*cs(:,1),'r-', cs(:,1),cs(:,2),'b x')

%             [mp,vp]=MeanAngle(psi);
            ang2nest=[ang2nest mod(cart2pol(-c_pt(1),-c_pt(2))-cmpdir,2*pi)];
            dangs=[dangs dang];       
            dangcs=[dangcs dangc];       
            dang2s=[dang2s dang2];       
            dangfbs=[dangfbs dangfb];
            dangBs=[dangBs dangB];
            mpsi=[mpsi psi'];
            nors=[nors no(is)'];
            relfs=[relfs AngularDifference(fltsec(i).fsec(j).co,a)'];
            o2n=[o2n [fltsec(i).o2n(is)]'];
            abf=abs(psi)*180/pi;
            maxpsi=[maxpsi;mean(abf) prctile(abf,[50, 75, 90, 95,99]) max(abf)];
            sos=[sos fltsec(i).fsec(j).so];
            allco=[allco fltsec(i).fsec(j).co'];
            zzt=[zzt t(is(end))-t(is(1))];            
            
            dv2s=diff(cs);
            zzdist=[zzdist sum(CartDist(dv2s))];
            relt=ts-ts(1);
            relts=[relts relt/max(relt)];
            zzlen=[zzlen zzl];
            [zztime,ztime,zds]=GetZZData(dang,10,cs,ts,zztime,ztime,zds,[]);
            [zztimec,ztimec,zdsc]=GetZZData(dangc,10,cs,ts,zztimec,ztimec,zdsc,[]);
            [zztimefb,ztimefb,zdsfb]=GetZZData(dangfb,10,cs,ts,zztimefb,ztimefb,zdsfb,[]);
            [zztime2,ztime2,zds2,tz2,iz2,zzd]=GetZZData(dang2,10,cs,ts,zztime2,ztime2,zds2,tz2);
%             [zztimeB,ztimeB,zdsB,tzB,izB]=GetZZData(dangB,10,cs,ts,zztimeB,ztimeB,zdsB,tzB);
            
            [rspzz,ztimeB,zdsB,rtz,izB,rtzA,rtDat]=GetZZData2(dang2*pi/180,cs,ts,ztimeB,zdsB,Speeds(is)',fltsec(i).fsec(j).co');
            relspzzB=[relspzzB rspzz];            
            rsp=Speeds(is)'; rsp(izB)=rspzz;           
            allrelspB=[allrelspB rsp];
            tzB=[tzB rtz];
            rts=ts; rts(izB)=rtz;
            fltsec(i).fsec(j).reltDang2=rtzA;
            fltsec(i).fsec(j).reltDang2Dat=rtDat;
            allreltsB=[allreltsB rts];
            
            dco=AngularDifference(fltsec(i).fsec(j).co',[fltsec(i).o2n(is)]');
            
            [rspzz,ztimeX,zdsX,rtz,iz,rtzA,rtDat,zzdB,zzan,zzal]=GetZZData2(psi',cs,ts,ztimeX,zdsX,Speeds(is)',fltsec(i).fsec(j).co');
            zza(numzz).as=zzan; zza(numzz).ls=zzal; numzz=numzz+1;
            fd=fltsec(i).fsec(j).co';
            [zzan,zzal]=MeanAngle(fd(abs(psi')<=(pi/18)));
            zzfang=[zzfang zzan];zzfangl=[zzfangl zzal];
            fltsec(i).fsec(j).reltPsi=rtzA;
            fltsec(i).fsec(j).reltPsiDat=rtDat;
            
            [rspzz,ztimeP,zdsP,rtz,izP,rtzA,rtDat]=GetZZData2(dco,cs,ts,ztimeP,zdsP,Speeds(is)',fltsec(i).fsec(j).co');
            relspzz=[relspzz rspzz];            
            rsp=Speeds(is)'; rsp(izP)=rspzz;           
            allrelsp=[allrelsp rsp];
            tzP=[tzP rtz];
            rts=ts; rts(izP)=rtz;
            allrelts=[allrelts rts];
            fltsec(i).fsec(j).reltDco=rtzA;
            fltsec(i).fsec(j).reltDcoDat=rtDat;
            
            iz2s=[iz2s length(tzz)+iz2];
            izPs=[izPs length(tzz)+izP];
            izBs=[izBs length(tzz)+izB];
            zzds=[zzds zzd];
            
            if(~isempty(izP))
                imms=find((AngularDifference(dco(izP)).*dco(izP(1:end-1)))<=0);
                isto=[isto length(tzz)+izP(imms)];
                imms=find((AngularDifference(dco(izP)).*dco(izP(1:end-1)))>0);
                isaway=[isaway length(tzz)+izP(imms)];
            end
            ftonest=[ftonest dco];
            tzz=[tzz ts];

            if(~isequal(relspzz,allrelsp(izPs)))
                keyboard;
            end
            
            as=AngleWithoutFlip(fltsec(i).fsec(j).so)*180/pi;
            ac=AngleWithoutFlip(fltsec(i).fsec(j).co')*180/pi;
            af=AngleWithoutFlip(psi')*180/pi;
            gr_as=MyGradient(as,t(is));
            gr_ac=MyGradient(ac,t(is));
            gr_af=MyGradient(af,t(is));
            zzspeed=[zzspeed Speeds(is)'];
            ra_s=[ra_s gr_as];
            ra_c=[ra_c gr_ac];
            ra_f=[ra_f gr_af];
            meanrates=[meanrates; ...
                mean(abs(gr_as)) mean(abs(gr_ac)) mean(abs(gr_af)) ...
                median(abs(gr_as)) median(abs(gr_ac)) median(abs(gr_af))];
        zzpict=union(zzpict,is);
        end
        allzz=union(allzz,is);
        %     pause
    end
    ZZProps(i,:)=[length(zzpict),length(allzz),length(t)];
    axis equal
    hold off
end
save(['processzigzags' fstr '.mat']);

figure(1)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dangs,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')

figure(2)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dangcs,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')

figure(3)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dang2s,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')

figure(4)
psi0=find(abs(mpsi*180/pi)<=10)
[y1,x]=AngHist(dangs(psi0));
[y2,x]=AngHist(dangcs(psi0));
[y3,x]=AngHist(dang2s(psi0));
plot(x,y1/sum(y1),'b',x,y2/sum(y2),'r-x',x,y3/sum(y3),'k-o'),
axis tight
% figure(4)
% [y1,x]=AngHist(ang3*180/pi);
% [y2,x]=AngHist(ang2*180/pi);
% plot(x,y1/sum(y1),'b',x,y2/sum(y2),'ro-')
% figure(5)
% [y1,x]=AngHist(AngularDifference(ang3,ang2nest)*180/pi);
% [y2,x]=AngHist(AngularDifference(ang2,ang2nest)*180/pi);
% [y3,x]=AngHist(ang2nest*180/pi);
% plot(x,y1/sum(y1),'b',x,y2/sum(y2),'ro-')%,x,y3/sum(y3),'k'),axis tight
a=1;
% sfs(1).a=[sfs(1).a;sfs(37).a];
% sfs(1).so=[sfs(1).so;sfs(37).so];
% sfs(1).co=[sfs(1).co;sfs(37).co];

% figure(2), subplot(1,2,1)
% [d,a,b,x1,y]=Density2D(mpsi*180/pi,relfs*180/pi,[-180:10:180],[-180:10:180]);
% contourf(x1,y,d)
% xlabel('\psi');ylabel('Flight Dir relative to zz major axis')
% axis equal
% axis([-90 90 -90 90])
% subplot(1,2,2)%,figure(4), 
% [d,a,b,x1,y]=Density2D(mpsi*180/pi,nors*180/pi,[-180:10:180],[-180:10:180]);
% contourf(x1,y,d)
% xlabel('\psi');ylabel('Retinal nest position')
% axis equal
% axis([-90 90 -90 90])

% for i=1:36
%     %      plot(mod(sfs(i).a*180/pi,360),sfs(i).so*180/pi,'.')
%     %      plot(sfs(i).a*180/pi,AngularDifference(sfs(i).a,sfs(i).so)*180/pi,'.')
%     p(i,:)=AngHist(AngularDifference(sfs(i).a,sfs(i).so)*180/pi)
%     % hold on;
%     % plot(ts(i),max(p(i,:))-1,'r*');
%     % hold off
%     % pause
% end
% hold off
% axis tight
% 
% figure(3),
% subplot(4,2,1),
% AngHist(ang3*180/pi),xlabel('angle of straight lines')
% subplot(4,2,2),
% bar(-170:10:180,sum(p([1:36],:))),axis tight,xlabel('\psi all lines')
% subplot(4,2,3),
% bar(-170:10:180,sum(p([1:9],:))),axis tight,xlabel('\psi SW lines')
% subplot(4,2,4),
% bar(-170:10:180,sum(p([10:18],:))),axis tight,xlabel('\psi NW lines')
% subplot(4,2,5),
% bar(-170:10:180,sum(p([19:27],:))),axis tight,xlabel('\psi NE lines')
% subplot(4,2,6),
% bar(-170:10:180,sum(p([28:36],:))),axis tight,xlabel('\psi SE lines')
% subplot(4,2,7),
% plot(ang3*180/pi,mpsi(:,1)*180/pi,'.'),axis tight,ax=axis;
% hold on;plot([-180 180],[-180 180],'r');axis(ax); hold off
% xlabel('angle of line'),ylabel('mean \psi of each line')
% subplot(4,2,8),hist(mpsi(:,2),40),axis tight,xlabel('length of mean \psi
% of each line')

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

% relsp=[relsp sp(is)/prc90(end)];
% ds=diff(cs(is,:));
% zzds(i+1)=sum(CartDist(ds));
% fd=fdir(is);
% [zzang(i+1),zzangl(i+1)]=MeanAngle(fd(abs(dang(is))<=(pi/18)));



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

% pts before
% if(length(zzls)>0)
%     is=1:tps(1)-1;
%     relt=(ts(is)-ts(is(1)))/zzls(1);
%     is=tps(end):length(ts);
%     relt2=(ts(is)-ts(is(1)))/zzls(end);
% end


function Someplots
load processzigzagsout
plot(zzt,zzlen,'o')
plot(zzt,maxpsi(:,1),'o')
plot(zzt,maxpsi(:,3),'go')
hist(maxpsi(:,3),40)
hist(maxpsi(:,4),40)

soM=AngularDifference(sos,o2n)*180/pi;
y5=AngHist(soM);
psiM=AngularDifference(allco,o2n)*180/pi;
y6=AngHist(psiM);
ts=-170:10:180;
plot(ts,y5./sum(y5),ts,y6./sum(y6),'r'),axis tight
maxpsizz=maxpsi;
load loopstatstemp

hist(maxpsi(:,4),40)

soN=AngularDifference(sos,o2n)*180/pi;
y1=AngHist(soN);
psiN=AngularDifference(allco,o2n)*180/pi;
y2=AngHist(psiN);
ts=-170:10:180;
soAll=AngularDifference(allsos,allo2n)*180/pi;
y3=AngHist(soAll);
psiAll=AngularDifference(allcos,allo2n)*180/pi;
y4=AngHist(psiAll);
ts=-170:10:180;
plot(ts,y1./sum(y1),ts,y2./sum(y2),'r',...
    ts,y5./sum(y5),'b:',ts,y6./sum(y6),'r:'),axis tight%...
plot(ts,y1./sum(y1),ts,y2./sum(y2),'r',...
    ts,y5./sum(y5),'b:',ts,y6./sum(y6),'r:',ts,y3./sum(y3),'b-s',ts,y4./sum(y4),'r-s'),axis tight

% max psi plots
[fz,xz]=hist(maxpsizz,40);
fz=fz./sum(fz(:,1));
[fl,xl]=hist(maxpsi,40);
fl=fl./sum(fl(:,1));
ind=[2 4 6];
plot(xl,fl(:,ind),'b',xz,fz(:,ind),'r'),axis tight

% abs psi
[gz,xxz]=hist(abs(mpsi)*180/pi,40);
[gl,xxl]=hist(abs(psi)*180/pi,40);
plot(xxl,gl/sum(gl),xxz,gz/sum(gz),'r')
% just psi
[gz,xxz]=hist((mpsi)*180/pi,40);
[gl,xxl]=hist((psi)*180/pi,40);
[gall,xall]=hist(AngularDifference(allcos,allsos)*180/pi,40);
plot(xxl,gl/sum(gl),xxz,gz/sum(gz),'r',xall,gall/sum(gall),'g:'),axis tight

% psi t-tests
plot(zzt,maxpsizz(:,4),'ro'),axis tight,xlabel('zig zag length (time)'),ylabel('90th percentile of psi')
plot(looplen,maxpsi(:,4),'o'),axis tight,xlabel('loop length (time)'),ylabel('90th percentile of psi')

thr1=min(zzt);thr2=max(zzt);%thr1=0.5;
gl=find((looplen>=thr1)&(looplen<=thr2));
gz=find((zzt>=thr1)&(zzt<=thr2));
subplot(2,1,1),hist(looplen(gl),0:0.25:max([looplen zzt])),axis tight,xlabel('loop length (time)')
subplot(2,1,2),hist(zzt(gz),0:0.25:max([looplen zzt])),axis tight,xlabel('zigzag length (time)')
ind=4;
psistatLoop=maxpsi(gl,ind);
psistatzz=maxpsizz(gz,ind);
[yl,xl]=hist(psistatLoop,40);
[yz,xz]=hist(psistatzz,20);
plot(xz,yz/sum(yz),'r',xl,yl/sum(yl)), axis tight
p1=ranksum(psistatLoop, psistatzz);
pt1t2=[round([median(psistatLoop) median(psistatzz)]) p1] 
p2=ranksum(maxpsi(:,ind), maxpsizz(:,ind));
pall=[round([median(maxpsi(:,ind)) median(maxpsizz(:,ind))]) p2] 
thr=0.5;gl=find(looplen>=thr);gz=find(zzt>=thr);
p3=ranksum(maxpsi(gl,ind), maxpsizz(gz,ind));
pt1=[round([median(maxpsi(gl,ind)) median(maxpsizz(gz,ind))]) p3] 


function PlotAngLine(angs,c,c2)
r=30;
[xs,ys]=pol2cart([angs,angs+pi],r);
xs=xs+c(1);ys=ys+c(2);
plot(xs([1 3]),ys([1 3]),'r',c2(:,1),c2(:,2),'k'...
    ,xs([2 4]),ys([2 4]),'g',[c2(1,1) c(1)],[c2(1,2) c(2)],'b')

% figure(2),

