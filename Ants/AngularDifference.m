% function[d] = AngularDifference(a,b)
% function to find the difference between angles a and b taking into
% account that the difference can't be greater than pi
%
% a and b must be the same sizr or 1 of them can be a aingle angle
%
% if only one argument is passed in, it does diff(a) and then ensures none
% of these differences are > pi
%
% *********************************************************
% at the moment returns straight difference
% possibly should be cahnged to do +ve if difference is anti-cwise and -ve
% if cwise, or possibly shoudl just be abs(d)

function[d] = AngularDifference(a,b)

if(nargin<2) d=diff(a);
else 
    if(size(a,1)~=size(b,1)) b=b'; end;
    d=a-b;
end
is = find(d>pi);
while(~isempty(is))
    d(is)=d(is)-2*pi;
    is = find(d>pi);
end;
is = find(d<-pi);
while(~isempty(is))
    d(is)=d(is)+2*pi;
    is = find(d<-pi);
end;