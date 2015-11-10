function Showdiff2to3d(GridSize, Density,Slice,Version,Time)

Sqare=1;
if(Time==-1)
filename=['MaxPerpRho' num2str(Density) '/TreeV' int2str(Version) 'Gr' num2str(GridSize) 'Sq' num2str(Sqare) 'T' num2str(Time) '.dat']
	M1=load(filename)*0.5;
else
   filename=['MaxPerpRho' num2str(Density) '/TreeV' int2str(Version) 'Sl' num2str(Slice) 'Gr' num2str(GridSize) 'Sq' num2str(Sqare) 'T' num2str(Time) '.dat']
	M1=load(filename);
end
filename2=['../Fast/MaxTreeRho' num2str(Density) '/TreeV' int2str(Version) 'Gr' num2str(GridSize) 'Sq' num2str(Sqare) 'T' num2str(Time) '.dat']
M2=load(filename2);
M3=M2(GridSize:-1:1,GridSize:-1:1);
subplot(1,3,1),pcolor(M1),colorbar,shading interp,subplot(1,3,2),pcolor(M3),colorbar,shading interp,subplot(1,3,3),pcolor((M3-M1)./M3),colorbar,shading interp

