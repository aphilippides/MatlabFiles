function KCFiringTimes(V,B,ReceptV)

KCRate=0.025;
TLength=100;
NumOuterKCs=27212;
NumKCs=30525;
NumReceptors=3313;
TStep=1e-4;
% NonFLen=1e-2;
NonFLen=B/1000+5e-3;
dmush

NumOn=round(NumOuterKCs*TLength*KCRate)
FTs=FiringTimesMush(TLength,NumOn,NumOuterKCs,KCRate,TStep,NonFLen);
save(['Mush/BasalT100TSt0_5Rate0_025B' int2str(B) 'Inn33Out99V' int2str(V) 'KCs.dat'],'FTs','-ascii');

% GetRecepts(NumReceptors,NumKCs,V);
% FTs=FiringTimesSAndP(TLength,NumOn,NumKCs,ReceptV,TStep,NonFLen);
% save(['Tube/BasalT100TSt0_5Rate0_025B' int2str(B) 'Inn33Out99V' int2str(V) 'KCs.dat'],'FTs','-ascii');

% This bit if re-scaling
% FTs=load('Mush/BasalT100TSt0_5Rate0_025B5Inn33Out99V10KCs.dat','-ascii');
% FTs(:,2)=(FTs(:,2)-1)*5 + 1;
% save(['Mush/BasalT100TSt0_1Rate0_025B5Inn33Out99V10KCs.dat'],'FTs','-ascii');

function[FTs]=FiringTimesMush(TLength,NumFiring,NumKCs,KCRate,TStep,NonFLen)
FiringTimes=round(rand(1,NumFiring)*(TLength/TStep));
FiringTimes=sort(FiringTimes);

% *** NB: these numbers indexing into C array so range = [0,N-1]
KCOn=iRnd(NumKCs,1,NumFiring); 
i=1;
while(i<=NumKCs)
    is=find(KCOn==i);
    if(length(is)>1)
        d=diff(FiringTimes(is));
        [m,j]=min(d);  
        if(m<(NonFLen/TStep))
            FiringTimes(is(j+1))=FiringTimes(is(j))+NonFLen/TStep+1;
            i=i-1
        end
    end
    i=i+1;
end
FTs=[KCOn' FiringTimes'];end
FTs=sortrows(FTs);

function[FTs,Recepts]=FiringTimesSAndP(TLength,NumFiring,NumKCs,ReceptV,TStep,NonFLen)
FiringTimes=round(rand(1,NumFiring)*(TLength/TStep));
FiringTimes=sort(FiringTimes);
recepts=load(['Tube/ReceptorsInn33Out99Group' int2str(ReceptV) '.dat'],'-ascii');

% *** NB: these numbers indexing into C array so range = [0,N-1]
NotRecepts=setdiff(0:NumKCs-1,recepts);
NotRecepts=NotRecepts(randperm(length(NotRecepts)));

% However thse are indexing into matlab so must be range [1,N]. Ho hum
KCOn=NotRecepts(iRnd(length(NotRecepts),1,NumFiring)+1); 
i=1;
while(i<=NumKCs)
    is=find(KCOn==i);
    if(length(is)>1)
        d=diff(FiringTimes(is));
        [m,j]=min(d);  
        if(m<(NonFLen/TStep))
            FiringTimes(is(j+1))=FiringTimes(is(j))+NonFLen/TStep+1;
            i=i-1
        end
    end
    i=i+1;
end
FTs=[KCOn' FiringTimes'];end
FTs=sortrows(FTs);

function GetRecepts(NumReceptors,NumKCs,Vs)
for v=Vs
    r=randperm(NumKCs)-1;
    Recepts=sortrows(r(1:NumReceptors)');
    save(['Tube/ReceptorsInn33Out99Group' int2str(v) '.dat'],'Recepts','-ascii');
end
