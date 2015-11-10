% function which plots parts of matrices as flat maps   

function DE_3dplot(Time,x1,x2,y1,y2,r1,r2)


if (Time<=0)
	%load twodSINK_0.mat
	load twod7S_L1_0.mat
	colormap('copper');
   %N = M(300:r1:700,300:r2:700)*-1.0;
   N = DEdat(300:r1:700,300:r2:700)*-1.0;
	%n=max(max(M))
	pcolor(N);
	%surfl(N,[125 50]);
	shading interp;
	view(150,70);
	axis([1 200 1 200 0 1.01])
else
	M=get_datam(Time);
	N = M(x1:r1:x2,y1:r2:y2);
	colormap('copper');
	%n=max(max(M))
	%pcolor(N);
	surfl(N,[125 50]);
	shading interp;
	view(150,70);
	%axis([1 ((y2-y1)/r2)+1 1 ((x2-x1)/r1)+1 0 1.01])
end
