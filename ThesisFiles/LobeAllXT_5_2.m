% function to draw Figure4 at time Timez

function LobeAllXT_5_2(Ts)
FirstPic;
SecondPic;
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
X=get(FigHdl,'Position');
set(FigHdl,'Position',[X(1) X(2) 18 10]);
set(FigHdl,'PaperPositionMode','auto');

function FirstPic(Ts)
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
if(nargin<1) Ts=[0.1,0.5,1,2];end;
Space=10;
Sq=2;
XT=1:15;
NumTs=XT.^2;
SynthWidth=0.5*(XT*(Space)+Sq-Space);%.^2;
subplot('Position',[0.1 0.15 0.35 0.8])
for i=1:length(Ts)
    AffVol=GetLobeAffVolumes(NumTs,Ts(i),Sq,Space);
    plot(XT,sqrt(AffVol./pi)./SynthWidth,Cols(i,:));
    hold on;
end
hold off
Setbox;
h=xlabel('Number of sources');
SetXTicks(gca,1,1,0,[1,5,10,15],int2str(([1,5,10,15].^2)'));
h=ylabel({'Threshold distance';'(`radius` of synthesising region)'});
%h=legend(num2str(Ts'));
axis tight
h=legend('0.1s','0.5s','1s','2s',2);

function SecondPic
dsmall;
Cols=['b- .';'r: x';'g--s';'k-.d';'y- +'];
X=[5,10];
NumTs=X.^2;
Widths=0.5*(X*(10)+2-10);
subplot('Position',[0.6 0.15 0.35 0.8])
for i=1:length(NumTs)
      filename=['Density/Mesh2dSSt1B1MaxGr1000X' int2str(NumTs(i)) 'Sq2Sp10.dat'];
      M=load(filename);
      Timez=M(2:end,1);
      NumOver=1e6-M(2:end,4);
      Rad=max(0,(sqrt(NumOver./pi)-Widths(i)));
      plot(Timez,Rad,Cols(i,:));
  %    plot(Timez,Rad./Widths(i),Cols(i,:));
      hold on;
end
hold off
Setbox;
h=xlabel('Time (s)');
h=ylabel('Threshold distance from edge of fibres (\mum)');
h=legend('25 fibres','100 fibres',2);

function[AffVol]= GetLobeAffVolumes(NumTs,Time,Square,Space)

dsmall
for i=1:length(NumTs)
   if(NumTs(i)==1)
      AffVol(i)=0;
   else      
      filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat'];
      M=load(filename);
      [X,Y]=size(M);
      Timez=M(2:X,1);
      NumOver=1e6-M(2:X,4);
      AffVol(i)=NumOver(find(Timez==Time));
   end
end


