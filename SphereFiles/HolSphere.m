% Function which returns the concenttration at time =Tim;dist =d
% for a hollow sphere of radii: inrad, outrad,burst length=Burst
% Time in seconds, distance in microns. 
% Function call: HolSphere(Inn,Out,Tim,d,Burst)

function[sphere_conc] = HolSphere(Inn,Out,Tim,d,Burst)

PT_SMTIME = 0.001;
GLOBE;
global SPHE_INN;
global SPHE_OUT;

SPHE_INN=Inn;
SPHE_OUT=Out;
if Tim <= Burst
   if Tim <PT_SMTIME
      sphere_conc = hol_spheint(Tim,d,Inn, Out);
   else		
      sphere_conc = quad8('inst_sphere2',PT_SMTIME,Tim,[],[],d)+hol_spheint(PT_SMTIME,d,Inn, Out);
   end
else
   temp2 = Tim - Burst;
   if temp2 <PT_SMTIME
      sphere_conc = hol_spheint(PT_SMTIME,d,Inn, Out)-hol_spheint(temp2,d,Inn,Out)+quad8('inst_sphere2',PT_SMTIME,Tim,[],[],d);
   else
      sphere_conc=quad8('inst_sphere2',temp2,Tim,[],[],d);
   end
end
sphere_conc = sphere_conc.*0.00331;