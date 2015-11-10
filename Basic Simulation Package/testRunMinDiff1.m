function testRunMinDiff1(n,sig,world,runData,filename)
% n         number of times to run test
% sig       SD of noise added to chosen direction
% world     file location of model of environment
% runData   file location of training data
% filename  file location to save results figure

load(world);% X Y Z
% load the training data
load(runData); % x y th D runName
% distance to move at each timestep
stepsize=0.1;
% W are the views along the training route
W=D;
clear D;
z0=0;

th=linspace(0,2*pi,90/rotation_stepsize+1);
th=th(1:end-1);

fh=figure(1);
clf
fill(X',Y','k')
hold on
view(0,90)
% plot training route
plot(x(end),y(end),'k*');
plot(x,y,'k.','MarkerSize',0.5,'Color',[0.75,0.75,0.75])
% goal location set here at x=0 y=6
[xgoal,ygoal]=deal(0,6);

for k=1:n
    % start location and orientation set here
    [x0,y0]=deal(0,-6);
    th0=pi/2;
    
    for i=1:300   
        % get the current view
        im=getView(x0,y0,z0,th0,X,Y,Z);
        
        % scan the world to find viewing direction most similar to one 
        % experienced during training
        E=zeros(1,90);
        IND=E;
        for j=1:90
            %   imb=im(:,6:85); % remove back portion of view
            [val,ind]=MinDiff(W,im(:));
            E(j)=val;
            IND(j)=ind;
            im=[im(:,end),im(:,1:end-1)];
        end
        
        % find minimum difference
        [~,ind]=min(E);
        
        % calculate new heading and add some noise
        th0=pi2pi(th0+th(ind)+sig*randn(1));
        
        % plot some stuff
        figure(fh)
        plot([x0,x0+stepsize*cos(th0)],[y0,y0+stepsize*sin(th0)],...
            '-','Color',0*[1,1,1]);
        axis equal
        axis([round(x0)-2 round(x0)+2 round(y0)-2 round(y0)+2]);
        drawnow
        
        % update position
        [x0,y0]=deal(x0+stepsize*cos(th0),y0+stepsize*sin(th0));
        
        % break if out of bounds or at goal
        if sqrt(dist2([x0,y0],[xgoal,ygoal]))<0.2 || abs(x0)>3 || abs(y0)>7
            break
        end
        
    end
end
% save the figure
figure(fh)
axis([-3 3 -7 7])
saveas(fh,strcat(filename,'.fig'))

% Function to find minimum sum squared difference between a test view
% and a group of saved views
function [val,ind]=MinDiff(W,im)
% W stored views
% im test view
% val value of minimum difference
% ind index of the stored view that
[nbases,~]=size(W);
SS2=sum((W'-repmat(im,1,nbases)).^2,1);
[val,ind]=min(SS2);