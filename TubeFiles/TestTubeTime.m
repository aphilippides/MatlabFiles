function[Conc,DistVec,Err ,Limit]= TestTubeTime(t,diam,Burst,MinR,MaxR,NumPts)
dtube
cd MeshPaper\Fig1Data
out=diam/2;
global LAM;
global DIFF;
DIFF=NumPts;
for half=MaxR
    LAM=log(2)/(half/1000);
    if(length(MinR)>1) DistVec=MinR;
    else DistVec=MinR:(MaxR-MinR)/NumPts:MaxR;
    end
    ind=find(DistVec==0);
    DistVec(ind)=eps;
    Err=[];Limit=[];
    for i=1:length(DistVec)
        i
        %Conc(i)=InstTube(t,DistVec(i),out,1e-4,100);
        Flag=1;
        fn=['notfileTubeSurfaceConcDiam0_1_10B' x2str(Burst) '.mat'];
        if((DistVec(i)==out)&(isfile(fn))&(Burst==t))
            E=Err;L=Limit;
            load(fn);
            ind = find(abs(Diams-diam)<1e-6);
            if(~isempty(ind)) 
                Flag=0;
                Conc(i) = SurfaceTubeConc(ind);
                E(i) = Err(ind); Err=E;
                L(i) = Limit(ind); Limit=L;
            end
        end
        if(Flag)
            [C E Limit(i)]=Tube(DistVec(i),t,out,Burst,5e-3,100)
            Conc(i)=C*0.00331;
            Err(i)=E*0.00331;
        end
        %    fn=['TubeDiam' x2str(diam) 'B' x2str(Burst) 'T' x2str(t) '.mat'];
        DIFF
%        half = round(1000*log(2)/LAM);
        fn=['TubeDiam' x2str(diam) 'B1Diff' x2str(DIFF) 'Lam' x2str(half) 'T' x2str(t) '.mat'];
        save(fn,'Conc','DistVec', 'Err' ,'Limit')
    end
    %plot(DistVec,Conc,'g')
end