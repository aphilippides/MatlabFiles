function [X,Y,Z]=buildMikesWorld(n)
% builds an analogur of Mike's world which puts n random blades of grass
% which has heights specifed by the heights in world_matrix

load world_matrix; % world
[X,Y,Z]=deal([],[],[]);
width=0.5;

for i=1:n
    while 1
        %select a random position
        x=ceil(rand(1)*1000);
        y=ceil(rand(1)*1000);
        % get the height of world in m 
        h=world(x,y);
        % if part of tussock build a blad of grass
        if h>1
            % pick a random orientation
            th=rand(1)*2*pi;
            % make base
            x1=x+width*(h/133)*cos(th);
            y1=y+width*(h/133)*sin(th);
             z1=0;
            x2=x-width*(h/133)*cos(th);
            y2=y-width*(h/133)*sin(th);
            z2=0;
            % tip of grass
            z3=(1+randn(1)/2)*h;
            x3=x+z3*sin(randn(1)*0.1);
            y3=y+z3*sin(randn(1)*0.1);
            
            X=[X;x1 x2 x3];
            Y=[Y;y1 y2 y3];
            Z=[Z;z1 z2 z3];
            break
        end
    end
end

% rescale to be in metres
[X,Y,Z]=deal(X/100,Y/100,Z/100);

fill3(X',Y',Z','k')
axis equal