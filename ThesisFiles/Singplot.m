function[h]= Singplot(FigHdl,ht,wid)

if (nargin<1) FigHdl=gcf; end
i%f (nargin<2) Lett = []; end
if (nargin<3) ht = 9; end
if (nargin<4) wid = 10; end

set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 9 10]);
set(FigHdl,'PaperPositionMode','auto');
cla
%set(gca,'Position',[0.175 0.125 0.775 0.8]);
h=subplot('Position',[0.175 0.125 0.775 0.8]);
SetBox(h)
%if(~isempty(Lett)) text(-0.18,1,Lett,'FontSize',14); end