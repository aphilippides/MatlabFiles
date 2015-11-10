function GasNetPlexusVsOrig(del, l, s)

Singplot(gcf)
d=-6:0.01:6;
r=5;
y=f1(d,r);
z=f2(d,r);
plot(d,y,d,z,'r:')
legend('Original','Plexus')
SetBox;
xlabel('Distance from centre of gas cloud')
ylabel('Maximum gas concentration')
SetXTicks(gca,5);
SetYTicks(gca,5);


function[y]=f1(d,r)
i=find(abs(d)>r);
y=exp(-2*abs(d)./r);
y(i)=0;

function[y]=f2(d,r)
i=find(abs(d)>r);
y=0.5*ones(size(d));
y(i)=0;