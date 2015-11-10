% Finds the time when the conc drops to Val p/c of the Peak Conc for 
% Hollow spherre Radii: in, out, Burst B at dist r. Peak at PeakT 
% Call: TubeFindLim(Val,in,out,r,B,PeakVal,PeakT)
% Used with Tube_tmax Finds the limit at which the concnetration gets to 
% a certain limit (eg finds threshold distance)
% Lim=2.5e-7/0.00331=7.5529e-5

function[Rthresh,Tthresh,Err,ErrConc,LimConc] = TubeFindLim(Lim,in,out,B)

TOL=1e-2;
Eps=1e-3;		% percent accuracy of Concs
NLim=20;			% No. of iterations to do (approx 1e6=2 hours)
MAX_R = out+out.*4./5;
a = 0;
[fa,Erra,LimA] =ThreshTube(Lim,0,B,out,B,Eps,NLim);
if ((fa+Erra)<Lim) 		% make sure source gets above lim
   Rthresh=0;
   Tthresh=100;
   Err=0;
   ErrConc=Erra;
   LimConc=LimA;
   return
end
b=MAX_R;
[bOver,Maxb,TMaxb,ErrConcb,LimConcb] =TubeOverThresh(Lim,out,b,B,Eps,NLim);
bOver
while(bOver==1) 		% Find a maximum
   a=b
   b=b+out.*4./5;
	[bOver,Maxb,TMaxb,ErrConcb,LimConcb] =TubeOverThresh(Lim,out,b,B,Eps,NLim);
end

while ((b-a)> TOL)
   mid = (a+b)./2.0
	[MidOver,MaxMid,TMaxMid,ErrConcMid,LimConcMid] =TubeOverThresh(Lim,out,mid,B,Eps,NLim)
   if (MidOver==1)
      a = mid
   else
      b = mid
   end
end
Rthresh = mid;
Tthresh=TMaxMid;
Err = Lim-MaxMid;
ErrConc=ErrConcMid;
LimConc=LimConcMid;
