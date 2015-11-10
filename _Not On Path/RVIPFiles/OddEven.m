% function[out] = OddEven(x)
% function returns 0 if x = 0, 1 if x is odd, 2 if x is even

function[out] = OddEven(x)

if(x==0) 
    out = 0;
elseif(mod(x,2)==1)
    out=1;
else
    out=2;
end
    