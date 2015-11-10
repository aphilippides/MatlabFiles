function TubeAnVsDEAllTimesV2(SSt,Diam,T)
OutStats=[];
for i=1:length(Diam)
   [TubeConcAn,TubeConcDE,Differ,RelDiff,DistVec]=TubeAnVsDE(SSt,Diam(i),T);
   AvgDiff(i)=mean(abs(Differ))*1e6;
   StdDiff(i)=std(abs(Differ))*1e6;
   [m,ind]=max(abs(Differ))%;*1e6;
   MaxDiff(i)=Differ(ind)*1e6;
   AvgRel(i)=mean(abs(RelDiff));
   StdRel(i)=std(abs(RelDiff));
   [m,ind]=max(abs(RelDiff));
   MaxRel(i)=RelDiff(ind);
   NumBad(i)=length(find(abs(RelDiff)>0.005));
end
fn=['TubeDiams1_5B' int2str(T*1000) 'AnVsDEDiffData.mat'];   
save(fn,'AvgDiff','StdDiff','MaxDiff','AvgRel','StdRel','MaxRel','NumBad','DistVec','Diam')