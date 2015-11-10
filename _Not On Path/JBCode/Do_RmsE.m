%%%%% Compute the rms error at each point of the grid and compute
% the homing vectors. The rms error is localy averaged with the eight
% neighbours
function[RmsE,mx,my,NumSteps,trapx,trapy]=Do_RmsE(X,Y,obj,nest)   

[RmsE,mx,my]=RmsEsForEnvironment(X,Y,obj,nest);

%%%%% Compute the catchment area
NumSteps=StartFromEachPos(X,Y,mx,my,nest) ;

[trapx,trapy]=find(mx==0 & my==0);