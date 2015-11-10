function RbfVsMLP_Pics

n=30;
m1=[4 5];s=[1 0;0 1];
a=mvnrnd(m1,s,n);
plot(a(:,1),a(:,2),'go')
hold on

m2=[-4 5];s=[2 1.9;1.9 2];
b=mvnrnd(m2,s,n);
plot(b(:,1),b(:,2),'go')

m3=[0 0];s=[0.1 0;0 1];
c=mvnrnd(m3,s,n);
plot(c(:,1),c(:,2),'go')
ms=[m1;m2;m3];
plot(ms(:,1),ms(:,2),'rx')
axis equal
axis off
plot([2 0 -10],[9 4 -2])
plot([5 0],[-2 4])
hold off

figure

plot(a(:,1),a(:,2),'go')
hold on
plot(b(:,1),b(:,2),'go')
plot(c(:,1),c(:,2),'go')
plot(ms(:,1),ms(:,2),'rx')

axis equal
axis off
MyCircle(m1,2.5,100);
MyCircle(m2,2.5,100);
MyCircle(m3,2.5,100);
hold off

figure

plot(a(:,1),a(:,2),'go')
hold on
plot(b(:,1),b(:,2),'go')
plot(c(:,1),c(:,2),'go')
plot(ms(:,1),ms(:,2),'rx')

axis equal
%axis off
MyCircle(m1,2.5,100);
MyCircle(m2,2,100);
MyCircle(m3,1.5,100);
hold off

figure

plot(a(:,1),a(:,2),'go')
hold on
plot(b(:,1),b(:,2),'go')
plot(c(:,1),c(:,2),'go')
plot(ms(:,1),ms(:,2),'rx')

axis equal
axis off
hold off