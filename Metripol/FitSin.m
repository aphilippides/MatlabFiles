function[estim]=FitSin(lens,ifplot,x)
if(nargin<2) ifplot=1; end
if(nargin<3) x=[0:pi/6:2*pi]; end
x0=[mean(lens) 3*pi/4 - 5*pi/6 range(lens)/2];
params=fminsearch('DataFitFunc',x0',[],x,lens);
a=params(1);
b=params(2);
c=params(3);
estim=c*sin(x+b)+a;
errs=mean(sqrt((lens-estim).^2));
nex=[min(x):0.01:max(x)];
estim=c*sin(nex+b)+a;

if(ifplot)
    plot(x,lens,'r--x')
    hold on;plot(nex,estim);hold off;
    estim=c*sin(x+b)+a;
end
for i=1:length(lens)
    is=setdiff([1:length(lens)],i);
    l=lens(is);
    xn=x(is);
    p=fminsearch('DataFitFunc',x0',[],xn,l);
    a=p(1);b=p(2);c=p(3);    
    es=c*sin(xn+b)+a;
    er(i)=mean(sqrt((l-es).^2));
end
[m,i]=min(er);
is=setdiff([1:length(lens)],i);
l=lens(is);
xn=x(is);
p=fminsearch('DataFitFunc',x0',[],xn,l);
a=p(1);b=p(2);c=p(3);
es=c*sin(nex+b)+a;
if(ifplot)
    hold on;plot(nex,es,'g');hold off;
end

