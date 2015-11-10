function NewGasNetPics(del, l, s)

[h1,h2]=Subplot2(gcf)
subplot(h1);
d=-6:0.01:6;
r=5;
y=f1(d,r);
z=f2(d,r);
plot(d,y,d,z,'r:')
legend('Version 0,1 and 2','Version 3')
SetBox;
xlabel('Distance from centre of gas cloud')
ylabel('Maximum gas concentration')
SetXTicks(gca,5);
SetYTicks(gca,5);

subplot(h2)
t=0:10;
x=[0,1,0];
t=[0,s,2*s];
x1=[0,1,0];
t1=[0,s,s+l];
x2=[0,0,1,0];
t2=[0,del,del+s,del+2*s];
plot(t,x,'r:',t1,x1,'b--',t2,x2,'g-')
legend('Version 0 and 3','Version 1','Version 2')
SetBox;
xlabel('Time')
ylabel('Concentration (% of maximum)')
SetYTicks(gca,5,100);
SetXTicks(gca,5,1,1,[del,s,2*s,s+l],{'d/v','s','2s','s+l'});

function[y]=f1(d,r)
i=find(abs(d)>r);
y=exp(-2*abs(d)./r);
y(i)=0;

function[y]=f2(d,r)
i=find(abs(d)>r);
y=0.5*ones(size(d));
y(i)=0;