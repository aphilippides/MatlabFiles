% function[bsProf1,bsProf2,NumTrades,bs1,bs2]=TestSettingAll(fn,nSmooth,EndPt,RangeProp,Plotting)
function[bsP1,bsP2,ntb,bs1,bs2,udP1,udP2,ntu,ud1,ud2]=TestSettingAll(l1,l2,l3,buy,sell,timez,nSmooth,EndPt,RangeProp,Plotting,fn)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    cd RHoar/LogData/;
end
WRITE=1;
if(WRITE)
    fout=['BSlogdata_TestAll.txt'];
    WriteLogDataPreamble(fout,['Testing data file: ' fn]);
    WriteParams(fout,nSmooth,RangeProp,EndPt);
    fout2=['UDlogdata_TestAll.txt'];
    WriteLogDataPreamble(fout2,['Testing data file: ' fn]);
    WriteParams(fout2,nSmooth,RangeProp,EndPt);
else 
    fout='dum';
    fout2='dum';
end

% Get the start and end times
tsecs=TimeSecs(timez(:,4:6));
tb=TimeSecs([8,2,0]);
te=TimeSecs([16,29,59]);
b=1;%find([tsecs>=tb],1);%1
e=find([tsecs<=te],1,'last');% length(tsecs);%
% if(isempty(e)) e=length(l3); end;
st=b:e;
buy=buy(st)';
sell=sell(st)';
l3=l3(st)';
l1=l1(st)';
l2=l2(st)';
tsecs=tsecs(st);
timez=timez(st,:);
t=st;

[updown]=UDProfit(fout2,l1,l2,l3,buy,sell,tsecs,timez,nSmooth,EndPt,RangeProp,WRITE);
buysell=updown;
% [ud1,ud2,TrTimes]=GetProfit(updown,1);
% ntu=length(ud1);%max(size(buysell,1)-1,0);
% udP1=sum(ud1);
% udP2=sum(ud2);
% [buysell]=TimeProfit(fout,l1,l2,l3,buy,sell,tsecs,timez,600,15,0.025,WRITE)
% [buysell]=DiagonalProfit(fout,l1,l2,l3,buy,sell,tsecs,timez,nSmooth,EndPt,RangeProp,WRITE);
[bs1,bs2,TrTimes]=GetProfit(buysell,1);
ntb=max(size(buysell,1)-1,0);
bsP1=sum(bs1);
bsP2=sum(bs2);