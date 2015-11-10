function [x,y,th]=buildRoute(dx,world_sz)
% function allows you to specify a route by clicking arbitarry waypoints
% and linearly interpolates between the points
% outputs are x and y and th is dirction to next point

% open a figure
figure;
hold on
[x,y,th]=deal([],[],[]);

% check inputs
if nargin==0
    dx=0.01;
    axis([-1,1,-1,1])
else
    axis([-world_sz(1),world_sz(1),-world_sz(2),world_sz(2)])
end

% specify waypoints on route press return when done
while(1)
    [x0,y0]=ginput(1);
    
    if isempty(x0)
        break
    end
    
    if isempty(x)
        plot(x0,y0,'.');
    else
        plot(x0,y0,'.');
        plot([x(end),x0],[y(end),y0],'-');
    end
    [x,y]=deal([x,x0],[y,y0]);
end
% add final th
[th,r]=cart2pol(x(2:end)-x(1:end-1),y(2:end)-y(1:end-1));
th=[th,th(end)];

% step through waypoints with stepsize set to dx
[x0,y0,th0]=deal(x(1),y(1),th(1));
cnt=0;
for i=1:length(x)-1
    % check whether we are within dx of the next waypoint
    while sqrt(dist2([x0,y0],[x(i+1),y(i+1)]))>dx
        cnt=cnt+1;
        [x0,y0]=deal(x0+dx*cos(th(i)),y0+dx*sin(th(i)));
        [xx(cnt),yy(cnt),tt(cnt)]=deal(x0,y0,th(i));
    end
    [x0,y0]=deal(x(i+1),y(i+1));
end

% set outputs
[x,y,th]=deal(xx,yy,tt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper functions
function n2 = dist2(x, c)
%DIST2	Calculates squared distance between two sets of points.

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end

