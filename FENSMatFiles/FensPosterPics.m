% function which plots parts of matrices as flat maps   
% for Jn fig 11 args are DEcontour(1,35,475,1,550,1,1,1)

function FensPosterPics(Square,Space,Timer)

x1=1;x2=300;r1=1;
y1=x1;y2=x2;r2=r1;
Timez=[-1,0,250,500,750,1000];
for i=6:length(Timez)
   %Time=(Timez(i))
   %filename=['Sq' num2str(Square) 'Sp' num2str(Space) '/MeshSq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Timer) '.dat']
   %Picname=['Sq' num2str(Square) 'Sp' num2str(Space) '/MeshSq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Timer) '.tif']
   filename=['Sq' num2str(Square) 'Sp' num2str(Space) '/MeshSq' num2str(Square) 'SingleT' num2str(Timer) '.dat']
   Picname=['Sq' num2str(Square) 'Sp' num2str(Space) '/MeshSq' num2str(Square) 'SingleT' num2str(Timer) '.tif']
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
   %title(['Time = ' int2str(Timer) 'ms']);xlabel('X (\mum)');ylabel('Y (\mum)');
   set(gca,'YTick',[ 1 50 100 150 200 250 300 ]);
   set(gca,'YTickLabel',{ '0'; '50'; '100'; '150'; '200'; '250'; '300' });
   
   set(gca,'XTick',[ 1 50 100 150 200 250 300 ]);
   set(gca,'XTickLabel',{ '0'; '50'; '100'; '150'; '200'; '250'; '300' });
   %eval(['print -dtiffnocompression -r300 ' Picname ])
   %colorbar;
end
