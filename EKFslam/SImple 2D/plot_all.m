function plot_all(world,ant,X,P)
n_landmarks=size(world.landmarks,1);
% measure
for n=1:n_landmarks
    
    % Plot progress
    plot(world.landmarks(n,1),world.landmarks(n,2),'r*');
    hold on
    plot(X(2*(n-1)+3),X(2*(n-1)+4),'r.');
    error_ellipse(P(2*(n-1)+3:2*(n-1)+4,2*(n-1)+3:2*(n-1)+4),X(2*(n-1)+3:2*(n-1)+4));
end
plot(ant.x,ant.y,'k*')
plot(X(1),X(2),'k.');
error_ellipse(P(1:2,1:2),X(1:2)); 
axis equal
drawnow
hold off