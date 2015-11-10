function TubeBurst(d)

Times=[0:0.001:0.1 0.11:0.01:1 1.1:0.1:10 11:1:60];
%Times=[0:0.001:.003 60];
dtube; cd MeshPaper/Fig1Data;
load TubeSurfaceConcDiam1_5B0_001.mat
is=find(abs(Diams-d)<1e-12);
SurfaceConc(1)=0;
ErrConc(1)=0;
SurfaceConc(2)=SurfaceTubeConc(is);
ErrConc(2)=Err(is);
for i=3:length(Times)
    i
   [SConc,Err]=SurfaceConcEnd(Times(i),Times(i-1),d);
   SurfaceConc(i)=SurfaceConc(i-1)+SConc;
   ErrConc(i)=ErrConc(i-1)+Err;
   % dtube; 
   fname=['TubeSurfaceConcTimeDiam' x2str(d) 'B' x2str(Times(end)) 'T0_001_60.mat'];
   save(fname,'SurfaceConc','Times','ErrConc')
end
save(fname,'SurfaceConc','Times','ErrConc')
lt=length(Times)
Times=[Times Times(2:end)+60];

for i=lt+1:length(Times)
    i;
   [sc ec Limit(i-lt)]=Tube(d/2,Times(i),d/2,Times(lt),5e-3,100);  
   SurfaceConc(i)=sc*0.00331;
   ErrConc(i)=ec*0.00331;
   Limit
   dtube; cd MeshPaper/Fig1Data;
   fname=['TubeSurfaceConcTimeDiam' x2str(d) 'B60T0_120.mat'];
   save(fname,'SurfaceConc','Times','ErrConc')
end
save(fname,'SurfaceConc','Times','ErrConc')
plot(Times,SurfaceConc)
% plot(Times,SurfaceConc,[Times(1) Times(end)],[2.5e-7 2.5e-7],'r:')