function TubeAnVsDEAllTimes(SSt,Diam,T)
OutStats=[];
for j=1:length(Diam)
   for i=1:length(T)
      [TubeConcAn,TubeConcDE,Differ(i,:),RelDiff(i,:),DistVec]=TubeAnVsDE(SSt,Diam(j),T(i));
   end
   AvgDiff=mean(abs(Differ'))*1e6;
   StdDiff=std(abs(Differ'))*1e6;
   MaxDiff=max(abs(Differ'))*1e6;
   AvgRel=mean(abs(RelDiff'));
   StdRel=std(abs(RelDiff'));
   MaxRel=max(abs(RelDiff'));
   OutStats=[OutStats [Diam(j)*ones(size(T));T;MaxRel;AvgRel;StdRel;MaxDiff;AvgDiff;StdDiff]]   
	clear Differ RelDiff;   
end
fn=['TubeDiams1_4B2AnVsDEDiffData.dat'];   
fid=fopen(fn,'w')
fprintf(fid,'Diam  Time  MaxRelDiff  MeanRelDiff  SDRelDiff  (MaxDiff  MeanDiff  SDDiff)x1e6\n');
fprintf(fid,'%2d    %.2f   %.6f    %.6f    %.6f   %.6f   %.6f   %.6f\n',OutStats);
fclose(fid)
