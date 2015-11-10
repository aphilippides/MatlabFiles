% function to get and draw data for fig1b

function InteractionThresh

Bursts=[0.1,1,5,10];
Diams=[10:-0.25:0.5];
for i=1:length(Bursts)
   for j=1:length(Diams)
      Burst=Bursts(i);
      t=Burst;
      Diam=Diams(j)
      fname=['d:\MyDocuments\TubeData\Fig1Data\TubeDiam' x2str(Diam) 'B' x2str(Burst) 'T' int2str(t*1000) '.mat']
      load(fname);
      DistVec
      Index=find(DistVec==Diam)
      SurfaceConc(j)=TubeConcAn(Index);
   end
   figure
   plot(Diams,TubeConcAn)
   fname2=['d:\MyDocuments\TubeData\Fig1Data\TubeDiam0_1_10B' x2str(Burst) 'T' int2str(t*1000) '.mat']
   save(fname2,'SurfaceConc','Diams','Burst','t')
end

      