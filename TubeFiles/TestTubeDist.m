function[Conc,TimeVec]= TestTubeDist(r,diam,NumPts,Burst,MinT,MaxT)

out=diam/2;
TimeVec=MinT:(MaxT-MinT)/NumPts:MaxT;
%TimeVec=[TimeVec(1:10) 0.2:0.001:0.35 TimeVec(19:end)];
%if(TimeVec(1)==0) TimeVec(1)=eps; end
%TimeVec=[Burst,Burst+eps,Burst+1e2*eps,Burst+1e4*eps,Burst+1e6*eps,Burst+1e8*eps]
for i=1:length(TimeVec)
   %Conc(i)=InstTube(t,DistVec(i),out,1e-4,100);
   if(TimeVec(i)<=eps) 
      Conc(i)=0;
      Limit(i)=0;
      Err(i)=0;
   else
      [Conc(i) Err(i) Limit(i)]=Tube(r,TimeVec(i),out,Burst,5e-3,25);
   end
   Limit(i)
   %QConc(i)=quad8('InstRing',0,out,1e-4,[],DistVec(i),t);
   %save(['SingleKCConc_at_' x2str(r) '.mat'],'Conc','Err','Limit','TimeVec');
end
%plot(DistVec,Conc,DistVec,QConc,'r:')
plot(TimeVec,Conc*.00331,'r:')