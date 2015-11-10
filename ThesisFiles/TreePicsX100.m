function TreePicsX100(Dens,Sl)
if(nargin<1) Dens=[100,111,125];end
if(nargin<2) Sl=4;end
d3dmm;
Rho100Pic(Sl)
%OverAllDens(Dens,Sl)

function Rho100Pic(Sl)
Thr=0.25e-6;
fn=['MaxTreeRho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl5.mat'];
load(fn);
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 18 10]);
set(FigHdl,'PaperPositionMode','auto');
subplot('Position',[0.1 0.15 0.375 0.8])
errorbar(Times,OverAvg/1e6,OverStd/1e6);
Setbox;
axis tight;
xlabel('Time (s)')
ylabel({'Area over threshold (Synthesising vol.)'});
subplot('Position',[0.6 0.15 0.375 0.8])
fn=['MaxTreeRho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl1.mat'];
load(fn);
errorbar(Times,OverAvg/1e6,OverStd/1e6);
xlabel('Time (s)')
ylabel({'Area over threshold (Synthesising vol.)'});
Setbox;
axis tight;

function OverAllDens(Dens,Sl)
%Cols=['b-o';'g- ';'r-s'];
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];

Thr=0.25e-6;
Overs=[];OvStd=[];MTs=[];
for i=1:length(Dens)
   fn=['MaxTreeRho'int2str(Dens(i)) '/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'int2str(Sl) '.mat'];
   load(fn);
   Overs=[Overs,OverAvg'];
   OvStd=[OvStd,OverStd'];
   %plot(Times,OverAvg/1e6,Cols(i,:));axis('tight');
   plot(Times,(0.75.*OverAvg./pi).^(1/3),Cols(i,:));axis('tight');
  hold on
   MTs=[MTs,Times];
end
legend('\rho=0.01','\rho=0.009','\rho=0.008',2)%,'Thresh',2)
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 10 10]);
set(FigHdl,'PaperPositionMode','auto');

%errorbar(MTs,Overs/1e6,OvStd/1e6);axis('tight');
%errorbar(MTs,(0.75.*pi.*Overs).^(1/3),(0.75.*pi.*OvStd).^(1/3));axis('tight');
hold off
Setbox;
xlabel('Time (s)')
ylabel({'Area over threshold (Synthesising vol.)'});
ylabel({'Threshold distance (\mum)'});
hold off