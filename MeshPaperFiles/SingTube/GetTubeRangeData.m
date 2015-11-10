% Function to get distances at which conc drops to a percentage of the
% central or surface concentration  or a specified concentration

function GetTubeRangeData

Bursts=[1,0.1];
Diams=[30:-1:10 9.9:-0.1:0.1]
dtube;
cd MeshPaper\Fig1Data\
for Burst=Bursts
   for j=1:length(Diams)
      t=Burst;
      Diam=Diams(j);
      [CentConc(j),Err(j),Limit(j)] = Tube(eps,Burst,Diam/2,Burst,0.001,20)
      fname=['CentTubeConcsB' x2str(Burst) 'T' x2str(Burst) '.mat'];
      save(fname,'CentConc','Err','Limit','Diams')   
   end
end