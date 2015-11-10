% This is a comments line. Use % to comment things out
% Function to add and take away 2 numbers a and b

function[TheSum,TheDifference] = FunctionExample(a, b)  

TheSum = a + b; 
TheDifference = a - b; 
% TheSum = SubFunctionSum(a,b)

% Sub function that sums 2 numbers
function[s] = SubFunctionSum(a,c)
s = a + c;