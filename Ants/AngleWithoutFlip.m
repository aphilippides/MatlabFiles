% function[newos] = AngleWithOutFlip(os)
%
% this function goes through a set of angles and where there is a 'flip' ie
% angle goes from eg pi to -pi, adds 2pi to the latter so that it looks
% more continuous for printing

function[newos] = AngleWithOutFlip(os)

d=diff(os);
k=find(abs(d)>=pi,1);
while(~isempty(k))
    if(d(k)>0) os(k+1:end) = os(k+1:end) -2*pi;
    else os(k+1:end) = os(k+1:end) +2*pi;
    end
    d=diff(os);
    k=find(abs(d)>pi,1);
end
m=mean(os);
s=floor(abs(m)/(2*pi))*2*pi;
if(m>0) newos = os-s;
else newos=os+s;
end
