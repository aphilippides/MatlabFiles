% Function which uses the trapezoidal rule to integrate a relatively smooth function
% to a relative error of Eps and with a recursion limit of Nlim

function[FInt,Err,NEnd]= ThreshTubeTrapInt(Func,Thresh,x0,xend,r,t,Eps,NLim,Draw)

oldf=-1e6;
Inter=xend-x0;
newf=0.5*Inter*(feval(Func,x0,r,t,Eps,NLim)+feval(Func,xend,r,t,Eps,NLim));
for n=1:NLim
   Err=abs(newf-oldf);
   if(abs(newf-oldf)<=(Eps*abs(oldf)))
      FInt=newf;
      NEnd=n;
      if(Draw==1)
         hold off;
      end
      return
   end
   if(n>1)			% this block is unused would delete but I might be able to do summat clever
      if(and((newf>=Thresh),(oldf<-Thresh)))
         FInt=newf;
         NEnd=n;
         if(Draw==1)
            hold off;
         end
         return
      elseif(and((newf<Thresh),(oldf<-1*Thresh)))
         FInt=newf;
         NEnd=n;
         if(Draw==1)
            hold off;
         end
         return
      end
   end
   innersum=0;
   absci=Inter*(0.5^n);
   for i=1:2:(2^n)
      newx=x0+i*absci;
      newy=feval(Func,newx,r,t,Eps,NLim);
      innersum=innersum+newy;
      if(Draw==1)
         plot(newx,newy,'rx')
         hold on
      end
   end
   oldf=newf;
   newf=oldf*0.5+innersum*absci;
end
FInt=newf;
Err=abs(newf-oldf);
NEnd=-100;
if(Draw==1)
   hold off;
end
return
