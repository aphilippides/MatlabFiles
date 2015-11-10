function AntSimulation

rng('shuffle');

% get some initial starting positions
MaxSteps = 50;
OldPos=[0,0];
OldHeading=0;
AntPos(1,:)=[0 0];

% set the step length
StepSize=1;

for t=1:MaxSteps
    % sense
    Senses=0; % not currently sensing anything
    % Move as a random walk
    NewPos=MoveAntRandom(OldPos,StepSize,Senses);

    % Move as a correlated random walk
%     [NewPos,NewHeading]=MoveAntCorr(OldPos,OldHeading,StepSize);

    % put the positions in a matrix for plotting 
    AntPos=[AntPos;NewPos];
    plot(AntPos(:,1),AntPos(:,2),'k')
    axis equal
    OldPos=NewPos;
%     OldHeading=NewHeading;
    
end

% random walk, various options
% senses isn't used
function[NewPos]=MoveAntRandom(OldPos,StepSize,Senses)

% % random walk with DELIBERATE BUG
% rand_step=rand(1,2);

% % circular random walk of non-fixed length
% rand_step=rand(1,2)-0.5;

% circular random work of length step-size
[randx,randy]=pol2cart(rand*2*pi,StepSize);
rand_step=[randx,randy];

% update the new position
NewPos=OldPos+rand_step;

% correlated random walk
function[NewPos,NewHeading]=MoveAntCorr(OldPos,OldHeading, StepSize)

% add a random direction to the old heading
NewHeading=OldHeading+2*(rand-0.5);

% get this as a cartesian vector of length Stepsize
[randx,randy]=pol2cart(NewHeading,StepSize);
rand_step=[randx,randy];
NewPos=OldPos+rand_step;

