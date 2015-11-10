function Figs4DynSysLecture
twofig

function onefig
[X,Y]=meshgrid(0:0.1:1.4,0:0.1:0.9);
plot(X,Y,'b .')
hold on
seminar6_des(0.1,1.5,0.05,6)
xlabel('t','FontSize',14),ylabel('x','FontSize',14)

function twofig
[T,X]=meshgrid(-1:0.1:1.4,-1:0.1:0.9);
plot(T,X,'b .');
NewX=6*X.*(1-X);
NewY=tanh(-T)-X;
NewX=tanh(-X)-T;
quiver(T,X,NewX,NewY)
% hold on
% seminar6_des(0.1,1.5,0.05,6)
xlabel('t','FontSize',14),ylabel('x','FontSize',14)

function fig3

r = 0.6;    % growth rate for prey
a = 0.05;   % attack efficiency of predators
f = 0.1;    % rate at which predators turn prey into offspring
q = 0.4;    % starvation rate for predators
% equations
%[x,y]=meshgrid(0:20:200,0:5:50);
[x,y]=meshgrid(10:10:100,1:2:40);
newx = (r*x - a*x.*y);
newy = (f*a*x.*y - q*y);
ls=sqrt(newx.^2+newy.^2);
%dydx=newy./newx;
%u=ones(size(dydx));
quiver(x,y,newx./ls,newy./ls,0.2)
%quiver(x,y,newx,newy,2)
