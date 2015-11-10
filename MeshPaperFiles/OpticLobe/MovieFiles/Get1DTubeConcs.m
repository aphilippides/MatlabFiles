function Get1DTubeConcs(GridSize,SSt,Diam,Time)

Times=500:500:5000;
Times=[-1 Times];
for i=1:length(Times)
   filename=['SingleSource/MeshSSt' num2str(SSt) 'Gr' num2str(GridSize) ...
         'Sq' num2str(Diam) 'SingT' int2str(Times(i)) '.dat']
   M=load(filename);
   Conc1D=M(GridSize/2,:).*1.324e-4;
   [x,y]=FracRem(1./SSt);
   if(y==0)
	fname=['d:\MyDocuments\TubeData\Diam' num2str(Diam) '\MeshSSt' int2str(SSt) ...
         'Gr' num2str(GridSize) 'Sq' num2str(Diam) 'SingB5T' int2str(Times(i)) '.mat']   
   else
      y=WholeNum(y);
  	fname=['d:\MyDocuments\TubeData\Diam' num2str(x) '_' num2str(y) '\MeshSSt' int2str(SSt) ...
         'Gr' num2str(GridSize) 'Sq' num2str(Diam) 'SingB5T' int2str(Times(i)) '.mat']   
   end
   save(fname,'Conc1D')   
end
