function MushPicsNew(pc,p2,ts,D,B)
% DrawReceptorStuff
if(nargin<5) B=50; end;
if(nargin<4) D=3300; end;
for p=[pc]
    [m s i]=GetReceptorMaxes(p,p2,D,B);
    Bit=['pc=' x2str(p) ' L=' int2str(p2) ' D=' int2str(D) ' B=' int2str(B) ' '];
    st=[Bit num2str(m*1e9,2) '  (' num2str(s*1e9,2) ', ' num2str(i*1e9,2) ')   ' num2str(m*1e9,2) '  (' num2str(s*100/m,2) ', ' num2str(i*100/m,2) ')'] 
end
fend=['SSt0_5B' int2str(B) 'Gr1000Inn33Out99Lam' int2str(p2) 'Diff' int2str(D)];
[sep,o,o2]=CalcOverlap2(pc,fend);
ol=['OLap ' num2str(sep*1e9,2) ', ' num2str(o,2) ', ' num2str(o2,2)]
ReceptorOverlap(pc,fend);

% SlicePics(pc,p2,ts)
% LobePics(pc,ts)
% TimePicsDiffPcs(pc,p2)
% TimePicsVs(pc,p2,ts)
% if(nargin<3) ts=[50 100 250]; end;
% SlicePicsVs(pc,p2,ts,D,B)

function ReceptorOverlap(pc,fend,l)
xs=[];ys=[];
for p=pc
    load(['Jitter0Pc' x2str(p) fend 'ReceptMaxes.mat']);
    r=Range(maxes)/100;
    edges=min(maxes)-r:r:max(maxes)+r;
%     [y,x]=hist(maxes,100);
%      xs=[xs x'];
   [y,x]=histc(maxes,edges);
    xs=[xs edges'];
%    ys=[ys (y*100/sum(y))'];
    ys=[ys y'];
end
plot(xs,ys)
% plot(xs,cumsum(ys)/331.3)
set(gca,'FontSize',14);
axis tight
% xlim([0 18.5e-8])
SetXTicks(gca,[],1e9)
xlabel('concentration (nM)')
ylabel('frequency')
% ylabel('Cumulative frequency')
Setbox
if((nargin>2)&(l>0)) hold on,plot([l l]*1e-9, YLim,'k--','LineWidth',2),hold off; end

function[mmax,smax,int_quart]=GetReceptorMaxes(p,l,D,B)
fn=['Jitter0Pc' x2str(p) 'SSt0_5B' int2str(B) 'Gr1000Inn33Out99Lam' int2str(l) 'Diff' int2str(D)];
f=[fn 'ReceptMaxes.mat'];
if(isfile(f))
    load(f);
    if(isequal(Vs,[1:10]))
        int_quart=iqr(maxes);
        iqr(tmaxes);
        mmax=mean(maxes);
        smax=std(maxes);
        return
    end
end

sf=1.324e-4/GetStrengthFact(p,l,D,B);
maxes=[];tmaxes=[];
Vs=1:10;
for i=1:length(Vs)
    mall=load([fn 'V' int2str(Vs(i)) 'Recepts.dat'])*sf;
    [m,ts]=max(mall(:,2:end));
    maxes=[maxes m];
    tmaxes=[tmaxes ts];
end
int_quart=iqr(maxes);
iqr(tmaxes);
mmax=mean(maxes);
smax=std(maxes);
save(f,'maxes','tmaxes','Vs');

function[sf]=GetStrengthFact(p,l,D,B)
fn=['Jitter0Pc' x2str(p) 'SSt0_5B' int2str(B) 'ParamsGr1000Inn33Out99Lam' int2str(l) 'Diff' int2str(D) 'V1.dat'];
fid=fopen(fn);
sf=100;
while 1
    tline=fgetl(fid);
    k=strfind(tline,'StrengthFactor=');
    if(~isempty(k)) 
        sf=str2num(tline(k+15:end));
        if(~isempty(sf)) break; end;
    end
end
fclose(fid);

function DrawReceptorStuff
m2=MushroomPics(0,[0.1 0.5 1 2 2.5 5:2.5:20],1:10,1)
m1=MushroomPics(0,[0.1 0.5 1 2 2.5 5:2.5:20],1:10)
keyboard
%plot([0.1 0.5 1 2 2.5 5:2.5:20],m1)
errorbar([0.1 0.5 1 2 2.5 5:2.5:20],m1(:,1),m1(:,2))
hold on
errorbar([0.1 0.5 1 2 2.5 5:2.5:20],m2(:,1),m2(:,2),'r:')
%plot([0.1 0.5 1 2 2.5 5:2.5:20],m2,'r:')
xlabel('Percentage of KC''s on')
SetYTicks(gca,[],1e9)
ylabel('Interquartile range of peak receptor concentrations (nM)')
ylabel('Mean and SD of peak receptor concentrations (nM)')
ylabel('Median and IQR of peak receptor concentrations (nM)')

function SlicePics(p1,p2,ts)
dmush;cd Mush
h1=load(['Jitter0Pc' x2str(p1) 'SSt0_5B5MaxGr1000Inn33Out99.dat']);
t1=h1(2:end,1)*1000;
h1=load(['Jitter0Pc' x2str(p1) 'SSt0_5B5Gr1000Inn33Out99Line500.dat'])*1.324e-6;
% [m,i]=max(h1);
% plot(i-1)
% figure
h2=load(['Jitter0Pc' x2str(p2) 'SSt0_5B5MaxGr1000Inn33Out99.dat']);
t2=h2(2:end,1)*1000;
h2=load(['Jitter0Pc' x2str(p2) 'SSt0_5B5Gr1000Inn33Out99Line500.dat'])*1.324e-6;
i=0;
for t=ts
    subplot(3,2,2*i+1)
    l=find(t1==t);
    DrawLine(h1(l,375:625))
    ylabel('concentration [nM]')
    subplot(3,2,2*i+2)
    DrawLine(h2(l,375:625)*100)
    l=find(t2==t);
    i=i+1;
end
% xlabel('distance (\mum)')

function SlicePicsVs(pc,la,Times,D,B)
dmush;cd MushParams;
Vs=1:10;
% dmush;cd Tube
p=load(['Jitter0Pc' x2str(pc) 'SSt0_5B' int2str(B) 'MaxGr1000Inn33Out99Lam' int2str(la) 'Diff' int2str(D) 'V1.dat']);
time_ms=p(2:end,1)*1000;
sf=1.324e-4/GetStrengthFact(pc,la,D,B);
for i=1:length(Times)
    [m,l]=min(abs(time_ms-Times(i)));
    ls=[];
    for v=1:length(Vs)
%         h=load(['Jitter0Pc' x2str(pc) 'SSt0_5B50Gr1000Inn33Out99Lam' int2str(la) 'Diff' int2str(D) 'V' int2str(v) 'Line500.dat'])*1.324e-6;
% for small lam's need higher strength fact
h=load(['Jitter0Pc' x2str(pc) 'SSt0_5B' int2str(B) 'Gr1000Inn33Out99Lam' int2str(la) 'Diff' int2str(D) 'V' int2str(Vs(v)) 'Line500.dat'])*sf;
          ls=[ls; h(l,:)];
          if(i==1)
              ts(v,:)=[h(:,500)'];
              [maxCent(v),maxTime(v)] = max(h(:,500));
              dt=find(h(maxTime(v):end,500)<=(0.5*maxCent(v)),1);
              if(isempty(dt)) DropTime(v)=NaN;
%              elseif(dt==1) DropTime(v)=maxTime(v);
              else
                  dt=dt+MaxTime(v)-1;
                  c=(0.5*maxCent(v)-h(dt,500))/(h(dt-1,500)-h(dt,500));
                  DropTime(v)=time_ms(dt-1)*c+time_ms(dt)*(1-c);
              end
              maxTime(v)=time_ms(v);
          end
    end
%     load(['SlicePicsB' int2str(B) 'DataPc' x2str(pc) 'Lam' int2str(la) 'Diff' int2str(D) 'Vs1_10.mat'])   
%    eval(['ls=t' int2str(l) ';'])
%    plot([0:length(ls)-1],[max(ls');min(ls')]','b','LineWidth',0.5)
    figure(i)
    plot(-249.5:0.5:250,ls(Vs,:),'r','LineWidth',0.5)
    hold on
    plot(-249.5:0.5:250,mean(ls),'k','LineWidth',2)
    hold off
    
    if(i==1)
        m=mean(ls);
        s=std(ls);
        wallmean=mean(m([401:467 533:599]));
        coremean=mean(m([468:532]));
        wallstd=mean(s([401:467 533:599]));
        corestd=mean(s([468:532]));
        mmaxCent=mean(maxCent);
        smaxCent=std(maxCent);
        mmaxTime=mean(maxTime);
        mdropTime=mean(DropTime);
        w=[[wallmean wallstd]*1e9 wallstd*100/wallmean]
        c=[[coremean corestd]*1e9 corestd*100/coremean]
        ce=[[mmaxCent smaxCent]*1e9 smaxCent*100/mmaxCent]
        cet=[mmaxTime mdropTime]
    end    
    eval(['t' int2str(l) '=ls;'])
    set(gca,'FontSize',14)
    Setbox
    %axis([0 500 0 1300e-9])
    SetYTicks(gca,[],1e9)
    ylabel('concentration [nM]')
    xlabel('distance (\mum)')
    axis tight
end
save(['SlicePicsB' int2str(B) 'DataPc' x2str(pc) 'Lam' int2str(la) 'Diff' int2str(D) 'Vs1_10.mat'],'t*','core*','wall*','*Cent','*Time')

function DrawLine(l)
plot(-125:125,l)
max(max(l))
Setbox
axis([-125 125 0 1300e-9])
SetYTicks(gca,[],1e9)

function LobePics(p,ts)
dmush;cd Mush
h=load(['Jitter0Pc' x2str(p) 'SSt0_5B50Gr1000Inn33Out99V1Line500.dat'])*1.324e-6;
for t=ts
    m=load(['Jitter0Pc' x2str(p) 'SSt0_5B50Gr1000Inn33Out99V1T' int2str(t) '.dat'])*1.324e-6;
    max(max(m))
    figure,SquareAx
    pcolor(m),shading interp,caxis([0 305e-9])
%    surfl(m),ZLim([0 175e-9]),XLim([1 260]),YLim([1 260]),shading interp
    figure, SquareAx
    plot(-100:0.5:100,h(t/5+1,300:700))
    YLim([0 3e-7])
    set(gca,'FontSize',14)
    Setbox, SetYTicks(gca,[],1e9)
    ylabel('concentration [nM]'), xlabel('distance (\mum)')
end

function TimePicsDiffPcs(pcs,l)
dmush;cd Mush
ls=[];
for p=pcs
    p                  
    h1=load(['Jitter0Pc' x2str(p) 'SSt0_5B50Gr1000Inn33Out99V1Line500.dat'])*1.324e-6;
%    ls=[ls h1(:,l)/p];
    ls=[ls h1(:,l)];
end
max(ls)
plot([0:5:500],ls);
hold on
plot([0:5:500],ls(:,3)*10,'g:');
hold off
set(gca,'FontSize',14)
Setbox
%axis([0 500 0 1300e-9])
SetYTicks(gca,[],1e9)
ylabel('concentration [nM]')
xlabel('time (ms)')
axis tight
figure
plot(pcs,max(ls),'bx')
hold on
plot(10,max(ls(:,3))*10,'gx');
x=regress(max(ls)',[ones(size(pcs')) pcs']);
plot([0 10],x'*[1 0;1 10]','r')
hold off
set(gca,'FontSize',14)
Setbox
%axis([0 500 0 1300e-9])
SetYTicks(gca,[],1e9)
ylabel('concentration [nM]')
xlabel('time (ms)')
axis tight

function TimePicsVs(pc,Vs,Lines)
% dmush;cd Mush
dmush;cd Tube
for l=Lines
    l
    ls=[];
    for v=Vs
%         h=load(['Jitter0Pc' x2str(pc) 'SSt0_5B50Gr1000Inn33Out99V' int2str(v) 'Line500.dat'])*1.324e-6;
%         ls=[ls h(:,l)];        
    end
%    load(['TimePicsB50DataPc' x2str(pc) 'Vs1_10.mat'])   
    load(['TimePicsB50DataPc' x2str(pc) 'Vs1_5.mat'])   
    eval(['ls=l' int2str(l) ';'])
%    plot([0:length(ls)-1],[max(ls');min(ls')]','b','LineWidth',0.5)
%    figure
    plot([0:length(ls)-1]*5,ls(:,Vs),'r','LineWidth',0.5)
    hold on
    plot([0:length(ls)-1]*5,mean(ls'),'k','LineWidth',2)
    eval(['l' int2str(l) '=ls;'])
end
clear ls l
% save(['TimePicsB50DataPc' x2str(pc) 'Vs1_10.mat'],'l*')
% save(['TimePicsB50DataPc' x2str(pc) 'Vs1_5.mat'],'l*')
hold off
set(gca,'FontSize',14)
Setbox
%axis([0 500 0 1300e-9])
SetYTicks(gca,[],1e9)
ylabel('concentration [nM]')
xlabel('time (ms)')
axis tight

function[ov]=CalcOverlap(pc,fend,n)
if(nargin<3) n=500; end;
xs=[];ys=[];ov=[];
load(['Jitter0Pc' x2str(pc(1)) fend 'ReceptMaxes.mat']);
m1=maxes;
for p=pc(2:end)
    load(['Jitter0Pc' x2str(p) fend 'ReceptMaxes.mat']);
    l=min(m1);
    h=max(maxes);
    edges=l:(h-l)/n:h;
    y=histc(maxes,edges);
    y1=histc(m1,edges);
    c1=cumsum(y1)/sum(y1);
    c2=cumsum(y)/sum(y);
    p1=y1/sum(y1);
    p2=y/sum(y);
    i1=min(find(c2>(1-c1)));
    i2=max(find(c2<(1-c1)));
    i=round(0.5*(i1+i2));
    ov=[ov; 1-c1(i) c2(i)];
end
ov=ov*100
s=sum(ov,2)
bar([ov s])

function[sep,ov,ov2]=CalcOverlap2(pc,fend,n)
if(nargin<3) n=97.5; end;
ov=[];
ov2=[];
sep=[];
load(['Jitter0Pc' x2str(pc(end)) fend 'ReceptMaxes.mat']);
lev=mean(maxes)-std(maxes);%prctile(maxes,n);
m1=maxes;
for p=pc(1:end-1)
    load(['Jitter0Pc' x2str(p) fend 'ReceptMaxes.mat']);
    % need pc to be in descending order
    m=mean(maxes)+std(maxes);
    sep =[sep lev-m];
    %    sep=[sep prctile(maxes,100-n)-lev]; 
    ov=[ov length(find(maxes>=lev))*100/length(maxes)];
    ov2=[ov2 length(find(m1<=m))*100/length(maxes)];
end