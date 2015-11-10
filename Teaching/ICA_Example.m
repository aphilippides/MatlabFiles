function ICA_Example(n)

y=-1:.01:1;
plot(y,ICA_Activ(y));
if nargin<1 n=65000; end;

t=0:1e-4:n*1e-4;

u(1,:) = 0.1.*sin(400.*t).*cos(30.*t);
u(2,:) = 0.001.*sign(sin(500.*t + 9.*cos(40.*t)));
u(3,:) = 2.*rand(size(t)) - 1;

figure;
subplot(3,1,1),plot(t,u(1,:)); 
subplot(3,1,2),plot(t,u(2,:)); 
subplot(3,1,3),plot(t,u(3,:)); 

A=[0.56 .79 -.37; -0.75 0.65 0.86; 0.17 0.32 -0.48]
x=A*u;
figure;
subplot(3,1,1),plot(t,x(1,:)); 
subplot(3,1,2),plot(t,x(2,:)); 
subplot(3,1,3),plot(t,x(3,:)); 

Tol=0.000;
change=100;
Iter=0;
eta = 0.1;
%W=0.05.*rand(3,3);
W=[0.0109 0.034 0.026;0.0024 0.0467 0.0415;0.0339 0.0192 0.0017]
while((change>Tol)&(Iter<300))
    y=W*x;
    max(max(y))
    UpdateW=eta.*(eye(size(W)) - ((ICA_Activ(y)./n)*y'))*W;
    W=W+UpdateW;        
    Iter=Iter+1
    change=sum(sum(abs(UpdateW)));
end
%W=[0.2222 .0294 -.6213;-10.19 -9.81 -9.72; 4.12 -1.788 -6.3765];
W*A
W
y=W*x;
figure;
subplot(3,1,1),plot(t,y(1,:)); 
subplot(3,1,2),plot(t,y(2,:)); 
subplot(3,1,3),plot(t,y(3,:)); 

function[Act] = ICA_Activ(y)

Act=0.5.*(y.^5)+(2./3).*(y.^7)+(15./2).*(y.^9)+(2./15).*(y.^11)-(112./3).*(y.^13)+128.*(y.^15)-(512./3).*(y.^17);