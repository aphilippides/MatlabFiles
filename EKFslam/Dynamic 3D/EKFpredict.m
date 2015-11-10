function [X,P]=EKFpredict(U,X,P,Q,dt)

% Estimate new position
 [Xnew,dfdX,dfdU]=Movement_Model(X(1:6),U,dt);
 X(1:6)=Xnew;
 
 % Update covariance matrix
for i=1:6:length(X)-1
    P(i:i+1,1:6)=P(i:i+1,1:6)*dfdX';
    P(1:6,i:i+1)=dfdX*P(1:6,i:i+1);
end
P(1:6,1:6)=P(1:6,1:6)+Q*eye(6);