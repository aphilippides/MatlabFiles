% function demonstrating 2 ways of pausing while plotting
% run it to see IterativePlotEG1, then comment line 7 and uncomment line 8
% to run IterativePlotEG2. 
% NB You can also 'pause' in programs by setting a debugging breakpoint 

function PlottingExamples

IterativePlotEG1
% IterativePlotEG2

function IterativePlotEG1

% Specify starting point
yold=10;
told=0;

% Generate a vector of time points at which we want to observe the system
TimeVec=1:10;
for t=TimeVec
    
    % generate the new y point
    ynew = sin(2*t)-yold;
    
    % plot a line from coordinates (told,yold) to (yold,ynew)
    plot([told t],[yold ynew],'b-x')
    
    % Set the axis limits so that each plot has the same limits. 
    % In this case we don't know the y-limits so I'll guess at -10 to 10
    % comment this line out to see the behaviour without it
    axis([0 10 -10 10])
    
    % set axis labels
    xlabel('Time')
    ylabel('y')
    
    % hold the plot
    hold on
    
    % set the new point to be the old point 
    yold=ynew;
    told=t;
    
    % display the string shown
    disp('Press any key to continue')
    
    % wait for a key to be pressed
    pause
end
% release the plot so that when you next call it it starts again
hold off

function IterativePlotEG2

yold=10;
told=0;
TimeVec=0.05:0.05:10;

%Set a flag saying whether to pause or not
PauseFlag=1;
for t=TimeVec
    ynew = sin(2*t)-yold;
    plot([told t],[yold ynew],'b-x')
    axis([0 10 -11 11])
    xlabel('Time')
    ylabel('y')
    hold on
    yold=ynew;
    told=t;
    
    if(PauseFlag)
        
        % display the string shown, wait for user input and store it in x
        x=input('Press return to continue\nor 0 and return to stop pausing\n');

        % if x is 0, set PauseFlag to 0 and skip the request for user input
        if(x==0) PauseFlag=0; end;
    end
end
% release the plot so that when you next call it it starts again
hold off
