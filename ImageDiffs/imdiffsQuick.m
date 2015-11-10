function[dnew]=imdiffs
% dwork
% cd 'New\cricket pitch panoramic images'\unwrapped\
% s=dir('cricket*Centred.mat')
s=dir('*.jpg')

% fn='cricket_pitch_225-sphereCentred.mat';
fn='cricket_pitch_409-sphere.jpg';
% fn='IMG_3425Centred.mat';
i=imread(fn);
i=imresize(i,[700,2500]);
newim=rgb2gray(i);
% newim=rgb2gray(frame);newim=newim(end:-1:1,:);
[ig]=eqheight(newim,400);% newim;
[ig2]=ig(1:300,:);%eqheightNew(newim,300);
% % [sg]=eqheight(newim,200);
 [sg]=removesky(ig,100);
% [ig2]=removesky(ig2,100);
for j=1:length(s)
    j
    load(s(j).name);
    i=imread(s(j).name);
    i=imresize(i,[700,2500]);
    newim=rgb2gray(i);

%     newim=rgb2gray(frame);newim=newim(end:-1:1,:);
%     figure(1)
%      il=newim;
  [il]=eqheight(newim,400);
 [il2]=il(1:300,:);%eqheightNew(newim,300);
% % [sl]=eqheight(newim,200);
% 
 [sl]=removesky(il,100);
% [il2]=removesky(il2,100);
     
    title(s(j).name);
% imagesc(sl)
%      figure(2);
%      imagesc(il);
%     
      dnew(j)=sum(sum((il-ig).^2));
      d(j)=sum(sum((il2-ig2).^2));
     sd(j)=sum(sum((sl-sg).^2));
% f=s(j).name;    
% save([f(1:end-4) 'Centred.mat'],'newim')
% save MidPoints mpts
end
is=1:length(s);
plot(is,dnew/max(dnew),is,d/max(d),'r',is,sd/max(sd),'k-x')
keyboard

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
newi=i;
is=find(i<29);
if(~isempty(is))
    s1=i(max(is(1)-1,1));
    s2=i(min(is(end)+1,wid));
    newi(is(1):is(end))=.5*(s1+s2);
end
newi=round(medfilt1(newi,55))+10;
figure(1),imagesc(newim), hold on,
plot(newi,'k','LineWidth',3),hold off
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

function[il,il2]=eqheightNew(newim,v)
wid=size(newim,2);
level=graythresh(newim(:,:,3));
mask=im2bw(newim(:,:,3),level);
% d=diff(newim(1:100,:));
% [m,i]=max(d);
for k=1:wid
    i(k)=find(mask(:,k),1);
end
figure(2)
imagesc(mask)
hold on
plot(i)
newi=medfilt1(i,25);
plot(newi,'r')
hold off
% il=rgb2gray(newim).*uint8(-1*mask+1);
% il=il(1:v,:);
% % if(~isempty(is))
% %     s1=i(is(1)-1);
% %     s2=i(is(end)+1);
% %     newi(is(1):is(end))=.5*(s1+s2);
% % end
% newi=round(medfilt1(newi,55));
% % plot(i),
% plot(newi),
% hold off
% 
newi=newi+10;
grayim=rgb2gray(newim);
il=zeros(v,wid);
for k=1:wid
    il(1:v,k)=newim(newi(k):newi(k)+(v-1),k);
end
% % id=il(450:500,:);
% % m=median(id(:));
% % il=il(100:end,:);
% m=mean(il(:));
% il2=il-m;
figure(1)
imagesc(il)


