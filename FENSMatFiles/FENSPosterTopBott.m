function FENSPosterTopBott(Time)

Fhdl=figure;
FigDim=10;
NumTicks=2;
set(Fhdl,'Units','centimeters','Position',[0.5 -5 12 23]);
S1hdl=subplot(2,1,1)
set(S1hdl,'Units','centimeters','Position',[1 12 FigDim FigDim]) 
FensPosterSingPic(Time);
S2hdl=subplot(2,1,2)
set(S2hdl,'Units','centimeters','Position',[1 1 FigDim FigDim]) 
FensPosterMultPic(Time);

function FensPosterSingPic(Time)

x1=1;x2=300;r1=1;
y1=x1;y2=x2;r2=r1;
%filename=['Sq' num2str(Square) 'Sp' num2str(Space) '/MeshSq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
filename=['Sq2Sp30/MeshSq2SingleT' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
%maxim=max(max(MData))
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
caxis([0 aff]);
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight;axis equal;axis([1 300 1 300])
hold off
%title(['Time = ' int2str(Time) 'ms']);xlabel('X (\mum)');ylabel('Y (\mum)');
set(gca,'YTick',[ 1 150 300 ]);
set(gca,'YTickLabel',{ '0'; '150'; '300' });

set(gca,'XTick',[ 1 150 300 ]);
set(gca,'XTickLabel',{ '0'; '150' ; '300' });
%eval(['print -dtiffnocompression -r100 ' Picname ])
%colorbar;


function FensPosterMultPic(Time,ColorB,NumTicks)

x1=1;x2=300;r1=1;
y1=x1;y2=x2;r2=r1;
filename=['Sq2Sp30/MeshSq2Sp30T' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
%maxim=max(max(MData))
aff=2.5e-7;%./(0.00331*.04)
pcolor(MData);
caxis([0 aff]);
shading interp
hold on
[c,h]=contour(MData,[aff aff],'k');
axis tight;axis equal;axis([1 300 1 300])
hold off
%title(['Time = ' int2str(Time) 'ms']);xlabel('X (\mum)');ylabel('Y (\mum)');
set(gca,'YTick',[ 1 150 300 ]);
set(gca,'YTickLabel',{ '0'; '150'; '300' });

set(gca,'XTick',[ 1 150 300 ]);
set(gca,'XTickLabel',{ '0'; '150' ; '300' });
%eval(['print -dtiffnocompression -r300 ' Picname ])
%colorbar