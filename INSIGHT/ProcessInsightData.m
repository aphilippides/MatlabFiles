function ProcessInsightData
% fn='Data240720140034.txt';
% % fn='Data.txt';
% % fn='Data0018.txt';
% fout=[fn(1:end-4) '.mat'];

% this analyses the data
rng('shuffle');
SpikePlots%(fn)

% % pick spike level
% [tlev,smlen]=PickSpikeLevel(fout);

% % get the spike data
% [sp,t]=GetSpikes1(fout);

% this is for when you don't want to run pickSpikeLevel% % tlev=4;  
% only enter the other parameters if you don't want to use the ones already
% found
% % smlen=1001;
% % is=3e5:6e5;
% % [sp,t]=GetSpikes1(fout,tlev,smlen,is);

% % this is legacy and should now all be done in ImportInsightData 
% % ChanNum=GetChannelNames(fn,fout);
% % SaveChannelData(fout)

% this function is legacy
% % GetSpikeCountsAll(fout)

% debugging
% [v,va]=CheckV(t,dat,tlev,smlen);
% keyboard
% save vtemp va v -append


function SpikePlots(fn) %(sp,ChanNum,A_Nodes,B_Nodes,A_Act,B_Act)
if(nargin<1)
    s=dir('SpikeData*.mat');
    WriteFileOnScreen(s,2);
    inp=input('Pick file to process and press return: ');
    f2=s(inp).name;
else
    f2=['Spike' fn(1:end-4) '.mat'];
end

% fn='SpikeData.mat';
load(f2);

As=ChanNum(A_Act);
Bs=ChanNum(B_Act);
Aall=ChanNum(A_Act);
Ball=ChanNum(B_Act);

T=max(t)-min(t);
for i=1:length(sp)
    sp(i).nsp=length(sp(i).sp);
    sp(i).rate=length(sp(i).sp)/T;
end

% plot some basic data
tstr=['A';'B';'C'];
figure(1)
for i=1:3
    ch=ChanAct(i).ch;
    cha=setdiff(ChanAll(i).ch,ch);

    subplot(3,2,2*i-1)
    bar(1:length(ch),[sp(ch).rate],'k'),hold on;
    bar([1:length(cha)]+length(ch)+5,[sp(cha).rate],'w'),hold off;
    ylim([0 max([sp.rate])*1.05])
    ylim([0 min(max([sp.rate]),15)])
    title(['spiking rates ' tstr(i,:) '; active (black) others (white)'])

    subplot(3,2,2*i)
%     v=[sp.v];
%         bar(1:length(ch),[[sp(ch).med]-v(ch);[sp(ch).med]]','Stacked'),hold on;
    bar(1:length(ch),[sp(ch).v],'k'),hold on;
    bar([1:length(cha)]+length(ch)+5,[sp(cha).v],'w'),hold off;
    title(['spike thresholds ' tstr(i,:) '; active (black) others (white)'])
    ylim([0 max([sp.v])*1.05])
end

bin_wid=0.01; %0.005;
x=-0.5:bin_wid:0.5;
Ev_only=1;
% MEAfiringPlot(sp,t,ChanAct(1).ch,ChanNames,x,Ev_only,0,'A to B')
PlotCorrelPlots(sp,t,ChanAct(1).ch,ChanAct(2).ch,x,Ev_only,0,'A to B')
% PlotCorrelPlots(sp,t,ChanAct(2).ch,ChanAct(1).ch,x,1,30,'B to A')

function MEAfiringPlot(sp,t,As,ch,bins,opt,npl,tpl)
istodo=1:length(sp);
ntime=length(bins)-2;
arr=zeros(8);
% dat(ntime).arr=
for j=1:length(As)
    for i=1:length(istodo)
        [re,ra,re_all,ra_all]=GetSpikeCountRaster(sp,t,As(j),istodo(i),bins);
        % plot spikes with windowing or all
        [rp,tst,rpall]=IndivOrAll(re,ra,re_all,ra_all,opt,tpl);        
        chn=ch(i);
        [x,y]=MEAxyPos(chn);
        for k=1:ntime
            dat(k).bin=bins(k+1);
            dat(k).arr(x,y)=rp.fr(k+1);
        end
        dat(k).arr(8,5)=0;
    end
    for k=32:3:72%(ntime-1)
        a=dat(k-1).arr+dat(k).arr+dat(k+1).arr;
        a(8,5)=0;
        imagesc(a);
        title(['response to electrode ' int2str(ch(As(j))) ...
            ' at time ' num2str(dat(k).bin)])
    end
end

function[x,y]=MEAxyPos(ch)
y=mod(ch,10);
x=floor(ch/10);
function quickpl(x,fr,tstr)
plot(x,fr)
hold on,
ys=[0 max(fr(:))];
plot([0.1 0.1],ys,'k:',[0.05 0.05],ys,'r','LineWidth',1),hold off
title(tstr)
axis tight


function GetCopyProtocol(sp,As,Bs,t)
TLim=0.5;
EvLim=1;

% get rid of self spike component
selfspike=0.035;

ta=sort(t([sp(As).sp]));
tb=sort(t([sp(Bs).sp]));
taevs=ta(GetSpikeEvents(ta,EvLim));
tbevs=taevs;
for j=1:length(taevs)
    taevs(j)
    td_in=GetNearSpikeTimes(taevs(j),tb,TLim);
    % get rid of self spikes
    selfs=abs(td_in)<selfspike;
    td_in=td_in(~selfs);
    if(isempty(td_in))
        tbevs(j)=NaN;
        goods(j)=0;
    else
        tbevs(j)=td_in(Randi(length(td_in)));
        goods(j)=1;
    end
end
tbevs=tbevs(goods==1);
taevs=taevs(goods==1);
figure(14)
clf
hist(tbevs,-0.5:.001:0.5)
tbt=tbevs+taevs+0.2;
A.mergedTimes=taevs*1e6;
B.mergedTimes=tbt*1e6;
A.duration=max(A.mergedTimes+5e5);
B.duration=max(B.mergedTimes+5e5);
[A.preppedTimes, duration] = meaPreprocessSpikes(A.mergedTimes, max(A.duration,B.duration), A.params);
[B.preppedTimes, duration] = meaPreprocessSpikes(B.mergedTimes, max(A.duration,B.duration), B.params);
outPath='./test395mins';
save_( A, B, duration, outPath, 'copy', [] );
keyboard


function PlotCorrelPlots(sp,t,As,Bs,x,opt,npl,tpl)

% plot the spikes
% figure(100)
% for i=1:1:length(As)
%     plot(t(sp(As(i)).sp),i,'b.')
%     hold on
% end
% for i=1:1:length(Bs)
%     plot(t(sp(Bs(i)).sp),i+length(As),'r.')
% end 
% hold off
    
[re,ra,re_all,ra_all]=GetSpikeCountRaster(sp,t,As,Bs,x);
% plot spikes with windowing or all
[rp,tst,rpall]=IndivOrAll(re,ra,re_all,ra_all,opt,tpl);

nrow=4;
m=ceil((length(rp)+1)/nrow);
for i=1:length(rp)
    figure(2+npl)
    subplot(nrow,m,i)
    imagesc(x,1:size(rp(i).M,1),rp(i).M)
    title([tst ' Spikes in all from ' int2str(As(i))]);
    figure(3+npl)
    subplot(nrow,m,i)
    tstr=[tst ' Spikes in all from ' int2str(As(i))];
    quickpl(x,rp(i).fr,tstr)
    mp(i,:)=rp(i).fr./sum(rp(i).fr);
end
figure(2+npl)
subplot(nrow,m,nrow*m)
imagesc(x,1:size(rpall.sortM,1),rpall.sortM)
title([tst ' Spikes in all from all ']);
figure(3+npl)
subplot(nrow,m,nrow*m)
quickpl(x,mp,[tst ' Spikes in all from each ']);

% get the copying protocol
% GetCopyProtocol(sp,As,Bs,t)

indivplots=1;
if(~indivplots)
    figure(4+npl)
    imagesc(x,1:size(rpall.sortM,1),rpall.sortM)
    title([tst ' Spikes in all from all, sorted in time']);
    figure(5+npl)
    imagesc(x,1:size(rpall.M,1),rpall.M)
    title([tst ' Spikes in all from all, not time sorted']);
    figure(6+npl)
    quickpl(x,mp,[tst ' Spikes in all from each ']);
    figure(7+npl)
    quickpl(x,mean(mp,1,'omitnan'),[tst ' Spikes in all from all (normalised)']);
else
m=ceil((length(Bs)+1)/nrow);
m2=ceil((length(As)+1)/nrow);
for j=1:length(Bs)
    [re,ra]=GetSpikeCountRaster(sp,t,As,Bs(j),x);
    % plot spikes with windowing or all
    [rp,tst,rpall]=IndivOrAll(re,ra,re_all,ra_all,opt,tpl);

    for i=1:length(rp)
        tstr=[tst ' Spikes in ' int2str(Bs(j)) ' from ' int2str(As(i))];
        % plot spikes in all B nodes caused by 1 A
        figure(4+npl+i),
        subplot(nrow,m,j)
        quickpl(x,rp(i).fr,tstr)
        % plot spikes in all B nodes caused by 1 A
        figure(4+npl+length(rp)+j),
        subplot(nrow,m2,i)
        quickpl(x,rp(i).fr,tstr)
        
        % get all data together
        all(i).m(j,:)=rp(i).fr./sum(rp(i).fr);
        all2(i,:)=rp(i).fr./sum(rp(i).fr);
    end
    subplot(nrow,m2,nrow*m2)
    quickpl(x,all2,[tst ' Spikes in ' int2str(Bs(j)) ' from all']);
%     figure(2+npl)
%     subplot(nrow,m2,nrow*m2)
% imagesc(x,1:size(rpall.sortM,1),rpall.sortM)
%     title([tst ' Spikes in ' int2str(Bs(j)) ' from all']);
end

for i=1:length(rp)
    figure(4+npl+i),
    subplot(nrow,m,m*nrow)
    quickpl(x,all(i).m,[tst ' Spikes in all B from ' int2str(As(i))]);
end
end
% for each A node look at  B nodes
    % one at a time
% load SpikeDataCount.mat
%  sp2=sp;
% for i=1:length(As)
%     figure(i+20)
%     clear sptf sptev re ra
%     for j=1:length(Bs)
%     [spts,spevs,sptf(j,:),sptev(j,:)]=...
%         CollateTimes(sp,i,Bs(j),bin_wid,0);
%         subplot(4,3,j);
% %         plot(x,rp.fr);axis tight;title(int2str(Bs(j)))
%         plot(x,sptev(j,:));axis tight;title(int2str(Bs(j)))
%     end
%     subplot(4,3,length(Bs)+1);
%     plot(x,sptev');axis tight;title('all')
% end

    % all together
%     figure(10)
% for i=1:length(As)
%     clear sptf sptev
%     [spts,spevs,sptf(i,:),sptev(i,:)]=...
%         CollateTimes(sp,As(i),Bs,bin_wid,0);
%     subplot(4,2,i);
%     plot(x,sptev(i,:));axis tight;title(int2str(As(i)))
% end
% subplot(4,2,length(As)+1);
% plot(x,sptev');axis tight;title('all')


function[rp,tst,rpall]=IndivOrAll(re,ra,re_all,ra_all,opt,tpl)
if(opt==1)
    rp=re;  % plot spikes with the window
    rpall=re_all;
    tst=[tpl ', Indiv'];
else
    rp=ra;  % plot all spikes
    rpall=ra_all;
    tst=[tpl ', All'];
end

function[freqs,tot_f]=RasterPlot(r,x)
freqs=zeros(length(r),length(x));
for i=1:length(r)
    freqs(i,:)=hist(r(i).dat,x);
end
tot_f=sum(freqs,1);
% [ps,fs]=GetFreqPeak(tot_f,x)

function[ps,fs]=GetFreqPeak(tot_f,x)
subplot(2,1,1)
GetMaxAndMins(tot_f,x,max(tot_f)*0.05,0.01)
subplot(2,1,2)
GetMaxAndMins(medfilt2(tot_f,[1 3]),x,max(tot_f)*0.05,0.01)
ps=[];
fs=[];
keyboard

function HistPlot(x,sptev,sptf)
subplot(2,1,1)
plot(x,sptev');axis tight;title('events')
subplot(2,1,2)
plot(x,sptf');axis tight;title('all to all')
% ASp=[sp.sp(Bs).all];
% BSp=

function[spts,spevs,yt,ye]=CollateTimes(sp,As,Bs,binw,pl)
spts=[];
spevs=[];
for i=As
    spts=[spts [sp(i).sp_t(Bs).all]];
    spevs=[spevs [sp(i).sp_t(Bs).event]];
end
[ye,x]=hist(spevs,-0.5:binw:0.5);
[yt,x]=hist(spts,-0.5:binw:0.5);
if(pl)
    subplot(2,1,1)
    bar(x,ye);axis tight;title('events')
    subplot(2,1,2)
    bar(x,yt);axis tight;title('all to all')
end

function[rev,rast,revall,rastall]=GetSpikeCountRaster(sp,t,As,Bs,x)

TLim=0.5;
% EvLim=0.5;
EvLim=1;
rast=[];
rev=[];
rastall.t=[];
revall.t=[];
rastall.M=[];
revall.M=[];
for i=1:length(As)
%     i
    spiketimes=t(sp(As(i)).sp);
    sp_events=GetSpikeEvents(spiketimes,EvLim);
    c=1;
    rast(i).sp_t=[];
    rev(i).sp_t=[];
    for j=1:length(spiketimes)
        tA=spiketimes(j);
        t_sps=[];
        % get all spike times
        for k=1:length(Bs)
            tB=t(sp(Bs(k)).sp);
            td_in=GetNearSpikeTimes(tA,tB,TLim);
            t_sps=[t_sps td_in];
        end
        rast(i).sp_t(j).dat=t_sps;
        if(sp_events(j)==1)
            rev(i).sp_t(c).dat=t_sps;
            c=c+1;
        end
    end
    [rast(i).M,rast(i).fr]=RasterPlot(rast(i).sp_t,x);
    [rev(i).M,rev(i).fr]=RasterPlot(rev(i).sp_t,x);
    rastall.t=[rastall.t;spiketimes];
    rastall.M=[rastall.M;rast(i).M];
    revall.t=[revall.t;spiketimes(sp_events)];
    revall.M=[revall.M;rev(i).M];
end
[rastall.sortT,rastall.ord]=sort(rastall.t);
rastall.sortM=rastall.M(rastall.ord,:);
[revall.sortT,revall.ord]=sort(revall.t);
revall.sortM=revall.M(revall.ord,:);


function[td_in]=GetNearSpikeTimes(tA,tB,TLim)
td=tB-tA;
td_in=td(abs(td)<=TLim)';

% define all the electrodes
function SaveChannelData(fout)
load(fout,'ChanNum')
A_Nodes=[17:10:87 28:10:78];
B_Nodes=[12:10:82 21:10:71];
C_Nodes=[13:10:83 14:10:84 15:10:85 16:10:86];

% define the active ones
A_Act=[47 67 77 87 28 68 78];
B_Act=[21 41 51 61 12 22 42 52 62 82];
C_Act=[33 43 53 14 34 44 54 26 76];

% % these are for the 50ms data
% A_Act=[16 23 25 34 46 47 48];
% B_Act=[51 52 53 54 57 61 63 71 72 76 78 82 83];
% C_Act=[];

ChanAct(1).ch=ChanNum(A_Act);
ChanAct(1).name=A_Act;
ChanAct(2).ch=ChanNum(B_Act);
ChanAct(2).name=B_Act;
ChanAct(3).ch=ChanNum(C_Act);
ChanAct(3).name=C_Act;

ChanAll(1).ch=ChanNum(A_Nodes);
ChanAll(1).name=A_Nodes;
ChanAll(2).ch=ChanNum(B_Nodes);
ChanAll(2).name=B_Nodes;
ChanAll(3).ch=ChanNum(C_Nodes);
ChanAll(3).name=C_Nodes;

save(fout,'Chan*','A_*','B_*','C_*','-append');

% this is legacy and can prob soon be got rid of
% f2=[fout(1:end-4) 'Spikes.mat'];
% save(f2,'Chan*','A_*','B_*','C_*','-append');


function GetSpikeCountsAll(fn)
load([fn(1:end-4) 'Spikes.mat'])
fout=[fn(1:end-4) 'SpikeDataCount.mat'];

% get rid of bad channels 45:48
for i=1:length(sp)
    nspike(i)=length(sp(i).sp);
end
bads=find(nspike>1e4);
for i=bads
    badc=find(ChanNum==i);
    disp(['removing data from channels ' int2str(badc)])
    sp(i).sp=[];
end

TLim=0.5;
EvLim=0.5;
for i=1:length(sp)
    spiketimes=t(sp(i).sp);
    sp(i).sp_events=GetSpikeEvents(spiketimes,EvLim);
    for j=1:length(sp)
        hereiam=[i j]
        if 0%(i==j)
            % this is to get rid of selfspikes: not wanted
            sp(i).sp_t(j).all=[];
            sp(i).sp_t(j).event=[];
        else
            tB=t(sp(j).sp);
            t_sps=[];
            t_evs=[];
            % get all spike times
            for k=1:length(spiketimes)
                tA=spiketimes(k);
                td_in=GetNearSpikeTimes(tA,tB,TLim);
                t_sps=[t_sps td_in];
                if(sp(i).sp_events(k)==1)
                    t_evs=[t_evs td_in];
                end
            end
            sp(i).sp_t(j).all=t_sps;
            sp(i).sp_t(j).event=t_evs;
        end
    end
end
for i=1:length(sp)
    sp(i).nspike=length(sp(i).sp);    
    sp(i).nsp=nspike(i);
end
save(fout,'sp','t','Chan*','A_*','B_*','C_*','nspike');

function[is]=GetSpikeEvents(spiketimes,EvLim)
if(isempty(spiketimes))
    is=[];
    return;
end
k=1;
is=zeros(size(spiketimes));
is(1)=1;
while(k<length(spiketimes))
    st=spiketimes(k);
    k=find(spiketimes>(st+EvLim),1,'first');
    if(isempty(k))
        break;
    else
        is(k)=1;
    end
end
is=(is==1)';

function[v,va]=CheckV(t,dat,tlev,smlen)
sdat=dat;
for i=1:(size(dat,2))
    i
    a=dat(:,i);
    as=SmoothVec(a,smlen)';
    sdat(:,i)=as;
    va(i)=iqr(a-as)*tlev;
end
js=0:1e5:length(t);
for i=1:(size(dat,2))
    a=dat(:,i);
    as=sdat(:,i);
    i
    for j=1:length(js)
        is=js(j):(js(j)+3e5);
        if(is(1)<1)
            is=1:3e5;
        elseif(is(end)>length(t))
            is=js(j):length(t);            
        end
        v(i,j)=iqr(a(is)-as(is))*tlev;
    end
end
 
function[ChanNum]=GetChannelNames(fn,fout)
fid=fopen(fn);

for i=1:3
    tl=fgetl(fid);
end
fclose(fid)
ChanNames=ExtractNumbers(tl);
ChanNum=zeros(1,88);
for i=1:88
    c=find(ChanNames==i);
    if(~isempty(c))
        ChanNum(i)=c;
    end
end
save(fout,'ChanNames','ChanNum','-append');


function[tlev,smlen] = PickSpikeLevel(fout)
load(fout)

in1=ForceNumericInput('enter channel number and return: '); %87
in2=ForceNumericInput('enter channel number and return: '); %12
c1=ChanNum(in1);
c2=ChanNum(in2);

is=3e5:6e5;%size(dat,1);
% is=176.4e4:177.4e4;%size(dat,1);
t=t(is);
a=dat(is,c1);
b=dat(is,c2);
smlen=1001;
as=SmoothVec(a,smlen)';
bs=SmoothVec(b,smlen)';
% bs=TimeSmooth(b,t,101);
% am=medfilt1(a,smlen);
% bm=medfilt1(b,smlen);
% toc
tlev=4;
tadd=0.25;
va=iqr(a-as);
vb=iqr(b-bs);
figure(200)
while 1
    da=va*tlev;
    db=vb*tlev;
    spa = ExtractSpikes(a,as,da);
    spb = ExtractSpikes(b,bs,db);
%     spa=a<(as-da);
%     spb=b<(bs-db);
    subplot(2,1,1)
    plot(t,a,t,as,'r',t,as-da,'k',t(spa),a(spa),'r.')
    axis tight
    xlabel(['num spikes = ' int2str(length(spa))])
    title(['Thresh = ' num2str(tlev) '; cursors: +/- ' num2str(tadd) '; return when done; k keyboard'])
    subplot(2,1,2)
    plot(t,b,t,bs,'r',t,bs-db,'k',t(spb),b(spb),'r.')    
    axis tight
    xlabel(['num spikes = ' int2str(length(spb))])
    title(['smoothing = ' num2str((smlen-1)/1000) ])
    
    [x,y,k]=ginput(1);
    if(isempty(x))
        break;
    elseif(isequal(k,30))
        tlev=tlev+tadd;
    elseif(isequal(k,31))
        tlev=tlev-tadd;
    elseif(isequal(k,107))
        keyboard;
    end
end
if(isfile(fout))
    inp=input([fout ' exists; enter 1 to overwrite thresh/smoothing: ']);
    if(isequal(inp,1))
        save(fout,'tlev','smlen','is','-append');
    end
else
    save(fout,'tlev','smlen','is','-append');
end