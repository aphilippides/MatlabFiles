% function [concient,Err,Limit] = Tube(r,t,a,Burst,Eps,NLim)
% Function which calculates the concentration at a distance r from a
% solid tube of outer radius 'a' source of NO at a time t 
% during or after a burst of synthesis of length Burst

function [concient,Err,Limit] = Tube(r,t,a,Burst,Eps,NLim)

Err=0;
Limit=0;
if(t<=Burst)
   [concient,Err,Limit]=TrapInt('InstTube',0,t,r,a,Eps,NLim,0);
   %concient=quad8('InstTube',0,t,Eps,[],r,a,Eps,NLim);
else 
   [concient,Err,Limit]=TrapInt('InstTube',t-Burst,t,r,a,Eps,NLim,0);
end