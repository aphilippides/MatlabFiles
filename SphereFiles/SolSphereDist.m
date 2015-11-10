function[Conc,R]=SolSphereDist(R0,R1,Burst,t,Rad,NumPts)

R=R0:(R1-R0)/(NumPts-1):R1;
for i=1:length(R)
    Conc(i)=SolSphere(Rad,t,R(i),Burst);
end
plot(R,Conc)