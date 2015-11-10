function[TubeConcAn,TubeDEConc,Differ,RelDiff,DistVec]= TubeAnVsDEData(Diam,Time)
dtube;
fname=['Diam' int2str(Diam) '\MeshSSt1Gr1000Sq' num2str(Diam) 'SingB5T' int2str(Time*1000) '.mat']   
dsmall
%fname=['SingleSource/MeshSSt1Gr1000Sq2SingStr1000T' num2str(Time*1000) '.dat'];
fname=['SingleSource/MeshSSt1Gr1000Sq'num2str(Diam) 'SingT' num2str(Time*1000) '.dat'];
%fname=['SingleSource/MeshSSt1Gr1000Sq' x2str(Diam) 'SingTSt_01T' num2str(Time*1000) '.dat'];
M=load(fname);
dtube;
[TubeConc,Dists]=GetAnTubeConcs(Diam,Time,Time,0);
[TubeConcAn,DistVec]=GetTubeRunMeans2(Diam,TubeConc,Dists);
Conc1D=M(500,:).*1.324e-4;
TubeDEConc=GetDEConc(Conc1D,length(TubeConcAn),Diam,0)
Differ=TubeConcAn-TubeDEConc;
RelDiff=Differ./TubeConcAn;

function[TubeConcAn,DistVec]=GetTubeRunMeans(Diam,TubeConc,Dists);
if(rem(Diam,2)>0)
   TubeConcAn=TubeConc(3:2:end-1)*0.5+0.25*(TubeConc(2:2:end-2)+TubeConc(4:2:end));
   DistVec=Dists(3:2:end-1);
else
   TubeConcAn=TubeConc(4:2:end-2)*0.5+0.25*(TubeConc(3:2:end-3)+TubeConc(5:2:end-1));
   DistVec=Dists(4:2:end-2);
end

function[TubeDEConc]=GetDEConc(Conc1D,LTConcAn,Diam,Inn) 
x1=ceil((length(Conc1D)-LTConcAn)/2)+floor(Diam/2);
x2 =x1+LTConcAn-1;
TubeDEConc=Conc1D(x1:x2).*0.25.*pi;

function[TubeConcAn,DistVec]=GetTubeRunMeans2(Diam,TubeConc,Dists);
if(rem(Diam,2)>0)
   TubeConcAn=TubeConc(1:2:end);
   DistVec=Dists(1:2:end);
else
   TubeConcAn=TubeConc(2:2:end);
   DistVec=Dists(2:2:end);
end


