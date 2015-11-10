function TreeDiffX(X)
X=[50,75,100,150];
Sl=4;
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
Thr=0.25e-6;
for i=1:length(X)
   if(X(i)==150)
   fn=['MaxTreeRho100/TreeAvgsSst1MaxGr300X'x2str(X(i)) 'Z'x2str(X(i)) 'Sq1Sp10Sl5.mat'];
   load(fn);
   plot(Times(1:11),OverAvg(1:11)/(X(i)^3),Cols(i,:));axis('tight');
else
   fn=['MaxTreeRho100/TreeAvgsSst1MaxGr300X'x2str(X(i)) 'Z'x2str(X(i)) 'Sq1Sp10Sl'int2str(Sl) '.mat'];
   load(fn);
   plot(Times,OverAvg/(X(i)^3),Cols(i,:));axis('tight');
end
   %plot(Times,(0.75.*OverAvg./pi).^(1/3),Cols(i,:));axis('tight');
  hold on
end
legend('50\mum','75\mum','100\mum','150\mum',2)%,'Thresh',2)
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[2 2 10 10]);
set(FigHdl,'PaperPositionMode','auto');
hold off
Setbox;
xlabel('Time (s)')
ylabel({'Area over threshold (Synthesising vol.)'});
%ylabel({'Threshold distance (\mum)'});
hold off