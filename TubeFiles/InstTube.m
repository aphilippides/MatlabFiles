% Function which calculates the concentration at a distance r from a
% solid tube of outer radius 'a' source of NO at a time t 
% after an instantaneous burst of synthesis at t=0

function [concient,Err,Limit] = InstTube(t,r,a,Eps,NLim)

GLOBE;

global STRENGTH_VOLSEC; 

if(t==0)
   if(r<a)
      concient=STRENGTH_VOLSEC;
      Err=0;
      Limit=0;
   elseif(r==a)
      concient=STRENGTH_VOLSEC*0.5;
      Err=0;
      Limit=0;
   else
      concient=0;
      Err=0;
      Limit=0;
   end
else
   Err=0;
   Limit=0;
   %[concient,Err,Limit]=TrapIntRing('InstRing',0,a,r,t,Eps,NLim,0);
   Eps=min(1e-3,Eps);
   concient=quad8('InstRing',0,a,Eps,[],r,t);
end
