function[fbs,fbsline,fBuyOn,fSellOn]=FastBuySell(l1,l2,l3,isF,fBuyOn,fSellOn,EPF,RPF,...
    i,buy,sell,buysound,sellsound,fout,timez)

fbs=[];
% Calc gradient and extension
[ex,fbsline]=calcgrad(isF,l3,RPF);

% get end points
ml1=mean(l1(end-EPF:end));
ml2=mean(l2(end-EPF:end));

% check if l1 is below or above the line. 
% If above and not signal, SELL else reset if below
if((ex>=ml1)&&(~fSellOn))
    WriteLogData(sell,timez,1,fout);
    fbs=[fbs;i 0 sell];
    wavplay(sellsound);%,'async');
    fSellOn=1;
elseif((ex<ml1)&&(fSellOn)) fSellOn=0;
end

% check if l2 is below or above the line. 
% If below and not signal, BUY else reset if above
if((ex<=ml2)&&(~fBuyOn))
    WriteLogData(buy,timez,1,fout);
    fbs=[fbs;i 1 buy];
    wavplay(buysound);%,'async');
    fBuyOn=1;
elseif((ex>ml1)&&(fBuyOn)) fBuyOn=0;
end

function[ex,fbsline]=calcgrad(x,y,RPF)
brob = [ones(size(x')) x']\y';
fbsline.xs=[x(1) x(end)*(1+RPF)];
fbsline.ys=brob(1)+brob(2)*fbsline.xs;
fbsline.gs=brob;
ex=fbsline.ys(2);

function[ex,fbsline]=calcgradRobust(x,y,RPF)
brob = robustfit(x,y);
fbsline.xs=[x(1) x(end)*(1+RPF)];
fbsline.ys=brob(1)+brob(2)*fbsline.xs;
fbsline.gs=brob;
ex=fbsline.ys(2);

function dummydemo
x = (-20:20)';
y = (x+15).^2 + 100*randn(41,1);
y(35:40)=y(35:40)+1000;
bls = regress(y,[ones(41,1) x])
brob = robustfit(x,y)
plot(x,y,'b-o',x,brob(1)+brob(2)*x,'r-', x,bls(1)+bls(2)*x,'m:')
hold off