function [X,P]=EKFpredict(U,X,P,Q,dt)

% Estimate new position
 [Xnew,dfdX,dfdU]=Movement_Model(X(1:4),U,dt);
 X(1:4)=Xnew;
 
 % Update covariance matrix
for i=1:2:length(P)-1
    P(i:i+1,1:4)=P(i:i+1,1:4)*dfdX';
    P(1:4,i:i+1)=dfdX*P(1:4,i:i+1);
end
P(1:4,1:4)=P(1:4,1:4)+dfdU*Q*dfdU';