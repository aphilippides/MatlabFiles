
n_landmarks=5;
world=new_world(0,n_landmarks,0);
ant=simple_ant(world);

% Initialise X and P
[X,P]=init(world,ant);

% plot initial estimates
clf
plot_all(world,ant,X,P);

% Process Noise
Q=0.5; 
%Measurement Noise
% R=0.35; 
R=[ 0.3366    0.0043   -0.0061;...
        0.0043    0.3290    0.0047;...
        -0.0061    0.0047    0.3328];

%main loop
for i=1:1000
    % make a move
    %         U=[ant.v*cos(rand(1)*2*pi),ant.v*sin(rand(1)*2*pi)];
    U=[ant.v*cos(i/10);ant.v*sin(i/20);ant.v*sin(i/35)];
    ant.x=ant.x+U(1)+Q*randn(1);
    ant.y=ant.y+U(2)+Q*randn(1);
    ant.z=ant.z+U(3)+Q*randn(1);
    
    % predict 
    [X,P]=EKFpredict(U,X,P,Q);
    
    % measure
    for n=1:n_landmarks
        
        % Get measured heading
        XYZ=raytrace(ant,world,n);
        if sum(XYZ(:))~=0
            % Incorporate measurement
            [X,P]=EKFmeasure(XYZ,X,P,R,n);
        end
    end
    % plot current estimates
    if mod(i,1)==0
        plot_all(world,ant,X,P);
    end
end