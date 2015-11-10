function plot_all(world,ant,X,P)
n_landmarks=size(world.landmarks,1);
% measure


for n=1:n_landmarks
   ind1=2*(n-1)+4;
ind2=2*(n-1)+5; 
    % Plot progress
    plot(world.landmarks(n,1),world.landmarks(n,2),'r*');
    hold on
    plot(X(ind1),X(ind2),'r.');
    error_ellipse(P(ind1:ind2,ind1:ind2),X(ind1:ind2));
end
plot(ant.x,ant.y,'k*')
plot(X(1),X(2),'k.');
quiver(ant.x,ant.y,5*cos(ant.theta),5*sin(ant.theta),0,'k')
quiver(X(1),X(2),5*cos(X(3)),5*sin(X(3)),0,'r')
error_ellipse(P(1:2,1:2),X(1:2)); 
axis([-50 50 -50 50])
drawnow
hold off