function[Conc,T]=Pt3dTime(T0,T1,Burst,r,NumPts)

T=T0:(T1-T0)/(NumPts-1):T1;
for i=1:length(T)
    Conc(i)=Pt3d(T(i),r,Burst);
end
plot(T,Conc)