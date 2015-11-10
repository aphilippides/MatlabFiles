function AllSurfaceConcs

%Diams=10:-0.1:0.1;
NewDiams=[5,3,1,0.5];
%Bursts=[1 5 10];
Bursts=[[0.1:0.05:1]]% [1.05:0.05:4.95] [5.05:0.05:9.95] 60];
%BurstBeg=[[0.1:0.05:0.9] [1:0.05:4.9] [5:0.05:9.9] 10];
Burst=0.1;
TotErr=zeros(size(NewDiams));
TotSC=zeros(size(NewDiams));
for i=2:length(Bursts)
    i
   [SConc,Err]=SurfaceConcEnd(Bursts(i),Bursts(i-1),NewDiams);
   TotSC=TotSC+SConc;
   TotErr=TotErr+Err;
end
%SurfaceConc(Burst)
dtube;
load MeshPaper\Fig1Data\TubeSurfaceConcDiam0_1_10B0_1.mat
for i=1:length(NewDiams)
    is(i)=find(abs(Diams-NewDiams(i))<1e-12);
end
TotSC=TotSC+SurfaceTubeConc(is)
TotErr=TotErr+Err(is)
load MeshPaper\Fig1Data\TubeSurfaceConcDiam0_1_10B1.mat
TotSC-SurfaceTubeConc(is)
