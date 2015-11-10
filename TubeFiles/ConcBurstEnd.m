% function[EndConc,Err,Limit]= ConcBurstEnd(ConcAtT,t,Burst,diam,d)
% function used to calculate the concentration at a point d
% from the centre of a tube of diameter diam at a time t
% before the end of a burst of synthesis of duration Burst
% given that the concentration at d t (<Burst) seconds after 
% synthesis starts is ConcAtT
%
% Basically used to speed up calculations of concentrations
% during synthesis with a loop like:
% 
% ConcAtT = GetConcForT(1)FromSomewhere
% for i=2:length(Ts)
%   Conc(i) = ConcBurstEnd(ConcAtT,t(i-1),t(i),diam,d)
%   ConcAtT = Conc(i);
% end

function[EndConc,Err,Limit]= ConcBurstEnd(ConcAtT,t,Burst,diam,d)
   
Outer=diam*0.5;
[C E Limit]=Tube(d,Burst,Outer,Burst-t,5e-3,25);
EndConc=C*.00331+ConcAtT;
Err=E*.00331;