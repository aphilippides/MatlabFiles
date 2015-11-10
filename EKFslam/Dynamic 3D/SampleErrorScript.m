
% x=-50:5.436:50;
% [X0,Y0,Z0]=meshgrid(x,x,x);

DD=[];
Dxyz=[];
Dh=[];
X=randn(1:3);
for i=1:1000
    L=50*randn(3,1);
    
    h=Measurement_Model(X,L);
    world.landmarks(1,1:3)=L;
    XYZ=raytrace(ant,world,1);
    
    DD(i,:)=(XYZ-h)';
    Dxyz(i,:)=XYZ';
    Dh(i,:)=h';
end