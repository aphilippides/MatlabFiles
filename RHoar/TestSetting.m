function TestSetting(fn,nPts1,nPred1,nPts2,nPred2,nPts3,nPred3)
dmat;
cd RHoar/LogData/; disp('Change folder back *****');
% cd RHoar/DataNoText/
% cd('C:\Documents and Settings\ROWLAND\My Documents');

% [T,L2,L3,L1,B,S]=textread(fn,'%s%f%f%f%f%f');
load(fn);

% Get the start and end times
tsecs=TimeSecs(times(:,4:6));
tb=TimeSecs([8,2,0]);
te=TimeSecs([16,29,59]);
b=find([tsecs>=tb],1);
e=find([tsecs<=te],1,'last');
st=b:e;

% Run the data for profit and loss
[buysell,updown]=RunData(l1(st),l2(st),l3(st),buy(st),sell(st),nPts1,nPred1,nPts2,nPred2,nPts3,nPred3);
fout=['TestData.mat'];
save(fout,'buysell','updown','fn','st')
[bs1,bs2,TrTimes]=GetProfit(buysell,1);
[ud1,ud2,TrTimes]=GetProfit(updown);
NumTrades=size(buysell,1);

bsProf1=sum(bs1)
bsProf2=sum(bs2)

udProf1=sum(ud1)
udProf2=sum(ud2)

figure(2)
plot(st,l1(st),'r',st,l2(st),'b',st,l3(st),'m','LineWidth',2)
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
figure(4)    
plot(st,l1(st),'r',st,l2(st),'b',st,l3(st),'m','LineWidth',2)
title('Up down day data')
hold on;
for i=1:size(updown,1);
    j=updown(i,1);
    if(updown(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
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
if(~isempty(updown))
    figure(5)
    n=size(updown,1);
    plot(1:length(ud1),ud1,':',1:length(ud2),ud2,'r')
    title('Up down profit/loss')
end

function[buysell,updown]=RunData(l1,l2,l3,buy,sell,nPoints1,nPredict1,nPoints2,nPredict2,nPoints3,nPredict3)

NotStillSelling=1;
NotStillBuying=1;
NotStillUp=1;
NotStillDown=1;
buysell=[];
updown=[];sm_len=2;
for i=1:length(l1)
    % Read data and write to file/variables
    t(i)=i;
    % Project the lines
    xl=max(1,i-nPoints1+1);
    xh=min(i,xl+nPoints1-nPredict1);
    pvec1=xl:xh;
    [p1,tnew1]=PredictPoints(t(pvec1),l1(pvec1),nPoints1,sm_len);

    xl=max(1,i-nPoints2+1);
    xh=min(i,xl+nPoints2-nPredict2);
    pvec2=xl:xh;
    [p2,tnew2]=PredictPoints(t(pvec2),l2(pvec2),nPoints2,sm_len);

    xl=max(1,i-nPoints3+1);
    xh=min(i,xl+nPoints3-nPredict3);
    pvec3=xl:xh;
    [p3,tnew3]=PredictPoints(t(pvec3),l3(pvec3),nPoints3,sm_len);

    % Check for alerts, sound alert and write log
    
    if(l1(i)>l2(i))
        j=find(tnew3==i);
        if(l1(i)<=p3(j))
            if(NotStillSelling)
                buysell=[buysell;i 0 sell(i)];
                NotStillSelling=0;
            end
        elseif(l3(i)>=p3(j)) NotStillSelling=1;
        end

        if(l2(i)>=p3(j))
            if(NotStillBuying)
                buysell=[buysell;i 1 buy(i)];
                NotStillBuying=0;
            end
        elseif(l3(i)<=p3(j)) NotStillBuying=1;
        end

        j=find(tnew2==i);
        if(l1(i)<=p2(j))
            if(NotStillDown)
                updown=[updown;i 0 sell(i)];
                NotStillDown=0;
            end
        elseif(l3(i)>=p2(j)) NotStillDown=1;
        end

        j=find(tnew1==i);
        if(l2(i)>=p1(j))
            if(NotStillUp)
                updown=[updown;i 1 buy(i)];
                NotStillUp=0;
            end
        elseif(l3(i)<=p1(j)) NotStillUp=1;
        end
    end
end
% close out buys
if(~isempty(updown))
    if(updown(end,2)) updown=[updown;i 0 sell(i)];
    else updown=[updown;i 1 buy(i)];
    end
end
if(~isempty(buysell))
    if(buysell(end,2)) buysell=[buysell;i 0 sell(i)];
    else buysell=[buysell;i 1 buy(i)];
    end
end        