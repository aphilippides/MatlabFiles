function[Conc,R]=Pt3dDist(R0,R1,Burst,t,NumPts)

R=R0:(R1-R0)/(NumPts-1):R1;
for i=1:length(R)
    Conc(i)=Pt3d(t,R(i),Burst);
end
plot(R,Conc)