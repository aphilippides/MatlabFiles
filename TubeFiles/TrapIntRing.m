% Function which uses the trapezoidal rule to integrate a relatively smooth function
% to a relative error of Eps and with a recursion limit of Nlim

function[FInt,Err,NLimFlag]= TrapIntRing(Func,x0,xend,r,t,Eps,NLim,Draw)

oldf=-1e6;
Inter=xend-x0;
newf=0.5*Inter*(feval(Func,x0,r,t)+feval(Func,xend,r,t));
for n=1:NLim
   if(abs(newf-oldf)<=(Eps*abs(oldf)))
      FInt=newf;
      Err=abs(newf-oldf);
      NLimFlag=n;
      if(Draw==1)
         hold off;
      end
      return
   end
   innersum=0;
   absci=Inter*(0.5^n);
   for i=1:2:(2^n)
      newx=x0+i*absci;
      newy=feval(Func,newx,r,t);
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
NLimFlag=-100;
if(Draw==1)
   hold off;
end
return
