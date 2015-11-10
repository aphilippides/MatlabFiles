function v=getView(x,y,z,th,X,Y,Z)
% takes inpu as current x, y, z position and orientation
% also a world which is all the trinalges in X, Y and Z

% get the ground height
z0=0;%getHeight(x,y,X,Y,Z);

ff=figure(999);
set(ff,'Position',[3,524,1044,304])
% If you need to resize the figure that pops up reset this line
% by first resizing the image and then typing get(gcf,'Position') to return
% the current position. Put those values into the line above.

% get polar coords of all the positions from current position
[TH,PHI,R]=cart2sph(X-x,Y-y,Z-z-z0);

% remove small far objects for speed up
% [t,r]=cart2pol(mean(R,2),mean(Z,2));
% TH=TH(t/2/pi*360>1,:);
% PHI=PHI(t/2/pi*360>1,:);

% rotate evrything
TH=pi2pi(TH-th);

% do all the ones on the edges
ind=(max(TH')-min(TH')<pi);
fill(-TH(ind,:)',PHI(ind,:)','k')
hold on

% do the ones on the edges: they need to be plotted twice
% ie objects on the edges extend out the sides of your world view
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
% curtail the height and width (so that you don't get the edges as extra)
axis([-pi pi 0 1.2])
axis off
hold off
drawnow

f=getframe;
% this function needs the image processing toolbox
% this resizes to be 900pixels wide by 170 tall
v=imresize(double(f.cdata(:,:,1)>0),900/size(f.cdata,2));

% flips beacuse images plot wrong way round
v=flipud(v);

% this bit means over blocks of 10 by 10
% this function needs more recent versions of MATLAB
V=blkproc(v,[10 10],@mean1);

% drop the end beacuse you have pi twice(?)
v=V(1:end-1,:);  

function m=mean1(X)
m=mean(X(:));

function x=pi2pi(x)
x=mod(x,2*pi);
x=x-(x>pi)*2*pi;