function CheckLims(Bursts,q)

for j=1:length(Bursts)
   %filename=(['LimitsRad1_0_25_25B' x2str(Bursts(j)) 'EarlyQTimes10.mat'])
   %filename=['LimitsRad_05_05_5B' x2str(Bursts(j)) 'EarlyQTimes5.mat'];
   filename=['LimitsRad05_05_5B' x2str(Bursts(j)) 'EarlyQTimes' int2str(q) '.mat'];
   load(filename)
   save Limitstemp.mat
   for i=1:length(Rads)
      i
      if (RThresh(i)==0)
         Timee=Bursts(j);
      else
         Timee=TThresh(i);
      end
      [CheckConc(i) ErrorCheckConc(i) LimitCheckConc(i)]=Tube(RThresh(i),Timee,Rads(i),Bursts(j),1e-3,25);      
        LimitCheckConc
     save(filename,'LimitCheckConc','CheckConc','ErrorCheckConc','-append')
    end
   save(filename,'LimitCheckConc','CheckConc','ErrorCheckConc','-append')
   figure
   subplot(1,2,1),plot(Rads*2,CheckConc*0.00331)
   subplot(1,2,2),errorbar(Rads*2,CheckConc*0.00331,Err*.00331)
end