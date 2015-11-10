% function[Conc,T]=SolSphereTime(T0,T1,Burst,r,Rad,NumPts)

function[Conc,T]=SolSphereTime(T0,T1,Burst,r,Rad,NumPts)

T=T0:(T1-T0)/(NumPts-1):T1;
for i=1:length(T)
    Conc(i)=SolSphere(Rad,T(i),r,Burst);
end
plot(T,Conc,'b-x')