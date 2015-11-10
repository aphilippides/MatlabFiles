function ProcessFigsScript
s=dir('*.fig');
for i=1:length(s)
    fn=s(i).name;
    h=openfig(fn);
    g=colormap('gray');colormap(g(end:-1:1,:))
%     xlim([-180 180]);
    printstuff(fn(1:end-4),h)
end
    
function printstuff(fn,h)
set(h, 'PaperPositionMode', 'auto')
% saveas(h,fn,'fig');
saveas(h,fn,'ai');