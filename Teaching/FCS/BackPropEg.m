function[NumIters] = BackPropEg

% generate inital random training data
x=rand(3,25);   
t=GetTargetValues(x);

% generate random weight matrix
W=rand(2,3)-0.5;
Y=W*x;
Err=sum(sum((Y-t).^2))  % Calculate and output error

% Optional Bit: Make some new input vectors covering the range [0, 1]        
% evenly, so the behaviour of the algorithm over data ranges can be tested
NewX=[0:0.05:1;0:0.05:1;0:0.05:1];   
NewT=GetTargetValues(NewX);  

NumIters=0;                     % set a parameter to count algorithm iterations
PauseFlag=1;
while(Err>0.01)                 % while error greater than tolerance
    for j=randperm(size(x,2))     % go through data in random order
        [W,OldOutput]=UpdateWeights(W,x(:,j),t(:,j));       % Update weights
        
        Y=W*x;                  % Calculate new outputs

        % ADVANCED: if you wanted to put an activation function on the output it would go here
        % Y=1./(1-exp(Y)). 
        % However, you would also have to change the learning rule
        
        Err=sum(sum((Y-t).^2))  % Calculate and output error
        
        figure(1)
        ShowNetOuts(W,x,t);       % show the outputs for the training vectors
        if(PauseFlag)
            g=input('Press return to continue\nor 0 and return to stop pausing\n');
            if(g==0) PauseFlag=0; end;
        end
    end
    
    % show the outputs for the training vectors
    figure(1)
    ShowNetOuts(W,x,t);  
    
    % Optional bit part 2: plotting targets and outputs over the range of
    % the data
    figure(2)
    ShowNetOuts(W,NewX,NewT);   
    NumIters=NumIters+1
     

    % pause every other iteration
    if(mod(NumIters,3)==0) pause; end;
end
W

% function which returns the target values given a matrix of input vectors
function[t]=GetTargetValues(x)
% generate target values
t=[2 0 -0.5;0 -3 0]*x;         % standard targets  
% t=t + rand(size(t))*0.1-0.05;      % targets with added noise 
% t(2,:)=-3*(x(2,:).^2);          % targets with second row chnaged to -3x^2 


% function which updates the weights W given a training vector trainVec 
% and associated target vector targetVec. 
% Function returns new weights and and also the output for the old weights
% for plotting purposes
function[NewW, y]=UpdateWeights(W,trainVec,targetVec)
LearningRate=0.05;          % set learning rate: can be varied
y=W*trainVec;               % output for current weights
% Generate the matrix of weight changes 
DeltaW=-2*LearningRate*(y-targetVec)*trainVec';
NewW=W+DeltaW;          % Update the weights

% function to plot the output of the net and target values for a matrix 
% of outputs Y and targets T
function ShowNetOuts(W,x,T)

Y=W*x;              % generate outputs for current weights
plot(Y(1,:),Y(2,:),'bx')       % plot the outputs as blue crosses
hold on;            % hold the plot so that the data is not overwritten
plot(T(1,:),T(2,:),'ro')       % plot the targets as red circles
hold off;           % release the plot so that next plot command 
                    % causes data to disappear