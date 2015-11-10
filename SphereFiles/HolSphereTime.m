% function[Conc,T]=HolSphereTime(T0,T1,Burst,r,R1,R2,NumPts)

function[Conc,T]=HolSphereTime(T0,T1,Burst,r,R1,R2,NumPts)

T=T0:(T1-T0)/(NumPts-1):T1;
for i=1:length(T)
    Conc(i)=HolSphere(R1,R2,T(i),r,Burst);
end
plot(T,Conc)