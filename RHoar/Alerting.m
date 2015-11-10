% function Alerting
% dmat
% cd RHoar;
cd('C:\Documents and Settings\ROWLAND\My Documents');
buysound=wavread('buy.wav');                          
downsound=wavread('down.wav');                         
mid1sound=wavread('mid1.wav');                         
mid2sound=wavread('mid2.wav');                         
sellsound=wavread('sell.wav');                         
upsound=wavread('up.wav');

% [T,L1,L2,L3]=textread('log_notext.txt','%s%f%f%f');
% L1=L1(1:7200);
% L2=L2(1:7200);
% L3=L3(1:7200);

N=32400;%length(L1);
T=1:length(L1);
% set up empty matrices so code runs quicker
AlertList=[]; AlertTime=[]; AlertValue=[];
% l1=zeros(1,N); l2=zeros(1,N); l3=zeros(1,N);
% buy=zeros(1,N); sell=zeros(1,N); t=zeros(N,6);

s=date;
fn=['logData' s '.mat'];
fout=['BSlogdata_' s '.txt'];
fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];

% Parameters
% This is how many points are used to get the prediction + the number
% extrapolated
nPoints1=220;    % top line
nPoints2=220;    % bottom line
nPoints3=220;    % middle line

% this is how many points into the 'future' the line is extrapolated
% Use 0 if you want line to be at forefront of data
nPredict1=20;
nPredict2=20;
nPredict3=20;

nEnd1=nPoints1-nPredict1;
nEnd2=nPoints2-nPredict2;
nEnd3=nPoints3-nPredict3;

sm_len=20;
PtsToPlot=3600;
PtsToPlot2=7200;

NotStillSelling=1;
NotStillBuying=1;
NotStillUp=1;
NotStillDown=1;
NotStillClosed=1;
PauseLen=1;%0.25;

if(~isfile(fout)) WriteLogDataPreamble(fout); end;
if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud); end;
if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nPoints3,nPredict3);
WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

StartPt=1;
for i=1:N
    % Read data and write to file/variables
    ts=cputime;
    l1(i)=L1;
    l2(i)=L2;
    l3(i)=L3;
    buy(i)=B;
    if(B==0)
        if(i>1) buy(i)=buy(i-1); end;
    end;
    sell(i)=S;
    if(S==0)
        if(i>1) sell(i)=sell(i-1); end;
    end;
    times(i,:)=clock;
    t(i)=TimeSecs(times(i,4:6));
    % Project the lines
    xl=max(StartPt,i-nPoints1+1);
    xh=min(i,xl+nPoints1-nPredict1);
    pvec1=xl:xh;
    [p1,tnew1]=PredictPoints(t(pvec1),l1(pvec1),i,sm_len);

    xl=max(StartPt,i-nPoints2+1);
    xh=min(i,xl+nPoints2-nPredict2);
    pvec2=xl:xh;
    [p2,tnew2]=PredictPoints(t(pvec2),l2(pvec2),i,sm_len);

    xl=max(StartPt,i-nPoints3+1);
    xh=min(i,xl+nPoints3-nPredict3);
    pvec3=xl:xh;
    [p3,tnew3]=PredictPoints(t(pvec3),l3(pvec3),i,sm_len);    

    % Check for alerts, sound alert and write log
    if(isequal(round(times(i,4:6)),[16,29,59]))
        if(AlertList(end)>3)
            WriteLogData(sell(i),times(i,(4:6)),1,fout);
            AlertList=[AlertList 0];
            AlertTime=[AlertTime times(i)];
            AlertValue=[AlertValue sell(i)];
        else
            WriteLogData(buy(i),times(i,(4:6)),4,fout);
            AlertList=[AlertList 0];
            AlertTime=[AlertTime times(i)];
            AlertValue=[AlertValue buy(i)];
        end
        save(fn,'l1','l2','l3','t','times','AlertList','AlertTime','AlertValue','buy','sell');        
        WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end
    
    if((l1(i)-l2(i))>0.05)
%         j=find(tnew3==i);
        if(l1(i)<=p3(2))
            if(NotStillSelling)
                WriteLogData(sell(i),times(i,(4:6)),1,fout);
                AlertList=[AlertList 1];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue sell(i)];
                NotStillSelling=0;
                wavplay(sellsound);
            end
        elseif(l3(i)>=p3(2)) NotStillSelling=1;
        end
        
        if(l2(i)>=p3(2))
            if(NotStillBuying)
                WriteLogData(buy(i),times(i,(4:6)),4,fout);
                AlertList=[AlertList 4];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue buy(i)];
                NotStillBuying=0;
                wavplay(buysound);
            end
        elseif(l3(i)<=p3(2)) NotStillBuying=1;
        end
        
%         j=find(tnew2==i);
        if(l1(i)<=p2(2))
            if(NotStillDown) 
                WriteLogData(sell(i),times(i,(4:6)),3,fout_ud);
                AlertList=[AlertList 3];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue sell(i)];
                wavplay(downsound);
                NotStillDown=0;
            end
        elseif(l3(i)>=p2(2)) NotStillDown=1;
        end

%         j=find(tnew1==i);
        if(l2(i)>=p1(2))
            if(NotStillUp)
                WriteLogData(buy(i),times(i,(4:6)),6,fout_ud);
                AlertList=[AlertList 6];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue buy(i)];
                wavplay(upsound);
                NotStillUp=0;
            end
        elseif(l3(i)<=p1(2)) NotStillUp=1;
        end
        
%     if(l3(i)<=p2(j))
%         wavplay(mid2);
%         AlertList=[AlertList 2];
%         AlertTime=[AlertTime times(i)];
%         AlertValue=[AlertValue sell(i)];
%     end
% 

%     if(l3(i)>=p1(j))
%         wavplay(mid1);
%         AlertList=[AlertList 5];
%         AlertTime=[AlertTime times(i)];        
%         AlertValue=[AlertValue buy(i)];
%     end
% 
    NotStillClosed=1;
    else
        if(NotStillClosed&length(AlertValue))
            if(AlertValue(end)<=3)
                WriteLogData(sell(i),times(i,(4:6)),1,fout);
                AlertList=[AlertList 0];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue sell(i)];
            else
                WriteLogData(buy(i),times(i,(4:6)),4,fout);
                AlertList=[AlertList 0];
                AlertTime=[AlertTime times(i)];
                AlertValue=[AlertValue buy(i)];
            end
        end
        NotStillClosed=0;
        StartPt=i;
    end

        % graph the data
    xl=max(1,i-PtsToPlot+1);
    subplot(3,1,1)
    plot(t,l1,'r',t,l2,'b',t,l3,'m','Linewidth',2)
    hold on
    plot(tnew1,p1,tnew2,p2,tnew3,p3,'Linewidth',2);
    plot(tnew1(1:nEnd1),p1(1:nEnd1),'k',tnew2(1:nEnd2),p2(1:nEnd2),'k',tnew3(1:nEnd3),p3(1:nEnd3),'k','Linewidth',2)
    axis([xl i (L3-0.25) (L3+0.25)])
    title('Hourly chart')
    hold off;
    
    xl=max(1,i-PtsToPlot2+1);
    subplot(3,1,2)
    plot(t,l1,'r',t,l2,'b',t,l3,'m','Linewidth',2)
    hold on
    plot(tnew1,p1,tnew2,p2,tnew3,p3,'Linewidth',2);
    plot(tnew1(1:nEnd1),p1(1:nEnd1),'k',tnew2(1:nEnd2),p2(1:nEnd2),'k',tnew3(1:nEnd3),p3(1:nEnd3),'k','Linewidth',2)
    axis([xl i (L3-0.25) (L3+0.25)])
    title('2 Hourly chart')
    hold off;
    
    subplot(3,1,3)
    plot(t,l1,'r',t,l2,'b',t,l3,'m','Linewidth',2)
    hold on
    plot(tnew1,p1,tnew2,p2,tnew3,p3,'Linewidth',2);
    plot(tnew1(1:nEnd1),p1(1:nEnd1),'k',tnew2(1:nEnd2),p2(1:nEnd2),'k',tnew3(1:nEnd3),p3(1:nEnd3),'k','Linewidth',2)
    axis([1 i (L3-0.25) (L3+0.25)])
    title('Daily chart')
    hold off;
    
    if(mod(i,100)==0)
        save(fn,'l1','l2','l3','t','times','AlertList','AlertTime','AlertValue','buy','sell');
    end
    WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);

    i
    td=cputime-ts;
    w=PauseLen-td;
    if(w>0) pause(w);  end;    
end