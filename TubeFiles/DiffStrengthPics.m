function DiffStrengthPics

dtube;
Cent=0;
qs=[1 2 5 10]
for i=1:length(qs)
    fn=['LimitsRad_05_5B1EarlyQTimes' int2str(qs(i)) '.mat'];
    load(fn)
    r=RThresh./Rads-1;
    is=find(r<=0);
    i1=is(1);
    is=find(r>=0);
    i2=is(end);
    RadLim(i)=Rads(i1)+(Rads(i2)-Rads(i1))*abs(r(i1))/(r(i2)-r(i1))
end
MyCircle(0, Cent, RadLim(1),200);
for i=2:length(qs)
    Cent=Cent+RadLim(i-1)+RadLim(i)+0.25;
    hold on;
    MyCircle(0, -Cent, RadLim(i),200);
end
hold off
axis off, axis equal;