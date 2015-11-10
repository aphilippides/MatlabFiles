function[i2]=PlotArc(Cents,EndPt,pos,t,t1,t2,c)
if(nargin<7) c='b'; end;
if(nargin==4) i2=t;
elseif(nargin==5)
    i2=t;
    c=t1;
else i2=find((t>=t1)&(t<=t2));
end;
plot(pos(1,1),pos(1,2),'gs')
hold on;                    %MyCircle(LM,LMWid);
plot(pos(2,1),pos(2,2),'ro')
plot(EndPt(i2,1),EndPt(i2,2),[c '.'])
plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]',c)
plot(Cents(i2,1),Cents(i2,2))
plot(Cents(i2,1),Cents(i2,2))
hold off;
axis equal
% axis([100 500 100 500])