function unwrappingFunction(folder)
if nargin==0
    % specify folder containing images
    folder='pano housefield1';
end
d=dir(strcat(folder,'\*.JPG'));

% width in pixels of unwrapped image
image_width=1440;
% read in first image to determine manually red patches
im=imread(strcat(folder,'\',d(1).name));
% im=resizeImage(im,0.25);
% find the red patches
rmax=0;rmin=255;bmax=0;bmin=255;gmax=0;gmin=255;
imagesc(im);
while 1
    title('Click on red patches: press return when done')
    [y,x]=ginput(1);
    if isempty(x)
        break
    end
    x=ceil(x);
    y=ceil(y);
    red=im(x,y,1);
    green=im(x,y,2);
    blue=im(x,y,3);
    rmax=max(rmax,red);rmin=min(rmin,red);
    bmax=max(bmax,blue);bmin=min(bmin,blue);
    gmax=max(gmax,green);gmin=min(gmin,green);
    % find the red patches
    [y,x]=find(im(:,:,1)>=rmin & im(:,:,1)<=rmax ...
        & im(:,:,2)>=gmin & im(:,:,2)<=gmax ...
        & im(:,:,3)>=bmin & im(:,:,3)<=bmax);

    imagesc(im)
    hold on
    plot(x,y,'.')
    hold off
end
[cent,radius] = FitCircle2(im);

imagesc(im)
hold on
%     plot(x,y,'.')
MyCircleLocal(cent(1),cent(2),radius);
drawnow

for i=1:length(d)
    im=imread(strcat(folder,'\',d(i).name));
%     im=resizeImage(im,0.25);
    % only search band roughly where we expect the red circle to be
    sz=size(im(:,:,1));
    [X,Y]=meshgrid(1:sz(2),1:sz(1));
    for j=1:3
        temp=im(:,:,j);
        temp(((X-cent(1)).^2+(Y-cent(2)).^2 )>(radius+20)^2)=0;
        temp(((X-cent(1)).^2+(Y-cent(2)).^2) < (radius-20)^2)=0;
        im0(:,:,j)=temp;
    end

    % find the red patches
    [y,x]=find(im0(:,:,1)>=rmin & im0(:,:,1)<=rmax ...
        & im0(:,:,2)>=gmin & im0(:,:,2)<=gmax ...
        & im0(:,:,3)>=bmin & im0(:,:,3)<=bmax);
    % fit circle to red patches
    abc=pinv([x,y,ones(size(x))])*(x.^2+y.^2);
    cent=[abc(1)/2,abc(2)/2];
    %     radius=mean(sqrt((x-cent(1)).^2+(y-cent(2)).^2));
    imagesc(im)
    hold on
    plot(x,y,'.')
    MyCircleLocal(cent(1),cent(2),radius);
    drawnow
    hold off
    % make a mesh to perform interpolation
    sz=size(im(:,:,1));
    [X,Y]=meshgrid(1:sz(2),1:sz(1));
    % determine radial and azimuthal steps
    azms=linspace(-pi,pi,image_width+1);
    azms=azms(1:end-1);
    rads=linspace(0,radius,round(image_width*135/360)+1);
    rads=rads(1:end-1);
    %     rads=0:0.25:radius;
    %     azms=-pi:(2*pi)/1540:pi;
    % construct cartesian points from polar steps
    xM=[];yM=[];
    for r=rads
        [xs,ys]=pol2cart(azms,r);
        xM=[xM; xs];
        yM=[yM; ys];
    end
    % centre the circular sample points
    xM=[xM+cent(1)];
    yM=[yM+cent(2)];
    % interpolate the image
    r=double(im(:,:,1));
    g=double(im(:,:,2));
    b=double(im(:,:,3));
    u_r=uint8(interp2(X,Y,r,xM,yM,'*cubic'));
    u_b=uint8(interp2(X,Y,b,xM,yM,'*cubic'));
    u_g=uint8(interp2(X,Y,g,xM,yM,'*cubic'));

    frame(:,:,1)=u_r;
    frame(:,:,2)=u_g;
    frame(:,:,3)=u_b;
    % save the unwrapped file
    if ~exist(strcat('unwrapped\',folder),'dir')
        mkdir(strcat('unwrapped\',folder))
    end
    save(strcat('unwrapped\',folder,'\',d(i).name(1:end-4)),'frame')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sub functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c,rad] = FitCircle2(im,sp,axw)
clf
imagesc(im);
if(nargin==3) axis(axw); end;
axis equal;
hold on;
if(nargin<2)
    [c,rad]=GetStartPoint;
else
    c=sp(1:2);
    rad=sp(3);
    t=pi/2;
end

MyCircleLocal(c(1),c(2),rad,'r');
plot(c(1),c(2),'r.');
hold off;

function[c,rad]=GetStartPoint
title('Click 7 points on the radius')
[x,y]=ginput(7);
% solve
abc=pinv([x,y,ones(size(x))])*(x.^2+y.^2);

c=[abc(1)/2,abc(2)/2];
rad=mean(sqrt((x-c(1)).^2+(y-c(2)).^2));

% rad=sqrt((abc(1)/2)^2+(abc(2)/2)^2-abc(3));

function im1=resizeImage(im,acuity)
% acuity is in degrees i.e. acuity=4 -> each pixel is 4 degrees,
% acuity = 0.2 ->5 pixels /degree
if nargin==1
    acuity=1;
end
% check whether colour or black and white
[a,b,c]=size(im);
if c==1
    % black and white
    B=double(im);
    [h,w]=size(im);
    block_sz=acuity*round(w/360);

    % make sure the dimensions are whole numbers

    max_h=floor(h/block_sz)*block_sz;
    max_w=floor(w/block_sz)*block_sz;

    B=B(1:max_h,1:max_w);

    fun=@(x) mean(x(:));

    im1=blkproc(B,[block_sz block_sz],fun);
else
    %colour
    R=double(im(:,:,1));
    B=double(im(:,:,2));
    G=double(im(:,:,3));
    [h,w]=size(R);
    block_sz=acuity*round(w/360);

    % make sure the dimensions are whole numbers

    max_h=floor(h/block_sz)*block_sz;
    max_w=floor(w/block_sz)*block_sz;

    R=R(1:max_h,1:max_w);
    B=B(1:max_h,1:max_w);
    G=G(1:max_h,1:max_w);
    % anonymous function
    fun=@(x) mean(x(:));

    im1(:,:,1)=uint8(blkproc(R,[block_sz block_sz],fun));
    im1(:,:,2)=uint8(blkproc(B,[block_sz block_sz],fun));
    im1(:,:,3)=uint8(blkproc(G,[block_sz block_sz],fun));
end

% function[lhdl] = MyCircleLocal(x,y,Rad,col,NumPts,fillc)
%
% Function draws circles of radius Rad(i) at x(:,i),y(:,i). 
% col is colour, NumPts the number of points to draw the circle
% defaults are blue and 50 and fills it if fillc = 1 (default 0)
%
% if x is a 2D row vector, it uses x as position and other parameters 
% shift across one eg y is rad
%
% function returns ldhl, handles to the lines
function[lhdl] = MyCircleLocal(x,y,Rad,col,NumPts,fillc)
ho=ishold;
if(size(x,2)==2)
    if(nargin<5) 
        fillc=0;
    else
        fillc=NumPts;
    end
    if((nargin<4)||isempty(col)) 
        NumPts=50;
    else
        NumPts=col;
    end;
    if(nargin<3) 
        col = 'b';
    else
        col=Rad;
    end;
    Rad=y;
    y=x(:,2);
    x=x(:,1);
else
    if(nargin<6) 
        fillc=0; 
    end;
    if((nargin<5)||isempty(NumPts)) 
        NumPts=50; 
    end;
    if(nargin<4) 
        col = 'b'; 
    end;
end

Thetas=0:2*pi/NumPts:2*pi;
lhdl=zeros(length(Rad));
if(size(col,1)==1)
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col);
            hold on;
        end
        lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col);
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col);
        hold on
    end
else
    for i=1:length(Rad)
        [Xs,Ys]=pol2cart(Thetas,Rad(i));
        if(fillc) 
            fill(Xs+x(i),Ys+y(i),col(i,:));
            hold on;
        end
        lhdl(i)=plot(Xs+x(i),Ys+y(i),'Color',col(i,:));
        % THIS ERROR LOOKS TO BE A VERSION CHANGE: BELOW FOR NEW VERSIONS
%         lhdl(i)=plot(Xs+x(i),Ys+y(i),col(i,:));
        hold on
    end
end
if(~ho) 
    hold off; 
end;