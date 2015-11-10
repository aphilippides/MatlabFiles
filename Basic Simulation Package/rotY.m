function [X,Y,Z]=rotY(X,Y,Z,TH)

rY=[cos(TH),0,sin(TH);...
    0,1,0;...
    -sin(TH),0,cos(TH)];

xyz=[X(:),Y(:),Z(:)]*rY;

X=reshape(xyz(:,1)',size(X));
Y=reshape(xyz(:,2)',size(Y));
Z=reshape(xyz(:,3)',size(Z));