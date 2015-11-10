function AlertingTest
dmat;
cd RHoar/DataNoText/
% cd('C:\Documents and Settings\ROWLAND\My Documents');

s=dir('*.wl');
rp=randperm(length(s));
train=rp(1:5);
rtr=ceil(rand(1,5));
test=rp(6:10);
rtest=ceil(rand(1,5));
train=[1:5]
nPs=[220];
nPrs=[20];
bs=[];
ss=[];
st=200:3e4;
for k=1:length(nPs);
    for i=1:length(nPrs)
        for j=1:5
            fn=s(train(j)).name;
            [T,L1,L2,L3,B,S]=textread(fn,'%s%f%f%f%f%f');
%             [buy sell]=RunData(L1(st)',L2(st)',L3(st)',B(st)',S(st)',nPs(k),nPrs(i));
            [p1,p2,TrTimes]=GetProfit(buysell);
            bsProf1(k,i,j)=sum(p1);
            bsProf2(k,i,j)=sum(p2);

            [p1,p2,TrTimes]=GetProfit(updown);
            udProf1(k,i,j)=sum(p1);
            udProf2(k,i,j)=sum(p2);
           
            bs=[bs;buy]
            ss=[ss;sell]
            lb(j)=length(buy);
            ls(j)=length(sell);
            if(isempty(sell)) as=0;
            else as=sum(sell(:,2));
            end
            if(isempty(buy)) ab=0;
            else ab=sum(buy(:,2));
            end
            Prof(j)=as-ab
            
            save buysell train AllProfs AllBuys AllSells
        end
        bsProfs1(k,i)=sum(bsProf1(k,i,:));
        bsProfs2(k,i)=sum(bsProf2(k,i,:));
        udProfs1(k,i)=sum(udProf1(k,i,:));
        udProfs2(k,i)=sum(udProf2(k,i,:));
    end
end
keyboard
figure(1)
pcolor(bsProfs1)
figure(2)
pcolor(bsProfs2)

figure(1)
pcolor(udProfs1)
figure(2)
pcolor(udProfs2)

function[buys,sells]=RunData(l1,l2,l3,buy,sell,nPoints,nPredict)

NotStillSelling=1;
NotStillBuying=1;
buys=[];
sells=[];sm_len=2;
    ts=GetSecs;
for i=1:length(l1)
    % Read data and write to file/variables
    t(i)=i;
    % Project the lines
    xl=max(1,i-nPoints+1);
    xh=min(i,xl+nPoints-nPredict);
    pvec=xl:xh;
%     [p1,p1s]=PredictPoints(t(pvec),l1(pvec),nPoints,sm_len);
%     [p2,p2s]=PredictPoints(t(pvec),l2(pvec),nPoints,sm_len);
    [p3,tnew]=PredictPoints(t(pvec),l3(pvec),nPoints,sm_len);
    
    % Check for alerts, sound alert and write log
    j=find(tnew==i);
    if(l1(i)>l2(i))
        if(l1(i)<=p3(j))
            if(NotStillSelling) sells=[sells;i sell(i)]; end
        elseif(l3(i)>=p3(j)) NotStillSelling=1;
        end
        
        if(l2(i)>=p3(j))
            if(NotStillBuying) buys=[i buy(i)]; end
        elseif(l3(i)<=p3(j)) NotStillBuying=1;
        end
    end
    if(mod(i,10000)==0)
        i
%        keyboard
    end
end
% figure
% plot(t,l1,'r:',t,l2,'g:',t,l3,'b:',tnew,p3)%,'r',tnew,p2,'g',tnew,p3);
% 
% figure(2)
% plot(times)