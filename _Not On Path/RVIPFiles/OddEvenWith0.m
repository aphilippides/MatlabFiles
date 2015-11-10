% function[out] = OddEvenWith0(x)
% function returns 0 if x = 0, 1 if x is odd, 2 if x is even
% works for vector x but not matrix (as yet)

function[out] = OddEvenWith0(x)
i0=find(~x);
iodd=find(mod(x,2));
out=2*ones(size(x));
out(i0)=0;
out(iodd)=1;    