function plot_all(world,ant,X,P)
n_landmarks=size(world.landmarks,1);

% measure
for n=1:n_landmarks
    % Calculate indices
    ind1=2*(n-1)+5;
    ind2=2*(n-1)+6;
    
    % Plot actual landmarks
    plot(world.landmarks(n,1),world.landmarks(n,2),'r*');
    hold on
    % Plot estimates
    plot(X(ind1),X(ind2),'r.');
    error_ellipse(P(ind1:ind2,ind1:ind2),X(ind1:ind2));
end
plot(ant.x,ant.y,'k*')
plot(X(1),X(2),'k.');
error_ellipse(P(1:2,1:2),X(1:2)); 
axis equal
drawnow
hold off