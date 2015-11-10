
% New strength function which gets out of problems at t=d=0

function [New_strength] = strengthlots(t,B)

%MAX_STREN = 1;
GLOBES;
global RISE;
global FALL;
global RISE_STEEP;
global FALL_STEEP;
FLAG = 0;
global NUM_SPIKES;
NUM_SPIKES = 4;

if B< (FALL+RISE)
	FALL = B/2.0;
	FLAG = 1;
end
B=B./NUM_SPIKES;	
leng = length(t);

for i=1:leng
FLAG = 0;
if FLAG == 0
if t(i) >=(B.*NUM_SPIKES)
	temp(i) = 0;
else
t(i) = mod(t(i),B);
if t(i)<=RISE
	temp(i) = (tanh((t(i)*2/RISE-1)*RISE_STEEP)-tanh(-RISE_STEEP))/(tanh(RISE_STEEP)*2);
elseif t(i)<=(FALL+RISE)
	temp(i) = (exp(-(t(i)-RISE)*FALL_STEEP/FALL)-exp(-FALL_STEEP))/(1-exp(-FALL_STEEP));
else
	temp(i) = 0;
end
end
else

fact = (tanh((FALL*2/RISE-1)*RISE_STEEP)-tanh(-RISE_STEEP))/(tanh(RISE_STEEP)*2);
if t(i)<=FALL
	temp(i) = (tanh((t(i)*2/RISE-1)*RISE_STEEP)-tanh(-RISE_STEEP))/(tanh(RISE_STEEP)*2);
elseif t(i)<=B
	temp(i) = (exp(-(t(i)-B+FALL)*FALL_STEEP/FALL)-exp(-FALL_STEEP))*fact/(1-exp(-FALL_STEEP));
else
	temp(i) = 0;
end

end

end
New_strength = temp;
