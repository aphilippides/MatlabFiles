function[NObj,mx,my]= ShowVisualCompass(nobj,objr,startpt,n)

global pl;
pl=0;
% set the grid of points for the environmen
% by default, grid is 0:100 sqaure, with 10 positions in it
if(nargin<4) n=10; end; 
[X,Y] = meshgrid([-100:n:100+n]);

% *** set objects in the environment here ****
% object is defined as: [x, y, radius;
% [O]=RndEnvironment(nobj,[n 100],objr,[startpt agentrad]);
% O=[100 70 5;100 30 5];
O=[20 0 7.5;-100 50 25];
% O=[30 100 objr;70 100 objr];

% set a goal position, defaults to centre of the grid
% in the old version this was goal snapshot position so is now bit defunct
if(nargin<3) 
    mp=floor(length(X)/2);
%     startpt=[X(mp,mp) Y(mp,mp)] ; 
    startpt=[0 0] ; 
%     startpt=[10 50] ; 
end;
% calc the ALV from the start position: Legacy stuff
[startang,ws,startons]=LincVision(O,startpt);
startx=mean(cos(startang));
starty=mean(sin(startang));

% *** set up the snapshot positions here ****
% snapshot defined as a position; nest facing angle calced below 
% snappos=[45, 50] ; 
% snappos=[45, 50; 55 50; 50 45;50 55] ; 
snd=5;
snappos=[-snd 0;snd 0;0 snd;0 -snd]; 

% set agent radius: not used apart from setting size of nest in pics
agentrad=2.5;

% get the snapshots
for i=1:size(snappos,1)
    % calculate the angle to the nest
    v2nest=startpt-snappos(i,:);
    ang2nest(i)=cart2pol(v2nest(1),v2nest(2));
    % LincVision is the driver function. Given a position and objects it
    % returns the viewed world. Needs to be updated to take angle of agent    
    [snapangs,ws,snapons(i,:)]=LincVision(O,snappos(i,:),ang2nest(i));
%     snapx(i)=mean(cos(snapangs(i)));
%     snapy(i)=mean(sin(snapangs(i)));
end

% Set all outputs to NaN. This is the deafult result if no objects can be
% seen or if the agent is inside an object
mx=ones(size(X))*NaN; my=mx;
vcx=mx; vcy=mx; 
ang=mx; angerr=mx; vec_len=mx;
mnx=mx; mny=mx;

for i=1:length(X)
    row=i
    for j=1:length(Y)
        % set the agent at the next grid point
        agent=[X(i,j) Y(i,j) agentrad];
        % check if agent is inside an object. If so, set outputs to NaN
        if(InsideObject(O,agent)) NObj(i,j)=-1;
        else
            [angs,w,ons]=LincVision(O,agent([1 2]));
            NObj(i,j)=length(angs);
            if(NObj(i,j)>0)
                % this is old: for calcualting ALV homing from start
                mx(i,j)=mean(cos(angs));
                my(i,j)=mean(sin(angs));
                %calc vector to the nest
                v2n=startpt-agent([1 2]);               
                % get the resultant anngle from all rotaional snapshots
                [ang(i,j),angerr(i,j),mn,vec_len(i,j)]=GetAngleFromSnaps(snapons,ons,v2n);%+snapangs;
                mnx(i,j)=mn(1);
                mny(i,j)=mn(2);                
                % calculate the resultant angle vector with length 1 so it's easy to see
                [vcx(i,j),vcy(i,j)]=pol2cart(ang(i,j),1);
            end
        end
    end
end
save tempShowVisualCompass

figure(1)
DrawEnviro(O,[startpt agentrad],snappos);hold on;
% plot the alv angles
mx=mx-startx;
my=my-starty;
quiver(X,Y,mx,my,'r')
% plot the rotational angles with unit length vectors
quiver(X,Y,vcx,vcy,'b')
hold off,axis tight,title('rotational angle (blue) and ALV (red)')

% plot the rotational angles with actual length vectors
figure(3),subplot(2,2,1)
DrawEnviro(O,[startpt agentrad],snappos);
hold on;quiver(X,Y,mnx,mny,'b')
hold off,axis tight,title('rotational angle (actual length)')

% remember when looking at these plots, pcolor cuts off the edges
% imagesc is better but you can't plot x and y, and it plots y backwards
subplot(2,2,2),pcolor(X,Y,abs(angerr)),title('absolute angular error'),colorbar
subplot(2,2,3),pcolor(X,Y,NObj),title(' number of objects visible')
subplot(2,2,4),pcolor(X,Y,vec_len),title('length of resultant vector'),colorbar

% function to generate snapshot stuff
function[ang,angerr,mx,r]=GetAngleFromSnaps(snaps,ons,v2n)
global pl
snaps=double(snaps);
ons=double(ons);
% get the visual compass angle and distance
% Visual compass can return a few other params but not really needed here
% Also can set a 3rd input which limits the range of angles searched
for i=1:size(snaps,1)
    [a,dum,dum,mind(i),ds(i,:)]=VisualCompass(snaps(i,:),ons);
    angs(i)=a*pi/45;
end
% can't remember how we did the normalising but obviously loads of ways
% here using 99th percentile of all the differences
maxdiff=prctile(ds(:),99);

% calc the weightings: again myriad ways
ws=max(1-mind/maxdiff,0);

% calc the weighted vector average
[xs,ys]=pol2cart(angs,ws);
mx=mean([xs' ys'],1);

% calc true angle to nest etc
a2n=cart2pol(v2n(1),v2n(2));
[nx,ny]=pol2cart(a2n,0.33);

% calc the angle and 'confidence' length (unused)
[ang,r]=cart2pol(mx(1),mx(2));
% calculates angular error as: 
% what angle would you rotate the current estimate by to face nest
angerr=AngularDifference(a2n,ang)*180/pi;
% plot the rotational IDFs, resultant vectors and real direction
if(pl)
    figure(2),subplot(1,2,1),plot(ds'),title(['Max diff = ' num2str(maxdiff)])
    subplot(1,2,2),zs=zeros(size(xs));
    plot([zs;xs],[zs;ys],[0 mx(1)],[0 mx(2)],'k-*',[0 nx],[0 ny],'r:o')
    title(['angular error = ' num2str(angerr)])
    inp=input('press any key to continue; 1 to stop plotting:  ');
    if(isequal(inp,1)) pl=0; end;
end

function DrawEnviro(NewObj,Objects,snaps)
for i=1:size(NewObj,1)
    MyCircle(NewObj(i,[1 2]),NewObj(i,3),'k')
    hold on;
end
for i=1:size(Objects,1)
    MyCircle(Objects(i,[1 2]),Objects(i,3),'r')
end
for i=1:size(snaps,1)
    plot(snaps(i,1),snaps(i,2),'kx','MarkerSize',8,'LineWidth',1.5)%,'MarkerFaceColor','k')
end
hold off