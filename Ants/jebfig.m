function jebfig(w,h)

if(nargin<2) h=4; end;
if(nargin<1) w=4.5; end;

set(gcf,'FontName','Arial','FontSize',10)
set(gca,'FontName','Arial','FontSize',8)
ht=get(gca,'Title');
hx=get(gca,'XLabel');
hy=get(gca,'YLabel');
set(ht,'FontName','Arial','FontSize',8)
set(hx,'FontName','Arial','FontSize',8)
set(hy,'FontName','Arial','FontSize',8)
set(gcf,'Units','centimeters')
p=get(gcf,'Position');
set(gcf,'Position',[p([1 2]) w h])
% set(gcf,'Position',[5 5 w h])
Setbox
return

for i=[2 5]
    figure(i)
    xlim([0 45])
caxis([0.00 0.125])
jebfig(9,4.5)
end
for i=[3 6]
    figure(i)
    xlim([0 45])
caxis([0.00 0.2])
jebfig(9,4.5)
end
for i=[1 4]
    figure(i)
    xlim([0 65])
caxis([0.0 0.08])
jebfig(9,4.5)
end
for i=[1 2]
    figure(i)
    xlim([0 60])
caxis([0.0 0.1])
jebfig(9,4.5)
end