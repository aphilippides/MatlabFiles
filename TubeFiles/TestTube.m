function TestTube(t,out,NumPts)

%DistVec=0:1.5*out/NumPts:1.5*out;
DistVec=[120:130];
for i=1:length(DistVec)
   i
   %Conc(i)=InstTube(t,DistVec(i),out,1e-4,100);
   Conc(i)=Tube(DistVec(i),t,out,1,1e-2,100)
   i
   %QConc(i)=quad8('InstRing',0,out,1e-4,[],DistVec(i),t);
end
%plot(DistVec,Conc,DistVec,QConc,'r:')
plot(DistVec,Conc*.00331,'r:')
keyboard