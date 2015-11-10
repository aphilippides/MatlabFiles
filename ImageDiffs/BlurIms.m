function BlurIms(s,RS)

if(nargin<1) 
    s=dir('*.jpg');
    s=dir('*RSC.mat');
%     s=dir('*Binary.mat');
% s=dir('*Centred.mat')
end;

% RS=GetRS(s);
% load MidPoints

if(exist('RS'))
    rsf=1;
    RS=RS(1:2);
else rsf=0;
end;

j=1;
len=length(s);
t=-1;
while(j<=length(s))
    j;
    fn=s(j).name;
    %     i=imread(fn);
    load(fn);
    im=newimall;
    [bina,newim,newimall,t]=BlurIm(newim,newimall,t);
    %frame;
    %     il=rgb2gray(im);
    %     %     il=frame(end:-1:1,:,:);
    %     %     RS=[748,2795];
    %     if(rsf)
    %         il=imresize(il,RS);
    %         im=imresize(im,RS);
    %     end
    bina(end,:)=1;
    bina=double(bwfill(bina,'holes'));
    for i=1:size(bina,2)
        skyl_lo(i)=double(find([0;bina(:,i)]==0,1,'last'));
        skyl_hi(i)=double(find([bina(:,i)]==1,1,'first'));
    end
    fnew=[fn(1:end-8) '_BlurBinary.mat'];
%     if(~isfile(fnew))
        save(fnew,'newim','newimall','bina','t')

    imagesc(newimall);
    axis image;
    hold on
    wi=1:length(skyl_hi);
    plot(wi,skyl_hi,'r',wi,skyl_lo,'c')
    hold off
    title([int2str(j) '/' int2str(len) '; ' fn])
%     x=input('Press c to end, u to go back, return continue','s');
%     %     colormap(gray)
%     if(isempty(x))
%         j=mod(j+1,len);
%         if(j==0) j=len; end;
% %         break;
%     elseif(isequal(x,'u'))
%         j=mod(j-1,len);
%         if(j==0) j=len; end;
% %         break;
%     elseif(isequal(x,'c')) break;
%     end
j=j+1;
% j=j+5;
end

function[bina,blim,blima,t]=BlurIm(im,imall,t,rfact)%,gwid,ex)

% if(nargin<4) gwid=1.5; end;
% if(nargin<5) ex=3; end;
if(nargin<4) rfact=4; end;

% h=fspecial('gaussian',(2*ex+1),gwid);
% 
ex=rfact;
en=size(im,2);
cs=[(en-ex+1):en 1:en 1:ex];
bigim=im(:,cs);  
bigall=imall(:,cs,:);
bl1 = imresize(bigim,1/rfact);%imfilter(bigim,h,'replicate');
bl2 = imresize(bigall,1/rfact);%imfilter(bigall,h,'replicate');

blim=bl1(:,2:end-1);
blima=bl2(:,2:end-1,:);
% cs=[3:rfact:en]+ex;
% blim=bl1(1:rfact:end,cs);
% blima=bl2(1:rfact:end,cs,:);

[bina,t]=binaryimage(blim,blima,t)

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
if((nargin<3)|(t==-1)) t=round(graythresh(d)*255); end;
while 1

    subplot(2,1,1),imagesc(imrgb),axis image

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
    if(isequal(b,'c')) break;
    elseif(isequal(b,'k')) 
        keyboard;
%         [tempb,tempd]=RegionCol(bina,1,d);
%   d=tempd;bina=tempb;
    elseif(b==30) t=t+1;
    elseif(b==31) t=t-1;
    end
end

