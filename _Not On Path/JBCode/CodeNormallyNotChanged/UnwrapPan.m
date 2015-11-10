% function[o,cent]=UnwrapPan(x,y,t,l,nfac,r1,r2)
%
% USAGE UnwrapPan(x) where x is the filename
% ignore all other parameters (for advanced users only, haha
% Only thing to change is line 15 when the central pixel is determined 

function[o,cent]=UnwrapPan(x,y,t,l,nfac,r1,r2)

% dwork
% cd GantryProj\ALV\RealGantry\Archive\
% cd ../Current/Linc/WithoutWalls
Drawing=1;

% Change this once centre is determined and adjust lines 64-65
CentNeeded=1;

if(nargin<1) fn ='0_0.jpg';
elseif(ischar(x)) fn=x;
else fn=[int2str(x) '_' int2str(y) '.jpg'];
end;
if(~isfile(fn))
    o=[];
    return;
end
im=double(rgb2gray(imread(fn)));
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
if(CentNeeded) [cent,fact]=GetCentroid(im);
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

function[cent,fact]=GetCentroid(im)
d=uint8(im>100);
big=bwareaopen(d,1e4,8);
big=imfill(big,'holes');
[l,n]=bwlabel(big);
s=regionprops(l,'Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength');
cent=[s(1).Centroid];
fact = 1;