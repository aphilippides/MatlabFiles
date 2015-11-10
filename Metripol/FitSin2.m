function[estim]=FitSin2(lens,x)
if(nargin<2) x=[0:pi/6:2*pi]; end
x0=[mean(lens) 3*pi/4 - 5*pi/6 range(lens) 1];
params=fminsearch('DataFitFunc2',x0',[],x,lens);
a=params(1);
b=params(2);
c=params(3);
d=params(4);
estim=c*sin(d*x+b)+a;
errs=mean(sqrt((lens-estim).^2));
nex=[0:0.01:2*pi];
estim=c*sin(d*nex+b)+a;
for i=1:length(lens)
    is=setdiff([1:length(lens)],i);
    l=lens(is);
    xn=x(is);
    p=fminsearch('DataFitFunc2',x0',[],xn,l);
    a=p(1);b=p(2);c=p(3); d=p(4)   
    es=c*sin(d*xn+b)+a;
    er(i)=mean(sqrt((l-es).^2));
end
[m,i]=min(er);
is=setdiff([1:length(lens)],i);
l=lens(is);
xn=x(is);
p=fminsearch('DataFitFunc',x0',[],xn,l);
a=p(1);b=p(2);c=p(3);d=p(4);
es=c*sin(d*nex+b)+a;

plot(x,lens,'r--x')
hold on;plot(nex,estim);hold off;
hold on;plot(nex,es,'g');hold off;