function[d,tn]=Ang2Nest(rad,th,p,sp)

a=1;
b=2*p(1)*cos(th)+2*p(2)*sin(th);
c=sum(p.^2)-rad^2;

r1=(-b+sqrt(b^2-4*a*c))/(2*a);
r2=(-b-sqrt(b^2-4*a*c))/(2*a);
x=[r1 r2]*cos(th)+p(1);
y=[r1 r2]*sin(th)+p(2);

[xs,ys]=pol2cart([th,th+pi],30);
xs=xs+p(1);ys=ys+p(2);
d=CartDist([x' y'],sp);
[m,i]=min(d);
x=x(i);
y=y(i);
tn=cart2pol(x,y);
d=AngularDifference(tn,th)*180/pi;

t=0:.1:2*pi;
% plot(rad*cos(t),rad*sin(t),p(1),p(2),'rx',xs,ys,[0 x],[0 y],'r-s',sp(1),sp(2),'go')
