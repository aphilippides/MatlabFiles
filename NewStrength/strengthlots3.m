
% New strength function which gets out of problems at t=d=0

function [New_strength] = strengthlots(t,B)

%MAX_STREN = 1;
GLOBES;
global RISE;
global FALL;
global RISE_STEEP;
global FALL_STEEP;

global NUM_SPIKES;

B=B./NUM_SPIKES;	
leng = length(t);

for i=1:leng

if t(i) >= (B.*NUM_SPIKES)
	temp(i) = 0;
else
t(i) = mod(t(i),B);
if t(i)<=0.05
	temp(i) = 1;
else
	temp(i) = 0;
end
end
end
New_strength = temp;
