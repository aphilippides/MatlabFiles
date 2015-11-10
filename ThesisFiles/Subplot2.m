function[h1,h2]=Subplot2(FigHdl)

set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
h1=subplot('Position',[0.1 0.15 0.375 0.8]);
Setbox;
h2=subplot('Position',[0.6 0.15 0.375 0.8]);
Setbox;




