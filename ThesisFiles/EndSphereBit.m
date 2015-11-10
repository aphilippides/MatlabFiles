function[Endbit,yval]=EndSphereBit(R,a)

DrawSphere(R,2*a)
yval=sqrt(R^2-a^2)
Endbit=pi*(2*(R.^3)+a.^3-3.*a.*(R.^2))/3;
function DrawSphere(R,a)

V1=[0,0,0,0,0]-a/2;
V2=[0,0,a,a,0]-a/2;
V3=[0,a,a,0,0]-a/2;
plot3(V1,V2,V3);
hold on;
plot3(V1+a,V2,V3);
plot3(V2,V1,V3);
plot3(V2,V1+a,V3);
%[x,y,z]=sphere(20);
x=x*R;
y=y*R;
z=z*R;
[x,y,z]=circle(R,0)
plot3(x,y,0*ones(size(x)))
plot3(x,0*ones(size(x)),y)
plot3(0*ones(size(x)),x,y)
hold off

function[x,y,newz]=circle(r,z)
th=0:0.1:2.*pi;
[x,y,newz]=pol2cart(th,r,z)
