% function used for the demos in lecture 7 based on the difference
% equations made for seminar 6
% typeflag sets which equation to use (1=exponential growth, anything else
% signals limited exponential growth), StartVal is the initial value of the
% system, PVal is the amount of the initial perturbation and k is the
% growth-rate
% eg for the 1st demo I typed: Lecture7_DEDemos(1,0,0.01,2)

function Lecture7_DEDemos(typeflag,StartVal,PVal,k)
tstep=0.1;
MaxT=2.9;
% Initialise x 
x = StartVal;
% Set Pause flag to pause
PauseFlag=false;
% number of time steps (length of time)/(size of time step)
mov = avifile('DEDemo4.avi','fps',3,'Compression','None')
for t=0:MaxT/tstep
    if(typeflag==1)                            % set whether its exponential growth or limited exponential growth
        newx = IterateExpGrowth(x,tstep,k);   % generate x at advanced
    else
        newx = IterateLimGrowth(x,tstep,k);
    end
    if (t==10)                      % after 10 steps 
        newx=x+PVal;                     % perturb x
        plot([t+1 t+1]*tstep,[x newx],'b-o','LineWidth',2)    % plot the perturbed x as a blue circle
    else    
        plot([t t+1]*tstep,[x newx],'r-x','LineWidth',2)  % plot the new points
        
    end
    axis([0 MaxT min(-0.1,newx) 1.2])                  % set the axis limits
    hold on;
    if(PauseFlag)                       % set whether to pause or not
        if (t==10)                      % after 10 steps 
            r=input('perturb fixed point'); % pause for effect
            pause
        else
            r=input('press enter to continue, 0 and enter to stop pausing\n');  
        end
        if(r==0) PauseFlag = false; end;        % stop pausing
    end
    F = getframe(gca);
    mov = addframe(mov,F);
    x=newx;  % update old x value    
end
hold off;
mov = close(mov);

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