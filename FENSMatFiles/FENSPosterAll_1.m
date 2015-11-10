function FENSPosterAll_1(Times)

Fhdl=figure;
FigDim=10;
NumTicks=2;
set(Fhdl,'Units','centimeters','Position',[5 5 FigDim+1.5 FigDim]);
%Times=[-1 0 250 500 750];
%Times=[1000];
for i=1:length(Times)
   Time=Times(i);
  FensPosterSingPic(Time,FigDim);
  % FensPosterMultPic(Time,FigDim);
end

function FensPosterSingPic(Time,FigDim)

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
set(gca,'TickLength',[0 0],'YTickLabel',{''},'XTickLabel',{''});
Picname=['FensSing' int2str(Time) ];
set(gca,'Units','centimeters','Position',[0 0 FigDim FigDim])

Drawcolorbar(FigDim)
%eval(['print -dtiffnocompression -r100 ' Picname 'dpi100.tif'])
%eval(['print -dtiffnocompression ' Picname '.tif'])
%eval(['print -djpeg ' Picname '.jpg'])
set(gca,'YTick',[ 1 150 300 ]);
set(gca,'YTickLabel',{ '0'; '150'; '300' });

set(gca,'XTick',[ 1 150 300 ]);
set(gca,'XTickLabel',{ '0'; '150' ; '300' });

function Drawcolorbar(FigDim)

h=colorbar;
set(h,'Units','centimeters','Position',[FigDim+0.5 0 0.75 FigDim])
Labs=get(h,'YTickLabels')
set(h,'YTickLabels',Labs)

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
set(gca,'TickLength',[0 0],'YTickLabel',{''},'XTickLabel',{''});
set(gca,'Units','normalized','Position',[0 0 1 1])
%h=colorbar;
Picname=['FensMult' int2str(Time) ]
%eval(['print -dtiffnocompression -r100 ' Picname 'dpi100.tif'])
%eval(['print -dtiffnocompression ' Picname '.tif'])
%eval(['print -djpeg ' Picname '.jpg'])
set(gca,'YTick',[ 1 150 300 ]);
set(gca,'YTickLabel',{ '0'; '150'; '300' });

set(gca,'XTick',[ 1 150 300 ]);
set(gca,'XTickLabel',{ '0'; '150' ; '300' });
%eval(['print -dtiffnocompression -r300 ' Picname ])
