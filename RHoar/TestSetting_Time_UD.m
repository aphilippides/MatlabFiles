function[bs1,bs2,NumTrades] = TestSetting_Time_UD(fin,nSmooth,EndPt,Thresh,MultipleLimit,nSmoothUD,RepTime)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    cd RHoar/LogData/;
end

buysound=wavread('buy.wav');
downsound=wavread('down.wav');
mid1sound=wavread('mid1.wav');
mid2sound=wavread('mid2.wav');
sellsound=wavread('sell.wav');
upsound=wavread('up.wav');

% max length of time (in secs) to run
N=32400;

% UPDOWN params
nSmoothL1=nSmoothUD;
nSmoothL2=nSmoothUD;
% whether to also run the up-down program
UPDOWN=0;
% TimeLim is set as the number of steps you'll wait to see if its a minimum
% TimeLim=0 means there is NO time limit
TimeLim=0;
if(TimeLim==0) TimeLim=N; end;

% ensure nSmooths are even
nS2=ceil(nSmooth/2);
nSmooth=2*nS2;
nS2L1=ceil(nSmoothL1/2);
nSmoothL1=2*nS2L1;
nS2L2=ceil(nSmoothL2/2);
nSmoothL2=2*nS2L2;
% Get max
nS=max([nS2, nS2L1,nS2L2]);
d1=nS-nS2L1;
d2=nS-nS2L2;
d3=nS-nS2;

s=date;
fout=['BSlogdata_Test_Time.txt'];
WriteLogDataPreamble(fout,['Testing data file: ' fin]);
WriteParams(fout,nSmooth,Thresh,EndPt,TimeLim,MultipleLimit,nSmoothL2,nSmoothL1);
% fn=['logData' s '.mat'];
% fout_ud=['UDlogdata_' s '.txt'];
% fout2=['exceldata_' s '.txt'];

PauseLen=1;
PtsToPlot=3600;
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud,s); end;
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

% REad in data
[tim,L1,L2,L3,B,S]=ReadLogData(fin);

% buysell start variables
buysell=[];
NotStillClosed=1;
ma_s=[];mi_s=[];ma=[];mi=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
LastMin=1e9;
LastMinT=-1e3;
LastMax=-1e9;
LastMaxT=-1e3;
LastAlertT=-MultipleLimit;
LastMinAlertT=-MultipleLimit;
LastMaxAlertT=-MultipleLimit;
TitStr=['Lowest min unassigned; Highest max unassigned'];

% updown start variables
updown=[];mults=[];bigs=[];
nUD=0;
LastUD=-1;
s1Low=1e9;
s2High=-1e9;

% General start parameters
j=1;
StartT=0;
for i=1:length(L1);
    
    ts=GetSecs;
    l1(i)=L1(i);
    l2(i)=L2(i);
    l3(i)=L3(i);
    buy(i)=B(i);
    sell(i)=S(i);
    if(B==0) if(i>1) buy(i)=buy(i-1); end;end;
    if(S==0) if(i>1) sell(i)=sell(i-1); end;end;
    timez(i,:)=tim(i,:);
    t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if(t(i)>=TimeSecs([16,29,59]))
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
        if(LastUD==1)
            bigs=[bigs size(updown,1)+1];
            WriteLogData(sell(i),timez(i,(4:6)),3,fout);
            updown=[updown;i -2 sell(i)];
        elseif(LastUD==0)
            bigs=[bigs size(updown,1)+1];
            WriteLogData(buy(i),timez(i,(4:6)),6,fout);
            updown=[updown;i -1 buy(i)];
        end
%         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
%         WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    if((l1(i)-l2(i))>0.05)

        % Calculate smoothed lines and gradients
        % Read in enough so that averaging works.
        if(i>(StartT+nS))

            % Calculate indices to smooth, with padding at left hand-side
            if(i>(nSmooth+StartT)) is=(i-nSmooth):i;
            else
                n1s=nSmooth-i+1;
                is=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            if(i>(nSmoothL1+StartT)) iL1s=(i-nSmoothL1):i;
            else
                n1s=nSmoothL1-i+1;
                iL1s=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            if(i>(nSmoothL2+StartT)) iL2s=(i-nSmoothL2):i;
            else
                n1s=nSmoothL2-i+1;
                iL2s=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end

            % Calculate smoothed values
            s1(j)=mean(l1(iL1s));
            s2(j)=mean(l2(iL2s));
            s3(j)=mean(l3(is));

            % do the up down test
            if(UPDOWN)
                % get lowest and highest
                if(s1(j)<=s1Low)
                    s1Low=s1(j);
                    s1T=i;
                end
                if(s2(j)>=s2High)
                    s2High=s2(j);
                    s2T=i;
                end
                % Check if up
                if(s2(j)>s1Low)
                    nUD=nUD+1;
                    if(LastUD==1) mults=[mults nUD];
                    else
                        bigs=[bigs nUD];
                        WriteLogData(buy(i),timez(i,(4:6)),6,fout);
                        wavplay(upsound);
                    end
                    s1Low=s1(j);
                    s1T=i;
                    LastUD=1;
                    updown(nUD,:)=[i 1 buy(i)];
                end
                % Check if down
                if(s1(j)<s2High)
                    nUD=nUD+1;
                    if(LastUD==0) mults=[mults nUD];
                    else
                        bigs=[bigs size(updown,1)+1];
                        WriteLogData(sell(i),timez(i,(4:6)),3,fout);
                        wavplay(downsound);
                    end
                    s2High=s2(j);
                    s2T=i;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end
            end

            % Calc gradient
            if(j>(StartT+3))
                g = gradient(s3(j-2:j));
                g3(j) = g(2);

                % check if optima and if greater than previous
                a=g3(j)*g3(j-1);
                if(a<=0)
                    if(g3(j)>g3(j-1))
                        mi=[mi j-1];
                        mi_s=[mi_s s3(j-1)];
                        % if lower and outside the window for multiple alerts
                        if((s3(j-1)<=LastMin)&((i-LastMinAlertT)>MultipleLimit))
                            LastMin=s3(j-1);
                            LastMinT=j-1;
                        end
                    else
                        ma=[ma j-1];
                        ma_s=[ma_s s3(j-1)];
                        % if higher and outside the window for multiple alerts
                        if((s3(j-1)>=LastMax)&((i-LastMaxAlertT)>MultipleLimit))
                            LastMax=s3(j-1);
                            LastMaxT=j-1;
                        end
                    end;
                end

                % if within time limit, check if TP triggers buy alert
                if((i-LastMinT)<TimeLim)
                    % Get end indices to mean over
                    if(i>(EndPt+StartT)) ks=(i-EndPt):i;
                    else
                        n1s=EndPt-i+1;
                        ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                    end
                    % if its a true minimum, buy and re-set the last min
                    if((mean(l3(ks))-LastMin)>Thresh)
                        WriteLogData(buy(i),timez(i,(4:6)),4,fout);
                        buysell=[buysell;i 1 buy(i)];
                        wavplay(buysound);
                        LastAlertT=i;
                        LastMinAlertT=i;
                        LastAlert=1;
                        MMin=[MMin LastMin];
                        MMinT=[MMinT LastMinT];
                        LastMin=1e9;
                        LastMinT=-TimeLim;
                    end
                else
                    % if outside the time limit, re-set min
                    % Could change to next potential min in list
                    LastMin=1e9;
                    LastMinT=-TimeLim;
                end

                if((i-LastMaxT)<TimeLim)
                    % Get end indices to mean over
                    if(i>(EndPt+StartT)) ks=(i-EndPt):i;
                    else
                        n1s=EndPt-i+1;
                        ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                    end
                    % if its a true maximum, sell and re-set the last max
                    if((LastMax-mean(l3(ks)))>Thresh)
                        WriteLogData(sell(i),timez(i,(4:6)),1,fout);
                        buysell=[buysell;i 0 sell(i)];
                        wavplay(sellsound);
                        MMax=[MMax LastMax];
                        MMaxT=[MMaxT LastMaxT];
                        LastAlertT=i;
                        LastMaxAlertT=i;
                        LastAlert=0;
                        LastMax=-1e9;
                        LastMaxT=-TimeLim;
                    end
                else
                    % if outside the time limit, re-set min
                    % Could change to next potential min in list
                    LastMax=-1e9;
                    LastMaxT=-TimeLim;
                end
            elseif(j>(StartT+2))
                % if not enough vals to check if optima
                g=gradient(s3(j-2:j));
                g3(j) = g(2);
            end;
            % increment j
            j=j+1;
        end
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
            save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        end
        StartT=i;
        LastUD=-1;
        s1Low=1e9;
        s2High=-1e9;
    end
    % graph the data

    if(mod(i,RepTime)==0)
        xl=max(1,i-PtsToPlot+1);
        ivec=xl:i;
        plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
        hold on
        if(i>(StartT+nS+2))
            jvec=xl:i-nS;
            plot(jvec+d3,s3(jvec),'m','Linewidth',2);
            plot(jvec+d2,s2(jvec),'b','Linewidth',2);
            plot(jvec+d1,s1(jvec),'r','Linewidth',2);
            if(length(ma)) plot(ma+d3,ma_s,'r.'); end;
            if(length(mi)) plot(mi+d3,mi_s,'b.'); end;
            if(length(MMax)) plot(MMaxT+d3,MMax,'ro'); end;
            if(length(MMin)) plot(MMinT+d3,MMin,'bo'); end;

            for k=1:size(buysell,1)
                ind=buysell(k,1);
                if(buysell(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
                else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
                end
            end
            for k=bigs
                ind=updown(k,1);
                if(updown(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
                else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
                end
            end
            for k=mults
                ind=updown(k,1);
                if(updown(k,2)) plot([ind ind],[l2(ind) l1(ind)],'b','Linewidth',2);
                else plot([ind ind],[l2(ind) l1(ind)],'r','Linewidth',2);
                end
            end
            if(UPDOWN) plot(s1T+d1,s1Low,'bs',s2T+d2,s2High,'rs'); end;

            % Plot current max and min
            if(LastMin~=1e9)
                plot(LastMinT+d3,LastMin,'bo','MarkerFaceColor','b');%,'MarkerSize',10);
                TitStr=['Lowest Min = ' num2str(LastMin)];
            else TitStr=['Lowest Min unassigned'];
            end
            if(LastMax~=-1e9)
                plot(LastMaxT+d3,LastMax,'ro','MarkerFaceColor','r');%,'MarkerSize',10);
                TitStr=[TitStr '; Highest Max = ' num2str(LastMax)];
            else TitStr=[TitStr '; Highest Max unassigned'];
            end
        end
        axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
        title(TitStr);
        xlabel('Hourly chart')
        hold off;
        drawnow;

    end
    %     WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
%     i
%     td=GetSecs-ts;
%     w=PauseLen-td;
%     if(w>0) pause(w);  end;
end
buyselltime=buysell;
save temp buyselltime
[b1,b2,TrTimes]=GetProfit(buysell,1);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=max(size(buysell,1)-1,0)
[ud1,ud2,TrTimes]=GetProfit(updown);
up1=sum(ud1)
up2=sum(ud2)
NumTradesUD=max(length(bigs)-1,0)

figure(2)
plot(1:i,l1,'g',1:i,l2,'g',1:i,l3,'g','Linewidth',2)
hold on
plot((1:j-1)+d3,s3,'m',(1:j-1)+d2,s2,'b',(1:j-1)+d1,s1,'r','Linewidth',2);
if(length(ma)) plot(ma+d3,ma_s,'r.'); end;
if(length(mi)) plot(mi+d3,mi_s,'b.'); end;
if(length(MMax)) plot(MMaxT+d3,MMax,'ro'); end;
if(length(MMin)) plot(MMinT+d3,MMin,'bo'); end;
for k=1:size(buysell,1)
    ind=buysell(k,1);
    if(abs(buysell(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
    end
end
% Plot UPDOWN stuff
for k=bigs
    ind=updown(k,1);
    if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
    end
end
for k=mults
    ind=updown(k,1);
    if(updown(k,2)) plot([ind ind],[l2(ind) l1(ind)],'b','Linewidth',2);
    else plot([ind ind],[l2(ind) l1(ind)],'r','Linewidth',2);
    end
end

if(~isempty(buysell))
    figure(3)
    bar([b1;b2]')
    legend('simple','multiple');
    title('Buy sell profit/loss')
end
if(~isempty(bigs))
    figure(4)
    bar(ud1)
    title('Up down profit/loss')
end