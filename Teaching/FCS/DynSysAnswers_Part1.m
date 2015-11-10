% Main function for questions 1 and 2 of dynamical systems problem sheet
% starting x and t are StartX and StartT respectively, 
% MaxT the length of simulation, h the timestep and tau the time delay

function DynSysAnswers_Part1(StartX,StartT,MaxT,h,tau)

% Initialise x and t
x(1) = StartX;
t(1) = StartT;
I(1) = ExternalInput(t(1));

% Set Pause flag to pause
PauseFlag=1;

% number of time steps (length of time)/(size of time step)
NumIters=MaxT/h;

for i=1:NumIters
     
     % evaluate t at the next time-step: 
     t(i+1) = t(i) + h;

     % Calculate x at the next time-step using x(i+1) = x(i) + h dx/dt
     x(i+1) = x(i) + (h/tau)*(-x(i) + I(i));
  
     % Calculate external input
     I(i+1) = ExternalInput(t(i+1));
   
    % plot the new points 
    plot(t,x,'b-',t,I,'r')  
    ylabel('x')
    xlabel('t')
    axis tight
    xlim([StartT MaxT])
    legend('output, x','input')
    
    % set whether to pause or not
    if(PauseFlag)                       
        r=input('press enter to continue, 0 and enter to stop pausing\n');
        if(r==0) PauseFlag = 0; end;
    end                             
end

% this function calculates the external input
% the outputs should be commented/uncommented to answer different elements
% of questions 1 and 2
function[I] = ExternalInput(t)
% % for first part of question 1
% I = t<=2;
% 
% for second part of question 1
I = sin(2*pi*t);
% 
% % for question 2
% I = 0;