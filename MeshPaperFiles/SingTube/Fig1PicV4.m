function Fig1PicV4(B,Radii)

dtube;
if(nargin<2) Radii=[2 2.5 5 10 15]; end;
if(nargin<1) B=1; end; 
Bursts=[0.1,1,5,10];
h=subplot('Position',[0.05 0.6 0.98 0.38]);
ThreshDistPic(B,Radii);
set(h,'TickDir','out','Box','off')
h2=subplot('Position',[0.3 0.125 0.6 0.4 ]);
ThreshDists(B);
%YTickStr=get(gca,'YTick')./1e-6;
set(h2,'TickDir','out','Box','off')
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2)-4 15 15]);
set(FigHdl,'PaperPositionMode','auto');
%X=get(AxHdl,'Position');
X(2)=X(2)+0.025;
%set(AxHdl,'Position',X);

function ThreshDistPic(Burst,Radii)

CircRad=1.25;
CircSep=1;
BLen=0.75;		% length of bars at ends of radii
fname=['MeshPaper\Fig1Data\LimitsRads1_25_25B' x2str(Burst) 'Am.mat'];
load(fname);
for i=1:length(Radii)
   Rad=Radii(i);
   ind=find(Rad==Rads);
   TDist=CircRad*RThresh(ind)/Rad;
   y=(2*i-1)*CircRad+(i-1)*CircSep;
   MyCircle(0,y,CircRad,100)
   hold on
   % draw lines depicting radii
   line([-TDist -CircRad;CircRad TDist]',[y y;y y]','Color','b');
   % draw bars at ends of radii
   line([-TDist -TDist;TDist TDist]',[y-BLen y+BLen;y-BLen y+BLen]','Color','b');
   offy=0.00;
   offx=0.55;
	text(0-offx,y-offy,[num2str(2*Rad) '\mu'],'FontSize',8)   
end 
axis equal
hold off
axis off

function ThreshDists(Burst)

fname=['MeshPaper\Fig1Data\LimitsRads1_25_25B' x2str(Burst) 'Am.mat'];
load(fname);
%plot(Rads.*2,RThresh./Rads);
%plot(Rads.*2,RThresh);
RDist=min(1,RThresh./Rads-1);
plot(Rads.*2,RThresh./(Rads.*2));
%set(gca,'XLim',[Rads(end)*2 30]);
axis([0 30 0 7]);
SetYTicks(gca,0,1,0,[0 3 6])
xlabel('Source diameter (\mum)')
h=ylabel({'Threshold distance';'(multiples of source diameter)'});
MoveXYZ(h,-0.1,0,0);