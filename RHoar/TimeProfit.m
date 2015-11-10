function[buysell]=TimeProfit(fout,l1,l2,l3,buy,sell,tsecs,timez,ns,EndPt,Thresh,WRITE)

n2=ceil(ns/2);
e3=MySmoothV(l3,EndPt+1);
% s3=MySmoothV(l3,ns+1);
% s3=s3(n2+1:end);
s3=SmoothVec(l3,ns+1,'replicate');
s3=s3(1:end-n2-1);
[ma,mi,opt,mami]=findextrema_v1(s3);

ma_t=ceil(ma)+n2;
mi_t=ceil(mi)+n2;
ma_s=s3(ma);
mi_s=s3(mi);
buysell=[];
t=1:length(l3);
opts=s3(opt);
opt=opt+n2;
MultLim=120;
cur_ma=-1e9;
cur_mat=n2;
cur_mi=1e9;
cur_mit=n2;
DownPt=1e9;
MaxAlert=-120;MinAlert=-120;
for i=1:length(opt)
    if(mami(i))
    % if new high max update current max
        if(opts(i)>=cur_ma)
            cur_ma=opts(i);
            cur_mat=opt(i);
        end
    else
        % if new low min update DownPt
        if(opts(i)<=cur_mi)
            cur_mi=opts(i);
            cur_mit=opt(i);
        end
    end
    % Get Buy Alert
    at=find((((e3-cur_mi)>Thresh)&(t>=cur_mit)),1);
    if(~isempty(at))
        if((at-MinAlert)>MultLim)
            if((i==length(opt))|(at<opt(i+1)))
                % buy
                if(WRITE) WriteLogData(buy(at),timez(at,(4:6)),4,fout); end;
                buysell=[buysell;at 1 buy(at)];
                cur_mi=1e9;
                DownPt=1e9;
                cur_ma=-1e9;
                MinAlert=at;
            end
        end
    end
    % Get Sell Alert
    at=find((((cur_ma-e3)>Thresh)&(t>=cur_mat)),1);
    if(~isempty(at))
        if((at-MaxAlert)>MultLim)
            if((i==length(opt))|(at<opt(i+1)))
                % sell
                if(WRITE) WriteLogData(sell(at),timez(at,(4:6)),1,fout); end;
                buysell=[buysell;at 0 sell(at)];
                cur_mi=1e9;
                DownPt=1e9;
                cur_ma=-1e9;
                MaxAlert=at;
            end
        end
    end
end

% sort rows into order
[d,is]=sort(buysell(:,1));
buysell=buysell(is,:);
if(~isempty(buysell))
    if(buysell(end,2)) buysell=[buysell;length(sell) 0 sell(end)];
    else buysell=[buysell;length(buy) 1 buy(end)];
    end
end

function[s]=MySmoothV(l,n)
if(n<2) 
    s=l;
    return;
end
ms=zeros(n,length(l)+n-1);
for i=1:n
    ms(i,:)=[ones(1,i-1)*l(1) l ones(1,n-i)*l(end)];
end
s=mean(ms);
s=s(1:length(l));

function[ma,mi,opt,mami]=findextrema_v1(s)
g=gradient(s);
d=g(1:end-1).*g(2:end);
is=find(d<=0);
ma=[];mi=[];mami=[];
for i=is
    if(g(i+1)>g(i)) 
        mi=[mi i+1];
        mami=[mami 0];
    else 
        ma=[ma i+1];
        mami=[mami 1];
    end
end
opt=is+2;