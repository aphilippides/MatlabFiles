function GradientAscentEg

% plot the landscape
ezmesh(@SimpleLandscape,[-2 2],[-2 2])

% Enter maximum number of iterations of the algorithm, learning rate and
% mutation range
NumSteps=50;
LRate=0.1;
MaxMutate=1;

% choose a random starting point
StartPt=rand(1,2)*4-2;

GradAscent(StartPt,NumSteps,LRate);
% HillClimb(StartPt,NumSteps,MaxMutate);

function GradAscent(StartPt,NumSteps,LRate)
PauseFlag=1;
hold on;
for i = 1:NumSteps
    % TO DO: Calculate the 'height' at StartPt using SimpleLandscape
    
    % TO DO: Plot a point on the landscape in 3D 
    % use plot3(x,y,z,,'r*','MarkerSize',10)
    % to get a marker you can see well

    % TO DO: Calculate the gradient at StartPt
    
    % TO DO: Calculate the new point and update StartPoint
    
    % Make sure StartPt is within the specified bounds
    StartPt=max([StartPt;-2 -2]);
    StartPt = min([StartPt;2 2]);
    
    % Pause to view output
    if(PauseFlag)
        x=input('Press return to continue\nor 0 and return to stop pausing\n');
        if(x==0) PauseFlag=0; end;
    end
end
hold off

function HillClimb(StartPt,NumSteps,MaxMutate)
PauseFlag=1;
hold on;
for i = 1:NumSteps
    % TO DO: Calculate the height of StartPt and plot it in 3d
    
    % Mutate StartPt
    NewPt=Mutate(StartPt,MaxMutate);
    
    % TO DO: Make sure NewPt is within the specified bounds
    
    % TO DO: Calculate the height of the new pt 
    
    % TO DO: decide whether to update StartPt or Not or not

    % TO DO: pause to view output
end
hold off

% TO DO: Mutation function
% Returns a mutated point given the old point and the range of mutation
function[NewPt] = Mutate(OldPt,MaxMutate)
% TO DO: select a random distance to mutate MutDist in the range 
% (-MaxMutate,MaxMutate)

% TO DO: randomly choose which element of OldPt to mutate 
% and mutate it by MutDist

% simple landscape function
% returns 'height' given (x,y) position
function[z] = SimpleLandscape(x,y)
z=max(1-abs(2*x),0)+x+y;

% gradient of simple landscape function
% returns gradient of SimpleLandscape given (x,y) position
function[g] = SimpleLandscapeGrad(x,y)
if(1-abs(2*x) > 0)
    if(x<0) g(1) = 3;
    elseif(x==0) g(1)=0;
    else g(1) = -1;
    end
else g(1)=1;
end
g(2)=1;

% Function which draws a complex landscape
function DrawComplexLandscape
f = ['4*(1-x)^2*exp(-(x^2) - (y+1)^2)' ... 
         '- 15*(x/5 - x^3 - y^5)*exp(-x^2-y^2)' ... 
         '- (1/3)*exp(-(x+1)^2 - y^2)' ...
        '-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2)'   ];

ezmesh(f,[-3,7])

% complex landscape function
% returns 'height' given (x,y) position
function[f]=ComplexLandscape(x,y)
f=4*(1-x)^2*exp(-(x^2)-(y+1)^2) -15*(x/5 - x^3 - y^5)*exp(-x^2-y^2) -(1/3)*exp(-(x+1)^2 - y^2)-1*(2*(x-3)^7 -0.3*(y-4)^5+(y-3)^9)*exp(-(x-3)^2-(y-3)^2);

% gradient of complex landscape function
% returns gradient of ComplexLandscape given (x,y) position
function[g]=ComplexLandscapeGrad(x,y)
g(1)=-8*exp(-(x^2)-(y+1)^2)*((1-x)+x*(1-x)^2)-15*exp(-x^2-y^2)*((0.2-3*x^2) -2*x*(x/5 - x^3 - y^5)) +(2/3)*(x+1)*exp(-(x+1)^2 - y^2)-1*exp(-(x-3)^2-(y-3)^2)*(14*(x-3)^6-2*(x-3)*(2*(x-3)^7-0.3*(y-4)^5+(y-3)^9));
g(2)=-8*(y+1)*(1-x)^2*exp(-(x^2)-(y+1)^2) -15*exp(-x^2-y^2)*(-5*y^4 -2*y*(x/5 - x^3 - y^5)) +(2/3)*y*exp(-(x+1)^2 - y^2)-1*exp(-(x-3)^2-(y-3)^2)*((-1.5*(y-4)^4+9*(y-3)^8)-2*(y-3)*(2*(x-3)^7-0.3*(y-4)^5+(y-3)^9));