% function VardyTest(gx,gy,n)
%
% this function runs Moller Vardy and Zeil algorithms on an image database
% gx and gy are x and y position of goal. n is the amount of subsampling of
% the image (default=none). Current image is roughly 1 degree acuity

function VardyTest(gx,gy,n)
% OLD: ignore these bits: they're old
% dwork
% cd ../Current/Linc/WithoutWalls
% cd ../d'atabase 2008-01-05/'
% s=dir('*1100.jpg');
% sn=10;
% fn=s(sn).name;
% load([fn(1:end-3) 'mat'])

% OLD: specify the horizon and scale it by n; This is set by examination
% % value for WithoutWalls database
% hor=54.5/n;

% housekeeping
if(nargin<3) n=1; end;

% value for 5-1-2008 database
hor=26.5/n;

% get the goal image
[fn,fno]=GetDBName(gx,gy);
if(fno==0)
    disp('no image at goal position');
    return;
end;
load(fn);

% Sub-sample the picture, reversing top to bottom so indices go upwards
% unlike in unwrapped image (as its unwrapped from middle to outer ring)
goal=SubSampleMean(unw(end:-1:1,:),n,n);

% Generate pre-specified matrices Gamma and B, and various sin/cos of them
[X,Y,sinB,cosB,secG,sinG,isecG,isinG]=GetBGamma(size(goal,2),size(goal,1),hor);

% x and y positions (in mm)
xs=0:50:2900;
ys=0:50:1750;
for i=1:length(xs)
    i
    for j=1:length(ys)
        % get file name
        [fn,fno]=GetDBName(xs(i),ys(j));
        % if it exists (some images don't exist as there was an LM
        % in that position) ...
        if(fno)
            % load it
            load(fn);
            % subsample it
            ss=SubSampleMean(unw(end:-1:1,:),n,n);

            % Get the numerical gradient of the image in image coordinates
            % Ignoring normalising factors this is grad_ij C_ij(x)
            [dx,dy]=gradient(ss);

            % get the difference between goal image and this
            d=goal-ss;

            % Calculate sum-square difference a la Zeil
            absdiff(i,j)=sqrt(sum(sum(d.^2)));

            % calculate Moller and Vardy homing vectors
            [u,v,t,x,y,th] = Moller(d,dx,dy,sinB,cosB,secG,sinG,isecG,isinG);

            % calculate mean homing vectors and headings
            % we multiply x-s by -1 to realign the world and unwrapped
            % camera axes
            homeV_Mx(i,j) = - mean(mean(u));
            homeV_My(i,j) = mean(mean(v));
            headM(i,j) = cart2pol(homeV_Mx(i,j),homeV_My(i,j));
            homeV_Vx(i,j) = - mean(mean(x));
            homeV_Vy(i,j) = mean(mean(y));
            headV(i,j) = cart2pol(homeV_Vx(i,j),homeV_Vy(i,j));

            % OLD: different way of getting mean headings
%             angM(i,j) = MeanAngle(cart2pol(u,v));
%             angV(i,j) = MeanAngle(cart2pol(x,y));
            % OLD: plots things
            %     imagesc(ss)
            %     hold on,plot([1 size(goal,2)],[hor hor]),hold off
            %     figure(1)
            %     imagesc(ss-goal);
            %     figure(2)
            %     quiver(X,Y,u,v)
            % OLD: this line not currently used
            % [u,v,t] = Vardy1(X,Y-hor,d,dx,-dy);
        else
            absdiff(i,j)=NaN;
            headM(i,j) = NaN;
            headV(i,j) = NaN;
            homeV_Mx(i,j) = NaN;
            homeV_My(i,j) =NaN;
            homeV_Vx(i,j) =NaN;
            homeV_Vy(i,j)=NaN;
%             angM(i,j) = NaN;
%             angV(i,j) = NaN;
        end
    end
end
save(['tmp_resultsGoal' int2str(gx) '_' int2str(gy) '_Sub' int2str(n) '.mat'])
figure(1)
surf(xs,ys,absdiff'/max(absdiff(:)))
hold on;plot(gx,gy,'rs');hold off;
title('Image differences')
figure(2)
quiver(xs,ys,-homeV_Mx',homeV_My',2)
hold on;plot(gx,gy,'rs');hold off;
title('Moller version')
figure(3)
quiver(xs,ys,-homeV_Vx',homeV_Vy',2)
hold on;plot(gx,gy,'rs');hold off;
title('Vardy version')

% this function takes the difference between the 2 images, d, the spatial
% gradients in image coordinates dx and dy, and the various transformations
% of B and gamma and calculates the home vector al Moller: (x,y); and
% Vardy: (xv, yv). t and tv are the headings of these vectors
function[x,y,t,xv,yv,tv] = ...
    Moller(d,dx,dy,sinB,cosB,secG,sinG,isecG,isinG)

x=d.*(sinB.*secG.*dx + cosB.*sinG.*dy);
y=d.*(-cosB.*secG.*dx + sinB.*sinG.*dy);
[t,r]=cart2pol(x,y);

xv=d.*(sinB.*isecG.*dx + cosB.*isinG.*dy);
yv=d.*(-cosB.*isecG.*dx + sinB.*isinG.*dy);
[tv,r]=cart2pol(xv,yv);

% this function generates B and gamma and the other constant matrices that
% are needed for the Moller and Vardy calculations. The only arguments
% needed are the size of the unwrapped image after sub-sampling as this
% specifies pixel positions and the row which is the 'horizon' (see below)
function[X,Y,sinB,cosB,secG,sinG,isecG,isinG] ...
    = GetBGamma(NumCols,NumRows,hor)

% Now generate matrices to be used to generate B and Gamma. These matrices
% contain the angular coordinates of pixels in goal which will be used in
% the calculations. This only works beacuse we have unwrapped the panoramic
% image so unw has equal angular increments between columns and our
% catadioptric mirro is fancy and has equal angles as you go radially out
% from the centre of the picture
[X,Y]=meshgrid(1:NumCols,1:NumRows);

% next need to transform X and Y positions into radians
% X is straightforward: basically its (0,2pi]. Only wrinkle is that this
% sets the 0 heading and direction of increase of theta
% (currently 0's in the x-axis direction and angles increase clockwise)
X=X*(2*pi/NumCols);

% Y depends on the angular extent of the camera which is *roughly*
% [-20,70]? However this could be experimented. 
% One also needs to take the 'horizon'
% (ie the row of the image where the height of objects doesn't change)
% off the Y as the horizon needs to be at 0
Y=Y-hor;
Y=Y/max(max(Y));

% these are all the computations of the matrices
% this could be done off-line
sinB=sin(X);
cosB=cos(X);
secG=sec(Y);
sinG=sin(Y);
isecG=sec(Y).^-1;
isinG=sin(Y).^-1;
% there's obviously a problem for the algorithm if sinG or cosG = 0;
% For the camera we use, cosG isn't a problem but sing is a problem around
% the horizon. I wasn't sure how to handle this so I set them to 0.
% I think things cancel out elsewhere in the algortihm but should check

% find all instances of infinity in a column of sinG. All columns are the
% same so then make any rows which are inf = 0
i=find(isinf(isinG(:,1)));
isinG(i,:)=0;

% % OLD: uncomment these bits if you want to see what is being produced by the
% % various pre-computed matrices used later
% x11=secG.*sinB;
% x21=sinG.*cosB;
% x12=-secG.*cosB;
% x22=sinG.*sinB;
% 
% sc=3;
% figure(1)
% quiver(X,Y,sc*x11,sc*x21)
% figure(2)
% quiver(X,Y,sc*x12,sc*x22)

% OLD: I currently don't use this function as its wrapped up in the Moller
% function
function[x,y,t] = Vardy1(X,Y,d,dx,dy)
u=sign(d).*dx;
v=sign(d).*dy;
l=sqrt(u.^2+v.^2);
u=u./l;
v=v./l;
u(isnan(u))=0;
v(isnan(v))=0;

% NB in the formula of Vardy, this bit is -ve but cos image
% coordinates are going down the screen, the -ve cancels out
v=sign(Y).*v;
[t,r]=cart2pol(u,v);
X=X*(2*pi/size(X,2));
x=cos(X).*u-sin(X).*v;
y=sin(X).*u+cos(X).*v;
[t,r]=cart2pol(x,y);