% function to try out various loops 

function LoopExamples
% ForLoopEg1
% ForLoopEg2
WhileLoopEg

% an example showing a for loop
function ForLoopEg1

% define an empty matrix, LowNums to put data in
LowNums=[];

% do the following loop for i from 1 to 10
for i=1:10
    
    % test if i is less than 5. If so, put it in LowNums    
    if(i<5) 
        LowNums=[LowNums i]
    end
end


% an example showing the same loop running backwards
function ForLoopEg2

% define an empty matrix, LowNums to put data in
LowNums=[];

% do the following loop for i from 10 to 1
for i=10:-1:1
    
    % test if i is less than 6. If so, put it in LowNums 
    % if i equals 2, break out of the loop   
    if(i==2)		% note the double == to test for equality
        break;
    elseif(i<5) 
        LowNums=[LowNums i]
    end
end


% an example showing a while loop 
function WhileLoopEg

% define an empty matrix, SomeNums to put data in
SomeNums=[];

% initialise i so that the while loop is entered
i=0;

% do the following while loop 
while(i<10)
    
    % test i and do different things depending on its value    
    if(i<5) 
        SomeNums=[SomeNums i]
    else
        SomeNums=[SomeNums 10*i]
    end 
    
    % add 1 to i, otherwise we will be stuck in an infinite loop!
    i=i+1;
end
