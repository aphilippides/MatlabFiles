function[newx,newxint,bads,goods] = DeSpike(x,t)

d1=diff(x(1:end-1));
d2=diff(x(2:end));

is=find((d1.*d2)<-(t^2));

dum=(abs(d1(is))>t)&(abs(d2(is))>t);
bads=is(find(dum))+1;
goods=setdiff([1:length(x)],bads);

newx=x(goods);
newxint=x;
for i=bads newxint(i)=0.5*(x(i-1)+x(i+1)); end