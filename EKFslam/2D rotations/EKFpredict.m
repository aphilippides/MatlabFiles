function [X,P]=EKFpredict(U,X,P,Q)

% Estimate new position
 [Xnew,dfdX,dfdU]=Movement_Model(X(1:3),U);
 X(1:3)=Xnew;
 
 % Update covariance matrix
for i=1:3:length(P)-1
    P(i:i+1,1:3)=P(i:i+1,1:3)*dfdX';
    P(1:3,i:i+1)=dfdX*P(1:3,i:i+1);
end
P(1:3,1:3)=P(1:3,1:3)+Q*eye(3);