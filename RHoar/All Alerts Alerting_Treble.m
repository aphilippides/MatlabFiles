% function[bs1,bs2,NumTrades] = TestSetting_Treble(fin,nSm,EndPt,RP, ...
%     nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,nSUD3,EPUD3,RPUD3, ...
%     TimeLim,p1p2Lim,RepTime)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    cd RHoar/LogData/;
end

h=gcf;
set(h,'Units','centimeters','Position',[1 1 30 10]);
ax1=subplot('Position',[0.05 0.575 0.35 0.35]);
ax2=subplot('Position',[0.05 0.1 0.35 0.35]);
ax3=subplot('Position',[0.6 0.1 0.35 0.825]);

buysound=wavread('buy.wav');
downsound=wavread('down.wav');
mid1sound=wavread('trend up.wav');
mid2sound=wavread('trend down.wav');
sellsound=wavread('sell.wav');
upsound=wavread('up.wav');
up1sound=wavread('up1.wav');
down1sound=wavread('down 2.wav');
hi2day=wavread('Hi 2 Day.wav');
low1day=wavread('Low1 Day.wav');
e_down=wavread('eTrend Down.wav');
e_up=wavread('eTrend Up.wav');
vol_buy=wavread('Volume Buy.wav');
vol_sell=wavread('Volume Sell.wav');
trend_buy=wavread('Trend Buy.wav');
trend_sell=wavread('Trend Sell.wav');
hi2=wavread('hi 2.wav');
low1=wavread('low 1.wav');

% max length of time (in secs) to run
N=33000;

% Set DIAGONAL parameters
nSm=1500;
EndPt=0;
RP=0.5;
% Set UD parameters
nSUD=1500;
EPUD=0;
RPUD=0.5;
% Set UD2 parameters
nSUD2=3300;
EPUD2=3300;
RPUD2=0.5;
% Set UD3 parameters
nSUD3=1500;
EPUD3=1500;
RPUD3=0;
% Set p1p2 parameters
TimeLim=1000;
p1p2Lim=100;

s=date;
fout=['BSlogdata_' s '.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];
% WriteLogDataPreamble(fout,['Testing data file: ' fin]);
if(~isfile(fout)) WriteLogDataPreamble(fout,s); end;
if(~isfile(fout2)) WriteExcelDataPreambleVol(fout2); end;

WriteParamsDynamic(fout,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,nSUD3,EPUD3,RPUD3);

% Set DIAGONAL parameters
EndPtU=EndPt;
EndPtD=EndPtU;
RP=RP*100/0.1;

% UPDOWN parameters
nSmoothL1=nSUD;
nSmoothL2=nSmoothL1;
RPUD=RPUD*100/0.1;
RPUD2=RPUD2*100/0.1;
RPUD3=RPUD3*100/0.1;
ExL1=RPUD;
ExL2=RPUD;

% ensure nSmooths are even
nS2=ceil(nSm/2);
nSm=2*nS2;
% nS22=ceil(nSm2/2);
% nSm2=2*nS22;
nS2L1=ceil(nSmoothL1/2);
nSmoothL1=2*nS2L1;
nS2L2=ceil(nSmoothL2/2);
nSmoothL2=2*nS2L2;
nS2UD2=ceil(nSUD2/2);
nSUD2=2*nS2UD2;
nS2UD3=ceil(nSUD3/2);
nSUD3=2*nS2UD3;

PtsToPlot=3600;
PtsToPlot2=7200;
j3=1;jud=1;jud2=1;jud3=1;
NotStillClosed=1;
StartT=0;
PauseLen=1;

% [tim,L1,L2,L3,B,S,V]=ReadLogDataV(fin);
% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
buysell=[];buysell2=[];buysell3=[];
NetVol=0;

% updown start variables
updown=[];mults=[];bigs=[];nUD=0;
updown2=[];mults2=[];bigs2=[];nUD2=0;
updown3=[];mults3=[];bigs3=[];nUD3=0;

% p1p2 start values
p2Off=1; p1Off=1; eUpOn=0; eDownOn=0;
p1p2=[]; s1s2=[]; d1d2=[];
stop1=[0 -1e9];stop2=[0 1e9];DiagL1.gr=-1e9;DiagL2.gr=1e9;
Low1Day=[0 1e9];Hi2Day=[0 -1e9];
HLinesL1=[];HLinesL2=[];DLinesL1=[];DLinesL2=[];
[l1line,l2line]=InitP1P2;
for i=1:N;
    ts=GetSecs;
    l1(i)=L1;
    l2(i)=L2;
    l3(i)=L3;
    if(isnumeric(B))
        buy(i)=B;
        if(B==0) if(i>1) buy(i)=buy(i-1); end;end;
    else buy(i)=0;
    end
    if(isnumeric(S))
        sell(i)=S;
        if(S==0) if(i>1) sell(i)=sell(i-1); end;end;
    else sell(i)=0;
    end
    if(isnumeric(V)) vol(i)=V;
    else vol(i)=0;
    end
    timez(i,:)=clock;
    t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if(t(i)>=TimeSecs([16,29,59]))
        WriteExcelDataVol(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),vol(i),fout2);
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
        %         buysell2=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell2,fout,2);
        buysell3=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell3,fout,3);
        x1x2=CombineProfs(p1p2,d1d2);
        x1x2=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),x1x2,fout,[13 14]);
        [a,b]=GetProfit(x1x2);
        pr1=sum(a);pr2=sum(b);
        title(ax3,['DAILY CHART:   E Trend Profit A = ' num2str(pr1) '; E Trend Profit B = ' num2str(pr2)]);
        [updown,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown,fout,[3 6]);
        bigs=[bigs nb];
        [updown2,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown2,fout,[2 5]);
        bigs2=[bigs2 nb];
        [updown3,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown3,fout,[11 12]);
        bigs3=[bigs3 nb];
        break;
    end

    spread=l1(i)-l2(i);
    if((spread>0.01)&(spread<0.4))
        % Buy sell line
        if(i>(StartT+nS2))
            if(i>(nSm+StartT)) is=(i-nSm):i;
            else
                n1s=nSm-i+1;
                is=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            s3(j3)=mean(l3(is)); s3t(j3)=j3+StartT;
            % main loop
            if(i>(StartT+nS2+3))
                % mid line test: Calc gradient
                g = gradient(s3(j3-2:j3));
                g3(j3) = g(2);
                % check if optima and if greater than previous
                a=g3(j3)*g3(j3-1);
                if(a<=0)
                    if(g3(j3)>g3(j3-1))
                        mi3=[mi3 s3t(j3)];
                        mi3_s=[mi3_s s3(j3)];
                        if((s3(j3)<=LastMin)&(DownStart~=-1e9))
                            LastMin=s3(j3);
                            LastMinT=s3t(j3);
                            % Calc new max-min line and extrapolation
                            DownGrad=(LastMin-DownStart)/(LastMinT-DownStartT);
                            len=RP*spread;
                            [DownPt,DownT]=GetDiagonalPt(DownGrad,len,LastMin,LastMinT);
                            DownLine=[DownStartT,DownStart;LastMinT,LastMin;DownT,DownPt];
                        end
                        if(s3(j3)<=UpStart)
                            UpStart=s3(j3);
                            UpStartT=s3t(j3);
                        end
                    else
                        ma3=[ma3 s3t(j3)];
                        ma3_s=[ma3_s s3(j3)];
                        if((s3(j3)>=LastMax)&(UpStart~=1e9))
                            LastMax=s3(j3);
                            LastMaxT=s3t(j3);
                            % Calc new max-min line and extrapolation
                            UpGrad=(LastMax-UpStart)/(LastMaxT-UpStartT);
                            len=RP*spread;
                            [UpPt,UpT]=GetDiagonalPt(UpGrad,len,LastMax,LastMaxT);
                            UpLine=[UpStartT,UpStart;LastMaxT,LastMax;UpT,UpPt];
                        end
                        if(s3(j3)>=DownStart)
                            DownStart=s3(j3);
                            DownStartT=s3t(j3);
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
                    wavplay(buysound);%,'async');
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
                    wavplay(sellsound);%,'async');
                    MMax=[MMax LastMax];MMaxT=[MMaxT LastMaxT];
                    UpPt = -1e9;
                    LastMax=-1e9;
                    UpStart=1e9;
                end
            elseif(i>(StartT+nS2+2))%j3>(StartT+2))
                % if not enough vals to check if optima
                g = gradient(s3(j3-2:j3));
                g3(j3) = g(2);
                % DIAGONAL starts
                st=find(s3t>StartT,1);
                %                 [UpStart,mt]=min(s3(StartT+1:j3));
                [UpStart,mt]=min(s3(st:end));
                UpStartT=s3t(st+mt-1);%j3-2+mt;
                %                 [DownStart,mt]=max(s3(StartT+1:j3));
                [DownStart,mt]=max(s3(st:end));
                DownStartT=s3t(st+mt-1);%j3-2+mt;
                DownLine=[DownStartT,DownStart;DownStartT,DownStart;DownStartT,DownStart];
                UpLine=[UpStartT,UpStart;UpStartT,UpStart;UpStartT,UpStart];
                LastMin=1e9;
                LastMax=-1e9;
                DownPt=1e9;
                UpPt=-1e9;
                buying=0;selling=0;
                buying2=0;selling2=0;
            end;
            % increment j
            j3=j3+1;
        end
        % Up down line
        if(i>(StartT+nS2L1))
            if(i>(nSmoothL1+StartT)) iL1s=(i-nSmoothL1):i;
            else
                n1s=nSmoothL1-i+1;
                iL1s=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            % Calculate smoothed values
            s1(jud)=mean(l1(iL1s));
            s2(jud)=mean(l2(iL1s));
            s12t(jud)=jud+StartT;

            % main loop
            if(i>(StartT+nS2L1+3))%(jud>(StartT+3))
                % L1 down diagonal: Check if at an optima
                d=diff(s1(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s1Line,s1Low,s1LowT,s1Ex,s1High]=IfMin(s12t(jud),s1(jud),ExL1*spread,s1Line,s1Low,s1LowT,s1Ex,s1High,d);
                end
                % Get end indices to mean over
                if(i>(EPUD+StartT)) ks=(i-EPUD):i;
                else
                    n1s=EPUD-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % Check if up
                if(mean(l2(ks))>s1Ex)
                    nUD=nUD+1;
                    if(LastUD==1) mults=[mults nUD];
                    else bigs=[bigs nUD];
                    end
                    WriteLogData(buy(i),timez(i,(4:6)),6,fout);
                    wavplay(upsound,8000);%,'async');
                    s1Low=1e9;s1LowT=jud;
                    s1High=[0 -1e9];
                    s1Ex=1e9;
                    LastUD=1;
                    updown(nUD,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s2Line,s2Low,s2Ex,s2High,s2HighT]=IfMax(s12t(jud),s2(jud),ExL2*spread,s2Line,s2Low,s2Ex,s2High,s2HighT,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex)
                    nUD=nUD+1;
                    if(LastUD==0) mults=[mults nUD];
                    else bigs=[bigs nUD];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),3,fout);
                    wavplay(downsound,8000);%,'async');
                    s2High=-1e9;s2HighT=jud;
                    s2Low=[0 1e9];
                    s2Ex=-1e9;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end
            elseif(i>(StartT+nS2L1+2))%(jud>(StartT+2))
                % UPDOWN start variables
                LastUD=-1;
                s1Ex=1e9;
                s2Ex=-1e9;
                s1Low=1e9;s1LowT=jud;
                s2High=-1e9;s2HighT=jud;
                st=find(s12t>StartT,1);
                [x,mt]=max(s1(st:end));
                s1High=[StartT+mt x];
                s1Line=[s1High;s1High;s1High];
                [x,mt]=min(s2(st:end));
                %                 [x,mt]=min(s2(StartT+1:jud));
                s2Low=[StartT+mt x];
                s2Line=[s2Low;s2Low;s2Low];
            end;
            % increment j
            jud=jud+1;
        end

        % up down line 2
        if(i>(StartT+nS2UD2))
            if(i>(nSUD2+StartT)) iUD2=(i-nSUD2):i;
            else
                n1s=nSUD2-i+1;
                iUD2=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            % Calculate smoothed values
            s1_2(jud2)=mean(l1(iUD2));
            s2_2(jud2)=mean(l2(iUD2));
            s12t_2(jud2)=jud2+StartT;

            % main loop
            if(i>(StartT+nS2UD2+3))
                % L1 2nd down diagonal
                d=diff(s1_2(jud2-2:jud2));
                if(d(1)*d(2)<=0)
                    [s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2]=IfMin(s12t_2(jud2),s1_2(jud2),RPUD2*spread,s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2,d);
                end
                % Get end indices to mean over
                if(i>(EPUD2+StartT)) ks=(i-EPUD2):i;
                else
                    n1s=EPUD2-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % Check if up
                if(mean(l2(ks))>s1Ex2)
                    nUD2=nUD2+1;
                    if(LastUD2==1) mults2=[mults2 nUD2];
                    else bigs2=[bigs2 nUD2];
                    end
                    WriteLogData(buy(i),timez(i,(4:6)),5,fout);
                    wavplay(mid1sound,44100);%,'async');
                    s1Low2=1e9;s1LowT2=jud2;
                    s1High2=[0 -1e9];
                    s1Ex2=1e9;
                    LastUD2=1;
                    updown2(nUD2,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2_2(jud2-2:jud2));
                if(d(1)*d(2)<=0)
                    [s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2]=IfMax(s12t_2(jud2),s2_2(jud2),RPUD2*spread,s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex2)
                    nUD2=nUD2+1;
                    if(LastUD2==0) mults2=[mults2 nUD2];
                    else bigs2=[bigs2 nUD2];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),2,fout);
                    wavplay(mid2sound,44100);%,'async');
                    s2High2=-1e9;s2HighT2=jud2;
                    s2Low2=[0 1e9];
                    s2Ex2=-1e9;
                    LastUD2=0;
                    updown2=[updown2;i 0 sell(i)];
                end
                % Crossed L3?
                if(s2_2(jud2)>=s3(jud2))
                    if(~selling2)
                        WriteLogData(sell(i),timez(i,(4:6)),9,fout);
                        buysell3=[buysell3;i 0 sell(i)];
                        wavplay(vol_sell,24050);%,'async');
                        selling2=1;
                        StartV=vol(jud2);
                    end
                    NetVol=NetVol-vol(jud2)+vol(jud2-1);
                else selling2=0;
                end
                if(s1_2(jud2)<=s3(jud2))
                    if(~buying2)
                        WriteLogData(buy(i),timez(i,(4:6)),10,fout);
                        buysell3=[buysell3;i 1 buy(i)];
                        wavplay(vol_buy,24050);%,'async');
                        buying2=1;
                        StartV=vol(jud2);
                    end
                    NetVol=NetVol+vol(jud2)-vol(jud2-1);
                else buying2=0;
                end
            elseif(i>(StartT+nS2UD2+2))
                % UPDOWN2 start variables
                LastUD2=-1;
                s1Ex2=1e9;
                s2Ex2=-1e9;
                s1Low2=1e9;s1LowT2=jud2;
                s2High2=-1e9;s2HighT2=jud2;
                st=find(s12t_2>StartT,1);
                [x,mt]=max(s1_2(st:end));
                s1High2=[StartT+mt x];
                s1Line2=[s1High2;s1High2;s1High2];
                [x,mt]=min(s2_2(st:end));
                s2Low2=[StartT+mt x];
                s2Line2=[s2Low2;s2Low2;s2Low2];
            end;
            % increment j
            jud2=jud2+1;
        end

        % up down line 3
        if(i>(StartT+nS2UD3))
            if(i>(nSUD3+StartT)) iUD3=(i-nSUD3):i;
            else
                n1s=nSUD3-i+1;
                iUD3=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            % Calculate smoothed values
            s1_3(jud3)=mean(l1(iUD3));
            s2_3(jud3)=mean(l2(iUD3));
            s12t_3(jud3)=jud3+StartT;

            % main loop
            if(i>(StartT+nS2UD3+3))
                % L1 3nd down diagonal
                d=diff(s1_3(jud3-2:jud3));
                if(d(1)*d(2)<=0)
                    [s1Line3,s1Low3,s1LowT3,s1Ex3,s1High3]=IfMin(s12t_3(jud3),s1_3(jud3),RPUD3*spread,s1Line3,s1Low3,s1LowT3,s1Ex3,s1High3,d);
                end
                % Get end indices to mean over
                if(i>(EPUD3+StartT)) ks=(i-EPUD3):i;
                else
                    n1s=EPUD3-i+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:i];
                end
                % Check if up
                if(mean(l2(ks))>s1Ex3)
                    nUD3=nUD3+1;
                    if(LastUD3==1) mults3=[mults3 nUD3];
                    else bigs3=[bigs3 nUD3];
                    end
                    WriteLogData(buy(i),timez(i,(4:6)),12,fout);
                    wavplay(up1sound,44100);%,'async');
                    s1Low3=1e9;s1LowT3=jud3;
                    s1High3=[0 -1e9];
                    s1Ex3=1e9;
                    LastUD3=1;
                    updown3(nUD3,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2_3(jud3-2:jud3));
                if(d(1)*d(2)<=0)
                    [s2Line3,s2Low3,s2Ex3,s2High3,s2HighT3]=IfMax(s12t_3(jud3),s2_3(jud3),RPUD3*spread,s2Line3,s2Low3,s2Ex3,s2High3,s2HighT3,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex3)
                    nUD3=nUD3+1;
                    if(LastUD3==0) mults3=[mults3 nUD3];
                    else bigs3=[bigs3 nUD3];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),11,fout);
                    wavplay(down1sound,44100);%,'async');
                    s2High3=-1e9;s2HighT3=jud3;
                    s2Low3=[0 1e9];
                    s2Ex3=-1e9;
                    LastUD3=0;
                    updown3=[updown3;i 0 sell(i)];
                end
            elseif(i>(StartT+nS2UD3+2))
                % UPDOWN3 start variables
                LastUD3=-1;
                s1Ex3=1e9;
                s2Ex3=-1e9;
                s1Low3=1e9;s1LowT3=jud3;
                s2High3=-1e9;s2HighT3=jud3;
                st=find(s12t_3>StartT,1);
                [x,mt]=max(s1_3(st:end));
                s1High3=[StartT+mt x];
                s1Line3=[s1High3;s1High3;s1High3];
                [x,mt]=min(s2_3(st:end));
                s2Low3=[StartT+mt x];
                s2Line3=[s2Low3;s2Low3;s2Low3];
            end;
            % increment j
            jud3=jud3+1;
        end

        % l1 line p1 to p2
        [l1line,p1Off]=L1LineNew(l1(i),i,l1line,p1Off,p1p2Lim);
        % Check for etrend up
        td=i-l1line.p1(1);
        exl1=l1line.p1(2)+l1line.gr*td;
        % if time lim and extrap is past l1, ETrendUp!
        if(td>TimeLim)
            if(l2(i)>=exl1)
                if(p1Off)
                    p1p2=[p1p2;i 1 buy(i)];
                    wavplay(e_up,24050);
                    WriteLogData(buy(i),timez(i,(4:6)),14,fout);
                    p1Off=0;
                    eUpOn=1;
                    % Set stop values
%                     stop1=l1line.currlow;
%                     HLinesL1=[HLinesL1;stop1 buy(stop1(1))];
                    svt=l1line.p1(1);
                    [sval svalt]=min(l1(svt:i));
                    stop1=[svalt+svt-1 sval];
                    HLinesL1=[HLinesL1;stop1 buy(svalt+svt-1)];
                    % Set diag values ** ISSUE IF 250 lim untriggered
                    if(l2line.grnew~=-1e9)
                        DiagL1.p1=l2line.p1new;
                        DiagL1.p2=l2line.p2new;
                        DiagL1.gr=l2line.grnew;
                        DLinesL1=[DLinesL1;DiagL1];
                    else DiagL1.gr=-1e9;
                    end
                end
                %             else p1Off=1;
            elseif((~p1Off)&(l1(i)<=exl1))
                % Close out with a TrendSell
                d1d2=[d1d2;i -2 sell(i)];
                WriteLogData(sell(i),timez(i,(4:6)),17,fout);                
                wavplay(trend_sell,24050);%,'async');
                eUpOn=0;
                p1Off=1;
            end
        end
        % test low1: stop on l1
        if(l1(i)<stop1(2))
            if(stop1(2)<Low1Day(2))
                Low1Day=stop1;
                wavplay(low1day,24050);
                WriteLogData(sell(i),timez(i,(4:6)),19,fout);
            else
                wavplay(low1,44100);%,'async');
                WriteLogData(sell(i),timez(i,(4:6)),15,fout);
            end
            s1s2=[s1s2;i 0 sell(i)];
            stop1(2)=-1e9;
        end
        % test for trendsell: diagonal stop on line 1
        if(DiagL1.gr~=-1e9)
            td=i-DiagL1.p1(1);
            exDiag1=DiagL1.p1(2)+DiagL1.gr*td;
            if(l1(i)<exDiag1)
                d1d2=[d1d2;i 0 sell(i)];
                wavplay(trend_sell,24050);%,'async');
                WriteLogData(sell(i),timez(i,(4:6)),17,fout);
                DiagL1.gr=-1e9;
                % Set diag values ** ISSUE IF p1p2lim untriggered
                if(l1line.grnew~=1e9)
                    DiagL2.p1=l1line.p1new;
                    DiagL2.p2=l1line.p2new;
                    DiagL2.gr=l1line.grnew;
                    DLinesL2=[DLinesL2;DiagL2];
                else DiagL2.gr=1e9;
                end
            end
        else exDiag1=-1e9;
        end

        % l2 line p1 to p2
        [l2line,p2Off]=L2LineNew(l2(i),i,l2line,p2Off,p1p2Lim);
        % Check for etrend up
        td=i-l2line.p1(1);
        exl2=l2line.p1(2)+l2line.gr*td;
        % if time lim and extrap is past l1, ETrendDown!
        if(td>TimeLim)
            if(l1(i)<=exl2)
                if(p2Off)
                    p1p2=[p1p2;i 0 sell(i)];
                    wavplay(e_down,24050);%,'async');
                    WriteLogData(sell(i),timez(i,(4:6)),13,fout);
                    eDownOn=1;
                    p2Off=0;
                    % Set stop values
%                     stop2=l2line.currhigh;
%                     HLinesL2=[HLinesL2;stop2 sell(stop2(1))];
                    svt=l2line.p1(1);
                    [sval svalt]=max(l2(svt:i));
                    stop2=[svalt+svt-1 sval];
                    HLinesL2=[HLinesL2;stop2 sell(svalt+svt-1)];
                    % Set diag values ** ISSUE IF p1p2lim untriggered
                    if(l1line.grnew~=1e9)
                        DiagL2.p1=l1line.p1new;
                        DiagL2.p2=l1line.p2new;
                        DiagL2.gr=l1line.grnew;
                        DLinesL2=[DLinesL2;DiagL2];
                    else DiagL2.gr=1e9;
                    end
                end
%             elseif(eDownOn)
            elseif((~p2Off)&(l2(i)>=exl2))
                % Close out with a TrendSell
                d1d2=[d1d2;i -1 buy(i)];
                wavplay(trend_buy,24050);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),18,fout);
                eDownOn=0;
                p2Off=1;                
            end
        end
        % test for hi2/hi2 day: stop on l2
        if(l2(i)>stop2(2))
            if(stop2(2)>Hi2Day(2))
                Hi2Day=stop2;
                wavplay(hi2day,24050);
                WriteLogData(buy(i),timez(i,(4:6)),20,fout);
            else
                wavplay(hi2,44100);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),16,fout);
            end
            s1s2=[s1s2;i 1 buy(i)];
            stop2(2)=1e9;
        end
        % test for trendbuy: diagonal stop on line 2
        if(DiagL2.gr~=1e9)
            td=i-DiagL2.p1(1);
            exDiag2=DiagL2.p1(2)+DiagL2.gr*td;
            if(l2(i)>exDiag2)
                d1d2=[d1d2;i 1 buy(i)];
                wavplay(trend_buy,24050);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),18,fout);
                DiagL2.gr=1e9;
                % Set diag values ** ISSUE IF 250 lim untriggered
                if(l2line.grnew~=-1e9)
                    DiagL1.p1=l2line.p1new;
                    DiagL1.p2=l2line.p2new;
                    DiagL1.gr=l2line.grnew;
                    DLinesL1=[DLinesL1;DiagL1];
                else DiagL1.gr=-1e9;
                end
            end
        else exDiag2=1e9;
        end
        % My Stop
%         x1x2=CombineProfs(p1p2,d1d2);
%                 if((~isempty(x1x2))&(x1x2(end,2)>=0))
%                     pr=x1x2(end,3);
%                     if(x1x2(end,2)) prnow=sell(i)-pr;
%                     else  prnow=pr-buy(i);
%                     end
%                     if(i>x1x2(end,1))
%                         if(prnow>maxpr) maxpr=prnow; end;
%                         if(0)%prnow<=-5)
%                             if(x1x2(end,2)) p1p2=[p1p2;i -2 sell(i)];
%                             else p1p2=[p1p2;i -1 buy(i)];
%                             end
%                             %CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),p1p2,fout,[13 14]);
%                         elseif((maxpr>0)&((maxpr-prnow)>3))
%                             if(x1x2(end,2)) p1p2=[p1p2;i -2 sell(i)];
%                             else p1p2=[p1p2;i -1 buy(i)];
%                             end
%                         end
%                     else maxpr=prnow;
%                     end
%                     oldpr=prnow
%                 end

        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            % Close stuff
            buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
            %         buysell2=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell2,fout,2);
            buysell3=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell3,fout,3);
%             p1p2=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),p1p2,fout,[13 14]);
            [updown,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown,fout,[3 6]);
            bigs=[bigs nb];
            [updown2,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown2,fout,[2 5]);
            bigs2=[bigs2 nb];
            [updown3,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown3,fout,[11 12]);
            bigs3=[bigs3 nb];
        end
        StartT=i;
    end

    % graph the data
    subplot(ax1);
    xl=max(1,i-PtsToPlot+1);
    ma=min(max([l1(xl:i) l2(xl:i)])+0.02,l3(i)+0.5);
    mi=max(min([l1(xl:i) l2(xl:i)])-0.02,l3(i)-0.5);
    ivec=xl:i;
    plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
    hold on
    if(i>(StartT+nS2+2))
        %             jvec=xl:i-nS2;
        plot(s3t,s3,'m','Linewidth',2);
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
        %             for k=1:size(buysell2,1)
        %                 ind=buysell2(k,1);
        %                 if(buysell2(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],':h');
        %                 else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:h');
        %                 end
        %             end
        % Plot current lines
        plot(DownLine([1 2],1),DownLine([1 2],2),'k','Linewidth',2)
        plot(DownLine([2 3],1),DownLine([2 3],2),'b','Linewidth',2)
        plot(UpLine([1 2],1),UpLine([1 2],2),'k','Linewidth',2)
        plot(UpLine([2 3],1),UpLine([2 3],2),'r','Linewidth',2)

        if(DownStart~=-1e9) plot(DownStartT,DownStart,'bs'); end;
        if(UpStart~=1e9) plot(UpStartT,UpStart,'rs'); end;
        if(LastMin~=1e9) plot(LastMinT,LastMin,'bo','MarkerFaceColor','b');end
        if(LastMax~=-1e9)plot(LastMaxT,LastMax,'ro','MarkerFaceColor','r');end
    end
    if(i>(StartT+nS2L1+2))
        %             jvec=xl:i-nS2L1;
        %             plot(jvec,s2(jvec),'b','Linewidth',2);
        plot(s12t,s2,'r','Linewidth',2);
        plot(s12t,s1,'b','Linewidth',2);
        % Plot UPDOWN stuff
        plot(s1Line(:,1),s1Line(:,2),'k')%,'Linewidth',2)
        plot([s1Line(end,1) i],s1Line([end end],2),'k')%,'Linewidth',2)
        plot(s2Line(:,1),s2Line(:,2),'k')%,'Linewidth',2)
        plot([s2Line(end,1) i],s2Line([end end],2),'k')%,'Linewidth',2)
        plot([s1High(1) s1LowT],[s1High(2) s1Low],'bs')
        plot([s2Low(1) s2HighT],[s2Low(2) s2High],'rs')
        for k=bigs
            ind=updown(k,1);
            if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
            end
        end
        for k=mults
            ind=updown(k,1);
            if(updown(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-s','Linewidth',1);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-s','Linewidth',1);
            end
        end
        if(LastUD==1) text(xl+100,ma-0.18,'UP','FontSize',14,'Color','b');
        elseif(LastUD==0) text(xl+100,ma-0.18,'DOWN','FontSize',14,'Color','r');
        end
    end
    if(i>(StartT+nS2UD3+2))
        % updown 3 stuff
        %             jvec=xl:i-nS2UD3;
        %             plot(jvec,s2_3(jvec),'r','Linewidth',2);
        %             plot(jvec,s1_3(jvec),'b','Linewidth',2);
        plot(s1Line3(:,1),s1Line3(:,2),'k--')%,'Linewidth',2)
        plot(s2Line3(:,1),s2Line3(:,2),'k--')%,'Linewidth',2)
        plot([s1High3(1) s1LowT3],[s1High3(2) s1Low3],'b.')
        plot([s2Low3(1) s2HighT3],[s2Low3(2) s2High3],'r.')
        for k=bigs3
            ind=updown3(k,1);
            if(abs(updown3(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:v','Linewidth',2);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:v','Linewidth',2);
            end
        end
        for k=mults3
            ind=updown3(k,1);
            if(updown3(k,2)) plot([ind ind],[l2(ind) l3(ind)+0.125],'b:v','Linewidth',1);
            else plot([ind ind],[l3(ind)-0.125 l1(ind)],'r:v','Linewidth',1);
            end
        end
        if(LastUD3==1) text(xl+100,mi+0.05,'UP 1','FontSize',14,'Color','b');
        elseif(LastUD3==0) text(xl+100,mi+0.05,'DOWN 2','FontSize',14,'Color','r');
        end
    end
    axis([xl-1 i mi ma])
    %         axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
    bsp=sum(GetProfit(buysell));
    udp=sum(GetProfit(updown)); udp3=sum(GetProfit(updown3));
    title(['HOURLY CHART:   BS = ' num2str(bsp) ';   UD = ' num2str(udp) ';   UD 1 = ' num2str(udp3) ]);
    hold off;
    drawnow;
    subplot(ax2);
    xl=max(1,i-PtsToPlot2+1);
    ivec=xl:i;
    plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
    hold on
    if(i>(StartT+nS2+2))
        %             jvec=xl:i-nS2;
        %             plot(jvec,s3(jvec),'m','Linewidth',2);
        plot(s3t,s3,'m','Linewidth',2);
        %             if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
        %             if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
        %             if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
        %             if(length(MMin)) plot(MMinT,MMin,'bo'); end;
        for k=1:size(buysell3,1)
            ind=buysell3(k,1);
            if(buysell3(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],':h');
            else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:h');
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
    end
    if(i>(StartT+nS2UD2+2))
        %             jvec=xl:i-nS2UD2;
        plot(s12t_2,s2_2,'r','Linewidth',2);
        plot(s12t_2,s1_2,'b','Linewidth',2);
        plot(s1Line2(:,1),s1Line2(:,2),'k--',s2Line2(:,1),s2Line2(:,2),'k--')%,'Linewidth',2)
        plot([s1High2(1) s1LowT2],[s1High2(2) s1Low2],'b*',[s2Low2(1) s2HighT2],[s2Low2(2) s2High2],'r*')
        for k=bigs2
            ind=updown2(k,1);
            if(abs(updown2(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--*','Linewidth',2);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--*','Linewidth',2);
            end
        end
        for k=mults2
            ind=updown2(k,1);
            if(updown2(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--*','Linewidth',1);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--*','Linewidth',1);
            end
        end
        if(LastUD2==1) text(xl+100,l3(i)+0.18,'TREND UP','FontSize',14,'Color','b');
        elseif(LastUD2==0) text(xl+100,l3(i)+0.18,'TREND DOWN','FontSize',14,'Color','r');
        end
    end
    axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
    udp2=sum(GetProfit(updown2));
    title(['2 HOURLY CHART:   UD 2 = ' num2str(udp2) ';   Volume = ' num2str(NetVol)]);
    hold off;
    drawnow;
        % 3rd figure
        subplot(ax3)
        xl=max(1,i-PtsToPlot2+1);
        ivec=xl:i;
        plot(ivec,l1(ivec),'b',ivec,l2(ivec),'r',ivec,l3(ivec),'m','Linewidth',2)
        hold on
        if(NotStillClosed)
            PlotP1P2Lines(i,l1line,l2line,exl1,exl2,Hi2Day,Low1Day, ...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,stop1,stop2)        
        end
        for k=1:size(p1p2,1)
            ind=p1p2(k,1);
            if(p1p2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'LineWidth',2);
            elseif(p1p2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r','LineWidth',2);
            elseif(p1p2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'k-s');
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'g-s');
            end
        end
        for k=1:size(s1s2,1)
            ind=s1s2(k,1);
            if(s1s2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:o');
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:o');
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
        [a,b]=GetProfit(CombineProfs(p1p2,d1d2));
        pr1=sum(a);pr2=sum(b);
        title(['DAILY CHART:   E Trend Profit A = ' num2str(pr1) '; E Trend Profit B = ' num2str(pr2)]);
        ma2=min(max([l1 l2])+0.02,l3(i)+1);
        mi2=max(min([l1 l2])-0.02,l3(i)-1);
        axis([xl-1 i mi2 ma2])
        hold off;drawnow;
    %        keyboard
    %         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
    WriteExcelDataVol(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),vol(i),fout2);
    i
    td=GetSecs-ts;
    w=PauseLen-td;
    if(w>0) pause(w);  end;
end
[b1,b2,TrTimes]=GetProfit(buysell,1);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=max(size(buysell,1)-1,0)
% [b3,b4,TrTimes]=GetProfit(buysell2,1);
% bs1_2=sum(b3)
% bs2_2=sum(b4)
% NumTrades2=max(size(buysell2,1)-1,0)
[b5,b6,TrTimes]=GetProfit(buysell3,1);
bs1_3=sum(b5)
bs2_3=sum(b6)
NumTrades3=max(size(buysell3,1)-1,0)
[ud1,ud2,TrTimes]=GetProfit(updown);
up1=sum(ud1)
up2=sum(ud2)
NumTradesUD=max(length(bigs)-1,0)
[ud1_2,ud2_2,TrTimes]=GetProfit(updown2);
up1_2=sum(ud1_2)
up2_2=sum(ud2_2)
NumTradesUD2=max(length(bigs2)-1,0)
[ud1_3,ud2_3,TrTimes]=GetProfit(updown3);
up1_3=sum(ud1_3)
up2_3=sum(ud2_3)
NumTradesUD2=max(length(bigs3)-1,0)

[et1,et2,TrTimes]=GetProfit(x1x2);
ETrend1=sum(et1)
ETrend2=sum(et2)
NumTradesETrend=max(length(et1),0)

figure(2)
plot(1:i,l1,'g',1:i,l2,'g',1:i,l3,'g','Linewidth',2)
hold on
plot((1:j3-1),s3,'m',(1:jud-1),s2,'r',(1:jud-1),s1,'b','Linewidth',2);
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
% for k=1:size(buysell2,1)
%     ind=buysell2(k,1);
%     if(buysell2(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],':h');
%     else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:h');
%     end
% end
% Plot UPDOWN stuff
for k=bigs
    ind=updown(k,1);
    if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
    end
end
for k=mults
    ind=updown(k,1);
    if(updown(k,2)) plot([ind ind],[l2(ind) l3(ind)+0.125],'b','Linewidth',1);
    else plot([ind ind],[l3(ind)-0.125 l1(ind)],'r-s','Linewidth',1);
    end
end
for k=bigs3
    ind=updown3(k,1);
    if(abs(updown3(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:v','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:v','Linewidth',2);
    end
end
for k=mults3
    ind=updown3(k,1);
    if(updown3(k,2)) plot([ind ind],[l2(ind) l3(ind)+0.125],'b:v','Linewidth',1);
    else plot([ind ind],[l3(ind)-0.125 l1(ind)],'r:v','Linewidth',1);
    end
end
title(['BS = ' num2str(bs1) ';   UD = ' num2str(ud1) ';   UD 1 = ' num2str(ud1_3) ]);
hold off;

figure(3)
plot(1:i,l1,'g',1:i,l2,'g',1:i,l3,'g','Linewidth',2)
hold on
plot((1:j3-1),s3,'m',(1:jud2-1),s2_2,'r',(1:jud2-1),s1_2,'b','Linewidth',2);
for k=1:size(buysell3,1)
    ind=buysell3(k,1);
    if(buysell3(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
    else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
    end
end
for k=bigs2
    ind=updown2(k,1);
    if(abs(updown2(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- *','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- *','Linewidth',2);
    end
end
for k=mults2
    ind=updown2(k,1);
    if(updown2(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b-*','Linewidth',1);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r-*','Linewidth',1);
    end
end
title(['UD 2 = ' num2str(ud1_2) ';   Volume = ' num2str(NetVol)]);
hold off

if(~isempty(buysell))
    figure(4)
    bar([b1;b2]')
    legend('simple','multiple');
    title('Buy sell profit/loss')
end
if(~isempty(bigs))
    figure(5)
    bar(ud1)
    title('Up down profit/loss')
end
if(~isempty(bigs2))
    figure(6)
    bar(ud1_2)
    title('Up down 2 profit/loss')
end
figure(8)
ivec=1:i;
plot(ivec,l1(ivec),'b',ivec,l2(ivec),'r',ivec,l3(ivec),'m','Linewidth',2)
hold on;
for k=1:size(p1p2,1)
    ind=p1p2(k,1);
    if(p1p2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'LineWidth',2);
    elseif(p1p2(k,2)==0) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r','LineWidth',2);
    elseif(p1p2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b--s');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r--s');
    end
end
for k=1:size(s1s2,1)
    ind=s1s2(k,1);
    if(s1s2(k,2)==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:o');
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:o');
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
[a,b]=GetProfit(x1x2);
pr1=sum(a);pr2=sum(b);
title(['DAILY CHART:   E Trend Profit A = ' num2str(pr1) '; E Trend Profit B = ' num2str(pr2)]);
if(~isempty(et1))
    figure(7)
    bar([et1;et2]')
    title('E Trend profit/loss')
end