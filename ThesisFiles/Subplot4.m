function[h1,h2,h3,h4]=Subplot4(FigHdl)

set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 15]);
set(FigHdl,'PaperPositionMode','auto');

h1=subplot('Position',[0.1 0.575 0.375 0.375]);
Setbox;
h2=subplot('Position',[0.6 0.575 0.375 0.375]);
Setbox;
h3=subplot('Position',[0.1 0.075 0.375 0.375]);
Setbox;
h4=subplot('Position',[0.6 0.075 0.375 0.375]);
Setbox;



