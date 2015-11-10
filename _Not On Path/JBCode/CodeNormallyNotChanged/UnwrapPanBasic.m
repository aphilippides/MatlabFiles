% function[o,cent]=UnwrapPan(fn,rads,ts)
%
% USAGE UnwrapPan(fn,rads,ts) where fn is the filename, rads the list
% eg: UnWrapPanBasic('1974_1798.bmp',10:150,-pi:(2*pi)/360:pi)
%  of radii (from centre of panoramic outwards in pixels) and ts the
% azimuths (in radians)
% Only thing to change is line 12 when the central pixel is determined

function[o,cent]=UnwrapPan(fn,rads,ts)

% Change this once centre is determined and adjust lines 64-65
CentNeeded=1;

im=double(rgb2gray(imread(fn)));
si=size(im);
[X,Y]=meshgrid(1:si(2),1:si(1));

xM=[];yM=[];
for r=rads
    [xs,ys]=pol2cart(ts,r);
    xM=[xM; xs];%+cent(1)];
    yM=[yM; ys];%+cent(2)];
end
if(CentNeeded) [cent,fact]=GetCentroid(im);
else  cent=[152.24 124];        % this is for one of the gantry databases
end
xM=[xM+cent(1)];
yM=[yM+cent(2)];

unwrapped2=interp2(X,Y,im,xM,yM,'*cubic');
o=unwrapped2;
figure(1)
imagesc(im), colormap(gray)
hold on, plot(cent(1), cent(2), 'r.'), hold off
figure(2)
imagesc(unwrapped2), colormap(gray)

function[cent,fact]=GetCentroid(im)
d=uint8(im>100);
big=bwareaopen(d,1e4,8);
big=imfill(big,'holes');
[l,n]=bwlabel(big);
s=regionprops(l,'Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength');
cent=[s(1).Centroid];
fact = 1;