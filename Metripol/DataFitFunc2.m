function[y]=DataFitFunc(params,x,estim)
a=params(1);
b=params(2);
c=params(3);
d=params(4);
y1=c*sin(d*x+b)+a;
y=sum(sqrt((y1-estim).^2));
% y=sqrt(sum((y1-estim).^2));