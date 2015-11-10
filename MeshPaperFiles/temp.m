function temp
clear
Bursts=[0.1 1 5 10]
for j=1:length(Bursts)
   filename=(['Fig1CheckRadsErrB' x2str(Bursts(j)) 'Early.mat']);
   load(filename)
   Y2Early=Y2;
   LimY2Early=LimY2;
   ErrY2Early=ErrY2;
   RadsEarly=Rads;
   X2Early=X2;   
   filename=(['Fig1ChecRadsErrB' x2str(Bursts(j)) '.mat']);
   load(filename)
         save(filename,'Rads','Y2','LimY2','ErrY2','X2')

   i=find(Rads==RadsEarly(1))
   Rs=1:i-1;
   Y2=[ Y2(Rs) Y2Early];
   X2=[X2(Rs) X2Early ];
   ErrY2=[ErrY2(Rs) ErrY2Early ];
   LimY2=[LimY2(Rs) LimY2Early ];
   chRs=[Rads(Rs) RadsEarly]
   plot(Rads,Y2*.00331)
   filename=(['Fig1CheckRads1_25ErrB' x2str(Bursts(j)) '.mat']);
   save(filename,'Rads','Y2','LimY2','ErrY2','X2')
end


function alterlimitsfiles
clear
Bursts=[0.1 1 5 10]
for j=1:length(Bursts)
   filename=(['LimitsRad1_0_25_25B' x2str(Bursts(j)) 'Early.mat']);
   load(filename)
   RThreshEarly=RThresh;
   TThreshEarly=TThresh;
   ErrEarly=Err;
   RadsEarly=Rads;
   ErrConcEarly=ErrConc;
   LimConcEarly=LimConc;
   LimitCheckConcEalr=LimitCheckConc;
   CheckConcEarly=CheckConc;
   ErrorCheckConcEarly=ErrorCheckConc;
   
   filename=(['LimitsRad1_0_25_25B' x2str(Bursts(j)) '.mat']);
   load(filename)
   
   i=find(Rads==RadsEarly(1))
   Rs=1:i-1;
   RThresh=[ RThresh(Rs) RThreshEarly];
   TThresh=[TThresh(Rs) TThreshEarly ];
   Err=[Err(Rs) ErrEarly ];
   ErrConc=[ErrConc(Rs) ErrConcEarly ];
   LimConc=[LimConc(Rs) LimConcEarly ];
   LimitCheckConc=[LimitCheckConc(Rs) LimitCheckConcEalr ];
   CheckConc=[ CheckConc(Rs) CheckConcEarly];
   ErrorCheckConc=[ErrorCheckConc(Rs) ErrorCheckConcEarly ];
   chRs=[Rads(Rs) RadsEarly]
   plot(Rads,RThresh)
   filename=(['LimitsRads1_25_25B' x2str(Bursts(j)) '.mat']);
   save(filename,'RThresh', 'TThresh' ,'Err', 'Rads' ,'ErrConc', 'LimConc',...
      'LimitCheckConc','CheckConc','ErrorCheckConc');
end
