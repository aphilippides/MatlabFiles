function[d2] = AlignCameras(Lref,imL,Rref,imR,n,refpoints,Pic)

r=refpoints(n,:);
[fL1,fL2,L3]=GetTransform(Lref,imL,n,refpoints,Pic);
if(Pic) figure; end;
[fR1,fR2,R3]=GetTransform(Rref,imR,n,refpoints,Pic);

for i=1:size(Lref,1)
    X(i,:) = GetXYZ(fL1,fL2,L3,Lref(i,:),fR1,fR2,R3,Rref(i,:));
end
d=(refpoints(:,1:3)-X)
d2=sqrt(sum(d.^2,2)');
%figure, 
%plot(dists)
% 

function[X] = GetXYZ(fL1,fL2,L3,XL,fR1,fR2,R3,XR)
xs3=XL(1)*L3(1:3);
ys3=XL(2)*L3(1:3);
xr3=XR(1)*R3(1:3);
yr3=XR(2)*R3(1:3);

LH=[(-fL1(1:3)+xs3)'; (-fL2(1:3)+ys3)'; (-fR1(1:3)+xr3)'; (-fR2(1:3)+yr3)'];
RH=[[fL1(4);fL2(4)]-XL';[fR1(4);fR2(4)]-XR'];
%X=LH\RH;
X=pinv(LH)*RH;