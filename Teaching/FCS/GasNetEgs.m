function GasNetEGs

% **TO DO**: set the pameters, C h length of simulation etc
% you can either write them in the m-file or pass them to the function as
% parameters


% **TO DO**: plot y=x and y=f(x) in figure 1
figure(1)

% **TO DO**: f'(x) in figure 2
figure(2)

% Set the pause flag
PauseFlag=1;

%  **TO DO**: Initialise x-vector and t-vector
xvec(1) 
tvec(1)

%  **TO DO**: calculate number of steps, NumIters, from length of
%  simulation and time-step h

for i=1:NumIters
    
    % **TO DO**: generate tvec(i+1) and xvec(i+1) from xvec(i), 
    % C and external input if there is any etc
    
    % Plot an iteration of the cobweb plot in figure 1
    figure(1),hold on
    plot([xvec(i) xvec(i) xvec(i+1)],[xvec(i) xvec(i+1) xvec(i+1)],'g--');

    % **TO DO**: Plot x and t in another figure eg figure 3
    
    % decide whether to pause or not
    if(PauseFlag)                       
        s=input('press enter to continue, 0 and enter to stop pausing\n');
        if(s==0) PauseFlag = 0; end;
    end
end
figure(1), hold off;
