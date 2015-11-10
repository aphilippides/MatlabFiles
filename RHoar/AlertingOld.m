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
PauseLen=1;%0.25;

if(~isfile(fout)) WriteLogDataPreamble(fout); end;
if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud); end;
if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nPoints3,nPredict3);
WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);
%while 1
for i=1:N
    % Read data and write to file/variables
    ts=GetSecs;
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
    
    % graph the data
    % plot(T,L1,'r:',T,L2,'g:',T,L3,'b:')
    xl=max(1,i-PtsToPlot+1);
    pvec=xl:i;
    figure(1)
    plot(t(pvec),l1(pvec),'r','Linewidth',2)
    hold on
    plot(t(pvec),l2(pvec),'b','Linewidth',2)
    plot(t(pvec),l3(pvec),'m','Linewidth',2)
    plot(tnew1,p1,tnew2,p2,tnew3,p3,'Linewidth',2);%,tnew,p2,'g',tnew,p1,'r');
    plot(tnew1(1:nEnd1),p1(1:nEnd1),'k',tnew2(1:nEnd2),p2(1:nEnd2),'k',tnew3(1:nEnd3),p3(1:nEnd3),'k','Linewidth',2)
%    ylim([min([l2(1:i),l1(1:i)]) max([l2(1:i),l1(1:i)])]);
    ylim([(L3-0.25) (L3+0.25)]);
    title('Hourly chart')
    hold off;
    
    % xl=max(1,i+nPredict-nPoints-PtsToPlot);
    % axis tight
    %xlim([xl,xl+PtsToPlot]);
    %xlim([1 7200]);
    
    % Check for alerts, sound alert and write log
    if(isequal(round(times(i,4:6)),[16,29,59]))
        if(AlertValue(end)<=3)
            WriteLogData(sell(i),times(i,(4:6)),1,fout);
            AlertList=[AlertList 0];
            AlertTime=[AlertTime i];
            AlertValue=[AlertValue sell(i)];
        else
            WriteLogData(buy(i),times(i,(4:6)),4,fout);
            AlertList=[AlertList 0];
            AlertTime=[AlertTime i];
            AlertValue=[AlertValue buy(i)];
        end
        save(fn,'l1','l2','l3','t','times','AlertList','AlertTime','AlertValue','buy','sell');        
        WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end
    
    if(l1(i)>l2(i))
        j=find(tnew3==i);
        if(l1(i)<=p3(j))
            if(NotStillSelling)
                WriteLogData(sell(i),times(i,(4:6)),1,fout);
                AlertList=[AlertList 1];
                AlertTime=[AlertTime i];
                AlertValue=[AlertValue sell(i)];
                NotStillSelling=0;
                wavplay(sellsound);
            end
        elseif(l3(i)>=p3(j)) NotStillSelling=1;
        end
        
        if(l2(i)>=p3(j))
            if(NotStillBuying)
                WriteLogData(buy(i),times(i,(4:6)),4,fout);
                AlertList=[AlertList 4];
                AlertTime=[AlertTime i];
                AlertValue=[AlertValue buy(i)];
                NotStillBuying=0;
                wavplay(buysound);
            end
        elseif(l3(i)<=p3(j)) NotStillBuying=1;
        end
        
        j=find(tnew2==i);
        if(l1(i)<=p2(j))
            if(NotStillDown) 
                WriteLogData(sell(i),times(i,(4:6)),3,fout_ud);
                AlertList=[AlertList 3];
                AlertTime=[AlertTime i];
                AlertValue=[AlertValue sell(i)];
                wavplay(downsound);
                NotStillDown=0;
            end
        elseif(l3(i)>=p2(j)) NotStillDown=1;
        end

        j=find(tnew1==i);
        if(l2(i)>=p1(j))
            if(NotStillUp)
                WriteLogData(buy(i),times(i,(4:6)),6,fout_ud);
                AlertList=[AlertList 6];
                AlertTime=[AlertTime i];
                AlertValue=[AlertValue buy(i)];
                wavplay(upsound);
                NotStillUp=0;
            end
        elseif(l3(i)<=p1(j)) NotStillUp=1;
        end
        
%     if(l3(i)<=p2(j))
%         wavplay(mid2);
%         AlertList=[AlertList 2];
%         AlertTime=[AlertTime i];
%         AlertValue=[AlertValue sell(i)];
%     end
% 

%     if(l3(i)>=p1(j))
%         wavplay(mid1);
%         AlertList=[AlertList 5];
%         AlertTime=[AlertTime i];        
%         AlertValue=[AlertValue buy(i)];
%     end
% 

    end

    if(mod(i,100)==0)
        save(fn,'l1','l2','l3','t','times','AlertList','AlertTime','AlertValue','buy','sell');
    end
    WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);

    i
    td=GetSecs-ts;
    w=PauseLen-td;
    if(w>0) pause(w);  end;    
end
figure
plot(t,l1,'r:',t,l2,'g:',t,l3,'b:')%,'r',tnew,p2,'g',tnew,p3);