function AlertingTest
% cd('C:\Documents and Settings\ROWLAND\My Documents');

s=dir('*.wl');
rp=randperm(length(s));
train=rp(1:5);
rtr=ceil(rand(1,5));
test=rp(6:10);
rtest=ceil(rand(1,5));
train=[1:10 13:15];
% nPs=[50:5:100 105:10:400];
% nPrs=[0:2:60];

nPs=[85:5:120];
nPrs=[40:2:80];

bs=[];
ss=[];
for k=1:length(nPs);
    k
    for i=1:length(nPrs)
        for j=1:length(train)
            ts=GetSecs;
            fn=s(train(j)).name;
            [T,L2,L3,L1,B,S]=textread(fn,'%s%f%f%f%f%f');
            b=find(strcmp(T,'08:02:00'));
            if(isempty(b)) b=1; end;
            e=find(strcmp(T,'16:29:00'));
            if(isempty(e)) e=length(T); end;
            st=b:e;            
           [buysell,updown]=RunData(L1(st)',L2(st)',L3(st)',B(st)',S(st)',nPs(k),nPrs(i));            
            fout=['buysellSet' int2str(j) '_Pts' int2str(nPs(k)) '_Pred' int2str(nPrs(i)) '.mat'];
            save(fout,'buysell','updown','fn','st','T')
%            GetSecs-ts
%            load(fout)
            [p1,p2,TrTimes]=GetProfit(buysell,1);
            bsProf1(k,i,j)=sum(p1);
            bsProf2(k,i,j)=sum(p2);
            NumTrades(k,i,j)=size(buysell,1);
            
            [p1,p2,TrTimes]=GetProfit(updown);
            udProf1(k,i,j)=sum(p1);
            udProf2(k,i,j)=sum(p2);
        end
         bsProfs1(k,i)=sum(bsProf1(k,i,:));
        bsProfs2(k,i)=sum(bsProf2(k,i,:));
        udProfs1(k,i)=sum(udProf1(k,i,:));
        udProfs2(k,i)=sum(udProf2(k,i,:));
        NumTradesAvg(k,i)=sum(NumTrades(k,i,:));
    end
        save ProfitData bsProfs1 bsProfs2 udProfs1 udProfs2 bsProf1 bsProf2 udProf1 udProf2 NumTradesAvg NumTrades
end
keyboard
figure(1)
pcolor(bsProfs1/5),colorbar
figure(2)
pcolor(bsProfs2/5),colorbar

figure(1)
pcolor(udProfs1/5),colorbar
figure(2)
pcolor(udProfs2/5),colorbar

function[buysell,updown]=RunData(l1,l2,l3,buy,sell,nPoints,nPredict)

NotStillSelling=1;
NotStillBuying=1;
NotStillUp=1;
NotStillDown=1;
buysell=[];
updown=[];sm_len=2;
for i=1:length(l1)
    % Read data and write to file/variables
    t(i)=i;
    % Project the lines
    xl=max(1,i-nPoints+1);
    xh=min(i,xl+nPoints-nPredict);
    pvec=xl:xh;
    [p1,tnew]=PredictPoints(t(pvec),l1(pvec),nPoints,sm_len);
    [p2,tnew]=PredictPoints(t(pvec),l2(pvec),nPoints,sm_len);
    [p3,tnew]=PredictPoints(t(pvec),l3(pvec),nPoints,sm_len);
    
    % Check for alerts, sound alert and write log
    j=find(tnew==i);
    if(l1(i)>l2(i))
        if(l1(i)<=p3(j))
            if(NotStillSelling) 
                buysell=[buysell;i 0 sell(i)];
                NotStillSelling=0;
            end
        elseif(l3(i)>=p3(j)) NotStillSelling=1;
        end
        
        if(l2(i)>=p3(j))
            if(NotStillBuying) 
                buysell=[buysell;i 1 buy(i)]; 
                NotStillBuying=0;
            end
        elseif(l3(i)<=p3(j)) NotStillBuying=1;
        end
        
        if(l1(i)<=p2(j))
            if(NotStillDown) 
                updown=[updown;i 0 sell(i)];
                NotStillDown=0;
            end
        elseif(l3(i)>=p2(j)) NotStillDown=1;
        end

        if(l2(i)>=p1(j))
            if(NotStillUp) 
                updown=[updown;i 1 buy(i)];
                NotStillUp=0;
            end
        elseif(l3(i)<=p1(j)) NotStillUp=1;
        end
    end
%     if(mod(i,10000)==0)
%         i
% %        keyboard
%     end
end
% figure
% plot(t,l1,'r:',t,l2,'g:',t,l3,'b:',tnew,p3)%,'r',tnew,p2,'g',tnew,p3);
% 
% figure(2)
% plot(times)