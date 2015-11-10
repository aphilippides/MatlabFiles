
n_landmarks=5;
world=new_world(0,n_landmarks,0);
ant=simple_ant(world);

% Initialise X and P
[X,P]=init(world,ant);

% plot initial estimates
clf
plot_all(world,ant,X,P);

% Process Noise
Q=diag([15,15,15,5,5,5]);
%Measurement Noise

% R=[ 0.3366    0.0043   -0.0061;...
%         0.0043    0.3290    0.0047;...
%         -0.0061    0.0047    0.3328];
R =  1.0e-002*[...
    0.3382    0.0347    0.0163;...
    0.0347    0.2872    0.0328;...
    0.0163    0.0328    0.3527];
%main loop
dt=ant.dt;
for i=1:1000
    
    % apply a random impulse
    U=Q*randn(6,1);
    
    ant.x=ant.x+ant.dx*dt;
    ant.y=ant.y+ant.dy*dt;
    ant.z=ant.z+ant.dz*dt;
    ant.yaw=ant.yaw+ant.dyaw*dt;   
    ant.pitch=ant.pitch+ant.dpitch*dt;
    ant.roll=ant.roll+ant.droll*dt;
    ant.dx=ant.dx+U(1)*dt;
    ant.dy=ant.dy+U(2)*dt;
    ant.dz=ant.dz+U(3)*dt;
    ant.dyaw=ant.dyaw+U(4)*dt;   
    ant.dpitch=ant.dpitch+U(5)*dt;
    ant.droll=ant.droll+U(6)*dt;   
    
    % predict 
    [X,P]=EKFpredict(U,X,P,Q,dt);
    
    % measure
    for n=1:n_landmarks
        
        % Get measured heading
        XYZ=FastRaytrace(ant,world,n);
        %         XYZ=raytrace(ant,world,n); 
        if sum(XYZ(:))~=0
            % Incorporate measurement
            [X,P]=EKFmeasure(XYZ,X,P,R,n);
        else
            disp('No measure')
        end
    end
    % plot current estimates
    if mod(i,1)==0
        plot_all(world,ant,X,P);
    end
end