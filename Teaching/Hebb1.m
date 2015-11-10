function Hebb1(n)
%n=10
h=0.1;
q=[1 .5;.5 .25];
w=[0.1 -0.3]'
    x(1)=w(1);
    y(1)=w(2);
for i=1:n
    w=w+h*q*w;
    x(i+1)=w(1);
    y(i+1)=w(2);
end
t=0:n;
figure(1)
plot(t,x','g',t,y','b','LineWidth',1)
axis tight
xlabel('repetitions')
ylabel('w')


figure(2)
v=0.5:.5:5.5;
th(1)=0.5;
for i=1:10
th(i+1)=0.5*v(i)^2+0.5*th(i);
end
plot([0:10],th,'g',[0:10],v,'b','LineWidth',2)
