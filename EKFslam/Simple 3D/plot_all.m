function plot_all(world,ant,X,P)
n_landmarks=size(world.landmarks,1);
% measure
for n=1:n_landmarks
    i1=3*(n-1)+4;
    i2=3*(n-1)+5;
    i3=3*(n-1)+6;
    % Plot progress
    plot3(world.landmarks(n,1),world.landmarks(n,2),world.landmarks(n,3),'r*');
    hold on
    plot3(X(i1),X(i2),X(i3),'r.');
    error_ellipse(P(i1:i3,i1:i3),X(i1:i3));
end
plot3(ant.x,ant.y,ant.z,'k*')
plot3(X(1),X(2),X(3),'k.');
error_ellipse(P(1:3,1:3),X(1:3)); 
axis([-100 100 -100 100 -100 100])

drawnow
hold off