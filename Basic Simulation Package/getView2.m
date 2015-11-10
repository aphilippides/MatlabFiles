function v=getView2(x,y,z,th,X,Y,Z)
% this is the same as getView but has own versions of imresize and blkProc

% get the ground height
z0=getHeight(x,y,X,Y,Z);

figure(999)
[TH,PHI,R]=cart2sph(X-x,Y-y,Z-z-z0);
TH=pi2pi(TH-th);

ind=(max(TH')-min(TH')<pi);
fill(-TH(ind,:)',PHI(ind,:)','k')
hold on

negind=(max(TH')-min(TH')>pi);
T2=TH(negind,:);
P2=PHI(negind,:);

TP=T2;
TP(T2<0)=TP(T2<0)+2*pi;

fill(-TP',P2','k')

TP=T2;
TP(T2>0)=TP(T2>0)-2*pi;

fill(-TP',P2','k')

axis equal
axis([-pi pi 0 1.2])
axis off
hold off
drawnow

f=getframe;
v=resizeImage(double(f.cdata(:,:,1)>0),900/size(f.cdata,2));
v=flipud(v);
c1=0;c2=0;
[r,c]=size(v);
for i=1:10:r-10
    c1=c1+1;
    for j=1:10:c-10
        c2=c2+1;
        V(c1,c2)=mean(mean(v(i:i+10,j:j+10)));
    end
    c2=0;
end
v=V;

function image1=resizeImage(image0,sc)
% Scale image by sc amount using cubic interpolation
% im=image
% sc=scale or number of points

% Get Image size
sz=size(image0);

% Create grids for interpolation
[xx,yy]=meshgrid(1:sz(1),1:sz(2));

% work out whether we want number of points or scale
if sc>10
    % we probably want points
    x=linspace(1,sz(1),ceil(sc*sz(1)/sz(2)));
    % scale by aspect ratio for number of y points
    y=linspace(1,sz(2),sc);
    [xn,yn]=meshgrid(x,y);
else
    x=linspace(1,sz(1),ceil(sz(1)*sc));
    y=linspace(1,sz(2),ceil(sz(2)*sc));
    [xn,yn]=meshgrid(x,y);
end
% Determine whether color image
if numel(sz)==2
    % bw
    image1=interp2(xx,yy,image0',xn,yn);
elseif numel(sz)==3
    %colour
    imR=double(image0(:,:,1));
    imG=double(image0(:,:,2));
    imB=double(image0(:,:,3));

    imR=uint8(interp2(xx,yy,imR',xn,yn));
    imG=uint8(interp2(xx,yy,imG',xn,yn));
    imB=uint8(interp2(xx,yy,imB',xn,yn));

    image1(:,:,1)=imR';
    image1(:,:,2)=imG';
    image1(:,:,3)=imB';
else
    error('Image must be 2D or 3D matrix');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image1=image1'; %%%%%%%%%%august 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%