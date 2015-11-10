function PlotTransects(xy,val,NObj,mx,my,c)
if(nargin<6) c='b'; end

if(xy)
   ns=NObj(:,val);
   dx=diff(mx(:,val));
   dy=diff(my(:,val));
else
   ns=NObj(val,:);
   dx=diff(mx(val,:));
   dy=diff(my(val,:));
end
d=sqrt(dx.^2+dy.^2);
subplot(2,1,1)
plot(ns,c)
subplot(2,1,2)
plot(d,c)