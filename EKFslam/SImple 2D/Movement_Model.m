function [X,dfdX,dfdU]=Movement_Model(X,U)

% new estimated position
X=[X(1)+U(1),X(2)+U(2)];

% jacobian calculations
dfdX=[1,0;0,1];
dfdU=[1,0;0,1];
