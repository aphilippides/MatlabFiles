function Sl1OverBar(T,Sl)

if(nargin<2) Sl=1; end
if(nargin<1) T=1.0; end
wid=[1 4];
close
h2=figure;
set(h2,'Units','centimeters');
X=get(h2,'Position');
set(h2,'Position',[X(1) X(2) 5 10]);
set(h2,'PaperPositionMode','auto');

DataNeeded=0;
fn=['MeshPaperFiles/WidthComp3d/Sl1OverData'];
if(DataNeeded==1)
   GetData(Sl,wid,fn,T)
end
dmat;
load(fn);
%h=BarErrorBar([1 4],Over,OverS*2.58/sqrt(30),2.1);
h=BarErrorBar([1 4],Over,OverS,2.1);
set(h,'Box','off','TickDir','out','Units','normalized')
set(h,'Position',[0.2 0.1 0.75 0.8])
ylabel('Volume over threshold (x10 ^5 \mum^3)');
SetYTicks(h,5,1e-5);
xlabel('Width (\mum)');
SetXLim(h,-0.5, 5.5);
%SetYLim(h,4e5,[]);


function GetData(Sl,wid,fn,T)
d3dmm;
Over=[];
OverS=[];
for i=1:2
	fn2=['MaxW'x2str(wid(i)) 'Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(Sl) '.mat'];
   load(fn2);
   ind=find(Times==T);
   Over=[Over OverAvg(ind)];
   OverS=[OverS OverStd(ind)];
end
dmat
save(fn,'Over','OverS','T')