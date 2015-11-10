% function to get t of the max conc for a given radius r and burst_length B
% for a hollow sphere rads in, out call:Hsp_tmax(in,out,r, B)

function[Maxim, T_max] = Tube_tmax(out,r, B)
GLOBE;
Tol = 1e-5;
StartT=B
MAX_T = B*max(1,r/out);
flag =1;
Acc=5e-3;
f_end1 = Tube(r,StartT,out,B,Acc,25);
if isnan(f_end1)
   Maxim = -100;
   T_max=-100;
   return
end

if(MAX_T==StartT)
   f_end2=f_end1;
   CheckMaxTMore=1.001*MAX_T;
   FCheckMaxTMore=Tube(r,CheckMaxTMore,out,B,Acc,25); 
else
   f_end2=Tube(r,MAX_T,out,B,1e-2,25);
   CheckMaxTMore=1.1*MAX_T;
   FCheckMaxTMore=Tube(r,CheckMaxTMore,out,B,Acc,25);
end

while(FCheckMaxTMore>f_end2) %while MAX_T not big enough
   CheckMaxTMore=1.1*CheckMaxTMore;
   f_end2 =FCheckMaxTMore;
   FCheckMaxTMore=Tube(r,CheckMaxTMore,out,B,Acc,25);
end
b=CheckMaxTMore;		% Since b defntley past max
f_end2=FCheckMaxTMore;
a=StartT
fmid1=-100;
fmid2=-10;
while((b-a)>Tol)
%while(and((abs(fmid1-fmid2)>Tol*fmid1),(abs(fmid1-f_end1)>Tol*f_end1)))
   mid1 =a+(b-a).*0.25;
   mid2 = a+(b-a).*0.75;
   fmid1 = Tube(r,mid1,out,B,1e-2,25);
   if(fmid1<f_end1)
      b=mid1;
   else
      fmid2 = Tube(r,mid2,out,B,1e-2,25);   
      if (fmid1>fmid2)
         b=mid2
      else
         a=mid1
      end
   end
end
if(fmid1>fmid2)
   T_max = mid1;
   Maxim = fmid1;  
else
   T_max = mid2;
   Maxim = fmid2;  
end
if(f_end1>Maxim)
   T_max=StartT;
   Maxim=f_end1;
end

% Check step
Check=0;
if(Check==1)
Time=[T_max-0.0001,T_max,T_max+0.0001];
y(1)=Tube(r,Time(1),out,B,1e-2,25) ;
y(2)=Maxim;
y(3)=Tube(r,Time(3),out,B,1e-2,25); 
plot(Time,y)

end