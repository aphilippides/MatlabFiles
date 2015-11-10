% Finds the time when the conc drops to Val p/c of the Peak Conc for 
% Hollow spherre Radii: in, out, Burst B at dist r. Peak at PeakT 
% Call: HspFindLim(Val,in,out,r,B,PeakVal,PeakT)
% Used with Hsp_tmax Finds the limit at which the concnetration gets to 
% a certain limit (eg finds threshold distance)

function[Rthresh,Tthresh,Err] = HspFindLim(Lim,in,out,B)

TOL=1e-1;
MAX_R = out.*2.0;
a = out;
[fa, ta] =Hsp_tmax(in,out,a,B);
if (fa<Lim) 		% make sure source gets above lim
   ERROR=1
   ERROR=1
   ERROR=1
   ERROR=1
   return
end

b=MAX_R;
[fb, tb] = Hsp_tmax(in,out,b,B);
while(fb>Lim) 		% Find a maximum
   b=2.*b;
   [fb, tb] = Hsp_tmax(in,out,b,B);
end

while ((b-a)> TOL)
   mid = (a+b)./2.0;
   [fmid,tmid] = Hsp_tmax(in,out,mid,B);
   if (fmid < Lim)
      b = mid;
   else
      a = mid;
   end
end
Rthresh = mid;
Tthresh=tmid;
Err = Lim-fmid;
      

