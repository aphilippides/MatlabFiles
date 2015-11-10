function [X,Y,Z]=flatObjectBuilder(pic)
% makes flat objects
% optionally give it a picture filename in pic which can be clicked round
% alternatively click a free shape
%
% center it around 0 to make the rotating to be maximally visible work
%
% once clicked, it asks you for an x-y position at which to put the object
% save them at 0 0 if you want a standard object

figure(1);
clf
if nargin==1
    im=imread(pic);
    imagesc(im)
    axis equal
    hold on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get scale and centre image by clicking red scale bar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % first get the centre of the object
    [c1,c2]=ginput(1);
    % now get the scale bar click top then bottom
    [s1,s2]=ginput(2);
    % crop the image so that bottom of image is at ground level
    maxy=ceil(s2(2)+(s2(2)-s1(2)));
    im=im(1:maxy,:,:);
    % redraw cropped image
    figure(1);
    clf
    imagesc(im)
    axis equal
    hold on
else
    c1=0;
    s1=1;
    s2=0;
    axis equal
    hold on
    axis([-5 5 0 5])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get outline of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=[];
zz=[];
while(1)
    [x,z]=ginput(1);
    % if return pressed join last point to first
    if isempty(x)
        plot([xx(end),xx(1)],[zz(end),zz(1)],'k-')
        break
    end
    % unless first point join current point to previous point
    if ~isempty(xx)
        plot(x,z,'kx')
        plot([x,xx(end)],[z,zz(end)],'k-')
    else
        plot(x,z,'kx')
        hold on
    end
    xx=[xx,x];
    zz=[zz,z];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert into triangular patches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create triangular patches
[p,t]=triangles([xx',zz']);
% plot triangles on figure
triplot(t,p(:,1),p(:,2));
xs=p(:,1);
zs=p(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert into X Y Z representaion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert to nx3 representation
X=xs(t);
Z=zs(t);
Y=zeros(size(X));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale and centre object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% centre object
X=X-c1;
if nargin==1
% flip z values because image origin is top left
Z=-Z;
end
Z=Z-min(Z(:));
% scale
% scale=0.8/(s2(2)-s2(1));
% X=X*scale;
% Z=Z*scale;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% place in correct place in world and rotate so perpendicular to the line of sight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input coordinates of object relative to origin (nest or experimental location)in metres
xpos=input('Input x position: \n');
ypos=input('Input y position: \n');

% rotate so perpendicular to line of sight
% get the angle to position
th=cart2pol(xpos,ypos);
% rotate pi/2 to make it perpendicular to line of sight
th=pi/2-th;
[X,Y,Z]=rotZ(X,Y,Z,th);
% translate to correct x y position
X=X+xpos;
Y=Y+ypos;

