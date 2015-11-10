function[TubeConcAn,DistVec]= GetAnTubeConcs(Diam,t,Burst,Plot)
dtube;
TimeInt=0.1;
NumB=Burst/TimeInt;
NumT=t/TimeInt;
if(t<=Burst)
   Conc=0;
   for j=1:NumT
      if(Diam>=1)
			filename=['Diam' int2str(floor(Diam)) '\TubeDiam' x2str(Diam) 'B' x2str(TimeInt) 'T' int2str(TimeInt*j*1000) '.mat'];
      else
         filename=['Diam' x2str(Diam) '\TubeDiam' x2str(Diam) 'B' x2str(TimeInt) 'T' int2str(TimeInt*j*1000) '.mat'];
      end
      M=load(filename);
      Conc=Conc+M.TubeConcAn;
   end
   TubeConcAn=[Conc(length(Conc):-1:2) Conc].*0.00331;
   Dists=M.DistVec;
   DistVec=[-1*Dists(length(Dists):-1:2) Dists];     
else   
  Conc=0;
   for j=0:NumB-1
      if(Diam>=1)
			filename=['Diam' int2str(floor(Diam)) '\TubeDiam' x2str(Diam) 'B' x2str(TimeInt) 'T' int2str((NumT-j)*TimeInt*1000) '.mat'];
      else
         filename=['Diam' x2str(Diam) '\TubeDiam' x2str(Diam) 'B' x2str(TimeInt) 'T' int2str((NumT-j)*TimeInt*1000) '.mat'];
      end
      M=load(filename);
      Conc=Conc+M.TubeConc;
   end
   TubeConcAn=[Conc(length(Conc):-1:2) Conc].*0.00331;
   Dists=M.DistVec;
   DistVec=[-1*Dists(length(Dists):-1:2) Dists];    
end
if (Plot)
   plot(DistVec,TubeConcAn,'b-x')
end
