function CompNeuroFigs(a,b,h,x)
n=200
t=(1:n)*h
f=b+0.1*(rand(1,n)-0.5);
%f=b*ones(1,n)+0.1*sin(2*pi*t);
%f=t;
v(1)=a;
for i=2:n
    v(i)=v(i-1)+(h/x)*(-v(i-1) +f(i-1));
end
plot(t,v-0.1,'g',t,v,'g',t,f,'b','LineWidth',2)
