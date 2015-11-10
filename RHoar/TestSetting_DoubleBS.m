function[bs1,bs2,NumTrades] = TestSetting_DoubleBS(fin,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,RepTime)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end

buysound=wavread('buy.wav');
downsound=wavread('down 2.wav');
mid1sound=wavread('trend up.wav');
mid2sound=wavread('trend down.wav');
sellsound=wavread('sell.wav');
upsound=wavread('up1.wav');

s=date;
% fn=['logData_Test_DiagonalUD.mat'];
fout=['BSlogdata_Test_Double.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
% fout2=['exceldata_' s '.txt'];
WriteLogDataPreamble(fout,['Testing data file: ' fin]);
% if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
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
ExL1=RPUD;
ExL2=RPUD;

% ensure nSmooths are even
nS2=ceil(nSm/2);
nSm=2*nS2;
nS2L1=ceil(nSmoothL1/2);
nSmoothL1=2*nS2L1;
nS2L2=ceil(nSmoothL2/2);
nSmoothL2=2*nS2L2;
nS2UD2=ceil(nSUD2/2);
nSUD2=2*nS2UD2;

PtsToPlot=3600;
j3=1;jud=1;jud2=1;
buysell=[];
NotStillClosed=1;
StartT=0;
PauseLen=1;

[tim,L1,L2,L3,B,S]=ReadLogData(fin);
% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
% updown start variables
updown=[];mults=[];bigs=[];nUD=0;
updown2=[];mults2=[];bigs2=[];nUD2=0;
for i=1:length(L1)%N;
    ts=GetSecs;
    % Read data and write to file/variables
    % can delete this bit if all works
    l1(i)=L1(i);
    l2(i)=L2(i);
    l3(i)=L3(i);
    buy(i)=B(i);
    sell(i)=S(i);
    if(B==0) if(i>1) buy(i)=buy(i-1); end;end;
    if(S==0) if(i>1) sell(i)=sell(i-1); end;end;
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
        %         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        %        WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    spread=l1(i)-l2(i);
    if(spread>0.05)
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
                    wavplay(upsound);
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
                    wavplay(downsound);
                    s2High=-1e9;s2HighT=jud;
                    s2Low=[0 1e9];
                    s2Ex=-1e9;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end
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
                    wavplay(mid1sound);
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
                    wavplay(mid2sound);
                    s2High2=-1e9;s2HighT2=jud2;
                    s2Low2=[0 1e9];
                    s2Ex2=-1e9;
                    LastUD2=0;
                    updown2=[updown2;i 0 sell(i)];
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
            end;
            % increment j
            j3=j3+1;
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
            title(TitStr);
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
        if(i>(StartT+nS2UD2+2))
%             jvec=ivec-nS2UD2;
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
            if(LastUD2==1) text(xl+100,l3(i)-0.2,'UP2','FontSize',14,'Color','b');
            elseif(LastUD2==0) text(xl+100,l3(i)-0.2,'DOWN2','FontSize',14,'Color','r');
            end
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
save temp updown2 -append
[b1,b2,TrTimes]=GetProfit(buysell,1);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=max(size(buysell,1)-1,0)
[ud1,ud2,TrTimes]=GetProfit(updown);
up1=sum(ud1)
up2=sum(ud2)
NumTradesUD=max(length(bigs)-1,0)
[ud1_2,ud2_2,TrTimes]=GetProfit(updown2);
up1_2=sum(ud1_2)
up2_2=sum(ud2_2)
NumTradesUD2=max(length(bigs2)-1,0)

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
% Plot UPDOWN stuff
for k=bigs
    ind=updown(k,1);
    if(abs(updown(k,2))==1) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'b- s','Linewidth',2);
    else plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r- s','Linewidth',2);
    end
end
for k=mults
    ind=updown(k,1);
    if(updown(k,2)) plot([ind ind],[l2(ind) l3(ind)+0.125],'b-s','Linewidth',1);
    else plot([ind ind],[l3(ind)-0.125 l1(ind)],'r-s','Linewidth',1);
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
if(~isempty(bigs2))
    figure(5)
    bar(ud1_2)
    title('Up down 2 profit/loss')
end