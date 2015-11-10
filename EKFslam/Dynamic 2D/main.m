
n_landmarks=10;
world=new_world(0,n_landmarks,0);
ant=simple_ant(world);% dx set to 5
dt=ant.dt;
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
    % apply a random impulse
    U=Q*randn(1,2);
    ant.x=ant.x+ant.dx*dt;
    ant.y=ant.y+ant.dy*dt;
    ant.dx=ant.dx+U(1)*dt;
    ant.dy=ant.dy+U(2)*dt;
    
    pU=[0,0];
    % predict 
    [X,P]=EKFpredict(pU,X,P,Q,dt);
    
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