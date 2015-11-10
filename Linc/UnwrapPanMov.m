% function[o,cent]=UnwrapPanMov(fn,t,l,nfac,r1,r2)
%
% USAGE UnwrapPan(fn) where fn is the filename
% ignore all other parameters (for advanced users only, haha
% Only thing to change is line 15 when the central pixel is determined 

function[o,cent]=UnwrapPanMov(fn,r1,r2,t,l,nel,nrad)


[inf,NumFr]=MyAviInfo(fn);

GenerateMatFromMovAlt(fn,(r1*30+1):5:(r2*30),t);
% CheckIms(fn,(r1*30+1):5:(r1*30+120),1);
% CheckIms(fn,131:30:406,0);
GenerateMatFromMov(fn,131:30:(r2*30),0,1);
% GenerateMatFromMov(fn,(r1*30+1):5:(r2*30),1);
% Check some:
% CheckIms(fn,(r1*30+1):5:(r1*30+120));


return
Drawing=1;

% Change this once centre is determined and adjust lines 64-65
CentNeeded=1;


im=double(rgb2gray(MyAviRead(fn,1)));
si=size(im);

[X,Y]=meshgrid(1:si(2),1:si(1));

if(nargin<3) t=220; end;
if(nargin<4) l=0; end;
% for whole thing use r1=30, r2=120
if(nargin<6) r1=74; end;
if(nargin<7) r2=78; end;
fn=['InterpPtsR' int2str(r1) '_' int2str(r2) 'Deg0_5.mat'];
% fn=['InterpPtsR74_78Deg0_5.mat'];

% generate interp data if needed: currently settings is for spacing of 0.5
% degrees. this means that 4 degrees = 8 units. Thus subsample mean factor
% is 8. For this reason, the amount r increases by is set to result in 32
% units of r which is 4 lots of 8 to be median-ed over
if(isfile(fn)) load(fn);
else
    np=720;
    p=2*pi/np;
    ts=pi:-p:(-pi+p);
    %    ts=0:-p:-(2*pi-p);

    % subsampfact = 4 degrees/unit width
    subsampfact=pi/(45*p);
    d=(r2-r1)/(4*subsampfact);
    rads=r1:d:(r2-d);
    rads=r1:0.5:r2;

    xM=[];yM=[];
    for r=rads
        [xs,ys]=pol2cart(ts,r);
        xM=[xM; xs];%+cent(1)];
        yM=[yM; ys];%+cent(2)];
    end
    save(fn,'xM','yM');%,'subsampfact','cent','');
end
if(CentNeeded) 
    [cent,fact]=GetCentroid(im);
else
%     cent=[152.24 124];        % this is for one of the gantry databases
    load MedianCents;  % this is for the without wa databases
    fact = 1;
end
xM=[xM+cent(1)];
yM=[yM+cent(2)];

unwrapped2=interp2(X,Y,im,xM,yM,'*cubic');
o=unwrapped2;
% if(nargin==4)
%     sm = NewSmooth(unwrapped2,subsampfact,l);
%     o=median(sm)<t;
% else
%     sl=median(unwrapped2)<t;
%     sm = NewSmooth(sl,subsampfact,l);
%     o=sm>(0.95*nfac/(subsampfact+2*l));
% end

if(Drawing)
    figure(4)
    imagesc(im), colormap(gray)
    hold on, plot(cent(1), cent(2), 'r.'), hold off
    figure(3)
    imagesc(unwrapped2), colormap(gray)
%     figure(5)
%     subplot(2,1,1)
%     imagesc(sm)
%     subplot(2,1,2)
%     plot(1:90,median(sm),'r',1:90,mean(sm),1:90,o*250,'g')
end

function[newX] = NewSmooth(x,n,sp)
if(n==1)
    newX=x;
    return;
end
[h,w]=size(x);
l=1;
if(h==1)
    for i=1:n:w-n+1
        inds=mod((i-sp):(i+n-1+sp),w)+1;
        newX(l)=mean(x(inds),2);
        l=l+1;
    end
else
    for j=1:n:h-n+1
        meanrows=mean(x(j:j+n-1,:),1);
        m=1;
        for i=1:n:w-n+1
            inds=mod((i-sp):(i+n-1+sp),w)+1;
            newX(l,m)=mean(meanrows(inds),2);
            m=m+1;
        end;
        l=l+1;
    end
end

function CheckIms(fn,is,opt)
for i=is

    if(opt==2)
        im2=MyAviRead(fn,i);
        subplot(2,1,1)
        imagesc(im2)
        subplot(2,1,2)
    end
    load([fn(1:end-4) int2str(i) '.mat'])
    imagesc(im),
    axis equal
    title(int2str(i) )
    inp=input('any key to continue');
end

function GenerateMatFromMovAlt(fn,is,sp)
% goodstart=sp:30:(r2*30);
sp=find(is==sp);
goodstart=sp:6:is(end);
todo=zeros(size(is));
for i=goodstart
    todo(i:i+3)=1;
end
GenerateMatFromMov(fn,is,2,todo)

function GenerateMatFromMov(fn,is,opt,notclear)
if(opt==1)
    notclear=zeros(size(is));
elseif(opt==0)
    notclear=zeros(size(is));
end
for j=1:length(is)
    i=is(j);
    f=[fn(1:end-4) int2str(i) '.mat'];
    if((opt==0)||(~isfile(f)))
        i
        c=0;
        [im,c]=MyAviRead(fn,i);
%         while(c==0)
%         end
            save(f,'im');
        if(notclear(j))
            clear im
        else
            clear mex im
        end
    end
end

function[cent,fact]=GetCentroid(im)
d=uint8(im>100);
big=bwareaopen(d,1e4,8);
big=imfill(big,'holes');
[l,n]=bwlabel(big);
s=regionprops(l,'Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength');
cent=[s(1).Centroid];
fact = 1;