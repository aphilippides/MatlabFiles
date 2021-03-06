function DEs_Answers(StartVal,MaxT,tstep,k)
% 1 dimensional equations
FirstQus(StartVal,MaxT,tstep,k);

% Predator-prey question
% PredPreyQu(100,5,MaxT,tstep);

% Main function which calls the single variable functions
% for question with a single population only. Initial population
% level is StartVal,  MaxT the length of simulation, 
% and tstep the timestep 
function FirstQus(StartVal,MaxT,tstep,k)

% Initialise x 
x = StartVal;

% Set Pause flag to pause
PauseFlag=1;

% number of time steps (length of time)/(size of time step)
for t=0:MaxT/tstep
    
    % generate x at advanced time-step using the uncommented equation
    
%     newx = IterateExpGrowth(x,tstep,k);   
%     newx = IterateLimGrowth(x,tstep,k)
    newx = IterateCtrnn(x,t*tstep,tstep,k);   
   
    % plot the new points 
    plot([t t+1]*tstep,[x newx],'b-x')  
    hold on;
    
    % set whether to pause or not
    if(PauseFlag)                       
        r=input('press enter to continue, 0 and enter to stop pausing\n');
        if(r==0) PauseFlag = 0; end;
    end
    
    % update old x value
    x=newx;                             
end

% plot the external input to the ctrnn if appropriate
t=0:tstep:MaxT;
% plot(t,ExtInput(t),'r')
plot(t,sin(2*pi*t),'r')

hold off;
axis tight

% Main function for the predator-prey question
% initial values for prey and predator are held in StartX and 
% StartY respectively. MaxT is the length of simulation
% and tstep the timestep
function PredPreyQu(StartX,StartY,MaxT,tstep)
% Initialise x and y
x(1) = StartX;
y(1) = StartY;

tvec=[0:(ceil(MaxT/tstep)+1)-1]*tstep;

% Set Pause flag to pause
PauseFlag=1;

% number of time steps (length of time)/(size of time step)
for t=1:MaxT/tstep
    
    % iterate through the predator-prey equations storing the resultant
    % points in vectors for plotting
    [x(t+1), y(t+1)] = IterateLotkaVolterra(x(t),y(t),tstep);
    
    subplot(1,2,1),plot(tvec(1:t+1),x(1:t+1),'b',tvec(1:t+1),y(1:t+1),'r')
    xlim([0 20])
    subplot(1,2,2),plot(x(1:t+1),y(1:t+1))

    % set whether to pause or not
    if(PauseFlag)                       
        r=input('press enter to continue, 0 and enter to stop pausing\n');
        if(r==0) PauseFlag = 0; end;
    end

end

% generate a time vector and plot x and y against time and the phase plane
tvec=[0:length(x)-1]*tstep;
subplot(1,2,1),plot(tvec,x,'b',tvec,y,'r')
subplot(1,2,2),plot(x,y) 

% function to iterate a ctrnn neuron from time t to t+tstep
% starting from x. tconst is the time constant, ExtInput is
% External input to the neuron. Function would need to be 
% adjusted to include input from other neurons 
function[newx]=IterateCtrnn(x,t,tstep,tconst)
% add tstep*dx/dt to x
% newx = x + tstep*(-x+ ExtInput(t) )/tconst;
newx = x + tstep*(-x+ sin(2*pi*t))/tconst;

% function to generate time varying external input to the ctrnn
function[val]=ExtInput(t)
val = (t<=2);

% function to iterate an exponential growth equation 
% from time t to t+tstep starting from x.
% k is the growth constant
function[newx]=IterateExpGrowth(x,tstep,k)
% add tstep*dx/dt to x
newx = x + tstep*k*x;

% function to iterate an exponential growth equation with 
% growth limit from time t to t+tstep starting from x.
% k is the growth constant
function[newx]=IterateLimGrowth(x,tstep,k)
% add tstep*dx/dt to x
newx = x+tstep*k*x*(1-x);

% function to iterate a lotka-volterra predator prey model
% x is the current prey population level, y the predator level 
% and tstep the time-step
function[newx, newy] = IterateLotkaVolterra(x,y,tstep)
% parameters
r = 0.6;    % growth rate for prey
a = 0.05;   % attack efficiency of predators
f = 0.1;    % rate at which predators turn prey into offspring
q = 0.4;    % starvation rate for predators

% equations
newx = x + tstep*(r*x - a*x*y);
newy = y + tstep*(f*a*x*y - q*y);