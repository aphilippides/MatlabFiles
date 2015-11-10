function VardyTest(n)
dwork
cd ../Current/Linc/WithoutWalls
s=dir('*.bmp');
sn=30%floor(length(s)/2);
fn=s(sn).name;
load([fn(1:end-3) 'mat'])
snap=SubSampleMean(unw(end:-1:1,:),n);
hor=54.5/n;
[X,Y]=meshgrid(1:size(snap,2),1:size(snap,1));
for i=1:(length(s))
    i
    fn=s(i).name;
    load([fn(1:end-3) 'mat']);
    ss=SubSampleMean(unw(end:-1:1,:),n);
%     imagesc(ss)
%     hold on,plot([1 size(snap,2)],[hor hor]),hold off
    [dx,dy]=gradient(ss);
    d=snap-ss;
    [u,v,t,x,y,th] = Moller(X,Y-hor,d,dx,dy);
    % [u,v,t] = Vardy1(X,Y-hor,d,dx,-dy);
    headM(i) = cart2pol(mean(mean(u)), mean(mean(v)));
    headV(i) = cart2pol(mean(mean(x)), mean(mean(y)));
    angM(i) = MeanAngle(cart2pol(u,v));
    angV(i) = MeanAngle(cart2pol(x,y));
%     figure(1)
%     imagesc(ss-snap);
%     figure(2)
%     quiver(X,Y,u,v)
    absdiff(i)=sqrt(sum(sum(d.^2)));
end
figure(1)
i=[1:(length(s))]-sn;
plot(i,absdiff/max(absdiff))
hold on
figure(2)
plot(i,AngleWithoutFlip(headM)*180/pi,'b- .',i,AngleWithoutFlip(headV)*180/pi,'r- .')
save(['resultsSn' int2str(sn) '_' int2str(n) '.mat'],'absdiff','headV','headM','angM','angV');

function[x,y,t,xv,yv,tv] = Moller(X,Y,d,dx,dy)
X=X*(2*pi/size(X,2));
% Y=0.4*pi*(size(X,1)-Y)/size(X,1);
Y=Y/max(max(Y));
sinB=sin(X);
cosB=cos(X);
secG=sec(Y);
sinG=sin(Y);
isecG=sec(Y).^-1;
isinG=sin(Y).^-1;
i=find(isinf(isinG(:,1)));
isinG(i,:)=0;
% figure(1)
% x1=secG.*sinB;
% y1=sinG.*cosB;
% quiver(X,Y,x1,y1)
% figure(2)
% x1=-secG.*cosB;
% y1=sinG.*sinB;
% quiver(X,Y,x1,y1)

x=d.*(sinB.*secG.*dx + cosB.*sinG.*dy);
y=d.*(-cosB.*secG.*dx + sinB.*sinG.*dy);
[t,r]=cart2pol(x,y);

xv=d.*(sinB.*isecG.*dx + cosB.*isinG.*dy);
yv=d.*(-cosB.*isecG.*dx + sinB.*isinG.*dy);
[tv,r]=cart2pol(xv,yv);

function[x,y,t] = Vardy1(X,Y,d,dx,dy)
u=sign(d).*dx;
v=sign(d).*dy;
l=sqrt(u.^2+v.^2);
u=u./l;
v=v./l;
u(isnan(u))=0;
v(isnan(v))=0;

% NB in the formula of Vardy, this is bit is -ve but cos image
% coordinates are going down the screen, the -ve cancels out
v=sign(Y).*v;
[t,r]=cart2pol(u,v);
X=X*(2*pi/size(X,2));
x=cos(X).*u-sin(X).*v;
y=sin(X).*u+cos(X).*v;
[t,r]=cart2pol(x,y);