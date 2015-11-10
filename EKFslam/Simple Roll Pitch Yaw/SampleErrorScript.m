
% x=-50:5.436:50;
% [X0,Y0,Z0]=meshgrid(x,x,x);

DD=[];
Dxyz=[];
Dh=[];

for i=1:1000
    X=randn(1:6);
    ant.x=X(1);
    ant.y=X(2);
    ant.z=X(3);
    ant.yaw=X(4);
    ant.pitch=X(5);
    ant.roll=X(6);
    L=10*randn(3,1);
    
    h=Measurement_Model(X,L);
    world.landmarks(1,1:3)=L;
    XYZ=FastRaytrace(ant,world,1);
    
    DD(i,:)=(XYZ-h)';
    Dxyz(i,:)=XYZ';
    Dh(i,:)=h';
end
R=cov(DD)