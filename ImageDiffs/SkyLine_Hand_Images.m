function SkyLine_Hand_Images(s)

if(nargin<1) 
    s=dir('I*RSC.mat')
end
if(ischar(s))
    s=dir(s)
end
skylines=zeros(length(s),360);
for j=1:length(s)
    j
    fn=s(j).name;
    % if it's a mat file, load the variables,
    % if it's an image, load it and convert to rgb
    if(isequal(fn(end-2:end),'mat'))%(~exist('unw_bw','var'))
        load(fn);
        newim=unw_bw;
        newimall=uint8(unw_im);
        fnew=[fn(1:end-7) '_Binary.mat'];
    else
        newimall=uint8(imread(fn));
        newim=rgb2gray(newimall);
        fnew=[fn(1:end-4) '_Binary.mat'];
    end
    
    if(~isfile(fnew))
        %         [newim,newimall,skyl]=eqheight(newim,newimall,170);% newim;
        %         skylines(j,:)=skyl;
        %         save skylinesHand.mat skylines
        if(exist('t')) 
            [bina,t]=binaryimage(newim,newimall,t);
        else
            [bina,t]=binaryimage(newim,newimall);
        end
        save(fnew,'newim','newimall','bina','t')
    else
%         load(fnew);
%         bina(end,:)=1;
%         bina=bwfill(bina,'holes');
%         if(j==1) 
%             binag=bina;
%             ig=double(newim).*double(bina)+170*double(~bina);
%         end
%             il=double(newim).*double(bina)+170*double(~bina);
%         
%            [mini(j),rim,imin,mind(j),dd(j,:)]=VisualCompass(ig,il);  
%   [mini2(j),rim2,imin2,mind2(j),dd2(j,:)]=VisualCompass(binag,bina);
% 
%         wid=size(bina,2)
%         for i=1:wid
% %             skylines(j,i)=double(find([0;bina(:,i)]==0,1,'last'));
%             skylines(j,i)=double(find([bina(:,i)]==1,1,'first'));
%         end
%         imagesc(newimall),hold on;
%         plot(skylines(j,:),'r')
%         axis image
%         hold off
%               d(j)=sum(sum((il-ig).^2));
%       db(j)=sum(sum((bina-binag).^2));
%      sd(j)=sum((skylines(j,:)-skylines(1,:)).^2);

    end
end
plot(1:length(s),d./median(d),1:length(s),db./median(db),'r',1:length(s),sd./median(sd),'k- .')
goal=1;
[rca,r,sk,bi]=RotCA(skylines,goal,mini,mini2);
figure(2),
plot(1:length(s),r,1:length(s),bi,'r',1:length(s),sk,'k- .')
title(['# good = ' int2str(rca)])
save resultstemp
keyboard

function[bina,t]=binaryimage(newim,imrgb,t)

v=1;
wid=size(imrgb,2);
d=(imrgb(:,:,3));

% for i=1:wid
%     sp=find(imrgb(:,i,3)<t,1,'first');
%     while(isempty(sp))
%         t=t+20;
%         sp=find(imrgb(:,i,3)<t,1,'first');
%     end
%     i2(i)=find(d(sp:end,i)<=0,1,'first')+sp-1;
% end
% skyl=i2+1;
if(nargin<3) t=round(graythresh(d)*255); end;
while 1

    subplot(2,1,1),imagesc(imrgb),

    %     for i=1:wid
    %         sp=find(imrgb(:,i,2)>t,1,'first');
    %         tm=t;
    %         while(isempty(sp))
    %             tm=tm-1;
    %             sp=find(imrgb(:,i,2)>tm,1,'first');
    %         end
    %         sl(i)=sp;
    %     end
    %     sl=sl+2;
    % hold on, plot(sl,'r','LineWidth',2),hold off
    bb=double(d<t);
    bb=bwareaopen(bb,4);
    bina=double(d<t);
    nosky=double(newim).*bina;
    subplot(2,1,2),imagesc(nosky),
    axis image
    title(['threshold = ' int2str(t) '; up to increase, down to decrease; k keyboard; c to end'])
    [x,y,b]=ginput(1);
    if(isequal(b,'c')) 
        break;
    elseif(isequal(b,'k')) 
        keyboard;
%         [tempb,tempd]=RegionCol(bina,1,d);
%   d=tempd;bina=tempb;
    elseif(b==30) 
        t=t+1;
    elseif(b==31) 
        t=t-1;
    end
end

function[newd,newb]=RegionCol(d,c,b)

figure(2)
imagesc(d);
newd=d;newb=b;
[x,y]=ginput;
x=round([x;x(1)]);
y=round([y;y(1)]);
gs=diff(y)./diff(x);
ps=[];
for i=1:(length(x)-1)
    if(x(i)==x(i+1)) ps=[ps;x(i:i+1) y(i:i+1)];
    else
       if(x(i)<x(i+1)) xs=[0:x(i+1)-x(i)]';
       else xs=[0:-1:x(i+1)-x(i)]';
       end
       ys=round(gs(i)*xs);
       ps=[ps;xs+x(i) ys+y(i)];
    end
end

[h,w]=size(d);
x1=max(1,min(x));
x2=min(w,max(x));
for xp=x1:x2
    is=find(ps(:,1)==xp);
    ymin=max(1,min(ps(is,2)));
    ymax=min(w,max(ps(is,2)));
    newd(ymin:ymax,xp)=c;
    newb(ymin:ymax,xp)=mod(c+1,2)*255;
end
imagesc(newd)

    


function[rca,es1,ys,es2]=RotCA(skylines,goal,mini,mini2,Tol)
if(nargin<5) Tol=45; end;

[ys,is]=VisCompSkylines(skylines,goal);
s=find(abs(ys)<=Tol);
[es1,ns]=min([mini-1;361-mini]);ms=find(ns==2);es1(ms)=es1(ms)*-1;
r=find(abs(es1)<=Tol);
[es2,ns]=min([mini2-1;361-mini2]);ms=find(ns==2);es2(ms)=es2(ms)*-1;
o=find(abs(es2)<=Tol);
rca=[length(r) length(s) length(o)];

function[il,il2,skyls]=eqheight(newim,imrgb,skyc)

v=1;
wid=size(newim,2);
d=double(imrgb(:,:,3)-imrgb(:,:,2));

for i=1:wid
    t=120;
    sp=find(imrgb(:,i,3)<t,1,'first');
    while(isempty(sp))
        t=t+20;
        sp=find(imrgb(:,i,3)<t,1,'first');
    end
    i2(i)=find(d(sp:end,i)<=0,1,'first')+sp-1;
end
skyl=i2+1;%v(2)-v(1)-i2;
%skyline
sms=round(medfilt1(skyl,25));
bads=find(abs(sms-skyl)>100);
skyls=skyl;
skyls(bads)=sms(bads);
if(v>1) skyls=medfilt1(skyls,v); end;
%

[skyl,t]=AdjustThreshold(imrgb);
skyls=AdjustSkyl(skyl,imrgb,v)

if(nargin<3)
    skym=newim(1:min(skyls),:);
    skyc=median(double(skym(:)));
end

il=double(newim);
il2=il;
for k=1:wid il(1:skyls(k),k)=skyc; end

for k=1:wid
    il2(1:skyls(k),k)=1;%skyc;
    il2(skyls(k)+1:end,k)=0;
end
figure(1),imagesc(imrgb), hold on,
plot(1:wid,skyls,'r','LineWidth',2),hold off
axis image
figure(2),imagesc(il2),hold on
plot(1:wid,skyls,'k','LineWidth',2),hold off


function[sl,t]=AdjustThreshold(imrgb,t)

v=1;
wid=size(imrgb,2);
d=double(imrgb(:,:,3)-imrgb(:,:,2));

% for i=1:wid
%     sp=find(imrgb(:,i,3)<t,1,'first');
%     while(isempty(sp))
%         t=t+20;
%         sp=find(imrgb(:,i,3)<t,1,'first');
%     end
%     i2(i)=find(d(sp:end,i)<=0,1,'first')+sp-1;
% end
% skyl=i2+1;
if(nargin<2) t=max(max((imrgb(:,:,2)))); end;
while 1
    for i=1:wid
        sp=find(imrgb(:,i,2)>t,1,'first');
        tm=t;
        while(isempty(sp))
            tm=tm-1;
            sp=find(imrgb(:,i,2)>tm,1,'first');
        end
        sl(i)=sp;
    end
    sl=sl+2;
    figure(1),imagesc(imrgb), hold on,
    plot(sl,'r','LineWidth',2),hold off
    axis image
    title(['threshold = ' int2str(t) '; up to increase, down to decrease; # to set; c to end'])
    [x,y,b]=ginput(1);
    if(isequal(b,'c')) break;
    elseif(b==30) t=t+1;
    elseif(b==31) t=t-1;
    end
end

function[sl]=AdjustSkyl(sl,imrgb,v)
w=size(imrgb,2);
while 1
    figure(1),imagesc(imrgb), hold on,
    plot(sl,'r','LineWidth',2),hold off
    axis image
    title('c to end or click 2 points and sky will be joined linearly')
    [x,y,b]=ginput(2);
    if(isequal(char(b(1)),'c')) break;
    elseif(length(x)==2)
        x=max([1;1],round(x));
        x=min([w;w],round(x));
        y=round(y);
        a1=y(1);% newi(x(1));
        a2=y(2);% newi(x(2));
        sl(x(1):x(2))=round(a1+(a2-a1)/(x(2)-x(1))*[0:(x(2)-x(1))]);
        if(v>1) sl=round(medfilt1(sl,v)); end
    end
end