function [X,dfdX,dfdU]=Movement_Model(X,U)

% new estimated position
X=X+U;

% jacobian calculations
dfdX=eye(3);
dfdU=eye(3);
