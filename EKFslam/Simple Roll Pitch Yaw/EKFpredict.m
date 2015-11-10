function [X,P]=EKFpredict(U,X,P,Q)
dimX=6;
dimL=3;

dimLminus1=dimL-1;

% Estimate new position
 [Xnew,dfdX,dfdU]=Movement_Model(X(1:dimX),U);
 X(1:dimX)=Xnew;
 
 % Update covariance matrix
for i=1:dimL:length(X)-dimLminus1
    P(i:i+dimLminus1,1:dimX)=P(i:i+dimLminus1,1:dimX)*dfdX';
    P(1:dimX,i:i+dimLminus1)=dfdX*P(1:dimX,i:i+dimLminus1);
end
P(1:dimX,1:dimX)=P(1:dimX,1:dimX)+Q*eye(dimX);