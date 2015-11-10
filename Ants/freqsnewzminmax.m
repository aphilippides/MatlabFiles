clear all;
cd C:\Experiment\RenamedTests\bee55\
filename=input('Enter filename to get the position of LM from: ','s');
track= DLMREAD((filename),'\t',1,0);
xlm1=median(track(:,1))
ylm1=median(track(:,2))

n=100;d=zeros(1,n+1);al=zeros(1,n+1);dcrawl=zeros(1,n+1);alcrawl=zeros(1,n+1);dtouch=zeros(1,n+1);altouch=zeros(1,n+1);
xmin=0; ymin=0;
xmax=1;
ymax=1;
xlm=round((xlm1-xmin)*n/(xmax));
ylm=round((ylm1-ymin)*n/(ymax));

P=input('Enter n=LM North or s=LM South or e=LM East or w=LM West - the correct position:  ','s');
if P=='n' xcorr=round((xlm1-0.15-xmin)*n/xmax); ycorr=ylm;
elseif P=='s' xcorr=round((xlm1+0.15-xmin)*n/xmax); ycorr=ylm;
elseif P=='e' xcorr=round((xlm1+0.15-xmin)*n/xmax); ycorr=round((ylm1-0.1-ymin)*n/ymax);
elseif P=='w' xcorr=round((xlm1-0.15-xmin)*n/xmax); ycorr=round((ylm1+0.1-ymin)*n/ymax);        
end;

filename = input('Enter filename to process: ','s');
tempname=filename;
zmin = 0.88;%input('Enter zmin: ');
zmax = 1.3;%input('Enter zmax:');
zcr=0.91;
k=zeros(n,n+1);kcrawl=zeros(n,n+1);kflight=zeros(n,n+1);ktouch=zeros(n,n+1);

fignum=3;

while filename(1)=='t'
track= DLMREAD((filename),'\t',1,0);
temp=[]; temp1=[];

inds=find(~isnan(track(:,1)));
x=track(inds,1);
y=track(inds,2);
z=track(inds,3);
t=track(inds,7);
%deltat=diff(t,1);


hold on
figure(1), plot(x,y)
xlabel('x')
ylabel('y')
title(strcat('distribution__bf__from__',tempname))
print('-djpeg',  strcat('distribution_bf_from_',tempname(1:5),tempname(8:13),'.jpg'))

i=1;
while i<=length(x)
    if ((x(i)<xmin) | (x(i)>xmax) | (y(i)<ymin) | (y(i)>ymax) | (z(i)<zmin) | (z(i)>zmax))
        x(i)=[];y(i)=[];z(i)=[];t(i)=[];
    else i=i+1;
    end; 
end;

vmax=1.5; k2=30;
[y,x,z,t]=checkcoords(y,x,z,t,vmax,k2);
[x,y,z,t]=checkcoords(x,y,z,t,vmax,k2);
[z,y,x,t]=checkcoords(z,y,x,t,vmax,k2);

figure(2),hold on
plot(x,y)
xlabel('x')
ylabel('y')
title(strcat('distribution__af__from__',tempname))
print('-djpeg',  strcat('distribution_af_from_',tempname(1:5),tempname(8:13),'.jpg'))
xyzt=[x y z t];
save(strcat('coords_af_from_',filename),'xyzt','-ASCII','-tabs');

trackcoord=[x y z];
deltat=diff(t,1);
v=sqrt(sum((diff(trackcoord,1)).^2,2))./deltat;
numav=10;

for i=1:1:floor(numav/2)
    vnew(i)=mean(v(1:2*i-1));
    znew(i)=mean(z(1:2*i-1));
end;    

for i=floor(numav/2)+1:1:length(v)-floor(numav/2)
    vnew(i)=mean(v(i-floor(numav/2):i+floor(numav/2)));
end;

for i=length(v)-floor(numav/2)+1:1:length(v)
    vnew(i)=mean(v(i:length(v)));
end; 

for i=floor(numav/2)+1:1:length(z)-floor(numav/2)
    znew(i)=mean(z(i-floor(numav/2):i+floor(numav/2)));
end;

for i=length(z)-floor(numav/2)+1:1:length(z)
    znew(i)=mean(z(i:length(z)));
end;

time=t(2:length(t));
signal=[(vnew.*znew(2:length(znew)))' time];

touchthresh=0.1; timespan=0.5;

jc=2;xcrawl=[];ycrawl=[];jt=1;xtouch=[];ytouch=[];

for i=2:1:length(signal)
    
    if signal(i,1)<touchthresh
        j=1; flag=0;
        while (signal(i+j,2)-signal(i,2))<timespan
            if signal(i+j,1)>touchthresh
                flag=1;
            end;
          j=j+1;
        end;
    end;
    
    if flag==0            
        xcrawl(jc)=x(i);ycrawl(jc)=y(i);zcrawl(jc)=z(i);tcrawl(jc)=t(i);
        if tcrawl(jc-1)<t(i-1)
            xtouch(jt)=x(i);ytouch(jt)=y(i);ztouch(jt)=z(i);ttouch(jt)=t(i);
            jt=jt+1;
        end;    
        jc=jc+1;i=i+1; 
    else i=i+1;
    end;
end;    
k1crawl=[];
for i=1:1:n
      inds=find(xcrawl(:)>=((xmax-xmin)*(i-1)/n)& xcrawl(:)<((xmax-xmin)*(i)/n));
      cents=ymin:(ymax-ymin)/n:ymax;
    k1crawl(i,:)=hist(ycrawl(inds),cents);
     end;
kcrawl=kcrawl+k1crawl;

distcrawl=sqrt((xcrawl-xcorr*xmax/n-xmin).^2+(ycrawl-ycorr*ymax/n-ymin).^2);
cents=0:1/n:1;
dcrawl=dcrawl+hist(distcrawl,cents);

alphacrawl=[];

for i=1:1:length(xcrawl(:))
    if ycrawl(i)>ylm1
        alphacrawl(i)=atan((xcrawl(i)-xlm1)/(ycrawl(i)-ylm1));
    elseif   ycrawl(i)<ylm1
        alphacrawl(i)=atan((xcrawl(i)-xlm1)/(ycrawl(i)-ylm1))+pi;
    elseif (ycrawl(i)==ylm1)&(xcrawl(i)>=xlm1)    alphacrawl(i)=pi/2;
    elseif (ycrawl(i)==ylm1)&(xcrawl(i)<xlm1)    alphacrawl(i)=-pi/2;
    
end; 
end;

k1touch=[];
for i=1:1:n
      inds=find(xtouch(:)>=((xmax-xmin)*(i-1)/n)& xtouch(:)<((xmax-xmin)*(i)/n));
      cents=ymin:(ymax-ymin)/n:ymax;
    k1touch(i,:)=hist(ytouch(inds),cents);
     end;
ktouch=ktouch+k1touch;

disttouch=sqrt((xtouch-xcorr*xmax/n-xmin).^2+(ytouch-ycorr*ymax/n-ymin).^2);
cents=0:1/n:1;
dtouch=dtouch+hist(disttouch,cents);

alphatouch=[];

for i=1:1:length(xtouch(:))
    if ytouch(i)>ylm1
        alphatouch(i)=atan((xtouch(i)-xlm1)/(ytouch(i)-ylm1));
    elseif   ytouch(i)<ylm1
        alphatouch(i)=atan((xtouch(i)-xlm1)/(ytouch(i)-ylm1))+pi;
    elseif (ytouch(i)==ylm1)&(xtouch(i)>=xlm1)   alphatouch(i)=pi/2;
    elseif (ytouch(i)==ylm1)&(xtouch(i)<xlm1)    alphatouch(i)=-pi/2;
    
end; 
end;

% for i=1:1:length(xtouch(:))
%     if ytouch(i)>ycorr*ymax/n+ymin
%         alphatouch(i)=atan((xtouch(i)-xcorr*xmax/n-xmin)/(ytouch(i)-ycorr*ymax/n-ymin));
%     elseif   ytouch(i)<ycorr*ymax/n+ymin
%         alphatouch(i)=atan((xtouch(i)-xcorr*xmax/n-xmin)/(ytouch(i)-ycorr*ymax/n-ymin))+pi;
%     elseif (ytouch(i)==ycorr*ymax/n+ymin)&(xtouch(i)>=xcorr*xmax/n+xmin)    alphatouch(i)=pi/2;
%     elseif (ytouch(i)==ycorr*ymax/n+ymin)&(xtouch(i)<xcorr*xmax/n+xmin)    alphatouch(i)=-pi/2;
%     
% end; 
% end;

cents=-pi/2:2*pi/n:3*pi/2;
alcrawl=alcrawl+hist(alphacrawl,cents);

cents=-pi/2:2*pi/n:3*pi/2;
altouch=altouch+hist(alphatouch,cents);

for i=1:1:n
      inds=find(x(:)>=((xmax-xmin)*(i-1)/n)& x(:)<((xmax-xmin)*(i)/n));
      cents=ymin:(ymax-ymin)/n:ymax;
    k1(i,:)=hist(y(inds),cents);
     end;
k=k+k1;


cm=colormap('gray');
figure(fignum), pcolor(k1)
set(pcolor(k1),'EdgeColor','white')
colormap(flipud(cm))
xlabel('South')
ylabel('East')
colorbar 
title(strcat('distribution__from__',filename))
print('-djpeg',  strcat('distribution_from_',filename,'.jpg'))

fignum=fignum+1;

dist=sqrt((x-xlm1).^2+(y-ylm1).^2);
cents=0:1/n:1;
d=d+hist(dist,cents);

for i=1:1:length(x(:))
    if y(i)>ylm1
        alpha(i)=atan((x(i)-xlm1)/(y(i)-ylm1));
    elseif   y(i)<ylm1
        alpha(i)=atan((x(i)-xlm1)/(y(i)-ylm1))+pi;
    elseif (y(i)==ylm1)&(x(i)>=xlm1)    alpha(i)=pi/2;
    elseif (y(i)==ylm1)&(x(i)<xlm1)    alpha(i)=-pi/2;
    
end; 
end;

cents=-pi/2:2*pi/n:3*pi/2;
al=al+hist(alpha,cents);

% i=1;jc=1;jf=1;xcrawl=[];ycrawl=[];xflight=[];yflight=[];
% while i<=length(z)
%     if (z(i)<zcr)
%         xcrawl(jc)=x(i);ycrawl(jc)=y(i);zcrawl(jc)=z(i);tcrawl(jc)=t(i);jc=jc+1;i=i+1;
%     else xflight(jf)=x(i);yflight(jf)=y(i);zflight(jf)=z(i);tflight(jf)=t(i);jf=jf+1;i=i+1;
%     end; 
% end;
% k1crawl=[];
% for i=1:1:n
%       inds=find(xcrawl(:)>=((xmax-xmin)*(i-1)/n)& xcrawl(:)<((xmax-xmin)*(i)/n));
%       cents=ymin:(ymax-ymin)/n:ymax;
%     k1crawl(i,:)=hist(ycrawl(inds),cents);
%      end;
% kcrawl=kcrawl+k1crawl;
% 
% k1flight=[];
% for i=1:1:n
%       inds=find(xflight(:)>=((xmax-xmin)*(i-1)/n)& xflight(:)<((xmax-xmin)*(i)/n));
%       cents=ymin:(ymax-ymin)/n:ymax;
%     k1flight(i,:)=hist(yflight(inds),cents);
%      end;
% kflight=kflight+k1flight;


filename = input('Enter filename to process:  ','s');
end;

val=max(max(k));
valcrawl=max(max(kcrawl));%valflight=max(max(kflight));
valtouch=max(max(ktouch));

if xlm>0 & xlm<n & ylm>0 & ylm<n
k(xlm,ylm)=k(xlm,ylm)+val;
ktouch(xlm,ylm)=ktouch(xlm,ylm)+valtouch;
% kflight(xlm,ylm)=kflight(xlm,ylm)+valflight;
kcrawl(xlm,ylm)=kcrawl(xlm,ylm)+valcrawl;
ktouch(xcorr,ycorr)=ktouch(xcorr,ycorr)+valtouch;
end;


cm=colormap('gray');
%pcolor(log(k+1))
figure(fignum), pcolor(k)
%shading flat
set(pcolor(k),'EdgeColor','white')
colormap(flipud(cm))
xlabel('South')
ylabel('East')
colorbar 
title(strcat('distribution__total__',tempname))
print('-djpeg',  strcat('distribution_total_',tempname(1:5),tempname(8:13),'.jpg'))

% cm=colormap('gray');
% figure(fignum+1), pcolor(kcrawl)
% set(pcolor(kcrawl),'EdgeColor','white')
% colormap(flipud(cm))
% xlabel('South')
% ylabel('East')
% colorbar 
% title(strcat('distribution__crawl__',tempname))
% print('-djpeg',  strcat('distribution_crawl_',tempname(1:5),tempname(8:13),'.jpg'))

% cm=colormap('gray');
% figure(fignum+2), pcolor(kflight)
% set(pcolor(kflight),'EdgeColor','white')
% colormap(flipud(cm))
% xlabel('South')
% ylabel('East')
% colorbar 
% title(strcat('distribution__flight__',tempname))
% print('-djpeg',  strcat('distribution_flight_',tempname(1:5),tempname(8:13),'.jpg'))


l=0:1/n:1;
figure(fignum+3),plot(l,d)
xlabel('m')
title(strcat('distance__',tempname))
print('-djpeg',  strcat('distance_',tempname(1:5),tempname(8:13),'.jpg'))

l=-90:360/n:270;
figure(fignum+4),plot(l,al)
xlabel('degrees')
title(strcat('angle__',tempname))
print('-djpeg',  strcat('angle_',tempname(1:5),tempname(8:13),'.jpg'))

cm=colormap('gray');
figure(fignum+5), pcolor(kcrawl)
set(pcolor(kcrawl),'EdgeColor','white')
colormap(flipud(cm))
xlabel('South')
ylabel('East')
colorbar 
title(strcat('distribution__crawl__',tempname))
print('-djpeg',  strcat('distribution_crawl_',tempname(1:5),tempname(8:13),'.jpg'))

l=0:1/n:1;
figure(fignum+6),plot(l,dcrawl)
xlabel('m')
title(strcat('distance__crawl__',tempname))
print('-djpeg',  strcat('distance_crawl_',tempname(1:5),tempname(8:13),'.jpg'))

l=-90:360/n:270;
figure(fignum+7),plot(l,alcrawl)
xlabel('degrees')
title(strcat('angle__crawl__',tempname))
print('-djpeg',  strcat('angle_crawl_',tempname(1:5),tempname(8:13),'.jpg'))

cm=colormap('gray');
figure(fignum+8), pcolor(ktouch)
set(pcolor(ktouch),'EdgeColor','white')
colormap(flipud(cm))
xlabel('South')
ylabel('East')
colorbar 
title(strcat('distribution__touch__',tempname))
print('-djpeg',  strcat('distribution_touch_',tempname(1:5),tempname(8:13),'.jpg'))

l=0:1/n:1;
figure(fignum+9),plot(l,dtouch)
xlabel('m')
title(strcat('distance__touch__',tempname))
print('-djpeg',  strcat('distance_touch_',tempname(1:5),tempname(8:13),'.jpg'))

l=-90:360/n:270;
figure(fignum+10),plot(l,altouch)
xlabel('degrees')
title(strcat('angle__touch__',tempname))
print('-djpeg',  strcat('angle_touch_',tempname(1:5),tempname(8:13),'.jpg'))


save(strcat('distribution_from_',tempname(1:5),tempname(8:13),'.dat'),'k','-ASCII','-tabs');
save(strcat('distance_from_',tempname(1:5),tempname(8:13),'.dat'),'d','-ASCII','-tabs');
save(strcat('angle_from_',tempname(1:5),tempname(8:13),'.dat'),'al','-ASCII','-tabs');