function SolidVsDispersedSpread2

set(gca,'FontSize',10)
d=-6:0.01:6;
r=5;
y=f1(d,r);
z=f2(d,r);
plot(d,y,d,z,'r:')
legend('GasNet','Plexus')
SetBox;
xlabel('Distance from emitter')
ylabel({'Maximum gas'; 'concentration'})
SetXLim(gca,-6,6)
SetXTicks(gca,5);
SetYTicks(gca,5);

set(gcf,'Units','centimeters');
X=get(gcf,'Position');
set(gcf,'Position',[X(1) X(2) 9 6]);
set(gcf,'PaperPositionMode','auto');
%h=subplot('Position',[0.175 0.175 0.775 0.75]);

function[y]=f1(d,r)
i=find(abs(d)>r);
y=exp(-2*abs(d)./r);
y(i)=0;

function[y]=f2(d,r)
i=find(abs(d)>r);
y=0.5*ones(size(d));
y(i)=0;