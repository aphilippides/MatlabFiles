
n_landmarks=1;
world=new_world(0,n_landmarks,0);
ant=simple_ant(world);

% Initialise X and P
[X,P]=init(world,ant);

% plot initial estimates
clf
plot_all(world,ant,X,P);

% Process Noise
Q=0.1; 
%Measurement Noise
R=0.0105; 

%main loop
for i=1:1000
    % make a move
%         U=[ant.v*cos(rand(1)*2*pi),ant.v*sin(rand(1)*2*pi)];
    U=[ant.v*cos(i/10),ant.v*sin(i/20)];
    ant.x=ant.x+U(1)+Q*randn(1);
    ant.y=ant.y+U(2)+Q*randn(1);
    
    % predict 
    [X,P]=EKFpredict(U,X,P,Q);
    
    % measure
    for n=1:n_landmarks
        
        % Get measured heading
        z=get_heading(world,ant,n);
        
        % Incorporate measurement
        [X,P]=EKFmeasure(z,X,P,R,n);
        
    end
    % plot current estimates
    plot_all(world,ant,X,P);
end