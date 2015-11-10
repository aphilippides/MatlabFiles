% Function which calculates the whether or not the concentration at a distance r 
% from a solid tube of outer radius 'a' source of NO at a time t 
% during or after a burst of synthesis of length Burst is over a threshold
% Thresh

function [concient,Err,Limit] = ThreshTube(Thresh,r,t,a,Burst,Eps,NLim)

Err=0;
Limit=0;
if(t<=Burst)
   [concient,Err,Limit]=ThreshTubeTrapInt('InstTube',Thresh,0,t,r,a,Eps,NLim,0);
else 
   [concient,Err,Limit]=ThreshTubeTrapInt('InstTube',Thresh,t-Burst,t,r,a,Eps,NLim,0);
end