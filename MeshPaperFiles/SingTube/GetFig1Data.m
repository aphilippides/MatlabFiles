% Function to get data for Figure 1 of paper

function GetFig1Data

Bursts=[0.1,1,5,10];
%Diams=[10:-0.25:1]
Diams=[0.75]% 0.5 0.25 0.1]
dtube;
cd MeshPaper\Fig1Data\
for i=1:length(Bursts)
   for j=1:length(Diams)
      Burst=Bursts(i);
      t=Burst;
      Diam=Diams(j);
      [TubeConcAn,DistVec]=GetAnTubeConcs(Diam,t,Burst);
      fname=['TubeDiam' x2str(Diam) 'B' x2str(Burst) 'T' int2str(t*1000) '.mat']
      save(fname,'TubeConcAn','DistVec')   
   end
end