function[consecps,allps]=PlotArcCentre(Cents,sOr,pos,t,t1,t2)
if(nargin==4) is=t;
else is=find((t>=t1)&(t<=t2));
end;
[x,y]=pol2cart(sOr,100);
c=Cents+[x' y'];
plot([Cents(is,1) c(is,1)]',[Cents(is,2) c(is,2)]',c(is,1),c(is,2),'r.', ...
    pos(1,1),pos(1,2),'gs',pos(2,1),pos(2,2),'ro')
text(Cents(is(1),1),Cents(is(1),2),'S')
text(Cents(is(end),1),Cents(is(end),2),'F')
axis equal
n=length(is);
consecps=[];allps=[];
for i=1:n-1
    s=is(i);
    s2=is(i+1);
    p1=[Cents(s,:);c(s,:)];
    [x,y]=IntersectionPointOld(p1,[Cents(s2,:);c(s2,:)]);
    consecps=[consecps;x y];
    for j=i+1:n
        s2=is(j);
        [x,y]=IntersectionPointOld(p1,[Cents(s2,:);c(s2,:)]);
        allps=[allps;x y];
    end
end