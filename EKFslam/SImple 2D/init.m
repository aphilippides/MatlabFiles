function [X,P]=init(world,ant)
% Initialise agent position and covariance
X=[ant.x;ant.y];
P=0.0001*eye(2);

% Initialise landmark positions and covariance
for i=1:size(world.landmarks,1)
    for j=1:2
        X=[X;world.landmarks(i,j)+10*randn(1)];
        P(end+1,end+1)=1000;
    end
end
