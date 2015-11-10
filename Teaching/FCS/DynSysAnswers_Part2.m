% DynSysAnalysis_Answers(StartX,NumIters,ExtInput,C1,StartY,C2)
% model answer for topics 7 and 8: dynamical systems analysis of discrete
% dynamical systems. StartX is the initial value of the system, NumIters
% the number of iterations (also used to specify the time for the
% exponential growth equation), ExtInput external neural input (and
% step-size for exponential growth), C1 C- value for the 1st GasNet 
% (and growth rate for exponential growth). StartY and C2 are initial value
% and C-value for the 2nd GasNet neuron when 2 neurons are used

function DynSysAnswers_Part2(StartX,NumIters,ExtInput,C1,StartY,C2)

GasNetQu(StartX,C1,NumIters,ExtInput);
%GasNetQu2(StartX,StartY,C1,C2,NumIters,ExtInput)

% Main function for the GasNet question. Initial value is StartX, 
% number of iterations NumIters, ExtInput the external input and 
% C1 the default C-value
function GasNetQu(StartX,C,NumIters,ExtInput)

% plot y=x and y=f(x) on the same graph and plot y = f'(x)
x=-2:0.01:2;
subplot(2,1,2),plot(x,C*(sech(C*x)).^2)
title(['y=f''(x) = ' num2str(C) '(sech(' num2str(C) 'x))^2'],'FontSize',14)
xlabel('x','FontSize',14)
ylabel('y','FontSize',14)
subplot(2,1,1),plot(x,x,'r:',x,tanh(C*(x+ExtInput)));
title(['y=x (red) and y = f(x) = tanh(' num2str(C) 'x) (blue)'],'FontSize',14)
xlabel('x','FontSize',14);
ylabel('y','FontSize',14)
disp('press any key to continue')
pause

% plot y=x and y=f(x) for the cobweb plot
figure
subplot(1,2,1),plot(x,x,'r:',x,tanh(C*(x+ExtInput)));
title(['Cobweb plot for y = tanh(' num2str(C) 'x)'],'FontSize',14)
xlabel('x','FontSize',14);
ylabel('y','FontSize',14)
hold on;

% Set the pause flag
PauseFlag=1;

% Initialise x-vector, gas concentration and variable C value
xvec(1) = StartX;
GasConc=0;
CVal=C;

for t=1:NumIters
    
    % if x>0.95 reset the gas concentration
    % else increment the gas conc
%     if(xvec(t)>0.955) GasConc = 0; 
%     else GasConc=GasConc+1;
%     end;
    
    % if gas has built up for 5 time-steps set C=-2
%     if(GasConc>=5) CVal=-2;
%     else CVal=C;
%     end
    
    % **TO DO**: generate xvec(t+1) value from xvec(t)
    xvec(t+1)=IterateGasNet(CVal,xvec(t),ExtInput); 
    
    % Plot an iteration of the cobweb plot 
    plot([xvec(t) xvec(t) xvec(t+1)],[xvec(t) xvec(t+1) xvec(t+1)],'g--');
    
    % decide whether to pause or not
    if(PauseFlag)                       
        s=input('press enter to continue, 0 and enter to stop pausing\n');
        if(s==0) PauseFlag = 0; end;
    end
end
hold off;

% **TO DO**: plot t against x in a new figure
t=[0:NumIters];
subplot(1,2,2),plot(t,xvec)
title(['x over time for C = ' num2str(C)],'FontSize',14)
xlabel('time','FontSize',14);
ylabel('x','FontSize',14)

% **TO DO**: function to iterate a GasNet neuron starting from x
% with external input ExtInput and C value C.
function[newx]=IterateGasNet(C,x,ExtInput)
newx = tanh(C*(x+ExtInput));

% function to simulate 2 GasNet neurons
function GasNetQu2(StartX,StartY,C1,C2,NumIters,ExtInput)

% plot y=x and y=f(x) on one graph; y=x and y=g(x) on another
% at the fixed point 
x=-2:0.01:2;
plot(x,x,'b',x,tanh(C1*x),'r',x,tanh(C2*(x-0)),'g')
title('Fixed points for  neuron A (red) and neuron B (green)','FontSize',14)
figure

% Set the pause flag
PauseFlag=1;

% Initialise x and y, variable input and variable C value
x(1) = StartX;
y(1) = StartY;
I = ExtInput;
CVal=C2;

for t=1:NumIters
    
    % every 10 time-steps, set I to be ExtInput
%     if(mod(t,10)==0) I = ExtInput;
%     else I=0;
%     end
     
    % Every 5 time-steps set variable C value to -2   
%     if(mod(t,5)==0) CVal=-1.2;
%     else CVal=C2;
%     end
    
    % ** TO DO **: Iterate both GasNet neurons       				   
    x(t+1)=IterateGasNet(C1,x(t),I);  
    y(t+1)=IterateGasNet2(CVal,y(t),x(t));
    
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
        if(s==0) PauseFlag = 0; end;
    end
end

% turn the holds off each subplot and do titles and labels
subplot(2,1,1)
title('x (red) and y (blue) over time','FontSize',14)
xlabel('time','FontSize',14);
ylabel('Output','FontSize',14)
hold off

subplot(2,1,2)
title('phase plane portrait of x vs y','FontSize',14) 
xlabel('x','FontSize',14);
ylabel('y','FontSize',14)
hold off

% TO DO**: function to iterate a GasNet neuron starting from y
% with C value C and inhibitory input from another neuron, x 
function[newy]=IterateGasNet2(C,y,x)
newy = tanh(C*(y-x));