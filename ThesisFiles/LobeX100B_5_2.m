% function to draw Figure4 at time Timez

function LobeX100B_5_2(Ts)
SecondPic;
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 9 10]);
set(FigHdl,'PaperPositionMode','auto');

function SecondPic
dsmall;
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
B=[500,1,2000];
Widths=0.5*(10*(10)+2-10);
%subplot('Position',[0.15 0.15 0.8 0.8])
for i=1:length(B)
      filename=['Density/Mesh2dSSt1B' int2str(B(i)) 'MaxGr1000X100Sq2Sp10.dat'];
      M=load(filename);
      Timez=M(2:end,1);
      NumOver=1e6-M(2:end,4);
      Rad=max(0,(sqrt(NumOver./pi)-Widths));
      plot(Timez,Rad,Cols(i,:));
  %    plot(Timez,Rad./Widths(i),Cols(i,:));
      hold on;
end
hold off
Setbox;
SetXLim(gca,0,6)
h=xlabel('Time (s)');
h=ylabel('Threshold distance from edge of fibres ( \mum)');
h=legend('0.5s','1s','2s',2);




