function[bs1,bs2,NumTrades] = TestSetting_DoubleNew(fin,nSm,EndPt,RP,nSm2,EndPt2,RP2,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2,RepTime)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end

figure('Units','centimeters','Position',[1 10 30 10]);
ax1=subplot('Position',[0.6 0.1 0.35 0.825]);
title('Hourly chart')
ax2=subplot('Position',[0.05 0.1 0.35 0.825]);
title('2 Hourly chart')

buysound=wavread('buy.wav');
downsound=wavread('down.wav');
mid1sound=wavread('trend up.wav');
mid2sound=wavread('trend down.wav');
sellsound=wavread('sell.wav');
upsound=wavread('up.wav');

% s=date;
s=fin(11:21);
% fn=['logData_Test_DiagonalUD.mat'];
fout=['BSlogdata_Test_Double.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
% fout2=['exceldata_' s '.txt'];
WriteLogDataPreamble(fout,['Testing data file: ' fin]);
% if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParamsDynamic(fout,nSm,EndPt,RP,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2);

% max length of time (in secs) to run
N=32400;

% ensure nSmooths are even
nS2=ceil(nSm/2);
nSm=2*nS2;
nS22=ceil(nSm2/2);
nSm2=2*nS22;
nS2L1=ceil(nSUD/2);
nSUD=2*nS2L1;
nS2UD2=ceil(nSUD2/2);
nSUD2=2*nS2UD2;

PtsToPlot=3600;
PtsToPlot2=7200;
j3=1;jud=1;jud2=1;
NotStillClosed=1;
StartT=0;
PauseLen=1;

[tim,L1,L2,L3,B,S]=ReadLogData(fin);
% DIAGONAL start variables
ma3_s=[];mi3_s=[];ma3=[];mi3=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];
buysell=[];buysell2=[];buysell3=[];

% updown start variables
updown=[];mults=[];bigs=[];nUD=0;
updown2=[];mults2=[];bigs2=[];nUD2=0;

% Initialise lines
[l1,l2,l3,s1,s2,s3,s1_2,s2_2,s3_2,UpLine,DownLine,UpLine2,DownLine2,s2Line,s1Line,s2Line2,s1Line2,LastUD,LastUD2,ex] ...
    =InitialiseDouble(s,0,nSm,EndPt,RP,nSm2,EndPt2,RP2,nSUD,EPUD,RPUD,nSUD2,EPUD2,RPUD2);
% Scale Range Props
RP=RP*100/0.1;
RP2=RP2*100/0.1;
RPUD=RPUD*100/0.1;
RPUD2=RPUD2*100/0.1;
if(ex>0)
    % set the is etc. These should be eg is=-nSm:0, but with ex added ie
    % the last one must be eg l3(ex) as this is the last added ie ...
    is=(ex-nSm):ex; iL1s=(ex-nSUD):ex; iUD2=(ex-nSUD2):ex;
    % take off the differences. May need something fancier here.
    d1=l1(end)-L1(1);
    d2=l2(end)-L2(1);
    d3=l3(end)-L3(1);
    l1=l1-d1; l2=l2-d2; l3=l3-d3;
    s1=s1-d1; s2=s2-d2; s3=s3-d3; s1_2=s1_2-d1; s2_2=s2_2-d2; s3_2=s3_2-d3;
    i9s=find(abs(UpLine(:,1))~=1e9); UpLine(i9s,1)=UpLine(i9s,1)-d3; 
    i9s=find(abs(UpLine2(:,1))~=1e9); UpLine2(i9s,1)=UpLine2(i9s,1)-d3;
    i9s=find(abs(DownLine(:,1))~=1e9); DownLine(i9s,1)=DownLine(i9s,1)-d3; 
    i9s=find(abs(DownLine2(:,1))~=1e9); DownLine2(i9s,1)=DownLine2(i9s,1)-d3;
    i9s=find(abs(s1Line(:,1))~=1e9); s1Line(i9s,1)=s1Line(i9s,1)-d1; 
    i9s=find(abs(s1Line2(:,1))~=1e9); s1Line2(i9s,1)=s1Line2(i9s,1)-d1;
    i9s=find(abs(s2Line(:,1))~=1e9); s2Line(i9s,1)=s2Line(i9s,1)-d2; 
    i9s=find(abs(s2Line2(:,1))~=1e9); s2Line2(i9s,1)=s2Line2(i9s,1)-d2;

    % buy sell 1st line
    UpStart=UpLine(1,1); UpStartT=UpLine(1,2);
    DownStart=DownLine(1,1); DownStartT=DownLine(1,2);
    DownPt=DownLine(3,1);UpPt=UpLine(3,1);
    LastMin=DownLine(2,1);LastMinT=DownLine(2,2);
    LastMax=UpLine(2,1);LastMaxT=UpLine(2,2);
    g=gradient(s3(end-2:end)); g3=[0 0 g(2)]; 
    buying=0;selling=0;
    % buy sell 2nd line
    UpStart2=UpLine2(1,1); UpStartT2=UpLine2(1,2);
    DownStart2=DownLine2(1,1); DownStartT2=DownLine2(1,2);
    DownPt2=DownLine2(3,1);UpPt2=UpLine2(3,1);
    LastMin2=DownLine2(2,1);LastMinT2=DownLine2(2,2);
    LastMax2=UpLine2(2,1);LastMaxT2=UpLine2(2,2);
    g=gradient(s3_2(end-2:end)); g32=[0 0 g(2)]; 
    buying2=0;selling2=0;
    % updown 1st line
    s1Ex=s1Line(3,1); s2Ex=s2Line(3,1);
    s1Low=s1Line(2,1);s1LowT=s1Line(2,2);
    s2High=s2Line(2,1);s2HighT=s2Line(2,2);
    s1High=s1Line(1,[2 1]);s2Low=s2Line(1,[2 1]); % LastUD=-1;
    % updown 2nd line
    s1Ex2=s1Line2(3,1); s2Ex2=s2Line2(3,1);
    s1Low2=s1Line2(2,1);s1LowT2=s1Line2(2,2);
    s2High2=s2Line2(2,1);s2HighT2=s2Line2(2,2);
    s1High2=s1Line2(1,[2 1]);s2Low2=s2Line2(1,[2 1]); % LastUD2=-1;
    % reset lines
    if(sum(abs(UpLine(:,1)))>1e8) UpLine=[L3(1) 1;L3(1) 1;L3(1) 1]; 
    elseif(UpLine(1,2)>UpLine(2,2)) UpLine(1,:)=UpLine(2,:); 
    end; UpLine=UpLine(:,[2 1]);
    if(sum(abs(UpLine2(:,1)))>1e8) UpLine2=[L3(1) 1;L3(1) 1;L3(1) 1]; 
    elseif(UpLine2(1,2)>UpLine2(2,2)) UpLine2(1,:)=UpLine2(2,:); 
    end; UpLine2=UpLine2(:,[2 1]);
    if(sum(abs(DownLine(:,1)))>1e8) DownLine=[L3(1) 1;L3(1) 1;L3(1) 1]; 
    elseif(DownLine(1,2)>DownLine(2,2)) DownLine(1,:)=DownLine(2,:); 
    end; DownLine=DownLine(:,[2 1]);
    if(sum(abs(DownLine2(:,1)))>1e8) DownLine2=[L3(1) 1;L3(1) 1;L3(1) 1]; 
    elseif(DownLine2(1,2)>DownLine2(2,2)) DownLine2(1,:)=DownLine2(2,:); 
    end; DownLine2=DownLine2(:,[2 1]);
    if(sum(abs(s1Line(:,1)))>1e8) s1Line=[L1(1) 1;L1(1) 1;L1(1) 1]; 
    elseif(s1Line(1,2)>s1Line(2,2)) s1Line1(1,:)=s1Line(2,:); 
    end; s1Line=s1Line(:,[2 1]);
    
    if(sum(abs(s1Line2(:,1)))>1e8) s1Line2=[L1(1) 1;L1(1) 1;L1(1) 1];
    elseif(s1Line2(1,2)>s1Line2(2,2)) s1Line2(1,:)=s1Line2(1,:); 
    end; s1Line2=s1Line2(:,[2 1]);
    
    if(sum(abs(s2Line(:,1)))>1e8) s2Line=[L2(1) 1;L2(1) 1;L2(1) 1]; 
    elseif(s2Line(1,2)>s2Line(2,2)) s2Line(1,:)=s2Line(2,:); 
    end; s2Line=s2Line(:,[2 1]);
    
    if(sum(abs(s2Line2(:,1)))>1e8) s2Line2=[L2(1) 1;L2(1) 1;L2(1) 1]; 
    elseif(s2Line2(1,2)>s2Line2(2,2)) s2Line2(1,:)=s2Line2(2,:); 
    end; s2Line2=s2Line2(:,[2 1]);
end
j3=length(s3)+1; j32=length(s3_2)+1; jud2=length(s1_2)+1;jud=length(s1)+1;  

for i=1:length(L1)%N;
    ts=GetSecs;
    % Read data and write to file/variables
    % can delete this bit if all works
    iex=i+ex;
    l1(iex)=L1(i);
    l2(iex)=L2(i);
    l3(iex)=L3(i);
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
        buysell2=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell2,fout,2);
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
        %         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        %        WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    spread=l1(iex)-l2(iex);
    if(spread>0.05)
        % Buy sell line
        if(iex>(StartT+nS2))
            is=[is(2:end) iex];
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
                        mi3=[mi3 j3-ex];
                        mi3_s=[mi3_s s3(j3)];
                        if((s3(j3)<=LastMin)&(DownStart~=-1e9))
                            LastMin=s3(j3);
                            LastMinT=j3-ex;
                            % Calc new max-min line and extrapolation
                            DownGrad=(LastMin-DownStart)/(LastMinT-DownStartT);
                            len=RP*spread;
                            [DownPt,DownT]=GetDiagonalPt(DownGrad,len,LastMin,LastMinT);
                            DownLine=[DownStartT,DownStart;LastMinT,LastMin;DownT,DownPt];
                        end
                        if(s3(j3)<=UpStart)
                            UpStart=s3(j3);
                            UpStartT=j3-ex;
                        end
                    else
                        ma3=[ma3 j3-ex];
                        ma3_s=[ma3_s s3(j3)];
                        if((s3(j3)>=LastMax)&(UpStart~=1e9))
                            LastMax=s3(j3);
                            LastMaxT=j3-ex;
                            % Calc new max-min line and extrapolation
                            UpGrad=(LastMax-UpStart)/(LastMaxT-UpStartT);
                            len=RP*spread;
                            [UpPt,UpT]=GetDiagonalPt(UpGrad,len,LastMax,LastMaxT);
                            UpLine=[UpStartT,UpStart;LastMaxT,LastMax;UpT,UpPt];
                        end
                        if(s3(j3)>=DownStart)
                            DownStart=s3(j3);
                            DownStartT=j3-ex;
                        end
                    end;
                end

                % check if TP triggers buy alert
                % Get end indices to mean over
                if((iex)>(EndPt+StartT)) ks=((iex)-EndPt):(iex);
                else
                    n1s=EndPt-iex+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:iex];
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
                % if not enough vals to check if optima set start vals
                g = gradient(s3(j3-2:j3)); g3(j3) = g(2);
                [UpStart,mt]=min(s3(StartT+1:j3));
                [DownStart,mt]=max(s3(StartT+1:j3));
                DownStartT=j3-2+mt; UpStartT=j3-2+mt;
                DownLine=[DownStartT,DownStart;DownStartT,DownStart;DownStartT,DownStart];
                UpLine=[UpStartT,UpStart;UpStartT,UpStart;UpStartT,UpStart];
                LastMin=1e9; LastMax=-1e9;
                DownPt=1e9; UpPt=-1e9;
                buying=0;selling=0; buying2=0;selling2=0;
            end;
            % increment j
            j3=j3+1;
        else is=[ones(1,(nSm-iex+1))*(StartT+1) StartT+1:iex];
        end
        % Up down line
        if(iex>(StartT+nS2L1))
            % Calculate smoothed values
            iL1s=[iL1s(2:end) iex];
            s1(jud)=mean(l1(iL1s));
            s2(jud)=mean(l2(iL1s));

            % main loop
            if(jud>(StartT+3))
                % L1 down diagonal: Check if at an optima
                d=diff(s1(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s1Line,s1Low,s1LowT,s1Ex,s1High]=IfMin(jud-ex,s1(jud),RPUD*spread,s1Line,s1Low,s1LowT,s1Ex,s1High,d);
                end
                % Get end indices to mean over
                if(iex>(EPUD+StartT)) ks=(iex-EPUD):iex;
                else
                    n1s=EPUD-iex+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:iex];
                end
                % Check if up
                if(mean(l2(ks))>s1Ex)
                    nUD=nUD+1;
                    if(LastUD==1) mults=[mults nUD];
                    else bigs=[bigs nUD];
                    end
                    WriteLogData(buy(i),timez(i,(4:6)),6,fout);
                    wavplay(upsound,44100);
                    s1Low=1e9;s1LowT=jud;
                    s1High=[0 -1e9];
                    s1Ex=1e9;
                    LastUD=1;
                    updown(nUD,:)=[i 1 buy(i)];
                end
                % Calc l2 up diagonal: Check if at an optima
                d=diff(s2(jud-2:jud));
                if(d(1)*d(2)<=0)
                    [s2Line,s2Low,s2Ex,s2High,s2HighT]=IfMax(jud-ex,s2(jud),RPUD*spread,s2Line,s2Low,s2Ex,s2High,s2HighT,d);
                end
                % Check if down
                if(mean(l1(ks))<s2Ex)
                    nUD=nUD+1;
                    if(LastUD==0) mults=[mults nUD];
                    else bigs=[bigs nUD];
                    end
                    WriteLogData(sell(i),timez(i,(4:6)),3,fout);
                    wavplay(downsound,44100);
                    s2High=-1e9;s2HighT=jud;
                    s2Low=[0 1e9];
                    s2Ex=-1e9;
                    LastUD=0;
                    updown=[updown;i 0 sell(i)];
                end
                % Crossed s3
                if(s2(jud)>=s3(jud))
                    if(~buying)
                        WriteLogData(buy(i),timez(i,(4:6)),8,fout);
                        buysell2=[buysell2;i 1 buy(i)];
                        wavplay(buysound);
                        buying=1;
                    end
                else buying=0;
                end
                if(s1(jud)<=s3(jud))
                    if(~selling)
                        WriteLogData(sell(i),timez(i,(4:6)),7,fout);
                        buysell2=[buysell2;i 0 sell(i)];
                        wavplay(sellsound);
                        selling=1;
                    end
                else selling=0;
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
        else iL1s=[ones(1,(nSUD-iex+1))*(StartT+1) StartT+1:iex];
        end

        % up down line 2
        if(iex>(StartT+nS2UD2))
            % Calculate smoothed values
            iUD2=[iUD2(2:end) iex];
            s1_2(jud2)=mean(l1(iUD2));
            s2_2(jud2)=mean(l2(iUD2));

            % main loop
            if(jud2>(StartT+3))
                % L1 2nd down diagonal
                d=diff(s1_2(jud2-2:jud2));
                if(d(1)*d(2)<=0)
                    [s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2]=IfMin(jud2-ex,s1_2(jud2),RPUD2*spread,s1Line2,s1Low2,s1LowT2,s1Ex2,s1High2,d);
                end
                % Get end indices to mean over
                if(iex>(EPUD2+StartT)) ks=(iex-EPUD2):iex;
                else
                    n1s=EPUD2-iex+1;
                    ks=[ones(1,n1s)*(StartT+1) StartT+1:iex];
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
                    [s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2]=IfMax(jud2-ex,s2_2(jud2),RPUD2*spread,s2Line2,s2Low2,s2Ex2,s2High2,s2HighT2,d);
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
                else buying2=0;
                end
                if(s1_2(jud2)<=s3(jud2))
                    if(~selling2)
                        WriteLogData(sell(i),timez(i,(4:6)),9,fout);
                        buysell3=[buysell3;i 0 sell(i)];
                        wavplay(sellsound);
                        selling2=1;
                    end
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
        else iUD2=[ones(1,(nSUD2-iex+1))*(StartT+1) StartT+1:iex];
        end
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
            %             CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
            save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        end
        StartT=iex;
%         ex=0;
    end

    % graph the data
    if(mod(i-1,RepTime)==0)
        subplot(ax1);
        xl=max(1,iex-PtsToPlot+1); ivec=xl:iex;
        plot(ivec-ex,l1(ivec),'g',ivec-ex,l2(ivec),'g',ivec-ex,l3(ivec),'g','Linewidth',2)
        hold on
        if(iex>(StartT+nS2+2))
            jvec=xl:(j3-1);%i-nS2;
            plot(jvec-ex,s3(jvec),'m','Linewidth',2);
            if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
            if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
            if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
            if(length(MMin)) plot(MMinT,MMin,'bo'); end;
            for k=1:size(buysell,1)
                ind=buysell(k,1);v=l3(ind+ex);
                if(buysell(k,2)) plot([ind ind],[v-0.25 v+0.25]);
                else  plot([ind ind],[v-0.25 v+0.25],'r');
                end
            end
            for k=1:size(buysell2,1)
                ind=buysell2(k,1);v=l3(ind+ex);
                if(buysell2(k,2)) plot([ind ind],[v-0.25 v+0.25],':h');
                else  plot([ind ind],[v-0.25 v+0.25],'r:h');
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
            if(LastMax~=-1e9) plot(LastMaxT,LastMax,'ro','MarkerFaceColor','r');end
        end
        if(iex>(StartT+nS2L1+2))
            jvec=xl:(jud-1);%i-nS2L1;
            plot(jvec-ex,s2(jvec),'b','Linewidth',2);
            plot(jvec-ex,s1(jvec),'r','Linewidth',2);
            % Plot UPDOWN stuff
            plot(s1Line(:,1),s1Line(:,2),'k')%,'Linewidth',2)
            plot([s1Line(end,1) i],s1Line([end end],2),'k')%,'Linewidth',2)
            plot(s2Line(:,1),s2Line(:,2),'k')%,'Linewidth',2)
            plot([s2Line(end,1) i],s2Line([end end],2),'k')%,'Linewidth',2)
            plot([s1High(1) s1LowT],[s1High(2) s1Low],'bs')
            plot([s2Low(1) s2HighT],[s2Low(2) s2High],'rs')
            for k=bigs
                ind=updown(k,1);v=l3(ind+ex);
                if(abs(updown(k,2))==1) plot([ind ind],[v-0.25 v+0.25],'b- s','Linewidth',2);
                else plot([ind ind],[v-0.25 v+0.25],'r- s','Linewidth',2);
                end
            end
            for k=mults
                ind=updown(k,1);v=l3(ind+ex);
                if(updown(k,2)) plot([ind ind],[v-0.25 v+0.25],'b-s','Linewidth',1);
                else plot([ind ind],[v-0.25 v+0.25],'r-s','Linewidth',1);
                end
            end
            if(LastUD==1) text(xl+100-ex,l3(i+ex)+0.18,'UP','FontSize',14,'Color','b');
            elseif(LastUD==0) text(xl+100-ex,l3(i+ex)+0.18,'DOWN','FontSize',14,'Color','r');
            end
        end
        axis([xl-1-ex i (l3(iex)-0.25) (l3(iex)+0.25)])
        xlabel('Hourly chart')
        hold off;
        drawnow;
        % Second plot stuff
        subplot(ax2);
        xl=max(1,iex-PtsToPlot+1); ivec=xl:iex;
        plot(ivec-ex,l1(ivec),'g',ivec-ex,l2(ivec),'g',ivec-ex,l3(ivec),'g','Linewidth',2)
        hold on
        if(iex>(StartT+nS2+2))
            jvec=xl:(j3-1);%i-nS2;
            plot(jvec-ex,s3(jvec),'m','Linewidth',2);
            %             if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
            %             if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
            %             if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
            %             if(length(MMin)) plot(MMinT,MMin,'bo'); end;
            for k=1:size(buysell3,1)
                ind=buysell3(k,1);v=l3(ind+ex);
                if(buysell3(k,2)) plot([ind ind],[v-0.25 v+0.25],':h');
                else  plot([ind ind],[v-0.25 v+0.25],'r:h');
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
        if(iex>(StartT+nS2UD2+2))
            jvec=xl:(jud2-1);%i-nS2UD2;
            plot(jvec-ex,s2_2(jvec),'b','Linewidth',2);
            plot(jvec-ex,s1_2(jvec),'r','Linewidth',2);
            plot(s1Line2(:,1),s1Line2(:,2),'k--',s2Line2(:,1),s2Line2(:,2),'k--')%,'Linewidth',2)
            plot([s1High2(1) s1LowT2],[s1High2(2) s1Low2],'b*',[s2Low2(1) s2HighT2],[s2Low2(2) s2High2],'r*')
            for k=bigs2
                ind=updown2(k,1);v=l3(ind+ex);
                if(abs(updown2(k,2))==1) plot([ind ind],[v-0.25 v+0.25],'b--*','Linewidth',2);
                else plot([ind ind],[v-0.25 v+0.25],'r--*','Linewidth',2);
                end
            end
            for k=mults2
                ind=updown2(k,1);v=l3(ind+ex);
                if(updown2(k,2)) plot([ind ind],[v-0.25 v+0.25],'b--*','Linewidth',1);
                else plot([ind ind],[v-0.25 v+0.25],'r--*','Linewidth',1);
                end
            end
            if(LastUD2==1) text(xl+100-ex,l3(i+ex)+0.18,'TREND UP','FontSize',14,'Color','b');
            elseif(LastUD2==0) text(xl+100-ex,l3(i+ex)+0.18,'TREND DOWN','FontSize',14,'Color','r');
            end
        end
        axis([xl-1-ex i (l3(iex)-0.25) (l3(iex)+0.25)])
        xlabel('2 Hourly chart')
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
% keyboard
% save temp updown2 -append
[b1,b2,TrTimes]=GetProfit(buysell,1);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=max(size(buysell,1)-1,0)
[b3,b4,TrTimes]=GetProfit(buysell2,1);
bs1_2=sum(b3)
bs2_2=sum(b4)
NumTrades2=max(size(buysell2,1)-1,0)
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

figure(2)
is=1:iex; plot(is-ex,l1(is),'g',is-ex,l2(is),'g',is-ex,l3(is),'g','Linewidth',2)
hold on
plot((1:j3-1)-ex,s3,'m',(1:jud-1)-ex,s2,'b',(1:jud-1)-ex,s1,'r','Linewidth',2);
if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
if(length(MMin)) plot(MMinT,MMin,'bo'); end;
for k=1:size(buysell,1)
    ind=buysell(k,1);v=l3(ind+ex);
    if(abs(buysell(k,2))==1) plot([ind ind],[v-0.25 v+0.25]);
    else  plot([ind ind],[v-0.25 v+0.25],'r');
    end
end
for k=1:size(buysell2,1)
    ind=buysell2(k,1);v=l3(ind+ex);
    if(buysell2(k,2)) plot([ind ind],[v-0.25 v+0.25],':h');
    else  plot([ind ind],[v-0.25 v+0.25],'r:h');
    end
end
% Plot UPDOWN stuff
for k=bigs
    ind=updown(k,1);v=l3(ind+ex);
    if(abs(updown(k,2))==1) plot([ind ind],[v-0.25 v+0.25],'b- s','Linewidth',2);
    else plot([ind ind],[v-0.25 v+0.25],'r- s','Linewidth',2);
    end
end
for k=mults
    ind=updown(k,1);v=l3(ind+ex);
    if(updown(k,2)) plot([ind ind],[l2(ind) v+0.125],'b-s','Linewidth',1);
    else plot([ind ind],[v-0.125 l1(ind)],'r-s','Linewidth',1);
    end
end
figure(3)
plot(is-ex,l1(is),'g',is-ex,l2(is),'g',is-ex,l3(is),'g','Linewidth',2)
plot((1:j3-1)-ex,s3,'m',(1:jud2-1)-ex,s2_2,'b',(1:jud2-1)-ex,s1_2,'r','Linewidth',2);
% if(length(ma3)) plot(ma3,ma3_s,'r.'); end;
% if(length(mi3)) plot(mi3,mi3_s,'b.'); end;
% if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
% if(length(MMin)) plot(MMinT,MMin,'bo'); end;
for k=1:size(buysell3,1)
    ind=buysell3(k,1);v=l3(ind+ex);
    if(buysell3(k,2)) plot([ind ind],[v-0.25 v+0.25]);
    else  plot([ind ind],[v-0.25 v+0.25],'r');
    end
end
for k=bigs2
    ind=updown2(k,1);v=l3(ind+ex);
    if(abs(updown2(k,2))==1) plot([ind ind],[v-0.25 v+0.25],'b- *','Linewidth',2);
    else plot([ind ind],[v-0.25 v+0.25],'r- *','Linewidth',2);
    end
end
for k=mults2
    ind=updown2(k,1);v=l3(ind+ex);
    if(updown2(k,2)) plot([ind ind],[v-0.25 v+0.25],'b-*','Linewidth',1);
    else plot([ind ind],[v-0.25 v+0.25],'r-*','Linewidth',1);
    end
end

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