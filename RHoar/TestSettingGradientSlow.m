function[bs1,bs2,NumTrades] = Alerting_Gradient(fn,nSmooth,Thresh)
if(isfile('C:\Documents and Settings\ROWLAND\My Documents\'))
    cd('C:\Documents and Settings\ROWLAND\My Documents');
else
    dmat;
    % cd RHoar/DataNoText/
    cd RHoar/LogData/;
end

disp('uncomment sounds and writeData')

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

PtsToPlot=3600;
PtsToPlot2=7200;

if(~isfile(fout)) WriteLogDataPreamble(fout); end;
if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
WriteParams(fout,nSmooth,Thresh,EndPt);
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud); end;
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

NotStillSelling=1;
j=1;
buysell=[];
NotStillClosed=1;
StartT=0;
t=TimeSecs(times(:,4:6));
for i=1:length(t);
    % Read data and write to file/variables
    ts(i)=GetSecs;%cputime;
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
    %    times(i,:)=clock;
    % t(i)=TimeSecs(timez(i,4:6));

    % If end time, close the
    if(t(i)>=TimeSecs([16,29,59]))
        CloseOut(t(i),sell(i),buy(i),times(i,(4:6)),buysell,fout)
        save(fn,'l1','l2','l3','t','times','buysell','buy','sell');
        WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);
        break;
    end

    % Calculate gradients
    if((l1(i)-l2(i))>0.05)
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
                        if((mean(l3(ks))-s3(j))>Thresh)
                            WriteLogData(buy(i),times(i,(4:6)),4,fout);
                            buysell=[buysell;t(i) 1 buy(i)];
                            %                         wavplay(buysound);
                        end
                    else
                        if((s3(j)-mean(l3(ks)))>Thresh)
                            buysell=[buysell;t(i) 0 sell(i)];
                            WriteLogData(sell(i),times(i,(4:6)),1,fout);
                            %                         wavplay(sellsound);
                        end
                    end;
                end
            elseif(j>(2*nPoints3))
                js=j-2*nPoints3:j;
                g=gradient(s3(js));
                g3(j) = g(2);    
            end;
            j=j+1;
        end
        NotStillClosed=1;
    else
        if(NotStillClosed)
            NotStillClosed=0;
%             CloseOut(t(i),sell(i),buy(i),times(i,(4:6)),buysell,fout)
%             save(fn,'l1','l2','l3','t','times','buysell','buy','sell');
        end
        StartT=i;
    end
    % graph the data
    if(mod(i,500)==0)
%        keyboard
    i
%        save(fn,'l1','l2','l3','t','times','buysell','buy','sell');
    end
%    WriteExcelData(times(i,(4:6)),l1(i),l2(i),l3(i),buy(i),sell(i),fout2);

end
[b1,b2,TrTimes]=GetProfit(buysell,1);
% [ud1,ud2,TrTimes]=GetProfit(updown);
bs1=sum(b1);
bs2=sum(b2);
NumTrades=size(buysell,1);
keyboard

function CloseOut(t,sell,buy,times,buysell,fout)
if(isempty(buysell))
elseif(buysell(end,2)==1)
    WriteLogData(sell,times,1,fout);
    buysell=[buysell;t -1 sell];
elseif(buysell(end,2)==0)
    WriteLogData(buy,times,4,fout);
    buysell=[buysell;t -2 buy];
end