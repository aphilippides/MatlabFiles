%%%%% Compute the nest ALV vector and ALV vector and number of
% objects seen from each point of the grid.
function[NObj,mx,my,Angle,AlvNumSteps,trapx,trapy]= ...
    Do_ALV(X,Y,obj,nest,NumAverage,Norm)

%%%%% Compute the nest ALV vector and ALV vector and number of objects
% seen from each point of the grid.
[NObj,mx,my,Nestmx,Nestmy]=ALVsForEnvironment(X,Y,obj,nest);

%%%%% Get the homing vectors
mx=mx-Nestmx;
my=my-Nestmy;

%%%%% Average or normalize the vectors according to the first two parameters
% ###### WARNING ###### if Norm=1 and if mx and my are zero, they will become NaN
% ###### WARNING ###### The meshgrid is here expected to be square
[mx,my]=Average_and_Norm(NumAverage,Norm,X,mx,my);

%%%%% Compute the homing vector accuracy : cosinus between  the
% homing vector and the true homing vector.
Angle = ( (mx.*(nest(1)-X) + my.*(nest(2)-Y) )./ ...
    (sqrt((mx.^2 + my.^2).*( (X-nest(1)).^2 +(Y-nest(2)).^2)) ));

%%%%% Compute the catchment area
AlvNumSteps=StartFromEachPos(X,Y,mx,my,nest) ;

%%%%% Find the points where the ant is trapped. This does not includes
% trapping areas bigger than one point.
[trapx trapy]=find(mx==0 & my==0);