function GasNetEGs(StartX,NumIters,ExtInput,C1,StartY,C2)
GasNetQu(StartX,C1,NumIters,ExtInput);
%GasNetQu2(StartX,StartY,C1,C2,NumIters,ExtInput)

% Main function for the GasNet question. Initial value is StartX, 
% number of iterations NumIters, ExtInput the external input and 
% C1 the default C-value
function GasNetQu(StartX,C,NumIters,ExtInput)

% **TO DO**: plot y=x and y=f(x) on the same graph
x=-2:0.01:2;

% Set the pause flag
PauseFlag=1;

% Initialise x-vector
xvec(1) = StartX;

for t=1:NumIters
    
    % **TO DO**: generate xvec(t+1) from xvec(t), C and ExtInput
    
    % Plot an iteration of the cobweb plot 
    plot([xvec(t) xvec(t) xvec(t+1)],[xvec(t) xvec(t+1) xvec(t+1)],'g--');
    
    % decide whether to pause or not
    if(PauseFlag)                       
        s=input('press enter to continue, 0 and enter to stop pausing\n');
        if(s==0) PauseFlag = 0; end;
    end
end
hold off;

% **TO DO**: and plot it against x in a new figure
TimeVector=[0:NumIterations];

% **TO DO**: function to iterate a GasNet neuron starting from x
% with external input ExtInput and C value C.
function[newx]=IterateGasNet(C,x,ExtInput)

% function to simulate 2 GasNet neurons
function GasNetQu2(StartX,StartY,C1,C2,NumIters,ExtInput)

% Set the pause flag
PauseFlag=1;

% Initialise x and y, variable input 
x(1) = StartX;
y(1) = StartY;

for t=1:NumIters
    
    % every 10 time-steps, set I to be ExtInput
    if(mod(t,10)==0) I = ExtInput;
    else I=0;
    end
    
    % ** TO DO **: Iterate both GasNet neurons
    % to get x(t+1) from x(t) and y(t+1) from y(t)       				   
    
    % Plot t vs x and t vs y and set the axes
    subplot(2,1,1)
    plot([t t+1],[x(t) x(t+1)],'r-x',[t t+1],[y(t) y(t+1)],'b:o');
    axis([0 NumIters -1 1]);
    hold on
    
    % Plot x vs y in the phase plan and set the axes
    subplot(2,1,2)
    plot([x(t) x(t+1)],[y(t) y(t+1)],'b-x');
    axis([-1.1 1.1 -1 1]);
    hold on
    
    % set whether to pause or not
    if(PauseFlag)                       
        s=input('press enter to continue, 0 and enter to stop pausing\n');
        if(s==0) PauseFlag = false; end;
    end
end

% turn the holds off each subplot
subplot(2,1,1)
hold off
subplot(2,1,2)
hold off

% TO DO**: function to iterate a GasNet neuron starting from y
% with C value C and inhibitory input from another neuron, x 
function[newy]=IterateGasNet2(C,y,x)
newy = tanh(C*(y-x));

% function to iterate an exponential growth equation 
% from time t to t+tstep starting from x.
% k is the growth constant
function[newx]=IterateExpGrowth(x,tstep,k)
% add tstep*dx/dt to x
newx = x + tstep*k*x;