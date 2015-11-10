function StdpInhib

N=1000     % num neurons
NIn=200;
%M=0;
%P=zeroes(1,N);
CTime=20;
APlus=0.005;
B=1.05;
AMin=B*APlus;
Tau_Min=20;
Tau_Plus=20;
EEx=0;
EIn=-70;
Tau_m=20;
VThresh=-54;
VReset=-60;
VRest=-74;
gmax=0.015;
Tau_ex=5;
Tau_in=5;
MaxT=1000;
g_inmax=0.05;

TSincePost=100;  %**Check
V(1)=VRest;

%rates=GetRates(N);
rates=GetRates2(N);
for i=1:N
    TToNext(i)=GetSpikeT(rates(i)/1000);
    TSincePre(i)=100;
end
for i=1:NIn
    TToNextIn(i)=GetSpikeT(0.01);
end

g=gmax*(rand(1,N));     %Check**
g_ex(1)=0;
g_in(1)=0;
IntCounter=GetNewInterval(CTime);
for t=1:MaxT
    g_ex(t)=0;
    g_in(t)=0;
    %t
    for i=1:N
        if(TToNext(i)<=0) 
            g(i)=g(i)-gmax*AMin*exp(-TSincePost/Tau_Min);
            TSincePre(i)=0;
            TToNext(i)=GetSpikeT(rates(i)/1000);
        else
            TSincePre(i)=TSincePre(i)+1;
            TToNext(i)=TToNext(i)-1;
        end
        if(g(i)<0) g(i)=0; end;
        g_ex(t)=g_ex(t)+g(i);
    end
    %if(t>0) g_ex(t)=g_ex(t)-g_ex(t)/Tau_ex; end;
    
    for i=1:NIn
        if(TToNextIn(i)<=0) 
            g_in(t)=g_in(t)+g_inmax;
            TToNextIn(i)=GetSpikeT(0.01);
        else
            TToNextIn(i)=TToNextIn(i)-1;
        end
    end    
    %g_in(t)=g_in(t)-g_in(t)/Tau_in;
   % length(find(TToNext==0))
    TSincePost=TSincePost+1;   % Check ****
    g_ex;
    if(t>0)
       g_ex(t)=g_ex(t)-g_ex(t)/Tau_ex;
       g_in(t)=g_in(t)-g_in(t)/Tau_in;
    end
    V(t+1)=V(t)+(VRest-V(t)+g_ex(t)*(EEx-V(t))+g_in(t)*(EIn-V(t)))/Tau_m;
    if(V(t+1)>VThresh)
        V(t+1)=VReset;
        %PostSpike=1;
        TSincePost=0; %Check****
        for i=1:N
            if(TSincePre(i)>0) 
                g(i)=g(i)+gmax*APlus*exp(-TSincePre(i)/Tau_Plus);
            end
            if(g(i)>gmax) g(i)=gmax; end;
        end
    end
    
    if(IntCounter<=0)
        IntCounter=GetNewInterval(CTime);
    else 
        IntCounter=IntCounter-1;
    end
    if(mod(t,100)==0)
       %keyboard;
       t
    end
end
plot(g,'o')
keyboard

function[t]=GetSpikeT(r)
t=round(GetRndExp(1/r));

function[t]=GetNewInterval(c)
t=round(GetRndExp(c));

function[t]=GetRndExp(c);
t=-log(rand)*c;

function[r]=GetRates(N)
added=randn;
RatesCorr=10*(1+0.3*randn(1,N/2)+0.3*added);     %Poss Change***
bads=find(RatesCorr<=0);
while(length(bads)>0)
    RatesCorr(bads)=10*(1+0.3*randn(1,length(bads))+0.3*added); 
    bads=find(RatesCorr<=0);
end
    
RatesUnCorr=10*(1+0.3*sqrt(2)*randn(1,N/2));    %Poss Change ***
bads=find(RatesUnCorr<=0);
while(length(bads)>0)
    RatesUnCorr(bads)=10*(1+0.3*sqrt(2)*randn(1,length(bads))); 
    bads=find(RatesUnCorr<=0);
end
r=[RatesCorr RatesUnCorr];

function[r]=GetRates2(N)
    
RatesUnCorr=10*(1+0.3*sqrt(2)*randn(1,N));    %Poss Change ***
bads=find(RatesUnCorr<=0);
while(length(bads)>0)
    RatesUnCorr(bads)=10*(1+0.3*sqrt(2)*randn(1,length(bads))); 
    bads=find(RatesUnCorr<=0);
end
r=[RatesUnCorr];