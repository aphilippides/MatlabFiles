function[out]=TestCCI(fin,p,pf,ps,nsm,th,opt)

% REad in data
if(ischar(fin)) [tim,l1,l2,l3,buy,sell,vol,tvar,BV,AV]=ReadLogDataVol(fin);
else 
    l3=[fin.l3];
    sell=[fin.sell];
    buy=[fin.buy];
end

plo=1;
% decide what to cci on, fut or l3 and smooth it
if(nargin<7)
    opt=0;
    fut=0.5*(buy+sell)';
elseif(opt<0)
    plo=0;
    opt=0;
    fut=0.5*(buy+sell)';    
else 
    fut=l3';
    if(opt>1) plo=0; end;
end
sfut=MySmoothV(fut,nsm);

% set the start values where cci is valid
st=2*p*ps;
st2=2*p*pf;

% Get cci for fast and slow and smooth the fast one
tp=GetTP(fut,p);
ccf=GetCCI(tp,pf,p);
ccs=GetCCI(tp,ps,p);
sc=MySmoothV(ccf,nsm);

% Get fast cci on smoothed data
stp=GetTP(sfut,p);
sccf=GetCCI(stp,pf,p);

% Fast cci, 2nd crossover
[buys,sells]=TCrossoverOp(ccf(st2:end),th,st2);
[out.f2ndXp1,out.f2ndXp2,out.f2ndXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt,0,1,'Fast cci, 2nd xover',plo);

% Fast cci, 1st crossover
[buys,sells]=TCrossover(ccf(st2:end),th,st2);
[out.f1stXp1,out.f1stXp2,out.f1stXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt,0,3,'Fast cci, 1st xover',plo);

% Fast smoothed cci, 2nd crossover
[buys,sells]=TCrossover(sc(st2:end),th,st2);
buys=buys+floor(nsm/2);
sells=sells+floor(nsm/2);
[out.fsm2ndXp1,out.fsm2ndXp2,out.fsm2ndXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt,2,5,'Fast smoothed cci, 2nd x-over',plo);

% Fast smoothed cci, 1st crossover
[buys,sells]=TCrossoverOp(sc(st2:end),th,st2);
buys=buys+floor(nsm/2);
sells=sells+floor(nsm/2);
[out.fsm1stXp1,out.fsm1stXp2,out.fsm1stXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt,2,7,'Fast smoothed cci, 1st x-over',plo);

% smoothed data, Fast  cci, 2nd crossover
[buys,sells]=TCrossover(sccf(st2:end),th,st2);
buys=buys+floor(nsm/2);
sells=sells+floor(nsm/2);
[out.smf2ndXp1,out.smf2ndXp2,out.smf2ndXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,sfut,ccf,ccs,sccf,st,opt,2,9,'smoothed data, Fast cci, 2nd x-over',plo);

% smoothed data, Fast cci, 1st crossover
[buys,sells]=TCrossoverOp(sccf(st2:end),th,st2);
buys=buys+floor(nsm/2);
sells=sells+floor(nsm/2);
[out.smf1stXp1,out.smf1stXp2,out.smf1stXnt]= ...
    ProfitAndPlot(buys,sells,buy,sell,sfut,ccf,ccs,sccf,st,opt,2,11,'smoothed data, Fast cci, 1st x-over',plo);

% Fast cci, 2nd crossover
[buys,sells]=FSCrossover(ccf(st:end),ccs(st:end),st);
[out.fastslowp1,out.fastslowp2,out.fastslownt]= ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt,1,13,'Fast vs Slow',plo);

function[buys,sells]=TCrossover(ccf,t,st)
s=ccf>t;
d=diff(s);
buys=find(d==1)'+st;
b=ccf<(-t);
d=diff(b);
sells=find(d==1)'+st;

function[buys,sells]=TCrossoverOp(ccf,t,st)
s=ccf>t;
d=diff(s);
sells=find(d==-1)'+st;
b=ccf<(-t);
d=diff(b);
buys=find(d==-1)'+st;

function[buys,sells]=FSCrossover(ccf,ccs,st)
s=sign(ccf-ccs);
d=diff(s);
buys=find(d==2)'+st;
sells=find(d==-2)'+st;

function[cci]=GetCCI(tp,n,p)
ccm=zeros(n,length(tp));
l=length(tp);
ss=[0:n-1]*p+1;
en=l-[0:n-1]*p;
for i=1:n 
    ccm(i,ss(i):l)=tp(1:en(i));
end
smi=mean(ccm,1);

d=tp-smi;
ad=abs(d);
ccm=zeros(n,length(tp));
for i=1:n 
    ccm(i,ss(i):l)=ad(1:en(i));
end
m=mean(ccm,1)*0.015;
cci=d./m;

function[tp]=GetTP(fut,p)
tpM=zeros(p,length(fut));
l=length(fut)+1;
for i=1:p;
    tpM(i,i:end)=fut(1:(l-i));
end
tp=(fut+min(tpM)+max(tpM))/3;

function[Prof1,Prof2,NumTrades] = ...
    ProfitAndPlot(buys,sells,buy,sell,fut,ccf,ccs,sc,st,opt1,opt2,a,str,plo);
bs=[buys ones(size(buys)) buy(buys);sells zeros(size(sells)) sell(sells)];
if(isempty(bs))
    Prof1=0;
    Prof2=0;
    NumTrades=0;
    return;
end
[s,is]=sort(bs(:,1));
bs=bs(is,:);
n=length(fut);
if(bs(end,2)) bs=[bs;n 0 sell(end)];
else bs=[bs;n 1 buy(end)];
end
iv=1:length(buy);
[bs1,bs2]=GetProfit(bs);
Prof1=sum(bs1);Prof2=sum(bs2);
NumTrades=length(bs1);
if(plo)
    tstr=[str ': Prof1 = ' num2str(Prof1) '; Prof2 = ' num2str(Prof2) ...
        '; # Trades = ' int2str(NumTrades)];
    disp(' ');
    disp(tstr);
    figure(a)
    subplot(2,1,1)
    if(opt1==0) plot(iv,buy,'b',iv,sell,'r',1:length(fut),fut,'g');
    else plot(1:length(fut),fut,'g');
    end
    r=0.1*MyRange(fut);
    hold on
    for k=1:size(bs,1)
        ind=bs(k,1);
        if(abs(bs(k,2))==1) plot([ind ind],[fut(ind)-r fut(ind)+r]);
        else  plot([ind ind],[fut(ind)-r fut(ind)+r],'r');
        end
    end
    hold off
    axis tight
    title(tstr)
    subplot(2,1,2)
    if(opt2==1) plot(iv,ccf(iv),'r',iv,ccs(iv))
    elseif(opt2==2) plot(iv,ccf(iv),'y',1:length(sc),sc,'g')
    else plot(ccf,'g')%,'r',iv,ccs(iv))
    end
    r=0.2*MyRange(ccf(st:end));
    hold on
    for k=1:(size(bs,1))
        ind=bs(k,1);
        if(abs(bs(k,2))==1) plot([ind ind],[ccf(ind)-r ccf(ind)+r],'b--');
        else plot([ind ind],[ccf(ind)-r ccf(ind)+r],'r--');
        end
    end
    hold off
    axis tight
    ylim([min(ccf(st:end)) max(ccf(st:end))]*1.1)
    figure(a+1)
    bar(bs1)
    title(tstr)
end

% Smoothing function
function[s]=MySmoothV(l,n)
if(n<2) 
    s=l;
    return;
end
ms=zeros(n+1,length(l)+n);
for i=1:n+1
    ms(i,:)=[ones(1,i-1)*l(1) l ones(1,n+1-i)*l(end)];
end
s=mean(ms);
s=s((n/2+1):length(l));