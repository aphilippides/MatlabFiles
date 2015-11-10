function CheckRoData(ind)
dmat;
cd RHoar\LogData\
s=dir('excel*.mat');
if((nargin<1)|isempty(ind))
    for i=1:length(s) 
        CheckData(s(i).name);
    end
else CheckData(s(ind).name);
end

function CheckData(fn)
load(fn);
[b1,b2,TrTimes]=GetProfit(buysell,1);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=max(size(buysell,1)-1,0)
[b5,b6,TrTimes]=GetProfit(buysell3,1);
bs1_3=sum(b5)
bs2_3=sum(b6)
NumTrades3=max(size(buysell3,1)-1,0)
[ud1,ud2,TrTimes]=GetProfit(updown);
up1=sum(ud1)
up2=sum(ud2)
NumTradesUD=max(length(bigs)-1,0)
% [ud1_2,ud2_2,TrTimes]=GetProfit(updown2);
% up1_2=sum(ud1_2)
% up2_2=sum(ud2_2)
% NumTradesUD2=max(length(bigs2)-1,0)

[et1,et2,TrTimes]=GetProfit(x1x2);
ETrend1=sum(et1)
ETrend2=sum(et2)
NumTradesETrend=max(length(et1),0)

[mm1,mm2,TrTimes]=GetProfit(m1m2);
mp1=sum(mm1)
mp2=sum(mm2)
NumTradesM1M2=max(length(mm1),0)

% figure(2),
% inds=1:length(l1);
% plot(inds,l1,'g',inds,l2,'g',inds,l3,'g','Linewidth',2)
% hold on
% plot((1:j3-1),s3,'m',(1:jud-1),s2,'r',(1:jud-1),s1,'b','Linewidth',2);
% if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
% if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
% if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
% if(length(MMin)) plot(MMinT,MMin,'bo'); end;
% for k=1:size(buysell,1)
%     ind=buysell(k,1);
%     if(abs(buysell(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
%     else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
%     end
% end
% 
% % Plot UPDOWN stuff
% for k=bigs
%     ind=updown(k,1);
%     if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
%     else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
%     end
% end
% for k=mults
%     ind=updown(k,1);
%     if(updown(k,2)) plot([ind ind],[l2(ind) l3(ind)+0.125],'b','Linewidth',1);
%     else plot([ind ind],[l3(ind)-0.125 l1(ind)],'r-s','Linewidth',1);
%     end
% end
% title(['BS = ' num2str(bs1) ';   UD = ' num2str(ud1) ]);%';   UD 2 = ' num2str(ud1_2) ]);
% hold off;
% 
% figure(3)
% inds=1:length(l1);
% plot(inds,l1,'g',inds,l2,'g',inds,l3,'g','Linewidth',2)
% hold on
% plot((1:j3-1),s3,'m',(1:jud2-1),s2_2,'r',(1:jud2-1),s1_2,'b','Linewidth',2);
% for k=1:size(buysell3,1)
%     ind=buysell3(k,1);
%     if(buysell3(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
%     else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
%     end
% end
% for k=bigs2
%     ind=updown2(k,1);
%     if(abs(updown2(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- *','Linewidth',2);
%     else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- *','Linewidth',2);
%     end
% end
% for k=mults2
%     ind=updown2(k,1);
%     if(updown2(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-*','Linewidth',1);
%     else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-*','Linewidth',1);
%     end
% end
% title(['UD 2 = ' num2str(ud1_2) ';   Volume = ' num2str(NetVol)]);
% hold off
% 
% if(~isempty(buysell))
%     figure(4)
%     bar([b1;b2]')
%     legend('simple','multiple');
%     title('Buy sell profit/loss')
% end
% if(~isempty(bigs))
%     figure(5)
%     bar(ud1)
%     title('Up down profit/loss')
% end
% if(~isempty(bigs2))
%     figure(6)
%     bar(ud1_2)
%     title('Up down 2 profit/loss')
% end
figure(8)
ivec=1:length(l1);
plot(ivec,l1(ivec),'b',ivec,l2(ivec),'r',ivec,l3(ivec),'m','Linewidth',2)
hold on;
for k=1:size(p1p2,1)
    ind=p1p2(k,1);
    if(p1p2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'LineWidth',2);
    elseif(p1p2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r','LineWidth',2);
    elseif(p1p2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'bs');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'rs');
    end
end
for k=1:size(s1s2,1)
    ind=s1s2(k,1);
    if(s1s2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:o');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:o');
    end
end
for k=1:size(c1c2,1)
    ind=c1c2(k,1);
    if(c1c2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:v');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:v');
    end
end
for k=1:size(d1d2,1)
    ind=d1d2(k,1);
    if(d1d2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--*');
    elseif(d1d2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--*');
    elseif(d1d2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--s','MarkerFaceColor','b');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--s','MarkerFaceColor','r');
    end
end
for k=1:size(m1m2,1)
    ind=m1m2(k,1);
    if(m1m2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:','LineWidth',2);
    elseif(m1m2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:','LineWidth',2);
    elseif(m1m2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:s','MarkerFaceColor','b','LineWidth',2);
    elseif(m1m2(k,2)==-2) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:s','MarkerFaceColor','r','LineWidth',2);
    elseif(m1m2(k,2)==-3) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:p','MarkerFaceColor','b','LineWidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:p','MarkerFaceColor','r','LineWidth',2);
    end
end
eval(['l1l=l1line;'])
eval(['l2l=l2line;'])
PlotP1P2Lines(length(l1),l1l,l2l,exl1,exl2,Hi2Day,Low1Day, ...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,0.5*spread)
title(['DAILY CHART:   E Trend Profit A = ' num2str(ETrend1) '; E Trend Profit B = ' num2str(ETrend2)]);
ma2=max([l1 l2])+0.02;mi2=min([l1 l2])-0.02;
axis([1 length(l1) mi2 ma2])
hold off
if(~isempty(mm1))
    figure(7)
%     bar([et1;et2]')
    bar([mm1;mm2]')
    title(['Mid profit/loss A = ' num2str(mp1) '  ; B = ' num2str(mp2)])
end

function[pr]=optimiseTrades(trs,buy,sell)
sind=1;
while 1
    if(trs(sind,2)) 
        eind=find(trs(sind:end,2)==0,1)+sind-1;
        if(isempty(eind)) break; end;
        ts=trs(sind,1):trs(eind,1);
        plot(ts,sell(ts)-trs(sind,3))
    else 
        eind=find(trs(sind:end,2)==1,1)+sind-1;
        if(isempty(eind)) break; end;
        ts=trs(sind,1):trs(eind,1);
        plot(ts,-buy(ts)+trs(sind,3))
    end
    sind=eind;
end