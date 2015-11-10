function im=imagetocirc(im)
% function im=imagetocirc(im)
%
% "Rounds off" the edges of an image, replacing values with NaN

% needs to be in double cf. uint8 format for us to be allowed NaNs in there
im = im2double(im);

% grid of x,y coords
[x,y] = ndgrid(linspace(-1,1,size(im,1)),linspace(-1,1,size(im,2)));

% make into 3D array (needed if in color)
x = repmat(x,[1 1 size(im,3)]);
y = repmat(y,[1 1 size(im,3)]);

% equation of circle: x^2+y^2=r^2
im(x.^2+y.^2 > 1) = NaN;