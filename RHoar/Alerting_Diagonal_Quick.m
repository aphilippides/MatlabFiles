function[bs1,bs2,NumTrades] = Alerting_Diagonal_Quick(fin,Plotting)
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

% Change these things
nSmooth=230;
% ensure nSmooth is even
nS2=ceil(nSmooth/2);
nSmooth=2*nS2;
EndPtU=0;
EndPtD=0;
RangeProp=0.5;
RangeProp=RangeProp*100/0.1;

% Not used at the moment
%
% MultipleLimit=120;
% TimeLim=0;
% if(TimeLim==0) TimeLim=N; end;

s=date;
fn=['logData' s '.mat'];
fout=['BSlogdata_' s '.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];

PauseLen=0.05;
RepTime=100;
PtsToPlot=3600;
PtsToPlot2=7200;

if(~isfile(fout)) WriteLogDataPreamble(fout,s); end;
if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nSmooth,0,EndPtU,0,0,EndPtD);
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud,s); end;
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

j=1;
buysell=[];
NotStillClosed=1;
StartT=0;
ma_s=[];mi_s=[];ma=[];mi=[];
MMax=[];MMaxT=[];MMin=[];MMinT=[];

[tim,L1,L2,L3,B,S]=ReadLogData(fin);

LastMin=1e9;
LastMax=-1e9;
% LastMinT=-TimeLim;
% LastMaxT=-TimeLim;
% LastAlertT=-MultipleLimit;
DownPt=1e9;
UpPt=-1e9;
TitStr=['Lowest min unassigned; Highest max unassigned'];
if(nargin<2) Plotting=1; end;

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
        CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout)
        save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        %        WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    if((l1(i)-l2(i))>0.05)

        % Calculate smoothed lines and gradients
        % Read in enough so that averaging works. NB nSmooth must be even
        if(i>(StartT+nSmooth/2))

            % Calculate indices to smooth, with padding at left hand-side
            if(i>(nSmooth+StartT)) is=(i-nSmooth):i;
            else
                n1s=nSmooth-i+1;
                is=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end

            % Calculate smoothed values
            s1(j)=mean(l1(is));
            s2(j)=mean(l2(is));
            s3(j)=mean(l3(is));

            % Calc gradient
            if(j>(StartT+3))
                g = gradient(s3(j-2:j));
                g3(j) = g(2);

                % check if optima and if greater than previous
                a=g3(j)*g3(j-1);
                if(a<=0)
                    if(g3(j)>g3(j-1))
                        mi=[mi j];
                        mi_s=[mi_s s3(j)];
                        if(s3(j)<=LastMin)
                            LastMin=s3(j);
                            LastMinT=j;
                            % Calc new max-min line and extrapolation
%                             loptt=UpLine(2,1);
%                             lopt=UpLine(2,2);
                            DownGrad=(LastMin-DownStart)/(LastMinT-DownStartT);
                            len=RangeProp*(l1(end)-l2(end));
                            [DownPt,DownT]=GetDiagonalPt(DownGrad,len,LastMin,LastMinT);
%                             DownLine=[loptt,lopt;LastMinT,LastMin;DownT,DownPt];
                            DownLine=[DownStartT,DownStart;LastMinT,LastMin;DownT,DownPt];
%                             UpStart=s3(j);
%                             UpStartT=j;
                        end
                        if(s3(j)<=UpStart)
                            UpStart=s3(j);
                            UpStartT=j;
                        end
                    else
                        ma=[ma j];
                        ma_s=[ma_s s3(j)];
                        if(s3(j)>=LastMax)
                            LastMax=s3(j);
                            LastMaxT=j;
                            % Calc new max-min line and extrapolation
%                             loptt=DownLine(2,1);
%                             lopt=DownLine(2,2);
                            UpGrad=(LastMax-UpStart)/(LastMaxT-UpStartT);
                            len=RangeProp*(l1(end)-l2(end));
                            [UpPt,UpT]=GetDiagonalPt(UpGrad,len,LastMax,LastMaxT);
%                             UpLine=[loptt,lopt;LastMaxT,LastMax;UpT,UpPt];
                            UpLine=[UpStartT,UpStart;LastMaxT,LastMax;UpT,UpPt];
%                             DownStart=s3(j);
%                             DownStartT=j;
                        end
                        if(s3(j)>=DownStart)
                            DownStart=s3(j);
                            DownStartT=j;
                        end
                    end;
                end

                % if within time limit, check if TP triggers buy alert
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
                    LastAlertT=i;
                    LastAlert=1;
                    DownPt=1e9;
                    MMin=[MMin LastMin];
                    MMinT=[MMinT LastMinT];
                    LastMin=1e9;
%                     LastMinT=-TimeLim;
                    DownStart=-1e9;
%                     DownLine=[];
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
                    MMax=[MMax LastMax];
                    MMaxT=[MMaxT LastMaxT];
                    LastAlertT=i;
                    LastAlert=0;
                    UpPt = -1e9;
                    LastMax=-1e9;
%                     LastMaxT=-TimeLim;
                    UpStart=1e9;
                end
            elseif(j>(StartT+2))
                % if not enough vals to check if optima
                g=gradient(s3(j-2:j));
                g3(j) = g(2);
                % Set first point after close as LastMin and LastMax
                [LastMin,mt]=min(s3(j-1:j));
                LastMinT=j-2+mt;
                [LastMax,mt]=max(s3(j-1:j));
                LastMaxT=j-2+mt;
                DownLine=[LastMinT,LastMin;LastMinT,LastMin;LastMinT,LastMin];
                UpLine=[LastMaxT,LastMax;LastMaxT,LastMax;LastMaxT,LastMax];
                UpStartT=LastMinT;
                UpStart=LastMin;
                DownStart=LastMax;
                DownStartT=LastMaxT;
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

    if(Plotting)
        xl=max(1,i-PtsToPlot+1);
        %     subplot(3,1,1)
        ivec=xl:i;
        plot(ivec,l1(ivec),'g',ivec,l2(ivec),'g',ivec,l3(ivec),'g','Linewidth',2)
        hold on
        if(i>(StartT+2+nSmooth/2))
            jvec=xl:ceil(i-nSmooth/2);
            plot(jvec,s3(jvec),'m','Linewidth',2);
            plot(jvec,s2(jvec),'b','Linewidth',2);
            plot(jvec,s1(jvec),'r','Linewidth',2);
            if(length(ma)) plot(ma,ma_s,'r.'); end;
            if(length(mi)) plot(mi,mi_s,'b.'); end;
            if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
            if(length(MMin)) plot(MMinT,MMin,'bo'); end;
            for k=1:size(buysell,1)
                ind=buysell(k,1);
                if(buysell(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
                else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
                end
            end
            % Plot current lines
            plot(DownLine([1 2],1),DownLine([1 2],2),'k')
            plot(DownLine([2 3],1),DownLine([2 3],2),'b')
            plot(UpLine([1 2],1),UpLine([1 2],2),'k')
            plot(UpLine([2 3],1),UpLine([2 3],2),'r')
            if(DownStart~=-1e9) plot(DownStartT,DownStart,'bs'); end;
            if(UpStart~=1e9) plot(UpStartT,UpStart,'rs'); end;
            %             TitStr=['Lowest Min = ' num2str(LastMin) '; Highest Max = ' num2str(LastMax)];
            if(LastMin~=1e9)
                plot(LastMinT,LastMin,'bo','MarkerFaceColor','b');%,'MarkerSize',10);
                TitStr=['Lowest Min = ' num2str(LastMin)];
            else TitStr=['Lowest Min unassigned'];
            end
            if(LastMax~=-1e9)
                plot(LastMaxT,LastMax,'ro','MarkerFaceColor','r');%,'MarkerSize',10);
                TitStr=[TitStr '; Highest Max = ' num2str(LastMax)];
            else TitStr=[TitStr '; Highest Max unassigned'];
            end
        end
        axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
        title(TitStr);
        xlabel('Hourly chart')
        hold off;
    end

    if(mod(i,RepTime)==0)
        xl=max(1,i-PtsToPlot+1);
        %     subplot(3,1,1)
        ivec=xl:i;
        plot(ivec,l1(ivec),'r',ivec,l2(ivec),'b',ivec,l3(ivec),'m','Linewidth',2)
        hold on
        if(i>(StartT+2+nSmooth/2))
            jvec=xl:ceil(i-nSmooth/2);
            plot(jvec,s3(jvec),'g','Linewidth',2);
            plot(jvec,s2(jvec),'g','Linewidth',2);
            plot(jvec,s1(jvec),'g','Linewidth',2);
            if(length(ma)) plot(ma,ma_s,'r.'); end;
            if(length(mi)) plot(mi,mi_s,'b.'); end;
            if(length(MMax)) plot(MMaxT,MMax,'ro'); end;
            if(length(MMin)) plot(MMinT,MMin,'bo'); end;
            for k=1:size(buysell,1)
                ind=buysell(k,1);
                if(buysell(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
                else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
                end
            end
            % Plot current lines
            plot(DownLine([1 2],1),DownLine([1 2],2),'k','LineWidth',2)
            plot(DownLine([2 3],1),DownLine([2 3],2),'b','LineWidth',2)
            plot(UpLine([1 2],1),UpLine([1 2],2),'k','LineWidth',2)
            plot(UpLine([2 3],1),UpLine([2 3],2),'r','LineWidth',2)
            if(DownStart~=-1e9) plot(DownStartT,DownStart,'bs'); end;
            if(UpStart~=1e9) plot(UpStartT,UpStart,'rs'); end;
            %             TitStr=['Lowest Min = ' num2str(LastMin) '; Highest Max = ' num2str(LastMax)];
            if(LastMin~=1e9)
                plot(LastMinT,LastMin,'bo','MarkerFaceColor','b');%,'MarkerSize',10);
                TitStr=['Lowest Min = ' num2str(LastMin)];
            else TitStr=['Lowest Min unassigned'];
            end
            if(LastMax~=-1e9)
                plot(LastMaxT,LastMax,'ro','MarkerFaceColor','r');%,'MarkerSize',10);
                TitStr=[TitStr '; Highest Max = ' num2str(LastMax)];
            else TitStr=[TitStr '; Highest Max unassigned'];
            end
        end
        axis([xl-1 i (l3(i)-0.25) (l3(i)+0.25)])
        title(TitStr);
        xlabel('Hourly chart')
        hold off;
        drawnow;
%        keyboard
%         save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
    end
    %    WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
    if(Plotting)
        i
        td=GetSecs-ts;
        w=PauseLen-td;
        if(w>0) pause(w);  end;
    end
end
[b1,b2,TrTimes]=GetProfit(buysell,1);
% [ud1,ud2,TrTimes]=GetProfit(updown);
bs1=sum(b1)
bs2=sum(b2)
NumTrades=size(buysell,1)