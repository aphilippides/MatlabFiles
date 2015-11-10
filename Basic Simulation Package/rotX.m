function [X,Y,Z]=rotX(X,Y,Z,TH)

rX=[1,0,0;...
    0,cos(TH),-sin(TH);...
    0,sin(TH),cos(TH)];

xyz=[X(:),Y(:),Z(:)]*rX;

X=reshape(xyz(:,1)',size(X));
Y=reshape(xyz(:,2)',size(Y));
Z=reshape(xyz(:,3)',size(Z));