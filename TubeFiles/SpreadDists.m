function SpreadDists
dtube; cd MeshPaper\Fig1Data
%GetSpreadDists(0.20,3300)

%lams=[1 10 100 500 1000 5000];
lams=[1 5 10 25:25:100 200:100:500 1000:1000:5000];
%GetDropDists(.2,6600)
GetDropDists(.2,3300)
GetDropDists(.2,1100)
GetDropDists(.2,1650)

function GetSpreadDists(pc,d)
lams=[1 5 10 25:25:100 200:100:500 1000:1000:5000];
%lams=[1 10 100 500 1000 5000];
for j=1:length(lams)
    fn=['TubeDiam1B1Diff' int2str(d) 'Lam' int2str(lams(j)) 'T1.mat'];
    if(isfile(fn))
        load(fn)
        C=Conc(3:end);
        i=max(find(Conc>=(pc*Conc(3))));
        if(isempty(i)) spread(j)=0;
        elseif (i==length(Conc)) spread(j)=DistVec(end)+10;
        else spread(j)=DistVec(i)+(DistVec(i+1)-DistVec(i))*(Conc(i)-pc*Conc(3))/(Conc(i)-Conc(i+1));
        end
    else spread(j)=nan;
    end
end
set(gca,'FontSize',14);
SetBox
subplot(1,2,1),plot(lams,spread,'r')
xlabel('t_{1/2} (ms)','FontSize',14),ylabel('distance (\mum)','FontSize',14)
subplot(1,2,2),semilogx(lams,spread,'r')
xlabel('t_{1/2} (ms)','FontSize',14),ylabel('distance (\mum)','FontSize',14)
save(['TubeDiam1B1Diff' x2str(d) 'SpreadDistsQuick.mat'],'spread','lams','pc')

function[SurfConc]= GetSurfaceConcs(t,diam,Burst ,lams,Diff)
out=diam/2;
global LAM;
global DIFF;
DIFF=Diff;
for i=1:length(lams)
    half=lams(i)
    LAM=log(2)/(half/1000);
    fn=['TubeDiam' x2str(diam) 'B1Diff' x2str(DIFF) 'Lam' int2str(half) 'T1.mat'];
    if(isfile(fn))
        load(fn);
        SurfConc(i)=Conc(3);
        Err(i) = Err(3);
        Limit(i)=Limit(3);
    else
        [C E Limit(i)]=Tube(out,t,out,Burst,5e-3,100)
        SurfConc(i)=C*0.00331;
        Err(i)=E*0.00331;
    end
    DIFF
    %        half = round(1000*log(2)/LAM);
    fn=['TubeDiam' x2str(diam) 'B1Diff' x2str(DIFF) 'SurfConcsForLams2.mat'];
%    fn=['TubeDiam' x2str(diam) 'B1Diff' x2str(DIFF) 'SurfConcsForLamsTemp.mat'];
    save(fn,'SurfConc','lams', 'Err' ,'Limit')
end
%plot(lams,SurfConc,'g')

function GetDropDists(PCs,Diff)
load(['TubeDiam1B1Diff' x2str(Diff) 'SurfConcsForLams2.mat'])
t=1;Burst=1;
diam=1;out=diam/2;
global LAM;
global DIFF;
DIFF=Diff;
% PCs=sort(PCs)
% pause
for i=1:length(lams)
    LAM=log(2)/(lams(i)/1000);
    for p=1:length(PCs)
        c1=SurfConc(i);
        Targ=c1*PCs(p)
        if(p==1) d1=out;
        else d1=2;
        end
        
        % Get initial dist past
        d2=20*d1;
        [C E Lim]= Tube(d2,t,out,Burst,5e-3,100)
        c2=C*0.00331;
        while(c2>Targ)
            d1=d2;c1=c2;
            d2=2*d2;
            [C E Lim]= Tube(d2,t,out,Burst,5e-3,100)
            c2=C*0.00331
        end
        
        % Search
        Tol=0.005*SurfConc(i);
        while ((d2-d1)>0.01)
            newd=0.5*(d1+d2)
            [C E Lim]= Tube(newd,t,out,Burst,5e-3,100)
            newc=C*0.00331
            if(newc>=Targ) c1=newc; d1=newd;
            else c2=newc; d2=newd;
            end
        end
        Spread(p,i)=d1+(d1-d2)*(c1-Targ)/(c1-c2);
        save(['TubeDiam1B1Diff' x2str(Diff) 'SpreadDistsLams2.mat'],'Spread','lams','PCs','SurfConc')
    end
end
Spread
% subplot(1,2,1),plot(lams,Spread),hold on,
% xlabel('t_{1/2} (ms)','FontSize',14),ylabel('distance (\mum)','FontSize',14)
% subplot(1,2,2),semilogx(lams,Spread),hold on,
% xlabel('t_{1/2} (ms)','FontSize',14),ylabel('distance (\mum)','FontSize',14)
