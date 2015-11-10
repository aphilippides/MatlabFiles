function[TConc,DVec]= TubesInSquare(NTubes,MaxR,NumPts,Burst,Diam,Spacing)

if(nargin==0)
    NTubes=4;
    MaxR=50;
    NumPts=100;
    Burst=1;
    Diam=2;
    Spacing=10;
end
[TubeConc,DistVec]=GetAnTubeConcs(Diam,Burst,Burst,0)
DVec=-MaxR:2*MaxR/NumPts:MaxR;

for j=1:length(DVec)
   TConc(j)=GetTubeConcAn(sqrt(DVec(j).^2+4*Spacing.^2),TubeConc,DistVec);
   TConc(j)=TConc(j)+GetTubeConcAn(sqrt(DVec(j).^2+9*Spacing.^2),TubeConc,DistVec);
   TConc(j)=TConc(j)+GetTubeConcAn(sqrt((DVec(j)+Spacing)^2 +4*Spacing^2),TubeConc,DistVec);
   TConc(j)=TConc(j)+GetTubeConcAn(sqrt((DVec(j)+Spacing)^2 +9*Spacing^2),TubeConc,DistVec);
end
TConc
plot(DVec,TConc,'r:')
return
hold on
plot(DistVec,TubeConc);
plot([-1*DVec(length(DVec)) DVec(length(DVec))], [2.5e-7 2.5e-7],'g--')
legend('Combined conc.','Individual conc.','Threshold conc.',0)
for i=1:(NTubes-1)/2
   plot(DistVec-Spacing*i,TubeConc);
   plot(DistVec+Spacing*i,TubeConc);
end
if(mod(NTubes,2)==0)
   plot(DistVec-Spacing*(NTubes/2),TubeConc);
end

xlabel('Distance (\mum)')
ylabel('Concentration (\muM)')
hold off
Setbox
SetXLim(gca,-MaxR,MaxR);
SetYLim(gca,min(TubeConc),1.05*max(TConc))
SetXTicks(gca,5);
SetYTicks(gca,6,1e6);

function[RConc]=GetTubeConcAn(r,Conc,Dists)

i=find(Dists==r);
if(isempty(i))
    il=find(Dists<r);
    ih=find(Dists>r);
    if(isempty(il)|isempty(ih)) 
        RConc=0;
    else
        RConc=Conc(il(end))+(Conc(ih(1))-Conc(il(end)))*(r-Dists(il(end)))/(Dists(ih(1))-Dists(il(end)));
    end
else
    RConc=Conc(i);
end