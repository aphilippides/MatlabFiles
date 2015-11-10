allang3=[];x3=[];x3i=[];
allang=[];x=[];xi=[];
eccs=[];
th=3;

% load straight_1north08_outData
% [ang3,ang,e]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
% x3=[x3;AngHist(ang3*180/pi)]; 
% x=[x;hist(ang*180/pi,0:10:180)];

% cd ../../bees07/2' east all'/
load zig_zag_2east_outData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load zigzag_2west_outData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load north8_2007_zigzag_outData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load west8_zigzag_outData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3=[x3;AngHist(ang3(find(e>th))*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load zigzag_east8_outData
[ang3,ang,e]=ProcessZigZagss(fltsec)
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
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load zigzag_2west_inData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load north8_2007_zigzag_inData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load west8_zigzag_inData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load zigzag_east8_inData
[ang3,ang,e]=ProcessZigZagss(fltsec)
allang3=[allang3 ang3]; allang=[allang ang];eccs=[eccs e];
x3i=[x3i;AngHist(ang3(find(e>th))*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];


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
cd ../'2 east all'

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
cd ..
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
