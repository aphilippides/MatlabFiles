function FindLimits(d,C)
dtube; cd MeshPaper/Fig1Data
DistLims(d,C)

function DistLims(t,LimConc)
load TubeSurfaceConcDiam0_1_10B1;
diams=Diams;
for i=1:length(diams)
    % LimConc=Conc*PC/100;
    [DLim(i),C]=FindDistToConc(SurfaceTubeConc(i),LimConc,diams(i),1,t)
    % RelErr(i)=abs(C-LimConc(i))./LimConc(i)
    RelErr(i)=abs(C-LimConc)./LimConc
    Cnm=round(1e9*LimConc);
    save(['DistTo' int2str(Cnm) 'nMB1T' x2str(t) '.mat'],'DLim','RelErr','diams')
end
plot(diams,DLim);

function TimeLims(d,PC)
if(d==0) 
    load TubeSurfaceConcDiam0_1_10B1;
    diams=Diams;
    Conc=SurfaceTubeConc;
else 
    load(['ConcsD' x2str(d) 'FromSurfB1T1DiffDiams']);
end
for i=1:length(diams)
    LimConc=Conc*PC/100;
    [t(i),C]=FindTimeToConc(Conc(i),LimConc(i),diams(i),1,d)
    RelErr(i)=abs(C-LimConc(i))./LimConc(i)
    PeakConc=Conc;
    save(['TimesTo' int2str(PC) 'OfPeakAtd' x2str(d) '.mat'],'t','PeakConc','RelErr','diams')
end

function[t,c]=FindTimeToConc(StartConc,C,diam,B,d)
out=diam/2;
if(StartConc<=C) t=-1;c=C; return; end; 
% Find far end
Endt=B;
EndConc=StartConc;
Startt=B;
while(EndConc>=C)
    StartConc=EndConc;
    Startt=Endt;
    Endt=Endt+B;
    [EndConc Err Limit]=Tube(d,Endt,out,B,5e-3,100);
    if(Err./EndConc>0.01)
        ProblemDiam=d
        pause
    end
    EndConc=EndConc*0.00331;
end
RelErr=(Endt-Startt)*2/(Endt+Startt);
while(RelErr>0.01)
    midt=0.5*(Startt+Endt)
    midc=Tube(d,midt,out,B,5e-3,100)*0.00331
    if(midc>C)
        Startt=midt;
        StartConc=midc;
    else
        Endt=midt;
        EndConc=midc;
    end
    RelErr=(Endt-Startt)*2/(Endt+Startt)
    d1=(StartConc-C)/C;
    d2=(C-EndConc)/C;
    if((d1<0.005)|(d2<0.005))
        if(d2<d1) t=Endt; c=EndConc; 
        else t=Startt; c=StartConc;
        end
        return;
    end        
end
prop=(C-StartConc)/(EndConc-StartConc);
midt=Startt+prop*(Endt-Startt);
midc=Tube(d,midt,out,B,5e-3,100)*0.00331;
t=midt;
c=midc;

function[d,c]=FindDistToConc(SurfConc,C,diam,B,t)
out=diam/2;
if(SurfConc<=C) d=0;c=C; return; end; 
Startd=out;
StartConc=Tube(out,t,out,B,5e-3,100)*0.00331;
if(StartConc<=C) d=0;c=C; return; end; 
% Find far end
Endd=out;
EndConc=StartConc;
while(EndConc>C)
    StartConc=EndConc;
    Startd=Endd;
    Endd=Endd*2;
    EndConc=Tube(Endd,t,out,B,5e-3,100)*0.00331;
end
RelErr=(Endd-Startd)*2/(Endd+Startd);
while(RelErr>0.01)
    midd=0.5*(Startd+Endd)
    midc=Tube(midd,t,out,B,5e-3,100)*0.00331
    if(midc>C)
        Startd=midd;
        StartConc=midc;
    else
        Endd=midd;
        EndConc=midc;
    end
    RelErr=(Endd-Startd)*2/(Endd+Startd)
    d1=(StartConc-C)/C;
    d2=(C-EndConc)/C;
    if((d1<0.005)|(d2<0.005))
        if(d2<d1) d=Endd; c=EndConc; 
        else d=Startd; c=StartConc;
        end
        return;
    end        
end
prop=(C-StartConc)/(EndConc-StartConc);
d=Startd+prop*(Endd-Startd);
c=Tube(d,t,out,B,5e-3,100)*0.00331;