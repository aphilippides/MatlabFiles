function[buysell,UpLine,DownLine,s3]=DiagonalProfit(fout,l1,l2,l3,buy,sell,tsecs,timez,ns,EndPt,RangeProp,WRITE)

n2=ceil(ns/2);
RangeProp=RangeProp*100/0.1;
s2=MySmoothV(l2,EndPt+1);
s1=MySmoothV(l1,EndPt+1);
% s3=MySmoothV(l3,ns+1);
% s3=s3(n2+1:end);
% ep2=ceil(EndPt/2);
% s2=[ones(1,ep2) SmoothVec(l2,EndPt+1,'replicate')];
% s1=[ones(1,ep2) SmoothVec(l1,EndPt+1,'replicate')];
s3=SmoothVec(l3,ns+1,'replicate');
% s3=s3(1:end-n2-1);
s3=s3(1:end-n2);
% s2=s2(1:end-n2-1);
% s1=s1(1:end-n2-1);
% [ma,mi]=findextrema(s3);
[ma,mi,opt,mami]=findextrema_v1(s3);
%[ma2,mi2]=findextrema(s3);
ma_t=ceil(ma)+n2;
mi_t=ceil(mi)+n2;
ma_s=s3(ceil(ma));
mi_s=s3(ceil(mi));
ma_ks=ma_s;
ma_kt=ma_t;
buysell=[];
t=1:length(l3);
opts=s3(opt);
opt=opt+n2;
[cur_ma,cur_mat]=max(s3(1:2));
cur_mat=cur_mat+n2+1;
cur_mi=1e9;
cur_mit=n2;
DownPt=1e9;
DownLine=[cur_ma,cur_mat;1e9,0;1e9,0];
for i=1:length(opt)
    % if new high max update current max
    if(mami(i))
        if(opts(i)>=cur_ma)
            cur_ma=opts(i);
            cur_mat=opt(i);
            DownLine(1,:)=[cur_ma,cur_mat];
        end
    else
        % if new low min update DownPt
        if(opts(i)<=cur_mi)
            if(cur_ma~=-1e9)
                cur_mi=opts(i);
                cur_mit=opt(i);
                DownGrad=(cur_mi-cur_ma)/(cur_mit-cur_mat);
                len=RangeProp*(l1(cur_mit)-l2(cur_mit));
                [DownPt,DownT]=GetDiagonalPt(DownGrad,len,cur_mi,cur_mit);
                DownLine(2:3,:)=[cur_mi,cur_mit;DownPt,DownT];
             end
        end
    end
    % Get Alert Time
    at=find(((s2>DownPt)&(t>=cur_mit)),1);
    if(~isempty(at))
        if((i==length(opt))|(at<opt(i+1)))
            % buy
            if(WRITE) WriteLogData(buy(at),timez(at,(4:6)),4,fout); end;
            buysell=[buysell;at 1 buy(at)];
            cur_mi=1e9;
            DownPt=1e9;
            cur_ma=-1e9;
            DownLine=[-1e9,0;1e9,0;1e9,0];
        end
    end
end    

[cur_mi,cur_mit]=min(s3(1:2));
cur_mit=cur_mit+n2+1;
cur_ma=-1e9;
cur_mat=n2;
UpPt=-1e9;
UpLine=[cur_mi,cur_mit;-1e9,0;-1e9,0];
for i=1:length(opt)
    % if new low min update current min
    if(mami(i)==0)
        if(opts(i)<=cur_mi)
            cur_mi=opts(i);
            cur_mit=opt(i);
            UpLine(1,:)=[cur_mi,cur_mit];
        end
    else
        % if new high max update UpPt
        if(opts(i)>=cur_ma)
            if(cur_mi~=1e9)
                cur_ma=opts(i);
                cur_mat=opt(i);
                gr=(cur_ma-cur_mi)/(cur_mat-cur_mit);
                len=RangeProp*(l1(cur_mat)-l2(cur_mat));
                [UpPt,UpT]=GetDiagonalPt(gr,len,cur_ma,cur_mat);
                UpLine(2:3,:)=[cur_ma,cur_mat;UpPt,UpT];
            end
        end
    end
    % Get Alert Time
    at=find(((s1<UpPt)&(t>=cur_mat)),1);
    if(~isempty(at))
        if((i==length(opt))|(at<opt(i+1)))
            % sell
            if(WRITE) WriteLogData(sell(at),timez(at,(4:6)),1,fout); end;
            buysell=[buysell;at 0 sell(at)];
            cur_ma=-1e9;
            UpPt=-1e9;
            cur_mi=1e9;                
            UpLine=[1e9,0;-1e9,0;-1e9,0];
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
UpLine(:,2)=max(UpLine(:,2)-n2,0);
DownLine(:,2)=max(DownLine(:,2)-n2,0);

Plotting=0;
if(Plotting)
    for i=1:size(buysell,1)
        t=timez(buysell(i,1),(4:6));
        if(buysell(i,2)) WriteLogData(buysell(i,3),t,4,fout);
        else WriteLogData(buysell(i,3),t,1,fout);
        end
    end
    figure(1);
    is=1:length(l1);
    plot(is,l1,'g',is,l2,'g',is,l3,'g',1:length(s3),s3,'m',1:length(s2),s2,'r',1:length(s1),s1,'b','Linewidth',2)
    hold on; 
    plot(mi_t,mi_s,'ro'); 
    plot(ma_t,ma_s,'bo'); 
    legend('smoothed l3','sell','buy','Location','best');
    [bs1,bs2,TrTimes]=GetProfit(buysell,1);
    sum(bs1)
    sum(bs2)
    for i=1:size(buysell,1)
        j=buysell(i,1);
        if(buysell(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
        else  plot([j j],[l3(j)-0.25 l3(j)+0.25],'r');
        end
    end
    hold off
    axis tight
    xlim([1 length(l1)+500])
    title('Smoothed day data with trades and potential trades')
    
    if(~isempty(buysell))
        figure(2)
        n=size(buysell,1);
        bar([bs1;bs2]')
        legend('simple','multiple');
        title('Buy sell profit/loss')
    end
    keyboard;
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
opt=is+1;