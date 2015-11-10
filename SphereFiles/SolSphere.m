% Function which returns the concenttration at time =Tim;dist =d
% for a solid sphere of radii: Out,burst length=Burst
% Time in seconds, distance in microns. 
% Function call: SolSphere(Out,Tim,d,Burst)

function[sphere_conc] = SolSphere(Out,Tim,d,Burst)

PT_SMTIME = 0.001;
GLOBE
global SPHE_OUT;

SPHE_OUT=Out;
if(abs(d)<eps) d= eps; end
if(abs(Tim)<eps) Tim= eps; end
if Tim <= Burst
   if Tim <PT_SMTIME
      sphere_conc = my_spheint(Tim,d, Out);
   else		
      sphere_conc = quad8('InstSolSphere',PT_SMTIME,Tim,[],[],d)+my_spheint(PT_SMTIME,d, Out);
   end
else
   temp2 = Tim - Burst;
   if temp2 <PT_SMTIME
      sphere_conc = my_spheint(PT_SMTIME,d, Out)-my_spheint(temp2,d,Out)+quad8('InstSolSphere',PT_SMTIME,Tim,[],[],d);
   else
      sphere_conc=quad8('InstSolSphere',temp2,Tim,[],[],d);
   end
end
sphere_conc = sphere_conc.*0.00331;