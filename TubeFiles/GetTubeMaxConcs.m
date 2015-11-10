function GetTubeMaxConcs(Burst)

%TubeWidths=[0.05,0.125,0.25,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,6,7,8,9,10,12.5,25];
TubeWidths=[25,12.5,10,9,8,7,6,5,4.5,4,3.5,3,2.5,2,1.5,1,0.5,0.25,0.125,0.05]
for i=1:length(TubeWidths)
   i
   [MaxTubeConc(i),Errors(i),Limits(i)]=Tube(0,Burst,TubeWidths(i),Burst,1e-2,20)
   save MaxTubeConcsB1_05_50.mat MaxTubeConc Errors Limits TubeWidths
end
