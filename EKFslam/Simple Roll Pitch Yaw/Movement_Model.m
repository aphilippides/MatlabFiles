function [X,dfdX,dfdU]=Movement_Model(X,U)

% new estimated position
X=X+U;

% jacobian calculations
dfdX=eye(6);
dfdU=eye(6);
