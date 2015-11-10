function[C,DistVec]=HolTubeTime(t,inn,out,NumPts,Burst,MinR,MaxR)

[CInn,DistVec]= TestTubeTime(t,inn,Burst,MinR,MaxR,NumPts);
[COut,DistVec]= TestTubeTime(t,out,Burst,MinR,MaxR,NumPts);
C=(COut-CInn)*0.00331;
plot(DistVec,C);