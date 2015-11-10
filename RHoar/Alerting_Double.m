% function[bs1,bs2,NumTrades] = TestSetting_Double(fin,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,nSUD3,EPUD3,RPUD3,RepTime)
% ,nSm2,EndPt2,RP2
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end

figure('Units','centimeters','Position',[1 1 30 10]);
ax2=subplot('Position',[0.6 0.1 0.35 0.825]);
ax1=subplot('Position',[0.05 0.1 0.35 0.825]);

buysound=wavread('buy.wav');
downsound=wavread('down.wav');
mid1sound=wavread('trend up.wav');
mid2sound=wavread('trend down.wav');
sellsound=wavread('sell.wav');
upsound=wavread('up.wav');
up1sound=wavread('up1.wav');
down1sound=wavread('down 2.wav');

% max length of time (in secs) to run
N=32400;

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

s=date;
fout=['BSlogdata_' s '.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];
% WriteLogDataPreamble(fout,['Testing data file: ' fin]);
if(~isfile(fout)) WriteLogDataPreamble(fout,s); end;
if(~isfile(fout2)) WriteExcelDataPreambleVol(fout2); end;
WriteParamsDynamic(fout,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,nSUD3,EPUD3,RPUD3);

% DIAGONAL parameters
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

% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
buysell=[];buysell2=[];buysell3=[];
NetVol=0;

% updown start variables
updown=[];mults=[];bigs=[];nUD=0;
updown2=[];mults2=[];bigs2=[];nUD2=0;
updown3=[];mults3=[];bigs3=[];nUD3=0;
for i=1:N;
    ts=GetSecs;
    l1(i)=L1;
    l2(i)=L2;
    l3(i)=L3;
    buy(i)=B;
    if(B==0) if(i>1) buy(i)=buy(i-1); end;end;
    sell(i)=S;
    if(S==0) if(i>1) sell(i)=sell(i-1); end;end;
    vol(i)=V;
    timez(i,:)=clock;
    t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if(t(i)>=TimeSecs([16,29,59]))
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
%         buysell2=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell2,fout,2);
        buysell3=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell3,fout,3);
        bigs=[bigs size(updown,1)+1];
        if(LastUD==1)
            WriteLogData(sell(i),timez(i,(4:6)),3,fout);
            updown=[updown;i -2 sell(i)];
        elseif(LastUD==0)
            WriteLogData(buy(i),timez(i,(4:6)),6,fout);
            updown=[updown;i -1 buy(i)];
        end
        bigs2=[bigs2 size(updown2,1)+1];
        if(LastUD2==1)
            WriteLogData(sell(i),timez(i,(4:6)),2,fout);
            updown2=[updown2;i -2 sell(i)];
        elseif(LastUD2==0)
            WriteLogData(buy(i),timez(i,(4:6)),5,fout);
            updown2=[updown2;i -1 buy(i)];
        end
        bigs3=[bigs3 size(updown3,1)+1];
        if(LastUD3==1)
            WriteLogData(sell(i),timez(i,(4:6)),11,fout);
            updown3=[updown3;i -2 sell(i)];
        elseif(LastUD3==0)
            WriteLogData(buy(i),timez(i,(4:6)),12,fout);
            updown3=[updown3;i -1 buy(i)];
        end
        WriteExcelDataVol(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),vol(i),fout2);
        break;
    end

    spread=l1(i)-l2(i);
    if(spread>0.05)
        % Buy sell line
        if(i>(StartT+nS2))
            if(i>(nSm+StartT)) is=(i-nSm):i;
            else
                n1s=nSm-i+1;
                is=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
            s3(j3)=mean(l3(is));
            % main loop
            if(j3>(StartT+3))
                % mid line test: Calc gradient
                g = gradient(s3(j3-2:j3));
                g3(j3) = g(2);
                % check if optima and if greater than previous
                a=g3(j3)*g3(j3-1);
                if(a<=0)
                    if(g3(j3)>g3(j3-1))
                        mi3=[mi3 j3];
                        mi3_s=[mi3_s s3(j3)];
                        if((s3(j3)<=LastMin)&(DownStart~=-1e9))
                            LastMin=s3(j3);
                            LastMinT=j3;
                            % Calc new max-min line and extrapolation
                            DownGrad=(LastMin-DownStart)/(LastMinT-DownStartT);
                            len=RP*spread;
                            [DownPt,DownT]=GetDiagonalPt(DownGrad,len,LastMin,LastMinT);
                            DownLine=[DownStartT,DownStart;LastMinT,LastMin;DownT,DownPt];
                        end
                        if(s3(j3)<=UpStart)
                            UpStart=s3(j3);
                            UpStartT=j3;
                        end
                    else
                        ma3=[ma3 j3];
                        ma3_s=[ma3_s s3(j3)];
                        if((s3(j3)>=LastMax)&(UpStart~=1e9))
                            LastMax=s3(j3);
                            LastMaxT=j3;
                            % Calc new max-min line and extrapolation
                            UpGrad=(LastMax-UpStart)/(LastMaxT-UpStartT);
                            len=RP*spread;
                            [UpPt,UpT]=GetDiagonalPt(UpGrad,len,LastMax,LastMaxT);
                            UpLine=[UpStartT,UpStart;LastMaxT,LastMax;UpT,UpPt];
                        end
                        if(s3(j3)>=DownStart)
                            DownStart=s3(j3);
                            DownStartT=j3;
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
            elseif(j3>(StartT+2))
                % if not enough vals to check if optima
                g = gradient(s3(j3-2:j3));
                g3(j3) = g(2);
                % DIAGONAL starts
                [UpStart,mt]=min(s3(StartT+1:j3));
                UpStartT=j3-2+mt;
                [DownStart,mt]=max(s3(StartT+1:j3));
                DownStartT=j3-2+mt;
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

            % main loop
            if(jud>(StartT+3))
                % L1 down diagonal: Check if at an optima
                d=diff(s1(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s1Line,s1Low,s1LowT,s1Ex,s1High]=IfMin(jud,s1(jud),ExL1*spread,s1Line,s1Low,s1LowT,s1Ex,s1High,d);
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
                    wavplay(upsound,8000);
                    s1Low=1e9;s1LowT=jud;
                    s1High=[0 -1e9];
                    s1Ex=1e9;
                    LastUD=1;
                    updown(nUD,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s2Line,s2Low,s2Ex,s2High,s2HighT]=IfMax(jud,s2(jud),ExL2*spread,s2Line,s2Low,s2Ex,s2High,s2HighT,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex)
                    nUD=nUD+1;
                    if(LastUD==0) mults=[mults nUD];
                    else bigs=[bigs nUD];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),3,fout);
                    wavplay(downsound,8000);
                    s2High=-1e9;s2HighT=jud;
                    s2Low=[0 1e9];
                    s2Ex=-1e9;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end
                % Crossed s3
%                 if(s2(jud)>=s3(jud))
%                     if(~buying)
%                         buysell2=[buysell2;i 1 buy(i)];
%                         buying=1;
%                         WriteLogData(buy(i),timez(i,(4:6)),8,fout);
%                         wavplay(buysound);
%                     end
%                 else buying=0;
%                 end
%                 if(s1(jud)<=s3(jud))
%                     if(~selling)
%                         WriteLogData(sell(i),timez(i,(4:6)),7,fout);
%                         buysell2=[buysell2;i 0 sell(i)];
%                         wavplay(sellsound);
%                         selling=1;
%                     end
%                 else selling=0;
%                 end
            elseif(jud>(StartT+2))
                % UPDOWN start variables
                LastUD=-1;
                s1Ex=1e9;
                s2Ex=-1e9;
                s1Low=1e9;s1LowT=jud;
                s2High=-1e9;s2HighT=jud;
                [x,mt]=max(s1(StartT+1:jud));
                s1High=[StartT+mt x];
                s1Line=[s1High;s1High;s1High];
                [x,mt]=min(s2(StartT+1:jud));
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

            % main loop
            if(jud2>(StartT+3))
                % L1 2nd down diagonal
                d=diff(s1_2(jud2-2:jud2));
                if(d(1)*d(2)<=0)
                    [s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2]=IfMin(jud2,s1_2(jud2),RPUD2*spread,s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2,d);
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
                    wavplay(mid1sound,44100);
                    s1Low2=1e9;s1LowT2=jud2;
                    s1High2=[0 -1e9];
                    s1Ex2=1e9;
                    LastUD2=1;
                    updown2(nUD2,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2_2(jud2-2:jud2));
                if(d(1)*d(2)<=0)
                    [s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2]=IfMax(jud2,s2_2(jud2),RPUD2*spread,s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex2)
                    nUD2=nUD2+1;
                    if(LastUD2==0) mults2=[mults2 nUD2];
                    else bigs2=[bigs2 nUD2];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),2,fout);
                    wavplay(mid2sound,44100);
                    s2High2=-1e9;s2HighT2=jud2;
                    s2Low2=[0 1e9];
                    s2Ex2=-1e9;
                    LastUD2=0;
                    updown2=[updown2;i 0 sell(i)];
                end
                % Crossed L3?
                if(s2_2(jud2)>=s3(jud2))
                    if(~buying2)
                        WriteLogData(buy(i),timez(i,(4:6)),10,fout);
                        buysell3=[buysell3;i 1 buy(i)];
                        wavplay(buysound);
                        buying2=1;
                    end
                    NetVol=NetVol-vol(jud2);
                else buying2=0;
                end
                if(s1_2(jud2)<=s3(jud2))
                    if(~selling2)
                        WriteLogData(sell(i),timez(i,(4:6)),9,fout);
                        buysell3=[buysell3;i 0 sell(i)];
                        wavplay(sellsound);
                        selling2=1;
                    end
                    NetVol=NetVol+vol(jud2);
                else selling2=0;
                end
            elseif(jud2>(StartT+2))
                % UPDOWN2 start variables
                LastUD2=-1;
                s1Ex2=1e9;
                s2Ex2=-1e9;
                s1Low2=1e9;s1LowT2=jud2;
                s2High2=-1e9;s2HighT2=jud2;
                [x,mt]=max(s1_2(StartT+1:jud2));
                s1High2=[StartT+mt x];
                s1Line2=[s1High2;s1High2;s1High2];
                [x,mt]=min(s2_2(StartT+1:jud2));
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

            % main loop
            if(jud3>(StartT+3))
                % L1 3nd down diagonal
                d=diff(s1_3(jud3-2:jud3));
                if(d(1)*d(2)<=0)
                    [s1Line3,s1Low3,s1LowT3,s1Ex3,s1High3]=IfMin(jud3,s1_3(jud3),RPUD3*spread,s1Line3,s1Low3,s1LowT3,s1Ex3,s1High3,d);
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
                    wavplay(up1sound,44100);
                    s1Low3=1e9;s1LowT3=jud3;
                    s1High3=[0 -1e9];
                    s1Ex3=1e9;
                    LastUD3=1;
                    updown3(nUD3,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2_3(jud3-2:jud3));
                if(d(1)*d(2)<=0)
                    [s2Line3,s2Low3,s2Ex3,s2High3,s2HighT3]=IfMax(jud3,s2_3(jud3),RPUD3*spread,s2Line3,s2Low3,s2Ex3,s2High3,s2HighT3,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex3)
                    nUD3=nUD3+1;
                    if(LastUD3==0) mults3=[mults3 nUD3];
                    else bigs3=[bigs3 nUD3];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),11,fout);
                    wavplay(down1sound,44100);
                    s2High3=-1e9;s2HighT3=jud3;
                    s2Low3=[0 1e9];
                    s2Ex3=-1e9;
                    LastUD3=0;
                    updown3=[updown3;i 0 sell(i)];
                end
            elseif(jud3>(StartT+2))
                % UPDOWN3 start variables
                LastUD3=-1;
                s1Ex3=1e9;
                s2Ex3=-1e9;
                s1Low3=1e9;s1LowT3=jud3;
                s2High3=-1e9;s2HighT3=jud3;
                [x,mt]=max(s1_3(StartT+1:jud3));
                s1High3=[StartT+mt x];
                s1Line3=[s1High3;s1High3;s1High3];
                [x,mt]=min(s2_3(StartT+1:jud3));
                s2Low3=[StartT+mt x];
                s2Line3=[s2Low3;s2Low3;s2Low3];
            end;
            % increment j
            jud3=jud3+1;
        end
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
        end
        StartT=i;
    end

    % graph the data
    subplot(ax1);
    xl=max(1,i-PtsToPlot+1);
    ivec=xl:i;
    plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
    hold on
    if(i>(StartT+nS2+2))
        jvec=xl:i-nS2;
        plot(jvec,s3(jvec),'m','Linewidth',2);
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
        %             TitStr=['UpLine = ' num2str(UpLine(1,2)) ' to ' num2str(UpLine(2,2)) '; DownLine = ' num2str(DownLine(1,2)) ' to ' num2str(DownLine(2,2))];
        %             title(TitStr);
    end
    if(i>(StartT+nS2L1+2))
        jvec=xl:i-nS2L1;
        plot(jvec,s2(jvec),'b','Linewidth',2);
        plot(jvec,s1(jvec),'r','Linewidth',2);
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
        if(LastUD==1) text(xl+100,l3(i)+0.18,'UP','FontSize',14,'Color','b');
        elseif(LastUD==0) text(xl+100,l3(i)+0.18,'DOWN','FontSize',14,'Color','r');
        end
    end
    if(i>(StartT+nS2UD3+2))
        % updown 3 stuff
        jvec=xl:i-nS2UD3;
        %             plot(jvec,s2_3(jvec),'b','Linewidth',2);
        %             plot(jvec,s1_3(jvec),'r','Linewidth',2);
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
        if(LastUD3==1) text(xl+100,l3(i)-0.18,'UP 1','FontSize',14,'Color','b');
        elseif(LastUD3==0) text(xl+100,l3(i)-0.18,'DOWN 2','FontSize',14,'Color','r');
        end
    end
    axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
    xlabel('Hourly chart')
    bsp=sum(GetProfit(buysell));
    udp=sum(GetProfit(updown)); udp3=sum(GetProfit(updown3));
    title(['BS = ' num2str(bsp) ';   UD = ' num2str(udp) ';   UD 1 = ' num2str(udp3) ]);
    hold off;
    drawnow;
    subplot(ax2);
    xl=max(1,i-PtsToPlot2+1);
    ivec=xl:i;
    plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
    hold on
    if(i>(StartT+nS2+2))
        jvec=xl:i-nS2;
        plot(jvec,s3(jvec),'m','Linewidth',2);
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
        %             TitStr=['UpLine = ' num2str(UpLine(1,2)) ' to ' num2str(UpLine(2,2)) '; DownLine = ' num2str(DownLine(1,2)) ' to ' num2str(DownLine(2,2))];
        %             title(TitStr);
    end
    if(i>(StartT+nS2UD2+2))
        jvec=xl:i-nS2UD2;
        plot(jvec,s2_2(jvec),'b','Linewidth',2);
        plot(jvec,s1_2(jvec),'r','Linewidth',2);
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
    xlabel('2 Hourly chart')
    udp2=sum(GetProfit(updown2));
    title(['UD 2 = ' num2str(udp2) ';   Volume = ' num2str(NetVol)]);
    hold off;
    drawnow;
    WriteExcelDataVol(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),vol(i),fout2);
    i
    td=GetSecs-ts;
    w=PauseLen-td;
    if(w>0) pause(w);  end;
end
% keyboard
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

figure(2)
plot(1:i,l1,'g',1:i,l2,'g',1:i,l3,'g','Linewidth',2)
hold on
plot((1:j3-1),s3,'m',(1:jud-1),s2,'b',(1:jud-1),s1,'r','Linewidth',2);
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
plot((1:j3-1),s3,'m',(1:jud2-1),s2_2,'b',(1:jud2-1),s1_2,'r','Linewidth',2);
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
if(~isempty(bigs3))
    figure(7)
    bar(ud1_3)
    title('Up down 3 profit/loss')
end