function[TConc,DVec]= TubesInLine(NTubes,MaxR,NumPts,Burst,Diam,Spacing)

SingPlot(gcf);
if(nargin==0)
    NTubes=9;
    MaxR=50;
    NumPts=200;
    Burst=1;
    Diam=2;
    Spacing=10;
end
[TubeConc,DistVec]=GetAnTubeConcs(Diam,Burst,Burst,0)
DVec=-MaxR:2*MaxR/NumPts:MaxR;
NTubes=4;
for j=1:length(DVec)
   TConc(j)=GetTubeConcAn(DVec(j),TubeConc,DistVec);
   for i=1:(NTubes-1)/2     
      TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)+Spacing*i),TubeConc,DistVec);
      TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)-Spacing*i),TubeConc,DistVec);
   end
   if(mod(NTubes,2)==0)
        TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)+Spacing*(NTubes/2)),TubeConc,DistVec);
   end
end
plot(DistVec(21:160),TConc(21:160),ThCols(1));
hold on
NTubes=9;

for j=1:length(DVec)
   TConc(j)=GetTubeConcAn(DVec(j),TubeConc,DistVec);
   for i=1:(NTubes-1)/2     
      TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)+Spacing*i),TubeConc,DistVec);
      TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)-Spacing*i),TubeConc,DistVec);
   end
   if(mod(NTubes,2)==0)
        TConc(j)=TConc(j)+GetTubeConcAn((DVec(j)+Spacing*(NTubes/2)),TubeConc,DistVec);
   end
end
TConc
plot(DVec,TConc,ThCols(2))
plot(DistVec,TubeConc,':');
plot([-1*DVec(length(DVec)) DVec(length(DVec))], [2.5e-7 2.5e-7],'g--')
legend('4 fibres','9 fibres','1 fibre','Threshold',0)
for i=1:(NTubes-1)/2
   plot(DistVec-Spacing*i,TubeConc,':');
   plot(DistVec+Spacing*i,TubeConc,':');
end
if(mod(NTubes,2)==0)
   plot(DistVec-Spacing*(NTubes/2),TubeConc,':');
end


xlabel('Distance (\mum)')
ylabel('Concentration (\muM)')
hold off
Setbox
SetXLim(gca,-MaxR,MaxR);
SetYLim(gca,min(TubeConc),1.15*max(TConc))
SetXTicks(gca,5);
SetYTicks(gca,[],1e6,2,[0.05:0.1:0.35]*1e-6);

function[RConc]=GetTubeConcAn(r,Conc,Dists)

i=find(Dists==r);
if(isempty(i))
   RConc=0;
else
   RConc=Conc(i);
end