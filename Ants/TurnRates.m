function[mr,ps,nps,awis,cwis,l1,l2,ralls,rmids,rfasts,rends] = TurnRates(Arcs,os,t,c,angs,angs2,Plotting);
if(nargin<7) Plotting=1; end;
n=3;
rates=zeros(size(os(1:end-n)));
if(nargin<4) c='b'; end;
ao=AngleWithoutFlip(os);
an=AngleWithoutFlip(angs);
ar=AngleWithoutFlip(angs2);
ps=[];nps=[];mr=[];cwis=[];awis=[];
ralls=[];rfasts=[];rmids=[];rends=[];
sss=mod(os+pi,2*pi)-pi;
% gn=medfilt1(MyGradient(AngleWithoutFlip(angs),t));
gn=Medianfilt(MyGradient(AngleWithoutFlip(angs),t));
if(Plotting) figure(2); end;
for i=1:size(Arcs,1)-1
    is=[Arcs(i,3):Arcs(i+1,3)];
    %        plot(t(is)-Arcs(i,1),abs(ao(is)-ao(Arcs(i,3))),c)
    %        plot(t(is)-Arcs(i,1),(ao(is)),[c 'x'])
    %       if((ao(is(1))-ao(is(end))<0)) plot(t(is)-Arcs(i,1),(ao(is))-m,c)
    % % % %     else plot(-t(is)+Arcs(i+1,1),(ao(is)),c)
    %       else plot(t(is)-Arcs(i,1),-ao(is)+m,c)
    %       end
    %     hold on
    %     if((ao(is(1))-ao(is(end))>0)) plot(t(is)-Arcs(i,1),-(ao(is)),[c
    %     ':']);end
    x=t(is);y=ao(is)*180/pi;
    [mr(i),s1,s2,fasts,b,rall,rmid,rfast,rend]=GetRate(x,y);ks=s1:s2;
    l1(i)=length(ks);
    l2(i)=length(fasts);
    ralls=[ralls rall];
    rmids=[rmids rmid];
    rfasts=[rfasts rfast];
    rends=[rends rend];
    %     fasts=is(fasts);
    js=is(ks);njs=setdiff(is,js);%s1=is(s1);s2=is(s2);
    f=hist(angs(js)*180/pi,-180:9:180);ps=[ps;f];
    fn=hist(angs(njs)*180/pi,-180:9:180);nps=[nps;fn];
    if(Plotting)
%         figure(2)
        lb=ceil(l2(i)/2);
        ts=fasts([1:lb:end-1 end]);
        cs=y(ts)-mr(i)*x(ts);
        y1=mr(i)*x(ts(1))+cs;
        y2=mr(i)*x(ts(end))+cs;
        mi=round(median(fasts));
        c=y(mi)-mr(i)*x(mi);
        ny=mr(i)*x(ts)+c;
%         plot(x,y,x(ks),y(ks),'rx',x(fasts),y(fasts),'s',x([s1 s2]),[y1;y2]','r')
        plot(x,y,x(ks),y(ks),'r',x(fasts),y(fasts),'rx',x([s1 s2]),[y1;y2]','k')
        hold on
    end
    %     plot(x,y*180/pi,x(ks),y(ks)*180/pi,'kx',x,angs(is)*180/pi,'r--',x(ks),angs(js)*180/pi,'rx',x([s1 s2]),[y(s1) ny]*180/pi,'r')
    %     figure(4),subplot(1,2,1),bar(-180:9:180,f);xlim([-180 180]);
    %     title(['time ' num2str(x(1)) ' to ' num2str(x(end))]);
    % %     figure(5);bar(-180:9:180,fn);xlim([-180 180]);
    %     subplot(1,2,2),bar(-180:9:180,fn);xlim([-180 180]);
    %     temparcs(i).ts=t(is)-Arcs(i,1);
    %     temparcs(i).as=abs(ao(is)-ao(Arcs(i,3)));
    %     hold off
    
%     % old correlation stuff
%     if(mr(i)<0) awis=[awis angs(js)'];
%     else cwis =[cwis angs(js)'];
%     end
%     [p,r]=corrcoef([an(js),ar(js),ao(js)']);
%     if(length(js)>=5)
%         pjs(i,:)=[length(js) p(1,[3,2]) p(2,3) r(1,[3,2]) r(2,3)];
%     else pjs(i,:)=[length(njs) 0 0 0 0 0 0];
%     end
%     if(length(njs)>=5)
%         [p,r]=corrcoef([an(njs),ar(njs),ao(njs)']);
%         pnjs(i,:)=[length(njs) p(1,[3,2]) p(2,3) r(1,[3,2]) r(2,3)];
%     else pnjs(i,:)=[length(njs) 0 0 0 0 0 0];
%     end
%     if(length(is)>=5)
%         [p,r]=corrcoef([an(is),ar(is),ao(is)']);
%         pis(i,:)=[length(is) p(1,[3,2]) p(2,3) r(1,[3,2]) r(2,3)];
%     else pis(i,:)=[length(njs) 0 0 0 0 0 0];
%     end
end
if(Plotting) hold off; end;

% if(size(Arcs,1)>1)
% figure(3),bar(mr)
% figure(4),bar(-180:9:180,sum(ps));xlim([-180 180]);
% figure(5);bar(-180:9:180,sum(nps));xlim([-180 180]);
% % ps=sum(ps,1)/sum(sum(ps));
% % nps=sum(nps,1)/sum(sum(nps));
% end
% mrs.mr=mr;mrs.pjs=pjs;mrs.pnjs=pnjs;mrs.pis=pis;
% figure(4),plot(pjs(:,2),pjs(:,3),'bo')
% figure(5),plot(pnjs(:,2),pnjs(:,3),'bo',pis(:,2),pis(:,3),'ro')
% mr=mrs;
% figure(3)
% MatchArcs(temparcs(3).ts,temparcs(3).as,temparcs(4).ts,temparcs(4).as)

function[ps,rs]=timecoef(x,y,np)
if(nargin<3) np=20; end;
for i=1:length(x)-np
    [p,r]=corrcoef(x(i:i+np),y(i:i+np));
    ps(i)=p(1,2);rs(i)=r(1,2);
end

function[meanrate,s1,s2,js,b,rsall,rsmid,rsfast,rsends]=GetRate(x,y)
if(length(x)<3)
    b=diff(y)/diff(x);
    s1 = 1;
    s2=length(x);
    js=s1:s2;
    meanrate=b;
    rsall=[];
    rsfast=[];
    rsmid=[];
    rsends=[];
    return
end
b = robustfit(x,y);
g=MyGradient(y,x);
gm=Medianfilt(g);
if(b(2)>=0)
    js=find(gm>b(2));
    if(isempty(js)) [m,js]=max(g); end;
else
    js=find(gm<b(2));
    if(isempty(js)) [m,js]=min(g); end;
end
s1=js(1);
s2=js(end);
b=b(2);
meanrate=mean(gm(js));

% if(abs(meanrate)>1e3)
%     keyboard;
% end

% meanrate=median(gm(js));
if(length(js)<5)
    rsall=[];
    rsfast=[];
    rsmid=[];
    rsends=[];
else
    rsall=gm;
    rsfast=gm(js);
    rsmid=gm(s1:s2);
    rsends=gm([1:(s1-1) s2+1:length(gm)]);
end

function MatchArcs(t1,a1,t2,a2)
tshift=-0.5:0.01:0.5;
for i=1:length(tshift)
    t=t2+tshift(i);
    i1s=[];i2s=[];
    for j=1:length(t)
        [m,ind]=min(abs(t(j)-t1));
        if(m<0.01)
            i1s=[i1s ind];
            i2s=[i2s j];
        end;
    end
    x1=a1(i1s);
    x2=a2(i2s);
    [ms(i),ds(i)]=ArcDiff(x1,x2);
end
[m,ind]=min(ds);
plot(t1,a1,t2+tshift(ind),a2-ms(ind))

function[ms,md]=ArcDiff(x1,x2)
d=x1-x2;
m=mean(d);
s=m-0.5:0.01:m+0.5;
for i=1:length(s)
    ds(i)=sqrt(sum((d+s(i)).^2))/length(d);
end
[md,j]=min(ds);
ms=s(j);