% function which performs gradient ascent and hillclimbing on a simple
% landscape. The argument Plotting is 0 or non-zero. If non-zero it
% performs gradient ascent and hill-climbing starting from a random point.
% If zero it uses a grid of points to start from and produces summary
% results graphs

function GradientAscentEgTask1(Plotting)

% plot the landscape
ezmesh(@SimpleLandscape,[-2 2],[-2 2])

% Enter maximum number of iterations of the algorithm, learning rate and
% mutation range
NumSteps=50;
LRate=0.1;
MaxMutate=1;

if(Plotting) 
    % choose a random starting point
    StartPt=rand(1,2)*4-2;
    GradAscent(StartPt,NumSteps,LRate,Plotting);
    HillClimb(StartPt,NumSteps,MaxMutate,Plotting);
else
    NumFoundGrad=0;
    NumFoundHill=0;
    SumTimesGrad=0;
    SumTimesHill=0;
    
    % go thru grid of points
    GridPoints=-2:0.25:2;
    for i = 1:length(GridPoints)
        for j = 1:length(GridPoints)
            % Set the start point
            StartPt=[GridPoints(i) GridPoints(j)];
            
            % Do gradient ascent, storing the time if a max is reached
            [MaxOrNotGrad(i,j),GradTimes(i,j)] = GradAscent(StartPt,NumSteps,LRate,Plotting);
            if(MaxOrNotGrad(i, j)) SumTimesGrad = SumTimesGrad + GradTimes(i,j); end

            % Do hill climb, storing the time if a max is reached
            [MaxOrNotHill(i,j),HillTimes(i,j)] = HillClimb(StartPt,NumSteps,MaxMutate, Plotting);
            if(MaxOrNotHill(i, j)) SumTimesHill = SumTimesHill + HillTimes(i,j); end
        end
    end
    
    % Calculate percentages of points that got to maximum
    PerCentAtMax_Grad = 100*sum(sum(MaxOrNotGrad))/(length(GridPoints)^2)
    PerCentAtMax_Hill = 100*sum(sum(MaxOrNotHill))/(length(GridPoints)^2)

    % Calculate mean length of time to the maximum. 
    MeanTime_Grad = SumTimesGrad/sum(sum(MaxOrNotGrad))
    MeanTime_Hill = SumTimesHill/sum(sum(MaxOrNotGrad))

    % Do pseudocolor plots of all times and whether max was reached 
    subplot(2,2,1); pcolor(GridPoints,GridPoints,MaxOrNotGrad);
    xlabel('x'),ylabel('y'),title('Grad Ascent: Max reached')

    subplot(2,2,2); pcolor(GridPoints,GridPoints,MaxOrNotHill);
    xlabel('x'),ylabel('y'),title('Hill climb: Max reached')
    
    subplot(2,2,3); pcolor(GridPoints,GridPoints,GradTimes); colorbar; 
    xlabel('x'),ylabel('y'),title('Grad Ascent: Search Times')

    subplot(2,2,4); pcolor(GridPoints,GridPoints,HillTimes); colorbar;
    xlabel('x'),ylabel('y'),title('Hill Climb: Search Times')    
end

% function which implements gradient ascent given a row vector as starting
% point, the maximum number of iterations, learning rate and a flag to say
% whether to plot or not
function[MaxOrNot,TimeToMax] = GradAscent(StartPt,NumSteps,LRate,Plotting)
% if we are doing lots of evaluations and not plotting, turn pause off
if(Plotting) PauseFlag=1;
else PauseFlag=0;
end
hold on;
MaxOrNot=0;

for i = 1:NumSteps
    % Calculate the 'height' at StartPt using SimpleLandscape
    ht=SimpleLandscape(StartPt(1),StartPt(2));
    
    % If plotting, plot a point on the landscape in 3D 
    if(Plotting) plot3(StartPt(1),StartPt(2),ht,'r*','MarkerSize',10); end;
    
    % if at the max, set values and exit loop
    if(ht==4)
        MaxOrNot=1;
        break
    end

    % Calculate the gradient at StartPt
    G=SimpleLandscapeGrad(StartPt(1),StartPt(2));
    
    % Calculate the new point and update StartPoint
    StartPt=StartPt+LRate*G;
    
    % Make sure StartPt is within the specified bounds
    StartPt=max([StartPt;-2 -2]);
    StartPt = min([StartPt;2 2]);
    
    % Pause to view output
    if(PauseFlag)
        x=input('Press return to continue\nor 0 and return to stop pausing\n');
        if(x==0) PauseFlag=0; end;
    end
end
TimeToMax=i;
hold off

% function which implements hill-climbing given a row vector as starting
% point, the maximum number of iterations, Mutation range and a flag to say
% whether to plot or not
function[MaxOrNot,TimeToMax] =  HillClimb(StartPt,NumSteps,MaxMutate,Plotting)
if(Plotting) PauseFlag=1;
else PauseFlag=0;
end
hold on;
MaxOrNot=0;

for i = 1:NumSteps
    % Calculate the height of StartPt and plot in 3d if plotting
    ht=SimpleLandscape(StartPt(1),StartPt(2));
    if(Plotting) plot3(StartPt(1),StartPt(2),ht,'b*','MarkerSize',10); end;
        
    % if at the max, set values and exit loop
    if(ht==4) 
        MaxOrNot=1;
        break
    end

    % Mutate StartPt
    NewPt=Mutate(StartPt,MaxMutate);
    
    % Make sure NewPt is within the specified bounds
    NewPt = max([NewPt;-2 -2]);
    NewPt = min([NewPt;2 2]);
    
    % Calculate the height of the new pt 
    ht2=SimpleLandscape(NewPt(1),NewPt(2));

    % decide whether to update StartPt or Not or not
    if(ht2>=ht) StartPt=NewPt; end

    % Pause to view output
    if(PauseFlag)
        x=input('Press return to continue\nor 0 and return to stop pausing\n');
        if(x==0) PauseFlag=0; end;
    end
end
TimeToMax=i;
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