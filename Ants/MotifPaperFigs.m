function MotifPaperFigs
allang3=[];x3=[];x3i=[];
allang=[];x=[];xi=[];
eccs=[];datout=[];datin=[];
th=3;

% zzrates
% inoutZZ
% psiZZ
% return

% load straight_1north08_outData
% [ang3,ang,e]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
% x3=[x3;AngHist(ang3*180/pi)]; 
% x=[x;hist(ang*180/pi,0:10:180)];
dwork
cd bees/bees07/2' east all'/
load zig_zag_2east_outData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'out');
datout=GetZZData(1,datout);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load zigzag_2west_outData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'out');
datout=GetZZData(1,datout);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load north8_2007_zigzag_outData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'out');
datout=GetZZData(1,datout);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load west8_zigzag_outData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'out');
datout=GetZZData(1,datout);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load zigzag_east8_outData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'out');
datout=GetZZData(1,datout);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

x(:,1)=x(:,1)+x(:,19);
x=x(:,1:18);
xb=x3./(sum(x3,2)*ones(1,36));
xc=x./(sum(x,2)*ones(1,18));
figure(4)
% plot(-170:10:180,sum(x3)./max(sum(x3)),'r',-170:10:180,sum(xb)./max(sum(xb)))
plot(-170:10:180,sum(x3)./sum(sum(x3)),'r',-170:10:180,sum(xb)./sum(sum(xb)))
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
figure(5)
plot(0:10:170,sum(x)./max(sum(x)),'r',0:10:170,sum(xc)./max(sum(xc)))
axis tight;ylim([0 1])
% cd ../../'bees 2008'/'1 north 2008 all'/

% ins
% load straight_1north_inData
% [ang3,ang,e]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
% x3i=[x3i;AngHist(ang3*180/pi)]; 
% xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../2' east all'/
load zig_zag_2east_inData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'in');
datin=GetZZData(0,datin);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load zigzag_2west_inData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'in');
datin=GetZZData(0,datin);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load north8_2007_zigzag_inData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'in');
datin=GetZZData(0,datin);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load west8_zigzag_inData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'in');
datin=GetZZData(0,datin);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load zigzag_east8_inData
[ang3,ang,e]=ProcessZigZagss(fltsec,0,'in');
datin=GetZZData(0,datin);
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ..
save tempMotifpaperFigsData

% 
xi(:,1)=xi(:,1)+xi(:,19);
xi=xi(:,1:18);
xbi=x3i./(sum(x3i,2)*ones(1,36));
xci=xi./(sum(xi,2)*ones(1,18));
figure(6)
% plot(-170:10:180,sum(x3i)./max(sum(x3i)),'r',-170:10:180,sum(xbi)./max(sum(xbi)))
plot(-170:10:180,sum(x3i)./sum(sum(x3i)),'r',-170:10:180,sum(xbi)./sum(sum(xbi)))
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
figure(7)
plot(0:10:170,sum(xi)./max(sum(xi)),'r',0:10:170,sum(xci)./max(sum(xci)))
axis tight;ylim([0 1])
% cd '2 east all'

is=[35 36 1:36 1];the=-190:10:190;
figure(9)
a=sum(xb)./sum(sum(xb));b=sum(xbi)./sum(sum(xbi));
plot(the,a(is),the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
figure(10)
a=sum(x3)./sum(sum(x3));b=sum(x3i)./sum(sum(x3i));
plot(the,a(is),the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
% cd ..
save tempMotifpaperFigsData
thr=2;
ou=AngHist(allang3(find(eccs>thr))*180/pi);
% in=AngHist(allang3i(find(eccs>thr))*180/pi);
a=ou./sum(ou);%b=sum(x3i)./sum(sum(x3i));
plot(the,a(is))%,the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

% plot(-170:10:180,(xb+0.05*([0:(size(xb,1)-1)]')*(ones(1,36)))'),axis tight
% plot(-170:10:180,(xp+0.1*([0:(size(xp,1)-1)]')*(ones(1,36)))'),axis tight
% plot(0:10:170,(xci+0.05*([0:(size(xbi,1)-1)]')*(ones(1,18)))'),axis tight

function[datin,datout]=GetAllZZData
datout=[];datin=[];
dwork
cd bees/bees07/2' east all'/
cd ../2' east all'/
datin=GetZZData(0,datin);
datout=GetZZData(1,datout);
cd ../'2 west'/
datin=GetZZData(0,datin);
datout=GetZZData(1,datout);
cd ../'north 8'/
datin=GetZZData(0,datin);
datout=GetZZData(1,datout);
cd ../'west 8'/
datin=GetZZData(0,datin);
datout=GetZZData(1,datout);
cd ../'east 8'/
datin=GetZZData(0,datin);
datout=GetZZData(1,datout);
cd ..

function inoutZZ

[datin,datout]=GetAllZZData;

BeeFDirPlot(datout.so,datout.co,datout.nor*180/pi,[],5,'OUT ZZ: ',datout.o2n,20:30)
BeeFDirPlot(datin.so,datin.co,datin.nor*180/pi,[],10,'IN ZZ: ',datin.o2n,20:30)

pa=[0 100];
figure(20), hold on,
figure(21), hold on,
BeeFDirPlot(datout.so,datout.co,datout.nor*180/pi,[],1,'OUT ZZ: ',datout.o2n,20:60,pa)
BeeFDirPlot(datin.so,datin.co,datin.nor*180/pi,[],10,'IN ZZ: ',datin.o2n,20:60,pa)
figure(20), hold off,
figure(21), hold off,

BeeFDirPlot(datout.so,datout.co,datout.nor*180/pi,[],1,'OUT ZZ: ',datout.o2n,50:60,pa)
BeeFDirPlot(datin.so,datin.co,datin.nor*180/pi,[],10,'IN ZZ: ',datin.o2n,50:60,pa)


function zzrates

[datin,datout]=GetAllZZData;

ra_s=[datout.ra_s datin.ra_s];
ra_c=[datout.ra_c datin.ra_c];
ra_f=[datout.ra_f datin.ra_f];
meanrates=[datout.meanrates;datin.meanrates]
cd Ci'rcling files'\
save zigzagrates




function psiZZ

[datin,datout]=GetAllZZData;

mpsi=[datin.psi];dangs=[datin.dang];dangcs=[datin.dangc];
dang2s=[datin.dang2];dangcs=[datin.dangfb];
relf2=[AngularDifference([datout.co],[datout.o2n])];
relf5=[AngularDifference([datin.co],[datin.o2n])];
t1=[datout.relt];
t2=[datin.relt];
figure(1)
[D,xs,ys,xps,yps]=Density2D([relf2 relf5]*180/pi,[t1 t2],-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:)))
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dangs,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('Flight dir wrt zz dir')
axis equal
figure(2)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,relf5*180/pi,[-180:10:180],[-180:10:180]);
cs=contourf(x1,y,d);axis([-120 120 -120 120])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('Flight direction (deg)')
axis equal;title('Flight direction relative to nest'),colormap gray; cmap=colormap;
colormap(cmap(end:-1:1,:)),clabel(cs)
figure(3)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,-dang2s,[-180:10:180],[-180:10:180]);
[cs,h] =contourf(x1,y,d);axis([-120 120 -120 120])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('Flight direction (deg)')
axis equal;title('Flight direction relative to zigzag'),colormap gray; cmap=colormap;
colormap(cmap(end:-1:1,:)),clabel(cs)
figure(7)
psi0=find(abs(mpsi*180/pi)<=10)
[y1,x]=AngHist(dangs(psi0));
[y2,x]=AngHist(dangcs(psi0));
[y3,x]=AngHist(dang2s(psi0));
plot(x,y1/sum(y1),'b',x,y2/sum(y2),'r-x',x,y3/sum(y3),'k-o'),axis tight

mpsi=[datout.psi];dangs=[datout.dang];dangcs=[datout.dangc];
dang2s=[datout.dang2];dangcs=[datout.dangfb];
figure(4)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dangs,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')
figure(5)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dangcs,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')
figure(6)
[d,a,b,x1,y]=Density2D(mpsi*180/pi,dang2s,[-180:10:180],[-180:10:180]);
contourf(x1,y,max(d(:))-d);axis([-100 100 -100 100])
hold on;plot(0,0,'ro');hold off;xlabel('\psi');ylabel('flt dir wrt zz dir')
figure(8)
psi0=find(abs(mpsi*180/pi)<=10)
[y1,x]=AngHist(dangs(psi0));
[y2,x]=AngHist(dangcs(psi0));
[y3,x]=AngHist(dang2s(psi0));
plot(x,y1/sum(y1),'b',x,y2/sum(y2),'r-x',x,y3/sum(y3),'k-o'),axis tight

function[dat]=GetZZData(ino,dat);

if(ino) load(['processzigzagsout.mat'])
else load(['processzigzagsin.mat']);
end
if(isempty(dat))
    dat.so=sos;
    dat.co=allco;
    dat.nor=nors;
    dat.o2n=o2n;
    dat.psi=mpsi;
    dat.dang=dangs;
    dat.dangc=dangcs;
    dat.dang2=dang2s;
    dat.dangfb=dangfbs;
    dat.meanrates=meanrates;
    dat.relt=relts;
    dat.ra_s=ra_s;
    dat.ra_c=ra_c;
    dat.ra_f=ra_f;
else
    dat.so=[dat.so sos];
    dat.co=[dat.co allco];
    dat.nor=[dat.nor nors];
    dat.o2n=[dat.o2n o2n];
    dat.psi=[dat.psi mpsi];
    dat.dang=[dat.dang dangs];
    dat.dangc=[dat.dangc dangcs];
    dat.dang2=[dat.dang2 dang2s];
    dat.dangfb=[dat.dangfb dangfbs];
    dat.relt=[dat.relt relts];
    dat.meanrates=[dat.meanrates;meanrates];
    dat.ra_s=[dat.ra_s ra_s];
    dat.ra_c=[dat.ra_c ra_c];
    dat.ra_f=[dat.ra_f ra_f];
end

