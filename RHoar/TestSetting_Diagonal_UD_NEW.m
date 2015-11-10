function[bs1,bs2,NumTrades] = TestSetting_Diagonal_UD(fin,nSmooth,EndPt,RangeProp,nSmoothUD,EndPtUD,RepTime)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
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

% Set DIAGONAL parameters
EndPtU=EndPt;
EndPtD=EndPtU;
RangeProp=RangeProp*100/0.1;

% UPDOWN parameters
nSmoothL1=nSmoothUD;
nSmoothL2=nSmoothL1;
ExtrapL1=RangeProp;
ExtrapL2=RangeProp;

% ensure nSmooths are even
nS2=ceil(nSmooth/2);
nSmooth=2*nS2;
nS2L1=ceil(nSmoothL1/2);
nSmoothL1=2*nS2L1;
nS2L2=ceil(nSmoothL2/2);
nSmoothL2=2*nS2L2;
% Get max
nS=max([nS2, nS2L1,nS2L2]);

s=date;
% fn=['logData_Test_DiagonalUD.mat'];
fout=['BSlogdata_Test_DiagonalUD.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
% fout2=['exceldata_' s '.txt'];

PtsToPlot=3600;
% PtsToPlot2=7200;

if(~isfile(fout)) WriteLogDataPreamble(fout,s); end;
% if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nSmooth,0,EndPtU,0,0,EndPtD);
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud,s); end;
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

j=1;
buysell=[];
NotStillClosed=1;
StartT=0;

[tim,L1,L2,L3,B,S]=ReadLogData(fin);
if(nargin<2) RepTime=100; end;

% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
% updown start variables
updown=[];mults=[];bigs=[];
nUD=0;
for i=1:length(L1)%N;
    % Read data and write to file/variables
    % can delete this bit if all works
    ts=GetSecs;
    l1(i)=L1(i);
    l2(i)=L2(i);
    l3(i)=L3(i);
    buy(i)=B(i);
    sell(i)=S(i);
    if(B==0)
        if(i>1) buy(i)=buy(i-1); end;
    end;
    if(S==0)
        if(i>1) sell(i)=sell(i-1); end;
    end;
    timez(i,:)=tim(i,:);

    % from here
    %     l1(i)=L1;
    %     l2(i)=L2;
    %     l3(i)=L3;
    %     buy(i)=B;
    %     if(B==0)
    %         if(i>1) buy(i)=buy(i-1); end;
    %     end;
    %     sell(i)=S;
    %     if(S==0)
    %         if(i>1) sell(i)=sell(i-1); end;
    %     end;
    %     timez(i,:)=clock;
    % to here

    t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if(t(i)>=TimeSecs([16,29,59]))
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
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
        %        WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
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

            % main loop
            if(j>(StartT+3))
                % L1 down diagonal: Check if at an optima
                d=diff(s1(j-2:j));
                if(d(1)*d(2)<=0)
                    % Check if min
                    if(d(1)<d(2))
                        if(s1(j)<=s1Low)
                            s1Low=s1(j);
                            s1LowT=j;
                            gr=(s1Low-s1High(2))/(j-s1High(1));
                            len=ExtrapL1*(l1(i)-l2(i));
                            [s1Ex,s1ExT]=GetDiagonalPt(gr,len,s1Low,j);
                            s1Line=[s1High;j,s1Low;s1ExT,s1Ex];
                            if(sum(abs(s1Line(:,2)))>1e3)
                                keyboard
                            end
                        end
                    elseif(s1(j)>=s1High(2)) 
                        s1High=[j s1(j)];
                    end
                end
                
                % Get end indices to mean over
                if(i>(EndPtUD+StartT)) ks=(i-EndPtUD):i;
                else
                    n1s=EndPtUD-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % Check if up
                if(mean(l2(ks))>s1Ex)
                    nUD=nUD+1;
                    if(LastUD==1) mults=[mults nUD];
                    else
                        bigs=[bigs nUD];
                        WriteLogData(buy(i),timez(i,(4:6)),6,fout);
                        wavplay(upsound);
                    end
                    s1Low=1e9;s1LowT=j;
                    s1High=[0 -1e9];
                    s1Ex=1e9;
                    LastUD=1;
                    updown(nUD,:)=[i 1 buy(i)];
                end

                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2(j-2:j));
                if(d(1)*d(2)<=0)
                    % Check if max
                    if(d(1)>d(2))
                        if(s2(j)>=s2High)
                            s2High=s2(j);
                            s2HighT=j;
                            gr=(s2High-s2Low(2))/(j-s2Low(1));
                            len=ExtrapL2*(l1(i)-l2(i));
                            [s2Ex,s2ExT]=GetDiagonalPt(gr,len,s2High,j);
                            s2Line=[s2Low;j,s2High;s2ExT,s2Ex];
                            if(sum(abs(s2Line(:,2)))>1e3)
                                keyboard
                            end
                        end
                    elseif(s2(j)<=s2Low(2)) 
                        s2Low=[j s2(j)];
                    end;
                end
                % Check if down
                if(mean(l1(ks))<s2Ex)
                    nUD=nUD+1;
                    if(LastUD==0) mults=[mults nUD];
                    else
                        bigs=[bigs size(updown,1)+1];
                        WriteLogData(sell(i),timez(i,(4:6)),3,fout);
                        wavplay(downsound);
                    end
                    s2High=-1e9;s2HighT=j;
                    s2Low=[0 1e9];
                    s2Ex=-1e9;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end

                % mid line test: Calc gradient
                g = gradient(s3(j-2:j));
                g3(j) = g(2);
                % check if optima and if greater than previous
                a=g3(j)*g3(j-1);
                if(a<=0)
                    if(g3(j)>g3(j-1))
                        mi3=[mi3 j];
                        mi3_s=[mi3_s s3(j)];
                        if(s3(j)<=LastMin)
                            LastMin=s3(j);
                            LastMinT=j;
                            % Calc new max-min line and extrapolation
                            DownGrad=(LastMin-DownStart)/(LastMinT-DownStartT);
                            len=RangeProp*(l1(i)-l2(i));
                            [DownPt,DownT]=GetDiagonalPt(DownGrad,len,LastMin,LastMinT);
                            DownLine=[DownStartT,DownStart;LastMinT,LastMin;DownT,DownPt];
                        end
                        if(s3(j)<=UpStart)
                            UpStart=s3(j);
                            UpStartT=j;
                        end
                    else
                        ma3=[ma3 j];
                        ma3_s=[ma3_s s3(j)];
                        if(s3(j)>=LastMax)
                            LastMax=s3(j);
                            LastMaxT=j;
                            % Calc new max-min line and extrapolation
                            UpGrad=(LastMax-UpStart)/(LastMaxT-UpStartT);
                            len=RangeProp*(l1(i)-l2(i));
                            [UpPt,UpT]=GetDiagonalPt(UpGrad,len,LastMax,LastMaxT);
                            UpLine=[UpStartT,UpStart;LastMaxT,LastMax;UpT,UpPt];
                        end
                        if(s3(j)>=DownStart)
                            DownStart=s3(j);
                            DownStartT=j;
                        end
                    end;
                end

                % check if TP triggers buy alert
                % Get end indices to mean over
                if(i>(EndPtD+StartT)) ks=(i-EndPtD):i;
                else
                    n1s=EndPtD-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % if mean is above DownPt, buy and set AlertFlags
                if(mean(l2(ks))>DownPt)
                    WriteLogData(buy(i),timez(i,(4:6)),4,fout);
                    buysell=[buysell;i 1 buy(i)];
                    wavplay(buysound);
                    DownPt=1e9;
                    MMin=[MMin LastMin];
                    MMinT=[MMinT LastMinT];
                    LastMin=1e9;
                    DownStart=-1e9;
                end

                % Get end indices to mean over
                if(i>(EndPtU+StartT)) ks=(i-EndPtU):i;
                else
                    n1s=EndPtU-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % if mean is below UpPt, sell and set AlertFlags
                if(mean(l1(ks))<UpPt)
                    WriteLogData(sell(i),timez(i,(4:6)),1,fout);
                    buysell=[buysell;i 0 sell(i)];
                    wavplay(sellsound);
                    MMax=[MMax LastMax];MMaxT=[MMaxT LastMaxT];
                    UpPt = -1e9;
                    LastMax=-1e9;
                    UpStart=1e9;
                end
            elseif(j>(StartT+2))
                % if not enough vals to check if optima
                g = gradient(s3(j-2:j));
                g3(j) = g(2);
                % DIAGONAL starts
                [UpStart,mt]=min(s3(j-1:j));
                UpStartT=j-2+mt;
                [DownStart,mt]=max(s3(j-1:j));
                DownStartT=j-2+mt;
                DownLine=[DownStartT,DownStart;DownStartT,DownStart;DownStartT,DownStart];
                UpLine=[UpStartT,UpStart;UpStartT,UpStart;UpStartT,UpStart];
                LastMin=1e9;
                LastMax=-1e9;
                DownPt=1e9;
                UpPt=-1e9;

                % UPDOWN start variables
                LastUD=-1;
                s1Ex=1e9;
                s2Ex=-1e9;
                s1Low=1e9;s1LowT=j;
                s2High=-1e9;s2HighT=j;
                [x,mt]=max(s1(StartT+1:j));
                s1High=[StartT+mt x];
                s1Line=[s1High;s1High;s1High];
                [x,mt]=min(s2(StartT+1:j));
                s2Low=[StartT+mt x];
                s2Line=[s2Low;s2Low;s2Low];
            end;
            % increment j
            j=j+1;
        end
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
            save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        end
        StartT=i;
    end

    % graph the data
    if(mod(i,RepTime)==0)
        xl=max(1,i-PtsToPlot+1);
        ivec=xl:i;
        plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
        hold on
        if(i>(StartT+nS+2))
            jvec=xl:(i);
            plot(jvec-nS2,s3(jvec),'m','Linewidth',2);
            plot(jvec-nS2L2,s2(jvec),'b','Linewidth',2);
            plot(jvec-nS2L1,s1(jvec),'r','Linewidth',2);
            if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
            if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
            if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
            if(length(MMin)) plot(MMinT,MMin,'bo'); end;
            for k=1:size(buysell,1)
                ind=buysell(k,1);
                if(buysell(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
                else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
                end
            end
            % Plot current lines
            plot(DownLine([1 2],1),DownLine([1 2],2),'k','Linewidth',2)
            plot(DownLine([2 3],1),DownLine([2 3],2),'b','Linewidth',2)
            plot(UpLine([1 2],1),UpLine([1 2],2),'k','Linewidth',2)
            plot(UpLine([2 3],1),UpLine([2 3],2),'r','Linewidth',2)
            if(DownStart~=-1e9) plot(DownStartT,DownStart,'bs'); end;
            if(UpStart~=1e9) plot(UpStartT,UpStart,'rs'); end;
            if(LastMin~=1e9) plot(LastMinT,LastMin,'bo','MarkerFaceColor','b');end
            if(LastMax~=-1e9)plot(LastMaxT,LastMax,'ro','MarkerFaceColor','r');end
            TitStr=['UpLine = ' num2str(UpLine(1,2)) ' to ' num2str(UpLine(2,2)) '; DownLine = ' num2str(DownLine(1,2)) ' to ' num2str(DownLine(2,2))];
            % Plot UPDOWN stuff
            plot(s1Line(:,1),s1Line(:,2),'k')%,'Linewidth',2)
            plot(s2Line(:,1),s2Line(:,2),'k')%,'Linewidth',2)
            plot([s1High(1) s1LowT],[s1High(2) s1Low],'bs')
            plot([s2Low(1) s2HighT],[s2Low(2) s2High],'rs')
            for k=bigs
                ind=updown(k,1)-nS2L2;
                if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
                else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
                end
            end
            for k=mults
                ind=updown(k,1)-nS2L2;
                if(updown(k,2)) plot([ind ind],[l2(ind) l1(ind)],'b','Linewidth',2);
                else plot([ind ind],[l2(ind) l1(ind)],'r','Linewidth',2);
                end
            end
%             if(l3(xl)-l3(i)>0) yt=l3(i)-0.22;
%             else yt=l3(i)+0.18;
%             end
            yt=l3(i)+0.18;
            if(LastUD==1) text(xl+100,yt,'UP','FontSize',14,'Color','b');
            elseif(LastUD==0) text(xl+100,yt,'DOWN','FontSize',14,'Color','r');
            end
            title(TitStr);
        end
        axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
        xlabel('Hourly chart')
        hold off;
        drawnow;
        %        keyboard
        %         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
    end
    %    WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
    %     if(Plotting)
    %         i
    %         td=GetSecs-ts;
    %         w=PauseLen-td;
    %         if(w>0) pause(w);  end;
    %     end
end
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
plot(1:j-1,s3,'m',1:j-1,s2,'b',1:j-1,s1,'r','Linewidth',2);
if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
if(length(MMin)) plot(MMinT,MMin,'bo'); end;
for k=1:size(buysell,1)
    ind=buysell(k,1);
    if(abs(buysell(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
    end
end
% Plot UPDOWN stuff
for k=bigs
    ind=updown(k,1)-nS2L2;
    if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
    end
end
for k=mults
    ind=updown(k,1)-nS2L2;
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