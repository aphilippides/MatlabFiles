function [X,P]=init(world,ant)
% Initialise agent position and covariance
X=[ant.x;ant.y;ant.z];
P=0.0001*eye(3);

% Initialise landmark positions and covariance
for i=1:size(world.landmarks,1)
    for j=1:3
        X=[X;world.landmarks(i,j)+10*randn(1)];
        P(end+1,end+1)=100;
    end
end
