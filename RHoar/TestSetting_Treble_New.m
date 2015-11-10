function[bs1,bs2,NumTrades] = TestSetting_Treble(fin,nSm,EndPt,RP, ...
    nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,TimeLim,p1p2Lim,RepTime)

if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    cd RHoar/LogData/;
end

h=gcf;
set(h,'Units','centimeters','Position',[1 1 30 10]);
% ax1=subplot('Position',[0.05 0.575 0.35 0.35]);
ax2=subplot('Position',[0.05 0.1 0.35 0.825]);
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
cbuy=wavread('cover buy.wav');
csell=wavread('cover sell.wav');
mbuy=wavread('Mid Buy.wav');
msell=wavread('Mid Sell.wav');
mup=wavread('Mid Up.wav');
mdown=wavread('Mid Down.wav');
dbuy=wavread('Diagonal Buy.wav');
dsell=wavread('Diagonal Sell.wav');

s=date;
% fn=['logData_Test_DiagonalUD.mat'];
fout=['BSlogdata_Test_Treble.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];
WriteLogDataPreamble(fout,['Testing data file: ' fin]);
% if(~isfile(fout2)) WriteExcelDataPreambleVol(fout2,1); end;
WriteParamsDynamic(fout,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2);

% max length of time (in secs) to run
N=32400;

% Set DIAGONAL parameters
EndPtU=EndPt;
EndPtD=EndPtU;
RP=RP*100/0.1;

% UPDOWN parameters
nSmoothL1=nSUD;
nSmoothL2=nSmoothL1;
RPUD=RPUD*100/0.1;
RPUD2=RPUD2*100/0.1;
ExL1=RPUD;ExL2=RPUD;

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

PtsToPlot=3600;
PtsToPlot2=7200;
j3=1;jud=1;jud2=1;jud3=1;
NotStillClosed=1;
StartT=0;
PauseLen=1;

[tim,L1,L2,L3,B,S,V,T]=ReadLogDataVol(fin);
% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
buysell=[];buysell3=[];
NetVol=0;

% updown start variables
updown=[];mults=[];bigs=[];nUD=0;
updown2=[];mults2=[];bigs2=[];nUD2=0;

% p1p2 start values
p2Off=1; p1Off=1; m2Off=1; m1Off=1; prnow=0;
p1p2=[]; s1s2=[]; d1d2=[]; c1c2=[]; e1e2=[]; m1m2=[];
DiagL1.gr=-1e9;DiagL2.gr=1e9;DiagL1.midon=0;DiagL2.midon=0;
Low1Day=[0 1e9 0];Hi2Day=[0 -1e9 0];
HLinesL1=[];HLinesL2=[];DLinesL1=[];DLinesL2=[];
[l1line,l2line]=InitP1P2;

% T Start values
TU=[]; TUnder=0; TO=[]; TOver=0;

for i=1:length(L1)%N;
    ts=GetSecs;
    t_temp(i)=GetSecs;
    % Read data and write to file/variables
    % can delete this bit if all works
    l1(i)=L1(i);
    l2(i)=L2(i);
    l3(i)=L3(i);
    buy(i)=B(i);
    sell(i)=S(i);
    if(B(i)==0) if(i>1) buy(i)=buy(i-1); end;end;
    if(S(i)==0) if(i>1) sell(i)=sell(i-1); end;end;
    vol(i)=V(i);
    tvar(i)=T(i);
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
    %     tvar(i)=T;
    %     timez(i,:)=clock;
    % to here
    t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if(t(i)>=TimeSecs([16,29,59]))
        %        WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
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
        m1m2=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),m1m2,fout,[23 24]);
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

        % l1 line p1 to p2
        [l1line,lchange]=L1LineNew(l1(i),i,l1line,p1p2Lim);
        if(lchange)
            p1Off=1;
            m1Off=1;
        end
        
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
                    DLinesL1=[DLinesL1;l1line];
                    % Set low 1 stop values and low 1 day
                    svt=l1line.p1(1);
                    [sval svalt]=min(l1(svt:i));
                    HLinesL1=[HLinesL1;svalt+svt-1 sval sell(svalt+svt-1) 0];
%                     if(l1(i)<=sval)
%                         disp('problem here?')
%                        keyboard
%                     end
                    if(sval<Low1Day(2)) Low1Day=[svalt+svt-1 sval size(HLinesL1,1)]; end;
                    % Set diag values ** ISSUE IF 250 lim untriggered
                    if(l2line.grnew~=-1e9)
                        DiagL1.p1=l2line.p1new;
                        DiagL1.p2=l2line.p2new;
                        DiagL1.gr=l2line.grnew;
                        DiagL1.midon=1;
%                         DLinesL1=[DLinesL1;DiagL1];
                    else DiagL1.gr=-1e9;
                    end
                end
            elseif((~p1Off)&(l3(i)<=exl1))
                % Close out with a TrendSell
                d1d2=[d1d2;i -2 sell(i)];
                WriteLogData(sell(i),timez(i,(4:6)),17,fout);                
                wavplay(trend_sell,24050);%,'async');
                p1Off=1;
            end
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
%                     DLinesL2=[DLinesL2;DiagL2];
                else DiagL2.gr=1e9;
                end
            end
        else exDiag1=-1e9;
        end
        
        % if time lim and extrap is past l3, MidUp!
        mexl1=exl1-0.5*spread;
        if(td>TimeLim)
            if((l2(i)>=mexl1)&m1Off)
                m1m2=[m1m2;i 1 buy(i)];
                wavplay(mup,24050);
                WriteLogData(buy(i),timez(i,(4:6)),24,fout);
                m1Off=0;
            elseif((~m1Off)&(l2(i)<=mexl1))
                % Close out with a MidSell
                m1m2=[m1m2;i -2 sell(i)];
                WriteLogData(sell(i),timez(i,(4:6)),25,fout);                
                wavplay(msell,24050);%,'async');
                m1Off=1;
            end
        end

%         if(DiagL1.midon)
%             td=i-DiagL1.p1(1);
%             mexDiag1=DiagL1.p1(2)+DiagL1.gr*td+0.5*spread;
%             if(l1(i)<mexDiag1)
%                 m1m2=[m1m2;i 0 sell(i)];
%                 WriteLogData(sell(i),timez(i,(4:6)),25,fout);                
%                 wavplay(msell,24050);%,'async');
%                 DiagL1.midon=0;
%             end
%         end
        
        % test all horizontal lines
        for ind=1:size(HLinesL1,1)
            % if L1 not yet crossed below and it crosses: LOW1
            if((~HLinesL1(ind,4))&(l1(i)<=HLinesL1(ind,2)))
                if(ind==Low1Day(3))
                    wavplay(low1day,24050);
                    WriteLogData(sell(i),timez(i,(4:6)),19,fout);
                else
                    wavplay(low1,44100);%,'async');
                    WriteLogData(sell(i),timez(i,(4:6)),15,fout);
                end
                HLinesL1(ind,4)=1;
                s1s2=[s1s2;i 0 sell(i)];
            
            % elseif LOW1 active and L2 above: COVER BUY
            elseif(HLinesL1(ind,4)&(l2(i)>=HLinesL1(ind,2)))
                wavplay(cbuy,24050);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),22,fout);
                HLinesL1(ind,4)=0;
                c1c2=[c1c2;i 1 buy(i)];
            end
        end

        % l2 line p1 to p2
        [l2line,lchange]=L2LineNew(l2(i),i,l2line,p1p2Lim);
        if(lchange)
            p2Off=1;
            m2Off=1;
        end

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
                    DLinesL2=[DLinesL2;l2line];
%                     DLinesL2(end).active=0;
                    p2Off=0;
                    % Set hi2 stop values and hi 2 day
                    svt=l2line.p1(1);
                    [sval svalt]=max(l2(svt:i));
                    HLinesL2=[HLinesL2;svalt+svt-1 sval buy(svalt+svt-1) 0];
                    if(sval>Hi2Day(2)) Hi2Day=[svalt+svt-1 sval size(HLinesL2,1)]; end;
                    % Set diag values ** ISSUE IF p1p2lim untriggered
                    if(l1line.grnew~=1e9)
                        DiagL2.p1=l1line.p1new;
                        DiagL2.p2=l1line.p2new;
                        DiagL2.gr=l1line.grnew;
                        DiagL2.midon=1;
%                         DLinesL2=[DLinesL2;DiagL2];
                    else DiagL2.gr=1e9;
                    end
                end
            elseif((~p2Off)&(l3(i)>=exl2))
                % Close out with a TrendSell
                d1d2=[d1d2;i -1 buy(i)];
                wavplay(trend_buy,24050);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),18,fout);
                p2Off=1;                
            end
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
%                 DLinesL1=[DLinesL1;DiagL1];
%                 DLinesL1.active
                % Set diag values ** ISSUE IF 250 lim untriggered
                if(l2line.grnew~=-1e9)
                    DiagL1.p1=l2line.p1new;
                    DiagL1.p2=l2line.p2new;
                    DiagL1.gr=l2line.grnew;
%                     DLinesL1=[DLinesL1;DiagL1];
                else DiagL1.gr=-1e9;
                end
            end
        else exDiag2=1e9;
        end

        % if time lim and extrap is past l3, MidUp!
        mexl2=exl2+0.5*spread;
        if(td>TimeLim)
            if((l1(i)<=mexl2)&(m2Off))
                m1m2=[m1m2;i 0 sell(i)];
                wavplay(mdown,24050);%,'async');
                WriteLogData(sell(i),timez(i,(4:6)),23,fout);
                m2Off=0;
            elseif((~m2Off)&(l1(i)>=exl2))
                % Close out with a TrendSell
                m1m2=[m1m2;i -1 buy(i)];
                wavplay(mbuy,24050);%,'async');
                WriteLogData(buy(i),timez(i,(4:6)),18,fout);
                m2Off=1;                
            end
        end

         % test for trendbuy: diagonal stop on line 2
%         if(DiagL2.midon)
%             td=i-DiagL2.p1(1);
%             mexDiag2=DiagL2.p1(2)+DiagL2.gr*td-0.5*spread;
%             if(l2(i)>mexDiag2)
%                 m1m2=[m1m2;i 1 buy(i)];
%                 wavplay(mbuy,24050);%,'async');
%                 WriteLogData(buy(i),timez(i,(4:6)),26,fout);
%                 DiagL2.midon=0;
%             end
%         end

%         test all ETrend Diagonals
%         for ind=1:size(DLinesL2,1)
%             td=i-DLinesL2(ind).p1(1);
%             exl2=DLinesL2(ind).p1(2)+DLinesL2(ind).gr*td;
%             if the diagonal is active and L1 crosses it: ***
%             if((DLinesL2(ind).active))&(l1(i)<=exl2))
%                 e1e2=[e1e2;i 0 sell(i)];
%                 wavplay(e_down,24050);%,'async');
%                 WriteLogData(sell(i),timez(i,(4:6)),13,fout);
%                 DLinesL2.active=0;
% 
%             if its inactive and l2 goes above: ***        
%             elseif(l2(i)>=exl2)
%                 Generate a TrendSell
%                 e1e2=[e1e2;i -1 buy(i)];
%                 d1d2=[d1d2;i -1 buy(i)];
%                 wavplay(trend_buy,24050);%,'async');
%                 WriteLogData(buy(i),timez(i,(4:6)),18,fout);
%                 DLinesL2.active=1;                
%             end
%         end
        
        % test all horizontal lines
        for ind=1:size(HLinesL2,1)
            % if L2 not yet crossed below and it crosses: HI2
            if((~HLinesL2(ind,4))&(l2(i)>=HLinesL2(ind,2)))
                if(ind==Hi2Day(3))
                    wavplay(hi2day,24050);
                    WriteLogData(buy(i),timez(i,(4:6)),20,fout);
                else
                    wavplay(hi2,44100);%,'async');
                    WriteLogData(buy(i),timez(i,(4:6)),16,fout);
                end
                HLinesL2(ind,4)=1;
                s1s2=[s1s2;i 1 buy(i)];
            
            % elseif HI2 active and L1 below: COVER SELL
            elseif(HLinesL2(ind,4)&(l1(i)<=HLinesL2(ind,2)))
                wavplay(csell,24050);%,'async');
                WriteLogData(sell(i),timez(i,(4:6)),21,fout);
                HLinesL2(ind,4)=0;
                c1c2=[c1c2;i 0 sell(i)];
            end
        end

        % My Stop
%         x1x2=CombineProfs(p1p2,d1d2);
        if((~isempty(m1m2))&(m1m2(end,2)>=0))
            pr=m1m2(end,3);
            if(m1m2(end,2)) prnow=sell(i)-pr;
            else  prnow=pr-buy(i);
            end
            if(i>m1m2(end,1))
                if(prnow>maxpr) maxpr=prnow; end;
                if(0)%prnow<=-5)
                    if(m1m2(end,2)) m1m2=[m1m2;i -2 sell(i)];
                    else m1m2=[m1m2;i -1 buy(i)];
                    end
                    %CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),p1p2,fout,[13 14]);
                elseif((maxpr>10)&((maxpr-prnow)>4))
                    if(m1m2(end,2)) 
                        m1m2=[m1m2;i -2 sell(i)];
                    else 
                        m1m2=[m1m2;i -1 buy(i)];
                    end
                end
            else maxpr=prnow;
            end
            oldpr=prnow;
        end

        % New thing for the T variable
        if((tvar(i)<l2(i))&(~TUnder)) 
            TU=[TU;i 0];
            TUnder=1;
        elseif((tvar(i)>=l2(i))&(TUnder)) 
            TU(end,2)=i;
            TUnder=0;
        end
        if((tvar(i)>l1(i))&(~TOver)) 
            TO=[TO;i 0];
            TOver=1;
        elseif((tvar(i)<=l1(i))&(TOver)) 
            TO(end,2)=i;
            TOver=0;
        end
        
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            % Close stuff
            buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
            buysell3=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell3,fout,3);
            [updown,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown,fout,[3 6]);
            bigs=[bigs nb];
            [updown2,nb]=CloseOutNew(i,sell(i),buy(i),timez(i,(4:6)),updown2,fout,[2 5]);
            bigs2=[bigs2 nb];
        end
        StartT=i;
    end

    % graph the data
    if(mod(i,RepTime)==0)
        
        % 2 Hourly plot
        subplot(ax2);
        xl=max(1,i-PtsToPlot2+1);
        ma=min(max([l1(xl:i) l2(xl:i)])+0.02,l1(i)+0.5);
        mi=max(min([l1(xl:i) l2(xl:i)])-0.02,l2(i)-0.5);
        ivec=xl:i;
        plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
        hold on
        if(i>(StartT+nS2+2))
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
            if(LastUD==1) text(xl+100,ma-0.1,'UP','FontSize',14,'Color','b');
            elseif(LastUD==0) text(xl+100,ma-0.1,'DOWN','FontSize',14,'Color','r');
            end
        end
        if(i>(StartT+nS2UD2+2))
%             plot(s12t_2,s2_2,'r','Linewidth',2);
%             plot(s12t_2,s1_2,'b','Linewidth',2);
%             plot(s1Line2(:,1),s1Line2(:,2),'k--',s2Line2(:,1),s2Line2(:,2),'k--')%,'Linewidth',2)
%             plot([s1High2(1) s1LowT2],[s1High2(2) s1Low2],'b*',[s2Low2(1) s2HighT2],[s2Low2(2) s2High2],'r*')
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
            if(LastUD2==1) text(xl+100,mi+0.05,'TREND UP','FontSize',14,'Color','b');
            elseif(LastUD2==0) text(xl+100,mi+0.05,'TREND DOWN','FontSize',14,'Color','r');
            end
        end
        for k=1:size(buysell3,1)
            ind=buysell3(k,1);
            if(buysell3(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],':h');
            else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:h');
            end
        end
        
        % Plot t stuff
        plotTvar(tvar,TU,TO,mi,0)
        its=(max(1,i-nS2)):i;
        plot(its,tvar(its),'y','LineWidth',2)

        axis([xl-1 i mi ma])
        bsp=sum(GetProfit(buysell));
        udp=sum(GetProfit(updown)); 
        udp2=sum(GetProfit(updown2));
        title(['2 HOURLY CHART:   BS = ' num2str(bsp) ';   UD = ' num2str(udp) ...
            '  UD 2 = ' num2str(udp2) ';   Volume = ' num2str(NetVol)]);
        hold off;
        drawnow;

        % 3rd figure
        subplot(ax3)
        ma2=min(max([l1(xl:i) l2(xl:i)])+0.02,l3(i)+1);
        mi2=max(min([l1(xl:i) l2(xl:i)])-0.02,l3(i)-1);
        nup=ma2+abs(0.02*(ma2-mi2));
        xl=max(1,i-PtsToPlot2+1);
        ivec=xl:i;
        plot(ivec,l1(ivec),'b',ivec,l2(ivec),'r',ivec,l3(ivec),'m','Linewidth',2)
        hold on
        if(NotStillClosed)
            PlotP1P2Lines(i,l1line,l2line,exl1,exl2,Hi2Day,Low1Day, ...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,0.5*spread)        
        end
        for k=1:size(p1p2,1)
            ind=p1p2(k,1);
            if(ind>=(xl-1))
                if(p1p2(k,2)==1)
                    plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'LineWidth',2);
                    text(ind-50, nup,num2str(p1p2(k,3)),'Color','b');
                elseif(p1p2(k,2)==0) 
                    plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r','LineWidth',2);
                    text(ind-50, nup,num2str(p1p2(k,3)),'Color','r');
                elseif(p1p2(k,2)==-1)
                    plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'k-s');
                    text(ind-50, nup,num2str(p1p2(k,3)),'Color','b');
                else
                    plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'g-s');
                    text(ind-50, nup,num2str(p1p2(k,3)),'Color','r');
                end
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
            elseif(m1m2(k,2)==-1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b:p','MarkerFaceColor','b','LineWidth',2);
            else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:p','MarkerFaceColor','r','LineWidth',2);
            end
        end
        [a,b]=GetProfit(CombineProfs(p1p2,d1d2));
        pr1=sum(a);pr2=sum(b);
        [mp1,mp2]=GetProfit(m1m2);
        mp1=sum(mp1)
        mp2=sum(mp2)
        xlabel(['Current = ' num2str(prnow) ';  E Trend A = ' num2str(pr1) '; Mid Up A = ' num2str(mp1) '   ; Mid Up B = ' num2str(mp2)]);
        axis([xl-1 i mi2 ma2])
        hold off;drawnow;
        %         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
    end
    %    WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
    %         i
    %         td=GetSecs-ts;
    %         w=PauseLen-td;
    %         if(w>0) pause(w);  end;
end
save temp p1p2 d1d2 x1x2 s1s2 m1m2 c1c2
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
[ud1_2,ud2_2,TrTimes]=GetProfit(updown2);
up1_2=sum(ud1_2)
up2_2=sum(ud2_2)
NumTradesUD2=max(length(bigs2)-1,0)

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
title(['BS = ' num2str(bs1) ';   UD = ' num2str(ud1) ]);%';   UD 2 = ' num2str(ud1_2) ]);
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
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r:s','MarkerFaceColor','r','LineWidth',2);
    end
end
PlotP1P2Lines(i,l1line,l2line,exl1,exl2,Hi2Day,Low1Day, ...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,0.5*spread)
[a,b]=GetProfit(x1x2);
pr1=sum(a);pr2=sum(b);
title(['DAILY CHART:   E Trend Profit A = ' num2str(pr1) '; E Trend Profit B = ' num2str(pr2)]);
ma2=max([l1 l2])+0.02;mi2=min([l1 l2])-0.02;
axis([1 i mi2 ma2])
if(~isempty(et1))
    figure(7)
    bar([et1;et2]')
    title('E Trend profit/loss')
end
save([fin(1:end-4) '.mat'])