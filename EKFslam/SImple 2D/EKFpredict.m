function [X,P]=EKFpredict(U,X,P,Q)

% Estimate new position
 [Xnew,dfdX,dfdU]=Movement_Model(X(1:2),U);
 X(1:2)=Xnew;
 
 % Update covariance matrix
for i=1:2:length(P)-1
    P(i:i+1,1:2)=P(i:i+1,1:2)*dfdX';
    P(1:2,i:i+1)=dfdX*P(1:2,i:i+1);
end
P(1:2,1:2)=P(1:2,1:2)+Q*eye(2);