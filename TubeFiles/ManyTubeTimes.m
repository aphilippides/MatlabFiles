function ManyTubeTimes

Outers =10:-0.25:0.25;
Outers=[Outers 0.1];
TimeInt=0.1;
Times=TimeInt:TimeInt:10;
NumPts=100;
for i=1:length(Outers)
   i
   MaxR=50*(min(1,Outers(i)));
   DistVec=0:(MaxR/NumPts):MaxR;
   for j=1:length(Times)
      j
      TubeConc=TestTubeTime(Times(j),Outers(i)*0.5,TimeInt,NumPts,0,MaxR)
      eval(['save d:\MyDocuments\TubeData\TubeDiam' x2str(Outers(i)) 'TubeDiam' ...
            x2str(Outers(i)) 'B' x2str(TimeInt) 'T' x2str(Times(j)) '.mat Times TubeConc DistVec'])
   end
end

