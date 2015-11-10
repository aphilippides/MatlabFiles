function plot_all(world,ant,X,P)
n_landmarks=size(world.landmarks,1);

for n=1:n_landmarks
    i1=3*(n-1)+13;
    i2=3*(n-1)+14;
    i3=3*(n-1)+15;
    
    %plot landmarks
    plot3(world.landmarks(n,1),world.landmarks(n,2),world.landmarks(n,3),'r*');
    hold on
    
    %plot landmark predictions
    plot3(X(i1),X(i2),X(i3),'r.');
    error_ellipse(P(i1:i3,i1:i3),X(i1:i3));
end

% plot agent
plot3(ant.x,ant.y,ant.z,'k*')
hold on
T=Transform(ant.yaw,ant.pitch,ant.roll);
T1=T*[10;0;0];
quiver3(ant.x,ant.y,ant.z,T1(1),T1(2),T1(3),0);
T1=T*[0;10;0];
quiver3(ant.x,ant.y,ant.z,T1(1),T1(2),T1(3),0);
T1=T*[0;0;10];
quiver3(ant.x,ant.y,ant.z,T1(1),T1(2),T1(3),0);

% and prediction
plot3(X(1),X(2),X(3),'k.');
error_ellipse(P(1:3,1:3),X(1:3)); 
T=Transform(X(4),X(5),X(6));
T1=T*[10;0;0];
quiver3(X(1),X(2),X(3),T1(1),T1(2),T1(3),0,'r');
T1=T*[0;10;0];
quiver3(X(1),X(2),X(3),T1(1),T1(2),T1(3),0,'r');
T1=T*[0;0;10];
quiver3(X(1),X(2),X(3),T1(1),T1(2),T1(3),0,'r');


axis([-50 50 -50 50 -50 50])

drawnow
hold off