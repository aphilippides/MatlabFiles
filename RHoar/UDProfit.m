function[updown,UpLine,DownLine,s1,s2,LastUD]=UDProfit(fout,l1,l2,l3,buy,sell,tsecs,timez,ns,EndPt,RangeProp,WRITE)

n2=ceil(ns/2);
s2=SmoothVec(l2,ns+1,'replicate');
% s2=s2(1:end-n2-1);
s2=s2(1:end-n2);
s1=SmoothVec(l1,ns+1,'replicate');
% s1=s1(1:end-n2-1);
s1=s1(1:end-n2);
RangeProp=RangeProp*100/0.1;
% s3=MySmoothV(l3,ns+1);
% s3=s3(n2+1:end);
% ep2=ceil(EndPt/2);

e2=MySmoothV(l2,EndPt+1);
e1=MySmoothV(l1,EndPt+1);
updown=[];
t=1:length(l3);

% Get optima for l1
[ma,mi,opt,mami]=findextrema_v2(s1);
ma_t=ma+n2;
mi_t=mi+n2;
opts=s1(opt);
opt=opt+n2;
% Start with UPs with l1 down diagonal
[cur_ma,cur_mat]=max(s1(1:2));
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
    at=find(((e2>DownPt)&(t>=cur_mit)),1);
    if(~isempty(at))
        if((i==length(opt))|(at<opt(i+1)))
            % buy
            updown=[updown;at 1 buy(at)];
            cur_mi=1e9;
            DownPt=1e9;
            cur_ma=-1e9;
            DownLine=[-1e9,0;1e9,0;1e9,0];
        end
    end
end

% Get optima for l2
[ma,mi,opt,mami]=findextrema_v2(s2);
ma_t=ceil(ma)+n2;
mi_t=ceil(mi)+n2;
opts=s2(opt);
opt=opt+n2;
% Next DOWNs with l2 up diagonal
[cur_mi,cur_mit]=min(s2(1:2));
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
    at=find(((e1<UpPt)&(t>=cur_mat)),1);
    if(~isempty(at))
        if((i==length(opt))|(at<opt(i+1)))
            % sell
            updown=[updown;at 0 sell(at)];
            cur_ma=-1e9;
            UpPt=-1e9;
            cur_mi=1e9;
            UpLine=[1e9,0;-1e9,0;-1e9,0];
        end
    end
end    

% sort rows into order
[d,is]=sort(updown(:,1));
updown=updown(is,:);
if(~isempty(updown))
    if(updown(end,2)) 
        updown=[updown;length(sell) 0 sell(end)];
        LastUD=1;
    else 
        updown=[updown;length(buy) 1 buy(end)];
        LastUD=0;
    end
else LastUD=-1;
end
UpLine(:,2)=max(UpLine(:,2)-n2,0);
DownLine(:,2)=max(DownLine(:,2)-n2,0);

Plotting=0;
if(Plotting)
    for i=1:size(updown,1)
        t=timez(updown(i,1),(4:6));
        if(updown(i,2)) WriteLogData(updown(i,3),t,4,fout);
        else WriteLogData(updown(i,3),t,1,fout);
        end
    end
    figure(1);
    is=1:length(l1);
    plot(is,l1,'g',is,l2,'g',is,l3,'g',1:length(s2),s2,'r',1:length(s1),s1,'b','Linewidth',2)
    hold on; 
    legend('smoothed l3','sell','buy','Location','best');
    [bs1,bs2,TrTimes]=GetProfit(updown,1);
    sum(bs1)
    sum(bs2)
    for i=1:size(updown,1)
        j=updown(i,1);
        if(updown(i,2)) plot([j j],[l3(j)-0.25 l3(j)+0.25]);
        else  plot([j j],[l3(j)-0.25 l3(j)+0.25],'r');
        end
    end
    hold off
    axis tight
    xlim([1 length(l1)+500])
    title('Smoothed day data with trades and potential trades')
    
    if(~isempty(updown))
        figure(2)
        n=size(updown,1);
        bar([bs1;bs2]')
        legend('simple','multiple');
        title('Buy sell profit/loss')
    end
%     keyboard;
end

% Copies findextrema but works on diff instead of gradient
function[ma,mi,opt,mami]=findextrema_v2(s)
g=diff(s);
d=g(1:end-1).*g(2:end);
is=find(d<=0);
ma=[];mi=[];mami=[];
for i=is
    if(g(i)<g(i+1)) 
        mi=[mi i+1];
        mami=[mami 0];
    else 
        ma=[ma i+1];
        mami=[mami 1];
    end
end
opt=is+2;

% Copies findextrema but with proper indices copying the testsettings
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

% Smoothing function
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