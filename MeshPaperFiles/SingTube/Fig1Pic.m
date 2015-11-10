function Fig1Pic

dtube;
Bursts=[0.1,1,5,10];
h=subplot('Position',[0.1 0.1 0.38 0.8]);
%ThreshDistPic(Bursts);
ThreshDistPic([0.1,1,10]);
set(h,'TickDir','out','Box','off')
h2=subplot('Position',[0.6 0.1 0.38 0.8]);
SurfaceConcPic(Bursts);
YTickStr=get(gca,'YTick')./1e-6;
set(h2,'TickDir','out','Box','off','YTickLabel',YTickStr)

function ThreshDistPic(Bursts)

Colors=['b- ';'g--';'y- ';'k-.';'c- ';'r--'];
Skip=4;
for i=1:length(Bursts)
   fname=['MeshPaper\Fig1Data\LimitsRads1_25_25B' x2str(Bursts(i)) 'Am.mat'];
   load(fname);
   y=RThresh-Rads;
   y=(y>0).*y;
   plot(Rads*2,y,Colors(i,:))
   hold on
	Plothdl=gca;
	[C(i),LSty(i,:),M(i,:)]=plotskip(Rads*2,y,i,Skip,Plothdl);
end 
Plothdl=gca;
%[AxLegHdl,ObjLegHdls]=legend('Burst=0.1s','Burst=1s','Burst=5s','Burst=10s',2);
[AxLegHdl,ObjLegHdls]=legend('Burst=0.1s','Burst=1s','Burst=10s',2);
set(AxLegHdl,'Visible','off')
hold off
axis tight
xlabel('Tube diameter ( \mum)')
ylabel('Threshold distance from surface of tube ( \mum)')
SetLegendLines(C,LSty,M,ObjLegHdls)


function SurfaceConcPic(Bursts)

%Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Colors=['b- ';'g--';'y- ';'k-.';'c- ';'r--'];

Bursts=[0.1,1,5,10];

for i=1:length(Bursts)
   fname=['MeshPaper\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Bursts(i)) '.mat'];
   load(fname);
   plot(Diams,SurfaceTubeConc,Colors(i,:))
   hold on
end
plot([0.1 10],[2.5e-7 2.5e-7],'r:')
Plothdl=gca;
[AxLegHdl,ObjLegHdls]=legend('Burst=0.1s','Burst=1s','Burst=5s','Burst=10s','Threshold Conc.',2)
set(AxLegHdl,'Visible','off')
Skip=8
for i=1:length(Bursts)
   fname=['MeshPaper\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Bursts(i)) '.mat'];
   load(fname);
	[C(i),LSty(i,:),M(i,:)]=plotskip(Diams,SurfaceTubeConc,i,Skip,Plothdl);
   hold on
end
xlabel('Tube Diameter ( \mum)')
ylabel('Concentration on surface of tube ( \muM)')
hold off
axis tight
SetLegendLines(C,LSty,M,ObjLegHdls(1:length(ObjLegHdls)-1))


function[Col,LSty,Mark]=plotskip(x,y,i,sk,PHdl)

Colors=['b';'g';'y';'k';'c';'r']';
LineStyles=['- ';': ';'--';'-.';'- ';'--'];
Symbols=['x   ';'.   ';'o   ';'d   ';'^   ';'none'];
xsk=x(1:sk:length(x));
ysk=y(1:sk:length(y));
subplot(PHdl)
if(Symbols(i,:)~='none')
   plot(xsk,ysk,[Colors(i) Symbols(i,:)])
end
Col=Colors(i);
LSty=LineStyles(i,:);
Mark=Symbols(i,:);


function SetLegendLines(Cols,LStyles,Markers,LHdls)

LHdls=LHdls(2:length(LHdls));
for i=1:length(Cols)
   set(LHdls(i),'Color',Cols(i),'LineStyle',LStyles(i,:))
   if (Markers(i,:)~='none')
      set(LHdls(i),'MarkerEdgeColor',Cols(i),'Marker',Markers(i,:))
   end
end
