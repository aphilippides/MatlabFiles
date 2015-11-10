function SurfaceConcsPic(Bursts,FigHdl)

dtube;
if(nargin<1) Bursts=[0.1,1,5,10]; end; 
%if(nargin<2) FigHdl=figure; end;
if(nargin<2) FigHdl=gcf; clf;end;
h=Singplot(gcf)
AxHdl=SurfaceConcPic(Bursts,FigHdl);
set(AxHdl,'XLim',[0.1 7]);
set(AxHdl,'YLim',[0 10e-7]);
SetXTicks(AxHdl,[],1,1,[1:1:7]);
SetYTicks(AxHdl,5,1e6,2,[0:2.5:10]*1e-7);
SetBox(h)
return
set(AxHdl,'TickDir','out','Box','off')
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 15 9]);
set(FigHdl,'PaperPositionMode','auto');
X=get(AxHdl,'Position');
X(2)=X(2)+0.025;
set(AxHdl,'Position',X);

function[AxHdl]=SurfaceConcPic(Bursts,PlotHdl)

Bursts=[0.1,1,5,10];
Skip=5;
for i=1:length(Bursts)
   fname=['MeshPaper\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Bursts(i)) '.mat'];
   load(fname);
   [C(i),LSty(i,:),M(i,:)]=PlotSkip(Diams,SurfaceTubeConc,i,Skip,PlotHdl);
   ColSty(i,:)=[C(i) LSty(i,:) M(i,:)];
   hold on
end
plot([0.1 10],[2.5e-7 2.5e-7],'r:')
ColSty(i+1,:)=['r:     '];
AxHdl=gca;
xlabel('Tube Diameter ( \mum)')
ylabel('Concentration on surface of tube ( \muM)')
hold off
axis tight
[AxLegHdl,ObjLegHdls]=SetLegend(ColSty,{'Burst=0.1s';'Burst=1s';'Burst=5s';'Burst=10s';'Threshold Conc.'},1.2);
set(AxLegHdl,'Visible','off')