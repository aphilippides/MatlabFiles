function[bsProf1,bsProf2,NumTrades]=TestSettingGradient(fn,n,nt,Plotting)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end
n=n+1;
load(fn);

% Get the start and end times
tsecs=TimeSecs(times(:,4:6));
tb=TimeSecs([8,2,0]);
te=TimeSecs([16,29,59]);
b=1;%find([tsecs>=tb],1);
e=length(tsecs);%find([tsecs<=te],1,'last');
st=b:e;
buy=buy(st);
sell=sell(st);
l3=l3(st);
tsecs=tsecs(st);
s=SmoothVec(l3,n,'replicate');
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
EndPt=15;

if(ma_t(1)<mi_t(1))
    for i=1:length(ma_t)
        ep=min(ma_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((ma_s(i)-mean(l3(is)))>nt) 
            buysell=[buysell;is(end) 0 sell(is(end))];
            ma_is=[ma_is i];
            plot(ma_t(i),ma_s(i),'ks');
        end
        if(length(mi_t)<i)
            buysell=[buysell;length(tsecs) 1 buy(end)];
            break;
        end;
        ep=min(mi_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((mean(l3(is))-mi_s(i))>nt) 
            buysell=[buysell;is(end) 1 buy(is(end))];
            mi_is=[mi_is i];
            plot(mi_t(i),mi_s(i),'cs');
       end
        if(length(ma_t)==i)
            buysell=[buysell;length(tsecs) 0 sell(end)];
        end
    end
else
    for i=1:length(mi_t)
        ep=min(mi_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((mean(l3(is))-mi_s(i))>nt) 
            buysell=[buysell;is(end) 1 buy(is(end))];
            mi_is=[mi_is i];
            plot(mi_t(i),mi_s(i),'cs');
        end
        if(length(ma_t)<i)
            buysell=[buysell;length(tsecs)  0 sell(end)];
            break;
        end;

        ep=min(ma_t(i)+floor(n/2)+nPoints3,length(tsecs));
        is=(ep-EndPt):ep;
        if((ma_s(i)-mean(l3(is)))>nt) 
            buysell=[buysell;is(end) 0 sell(is(end))];
            ma_is=[ma_is i];
            plot(ma_t(i),ma_s(i),'ks');
        end
        if(length(mi_t)==i)
            buysell=[buysell;length(tsecs) 1 buy(end)];
        end
    end
end
hold off; 

[bs1,bs2,TrTimes]=GetProfit(buysell,1);
NumTrades=size(buysell,1)
bsProf1=sum(bs1)
bsProf2=sum(bs2)

if(nargin<4) Plotting=1; end;
if(Plotting)
    figure(1);
    plot(s);
    hold on; plot(ma_t,ma_s,'ro'); plot(mi_t,mi_s,'gs'); hold off;
    figure(2)
    plot(st,l1(st),'r',st,l2(st),'b',st,l3,'m','LineWidth',2)
    title('Buy sell day data')
    hold on;
    for i=1:NumTrades
        j=buysell(i,1);
        if(buysell(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
        else  plot([j j],[l3(j)-0.25 l3(j)+0.25],'r');
        end
    end
    hold off
    axis tight
    if(~isempty(buysell))
        figure(3)
        n=size(buysell,1);
        plot(1:length(bs1),bs1,':',1:length(bs2),bs2,'r')
        title('Buy sell profit/loss')
    end
end
% keyboard;