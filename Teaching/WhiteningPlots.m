function WhiteningPlots(n)

m=[7 5];
s=[0.1 0;0 3.9]
a=MyMvnrnd(m,s,n);
ta=(a-ones(n,1)*mean(a))./(ones(n,1)*std(a));
plot(a(:,1),a(:,2),'rx',ta(:,1),ta(:,2),'go')
axis square
axis([-4 10 -3 11])
DrawAxes(gca)
Setbox

figure
m=[7 5];
s=[2 1.9; 1.9 2]
a=MyMvnrnd(m,s,n);
ta=(a-ones(n,1)*mean(a))./(ones(n,1)*std(a));
plot(a(:,1),a(:,2),'rx',ta(:,1),ta(:,2),'go')
axis square
axis([-4 10 -3 11])
DrawAxes(gca)
Setbox

figure
[v,d]=eig(s)
wa=((d^-0.5)*v'*(a-ones(n,1)*mean(a))')';
plot(a(:,1),a(:,2),'rx')%,wa(:,1),wa(:,2),'go');
hold on;
%DrawEigs(v,d,m);
axis square
axis([-4 10 -3 11])
DrawAxes(gca)
Setbox
axis off
figure
[v,d]=eig(s)
wa=((d^-0.5)*v'*(a-ones(n,1)*mean(a))')';
plot(a(:,1),a(:,2),'rx')%,wa(:,1),wa(:,2),'go');
hold on;
DrawEigs(v,d,m);
axis square
axis([-4 10 -3 11])
DrawAxes(gca)
Setbox
axis off
function DrawEigs(v,d,m)
%s=[m;m+(v(:,1)*0.75)'];
s=[m;m+(v(:,1)*d(1,1))'];
s2=[m;m+(v(:,2)*d(2,2))'];
plot(s(:,1),s(:,2),'b',s2(:,1),s2(:,2),'b')