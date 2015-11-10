function[bsProf1,bsProf2,NumTrades]=TestSettingGradient(fn,n,nt,EndPt,Plotting)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end
fout=['BSlogdata_TestGradient.txt'];
dat=date;
WriteLogDataPreamble(fout,['Testing data file: ' fn]);
WriteParams(fout,n,nt,EndPt);

if(isfile(fn)) [timez,l1,l2,l3,buy,sell]=ReadLogData(fn);
else load(['logData' fn(11:end-3) 'mat']);
end

% Get the start and end times
if(exist('timez','var')) tsecs=TimeSecs(timez(:,4:6));
else tsecs=TimeSecs(timez(:,4:6));
end
tb=TimeSecs([8,2,0]);
te=TimeSecs([16,29,59]);
b=find([tsecs>=tb],1);%1
e=find([tsecs>=te],1);% length(tsecs);%
if(isempty(e)) e=length(l3); end;
st=b:e;
buy=buy(st)';
sell=sell(st)';
l3=l3(st)';
tsecs=tsecs(st);
% stemp=SmoothVec(l3,n,'replicate');
timez=timez(st,:);

m=length(l3);
n2=ceil(n/2);
l3t=[ones(1,n2)*l3(1) l3 ones(1,n2)*l3(end)];
for i=1:m-n2   
    is=i:i+n;
    s(i)=mean(l3t(is));
end

% s=MedianSmooth(l3(st),n,'symmetric');

t=st;
[ma,mi]=findextrema(s);
% ma_t=round(ma);
% mi_t=round(mi);
% ma_s=s(round(ma));
% mi_s=s(round(mi));
ma_t=ceil(ma);
mi_t=ceil(mi);
ma_s=s(ceil(ma));
mi_s=s(ceil(mi));

nPoints3=1;
buysell=[];
mi_is=[];
ma_is=[];
% EndPt=15;

if(ma_t(1)<mi_t(1))
    for i=1:length(ma_t)
        ep=min(ma_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((ma_s(i)-mean(l3(is)))>nt) 
            buysell=[buysell;is(end) 0 sell(is(end))];
            ma_is=[ma_is i];
%             plot(ma_t(i),ma_s(i),'ks');
        end
        if(length(mi_t)<i)
%             buysell=[buysell;length(tsecs) 1 buy(end)];
            break;
        end;
        ep=min(mi_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((mean(l3(is))-mi_s(i))>nt) 
            buysell=[buysell;is(end) 1 buy(is(end))];
            mi_is=[mi_is i];
%             plot(mi_t(i),mi_s(i),'cs');
        end
    end
else
    for i=1:length(mi_t)
        ep=min(mi_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((mean(l3(is))-mi_s(i))>nt) 
            buysell=[buysell;is(end) 1 buy(is(end))];
            mi_is=[mi_is i];
%           plot(mi_t(i),mi_s(i),'cs');
        end
        if(length(ma_t)<i)
            break;
        end;

        ep=min(ma_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((ma_s(i)-mean(l3(is)))>nt) 
            buysell=[buysell;is(end) 0 sell(is(end))];
            ma_is=[ma_is i];
%            plot(ma_t(i),ma_s(i),'ks');
        end
    end
end

if(~isempty(buysell))
    if(buysell(end,2)) buysell=[buysell;length(sell) 0 sell(end)];
    else buysell=[buysell;length(buy) 1 buy(end)];
    end
end

hold off; 

[bs1,bs2,TrTimes]=GetProfit(buysell,1);
NumTrades=size(buysell,1)
bsProf1=sum(bs1)
bsProf2=sum(bs2)

if(nargin<5) Plotting=1; end;
if(Plotting)
    for i=1:size(buysell,1)
        t=timez(buysell(i,1),(4:6));
        if(buysell(i,2)) WriteLogData(buysell(i,3),t,4,fout);
        else WriteLogData(buysell(i,3),t,1,fout);
        end
    end
    figure(1);
    plot(s,'g');
    hold on; 
    plot(mi_t,mi_s,'ro'); 
    plot(ma_t,ma_s,'bo'); 
    legend('smoothed l3','sell','buy','Location','best');
    for i=1:NumTrades
        j=buysell(i,1);
        if(buysell(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
        else  plot([j j],[l3(j)-0.25 l3(j)+0.25],'r');
        end
    end
    hold off
    axis tight
    xlim([1 length(st)+500])
    title('Smoothed day data with trades and potential trades')
    
    figure(2)
    plot(st,l1(st),'r',st,l2(st),'b',st,l3,'m','LineWidth',2)
    title('Buy sell day data with trades and potential trades')
    hold on;
legend('sell','buy','Location','best');
plot(ma_t,ma_s,'bo'); 
    plot(mi_t,mi_s,'ro'); 
    for i=1:NumTrades
        j=buysell(i,1);
        if(buysell(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
        else  plot([j j],[l3(j)-0.25 l3(j)+0.25],'r');
        end
    end
    hold off
    axis tight
    xlim([1 length(st)+500])
    if(~isempty(buysell))
        figure(3)
        n=size(buysell,1);
        bar([bs1;bs2]')
        legend('simple','multiple');
%         if(length(bs1)==1) plot(1:length(bs1),bs1,'x',1:length(bs2),bs2,'rx')
%         else plot(1:length(bs1),bs1,':',1:length(bs2),bs2,'r')
%         end
        title('Buy sell profit/loss')
    end
end
% keyboard;