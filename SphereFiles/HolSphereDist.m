% function[Conc,T]=HolSphereDist(R0,R1,Burst,t,in,out,NumPts)

function[Conc,R]=HolSphereDist(R0,R1,Burst,t,in,out,NumPts)

R=R0:(R1-R0)/(NumPts-1):R1;
ind=find(R==0);
R(ind)=eps;
for i=1:length(R)
    Conc(i)=HolSphere(in,out,t,R(i),Burst);
end
plot(R,Conc)
