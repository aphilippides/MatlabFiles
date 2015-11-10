function[dnew]=imdiffsOz(goal,Lims)

s=dir('I*RSC.mat')

if(nargin<1) goal=length(s);end;% goal=round(length(s)/2); end;
fn=s(goal).name;
load(fn);

% newim=rgb2gray(frame);

% gsize=10;
% h=fspecial('gaussian',gsize,gsize/3);



skyc=170;
if(nargin<2) Lims=1; end;%[150 350];
% [ig,sg,ig2]=eqheight(newim,frame,Lims,skyc);% newim;
% newim=adapthisteq(newim);
newim=histeq(newim);
% newimall=adapthisteq(newimall);
gall=newimall;
gim=newim;
[ig,sg,ig2]=eqheight(newim,newimall,Lims,skyc);% newim;
% [ig2]=sg(1:400,:);%eqheightNew(newim,300);
% ig2=imfilter(ig,h,'replicate');
% % [sg]=eqheight(newim,200);
%  [sg]=removesky(ig,100);
% [ig2]=removesky(ig2,100);
il=ig;
sl=sg;
for j=1:length(s)
    disp(['goal ' int2str(goal) '; im ' int2str(j)])
    oldim=newim;
    oldil=il;
    oldsl=sl;
    load(s(j).name);
%     [mini(j),rim,imin,mind(j)]=VisualCompass(oldim,newim,40);
    
%     newim=rgb2gray(frame);%newim=newim(end:-1:1,:);
%     figure(1)
%      il=newim;
%   [il]=eqheightNew(newim,400);
%   [il]=eqheight(newim,500);
%   [il,sl,il2]=eqheight(newim,frame,Lims,skyc);
% newim=adapthisteq(newim);
newim=histeq(newim);

  [il,sl,il2]=eqheight(newim,newimall,Lims,skyc);
   [mini(j),rim,imin,mind(j),dd(j,:)]=VisualCompass(ig,il);  
  [mini2(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(sg,sl);
%   [mini2(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(oldil,il);
% 
  %    [mini(j),rim,imin,mind(j),dd(j,:)]=VisualCompass(ig(1:end,1:4:end),il(1:end,1:4:end));  
%   [mini2(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(oldil,il,50);
%   [mini3(j),rim3,imin3,mind3(j),dd3(j,:)]=VisualCompass(oldil(1:end,1:4:end),il(1:end,1:4:end));
%   figure(3)  
%   nl=floor(size(dd2,2)/2);
%     plot([-nl+1:nl],dd2(j,[nl+1:end 1:nl]))
    skylines(j,:)=il2;
%  [il2]=sl(1:400,:);%eqheightNew(newim,300);
%  il2=imfilter(il,h,'replicate');

% % [sl]=eqheight(newim,200);
% 
%  [sl]=removesky(il,100);
% [il2]=removesky(il2,100);
     
%     title([int2str(j) ': ' s(j).name]);
%     figure(1)
%     imagesc(il)
%      figure(2);
%      imagesc(il2);
%     
%     figure(2),
%     rdplot(dd(j,:)), hold on,    rdplot(dd2(j,:),'r'), hold off,
      dnew(j)=sum(sum((il-ig).^2));
      d(j)=sum(sum((il2-ig2).^2));
     sd(j)=sum(sum((sl-sg).^2));
%      f=s(j).name;
%      rawim=il;
%      save(['NoSky/' f(1:end-17) 'NoSky.mat'],'rawim','skyline')
end
% keyboard
m=medfilt1(skylines,3);
outfile=['Goal' int2str(goal) 'Med' int2str(Lims) 'H.mat'];

g=m(goal,:);
g2=skylines(goal,:);
for i=1:length(s) df(i)=sum((g-m(i,:)).^2); df2(i)=sum((g2-skylines(i,:)).^2); end; 
is=1:length(s);
% clear gall gim newim newimall il sl il2 old* ig sg ig2
save(outfile)

% plot(is,df/max(df),'k',is,df2/max(df2),'k:x',is,dnew/max(dnew),'r-s')
% if(goal==1) bs=length(s)-4:length(s);
% else bs=1:5;
% end
% keyboard 
% plot(is,df2/median(df2(bs)),'k','LineWidth',1.5)
% % plot(is,df/median(df(bs)),'k',is,df2/median(df2(bs)),'k:x',is,dnew/median(dnew(bs)),'r-s',is,sd/median(sd(bs)),'b--*')
% set(gca,'FontSize',14)
% xlabel('distance (m)')
% ylabel('error (normalised)')
% axis tight
% Setbox
% figure(2)
% VisCompSkylines(skylines,goal)
% xlabel('distance (m)')
% ylabel('error (degrees)')
% axis tight
% Setbox
% [es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
% [es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
% figure(3)
% plot(is,es1,is,es2,'r')
% xlabel('distance (m)')
% ylabel('error (degrees)')
% axis tight
% Setbox
% % plot(is,dnew/max(dnew),is,d/max(d),'r',is,sd/max(sd),'k-x',is,df/max(df),'b-o')
% keyboard
% nl=floor(size(dd2,2)/2);
% plot([-nl+1:nl],dd2(2,[nl+1:end 1:nl]))
% nl=floor(size(dd,2)/2);plot([-nl:nl],dd(22,[nl+1:end 1:nl]))
% for i=1:length(s) plot(m(i,:)+i*50);hold on; end;hold off;

function rdplot(d,c)
d=d./max(d);
if(nargin<2) c='b-'; end;
[n,le]=size(d);
nl=floor(le/2);
if(mod(le,2)) 
    for i=1:n 
        plot([-nl:nl],d(i,[nl+1:end 1:nl]),c); 
    end
else
    for i=1:n
        plot([-nl:nl-1],d(i,[nl+1:end 1:nl]),c)
    end
end




function[il,il2,skyls]=eqheight(newim,imrgb,v,skyc)
wid=size(newim,2);
% d=diff(imrgb(1:75,:,3));
% newim=newim(v(1):v(2),:);
% imrgb=imrgb(v(1):v(2),:,:);
% 
% d=diff(double(imrgb(:,:,3)));
% [m2,i2]=min(d(1:end,:));
% skyl=i2;%newi,));

d=double(imrgb(:,:,3)-imrgb(:,:,2));
% d2=double(d>=0);%d(end:-1:1,:)>0;

for i=1:wid 
    t=120;
    sp=find(imrgb(:,i,3)<t,1,'first');
    while(isempty(sp)) 
        t=t+20;
        sp=find(imrgb(:,i,3)<t,1,'first');
    end
    i2(i)=find(d(sp:end,i)<=0,1,'first')+sp-1; 
end
skyl=i2;%v(2)-v(1)-i2;
%skyline
sms=round(medfilt1(skyl,25));
bads=find(abs(sms-skyl)>100);
skyls=skyl;
skyls(bads)=sms(bads);
if(v>1) skyls=medfilt1(skyls,v); end;
% 
il=double(newim);%zeros(size(newim));
% newi=newi+15;
% for k=1:wid
%     il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
% end

% if(nargin<4) 
%     skym=newim(max(newi):min(skyls),:);
%     skyc=median(double(skym(:)));
% end

% skyls=max(skyls-newi,0);
il2=il;
for k=1:wid
    il2(1:skyls(k),k)=1;%skyc;
    il2(skyls(k)+1:end,k)=0;
end
% figure(1),imagesc(imrgb), hold on,
% plot(1:wid,skyls,'r','LineWidth',2),hold off
% axis image
% figure(2),imagesc(il2),hold on
% plot(1:wid,skyls,'k','LineWidth',2),hold off


function[il,il2,skyls]=eqheightOrigIm(newim,imrgb,v,skyc)
wid=size(newim,2);
% d=diff(imrgb(1:75,:,3));
newim=newim(v(1):v(2),:);
imrgb=imrgb(v(1):v(2),:,:);

d=diff(double(imrgb(:,:,3)));
[m2,i2]=min(d(1:end,:));
skyl=i2;%newi,));

% d=-double(imrgb(:,:,3)-imrgb(:,:,2));
% d2=double(d>=0);%d(end:-1:1,:)>0;
% for i=1:wid i2(i)=find(d2(:,i),1,'first'); end
% skyl=i2;%v(2)-v(1)-i2;
%skyline
sms=round(medfilt1(skyl,25));
bads=find(abs(sms-skyl)>50);
skyls=skyl;
skyls(bads)=sms(bads);
skyls=medfilt1(skyls,25);
% 
il=newim;%zeros(size(newim));
% newi=newi+15;
% for k=1:wid
%     il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
% end

% if(nargin<4) 
%     skym=newim(max(newi):min(skyls),:);
%     skyc=median(double(skym(:)));
% end

% skyls=max(skyls-newi,0);
il2=il;
for k=1:wid
    il2(1:skyls(k),k)=1;%skyc;
    il2(skyls(k)+1:end,k)=0;
end
figure(1),imagesc(imrgb), hold on,
plot(1:wid,skyls,'r','LineWidth',2),hold off
axis image
% figure(2),imagesc(il2),hold on
% plot(1:wid,skyls,'k','LineWidth',2),hold off


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