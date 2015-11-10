function[bs1,bs2,NumTrades] = Alerting_GradientMine(fn,nSmooth,Thresh,Plotting)
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

% Change this bit to change the end pt
EndPt=15;
nPoints3=1;

load(fn);
L1=l1;L2=l2;L3=l3;B=buy;S=sell;
clear l1 l2 l3 buy sell t

s=date;
fn=['logData' s '.mat'];
fout=['BSlogdata_' s '.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
fout2=['exceldata_' s '.txt'];

PauseLen=0.02;%0.25;
PtsToPlot=3600;
PtsToPlot2=7200;
if(nargin<4) Plotting=1; end;

if(~isfile(fout)) WriteLogDataPreamble(fout); end;
if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nSmooth,Thresh,EndPt);
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud); end;
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);
N=32400;
NotStillSelling=1;
j=1;
buysell=[];
NotStillClosed=1;
StartT=0;
t=TimeSecs(timez(:,4:6));
ma_s=[];mi_s=[];ma=[];mi=[];
for i=1:length(t);
    % Read data and write to file/variables
%     ts=GetSecs;
    ts(i)=GetSecs;
    l1(i)=L1(i);
    l2(i)=L2(i);
    l3(i)=L3(i);
    buy(i)=B(i);
    if(B==0)
        if(i>1) buy(i)=buy(i-1); end;
    end;
    sell(i)=S(i);
    if(S==0)
        if(i>1) sell(i)=sell(i-1); end;
    end;
%     timez(i,:)=clock;
%     t(i)=TimeSecs(timez(i,4:6));

    % If end time, close
    if((t(i)>=TimeSecs([16,29,59]))|i==length(t))
        buysell=CloseOut(i,sell(i),buy(i),timez(i,(4:6)),buysell,fout);
        save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
 %       WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    % Calculate gradients
    if((l1(i)-l2(i))>0.0)%5)
        if(i>(StartT+nSmooth/2))
            if(i>(nSmooth+StartT)) is=(i-nSmooth):i;
            else
                n1s=nSmooth-i+1;
                is=[ones(1,n1s)*(StartT+1) StartT+1:i];
            end
                
            s3(j)=mean(l3(is));
            if(j>(1+2*nPoints3))
                js=j-2*nPoints3:j;
                g=gradient(s3(js));
                g3(j) = g(2);    % CalcGradient(s(j));
                a=g3(j)*g3(j-1);
                if(a<0)
                    ks=(i-EndPt):i;
                    if(g3(j)>g3(j-1))
                        mi=[mi j];
                        mi_s=[mi_s s3(j)];
                        if((mean(l3(ks))-s3(j))>Thresh)
                            WriteLogData(buy(i),timez(i,(4:6)),4,fout);
                            buysell=[buysell;i 1 buy(i)];
%                             buysell=[buysell;t(i) 1 buy(i)];
                            wavplay(buysound);
                        end
                    else
                        ma=[ma j];
                        ma_s=[ma_s s3(j)];
                        if((s3(j)-mean(l3(ks)))>Thresh)
                            buysell=[buysell;i 0 sell(i)];
%                             buysell=[buysell;t(i) 0 sell(i)];
                            WriteLogData(sell(i),timez(i,(4:6)),1,fout);
                            wavplay(sellsound);
                        end
                    end;
                end
            elseif(j>(2*nPoints3))
                js=j-2*nPoints3:j;
                g=gradient(s3(js));
                g3(j) = g(2);    
            end;
            j=j+1;
        end;
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
%             CloseOut(t(i),sell(i),buy(i),timez(i,(4:6)),buysell,fout)
             save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
        end
        StartT=i;
    end
    % graph the data
    if(Plotting)
        xl=max(1,i-PtsToPlot+1);
        %     subplot(3,1,1)
        ivec=xl:i;
        plot(ivec,l1(ivec),'r',ivec,l2(ivec),'b',ivec,l3(ivec),'m','Linewidth',2)
        hold on
        if(i>(StartT+nSmooth/2))
            jvec=xl:ceil(i-nSmooth/2);
            plot(jvec,s3(jvec),'g','Linewidth',2);
            if(length(ma)) plot(ma,ma_s,'ro'); end;
            if(length(mi)) plot(mi,mi_s,'bo'); end;
            for k=1:size(buysell,1)
                ind=buysell(k,1);
                if(buysell(k,2)) plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25]);
                else  plot([ind ind],[l3(ind)-0.25 l3(ind)+0.25],'r');
                end
            end
        end
        axis([xl-1 i (L3(i)-0.25) (L3(i)+0.25)])
        title('Hourly chart')
        hold off;
    end

    if(mod(i,500)==0)
%          keyboard
    i
        save(fn,'l1','l2','l3','t','timez','buysell','buy','sell');
    end
%    WriteExcelData(timez(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
    td=GetSecs-ts;
    w=PauseLen-td;
%     if(w>0) pause(w);  end;    

end
[b1,b2,TrTimes]=GetProfit(buysell,1);
% [ud1,ud2,TrTimes]=GetProfit(updown);
bs1=sum(b1);
bs2=sum(b2);
NumTrades=size(buysell,1);
keyboard