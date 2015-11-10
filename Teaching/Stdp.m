function Stdp

N=1000;     % num neurons
%M=0;
%P=zeroes(1,N);
CTime=20;
APlus=0.005;
B=1.05;
AMin=B*APlus;
Tau_Min=20;
Tau_Plus=20;
EEx=0;
Tau_m=20;
VThresh=-54;
VReset=-60;
VRest=-74;
gmax=0.015;
Tau_ex=5;
MaxT=100000;
PostSpike=0;
TSincePost=100;  %**Check
V(1)=VRest;
rates=GetRates(N);
for i=1:N
    TToNext(i)=GetSpikeT(rates(i)/1000);
    TSincePre(i)=100;
end
g=gmax*(rand(1,N));     %Check**
g_ex(1)=0;
IntCounter=GetNewInterval(CTime);
for t=1:MaxT
%    g_ex(t)=0;
  %  t
  SumNeg(t)=0;
SumPos(t)=0;
  for i=1:N
        if(TToNext(i)<=0) 
            g(i)=g(i)-gmax*AMin*exp(-TSincePost/Tau_Min);
            SumNeg(t)=SumNeg(t)+gmax*AMin*exp(-TSincePost/Tau_Min);
            TSincePre(i)=0;
            TToNext(i)=GetSpikeT(rates(i)/1000);
            g_ex(t)=g_ex(t)+g(i);
			else
            TSincePre(i)=TSincePre(i)+1;
            TToNext(i)=TToNext(i)-1;
        end
        if(g(i)<0) g(i)=0; end;
    end
	TSincePost=TSincePost+1;   % Check ****
   % length(find(TToNext==0))
   %     if(t>0) g_ex(t+1)=g_ex(t)-g_ex(t)/Tau_ex; end;
    g_ex;
    V(t+1)=V(t)+(VRest-V(t)+g_ex(t)*(EEx-V(t)))/Tau_m;
    if(V(t+1)>VThresh)
        V(t+1)=VReset;
        PostSpike=PostSpike+1
        t
        TSincePost=0; %Check****
        for i=1:N
            if(TSincePre(i)>0) 
                g(i)=g(i)+gmax*APlus*exp(-TSincePre(i)/Tau_Plus);
                SumPos(t)=SumPos(t)+gmax*APlus*exp(-TSincePre(i)/Tau_Plus);
            end
            if(g(i)>gmax) g(i)=gmax; end;
        end
    end
    gmeantop(t)=mean(g(1:500))/gmax;
    gmeanbot(t)=mean(g(501:1000))/gmax;
    gmean(t)=mean(g)/gmax;
    g_ex(t+1)=g_ex(t)-g_ex(t)/Tau_ex;
    if(IntCounter<=0)
        IntCounter=GetNewInterval(CTime);
     		rates=GetRates(N);   
		for i=1:N
    		TToNext(i)=GetSpikeT(rates(i)/1000);
    	%	TSincePre(i)=100;
		end
     else 
        IntCounter=IntCounter-1;
    end
    if(mod(t,100)==0)
        [gmean(t) gmeantop(t) gmeanbot(t)]
        [sum(SumPos) sum(SumNeg)]
    end
    if(mod(t,1000)==0)
        figure,
        subplot(3,1,1)
        plot(g,'o');
        title(['t= ' int2str(t) ]);
        subplot(3,1,2)
        plot([1:t],SumPos,'b',[1:t],SumNeg,'r')
        subplot(3,1,3)
        plot([1:t],gmean,'b',[1:t],gmeantop,'r',[1:t],gmeanbot,'g')
    end
end
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