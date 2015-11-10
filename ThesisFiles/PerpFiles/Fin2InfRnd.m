function Fin2InfRnd
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
T=[500,1000];
Sl=[2,5];
for i=1:2
    fn=['Fin2InfRandX150T500Sl'int2str(Sl(i)) 'Data.mat'];
    load(fn);
    plot(V,100*ThreedOver./(150*TwodOver),Cols(i,:));
    hold on
end
hold off
Setbox;
axis tight
xlabel('Plexus')
ylabel('Volume over threshold (%age of 2d estimate)');
legend('synth. vol','whole vol.')
subplot('Position',[0.6 0.15 0.375 0.8])
Fact=mean(ThreedOver(1:22)./TwodOver(1:22));
rest=(23:32);
plot(rest,100*TwodOver(rest)*Fact./ThreedOver(rest))
Setbox;
xlabel('Plexus')
ylabel({'Estimated volume over threshold';'(%age of true value)'});
axis tight