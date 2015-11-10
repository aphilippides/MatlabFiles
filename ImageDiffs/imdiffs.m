function[dnew]=imdiffs(goal)
% dwork
% cd 'New\cricket pitch panoramic images'\unwrapped\
% s=dir('cricket*Centred.mat')
s=dir('*Centred.mat')

if(nargin<1) goal=round(length(s)); end;
fn=s(goal).name;
% fn='IMG_3425Centred.mat';
load(fn);
% newim=rgb2gray(frame);newim=newim(end:-1:1,:);
% [ig]=eqheightNew(newim,400);% newim;
% [ig]=eqheight(newim,500);% newim;
gsize=10;
h=fspecial('gaussian',gsize,gsize/3);

skyc=170;
newim=imresize(newim,[90,360]);
n=imresize(newimall,[90,360]);newimall=n;
[ig,sg,ig2]=eqheightSmall(newim,newimall,40,skyc);% newim;
% [ig,sg,ig2]=eqheightNew(newim,newimall,500,skyc);% newim;
% [ig2]=sg(1:400,:);%eqheightNew(newim,300);
% ig2=imfilter(ig,h,'replicate');
% % [sg]=eqheight(newim,200);
%  [sg]=removesky(ig,100);
% [ig2]=removesky(ig2,100);
il=ig;
for j=1:length(s)
    j
    oldim=newim;
    oldil=il;
    load(s(j).name);
%     [mini(j),rim,imin,mind(j)]=VisualCompass(oldim,newim,40);
    
%     newim=rgb2gray(frame);newim=newim(end:-1:1,:);
%     figure(1)
%      il=newim;
%   [il]=eqheightNew(newim,400);
%   [il]=eqheight(newim,500);

newim=imresize(newim,[90,360]);
n=imresize(newimall,[90,360]);newimall=n;
[il,sl,il2]=eqheightSmall(newim,newimall,40,skyc);% newim;


% [il,sl,il2]=eqheightNew(newim,newimall,500,skyc);
%   [mini(j),rim,imin,mind(j),dd(j,:)]=VisualCompass(ig(1:2:end,1:5:end),il(oldil(1:2:end,1:5:end)));  
%   [mini2(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(oldil,il,100);
  skylines(j,:)=il2;
%  [il2]=sl(1:400,:);%eqheightNew(newim,300);
%  il2=imfilter(il,h,'replicate');

% % [sl]=eqheight(newim,200);
% 
%  [sl]=removesky(il,100);
% [il2]=removesky(il2,100);
     
    title([int2str(j) ': ' s(j).name]);
%     figure(1)
%     imagesc(il)
%      figure(2);
%      imagesc(il2);
%     
      dnew(j)=sum(sum((il-ig).^2));
      d(j)=sum(sum((il2-ig2).^2));
     sd(j)=sum(sum((sl-sg).^2));
%      f=s(j).name;
%      rawim=il;
%      save(['NoSky/' f(1:end-17) 'NoSky.mat'],'rawim','skyline')
% save MidPoints mpts
end
% keyboard
m=medfilt1(skylines,5);
save skylines m

g=m(goal,:);
for i=1:length(s) df(i)=sum((g-m(i,:)).^2); end
is=2*[1:length(s)];
if(goal==1) 
    bs=length(s)-4:length(s);
else
    bs=1:5;
% plot(is,df(end:-1:1)/median(df(bs)),'k',is,dnew(end:-1:1)/median(dnew(bs)),'b','LineWidth',1.5)%,is,df2/median(df2(bs)),'k:x',is,sd/median(sd(bs)),'k')
end
plot(is,df/median(df(bs)),'k',is,dnew/median(dnew(bs)),'b','LineWidth',1.5)%,is,df2/median(df2(bs)),'k:x',is,sd/median(sd(bs)),'k')
xlabel('distance (m)')
ylabel('error (normalised)')
axis tight
Setbox
keyboard
plot(is,dnew/max(dnew),is,d/max(d),'r',is,sd/max(sd),'k-x',is,df/max(df),'b-o','LineWidth',1.5)
nl=floor(size(dd2,2)/2);
plot([-nl:nl],dd2(61,[nl+1:end 1:nl]))
nl=floor(size(dd,2)/2);plot([-nl:nl],dd(22,[nl+1:end 1:nl]))

for i=1:length(s) plot(m(i,:)+i*3);hold on; end;hold off;

function[il,il2,skyls]=eqheightSmall(newim,imrgb,v,skyc)
wid=size(newim,2);
% d=diff(imrgb(1:75,:,3));
d=diff(double(imrgb(1:70,:,3)));
d2=d(1:20,:);

[m,i]=max(d2);
newi=round(medfilt1(i,5));

%skyline
[m2,i2]=min(d(1:end,:));
skyl=i2;%newi,));
sms=round(medfilt1(skyl,5));
bads=find(abs(sms-skyl)>50);
skyls=skyl;
skyls(bads)=sms(bads);
skyls=medfilt1(skyls,5);
% 
newi=newi+15;
il=zeros(v,wid);
for k=1:wid
    il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
end

if(nargin<4) 
    skym=newim(max(newi):min(skyls),:);
    skyc=median(double(skym(:)));
end

skyls=max(skyls-newi,0);
il2=il;
for k=1:wid
    il2(1:skyls(k),k)=skyc;
    il2(skyls(k)+1:end,k)=0;
end
figure(1),imagesc(imrgb), hold on,
plot(1:wid,skyls+newi,'r',1:wid,newi,'r','LineWidth',2),hold off
figure(2),imagesc(il2),hold on
plot(1:wid,skyls,'k','LineWidth',2),hold off


function[il,il2,skyls]=eqheightNew(newim,imrgb,v,skyc)
wid=size(newim,2);
% d=diff(imrgb(1:75,:,3));
d=diff(double(imrgb(1:500,:,3)));
d2=d(1:75,:);

% while 1
%     [m,i]=max(d2);
%     bads=find(diff(i)>20)+1;
%     if(isempty(bads)) break;
%     else
%         for b=bads
%             d2(i(b),b) = 0;
%         end
% %         plot(d2(:,bads))
%     end
% end
[m,i]=max(d2);
newi=round(medfilt1(i,35));

%skyline
[m2,i2]=min(d(1:end,:));
skyl=i2;%newi,));
sms=round(medfilt1(skyl,25));
bads=find(abs(sms-skyl)>50);
skyls=skyl;
skyls(bads)=sms(bads);
skyls=medfilt1(skyls,25);
% 
newi=newi+15;
il=zeros(v,wid);
for k=1:wid
    il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
end

if(nargin<4) 
    skym=newim(max(newi):min(skyls),:);
    skyc=median(double(skym(:)));
end

skyls=max(skyls-newi,0);
il2=il;
for k=1:wid
    il2(1:skyls(k),k)=skyc;
    il2(skyls(k)+1:end,k)=0;
end
figure(1),imagesc(imrgb), hold on,
plot(1:wid,skyls+newi,'r',1:wid,newi,'r','LineWidth',2),hold off
figure(2),imagesc(il2),hold on
plot(1:wid,skyls,'k','LineWidth',2),hold off
% plot(1:wid,skyl-newi,'r',1:wid,skyls,'k','LineWidth',2),hold off
% figure(3),imagesc(il2)
% id=il(450:500,:);
% m=median(id(:));
% il=il(100:end,:);
% m=mean(il(:));
% il2=il-m;


function[il]=removesky(newim,v)
il=newim(v:end,:);
return
% d=diff(diff(newim));
% skyl_r=min(d);
% skyl=skyl_r;
for k=1:2760
%     ss=find(d(:,k)<v,1);
    ss=find(newim(10:end,k)<100,1);
    if(~isempty(ss)) skyl(k)=ss; 
    else
    skyl(k)=1;
    end;
end
% skyl=medfilt1(skyl,15);
il=newim;
% il2=il;
for k=1:2760
    il(1:skyl(k)-1,k)=255;
%     il2(1:skyl_r-1,k)=0;
end
%    figure(1),imagesc(newim),hold on, plot(skyl),hold off
%     figure(2),imagesc(il)   

function[il,il2]=eqheight(newim,v)
wid=size(newim,2);
d=diff(newim(1:100,:));
[m,i]=max(d);

% plot(i),hold on
newi=i;
is=find(i<29);
if(~isempty(is))
    s1=i(max(is(1)-1,1));
    s2=i(min(is(end)+1,wid));
    newi(is(1):is(end))=.5*(s1+s2);
end
figure(1),imagesc(newim), hold on,
plot(newi,'k','LineWidth',3),hold off

newi=round(medfilt1(newi,55))+10;
il=zeros(v,wid);
for k=1:wid
    il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
end
figure(2),imagesc(il) 
% id=il(450:500,:);
% m=median(id(:));
% il=il(100:end,:);
m=mean(il(:));
il2=il-m;

