% function[o,cent]=UnwrapPan(fn,rads,ts,cent,plotting)
%
% USAGE UnwrapPan(fn,rads,ts) where fn is the filename, rads the list
%  of radii (from centre of panoramic outwards in pixels) and ts the
% azimuths (in radians)
% 
% eg: UnWrapPanBasic('1974_1798.bmp',10:150,-pi:(2*pi)/360:pi)
%
% Only thing to change is the part that determines the central pixel 

function[o,cent]=UnwrapPan(fn,rads,ts,cent,plotting)

if(nargin<5) plotting=1; end;
if(isstruct(rads))
    if(nargin<3) plotting=1;
    else plotting = ts;
    end
end

im=double(rgb2gray(imread(fn)));
if(isstruct(rads))
    xM=rads.xM;
    yM=rads.yM;
    X=rads.X;
    Y=rads.Y;
    cent=rads.cent;
else
    % Change this once centre is determined and adjust line 42
    if(nargin<3) CentNeeded=1;
    elseif(length(cent)==1) CentNeeded=cent;
    else CentNeeded-0;
    end;
    si=size(im);
    [X,Y]=meshgrid(1:si(2),1:si(1));
    xM=[];yM=[];
    for r=rads
        [xs,ys]=pol2cart(ts,r);
        xM=[xM; xs];%+cent(1)];
        yM=[yM; ys];%+cent(2)];
    end
    if(CentNeeded) [cent,fact]=GetCentroid(im);
    elseif(length(cent)==1)  cent=[152.24 124];        % this is for one of the gantry databases
    end
    xM=[xM+cent(1)];
    yM=[yM+cent(2)];
end

unwrapped2=interp2(X,Y,im,xM,yM,'*cubic');
o=unwrapped2;
if(plotting)
    figure(1)
    imagesc(im), colormap(gray)
    hold on, plot(cent(1), cent(2), 'r.'), hold off
    title(fn);
    figure(2)
    imagesc(unwrapped2), colormap(gray)
end

function[cent,fact]=GetCentroid(im)
d=uint8(im>100);
big=bwareaopen(d,1e4,8);
big=imfill(big,'holes');
[l,n]=bwlabel(big);
s=regionprops(l,'Centroid','Orientation','Eccentricity','MajorAxisLength','MinorAxisLength');
cent=[s(1).Centroid];
fact = 1;