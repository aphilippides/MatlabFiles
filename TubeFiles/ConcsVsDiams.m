function ConcsVsDiams
dtube
cd MeshPaper\Fig1Data
diams=[10]%1,5,0.1,2]%,10]
for d=[0]%2,5,1]
    %ConcsVsDiamsDist(d,1,diams)
    %GetConcVsDiamRelationship(d,1);
    for diam=diams
        % ConcsVsDiamsTimeBurst(d,[0 .001025 0.002:0.001:0.1 0.11:0.01:1],1,diam)
%        ConcsVsDiamsTime(d,[0.001:0.001:1.1 0.11:0.01:1 1.1:0.1:10]+1,1,diam)
        ConcsVsDiamsDist(d,1,[0.1:0.1:10])
    end
end

function ConcsVsDiamsDist(DFromSurf,B,diams)

for i=1:length(diams)
   out=diams(i)/2
%   [C E Limit(i)]=Tube(DFromSurf+out,B,out,B,5e-3,100)
   [C E Limit(i)]=Tube(DFromSurf,B,out,B,5e-3,100)
   Conc(i)=C*0.00331;
   Err(i)=E*0.00331;
   fn=['ConcsD' x2str(DFromSurf) 'FromSurfB' x2str(B) 'T' x2str(B) 'DiffDiams.mat'];
   save(fn,'Conc','DFromSurf', 'Err' ,'Limit','diams')
end    
plot(diams,Conc,'r:')

function ConcsVsDiamsTime(d,Ts,B,diam)

for i=1:length(Ts)
    out=diam/2
    if (Ts(i)<=eps) C=0;Err=0;Limit(i)=0;
    else [C Err Limit(i)]=Tube(d+out,Ts(i),out,B,5e-3,100);
    end
    Err(i)=Err*0.00331;
    Conc(i)=C*0.00331
    fn=['ConcsD' x2str(d) 'FromDiam' x2str(diam) 'B' x2str(B) 'T' x2str(B) '_' x2str(Ts(end)) '.mat'];
    save(fn,'Conc','d', 'Err' ,'Limit','diam','Ts')
end    
plot(Ts,Conc,'r:')

function ConcsVsDiamsTimeBurst(d,Ts,B,diam)

out=diam/2
for i=1:2
    if (Ts(i)<=eps) C=0;Err=0;Limit(i)=0;
    else [C Err Limit(i)]=Tube(d+out,Ts(i),out,B,5e-3,100);
    end
    Limit
    Err(i)=Err*0.00331;
    Conc(i)=C*0.00331
    fn=['ConcsD' x2str(d) 'FromDiam' x2str(diam) 'B' x2str(B) 'T0_1.mat'];
    save(fn,'Conc','d', 'Err' ,'Limit','diam','Ts')
end 
for i=3:length(Ts)    
    [Conc(i) Err(i) Limit(i)]=ConcBurstEnd(Conc(i-1),Ts(i-1),Ts(i),diam,d+out)
    fn=['ConcsD' x2str(d) 'FromDiam' x2str(diam) 'B' x2str(B) 'T0_1.mat'];
    save(fn,'Conc','d', 'Err' ,'Limit','diam','Ts')
end 
plot(Ts,Conc,'r:')