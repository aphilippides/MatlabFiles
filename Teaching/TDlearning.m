function TDlearning(h)

w=zeros(1,11);
v=zeros(1,17);
r=zeros(1,16);
r(11)=0.5;
u=w;u(6)=1;
l=0.1;
NumTrials = 1000;
d=r+v(2:end)-v(1:end-1);
Draws(v,w,d,h)
pause
for i=1:NumTrials
    w=w+l*d(6:16)
    v(6:11)=w(1:6)
    d=r+v(2:end)-v(1:end-1)
    Draws(v,w,d,h)
    pause
end

function Draws(v,w,d,h)
subplot(3,1,1)
plot(0:10,d(1:11))
axis([0 10 0 0.55])
if(h) hold on; end;
ylabel('d','FontSize',16);
subplot(3,1,2)
plot(0:10,w)
axis([0 10 0 0.55])
if(h) hold on; end;
ylabel('w','FontSize',16);
subplot(3,1,3)
plot(0:10,v(1:11))
ylabel('v','FontSize',16);
axis([0 10 0 0.55])
if(h) hold on; end;


