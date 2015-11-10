function PaulStickBall(x,y,theta,n)    

x=x(1:n:end);y=y(1:n:end);
theta=theta(1:n:end);

bsize=18;
hold on
    
%theta=GetTheta(theta-pi);
e_x=x-cos(theta);
e_y=y-sin(theta);
plot(x,y,'k.','MarkerSize',bsize)
for i=1:length(x)
    plot([x(i) e_x(i)],[y(i) e_y(i)],'k')
    
end
sqx=[-10 -10 10 10];sqy=[7.5 -7.5 -7.5 7.5];
line([sqx,-10],[sqy,7.5])
axis equal;axis([-14 14 -11 11])