function [h, dhdX,dhdY]=Measurement_Model(X,Y)

% estimated agent position
Xa=X(1);
Ya=X(2);
Ta=X(3);

% estimated landmark position
Xl=Y(1);
Yl=Y(2);

% estimated heading
h=atan2((Yl-Ya),(Xl-Xa))+Ta; 

% jacobian calculations
dhdX(1) = (Yl-Ya)/(Xl-Xa)^2/(1+(Yl-Ya)^2/(Xl-Xa)^2);
dhdX(2)  = -1/(Xl-Xa)/(1+(Yl-Ya)^2/(Xl-Xa)^2);
dhdX(3)= 1;
dhdY(1)  = -(Yl-Ya)/(Xl-Xa)^2/(1+(Yl-Ya)^2/(Xl-Xa)^2);
dhdY(2) = 1/(Xl-Xa)/(1+(Yl-Ya)^2/(Xl-Xa)^2);