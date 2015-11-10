% function which plots parts of matrices as flat maps   
% for Jn fig 11 args are DEcontour(1,35,475,1,550,1,1,1)

function DEcontour(Time,x1,x2,y1,y2,r1,r2,Source)

cd d:/mydocuments/Diffequn/Space/DE
%aff=0.0634;
%aff=1e-7;
aff=1e-7./(0.00331*.04)
colormap('gray');
axis equal
if (Source==1)
	cla
	M=get_datam(0);
	N = M(x1:r1:x2,y1:r2:y2)*-1.0;
	pcolor(N);
	shading interp;
	axis([1 ((y2-y1)/r2)+1 1 ((x2-x1)/r1)+1 0 1.01])
end
hold on
Timez=[25,50,100];
for i=1:0
   Time = Timez(i);
M=get_datam(Time);
max(max(M))
N = M(x1:r1:x2,y1:r2:y2);
shading interp
view(90,90);
contour(N,[aff aff],'r');
%hold off
%axis([1 ((y2-y1)/r2)+1 1 ((x2-x1)/r1)+1 0 1.01])
end
axis equal
axis([30 550 15 455])
X=60:70:550;
Y=15:70:435;
set(gca,'XTick',X);
set(gca,'YTick',Y);

XL=70:-10:0;
YL=0:10:60;
set(gca,'XTickLabel',XL);
set(gca,'YTickLabel',YL);

view(90,90);
