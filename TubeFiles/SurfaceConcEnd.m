function[SurfaceTubeConc,Err]= SurfaceConcEnd(Time,Burst,Diams)

for i=1:length(Diams)
   Outer=Diams(i)*0.5
%   [SurfaceTubeConc(i) Err(i) Limit(i)]=Tube(Outer,Burst,Outer,Burst,1e-2,20);
   [SurfaceTubeConc(i) Err(i) Limit(i)]=Tube(Outer,Time,Outer,Time-Burst,5e-3,25);
   Limit;
   if (Limit >=24) pause; end;
   dtube
   fname=['MeshPaper\Fig1Data\TubeSurfaceConcData\TubeSurfaceConcDiam0_5_5B' x2str(Time-Burst) 'T' x2str(Time) '.mat'];
   %save(fname,'SurfaceTubeConc','Diams','Err','Limit')
end
SurfaceTubeConc=SurfaceTubeConc*.00331
Err=Err*.00331;
Limit
%save(fname,'SurfaceTubeConc','Diams','Err','Limit')
%plot(Diams,SurfaceTubeConc,[0.1 10],[2.5e-7 2.5e-7],'r:')
%fname2=['d:\MyDocuments\Tubedata\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Burst) '.ps'];
%print(gcf,'-dps',fname2)
%fname2=['d:\MyDocuments\Tubedata\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Burst) '.m'];
%saveas(gcf,fname2,'m')

