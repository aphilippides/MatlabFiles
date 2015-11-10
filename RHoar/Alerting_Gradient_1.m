function Alerting_Gradient(fn)

nSmooth=100:20:500
profs=[];
for nS=nSmooth
    bs=ag(fn,nS);
    s=GetProfit(bs);
profs=[profs sum(s(find(abs(s)<500)))]
end
keyboard


function[buysell]=ag(fn,nSmooth)

dmat
cd RHoar\LogData;
% cd('C:\Documents and Settings\ROWLAND\My Documents');

load(fn);
L1=l1;L2=l2;L3=l3;B=buy;S=sell;
clear l1 l2 l3 buy sell t AlertList AlertTime AlertValue


% s=date;
% % fn=['logData' s '.mat'];
% fout=['BSlogdata_' s '.txt'];
% fout_ud=['UDlogdata_' s '.txt'];
% fout2=['exceldata_' s '.txt'];

% Parameters
% This is how many points are used to get the prediction + the number
% extrapolated
nPoints1=220;    % top line
nPoints2=220;    % bottom line
nPoints3=2;    % middle line

% this is how many points into the 'future' the line is extrapolated
% Use 0 if you want line to be at forefront of data
% nSmooth=240;
nPredict2=20;
nPredict3=20;

% nEnd1=nPoints1-nPredict1;
% nEnd2=nPoints2-nPredict2;
% nEnd3=nPoints3-nPredict3;

sm_len=20;
PtsToPlot=3600;
PtsToPlot2=7200;

% if(~isfile(fout)) WriteLogDataPreamble(fout); end;
% if(~isfile(fout_ud)) WriteLogDataPreamble(fout_ud); end;
% if(~isfile(fout2)) WriteExcelDataPreamble(fout2); end;
% WriteParams(fout,nPoints3,nPredict3);
% WriteParams(fout_ud,nPoints1,nPredict1,nPoints2,nPredict2);

NotStillSelling=1;
pt1=[];
pt2=[];
j=1;
buysell=[];
for i=1:length(L1);
    % Read data and write to file/variables
    ts(i)=cputime;
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
    t(i)=TimeSecs(times(i,4:6));
    % Project the lines
    %     xl=max(StartPt,i-nPoints1+1);
    %     xh=min(i,xl+nPoints1-nPredict1);
    %     pvec1=xl:xh;
    % Calculate gradients

    if(i>nSmooth)
        g3(j) = CalcGradient(t,l3,nSmooth);
        if(j>(2*nPoints3))
            i1=j-nPoints3:j;
            i2=j-2*nPoints3:j-nPoints3;
            a=g3(j)*g3(j-2*nPoints3);
            %             ipos=find(g3(i1)>0);
            %             ineg=find(g3(i1)<0);
            %             if((length(ipos)/nPoints3)>0.75)
            %                 s1=mean(g3(ipos));
            %             elseif((length(ineg)/nPoints3)>0.75)
            %                 s1=mean(g3(ineg));
            %             else s1=0;
            %             end
            %             ipos=find(g3(i2)>0);
            %             ineg=find(g3(i2)<0);
            %             if((length(ipos)/nPoints3)>0.5)
            %                 s2=mean(g3(ipos));
            %             elseif((length(ineg)/nPoints3)>0.5)
            %                 s2=mean(g3(ineg));
            %             else s2=0;
            %             end
            %             b=s1*s2;
            %              b=median(g3(i1))*median(g3(i2));
            if(a<0)
                if(NotStillSelling)
                    NotStillSelling=0;
                    if(g3(j)>g3(j-nPoints3))
                        buysell=[buysell;t(i) 1 buy(i)];
                        pt2=[pt2;1 i t(i) buy(i) a g3(j) g3(j-nPoints3)];
                    else
                        pt2=[pt2;0 i t(i) sell(i) a g3(j) g3(j-nPoints3)];
                        buysell=[buysell;t(i) 0 sell(i)];
                    end;
                end
            else NotStillSelling=1;
            end
%             if(b<0)
%                 if(NotStillSelling)
%                     NotStillSelling=0;
%                     %                    if(s1>s2)
%                     if(median(g3(i1))>median(g3(i2)))
%                         pt2=[pt2;0 i t(i) b buy(i)];
%                         buysell=[buysell;t(i) 1 buy(i)];
%                     else
%                         pt2=[pt2;0 i t(i) b sell(i)];
%                         buysell=[buysell;t(i) 0 sell(i)];
%                     end;
%                 end;
%             else NotStillSelling=1;
%             end
        end;
        j=j+1;
        % graph the data
    end
%     if(mod(i,100)==0)
%         i
%     end
%     if(mod(i,1000)==0)
%         keyboard;
%     end
end
% keyboard