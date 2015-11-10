function GradientAscentEgTask2(Plotting)

% plot the landscape
DrawComplexLandscape

% Enter maximum number of iterations of the algorithm, learning rate and
% mutation range
NumSteps=50;
LRate=0.1;
MaxMutate=1;

if(Plotting) 
    % choose a random starting point
    StartPt=rand(1,2)*10-3;
    GradAscent(StartPt,NumSteps,LRate,Plotting);
    HillClimb(StartPt,NumSteps,MaxMutate,Plotting);
else
    NumFoundGrad=0;
    NumFoundHill=0;
    SumTimesGrad=0;
    SumTimesHill=0;
    
    % go thru grid of points
    GridPoints=-3:0.25:7;
    for i = 1:length(GridPoints)
        for j = 1:length(GridPoints)
            % Set the start point
            StartPt=[GridPoints(i) GridPoints(j)];
            
            % Do gradient ascent and hill climb
            MaxOrNotGrad(i,j)= GradAscent(StartPt,NumSteps,LRate,Plotting);
            MaxOrNotHill(i,j) = HillClimb(StartPt,NumSteps,MaxMutate, Plotting);
        end
    end
    
    % Calculate mean height reached
    Mean_Grad = mean(mean(MaxOrNotGrad))
    Mean_Hill = mean(mean(MaxOrNotHill))

    % Do pseudocolor plots of all times and whether max was reached 
    subplot(1,2,1); pcolor(GridPoints,GridPoints,MaxOrNotGrad); colorbar;
    xlabel('x'),ylabel('y'),title('Grad Ascent: Max reached')

    subplot(1,2,2); pcolor(GridPoints,GridPoints,MaxOrNotHill); colorbar;
    xlabel('x'),ylabel('y'),title('Hill climb: Max reached')
end

% function which implements gradient ascent given a row vector as starting
% point, the maximum number of iterations, learning rate and a flag to say
% whether to plot or not
function[MaxHt] = GradAscent(StartPt,NumSteps,LRate,Plotting)
% if we are doing lots of evaluations and not plotting, turn pause off
if(Plotting) PauseFlag=1;
else PauseFlag=0;
end
hold on;

for i = 1:NumSteps
    % Calculate the 'height' at StartPt using SimpleLandscape
    ht=ComplexLandscape(StartPt(1),StartPt(2));

    % If plotting, plot a point on the landscape in 3D 
    if(Plotting) plot3(StartPt(1),StartPt(2),ht,'r*','MarkerSize',10); end;

    % Calculate the gradient at StartPt
    G=ComplexLandscapeGrad(StartPt(1),StartPt(2));
        
    % Calculate the new point and update StartPoint
    StartPt=StartPt+LRate*G;
    
    % Pause to view output
    if(PauseFlag)
        x=input('Press return to continue\nor 0 and return to stop pausing\n');
        if(x==0) PauseFlag=0; end;
    end
end
MaxHt=ht;
hold off

% function which implements hill-climbing given a row vector as starting
% point, the maximum number of iterations, Mutation range and a flag to say
% whether to plot or not
function[MaxHt] =  HillClimb(StartPt,NumSteps,MaxMutate,Plotting)
if(Plotting) PauseFlag=1;
else PauseFlag=0;
end
hold on;

for i = 1:NumSteps
    % Calculate the height of StartPt and plot in 3d if plotting
    ht=ComplexLandscape(StartPt(1),StartPt(2));
    if(Plotting) plot3(StartPt(1),StartPt(2),ht,'b*','MarkerSize',10); end;
        
    % if at the max, set values and exit loop
    if(ht==4) 
        MaxOrNot=1;
        break
    end

    % Mutate StartPt
    NewPt=Mutate(StartPt,MaxMutate);
    
    % Calculate the height of the new pt 
    ht2=ComplexLandscape(NewPt(1),NewPt(2));

    % decide whether to update StartPt or Not or not
    if(ht2>=ht) StartPt=NewPt; end

    % Pause to view output
    if(PauseFlag)
        x=input('Press return to continue\nor 0 and return to stop pausing\n');
        if(x==0) PauseFlag=0; end;
    end
end
MaxHt=ht;
hold off

% TO DO: Mutation function
% Returns a mutated point given the old point and the range of mutation
function[NewPt] = Mutate(OldPt,MaxMutate)
% select a random distance to mutate in the range (-MaxMutate,MaxMutate)
MutDist=rand*2*MaxMutate-MaxMutate;

% randomly choose which element of OldPt to mutate by MutDist
NewPt=OldPt;
if(rand<0.5) NewPt(1)=NewPt(1)+MutDist;
else NewPt(2)=NewPt(2)+MutDist;
end

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