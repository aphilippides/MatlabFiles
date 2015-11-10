% function to get t of the max conc for a given radius r and burst_length B
% for a hollow sphere rads in, out call:Hsp_tmax(in,out,r, B)

function[Over, Maxim, T_max,CErr,Limit] = TubeOverThresh(Thresh,out,r, B,Eps,NLim)
%GLOBE;
Tol = 1e-4;
StartT=B;
MAX_T = B*max(1,r/out);
MAX_T=min(MAX_T,2*B);
flag =1;
[f_end1,ErrEnd,LimEnd] = ThreshTube(Thresh,r,StartT,out,B,Eps,NLim);
if(f_end1>=Thresh)
   Over=1;
   Maxim=f_end1;
   T_max=StartT;
   CErr=ErrEnd;
   Limit=LimEnd;
   return
end

if isnan(f_end1)
   Over=-100;
   Maxim = -100;
   T_max=-100;
   CErr=-100;
   Limit=-100;
   return
end

if(MAX_T==StartT)
   f_end2=f_end1;
   CheckMaxTMore=1.001*MAX_T;
   [FCheckMaxTMore,ErrF,LimF]=ThreshTube(Thresh,r,CheckMaxTMore,out,B,Eps,NLim); 
else
   [f_end2,ErrEnd2,LimEnd2]=ThreshTube(Thresh,r,MAX_T,out,B,Eps,NLim);
   CheckMaxTMore=1.1*MAX_T;
   [FCheckMaxTMore,ErrF,LimF]=ThreshTube(Thresh,r,CheckMaxTMore,out,B,Eps,NLim);
end

if(f_end2>=Thresh)
   Over=1;
   Maxim=f_end2;
   T_max=MAX_T;
   CErr=ErrEnd2;
   Limit=LimEnd2;
	return
end
if(FCheckMaxTMore>=Thresh)
   Over=1;
   Maxim=FCheckMaxTMore;
   T_max=CheckMaxTMore;
   CErr=ErrF;
   Limit=LimF;
   return
end


while(FCheckMaxTMore>f_end2) %while MAX_T not big enough
   CheckMaxTMore=1.1*CheckMaxTMore;
   f_end2 =FCheckMaxTMore;
   [FCheckMaxTMore,ErrF,LimF]=ThreshTube(Thresh,r,CheckMaxTMore,out,B,Eps,NLim);
   if(FCheckMaxTMore>=Thresh)
      Over=1;
      Maxim=FCheckMaxTMore;
      T_max=CheckMaxTMore;
   	CErr=ErrF;
   	Limit=LimF;
	   return
   end   
end

b=CheckMaxTMore;		% Since b defntley past max
f_end2=FCheckMaxTMore;
a=StartT;
fmid1=-100;
fmid2=-10;
while((b-a)>Tol)
   mid1 =a+(b-a).*0.25;
   mid2 = a+(b-a).*0.75;
   [fmid1,ErrMid1,LimMid1] = ThreshTube(Thresh,r,mid1,out,B,Eps,NLim);
   if(fmid1>=Thresh)
      Over=1;
      Maxim=fmid1;
      T_max=mid1;
      CErr=ErrMid1;
      Limit=LimMid1;
	   return
   end
   
   if(fmid1<f_end1)
      b=mid1;
   else
     	[fmid2,ErrMid2,LimMid2] = ThreshTube(Thresh,r,mid2,out,B,Eps,NLim);   
      if(fmid2>=Thresh)
         Over=1;
         Maxim=fmid2;
         T_max=mid2;
     		CErr=ErrMid2;
      	Limit=LimMid2;
         return
      end
      if (fmid1>fmid2)
         b=mid2;
      else
         a=mid1;
      end
   end
end
if(fmid1>fmid2)
   T_max = mid1;
   Maxim = fmid1;  
   CErr=ErrMid1;
   Limit=LimMid1;
else
   T_max = mid2;
   Maxim = fmid2;  
   CErr=ErrMid2;
   Limit=LimMid2;
end
if(f_end1>Maxim)
   T_max=StartT;
   Maxim=f_end1;
  	CErr=ErrEnd;
   Limit=LimEnd;
end
Over=0;
% Check step
Check=0;
if(Check==1)
   Time=[T_max-0.0001,T_max,T_max+0.0001];
   y(1)=ThreshTube(Thresh,r,Time(1),out,B,Eps,NLim) ;
   y(2)=Maxim;
   y(3)=ThreshTube(Thresh,r,Time(3),out,B,Eps,NLim); 
   plot(Time,y)   
end