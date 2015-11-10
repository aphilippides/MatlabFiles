function AllLims(q)

GLOBE(q);
%Rads=25:-0.25:1;
Rads=[5:-0.05:0.05];
%Rads=[1:-0.05:0.05];
Bursts=[1]%0.1,1,5,10];
dtube

for j=1:length(Bursts)
   EndFlag=0;
   for i=1:length(Rads)
      if(EndFlag>0)
         RThresh(i)=0;
         TThresh(i)=TThresh(EndFlag);
         Err(i)=Err(EndFlag);
         ErrConc(i)=-100;
         LimConc(i)=-100;
      else   
         [RThresh(i),TThresh(i),Err(i),ErrConc(i),LimConc(i)]=TubeFindLim(7.5529e-5,0,Rads(i),Bursts(j))
         fname=['LimitsRad05_05_5B' x2str(Bursts(j)) 'EarlyQTimes' int2str(q) '.mat'];
         if (RThresh(i)==0)
            EndFlag=i;
         end
      end
      save(fname, 'RThresh', 'TThresh' ,'Err', 'Rads' ,'ErrConc', 'LimConc')
   end
end


CheckLims(Bursts,q);
%CheckAccFig1;