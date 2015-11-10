function Treemax3d(GridSize, Density,Sqare,Version,Slice)
Densities=[133,200];
for i=1:2
   Version =i+20;
   Density=Densities(i);
%filename=['TreeRho' num2str(Density) '/TreeV' int2str(Version) 'MaxGr' num2str(GridSize) 'Sq' num2str(Sqare) '.dat']
filename=['MaxTreeRho' num2str(Density) '/TreeV' int2str(Version) 'MaxGr' num2str(GridSize) 'Sq' num2str(Sqare) 'Sl' int2str(Slice) '.dat']
M=load(filename);
[Y,X]=size(M);
%Times=2:1:Y;
Times=M(2:Y,1);
Thresh=ones(Y-1)*.00188;
Maximums=M(2:Y,2);
Minimums=M(2:Y,3);
NumNot=M(2:Y,4);
PCNot=NumNot./((GridSize/2)^3);
subplot(1,2,1),plot(Times,Maximums,Times,Minimums,Times,Thresh),hold on,
%legend('Max Conc', 'Min Conc','Thresh Conc');
subplot(1,2,2),plot(Times,NumNot),title('% not over thresh');hold on,
end
subplot(1,2,1),hold off,grid
subplot(1,2,2),;hold off,grid
