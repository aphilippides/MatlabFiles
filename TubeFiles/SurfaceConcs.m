function SurfaceConcs(Burst)

%Diams=10:-0.1:0.1;
Diams=[0.5];
dtube;
cd MeshPaper\Fig1Data\
for i=1:length(Diams)
   Outer=Diams(i)*0.5
%   [SurfaceTubeConc(i) Err(i) Limit(i)]=Tube(Outer,Burst,Outer,Burst,1e-2,20);
   [SurfaceTubeConc(i) Err(i) Limit(i)]=Tube(Outer,Burst,Outer,Burst,5e-3,25);
   Limit
   fname=['TubeSurfaceConcDiam0_5_B' x2str(Burst) '.mat'];
   save(fname,'SurfaceTubeConc','Diams','Err','Limit')
end
SurfaceTubeConc=SurfaceTubeConc*.00331
Err=Err*.00331;
Limit
save(fname,'SurfaceTubeConc','Diams','Err','Limit')
plot(Diams,SurfaceTubeConc,[min(Diams) max(Diams)],[2.5e-7 2.5e-7],'r:')
fname2=['d:\MyDocuments\Tubedata\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Burst) '.ps'];
%print(gcf,'-dps',fname2)
fname2=['d:\MyDocuments\Tubedata\Fig1Data\TubeSurfaceConcDiam0_1_10B' x2str(Burst) '.m'];
%saveas(gcf,fname2,'m')



