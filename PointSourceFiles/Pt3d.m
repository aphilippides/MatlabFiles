% Function which returns the concenttration at time =Tim;dist =d
% for a 3d point source burst length=Burst
% Time in seconds, distance in microns. 
% Function call: Pt3d(Tim,d,Burst)

function[conc] = Pt3d(Tim,d,Burst)

PT_SMTIME = 0.001;
GLOBE;
if(Tim<eps) Tim=eps;end
if Tim <= Burst
   if Tim <PT_SMTIME
      conc = my_ptint(Tim,d);
   else		
      conc = quad8('inst_3d',PT_SMTIME,Tim,[],[],d)+my_ptint(PT_SMTIME,d);
   end
else
   temp2 = Tim - Burst;
   if temp2 <PT_SMTIME
      conc = my_ptint(PT_SMTIME,d)-my_ptint(temp2,d)+ ...
          quad8('inst_3d',PT_SMTIME,Tim,[],[],d);
   else
      conc=quad8('inst_3d',temp2,Tim,[],[],d);
   end
end
conc = conc.*0.00331;