function wholeflightstats(fltsec)

LoopPsi
% this plots individual loops from flights
% [fn,tg]=PlotLoops%;(2 ,3);%[1 2])
% axis([-6 21 -12 15])
% figure(11)
% BeePathLooking(fn,10,tg)
return

% DistanceCompLoops
% TimeComparisonLoopsZZs
% PlotSpeedStats


% get coincident points as per 2nd option: 3 psi=0; 2 f2n=0; 1 both (default)
% 1st option is outs vs ins via loops file: loopstatstemp is outs, loopstatsIn = ins
% default is loopstatstemp
% GetCoincidentPoints('loopstatstemp',3)  % does outs with psi=0
load CoinPointsLoop
PlotCoinPoints(Coins,1.5,LM,LMWid,5,'k')
% GetCoincidentPoints('loopstatsIn',3)   % does ins with psi=0
load CoinPointsZZ
PlotCoinPoints(Coins,1.5,LM,LMWid,0,'r')


load loopstatstemp
load loopstatsIn
ppsi=[];nor=[];
for i=1:length(loops)
    ppsi=[ppsi;[loops(i).fdir]];
    nor=[nor;[loops(i).nor]];
end
figure(3)
[y,x]=AngHist(nor*180/pi);
[y,x]=AngHist(nor(abs(ppsi)<(pi/18))*180/pi);
[y,x]=AngHist(ppsi(abs(nor)<=(pi/18))*180/pi);
plot(x,y/sum(y),'g:')


% StraightFigs2
% FlightDirAndBodyRel2CompassAndNest
% LoopFig7

% PlotAllData('allratesout',1)%figure(3),
% PlotAllData('allratesin',0)
% return

% 
% stuff to get number of bees and flights in loops and ZZs
% clear bee fnum
% for i=1:size(cocw,1)
% %     fn_n=fltsec(cocw(i,12)).fn;
%     fn_n=loops(cocw(i,12)).fn;
%     [out,bee(i),fnum(i)]=ProcessBeeFilename(fn_n);
% end
% bfc=unique([bee;fnum]','rows')
% [size(cocw,1) size(bfc,1) size(unique(bee),2)]
% clear bee fnum
% for i=1:size(coaw,1)
%     fn_n=fltsec(coaw(i,12)).fn;
% %     fn_n=loops(coaw(i,12)).fn;
%     [out,bee(i),fnum(i)]=ProcessBeeFilename(fn_n);
% end
% bfa=unique([bee;fnum]','rows')
% [size(coaw,1) size(bfa,1) size(unique(bee),2)]

% allloopdata;return
% % load ../2' east all'/temp2EZZPhaseDataAll.mat
% % load temp2WZZPhaseDataAll.mat
% % datZ=PlotStarts(starts,LM,LMWid,-1,cocw(:,8:end),coaw(:,8:end),fltsec)
% % % % 
% % % load ../2' east all'/temp2ELoopPhaseDataAll' Old'
% load ../2' east all'/temp2ELoopPhaseDataAll
% load temp2WLoopPhaseDataAll
% datL=PlotStarts(starts,LM,LMWid,2,cocw(:,8:end),coaw(:,8:end),loops)
% save tempStarts datZ datL
% % tempPlotStarts(datL,datZ)
% 
% plotPhaseStuff(PhDat)
% % startse=starts;
% % me=PhDat.m1;
% % [y1,x]=AngHist(me(:,27));
% % [y2,x]=AngHist(me(:,29));
% % % PlotStarts(startse,LM,LMWid,2)
% % 
% % % PlotLoopPsi(psicw,psiaw,f2ncw,f2naw,cocw,coaw,ipl,pea,...
% % %     cwin*180/pi,awin*180/pi,cwout*180/pi,awout*180/pi)
% % % 
% load ../2' east all'/temp2ELoopPhaseDataAll
% cocwL=cocw;coawL=coaw;
% % PlotStarts(starts,LM,LMWid,2,cocwL(:,8:end),coawL(:,8:end),loops,f2n0cw,f2n0aw)
% % % % figure(1); hold on; figure(2); hold on
% % load temp2WZZPhaseDataAll
% load ../2' east all'/temp2EZZPhaseDataAll
% % PlotStarts(starts,LM,LMWid,-1,cocw(:,8:end),coaw(:,8:end),fltsec,f2n0cw,f2n0aw)
% figure(3),[m3,n3]=CheckCoincidence(cocw,cocwL,loops,fltsec,20);
% figure(4),[m4,n4]=CheckCoincidence(coaw,coawL,loops,fltsec,30);
% CheckAllCoincidences
% return
% % [y1,x]=AngHist(psi0cw(:,3)*180/pi);[y2,x]=AngHist(psi0aw(:,3)*180/pi);
% % [y3,x]=AngHist(f2n0cw(:,3)*180/pi);[y4,x]=AngHist(f2n0aw(:,3)*180/pi);
% % [y5,x]=AngHist(cocw(:,10)*180/pi);[y6,x]=AngHist(coaw(:,10)*180/pi);
% % subplot(1,2,2),plot(x,y2/sum(y2),x,y4/sum(y4),'r:'),axis tight
% % subplot(1,2,1),plot(x,y1/sum(y1),x,y3/sum(y3),'r:'),axis tight
% % subplot(1,2,2),plot(x,y2/sum(y2),x,y4/sum(y4),'r:',x,y6/sum(y6),'k--'),axis tight
% % subplot(1,2,1),plot(x,y1/sum(y1),x,y3/sum(y3),'r:',x,y5/sum(y5),'k--'),axis tight
% %
% keyboard
% stuff to lot starts to coincidents
% cocw=coaw;MotifFigs(gcf,2)
% plot(cocw(:,end-1),cocw(:,end),'ko',cocw(:,8),cocw(:,9),'k.')
% hold on
% plot(cocw(:,[8 end-1])',cocw(:,[9 end])','k')
% PlotNestAndLMs(LM,LMWid,[0 0],0,1,1);hold off; 

% 
% load ../2' west'/temp2WLoopPhaseDataAll
% PlotStarts(startse,LM,LMWid,2)
% mw=PhDat.m1;
% [y3,x]=AngHist(mw(:,27));
% [y4,x]=AngHist(mw(:,29));
% MotifFigs(gcf,1);
% d=[y1' y2' y3' y4'];[sum(d) size(me) size(mw)]
% bar(x,[y1' y2'],1)
% axis tight,xlabel('starting angle'),ylabel('n'),Setbox
% colormap gray
% return;

%     load ../2' east all'/temp2ELoopPhaseData.mat;
% awout=[awout;eawout];cwout=[cwout;ecwout];
% awin=[awin;eawin];cwin=[cwin;ecwin];
%     plotPhaseStuff(ephdat)
% %     plotPhaseStuff(PhDat)
% %     plotPhaseStuff(PhDat,ephdat)
%  return

% RunLoopStats
% load tempzz
% 
% keyboard

% for i=5:25
%     str=['Len' int2str(i) '_' int2str(i+1)]; 
%     AllRates('in',1:5,['2E2W_1NEW_2007' str],[i i+1])
%     AllRates('out',1:5,['2E2W_1NEW_2007' str],[i i+1])
% end

% figure(1)
% % st=plotratesNest('allratesout','all data rel 2 nest')
% st=plotrates('allratesout2E2W_1NEW_2007','outs')
% % st=plotrates('allratesout2E2W','2E 2W outs')
% % figure(2)
% st=plotrates('allratesin2E2W_1NEW_2007','returns')
% st=plotrates('allratesin2E2W','2E 2W returns')
% figure(3),st=plotrates('2e2wlooprates','2e 2w loops')
% figure(4),st=plotrates('2e2wZZrates','2e 2w ZZs')
% % figure(3),st=plotrates('allratesout','all data')
% % figure(4),st=plotrates('allratesoutLen5_6','outs len 5-6')
% figure(5),st=plotrates('allratesoutLen10_11','outs len 10-11')
% % figure(6),st=plotrates('allratesoutLen15_16','all data')
% figure(7),st=plotrates('allratesoutLen20_21','outs len 20-21')
% 
% st=plotrates('loopstatsrates','loops')
% st=plotrates('circlingstatstemp','circling')
% st=plotrates('doublelooprates','double loops')
% st=plotrates('zigzagrates','zigzags')

% loopstats([],'circlingstatstemp')
% return

% AllRates('out',1:2,'2E2W')
% AllRates('in',1:2,'2E2W')
% AllRates('in',1:7,'Len4_5',[4 5])
% AllRates('in',1:7,'Len8_9',[8 9])
% AllRates('out',1:7,'Len20_21',[20 21])
% AllRates('out',1:7,'Len25_26',[25 26])
% AllRates('out',1:2,'2LMs')
% AllRates('in',1:2,'2LMs')
% AllRates('out',3:6,'SingleLMs2007')
% AllRates('in',3:6,'SingleLMs2007')
% AllRates('out',3:7,'SingleLMs')
% AllRates('in',3:7,'SingleLMs')
% figure(1),[y1,y2,y3,y4,x]=PlotAllData('allratesout2E',1,'k')
% figure(2),[r1,r2,r3,r4,x]=PlotAllData('allratesin2E',0,'k:')
% 
% for i=1:4
%     eval(['y=y' int2str(i) ';'])
%     p1=(y+eps)/sum(y+eps);
%     eval(['r=r' int2str(i) ';'])
%     p2=(r+eps)/sum(r+eps);
%     kl(i)=kldiv(x,p1,p2,'sym');
% end
% 
% figure(3),[y1,y2,y3,y4,x]=PlotAllData('allratesout2W',1,'k')
% figure(4),[r1,r2,r3,r4,x]=PlotAllData('allratesin2W',0,'k:')
% keyboard
% AllRates('out',1,'2E')
% AllRates('in',1,'2E')
% AllRates('out',2,'2W')
% AllRates('in',2,'2W')
% 

% 
% dwork
% cd bees\bees07\WholeFlightStats\
% PlotAllData('allratesout',1)%figure(3),
% PlotAllData('allratesin',0)
% [sfs]=StraightFigs;
% return
origdir=cd;
% for i=1:6
st=[];df2n=0;dpsi=0;drsp=0;drsp2=0;dras=0;
lts=[];y2s=[];o2s=[];zys=[];oys=[];ts=[];relspeed=[];ra_f2n=[];
cols=['b';'g';'r';'k';'c';'c';'c'];
for i=[1:2]
%     subplot(111)
% figure(i)
    changedir(i);
%     [t,y2,o2]=PercentFlightsLorZZ(2,i);ts=[ts;t];y2s=[y2s;y2];o2s=[o2s o2];
%         [lt,y2,o2,zy,oy,t]=GetOverlapOut(i,20);    
%        o2s=[o2s lt];zys=[zys y2]; ts=[ts t];

% % this to do outs
[lt,y2,o2,zy,oy,t]=LoopPsi(i);

% get psi values in the loops
%     CheckCoincidentPonts('NestCoDatOut')
%     ProcessNestCoin('NestCoDatFinal')
% [lt,y2,o2,zy,oy,t]=LoopPsi(i,'loopstatsIn.mat');

[lt,y2,o2,zy,oy,t]=ZigZagPsi(i);
% lts=[lts;lt];y2s=[y2s;y2];o2s=[o2s;o2];zys=[zys;zy];oys=[oys;oy];ts=[ts;t];
%      [lt,y2,o2,zy,oy,t]=GetOverlapIn(i);
%      ts=[ts;t];
%       [lt,y2,o2,zy,oy,t]=ZZContours(i);
%     [lt,y2,o2,zy,oy,t]=ZZTimeDistributions(i);
%     if(i==1) lts=lt;y2s=y2;o2s=o2;zys=zy;oys=oy;
%     else lts=lts+lt;y2s=y2s+y2;o2s=o2s+o2;zys=zys+zy;oys=oys+oy;
%     end
%     [lt,y2,o2,zy,oy,t]=LoopTimeData;
%       [lt,y2,o2,zy,oy,t,rels,rf]=LoopSpeeds;
%      [lt,y2,o2,zy,oy,t,rf]=ZZSpeeds('in',i);
%       lts=[lts;lt'];y2s=[y2s;y2'];o2s=[o2s;o2];
%     lts=[lts lt];y2s=[y2s y2];oys=[oys oy];o2s=[o2s o2];zys=[zys zy];ts=[ts t];
%     
%        relspeed=[relspeed rels];
%     df2n=df2n+t;drsp=drsp+y2;
%     dras=dras+lt;drsp2=drsp2+o2;
%     dpsi=dpsi+oy;
%        ra_f2n=[ra_f2n rf];
%        zspeedstats(i).s=rf; %lspeedstats(i).s=rf;
% %     [m,s]=allLoopdata;
% %     st=[st;m s];
% 
%     AllData('in')
%     load allratesout
%     [dat,xp]=StatsOverX(allts,allsp);
%     dm=[dat.med];
%     errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm,cols(i))
%     hold on
    str=cd;sp=findstr(str,'\');

% % this bit to get the overlapping loop/zz straight bits
%     load loopsOverlap langs e2st st2e
%     olap(i).LAll=langs;
%     olap(i).LOlap=e2st;
%     olap(i).LOut=st2e;
%     olap(i).ZAll=o2;
%     olap(i).ZOlap=lt;
%     olap(i).ZOut=y2;
%     olap(i).dir=str;

    title(str(sp(end)+1:end))
    cd(origdir);
end
% save StraightOlapData olap
return
zstats=ra_f2n;%lstats=ra_f2n;
save ZZSpeedStats2007_t05 df2n dpsi dras drsp drsp2 zstats zspeedstats% save LoopSpeedStats2007 lstats lspeedstats
xps=-160:20:180;xp2s=-180:20:180;
yps=0.05:.1:.95;n=1;
yps=0.025:.05:.975;n=1;
figure(6)
subplot(1,2,1),contourf(xp2s,yps(n:end),df2n(n:end,[end 1:end])),xlabel('fdir rel to nest')
subplot(1,2,2),contourf(xp2s,yps(n:end),dpsi(n:end,[end 1:end])),xlabel('psi')
g=colormap('gray');colormap(g(end:-1:1,:))
figure(7)
xps=0:60:480;
subplot(2,2,1),contourf(xps,yps(n:end),dras(n:end,:)),xlabel('fdir rel to nest')
xps=0.025:.05:0.975;
subplot(2,2,2),contourf(xps,yps(n:end),drsp(n:end,:)),xlabel('psi')
subplot(2,2,4),contourf(xps,yps(n:end),drsp2(n:end,:)),xlabel('psi')
g=colormap('gray');colormap(g(end:-1:1,:))

hold off
thd=20;
thdiv=[-180:thd:180+thd]-thd/2;
thdiv2=[0:thd:360+thd]-thd/2;
% save tempzz1_2
return
PlotLoopPsi(lts,y2s,o2s,zys,oys,ts,6)
% keyboard
fnum=0;
% loop/straight overlap figs
psiolap=o2s;colap=zys;folap=oys;tolap=ts;
figure(fnum+3),subplot(2,3,6),[Dpsif,xs,ys,xps,yps]=Density2D(psiolap,folap,thdiv,thdiv);
contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
xlabel('\psi'),ylabel('Flight dir rel to nest')
figure(fnum+4),subplot(2,3,6),[Dpsic,xs,ys,xps,yps]=Density2D(psiolap,colap,thdiv,thdiv2);
contourf(xps,yps,max(Dpsic(:))-Dpsic);axis equal;axis tight;
xlabel('\psi'),ylabel('Flight direction')
% load tempLooptimes
[yp,x]=hist(ts((ts>=-0.5)&(ts<=1.5)),-0.5:.1:1.5);yto=yp/sum(yp);
mdt=oys;[yp,x]=hist(mdt((mdt>=-0.5)&(mdt<=1.5)),-0.5:.1:1.5);yt2=yp/sum(yp);
% mdt2=lts;[yp,x]=hist(mdt2(abs(mdt2)<=1.5),-1.5:.1:1.5);yt2=yp/sum(yp);
% figure(fnum+2),subplot(2,3,6),
plot(x,yto,x,yt2,'r:');axis tight,xlim([-.5 1.5])
% f0angs=lts;f0ins=ts;f0outs=y2s;
% figure(21),subplot(2,3,6)
% [yp,x]=AngHist(f0ins(:,1)*180/pi);[yf,x]=AngHist(f0outs(:,1)*180/pi);[yc,x]=AngHist(f0angs*180/pi);
[yp,x]=AngHist(lts*180/pi);[yf,x]=AngHist(y2s*180/pi);[y,x]=AngHist(ts);yc=y/sum(y);
plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight%
% figure(25),subplot(2,3,6)
% plot(f0ins(:,1)*180/pi,f0ins(:,2)*180/pi,'o',f0outs(:,1)*180/pi,f0outs(:,2)*180/pi,'rx');axis tight

% straight line angle plots
is=[35 36 1:36 1];the=-190:10:190;
[y,x]=AngHist(o2s*180/pi);a=y/sum(y);[y,x]=AngHist(zys*180/pi);c=y/sum(y);
[y,x]=AngHist(lts*180/pi);b=y/sum(y);[y,x]=AngHist(y2s*180/pi);d=y/sum(y);
plot(the,a(is),the,b(is),'r:')%,the,c(is),'k:x',the,d(is),'k:')
% plot(the,(b(is)+d(is))*0.5,'r:')%,the,c(is),'k:x',the,d(is),'k:')
axis tight;ya=ylim;ylim([0 ya(2)]);ylabel('frequency')%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

% contour speed plots
ra_s=lts;ra_c=y2s;lspeed=o2s;dco=zys;ra_f=oys;tz2=ts;
[Ds,xs,ys,xps,yps]=Density2D(relspeed,ts,0:0.05:1,0:0.05:1);
[dat,xp]=StatsOverX(ts,relspeed,0:0.05:1);
% [Ds,xs,ys,xps,yps]=Density2D(y2s,ts,0:0.05:1,0:0.05:1);
clf;subplot(1,2,1),contourf(xps,yps,-Ds+max(Ds(:))),
% [dat,xp]=StatsOverX(ts,y2s,0:0.05:1);
hold on; plot([dat.med],xp,'w','LineWidth',2); hold off;
xlabel('Translational speed (normalised)'),ylabel('Time (normalised)')
divi=-60:60:780;caxis/length(ra_s)
[Db,xs,ys,xps,yps]=Density2D(abs(ra_s),ts,divi,0:0.025:1);
[dat,xp]=StatsOverX(ts,abs(ra_s),0:0.025:1);
figure(9),%subplot(1,2,2),
contourf(xps,yps,-Db+max(Db(:))),
hold on; plot([dat.med],xp,'w','LineWidth',2); hold off;
xlabel('Rotational speed (deg/s)'),ylabel('Time (normalised)')
axis([20 780 0.025 .975])%
axis([0 780 0 1])

% plots for length of zigzags in flights
x=round([median(lts) median(zys)])
sum(zys>0)/length(zys)
sum(lts>0)/length(lts)
x=round([median(lts(lts>0)) median(zys(zys>0))])
subplot(3,2,6)
[y,x]=hist(lts,0:5:75);yi=y/sum(y);
[y,x]=hist(zys,0:5:75);yo=y/sum(y);
plot(x,yo,x,yi,'r:'),axis tight

[y,x]=AngHist(lts*180/pi);yi=y/sum(y);
[y,x]=AngHist(y2s*180/pi);yo=y/sum(y);
plot(x,yi,x,yo,'r:'),axis tight


s=y2s; 
round(1000*[median(s) iqr(s) mean(s) std(s) length(s)/1e3])
subplot(2,1,1)
plot(x,lts/sum(lts),x,y2s/sum(y2s),'r--',x,zys/sum(zys),'k:')
axis tight,title('ins')
subplot(2,1,2)
plot(x,lts/sum(lts),x,o2s/sum(o2s),'r--',x,oys/sum(oys),'k:')
axis tight,title('outs')

round(st)
cd(origdir);

function[e2st,st2e,psiolap,colap,folap,tolap]=GetOverlapOut(ipl,fnum)

% loopfns={'Loopssingle_2east.mat';'Loopssingleloops_2west.mat';...
%     'Loopsloopsingle_west8.mat';'LoopssingleloopsN8.mat'; ...
%     'Loopssingle_east8.mat';'';'Loopssingleloops_1north2008.mat'};
% linefns={'straight_2east_outData.mat';'straight_2westoutData.mat';...
%     'straight_west8_outData.mat';'straight_out_north8_2007Data.mat'; ...
%     'straight_east8_outData.mat'};
% load(char(loopfns(ipl)))
% load(char(linefns(ipl)))
% 
load processflightsecOut

load loopstatstemp
eval('ppsiL=psi;');
eval('c_os=cos;');

thd=20;
thdiv=[-180:thd:180+thd]-thd/2;
thdiv2=[0:thd:360+thd]-thd/2;

%  ipl=min(ipl,6);
% c=['b';'r';'k']
f2n=AngularDifference(c_os,o2n)*180/pi;
f0=find(abs(f2n)<10);
p0=find(abs(ppsiL*180/pi)<10);
iface=find(abs(nors*180/pi)<10);
allnors=AngularDifference(allsos,allo2n);

figure(fnum+7),subplot(2,3,ipl)
[y,x]=AngHist(allsos(abs(allnors)<(pi/18))*180/pi);ya=y/sum(y);
[y,x]=AngHist(sos(iface)*180/pi);yface=y/sum(y);
[y,x]=AngHist(sos*180/pi);ys=y/sum(y);
[y,x]=AngHist(allsos*180/pi);ysa=y/sum(y);
[y,x]=AngHist(sos(intersect(p0,f0))*180/pi);yb=y/sum(y);
plot(x,ya,x,yface,'r:',x,ys,'k:',x,ysa,'k*',x,yb,'g--d'),axis tight

% % pea=1:36;
% f2n=[sfs(pea).a]*180/pi;
% f2n=AngularDifference([sfs(pea).co],[sfs(pea).o2n])*180/pi;
% ppsi=AngularDifference([sfs(pea).co],[sfs(pea).so]);
% % [dat,xp]=StatsOverX(ppsi*180/pi,f2n,-185:10:185);
% % dm=[dat.med];plot(xp,dm,c(ipl,:)),hold on,%errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm)
% figure(1),subplot(2,3,ipl)
% [D,xs,ys,xps,yps]=Density2D(ppsi*180/pi,f2n,-185:10:185,-185:10:185);
% contourf(xps,yps,-D+max(D(:))),xlabel('\psi');ylabel('fdir rel to nest')
% figure(2),subplot(2,3,ipl)
% [y1,x]=AngHist(ppsi*180/pi);
% [y2,x]=AngHist(f2n);
% plot(x,y1/sum(y1),x,y2/sum(y2),'r:'),axis tight

% return
% [yl,x]=AngHist(ang3*180/pi);
% sts=find(ts==0);
% ens=find(ts==1);
% [ys,x]=AngHist(cos(sts)*180/pi);
% [yse,x]=AngHist(cos(ens)*180/pi);
% plot(x,ys/sum(ys),x,yl/sum(yl),'r:',x,yse/sum(yse),'k--')
% axis tight
% return
dds=[];tolap=[];psiolap=[];folap=[];e2st=[];st2e=[];csts=[];cens=[];colap=[];
pins=[];fins=[];cins=[];pout=[];cout=[];fout=[];mdt=[];mdt2=[];
f0outs=[];f0ins=[];f0angs=[];f0Nr=[];langs=[];
mdts=[];dst=[];dend=[];medt=[];dp=[];psts=[];pens=[];nlin=0;

c=0;c2=0;
for i=1:length(fltsec)    
    for j=1:length(fltsec(i).fsec)
        c=c+1;
      if(size(fltsec(i).fsec(j).cs,1)>=4) c2=c2+1;end;
    end
end
[c c2]
% return
for i=1:length(fltsec)
    
    lnum=-1;
    fn=fltsec(i).fn;
    for k=1:length(loops)
        if(isequal(fn,loops(k).fn))
            lnum=k;
            break;
        end
    end
    if(lnum==-1)
    else
        load(fn);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        f2n=AngularDifference(Cent_Os,OToNest);
        ppsi=AngularDifference(Cent_Os,sOr);
    if(isempty(fltsec(i).fsec)) iss=[];
    else iss=[fltsec(i).fsec.is];
    end
    ps=find([loops(lnum).Picked]);
    if(isempty(ps)) isl=[];
    else isl=[loops(lnum).loop(ps).is];
    end
    isb=intersect(iss,isl);
    allcs=fltsec(i).cs;
    relt=-1*ones(size(t));
    relt2=[];rt2=[];
%     if 1%(pl)
         if(~isempty(ps))
            lsts=[loops(lnum).loop(ps).sp];
            csts=[csts Cent_Os(lsts)'*180/pi];
            psts=[psts ppsi(lsts)'*180/pi];
            lens=[loops(lnum).loop(ps).ep];
            cens=[cens Cent_Os(lens)'*180/pi];
            pens=[pens ppsi(lens)'*180/pi];
            for j=ps
                is=loops(lnum).loop(j).is;
                psi0=find(abs(ppsi(is))<(pi/18));
                f2n0=find(abs(f2n(is))<(pi/18));
                b=intersect(psi0,f2n0);
%                 f0angs=[f0angs Cent_Os(is(b))'];
                f0angs=[f0angs sOr(is(b))];
                f0Nr=[f0Nr NestOnRetina(is(b))'];
                if(~isempty(b))
                    mp=round(median(is(b)));
%                     f0ang=Cent_Os(mp);
                    f0ang=sOr(mp);
%                     f0angs=[f0angs f0ang];
%                     if(h==1) cocw=[cocw;AngularDifference([co(sp) co(ep)],co(mp)) co([sp ep mp])'];
%                     else coaw=[coaw;AngularDifference([co(sp) co(ep)],co(mp)) co([sp ep mp])'];
%                     end
                else f0ang=NaN;
                end;
                
%                 cs=allcs(is,:);
                ib=intersect(iss,is);
                rt=t(is)-t(is(1));
                l1s=ones(length(is),1);
                rt2=[rt2; l1s*t(is(1)) l1s*max(rt) l1s*lnum l1s*j l1s*f0ang];
                rt=rt/max(rt);
                relt(is)=rt;
                relt2=[relt2 rt];
                tolap=[tolap relt(ib)];    

                %             figure(7)
                %             plot(cs(:,1),cs(:,2),'r'), hold on
            end
         for j=1:length(fltsec(i).fsec)
             sst=fltsec(i).fsec(j).is(1);
             est=fltsec(i).fsec(j).is(end);
             mst=fltsec(i).fsec(j).is(round(end/2));
%              mp=length(
%              mst=fltsec(i).fsec(j).is(round();
%              dds=[dds;min(abs(lsts-sst)) min(abs(lens-sst)) ...
%                  min(abs(lsts-est)) min(abs(lens-est))];
%              d=lsts-sst;[md mi]=min(abs(d));m1=d(mi);
%              d=lens-sst;[md mi]=min(abs(d));m2=d(mi);
%              d=est-lsts;[md mi]=min(abs(d));m3=d(mi);
%              d=lens-est;[md mi]=min(abs(d));m4=d(mi);
%                dds=[dds;m1 m2 m3 m4 m5 m6];

            [md mi]=min(abs(isl-mst));
            
            % this works out the time relative to the nearest loop of the 
            % mid point of the line
            mdt2=[mdt2 (t(mst)-rt2(mi,1))/rt2(mi,2)];
            % this works out the relative time of the median point of the
            % line
            rts=(t(sst:est)-rt2(mi,1))/rt2(mi,2);
            medt=[medt median(rts)];
            mdts=[mdts rts];

            % this works out the relative time of the mid point of the line
            % but only includes poinst within loops
            if(md==0)
                mdt=[mdt relt2(mi)];
                nlin=nlin+1;
            end;
            
            % this works out the relative time of the nearest point of the loop
%            mdt2=[mdt2 (t(isl(mi))-rt2(mi,1))/rt2(mi,2)];
            
            dds=[dds;min(abs(isl-sst)) min(abs(isl-est)) ...
                 min(abs([isl-est isl-sst])) length(intersect(isl,fltsec(i).fsec(j).is))];
             
            cs=fltsec(i).fsec(j).cs;
%             if(dds(end,3)<4) e2st=[e2st MeanAngle(Cent_Os([fltsec(i).fsec(j).is]))]; end
%             if(dds(end,2)<4) st2e=[st2e MeanAngle(Cent_Os([fltsec(i).fsec(j).is]))]; end
            lang=MeanAngle(fltsec(i).fsec(j).co);
            langs=[langs lang];
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lmini=md;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lmint=mdt2;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lfseci=i;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lfsecj=j;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lang=lang;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lcs=cs;
            loops(rt2(mi,3)).loop(rt2(mi,4)).Lis=fltsec(i).fsec(j).is;
            if(dds(end,3)<5) 
                pins=[pins ppsi([fltsec(i).fsec(j).is])'*180/pi]; 
                fins=[fins f2n([fltsec(i).fsec(j).is])'*180/pi]; 
                cins=[cins [fltsec(i).fsec(j).co]'*180/pi];
                dp=[dp [ppsi(mst); f2n(mst); Cent_Os(mst)]*180/pi];
                if(medt(end)<=0.5)
                    dst=[dst [ppsi([fltsec(i).fsec(j).is])'*180/pi; ...
                        f2n([fltsec(i).fsec(j).is])'*180/pi; [fltsec(i).fsec(j).co]'*180/pi]];
                else
                    dend=[dend [ppsi([fltsec(i).fsec(j).is])'*180/pi; ...
                        f2n([fltsec(i).fsec(j).is])'*180/pi; [fltsec(i).fsec(j).co]'*180/pi]];
                end
                if(~isnan(rt2(mi,5))) f0ins=[f0ins;rt2(mi,5) lang]; end;
                e2st=[e2st lang];
                
            elseif(dds(end,3)>15) 
                pout=[pout ppsi([fltsec(i).fsec(j).is])'*180/pi]; 
                fout=[fout f2n([fltsec(i).fsec(j).is])'*180/pi]; 
                cout=[cout [fltsec(i).fsec(j).co]'*180/pi];
                if(~isnan(rt2(mi,5))) f0outs=[f0outs;rt2(mi,5) lang]; end;
                st2e=[st2e lang];
            end
            ls(j)=size(cs,1);
%             plot(cs(:,1),cs(:,2),'b'),hold on
        end
         end

%         plot(allcs(isb,1),allcs(isb,2),'ko')
%     end
    pcs(i,:)=([length(iss) length(isl) length(isb) ...
        length(union(iss,isl))].*100./size(allcs,1));
    l(i).ls=ls;
    psiolap=[psiolap ppsi(isb)'*180/pi];
    folap=[folap f2n(isb)'*180/pi];
    colap=[colap Cent_Os(isb)'*180/pi];
    end
%     figure(7),hold off
end

save loopsOverlap
nums=[length(e2st) nlin length(st2e) length(langs)]
% figure(fnum+2),subplot(2,3,ipl)
% [yp,x]=AngHist(psiolap);[yf,x]=AngHist(folap);[yc,x]=AngHist(colap);
% plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight
% figure(fnum+6),subplot(2,3,ipl)
% % [yp,x]=AngHist(csts);[yf,x]=AngHist(cens);[yl,x]=AngHist(ang3*180/pi);
% % [yp,x]=AngHist(colap);[yf,x]=AngHist(colap);[yl,x]=AngHist(ang3*180/pi);
% % plot(x,yp/sum(yp),x,yf/sum(yf),'k--',x,yl/sum(yl),'r:');axis tight
% [yp,x]=AngHist(pout);[yf,x]=AngHist(fout);[yc,x]=AngHist(cout);
% plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight
% figure(fnum+3),subplot(2,3,ipl),
% hist(dds(:,[1:3]),[0:10]);axis tight;%ylim([0 30])
% figure(fnum+4),subplot(2,3,ipl)
% [yp,x]=AngHist(st2e*180/pi);[yf,x]=AngHist(e2st*180/pi);
% plot(x,yp/sum(yp),x,yf/sum(yf),'r:');axis tight

pins=dp(1,:);fins=dp(2,:);cins=dp(3,:);
% plot frequency distributions of near lines
figure(fnum+1),subplot(2,3,ipl),%hist([pcs(:,3)./pcs(:,1) pcs(:,3)./pcs(:,2)],0:0.05:1);axis tight
[yp,x]=AngHist(pins);[yf,x]=AngHist(fins);[yc,x]=AngHist(cins);
plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight

% % plots of flight directions etc for central points in or out of loops
% figure(fnum+1),subplot(2,3,ipl)
% [yp,x]=AngHist(f0ins(:,1)*180/pi);[yf,x]=AngHist(f0outs(:,1)*180/pi);[yc,x]=AngHist(f0angs*180/pi);
% [y,x]=AngHist(sos(iface)*180/pi);yb=y/sum(y);
% % plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight
% plot(x,yp/sum(yp),x,yb/sum(yb),'r:',x,yc/sum(yc),'k--');axis tight

% % get the lines which contribute to peak angles
% [m,i]=max(yc);xa=x(i)
% ff=AngularDifference(f0ins(:,1),0)*180/pi;
% w=15;isp=find((ff>=(xa-w))&(ff<=(xa+w)));
% figure(fnum+5),subplot(2,3,ipl)
% plot(ff(isp),f0ins(isp,2)*180/pi,'o');axis tight
% plot(f0ins(:,1)*180/pi,f0ins(:,2)*180/pi,'o',f0outs(:,1)*180/pi,f0outs(:,2)*180/pi,'rx');axis tight
% peakls=f0ins(isp,2)*180/pi;

[yp,x]=hist(tolap,-1.5:.1:1.5);yto=yp/sum(yp);
[yp,x]=hist(mdt2(abs(mdt2)<=1.5),-1.5:.1:1.5);yt2=yp/sum(yp);
[yp,x]=hist(mdts(abs(mdts)<=1.5),-1.5:.1:1.5);yts=yp/sum(yp);
[yp,x]=hist(medt(abs(medt)<=1.5),-1.5:.1:1.5);ytm=yp/sum(yp);
figure(fnum+2),subplot(2,3,ipl),plot(x,yto,x,yt2,'r:',x,ytm,'g:x',x,yts,'k--');axis tight,xlim([-.5 1.5])

%  noolap=round(100*[sum(dds<=2) sum(dds<=5) sum(dds<=10)]./size(dds,1))

% instead of doing all points within both, do points from all near lines
psiolap=pins;folap=fins;colap=cins;
% psi and flight direction for overlapping pointa
[Dpsif,xs,ys,xps,yps]=Density2D(psiolap,folap,thdiv,thdiv);
[Dpsic,xs,ys,xps,yps]=Density2D(psiolap,colap,thdiv,thdiv2);
figure(fnum+3),subplot(2,3,ipl),contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
figure(fnum+4),subplot(2,3,ipl),contourf(xps,yps,max(Dpsic(:))-Dpsic);axis equal;axis tight;
% psi and flight for the points at the start of loops
[Dpsif,xs,ys,xps,yps]=Density2D(dst(1,:),dst(2,:),thdiv,thdiv);
[Dpsic,xs,ys,xps,yps]=Density2D(dst(1,:),dst(3,:),thdiv,thdiv2);
figure(fnum+5),subplot(2,3,ipl),contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
figure(fnum+6),subplot(2,3,ipl),contourf(xps,yps,max(Dpsic(:))-Dpsic);axis equal;axis tight;
% psi and flight for the points at the end of loops
[Dpsif,xs,ys,xps,yps]=Density2D(dend(1,:),dend(2,:),thdiv,thdiv);
[Dpsic,xs,ys,xps,yps]=Density2D(dend(1,:),dend(3,:),thdiv,thdiv2);
figure(fnum+7),subplot(2,3,ipl),contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
figure(fnum+8),subplot(2,3,ipl),contourf(xps,yps,max(Dpsic(:))-Dpsic);axis equal;axis tight;
% distributions of psi and flight for the starts and  ends of loops
if(ipl>3) dpl=ipl+3;
else dpl=ipl;
end
figure(fnum+9),subplot(4,3,dpl),
[yp,x]=AngHist(psts);yps=yp/sum(yp);[yf,x]=AngHist(pens);ype=yf/sum(yf);
[yp,x]=AngHist(dst(1,:));[yf,x]=AngHist(dend(1,:));[yc,x]=AngHist(ppsiL*180/pi);
plot(x,yp/sum(yp),x,yc/sum(yc),'k--',x,yps,'b:');axis tight
subplot(4,3,dpl+3),plot(x,yf/sum(yf),'r',x,ype,'r:',x,yc/sum(yc),'k--');axis tight
figure(fnum+10),subplot(4,3,dpl)
[yp,x]=AngHist(csts);yps=yp/sum(yp);[yf,x]=AngHist(cens);ype=yf/sum(yf);
[yp,x]=AngHist(dst(3,:));[yf,x]=AngHist(dend(3,:));[yc,x]=AngHist(c_os*180/pi);
plot(x,yp/sum(yp),x,yf/sum(yf),'r:');axis tight
subplot(4,3,dpl+3),plot(x,yps,'b',x,ype,'r:');axis tight
% folap=mdt2;
%  mdt2=st2e;%tolap=f0ins;
% mdt2=f0angs;tolap=f0ins;e2st=f0outs;
tolap=mdt2;
colap=langs;


function[e2st,st2e,psiolap,colap,folap,dds]=GetOverlapIn(ipl)

% loopfns={'Loopssingle_2east.mat';'Loopssingleloops_2west.mat';...
%     'Loopsloopsingle_west8.mat';'LoopssingleloopsN8.mat'; ...
%     'Loopssingle_east8.mat';'';'Loopssingleloops_1north2008.mat'};
% linefns={'straight_2east_outData.mat';'straight_2westoutData.mat';...
%     'straight_west8_outData.mat';'straight_out_north8_2007Data.mat'; ...
%     'straight_east8_outData.mat'};
% load(char(loopfns(ipl)))
% load(char(linefns(ipl)))
% 
load processzigzagsin
zz=fltsec;
load processflightsecIn
 ipl=min(ipl,6);
c=['b';'r';'k'];

thd=20;
thdiv=[-180:thd:180+thd]-thd/2;
thdiv2=[0:thd:360+thd]-thd/2;

% f2n=ftonest*180/pi;
% % pea=1:36;
% f2n=[sfs(pea).a]*180/pi;
% f2n=AngularDifference([sfs(pea).co],[sfs(pea).o2n])*180/pi;
% mpsi=AngularDifference([sfs(pea).co],[sfs(pea).so]);
% 
% % [dat,xp]=StatsOverX(ppsi*180/pi,f2n,-185:10:185);
% % dm=[dat.med];plot(xp,dm,c(ipl,:)),hold on,%errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm)
% figure(3),subplot(2,3,ipl)
% [D,xs,ys,xps,yps]=Density2D(mpsi*180/pi,f2n,-185:10:185,-185:10:185);
% contourf(xps,yps,-D+max(D(:))),xlabel('\psi');ylabel('fdir rel to nest')
% figure(4),subplot(2,3,ipl)
% f2n=AngularDifference([sfs.co],[sfs.o2n])*180/pi;
% [y1,x]=AngHist(mpsi*180/pi);
% [y2,x]=AngHist(f2n);
% plot(x,y1/sum(y1),x,y2/sum(y2),'r:'),axis tight
% return

% [yl,x]=AngHist(ang3*180/pi);
% sts=find(ts==0);
% ens=find(ts==1);
% [ys,x]=AngHist(cos(sts)*180/pi);
% [yse,x]=AngHist(cos(ens)*180/pi);
% plot(x,ys/sum(ys),x,yl/sum(yl),'r:',x,yse/sum(yse),'k--')
% axis tight
% return
dds=[];tolap=[];psiolap=[];folap=[];e2st=[];st2e=[];csts=[];cens=[];colap=[];
mdt=[];mdt2=[];farp=[];nearp=[];tolap2=[];tolap3=[];langs=[];
pins=[];fins=[];cins=[];pout=[];cout=[];fout=[];isl=[];nlin=0;
for i=1:length(fltsec)

    lnum=-1;
    fn=fltsec(i).fn;
    for k=1:length(zz)
        if(isequal(fn,zz(k).fn))
            lnum=k;
            break;
        end
    end
    if(lnum==-1)
    else
        load(fn);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        f2n=AngularDifference(Cent_Os,OToNest);
        ppsi=AngularDifference(Cent_Os,sOr);
        if(isempty(fltsec(i).fsec)) iss=[];
        else iss=[fltsec(i).fsec.is];
        end
        %     if(isempty(zz(lnum).fsec)) isl=[];
        %     else isl=[zz(lnum).fsec.is];
        %     end
        isl=[];
        
        allcs=fltsec(i).cs;
        relt=-1*ones(size(t));
        relt2=[];rt2=[];
        %     if 1%(pl)
            for j=1:length(zz(lnum).fsec)
                %             lsts(j)=zz(lnum).fsec(j).is(1);
                % %             csts=[csts Cent_Os(lsts)'*180/pi];
                %             csts=[csts ppsi(lsts)'*180/pi];
                %             lens=[zz(lnum).fsec(ps).ep];
                % %             cens=[cens Cent_Os(lens)'*180/pi];
                %             cens=[cens ppsi(lens)'*180/pi];
                is=zz(lnum).fsec(j).is;
                if(length(is)>=4)
                    isl=[isl is];
                    acs=zz(lnum).fsec(j).cs;
                    v1=ones(length(is),1);
                    % timing based on time against ZZ major axis THIS ONE
                    % BEST
                    relt2=[relt2 zz(lnum).fsec(j).reltDang2];  
                    rtdat=zz(lnum).fsec(j).reltDang2Dat;
                    % timing based on time against Flt dir rel 2 nest
                    % POSS CLEANER BUT NOT AS ASSUMPTION FREE
%                     relt2=[relt2 zz(lnum).fsec(j).reltDco];  
%                     rtdat=zz(lnum).fsec(j).reltDcoDat;
                    rt=t(is)-t(is(1));
                    rt2=[rt2; v1*t(is(1)) v1*max(rt) v1*rtdat.sp1 ...
                        v1*rtdat.len1 v1*rtdat.sp2 v1*rtdat.len2];
                    rt=rt/max(rt);
                    relt(is)=rt;
                    [bb,ib]=intersect(is,iss);
                    %             tolap=[tolap relt(ib)];
                    tolap=[tolap zz(lnum).fsec(j).reltDang2(ib)];
                    tolap2=[tolap2 zz(lnum).fsec(j).reltDco(ib)];
                    tolap3=[tolap3 zz(lnum).fsec(j).reltPsi(ib)];
                end
                %             figure(7)
                %             plot(acs(:,1),acs(:,2),'r'), hold on
            end
        if(~isempty(isl))
            for j=1:length(fltsec(i).fsec)
                sst=fltsec(i).fsec(j).is(1);
                est=fltsec(i).fsec(j).is(end);
                mst=fltsec(i).fsec(j).is(round(end/2));
                lang=MeanAngle(fltsec(i).fsec(j).co);
                langs=[langs lang];
                [md mi]=min(abs(isl-mst));
                if(md<=5)
                    pins=[pins ppsi([fltsec(i).fsec(j).is])'*180/pi];
                    fins=[fins f2n([fltsec(i).fsec(j).is])'*180/pi];
                    cins=[cins [fltsec(i).fsec(j).co]'*180/pi];
                    e2st=[e2st lang];
                elseif(md>15)
                    st2e=[st2e lang];
                end;
                if(md==0) 
                    mdt=[mdt relt2(mi)]; 
                    nlin=nlin+1;
                elseif((isl(mi)-mst)>0)    % if line comes before zz
                    mdt=[mdt (t(mst)-rt2(mi,3))/rt2(mi,4)];
                else       % if lines comes after zz    
                    mdt=[mdt (t(mst)-rt2(mi,5))/rt2(mi,6)];
                end;
                mdt2=[mdt2 (t(mst)-rt2(mi,1))/rt2(mi,2)];
                %              dds=[dds;min(abs(lsts-sst)) min(abs(lens-sst)) ...
                %                  min(abs(lsts-est)) min(abs(lens-est))];
                cs=fltsec(i).fsec(j).cs;
                %             if(dds(end,3)<4) e2st=[e2st MeanAngle(Cent_Os([fltsec(i).fsec(j).is]))]; end
                %             if(dds(end,2)<4) st2e=[st2e MeanAngle(Cent_Os([fltsec(i).fsec(j).is]))]; end
                %             ls(j)=size(cs,1);
                dds=[dds;min(abs(isl-sst)) min(abs(isl-est)) ...
                    min(abs([isl-est isl-sst])) length(intersect(isl,fltsec(i).fsec(j).is))];
                %             plot(cs(:,1),cs(:,2),'b'),hold on
            end
        end

%         plot(allcs(isb,1),allcs(isb,2),'ko')
%     end
    isb=intersect(iss,isl);
    pcs(i,:)=([length(iss) length(isl) length(isb) ...
        length(union(iss,isl))].*100./size(allcs,1));
    l(i).ls=ls;
    psiolap=[psiolap ppsi(isb)'*180/pi];
    folap=[folap f2n(isb)'*180/pi];
    colap=[colap Cent_Os(isb)'*180/pi];
    end
%     figure(7),hold off
end
save ZZOlap
nums=[length(e2st) nlin length(st2e) length(langs)]
figure(4),subplot(2,3,ipl)
[yp,x]=AngHist(psiolap);[yf,x]=AngHist(folap);[yc,x]=AngHist(colap);
% [yf,x]=AngHist(psiolap);[yp,x]=AngHist(nearps);[yc,x]=AngHist(nearp);
plot(x,yp/sum(yp),x,yf/sum(yf),'r:',x,yc/sum(yc),'k--');axis tight;
% figure(6),subplot(2,3,ipl)
% [yp,x]=AngHist(csts);[yf,x]=AngHist(cens);[yl,x]=AngHist(ang3*180/pi);
% [yp,x]=AngHist(colap);[yf,x]=AngHist(colap);[yl,x]=AngHist(ang3*180/pi);
% plot(x,yp/sum(yp),x,yf/sum(yf),'k--',x,yl/sum(yl),'r:');axis tight
figure(3),subplot(2,3,ipl),
hist(dds(:,1:3),[0:20]);axis tight;%ylim([0 20])
% figure(4),subplot(2,3,ipl)
% [yp,x]=AngHist(st2e*180/pi);[yf,x]=AngHist(e2st*180/pi);
% plot(x,yp/sum(yp),x,yf/sum(yf),'r:');axis tight
figure(5),subplot(2,3,ipl),hist([pcs(:,3)./pcs(:,1)],0:0.05:1);axis tight
% figure(1),subplot(2,3,ipl),hist(tolap,0:0.05:1);axis tight
% keyboard

figure(1),subplot(2,3,ipl),hist([tolap;tolap2;tolap3]',20);axis tight
% figure(2),subplot(2,3,ipl),hist(mdt2(abs(mdt2)<=1.5),-1.5:.1:1.5);axis tight,xlim([-.5 1.5])
figure(2),subplot(2,3,ipl),hist(mdt(abs(mdt)<=1.5),-1.5:.1:1.5);axis tight,xlim([-.5 1.5])
noolap=round(100*[sum(dds<=2) sum(dds<=5) sum(dds<=10)]./size(dds,1))
% instead of doing all points within both, do points from all near lines

psiolap=pins;folap=fins;colap=cins;
% psi and flight direction for overlapping pointa
[Dpsif,xs,ys,xps,yps]=Density2D(psiolap,folap,thdiv,thdiv);
[Dpsic,xs,ys,xps,yps]=Density2D(psiolap,colap,thdiv,thdiv2);
figure(3),subplot(2,3,ipl),contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
figure(4),subplot(2,3,ipl),contourf(xps,yps,max(Dpsic(:))-Dpsic);axis equal;axis tight;
dds=[tolap;tolap2;tolap3]';%nearp;%
folap=mdt;
psiolap=langs;

function[psicw,psiaw,f2ncw,f2naw,cocw,coaw,lens]=ZigZagPsi(ipl)
toplot=0;
load processzigzagsin
zz=fltsec;
zatcw=[];zataw=[];psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];lens=[];
allco=[];nf=0;nfc=zeros(1,length(zz));nfcc=zeros(1,length(zz));
cwin=[];cwout=[];awin=[];awout=[];starts=[];
psi0aw=[];f2n0aw=[];psi0cw=[];f2n0cw=[];lkcw=[];lkaw=[];
PhDat.c=zeros(1,4);
PhDat.m=[];PhDat.m1=[];PhDat.m2=[];PhDat.m4=[];PhDat.m3=[];
for i=1:length(zz)
    inf(i)=0;
            load(zz(i).fn);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
    zz(i).f2n=AngularDifference(Cent_Os,OToNest);
    zz(i).c_os=Cent_Os;
    zz(i).so=sOr;
    zz(i).psi=AngularDifference(Cent_Os,sOr);

    ra_co=MyGradient(AngleWithoutFlip(Cent_Os),t);
    ra_so=MyGradient(AngleWithoutFlip(sOr),t);
    o2n=zz(i).o2n;
    nor=zz(i).nor;
    t=zz(i).t;
    for j=1:length(zz(i).fsec)
        is=zz(i).fsec(j).is;
        if(length(is)>=4)
            nf=nf+1;
            ts=t(is);
            co=AngularDifference(zz(i).fsec(j).co,0);
%             co=AngularDifference(zz(i).fsec(j).so',0);
            so=AngularDifference(zz(i).fsec(j).so',0);
            
            cs=zz(i).fsec(j).cs;
            ppsi=AngularDifference(co,so);
            f2n=AngularDifference(co,o2n(is));
            s2n=AngularDifference(so,o2n(is));
            relt=zz(i).fsec(j).reltDang2;
%             relt=zz(i).fsec(j).reltDco;
            sps=find(relt==0);
            eps=find(relt==1);
            if(eps(1)<=sps(1)) eps=eps(2:end); end;
            if(eps(end)<=sps(end)) sps=sps(1:end-1); end;
            tpc=[];
            for k=1:length(sps)
                izz=sps(k):eps(k);
                [h,ad1 ad2] = LoopHandednes(co(izz));
                if(ad2(1)<0) 
                    h=-1; 
                    cstr='anti-clock';
                else
                    h=1;
                    cstr='clock';
                end
                sp=sps(k);
                ep=eps(k);
                
%                 psi0=find(abs(ppsi(izz))<(pi/18));%1:length(is);%
%                 f2n0=find(abs(f2n(izz))<(pi/18));
                [psi0,meInd]=Thru0Pts(ppsi(izz),ts(izz),pi/18,[],0.08);
                [f2n0,meInd]=Thru0Pts(f2n(izz),ts(izz),pi/18,[],0.08);
                [lk0,meInd]=Thru0Pts(nor(is(izz)),ts(izz),pi/18,[],0.08);

                psif0=MeanAngle(ppsi(izz(f2n0)));
                tf=ts(izz(f2n0));
                tp=ts(izz(psi0));
                tpsi0=median(tp);
                fpsi0=MeanAngle(f2n(izz(psi0)));
                tf0=median(tf);
                b=intersect(psi0,f2n0);
                
                % get all the points within +/-tlim
                if 1%(isempty(b)) 
                    tlim=0.04;
%                     [minb,ind]=min(abs(psif0));
                    dds=[];onees=ones(size(tf)); overf=[];overp=[];
                    if(~isempty(f2n0)&&~isempty(psi0))
                        for pp=1:length(tp)
                            dds=tf-tp(pp);
                            [md,mi]=min(abs(dds));
                            if(md<=tlim) 
                                overf=[overf f2n0(mi)];
                                overp=[overp psi0(pp)];
                            end
%                             dds=[dds [tf-tp(pp);onees*pp]];
                        end
%                         [minb,ind]=min(abs(dds(1,:)));
%                         if(minb<=0.04)
% %                             keyboard;
%                         end
                        minb=NaN;%dds(1,ind); 
                    else minb=NaN;
                    end
%                     b=f2n0(ind);
                else minb=0;%ppsi(b(1));
                end;

                % get incidents from individual frames
                [dum,dum,psi0len,ipsi0]=StartFinish(ts(izz),psi0,0.05);
                [dum,dum,f2n0len,if2n0]=StartFinish(ts(izz),f2n0,0.05);
                [dum,dum,lklen,ilk]=StartFinish(ts(izz),lk0,0.05);
                [sbs,sens,blens,imids]=StartFinish(ts(izz),b,0.05);
                vecp=[];vecf=[];vecc=[];veclk=[];
                ips=izz(ipsi0)';v=ones(size(ips));
                vecp=[cs(ips,:) o2n(is(ips)) psi0len' i*v j*v so(ips) cs(sp*v,:) co(ips)];
                ips=izz(if2n0)';v=ones(size(ips));
                vecf=[cs(ips,:) o2n(is(ips)) f2n0len' i*v j*v so(ips) cs(sp*v,:) co(ips)];
                ips=izz(ilk)';v=ones(size(ips));
                veclk=[cs(ips,:) o2n(is(ips)) lklen' i*v j*v so(ips) cs(sp*v,:) co(ips)];
                 
                if(h==1)
                    psicw=[psicw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0 minb];
                    f2ncw=[f2ncw;f2n(sp) f2n(ep)];
                    f2n0cw=[f2n0cw;vecf];
                    psi0cw=[psi0cw;vecp];
                    lkcw=[lkcw;veclk];
                    if(f2n(sp)>0)
%                         toplot=1;
                    end
                else
                    psiaw=[psiaw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0 minb];
                    f2naw=[f2naw;f2n(sp) f2n(ep)];
                    f2n0aw=[f2n0aw;vecf];
                    psi0aw=[psi0aw;vecp];
                    lkaw=[lkaw;veclk];
                    if(f2n(sp)<0)
%                         toplot=1;
                    end
                end

%                 if(sum(blens)>=1) toplot=0;
%                 else toplot=0;
%                 end
                
                lens=[lens blens];
%                 lens=[lens length(imids)];

                % decide which overlap to use
%                 b=overp;
                if(~isempty(b))
                    %                                 mp=round(mean(izz(b))); % single points
                    %                                 com=MeanAngle(co(izz(b)));
                    b=imids;        % proper single points
                    mp=izz(b)';v=ones(size(mp));sp=v*sp;ep=v*ep;  % all the  points
                    com=[];
                    for l=1:length(sbs)
                        com(l)=circ_median(co(izz(sbs(l)):izz(sens(l))));
                    end
                    %                     com=co(mp);
                    vecc=[cs(mp,:) o2n(is(mp)) blens' i*v j*v so(mp) cs(sp,:) co(mp)];
                    if(h==1)
                        cocw=[cocw;AngularDifference(co(sp),com),...
                            AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                            relt(mp)' ts(mp)' vecc];
                        nfc(i)=nfc(i)+1;
                        cwin=[cwin;co f2n ppsi so s2n];
                        sbp=1;
                    else
                        coaw=[coaw;AngularDifference(co(sp),com),...
                            AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                            relt(mp)' ts(mp)' vecc];
                        nfcc(i)=nfcc(i)+1;
                        awin=[awin;co f2n ppsi so s2n];
                        sbp=3;
                    end
                    %                     lens=[lens [k;length(sps)]];
                else
                    if(h==1)
                        sbp=2;
                        cwout=[cwout;co f2n ppsi so s2n];
                    else
                        sbp=4;
                        awout=[awout;co f2n ppsi  so s2n];
                    end
                end;
%                 lens=[lens;length(b) length(psi0) length(f2n0)];
                sp=sp(1);
                isp=sp:(min(sp+3,ep)); m3=MeanAngle(co(isp)); s3=MeanAngle(so(isp));
                isp=sp:(min(sp+5,ep)); m5=MeanAngle(co(isp)); s5=MeanAngle(so(isp));
                starts=[starts; sbp cs(sp,:) co(sp) so(sp) m3 m5 s3 s5];
                ilo=max(1,izz(1)-25);%GetTimes(t,t(is(1))-0.5);
                is2=ilo:izz(end);
                lmor=[];
                o2lm=[];
                f2lm=[];
                if(exist('LMs'))
                    lmo=LMOrder(LM);
                    for l=1:length(LMs)
                        lmor(l,:)=LMs(lmo(l)).LMOnRetina(is(izz))';
                        o2lm(l,:)=LMs(lmo(l)).OToLM(is(izz))';
                        f2lm(l,:)=AngularDifference(co(izz)',o2lm(l,:));
                    end
                else
                    keyboard;
                end

                % get the data for all ZZS for phase type plots
                clear d
                d.f2n=f2n(izz)';
                d.psi=ppsi(izz)';
                d.nor=-s2n(izz)';
                d.lmor=lmor;
                d.co=co(izz)';
                d.t=ts(izz);
                d.ra_co=ra_co(is(izz));
                d.fltnum=i;
                
                if(isempty(b)); d.coin=0;
                else d.coin=1;
                end
                if(h==1); zatcw=[zatcw;d];
                else zataw=[zataw;d];
                end

                [PhDat,spp,tpp,tpcs]=PhaseStuff(PhDat,f2n(izz),co(izz),s2n(izz),so(izz),...
                    o2n(is(izz)),sbp,CartDist(cs(izz(1),:)),ts(izz),cs(izz,:), ...
                    co(is2),f2n(is2),t(is2),o2lm,lmor,f2lm,Speeds(is(izz))',ra_co(is(izz)),ra_so(is(izz)));
                te=[te;h,ad2];
                tpc(k).tpcs=tpcs;
                tpc(k).sp=sp;
                if(toplot)
                    figure(4),subplot(2,1,1)
                    plot(ts(izz),so(izz)*180/pi,ts(izz),co(izz)*180/pi,'r:', ...
                        tp,so(izz(psi0))*180/pi,'bo',tp,co(izz(psi0))*180/pi,'ro',...%)
                        tf,so(izz(f2n0))*180/pi,'bx',tf,co(izz(f2n0))*180/pi,'rx')
                    xlabel('body o blue, flight dir red. o=psi0; x=f2n0'),axis tight
                    title(int2str(round(co(imids)*180/pi)))
                    subplot(2,1,2),plot(ts(izz),ppsi(izz)*180/pi,ts(izz),f2n(izz)*180/pi,'r:', ...
                        tp,ppsi(izz(psi0))*180/pi,'bo',tf,f2n(izz(f2n0))*180/pi,'rx', ...%)
                        ts(izz(b)),f2n(izz(b))*180/pi,'g*',ts(izz(overf)),f2n(izz(overf))*180/pi,'gs', ...%)
                        ts(izz(b)),ppsi(izz(b))*180/pi,'k*',ts(izz(overp)),ppsi(izz(overp))*180/pi,'ks')
                    xlabel('psi blue, f2n red. o=psi0; x=f2n0 * intersect; square overlap'),axis tight
                    figure(5),plot(cs(:,1),cs(:,2),cs(izz,1),cs(izz,2),'r:',...
                        cs(izz(psi0),1),cs(izz(psi0),2),'ro',...
                        cs(izz(f2n0),1),cs(izz(f2n0),2),'rx',...
                        cs(sp,1),cs(sp,2),'kd',tpcs(:,1),tpcs(:,2),'k*')
%                     title([cstr 'wise: ang1 = ' int2str(ad1) ' ang2 = ' int2str(ad2)])
                    comp=AngleWithoutFlip(co(izz(b)'));ran=round((max(comp)-min(comp))*180/pi);
                     hold on; PlotNestAndLMs(LM,LMWid,[0 0],0); %hold off;
                    axis equal,set(gca,'ydir','reverse'),axis tight,ylabel('o=psi0; x=f2n0')
                    title([cstr 'wise: ang1 = ' int2str(blens) ' ang2 = ' int2str(ran)])

%                     pinp=input('Return to continue; 0 to stop: ','s');
%                     if(isequal(pinp,'0')) toplot=0; end;
                end
            end
            figure(5)
            hold off;
            if(toplot)
                figure(11)
                isp=[1:size(cs,1)];
                BeePathNew(cs,isp,so,LM,LMWid,[0 0])
                hold on
                text(cs(isp(1),1),cs(isp(1),2),'S')
                plot(cs(sps,1),cs(sps,2),'r*')
                for k=1:length(tpc)
                    plot(tpc(k).tpcs(:,1),tpc(k).tpcs(:,2),'kx')
                    fstr=[0;60;100];
                    text(tpc(k).tpcs(:,1),tpc(k).tpcs(:,2),int2str(fstr))
%                     for l=1:3
%                         text(tpc(k).tpcs(l,1),tpc(j).tpcs(k,2),int2str(fstr(k)))
%                     end
                end
                title(['flight ' int2str(i) ':' zz(i).fn '; zz ' int2str(j)])
                hold off
                pause
            end
        end
    end
end
if(isequal(zz(1).fn(2),'E')) 
    pea=3;
%     ephdat=PhDat;
%     ecwin=cwin;ecwout=cwout;eawin=awin;eawout=awout;
%     save temp2EZZPhaseData ephdat ecwin ecwout eawin eawout -append
    save temp2EZZPhaseDataAll
else
    pea =4;
    save temp2WZZPhaseDataAll
end
% PlotStarts(starts,LM,LMWid,-1,cocw(:,8:end),coaw(:,8:end),zz)
% for i=1:4
%     figure(1)
%     subplot(2,2,i);
% %     axis equal;axis tight;
%     axis equal;axis([-180 180 -180 180]);
% %     xlabel('f dir rel. nest');ylabel('flt dir');
%     xlabel('body O rel 2 nest');ylabel('body orientation');
%     hold off
% end
% plotPhaseStuff(PhDat)
% 
% lens;%[mean(lens(lens(:,1)>0)) median(lens(lens>0))]
% PlotLoopPsi(psicw,psiaw,f2ncw,f2naw,cocw,coaw,ipl,pea)

function[fn,tbit]=PlotLoops(flts,lnums)

load loopstatstemp
load processflightsecOut

psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];lens=[];
allco=[];nf=0;nfc=zeros(1,length(loops));nfcc=zeros(1,length(loops));
cwin=[];cwout=[];awin=[];awout=[];starts=[];
psi0aw=[];f2n0aw=[];psi0cw=[];f2n0cw=[];lkcw=[];lkaw=[];
PhDat.c=zeros(1,4);
PhDat.m=[];PhDat.m1=[];PhDat.m2=[];PhDat.m4=[];PhDat.m3=[];

if(nargin<1)
    flts=1:length(loops);
end
if(nargin<2)
    allLoop=1;
else
    allLoop=0;
end

for i=flts
    ps=find([loops(i).Picked]);
    co=AngularDifference(loops(i).Co,0);
    so=AngularDifference([loops(i).so]',0);
    cs=loops(i).cs;
    ppsi=loops(i).fdir;
    f2n=loops(i).f2n;
    s2n=loops(i).nor;
    o2n=loops(i).o2n;
    t=loops(i).t;
    
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);
    ra_co=MyGradient(AngleWithoutFlip(co),t);
    ra_so=MyGradient(AngleWithoutFlip(so),t);
    
    % find the correct straight file  
    lnum=-1;
    fn=loops(i).fn;
    for k=1:length(fltsec)
        if(isequal(fn,fltsec(k).fn))
            if(isempty(fltsec(k).fsec))
                lnum=-1;
            else
                lnum=k;
            end
            break;
        end
    end
    % get the indices of all the straight lines
    if(lnum>0)
        fsec=fltsec(lnum).fsec;
        is_str=[fsec.is];
        fsecs=[];
        for k=1:length(fsec)
            fsecs=[fsecs k*ones(size(fsec(k).is))];
        end
    end

    if(sum(ps)) nf=nf+1; end
    oldis=[];

    figure(10),clf
    PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0)
    hold on;
    
    clear tpc
    if(allLoop==1)
        lnums=1:length(ps);
    end
    
    for j=lnums
        is=loops(i).loop(ps(j)).is;
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        [h,ad1 ad2] = LoopHandednes(co(is));
        sp=is(1);ep=is(end);
                
        %         psi0=find(abs(ppsi(is))<(pi/18));%1:length(is);%
%         f2n0=find(abs(f2n(is))<(pi/18));
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
        [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
        b=intersect(psi0,f2n0);
        
        % get incidents from frames
        [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
        [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
        [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
        [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        % data vectors
        vecp=[];vecf=[];vecc=[];veclk=[];
        ips=is(ipsi0)';v=ones(size(ips));
        vecp=[cs(ips,:) o2n(ips) psi0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(if2n0)';v=ones(size(ips));
        vecf=[cs(ips,:) o2n(ips) f2n0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(ilk)';v=ones(size(ips));
        veclk=[cs(ips,:) o2n(ips) lklen' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        
% %         lens=[lens blens];
        psif0=circ_median(ppsi(is(f2n0)));% MeanAngle(ppsi(is(f2n0)));% 
        tpsi0=median(t(is(psi0)));
        fpsi0=circ_median(f2n(is(psi0)));% MeanAngle(f2n(is(psi0)));% 
        tf0=median(t(is(f2n0)));
        if(h==1)
            psicw=[psicw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2ncw=[f2ncw;f2n(sp) f2n(ep)];
            f2n0cw=[f2n0cw;vecf];
            psi0cw=[psi0cw;vecp];
            lkcw=[lkcw;veclk];
            nfc(i)=nfc(i)+1;
        else
            psiaw=[psiaw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2naw=[f2naw;f2n(sp) f2n(ep)];
            f2n0aw=[f2n0aw;vecf];
            psi0aw=[psi0aw;vecp];
            lkaw=[lkaw;veclk];
            nfcc(i)=nfcc(i)+1;
        end
        if(~isempty(b))
            %             mp=round(mean(is(b))); % single points
            %             com=MeanAngle(co(is(b)));
            b=imids;        % proper single points
            mp=is(b)';v=ones(size(mp));sp=v*sp;ep=v*ep;  % all the  points
            com=[];
            for l=1:length(sbs)
                com(l)=circ_median(co(is(sbs(l)):is(sens(l))));
            end
            %             com=co(mp);
            vecc=[cs(mp,:) o2n(mp) blens' i*v ps(j)*v so(mp) cs(sp,:) co(mp)];
            if(h==1)
                cocw=[cocw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfc(i)=nfc(i)+1;
                cwin=[cwin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=1;
            else
                coaw=[coaw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfcc(i)=nfcc(i)+1;
                awin=[awin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=3;
            end
        else
            if(h==1)
                cwout=[cwout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=2;
            else
                awout=[awout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=4;
            end
        end;
        
        isp=sp:(min(sp+3,ep)); m3=MeanAngle(co(isp)); s3=MeanAngle(so(isp));
        isp=sp:(min(sp+5,ep)); m5=MeanAngle(co(isp)); s5=MeanAngle(so(isp));
        sp=sp(1);
        starts=[starts; sbp cs(sp,:) co(sp) so(sp) m3 m5 s3 s5];
        lens=[lens; length(imids) i j sbp co(sp) CartDist(cs(sp,:)) length(snp) length(snf)];
        
        ilo=max(1,is(1)-25);%GetTimes(t,t(is(1))-0.5);
        is2=ilo:is(end);
            
        lmo=LMOrder(loops(i).LM);
        lor=loops(i).lor(lmo);
        lmor=[];
        o2lm=[];
        f2lm=[];
        for l=1:length(lor)
            lmor(l,:)=lor(l).LMOnRetina(is)';
            o2lm(l,:)=lor(l).OToLM(is)';
            f2lm(l,:)=AngularDifference(co(is)',o2lm(l,:));
        end
        
        [PhDat,spp,tpp,tpcs]=PhaseStuff(PhDat,f2n(is),co(is),s2n(is),so(is),o2n(is),...
            sbp,CartDist(cs(is(1),:)),t(is),cs(is,:),...
            co(is2),f2n(is2),t(is2),o2lm,lmor,f2lm,spee(is),ra_co(is),ra_so(is));
        te=[te;h,ad1];
    
        % plot stuff
        if 1 %(length(imids)>0)
            % plot loop
            if(h==1)  % CW loop
                lcol='k';
            else      % CCW loop
                lcol='g';
            end
            plot(cs(is,1),cs(is,2),lcol,cs(is(1:3),1),cs(is(1:3),2),'r-d', ...
                cs(is(psi0),1),cs(is(psi0),2),'ro',cs(is(f2n0),1),cs(is(f2n0),2),'gs',...
                cs(is(b),1),cs(is(b),2),'rx',cs(is(spp),1),cs(is(spp),2),'k.',...
                tpcs(:,1),tpcs(:,2),'k*')
            text(cs(is(spp),1),cs(is(spp),2),int2str(round(f2n(is(spp))*180/pi)))
                
        end
        tpc(j).tpcs=tpcs;
        if(j==lnums(1))
            oldis=is;
        end
        title(['flight ' int2str(i) '; loop ' int2str(j)])
%         input('press any key to continue')
    end
    if(sum(ps)>0)        
        ibet=(oldis(end)+1):(is(1)-1);
        plot(cs(ibet,1),cs(ibet,2),'r:'),
        %     text(cs(is(1),1),cs(is(1),2),int2str(j))
        title(['flight ' int2str(i)])% '; loop ' int2str(j)])
        hold off
        axis equal
    end
    figure(11)
    isp=[(oldis(1)-3):(is(end)+3)];diff(t(isp))
    BeePathNew(cs,isp,so,loops(i).LM,loops(i).LMw,[0 0])
    hold on
    text(cs(isp(1),1),cs(isp(1),2),'S')
    for j=lnums%(2)
         plot(tpc(j).tpcs(:,1),tpc(j).tpcs(:,2),'kx')
         fstr=[0 60 100]
         for k=1:size(tpc(j).tpcs,1)
             text(tpc(j).tpcs(k,1),tpc(j).tpcs(k,2),int2str(fstr(k)))
         end
    end
    hold off
    tbit=t(isp([1 end]));
    fn=loops(i).fn;
end

function BeePathNew(Cents,iall,sOr,LM,LMWid,nest,compassDir)
if(nargin<3) 
    load(Cents);
end
if(nargin<7)
    compassDir=4.9393;
end
if(nargin<8)
    bsize=14;
end

so=sOr+compassDir;
[ep(:,1) ep(:,2)]=pol2cart(so,1.25);
EndPt=-ep+Cents;
PlotNestAndLMs(LM,LMWid,nest,0)
hold on;
plot(Cents(iall,1),Cents(iall,2),'k.','MarkerSize',bsize)
plot([Cents(iall,1) EndPt(iall,1)]',[Cents(iall,2) EndPt(iall,2)]','k')
hold off
axis equal

function SelectAllZigZags(co,cs,t,imids,LM,LMw,Speeds)

% Select the turning points
mf=MeanFlightAng(co);
[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(mf,t,0.17,0.04,0);
ex=[ma mi];
subplot(1,2,1)
PlotNestAndLMs(LM,LMw,[0 0],0);
hold on;
plot(cs(:,1),cs(:,2),cs(ex,1),cs(ex,2),'o',cs(imids,1),cs(imids,2),'rx')
axis equal
hold off
sp=1;
while 1
    subplot(1,2,1)
    [ind,b]=GetNearestClickedPt(cs(ex,:),'click end of ZZ; return to stop');
    if(ind==0)
        meana=mf(en);
        break;
    else
        en=ex(ind);
        is=sp:en;
        subplot(1,2,2)
        PlotNestAndLMs(LM,LMw,[0 0],0);
        hold on;
        plot(cs(is,1),cs(is,2),cs(ex(1:ind),1),cs(ex(1:ind),2),'o')%,cs(imids,1),cs(imids,2),'rx')
        axis equal
        hold off
    end
end
dco=AngularDifference(meana,co(is));
% get the zigzag
ztimeP=[];
zdsP=[];
[rspzz,ztimeP,zdsP,rtz,izP,rtzA,rtDat]=GetZZData2(dco,cs(is),t(is),ztimeP,zdsP,Speeds(is)',co(is));
[zztime2,ztime2,zds2,tz2,iz2,zzd]=GetZZData(dang2,10,cs,ts,zztime2,ztime2,zds2,tz2);
 

function[zzls,zls,zds,tzz,izz,zzds]=GetZZData(dang,athresh,cs,ts,zzls,zls,zds,tzz)

% zigs=find(dang<-athresh);
% zags=find(dang>athresh);
% [zig1,zig2,lzig,zigas]=GetZigOrZag(zigs,cs);
% [zag1,zag2,lzag,zagas]=GetZigOrZag(zags,cs);

tps=find(diff(dang>0));

tpts=ts(tps);
zls=[zls diff(tpts)];
zds=[zds diff(diff(tpts))];
c=1;
zzds=[];
for i=1:(length(tps)-1)
    is=tps(i):tps(i+1);
    ds=diff(cs(is,:));
    zzds(i)=sum(CartDist(ds));
end
izz=[];
allt=[];
while 1
    if(length(tps)>=c+2) 
        zzls=[zzls ts(tps(c+2)-1)-ts(tps(c))];
        is=tps(c):tps(c+2)-1;   
        relt=(ts(is)-ts(is(1)))/zzls(end);
        allt=[allt relt];
        tzz=[tzz relt];
        izz=[izz is];    
        c=c+1;
    else break;
    end
end

function[relsp,zls,zds,tzz,izz,tzza,rtdat,zzds,zzang,zzangl]= ...
    GetZZData2(dang,cs,ts,zls,zds,sp,fdir)

% figure(1),
[ma_t,ma_s,mi_t,mi_s,ma,mi]=GetArcs(dang,ts,pi/20,0.03,0);
tps=sort([ma mi]);
pm=sin(dang(tps))>0;
c=1;
while(c<length(tps))
    s=mod(pm(c)+1,2);
    if(pm(c+1)==s) c=c+1;
    else
        tps=tps([1:c c+2:end]);
        pm=sin(dang(tps))>0;
    end
end
% figure(2),plot(cs(:,1),cs(:,2),cs(mi,1),cs(mi,2),'gs',cs(ma,1),cs(ma,2),'ro'...
%     ,cs(tps,1),cs(tps,2),'k*')
tpts=ts(tps);
zls=[zls diff(tpts)];
zds=[zds diff(diff(tpts))];
zzds=[];izz=[];relsp=[];tzz=[];zzang=[];zzangl=[];
if(length(tps)>1)
    for i=1:(length(tps)-1)
        is=tps(i):(tps(i+1)-1);
        ds=diff(cs(is,:));
        zzds(i)=sum(CartDist(ds));
        sp(i)=ts(is(1));
        relt=ts(is)-ts(is(1));
        maxrel(i)=max(relt);
        tzz=[tzz relt/maxrel(i)];
        izz=[izz is];
        prc90(i)=prctile(sp(is),90);
        relsp=[relsp sp(is)/prc90(i)];
        fd=fdir(is);
        [zzang(i),zzangl(i)]=MeanAngle(fd(abs(dang(is))<=(pi/18)));
    end

    % approximate 1st bit
    is=1:(tps(1)-1);
    if(~isempty(is))
        rtdat.len1=max(maxrel(1),ts(is(end))-ts(is(1)));
        rtdat.sp1=ts(is(end))-rtdat.len1;
        relt=ts(is)-rtdat.sp1;
        tzza=[relt/rtdat.len1 tzz];
    else
        tzza=tzz;
        rtdat.len1=maxrel(1);
        rtdat.sp1=sp(1);        
    end
    % relsp=[sp(is)/prc90(1) relsp];

    % approximate last bit
    is=(tps(end)):length(ts);
    if(~isempty(is))
        rtdat.sp2=ts(is(1));        
        relt=ts(is)-rtdat.sp2;
        rtdat.len2=max(maxrel(end),relt(end));
        tzza=[tzza relt/rtdat.len2];
    else
        rtdat.len2=maxrel(end);
        rtdat.sp2=sp(end);        
    end
else
    rtdat.sp1=ts(1);
    rtdat.sp2=ts(1);
    relt=ts-ts(1);
    mr=max(relt);
    rtdat.len1=mr;
    rtdat.len2=mr;
    tzza=relt/mr;
end


function[mf]=MeanFlightAng(co)
for i=1:length(co)
    mf(i)=MeanAngle(co(1:i));
end

function PlotCoinPoints(Coins,l,LM,LMw,dlim,col)

is=Coins.ds>dlim;
% is=(Coins.ds>dlim)&(abs(Coins.nor)<(pi/18));

[ep(:,1) ep(:,2)]=pol2cart(Coins.so(is),l);
cs=Coins.cs(is,:);
ep=cs+ep;

figure(1)
PlotNestAndLMs(LM,LMw,[0 0],0);
hold on;
plot(ep(:,1),ep(:,2),[col '.'])
plot([cs(:,1) ep(:,1)]',[cs(:,2) ep(:,2)]',col)
axis equal
hold off
figure(2)
[y,x]=AngHist(Coins.nor*180/pi);
[ya,x]=AngHist(Coins.nor_allfr*180/pi);
plot(x,y/sum(y),col,x,ya/sum(ya),[col ':'])
axis tight
ylow(0)
xlabel('retinal nest position')

% get coincident points as per 2nd option: 3 psi=0; 2 f2n=0; 1 both (default)
% 1st option is outs vs ins via loops file: loopstatstemp is outs, loopstatsIn = ins
% default is loopstatstemp
% 2rd option is whther to show 
% GetCoincidentPoints('loopstatstemp',3)  % does outs with psi=0
% GetCoincidentPoints('loopstatsIn',1)   % does ins with both =0
% GetCoincidentPoints                    % does outs with both =0
function[NestCo]=GetCoincidentPoints(lfname,opt)

Coins.cs=[];
Coins.ds=[];
Coins.so=[];
Coins.nor=[];
Coins.nor_allfr=[];

if(nargin<2)
    opt=1;
end
if((nargin<1)||(isequal(lfname,'loopstatstemp'))) 
    load loopstatstemp
    if(isfile('processzigzagsout.mat'))
        load('processzigzagsout.mat');
        zz=fltsec;
    else
        zz=[];
    end
    if(isfile('processflightsecOut'))
        load('processflightsecOut');
    else
        fltsec=[];
    end
    infiles=0;
else
    infiles=1;
    zzfile='processzigzagsin';
    load(zzfile)
    zz=fltsec;
    load(lfname)
    if(isfile('processflightsecIn'))
        load('processflightsecIn');
    else
        fltsec=[];
    end
end

nf=0;
PhDat.c=zeros(1,4);numloop=0;
nloops=length(loops);
for i=1:nloops
    ps=find([loops(i).Picked]);
    co=AngularDifference(loops(i).Co,0);
    
    cs=loops(i).cs;
    ppsi=loops(i).fdir;
    f2n=loops(i).f2n;
    s2n=loops(i).nor;
    o2n=loops(i).o2n;

    % this is body orientation in compass coords not image
    so=AngularDifference([loops(i).so]',0);
%     if(isempty(NDir)) 
%         else
%         
%     end;
    NDir=4.9393; 
    if(i==1)
        disp(' this only works for 2007 data')
    end
    so=mod(so+NDir,2*pi);
%     so=AngularDifference(o2n,s2n);
    
    t=loops(i).t;
    ds=CartDist(cs);

    % get all coincident points
    [pall0]=Thru0Pts(ppsi,t,pi/18,[],0.08);
    [fall0]=Thru0Pts(f2n,t,pi/18,[],0.08);
    if(opt==3)
        ball=pall0;
    elseif(opt==2)
        ball=fall0;
    else
        ball=intersect(pall0,fall0);
    end
    [dum,dum,blenall,imidall]=StartFinish(t,ball,0.05);
    NestCo(i).co=co;
    NestCo(i).so=so;
    NestCo(i).t=t;
    NestCo(i).cs=cs;
    NestCo(i).psi=ppsi;
    NestCo(i).f2n=f2n;
    NestCo(i).inds=ball;
    NestCo(i).incids=[imidall;blenall];
    NestCo(i).is=1:length(t);
    if(infiles)
        revd=ds(end:-1:1);
        sp=length(t)-find(revd>5,1)+1;
        NestCo(i).begis=sp+1:length(t);
    else
        NestCo(i).begis=1:find(ds>5,1)-1;
    end
    Coins.cs=[Coins.cs;cs(imidall,:)];
    Coins.ds=[Coins.ds;ds(imidall)];
    Coins.so=[Coins.so;so(imidall)];
    Coins.nor=[Coins.nor;s2n(imidall)];
    Coins.nor_allfr=[Coins.nor_allfr;s2n(ball)];
    
    NestCo(i).cutoff=find(ds<2.5,1);
    
    if(isempty(loops(i).loop))
        NestCo(i).lallis=[];
        NestCo(i).lis=[];
        NestCo(i).loo=[];
        NestCo(i).ps=[];
    else
        NestCo(i).lallis=unique([loops(i).loop.is]);
        NestCo(i).lis=unique([loops(i).loop(ps).is]);
        NestCo(i).loo=loops(i).loop;
        NestCo(i).ps=loops(i).Picked;
    end
    NestCo(i).Lallincids=intersect(imidall,NestCo(i).lallis);
    NestCo(i).Lallinds=intersect(ball,NestCo(i).lallis);
    
    % find the correct zz file  
    fn=loops(i).fn;
    NestCo(i).zallis=[];
    NestCo(i).zis=[];
    NestCo(i).zst=[];
    NestCo(i).lst=[];
    NestCo(i).allzst=[];
    NestCo(i).zzf=0;
    NestCo(i).zz=[];
    for k=1:length(zz)
        if(isequal(fn,zz(k).fn))
            if(~isempty(zz(k).fsec))
                NestCo(i).zz=zz(k).fsec;
                NestCo(i).zzf=1;
                NestCo(i).zallis=unique([zz(k).fsec.is]);
                for z=1:length(zz(k).fsec)
                    zis=zz(k).fsec(z).is;
                    NestCo(i).allzst(z)=t(zis(1));
                    if(length(zis)>=4)
                        NestCo(i).zst=[NestCo(i).zst t(zis(1))];
                        NestCo(i).zis=unique([NestCo(i).zis zis]);
                    end
                end
            end
            break;
        end
    end

    % get %ages of flights
    NestCo(i).lens=[length(t) length(NestCo(i).lallis) length(NestCo(i).lis) ...
        length(NestCo(i).zallis) length(NestCo(i).zis) length(NestCo(i).begis)];
    
    % get # and %ages of coincident points
    NestCo(i).nlks=[length(imidall) length(NestCo(i).Lallincids) ...
        length(intersect(imidall,NestCo(i).lis)) length(intersect(imidall,NestCo(i).zallis)) ...
        length(intersect(imidall,NestCo(i).zis)) length(intersect(imidall,NestCo(i).begis))];
    NestCo(i).pcs=100*[NestCo(i).lens(2:end)/NestCo(i).lens(1) ...
        NestCo(i).nlks(2:end)/NestCo(i).nlks(1)];
    
    n1=NestCo(i).lens(1)-NestCo(i).lens(6);
    n2=NestCo(i).nlks(1)-NestCo(i).nlks(6);
    NestCo(i).pc2=100*[NestCo(i).lens(2:end-1)/n1 ...
        NestCo(i).nlks(2:end-1)/n2];
    NestCo(i).LM=loops(i).LM;
    NestCo(i).LMw=loops(i).LMw;

    NestCo(i).Lincids=[];
    NestCo(i).Linds=[];

    % check all coincident points
%     NestCoCh(i)=CheckAllCoin(NestCo(i),i,nloops);
%     save NestCoDat  NestCo nloops -append
    
%     SelectAllZigZags(co,cs,t,imidall,loops(i).LM,loops(i).LMw,ds)
%     keyboard
    
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);
    ra_co=MyGradient(AngleWithoutFlip(co),t);
    ra_so=MyGradient(AngleWithoutFlip(so),t);
    
    % find the correct straight file  
    lnum=-1;
    fn=loops(i).fn;
    for k=1:length(fltsec)
        if(isequal(fn,fltsec(k).fn))
            if(isempty(fltsec(k).fsec))
                lnum=-1;
            else
                lnum=k;
            end
            break;
        end
    end
    % get the indices of all the straight lines
    if(lnum>0)
        fsec=fltsec(lnum).fsec;
        is_str=[fsec.is];
        fsecs=[];
        for k=1:length(fsec)
            fsecs=[fsecs k*ones(size(fsec(k).is))];
        end
    end

    if(sum(ps)) nf=nf+1; end
    for j=1:length(ps)
        numloop=numloop+1;
        is=loops(i).loop(ps(j)).is;
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        sp=is(1);ep=is(end);
                
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
        [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
        b=intersect(psi0,f2n0);
        NestCoin(numloop).coin=is(b);
        NestCoin(numloop).lk=~isempty(b);
        NestCo(i).lst=[NestCo(i).lst t(is(1))];
        
        % get incidents from frames
        [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
        [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
        [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
        [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        NestCo(i).Lincids=[NestCo(i).Lincids [is(imids);blens]];
        NestCo(i).Linds=[NestCo(i).Linds is(b)];
          
    end
end
LM=loops(1).LM;
LMWid=loops(1).LMw;
nest=[0 0];
if(infiles)
    save CoinPointsZZ Coins NestCo nest LM LMWid
else
    save CoinPointsLoop Coins NestCo nest LM LMWid
end

function CheckCoincidentPonts(outfn)

% outfn='NestCoDat.mat';

% ProcessNestCoin(outfn)
% load('NestCoDataIn 2east1_13.mat');
if(isfile(outfn))
    load(outfn);
else
	NestCo=GetCoincidentPoints;%('loopstatsIn');
    nloops=length(NestCo);
    save(outfn,'NestCo','nloops');
end
for i=1:nloops
    if((exist('NestCoCh','var'))&&(length(NestCoCh)>=i))%NestCoCh(i).checked==1)
%         CheckAllCoin(NestCoCh(i),i,nloops);
    else
        NestCoCh(i)=CheckAllCoin(NestCo(i),i,nloops);
        save(outfn,'NestCoCh','-append');
    end
end

function ProcessNestCoin(outfn)
load(outfn)% NestCoDat
for i=1:length(NestCoCh)
    fs=Frequencies(NestCoCh(i).CoinType,1:5);
    pcs(i,:)=100*fs(1:4)./sum(fs(1:4));
    NestCoCh(i).f2n=[NestCoCh(i).f2n]';
    NestCoCh(i).psi=[NestCoCh(i).psi]';
end
plotOverf2n([NestCoCh.f2n],[NestCoCh.psi],'k',0)
mean(pcs(~isnan(pcs(:,1)),:),1)
keyboard


function plotOverf2n(relf,ppsi,cst,isho)%,so,rellm,cc,o2lm,o2n,s2n,spee,ra_co,ra_so,fs)

thf=-190:20:190;
thp=thf;
[Dpsi,xs,ys,xps,yps]=Density2DAng(relf*180/pi,ppsi*180/pi,thf,thp);
[da1,n]=StatsOverX(relf,ppsi,thf*pi/180);
[y,x]=AngHist(da1(10).x*180/pi,[],[],0);

subplot(2,1,1)
contourf(xps,yps,Dpsi)
axis tight;xlabel('f to nest');ylabel('psi')
subplot(2,1,2)
plot(x,y/sum(y),cst)
Setbox;
axis tight;title('psi when flying towards nest')
if(isho)
    hold on;
else
    hold off;
end
return;

%         ylabel(char(tst(vs(i),:)))


% subst='subplot(4,3,i)';
% vs=1:12;
subst='subplot(1,3,i)';
vs=[1 7:8];
% subst='MotifFigs(gcf,1)';
% subst='figure(fs(i));MotifFigs(gcf,1)';
% vs=[12];
hists=1;
if(fs(1)>40)
    g=13;
else
    g=7;
end
g=[7 13];
[da1,n]=StatsOverX(relf,ppsi,[-190:20:190]*pi/180);
% [da2,n]=StatsOverX(relf,cc,[-190:20:190]*pi/180);
% [da3,n]=StatsOverX(relf,so,[-190:20:190]*pi/180);
% [da4,n]=StatsOverX(relf,o2n,[-190:20:190]*pi/180);
% [da5,n]=StatsOverX(relf,o2lm(1,:),[-190:20:190]*pi/180);
% [da6,n]=StatsOverX(relf,o2lm(2,:),[-190:20:190]*pi/180);
[da7,n]=StatsOverX(relf,s2n,[-190:20:190]*pi/180);
[da8,n]=StatsOverX(relf,rellm(1,:),[-190:20:190]*pi/180);
% [da9,n]=StatsOverX(relf,rellm(2,:),[-190:20:190]*pi/180);
% [da10,n]=StatsOverX(relf,spee,[-190:20:190]*pi/180);
[da11,n]=StatsOverX(relf,abs(ra_co),[-190:20:190]*pi/180);
[da12,n]=StatsOverX(relf,abs(ra_so),[-190:20:190]*pi/180);
np=n*180/pi;
% figure(fs(1))
% plot(np,[da1.meang]*180/pi,np,[da2.meang]*180/pi,'r:',np,[da3.meang]*180/pi,'k:',np,-[da4.meang]*180/pi,'b:x')
% grid on,axis tight
if(ischar(fs(1)))
    save(fs);
    return;
end
tst={'psi';'fdir';'body';'o to nest';'o to NLM';'o to SLM';'nest ret';'N LM ret';...
    'S LM ret';'speed';'df/dt';'dflight/df2nest'};%'dbody/dt'};
figure(fs(1))
for i=1:length(vs)
    eval(subst);
    eval(['dp=da' int2str(vs(i))]);
%     plot(np,dp.meang*180/pi,cst)
    if(vs(i)<10) 
%         errorbar(np,[dp.meang]*180/pi,[dp.angsd]*180/pi,cst)
        % plot data and sd's
        ma=140;
        plot(np,[dp.meang]*180/pi,cst,np,ma+[dp.angsd]*180/pi,cst, ...
            np([1 end]), [ma ma],'k')

        % plot n's as a percentage. Need to scale them all
        % slot is 90degs = 20% so 1%=90/20=4.5 Take off 190 to put at bottom
%         ma=-100;
%         pc=100*[dp.n]./sum([dp.n]);
%         plot(np,pc*4.5-190,cst,np([1 end]), [ma ma],'k')
    else
%         errorbar(np,[dp.me],[dp.sd],cst)
        plot(np,[dp.med],cst)
    end
    grid on;
    axis tight;
    if(isho) 
        hold on;
    else
        hold off;
    end
%     ylabel(char(tst(vs(i),:)))
     title(char(tst(vs(i),:)))

    if(vs(i)<10) 
        ylim([-190 200])
    end
    
%     xlabel('f rel 2 nest')
end
if hists
    figure(fs(2))
    for i=1:length(vs)
        eval(subst);
        eval(['dp=da' int2str(vs(i))]);
        if(vs(i)<10)
            [y,x]=AngHist(dp(10).x*180/pi,[],[],0);
        else
%             [y,x]=hist(dp(10).x,20);
            [y,x]=hist(dp(10).x,0:.1:2);
        end
        plot(x,y/sum(y),cst)
        Setbox;
        axis tight;
        if(isho)
            hold on;
        else
            hold off;
        end
        ylabel(char(tst(vs(i),:)))
    end
    figure(fs(3))
    for i=1:length(vs)
        eval(subst);
        eval(['dp=da' int2str(vs(i))]);
        if(vs(i)<10)
            [y,x]=AngHist(dp(g(1)).x*180/pi,[],[],0);
            [y1,x]=AngHist(dp(g(2)).x*180/pi,[],[],0);
        else
%             [y,x]=hist(dp(g(1)).x,20);
            [y,x]=hist(dp(g(1)).x,0:.1:2);
            [y1,x]=hist(dp(g(2)).x,x);
        end
        %     plot(x,y/sum(y),cst)%,x,y1/sum(y1),cst)
        plot(x,y/sum(y),cst,x,y1/sum(y1),cst)
        axis tight;
        Setbox;
        if(isho)
            hold on;
        else
            hold off;
        end
        ylabel(char(tst(vs(i),:)))
    end
end


function DuplicateFiles
% load processzigzagsin
% load processflightsecIn
% isequal(fltsec.fn,zz.fn)
% for i=1:16
%     is(i)=isequal(fltsec(i).fn,zz(i).fn)
% %     gfiles{i}=fltsec(i).fn;
% end
clear
load tempzz
load loopstatsInOrigWDuplicates
zzfiles=strvcat(zz.fn)
origfiles=strvcat(loops.fn);
for i=1:length(loops)
    if(isempty(strmatch(loops(i).fn,zzfiles,'exact')))
        b(i)=1;
    else
        b(i)=0;
    end
end
duplicatefiles=origfiles(b==1,:)
loops=loops(b==0)
% save loopstatsIn
clear
load processzigzagsin
zzfiles=strvcat(fltsec.fn);
load loopstatstemp
c=strvcat(loops.fn);
% f=dir('E8*All.mat');
f=dir('2w20*All.mat');
allf=strvcat(zzfiles,c);
for i=1:length(f)
    if(isempty(strmatch(f(i,:).name,allf,'exact')))
        b(i)=1;
    else
        b(i)=0;
    end
end
dup=strvcat(f(b==1).name)
[length(loops) size(zzfiles,1) length(f) size(dup,1)]



function[NestCo]=CheckAllCoin(NestCo,nf,numf)
NestCo.checked=0;
co=NestCo.co;
if(isempty(NestCo.incids))
    NestCo.checked=1;
    NestCo.znum=[];
    NestCo.lnum=[];
    NestCo.nznum=[];
    NestCo.nlnum=[];
    NestCo.CoinType=[];
    NestCo.BegType=[];
    NestCo.zzsec.is=[];
    NestCo.lsec.is=[];
    return
else
    coin=NestCo.incids(1,:);
end
cs=NestCo.cs;
t=NestCo.t;
zinds=NestCo.zis;
linds=NestCo.lis;
begs=NestCo.begis;

% Select the turning points
% mf=MeanFlightAng(co);
% [ma_t,ma_s,mi_t,mi_s,ma,mi]=GetMaxAndMins(mf,t,0.17,0.04,0);
% ex=[ma mi];

if(isfield(NestCo,'CoinType'))
    CoinType=NestCo.CoinType;
    BegType=NestCo.BegType;
    for j=1:length(coin)
        zzsec(j).is=NestCo.zzsec(j).is;
        lsec(j).is=NestCo.lsec(j).is;
    end
else
    
    CoinType=zeros(size(coin))*NaN;
    BegType=zeros(size(coin));
    NestCo.znum=zeros(size(coin));
    NestCo.lnum=zeros(size(coin));
    NestCo.nznum=zeros(size(coin));
    NestCo.nlnum=zeros(size(coin));
    for j=1:length(coin)
        zzsec(j).is=[];
        lsec(j).is=[];
    end
end
i=1;
sc=coin(i);
intp=50;
intm=50;
maxi=length(t);
tstr={'ZZ';'LOOP';'BOTH';'NONE';'EXCLUDED'};
while 1
    is=max(1,sc-intm):min(maxi,sc+intp);
    coint=intersect(coin,is);
    zis=intersect(zinds,is);
    lis=intersect(linds,is);
    zls=intersect(zis,lis);
    bis=intersect(begs,is);
    nzis=intersect([zzsec.is],is);
    nlis=intersect([lsec.is],is);

    if(isnan(CoinType(i)))
        if(ismember(sc,zls))
            CoinType(i)=3;
            for j=1:length(NestCo.zz)
                if(ismember(sc,NestCo.zz(j).is))
                    NestCo.znum(i)=j;
                    break
                end
            end
            for j=1:length(NestCo.loo)
                if((NestCo.ps(j))&&(ismember(sc,NestCo.loo(j).is)))
                    NestCo.lnum(i)=j;
                    break;
                end
            end
        elseif(ismember(sc,zis))
            CoinType(i)=1;
            for j=1:length(NestCo.zz)
                if(ismember(sc,NestCo.zz(j).is))
                    NestCo.znum(i)=j;
                    break
                end
            end
        elseif(ismember(sc,lis))
            CoinType(i)=2;
            for j=1:length(NestCo.loo)
                if((NestCo.ps(j))&&(ismember(sc,NestCo.loo(j).is)))
                    NestCo.lnum(i)=j;
                    break;
                end
            end
        elseif(ismember(sc,[zzsec.is]))
            CoinType(i)=1;
            for j=1:length(zzsec)
                if(ismember(sc,zzsec(j).is))
                    NestCo.nznum(i)=j;
                    break
                end
            end
        elseif(ismember(sc,[lsec.is]))
            CoinType(i)=2;
            for j=1:length(lsec)
                if(ismember(sc,lsec(j).is))
                    NestCo.nlnum(i)=j;
                    break
                end
            end
        else
            CoinType(i)=4;
        end
        if(ismember(sc,bis))
            BegType(i)=1;
        end
    end
    PlotNestAndLMs(NestCo.LM,NestCo.LMw,[0 0],0);
    hold on;
    plot(cs(is,1),cs(is,2),'b',cs(coint,1),cs(coint,2),'ro','MarkerSize',8)
    plot(cs(lis,1),cs(lis,2),'k.',cs(nlis,1),cs(nlis,2),'r.',...
        cs(zis,1),cs(zis,2),'kx',cs(nzis,1),cs(nzis,2),'rx',...
        cs(sc,1),cs(sc,2),'g*',cs(bis,1),cs(bis,2),'g','MarkerSize',8,'LineWidth',1.5) 
    text(cs(is(1),1),cs(is(1),2),'START');
    axis equal
    hold off
    xlabel('z=ZZ; l=loop; b=both; n=none; x=excluded; u=back; return=done; cursors add points')
    ts=(['file ' int2str(nf) '/' int2str(numf) '; point ' int2str(i) '/' ...
        int2str(length(coin)) ' is a ' char(tstr(CoinType(i)))]);
    if(BegType(i))
        ts=[ts '; START'];
    end
    title(ts);
    [x,y,inp]=ginput(1);
    if(isempty(inp))  % move on
        i=i+1;
        if(i>length(coin))
            break;
        else
            sc=coin(i);
            intp=25;
            intm=25;
        end
    elseif(isequal(inp,122)) % zigzag
        CoinType(i)=(1);
        if(~ismember(sc,zis))
            if(~ismember(sc,[zzsec.is]))
                hold on
                zzsec(i).is=SelectFlightSectionV2(cs,is,'ZZ');
                NestCo.nznum(i)=i;
                hold off
            else
                for j=1:length(zzsec)
                    if(ismember(sc,zzsec(j).is))
                        NestCo.nznum(i)=j;
                        break
                    end
                end
            end
        end
    elseif(isequal(inp,108)) % loop
        CoinType(i)=(2);
        if(~ismember(sc,lis))
            if(ismember(sc,[lsec.is]))
                for j=1:length(lsec)
                    if(ismember(sc,lsec(j).is))
                        NestCo.nlnum(i)=j;
                        break
                    end
                end
            elseif(ismember(sc,[NestCo.lallis]))
                j=1;
                while 1
                    tlis=NestCo.loo(j).is;
                    if(ismember(sc,tlis))
                        hold on;
                        h=plot(cs(tlis,1),cs(tlis,2),'r.');
                        hold off;
                        title('y = pick this loop; return next loop')
                        [x,y,b]=ginput(1);
                        delete(h);
                        if(isequal(b,121))
                            lsec(i).is=tlis;
                            NestCo.nlnum(i)=i;
                            break;
                        end
                    end
                    j=j+1;
                    if(j>length(NestCo.loo))
                        j=1;
                    end
                end
            else
                hold on
                lsec(i).is=SelectFlightSectionV2(cs,is,'loop');
                NestCo.nlnum(i)=i;
                hold off
            end
        end
    elseif(isequal(inp,98))  % both
        CoinType(i)=(3);
    elseif(isequal(inp,110))  % none
        CoinType(i)=(4);
    elseif(isequal(inp,120))  % excluded
        CoinType(i)=(5);
    elseif(isequal(inp,30))  % add points in front
        intp=intp+3;
    elseif(isequal(inp,31))  % add points in back
        intm=intm+3;
    elseif(isequal(inp,117)) % go back one point
        i=i-1;
        sc=coin(i);
    end
end
NestCo.checked=1;
NestCo.CoinType=CoinType;
NestCo.BegType=BegType;
NestCo.zzsec=zzsec;
NestCo.lsec=lsec;


function[sels]=SelectFlightSectionV2(cs,is,str)
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click start of ' str]);
    if(ind~=0)
        fss=is(ind);
        h=plot(cs(fss,1),cs(fss,2),'ks');
        break;
    end
end
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click end of ' str]);
    if(ind~=0)
        delete(h);
        fse=is(ind);
        if(fse<fss)
            tmp=fss;
            fss=fse;
            fse=fss;
        end
        sels=fss:fse;
        h=plot(cs(sels,1),cs(sels,2),'k-s');
        break
    end
end

while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),'click near ends to adjust; return to end');
    if(ind==0)
        delete(h);
        break;
    else
        ind=is(ind);
        if(abs(fse-ind)<abs(fss-ind))
            fse=ind;
        else
            fss=ind;
        end
        sels=fss:fse;   
        delete(h);
        h=plot(cs(sels,1),cs(sels,2),'k-s');
    end
end

function[sels]=SelectFlightSection(cs,is,str)
fss=[]; h=[]; 
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click start of ' str '; return to end']);
    if(ind==0)
        if(~isempty(fss))
            break;
        end
    else
        delete(h);
        fss=is(ind);
        h=plot(cs(fss,1),cs(fss,2),'ks');
    end
end
h=[]; fse=[];
while 1
    [ind,b]=GetNearestClickedPt(cs(is,:),['click end of ' str '; return to end']);
    if(ind==0)
        if(~isempty(fse))
            break;
        end
    else
        delete(h);
        fse=is(ind);
        sels=fss:fse;
        h=plot(cs(sels,1),cs(sels,2),'k-s');
    end
end


function[psicw,psiaw,f2ncw,f2naw,cocw,coaw,lens]=LoopPsi(ipl)

load loopstatstemp
load processflightsecOut

psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];lens=[];
allco=[];nf=0;nfc=zeros(1,length(loops));nfcc=zeros(1,length(loops));
cwin=[];cwout=[];awin=[];awout=[];starts=[];
psi0aw=[];f2n0aw=[];psi0cw=[];f2n0cw=[];lkcw=[];lkaw=[];
PhDat.c=zeros(1,4);
PhDat.m=[];PhDat.m1=[];PhDat.m2=[];PhDat.m4=[];PhDat.m3=[];
LMListPhase(1).LM=[]; LMListPhase(2).LM=[]; LMListPhase(3).LM=[]; LMListPhase(4).LM=[];

for i=1:length(loops)
    ps=find([loops(i).Picked]);
    co=AngularDifference(loops(i).Co,0);
    so=AngularDifference([loops(i).so]',0);
    cs=loops(i).cs;
    ppsi=loops(i).fdir;
    f2n=loops(i).f2n;
    s2n=loops(i).nor;
    o2n=loops(i).o2n;
    t=loops(i).t;
    
    v1=MyGradient(cs(:,1),t);
    v2=MyGradient(cs(:,2),t);
    [ce_o,spee]=cart2pol(v1,v2);
    ra_co=MyGradient(AngleWithoutFlip(co),t);
    ra_so=MyGradient(AngleWithoutFlip(so),t);
    
    % find the correct straight file  
    lnum=-1;
    fn=loops(i).fn;
    for k=1:length(fltsec)
        if(isequal(fn,fltsec(k).fn))
            if(isempty(fltsec(k).fsec))
                lnum=-1;
            else
                lnum=k;
            end
            break;
        end
    end
    % get the indices of all the straight lines
    if(lnum>0)
        fsec=fltsec(lnum).fsec;
        is_str=[fsec.is];
        fsecs=[];
        for k=1:length(fsec)
            fsecs=[fsecs k*ones(size(fsec(k).is))];
        end
    end

    if(sum(ps)) nf=nf+1; end
    for j=1:length(ps)
        is=loops(i).loop(ps(j)).is;
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        [h,ad1 ad2] = LoopHandednes(co(is));
        sp=is(1);ep=is(end);
                
        %         psi0=find(abs(ppsi(is))<(pi/18));%1:length(is);%
%         f2n0=find(abs(f2n(is))<(pi/18));
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
        [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
        b=intersect(psi0,f2n0);
        
        % get incidents from frames
        [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
        [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
        [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
        [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

        % data vectors
        vecp=[];vecf=[];vecc=[];veclk=[];
        ips=is(ipsi0)';v=ones(size(ips));
        vecp=[cs(ips,:) o2n(ips) psi0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(if2n0)';v=ones(size(ips));
        vecf=[cs(ips,:) o2n(ips) f2n0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(ilk)';v=ones(size(ips));
        veclk=[cs(ips,:) o2n(ips) lklen' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        
% %         lens=[lens blens];
        psif0=circ_median(ppsi(is(f2n0)));% MeanAngle(ppsi(is(f2n0)));% 
        tpsi0=median(t(is(psi0)));
        fpsi0=circ_median(f2n(is(psi0)));% MeanAngle(f2n(is(psi0)));% 
        tf0=median(t(is(f2n0)));
        if(h==1)
            psicw=[psicw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2ncw=[f2ncw;f2n(sp) f2n(ep)];
            f2n0cw=[f2n0cw;vecf];
            psi0cw=[psi0cw;vecp];
            lkcw=[lkcw;veclk];
            nfc(i)=nfc(i)+1;
        else
            psiaw=[psiaw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2naw=[f2naw;f2n(sp) f2n(ep)];
            f2n0aw=[f2n0aw;vecf];
            psi0aw=[psi0aw;vecp];
            lkaw=[lkaw;veclk];
            nfcc(i)=nfcc(i)+1;
        end
        if(~isempty(b))
            %             mp=round(mean(is(b))); % single points
            %             com=MeanAngle(co(is(b)));
            b=imids;        % proper single points
            mp=is(b)';v=ones(size(mp));sp=v*sp;ep=v*ep;  % all the  points
            com=[];
            for l=1:length(sbs)
                com(l)=circ_median(co(is(sbs(l)):is(sens(l))));
            end
            %             com=co(mp);
            vecc=[cs(mp,:) o2n(mp) blens' i*v ps(j)*v so(mp) cs(sp,:) co(mp)];
            if(h==1)
                cocw=[cocw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfc(i)=nfc(i)+1;
                cwin=[cwin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=1;
            else
                coaw=[coaw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfcc(i)=nfcc(i)+1;
                awin=[awin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=3;
            end
        else
            if(h==1)
                cwout=[cwout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=2;
            else
                awout=[awout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=4;
            end
        end;
        isp=sp:(min(sp+3,ep)); m3=MeanAngle(co(isp)); s3=MeanAngle(so(isp));
        isp=sp:(min(sp+5,ep)); m5=MeanAngle(co(isp)); s5=MeanAngle(so(isp));
        sp=sp(1);
        starts=[starts; sbp cs(sp,:) co(sp) so(sp) m3 m5 s3 s5];
        lens=[lens; length(imids) i j sbp co(sp) CartDist(cs(sp,:)) length(snp) length(snf)];
        
        ilo=max(1,is(1)-25);%GetTimes(t,t(is(1))-0.5);
        is2=ilo:is(end);
            
        lmo=LMOrder(loops(i).LM);
        lor=loops(i).lor(lmo);
        lmor=[];
        o2lm=[];
        f2lm=[];
        for l=1:length(lor)
            lmor(l,:)=lor(l).LMOnRetina(is)';
            o2lm(l,:)=lor(l).OToLM(is)';
            f2lm(l,:)=AngularDifference(co(is)',o2lm(l,:));
        end
        
        LMListPhase(sbp).LM=[LMListPhase(sbp).LM;loops(i).LM(lmo(1),:)];
        
        [PhDat,spp,tpp]=PhaseStuff(PhDat,f2n(is),co(is),s2n(is),so(is),o2n(is),...
            sbp,CartDist(cs(is(1),:)),t(is),cs(is,:),...
            co(is2),f2n(is2),t(is2),o2lm,lmor,f2lm,spee(is),ra_co(is),ra_so(is));
        te=[te;h,ad1];
        
        if(lnum>0)            
            [ind,td,fse,i_d]=OlapPt(is_str,fsecs,is,t);
            loops(i).loop(ps(j)).Smini=ind;
            loops(i).loop(ps(j)).Smint=td;
            loops(i).loop(ps(j)).Sfnum=lnum;
            loops(i).loop(ps(j)).Sfsec=fse;
            loops(i).loop(ps(j)).Sang=MeanAngle(fsec(fse).co);
            loops(i).loop(ps(j)).Scs=fsec(fse).cs;
            loops(i).loop(ps(j)).Sis=fsec(fse).is;            
        end
        
    
        % plot stuff
        if 0 %(length(imids)>0)
            % plot whole flight
            if(j>1)
                figure(10),
                PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0)
                hold on;
                plot(cs(oldis,1),cs(oldis,2),'k',cs(oldis(1:3),1),cs(oldis(1:3),2),'r-d'),
                plot(cs(is,1),cs(is,2),cs(is(1:3),1),cs(is(1:3),2),'r-d', ...
                    cs(is(psi0),1),cs(is(psi0),2),'ro',cs(is(f2n0),1),cs(is(f2n0),2),'gs',...
                    cs(is(b),1),cs(is(b),2),'rx',cs(is(spp),1),cs(is(spp),2),'k*'),               
%                 plot(cs(oldis,1),cs(oldis,2),'k',cs(oldis(1:3),1),cs(oldis(1:3),2),'r-d', ...
%                     cs(oldis(psi0),1),cs(oldis(psi0),2),'ro',cs(oldis(f2n0),1),cs(oldis(f2n0),2),'gs',...
%                     cs(oldis(b),1),cs(oldis(b),2),'rx',cs(oldis(spp),1),cs(oldis(spp),2),'k*'),
                ibet=(oldis(end)+1):(is(1)-1);
                plot(cs(ibet,1),cs(ibet,2),'r:'),
                text(cs(is(1),1),cs(is(1),2),int2str(j))
                title(['flight ' int2str(i) '; loop ' int2str(j)])
                hold off
                pause
            end
            
%             if(~isnan(tpp)) spp=[spp tpp];
%             else spp=[];
%             end
%             
%             figure(3),
%             plot(cs(is,1),cs(is,2),cs(is(1:3),1),cs(is(1:3),2),'r-d', ...
%                 cs(is(psi0),1),cs(is(psi0),2),'ro',cs(is(f2n0),1),cs(is(f2n0),2),'gs',...
%                 cs(is(b),1),cs(is(b),2),'rx',cs(is(spp),1),cs(is(spp),2),'k*'),
%             hold on;
%             PlotNestAndLMs(LM,LMWid,[0 0],0);
%             hold off%             title(['cwise: ang1 = ' int2str(ad1) ' ang2 = ' int2str(ad2)])
%             title(['cwise: flight ' int2str(i) '; loop ' int2str(j) 'o=psi0; square f2n=0'])
%             if(lnum>0)
%                 if(td<=0) ibet=fsec(fse).is(end):is(1);
%                 else ibet=is(end):fsec(fse).is(1);
%                 end
%                 hold on; plot(fsec(fse).cs(:,1),fsec(fse).cs(:,2),'r',...
%                     cs(ibet,1),cs(ibet,2),'g:')
%                 hold off,axis equal
%                 xlabel(['time off = ' num2str(td) '; i off = ' int2str(i_d)])
%             end
%             figure(7),
%             subplot(2,1,1)
%             plot(f2n(is)*180/pi,co(is)*180/pi,...
%                 f2n(is(1))*180/pi,co(is(1))*180/pi,'rd',...
%                 f2n(is(psi0))*180/pi,co(is(psi0))*180/pi,'ro',f2n(is(f2n0))*180/pi,co(is(f2n0))*180/pi,'gs',...
%                 f2n(is(b))*180/pi,co(is(b))*180/pi,'rx',f2n(is(spp))*180/pi,co(is(spp))*180/pi,'k*'),
%             axis equal,axis tight
%             subplot(2,1,2)
%             dco=AngularDifference(co(is(1:2:end)));
%             df2n=AngularDifference(f2n(is(1:2:end)));
%             [y,x]=hist(dco./df2n,-2:.05:2);
%             plot(x,y/sum(y)); axis tight;
%             
%             figure(5)
%             plot(t(is),co(is)*180/pi,t(is),f2n(is)*180/pi,'r:',...
%                 t(is(spp)),f2n(is(spp))*180/pi,'k*')
%             if((lnum>0)&&(abs(td)<=0.15))
%                 if(td<=0) ibet=fsec(fse).is(1):is(1);
%                 else ibet=is(end):fsec(fse).is(end);
%                 end
%                 ibet=fsec(fse).is;
%                 hold on;
%                 plot(t(ibet),co(ibet)*180/pi,'g--',t(ibet),f2n(ibet)*180/pi,'g--')
%                 hold off
%             end
%             axis tight
            
        end
        oldis=is;
    end
end
save LoopLMListPhase LMListPhase

if(isequal(loops(1).fn(2),'E'))
    pea=1;
    ephdat=PhDat;
    ecwin=cwin;ecwout=cwout;eawin=awin;eawout=awout;
%      save temp2ELoopPhaseData ephdat ecwin ecwout eawin eawout
%      save temp2ELoopPhaseDataAll% ephdat ecwin ecwout eawin eawout
else
    pea =2;
%     save temp2WLoopPhaseData PhDat %ecwin ecwout eawin eawout
%      save temp2WLoopPhaseDataAll %ecwin ecwout eawin eawout
%     load ../2' east all'/temp2ELoopPhaseData.mat;
    
%     plotPhaseStuff(PhDat)
%     plotPhaseStuff(PhDat,ephdat)
%     plotPhaseStuff(ephdat)
end
% PlotStarts(starts,LM,LMWid,2,cocw(:,8:end),coaw(:,8:end),loops) 
% for i=1:4
%     figure(1)
%     subplot(2,2,i);
%     axis equal;axis([-180 180 -180 180]);
%     xlabel('f dir rel. nest');ylabel('flt dir');
% %     xlabel('body O rel 2 nest');ylabel('body orientation');
%     hold off
% end
% 
% 
% 
% % [mean(lens(lens>0)) median(lens(lens>0))];
% % [x,y]=Frequencies(lens);[y';x]
% % awout=[awout;ewout];awout=[awout;eawout];
% % cwout=[cwout;ecwout];awin=[awin;eawin]
% PlotLoopPsi(psicw,psiaw,f2ncw,f2naw,cocw,coaw,ipl,pea,...
%     cwin*180/pi,awin*180/pi,cwout*180/pi,awout*180/pi)




% think I started something with NestCo which is now in other functions
% going to comment out bits that don't work in here
% have tried to recover this function but it seems to not work which is a
% big worry so I've put an old version back in

function[psicw,psiaw,f2ncw,f2naw,cocw,coaw,lens]=LoopPsiNEW(ipl,lfname)

if(nargin<2) 
    load loopstatstemp
    load processflightsecOut
    zz=[];
    infiles=0;
else
    infiles=1;
    zzfile='processzigzagsin';
    load(zzfile)
    zz=fltsec;
    load(lfname)
    if(isfile('processflightsecIn'))
        load('processflightsecIn');
    else
        fltsec=[];
    end
end

dataw=[];datcw=[];psiaw=[];f2naw=[];psicw=[];f2ncw=[];te=[];cocw=[];coaw=[];lens=[];
allco=[];nf=0;nfc=zeros(1,length(loops));nfcc=zeros(1,length(loops));
cwin=[];cwout=[];awin=[];awout=[];starts=[];
psi0aw=[];f2n0aw=[];psi0cw=[];f2n0cw=[];lkcw=[];lkaw=[];
PhDat.c=zeros(1,4);numloop=0;
PhDat.m=[];PhDat.m1=[];PhDat.m2=[];PhDat.m4=[];PhDat.m3=[];
nloops=length(loops);
LMListPhase(1).LM=[]; LMListPhase(2).LM=[]; LMListPhase(3).LM=[]; LMListPhase(4).LM=[];

% s=dir(['*' str 'All.mat']);  %% Not sure why this is here....
% think I started something with NestCo which is now in other functions
% going to comment out bits that don't work in here
for i=1:nloops
    
    %     cmpdir=4.93;%0.6;%
    %     cmpdir=fltsec(i).cmpdir;
    load(loops(i).fn);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fltsec(i).fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fltsec(i).fn,t,OToNest,[],[]);
    end
   
    ppsi=AngularDifference(loops(i).Co,0);
    f2n=AngularDifference([loops(i).so]',0);
    ds=CartDist(Cents);
    cs=Cents;
    s2n=loops(i).nor;
    
    % get all coincident points
    [pall0]=Thru0Pts(ppsi,t,pi/18,[],0.08);
    [fall0]=Thru0Pts(f2n,t,pi/18,[],0.08);
    ball=intersect(pall0,fall0);
    [dum,dum,blenall,imidall]=StartFinish(t,ball,0.05);
    NestCo(i).co=co;
    NestCo(i).t=t;
    NestCo(i).cs=cs;
    NestCo(i).psi=ppsi;
    NestCo(i).f2n=f2n;
%     NestCo(i).nor=s2n';
    NestCo(i).inds=ball;
    NestCo(i).incids=[imidall;blenall];
    NestCo(i).is=1:length(t);
    if(infiles)
        revd=ds(end:-1:1);
        sp=length(t)-find(revd>5,1)+1;
        NestCo(i).begis=sp+1:length(t);
    else
        NestCo(i).begis=1:find(ds>5,1)-1;
    end
    
    NestCo(i).cutoff=find(ds<2.5,1);
    
%     if(isempty(loops(i).loop))
%         NestCo(i).lallis=[];
%         NestCo(i).lis=[];
%         NestCo(i).loo=[];
%         NestCo(i).ps=[];
%     else
%         NestCo(i).lallis=unique([loops(i).loop.is]);
%         NestCo(i).lis=unique([loops(i).loop(ps).is]);
%         NestCo(i).loo=loops(i).loop;
%         NestCo(i).ps=loops(i).Picked;
%     end
%     NestCo(i).Lallincids=intersect(imidall,NestCo(i).lallis);
%     NestCo(i).Lallinds=intersect(ball,NestCo(i).lallis);
    
%     % find the correct zz file  
%     fn=loops(i).fn;
%     NestCo(i).zallis=[];
%     NestCo(i).zis=[];
%     NestCo(i).zst=[];
%     NestCo(i).lst=[];
%     NestCo(i).allzst=[];
%     NestCo(i).zzf=0;
%     NestCo(i).zz=[];
%     for k=1:length(zz)
%         if(isequal(fn,zz(k).fn))
%             if(~isempty(zz(k).fsec))
%                 NestCo(i).zz=zz(k).fsec;
%                 NestCo(i).zzf=1;
%                 NestCo(i).zallis=unique([zz(k).fsec.is]);
%                 for z=1:length(zz(k).fsec)
%                     zis=zz(k).fsec(z).is;
%                     NestCo(i).allzst(z)=t(zis(1));
%                     if(length(zis)>=4)
%                         NestCo(i).zst=[NestCo(i).zst t(zis(1))];
%                         NestCo(i).zis=unique([NestCo(i).zis zis]);
%                     end
%                 end
%             end
%             break;
%         end
%     end

%     % get %ages of flights
%     NestCo(i).lens=[length(t) length(NestCo(i).lallis) length(NestCo(i).lis) ...
%         length(NestCo(i).zallis) length(NestCo(i).zis) length(NestCo(i).begis)];
%     
%     % get # and %ages of coincident points
%     NestCo(i).nlks=[length(imidall) length(NestCo(i).Lallincids) ...
%         length(intersect(imidall,NestCo(i).lis)) length(intersect(imidall,NestCo(i).zallis)) ...
%         length(intersect(imidall,NestCo(i).zis)) length(intersect(imidall,NestCo(i).begis))];
%     NestCo(i).pcs=100*[NestCo(i).lens(2:end)/NestCo(i).lens(1) ...
%         NestCo(i).nlks(2:end)/NestCo(i).nlks(1)];
%     
%     n1=NestCo(i).lens(1)-NestCo(i).lens(6);
%     n2=NestCo(i).nlks(1)-NestCo(i).nlks(6);
%     NestCo(i).pc2=100*[NestCo(i).lens(2:end-1)/n1 ...
%         NestCo(i).nlks(2:end-1)/n2];
%     NestCo(i).LM=loops(i).LM;
%     NestCo(i).LMw=loops(i).LMw;
%     lmo=LMOrder(loops(i).LM);
%     lor=loops(i).lor(lmo);
%     for j=1:size(loops(i).LM,1)
%         NestCo(i).lmor(j,:)=lor(j).LMOnRetina';
%     end
%     NestCo(i).Lincids=[];
%     NestCo(i).Linds=[];

    % check all coincident points
%     NestCoCh(i)=CheckAllCoin(NestCo(i),i,nloops);
%     save NestCoDat NestCoCh NestCo nloops
    
%     SelectAllZigZags(co,cs,t,imidall,loops(i).LM,loops(i).LMw,ds)
%     keyboard
    
%     v1=MyGradient(cs(:,1),t);
%     v2=MyGradient(cs(:,2),t);
%     [ce_o,spee]=cart2pol(v1,v2);
%     ra_co=MyGradient(AngleWithoutFlip(co),t);
%     ra_so=MyGradient(AngleWithoutFlip(so),t);
    
    % find the correct straight file  
    lnum=-1;
    fn=loops(i).fn;
    for k=1:length(fltsec)
        if(isequal(fn,fltsec(k).fn))
            if(isempty(fltsec(k).fsec))
                lnum=-1;
            else
                lnum=k;
            end
            break;
        end
    end
    % get the indices of all the straight lines
    if(lnum>0)
        fsec=fltsec(lnum).fsec;
        is_str=[fsec.is];
        fsecs=[];
        for k=1:length(fsec)
            fsecs=[fsecs k*ones(size(fsec(k).is))];
        end
    end

    ps=find(loops(i).Picked==1);
    if(sum(ps)) nf=nf+1; end
    for j=1:length(ps)
        numloop=numloop+1;
        is=loops(i).loop(ps(j)).is;
        relt=t(is)-t(is(1));
        relt=relt/max(relt);
        [h,ad1 ad2] = LoopHandednes(co(is));
        sp=is(1);ep=is(end);
                
        %         psi0=find(abs(ppsi(is))<(pi/18));%1:length(is);%
%         f2n0=find(abs(f2n(is))<(pi/18));
        [psi0,meInd,snp]=Thru0Pts(ppsi(is),t(is),pi/18,[],0.08);
        [f2n0,meInd,snf]=Thru0Pts(f2n(is),t(is),pi/18,[],0.08);
        [lk0,meInd]=Thru0Pts(s2n(is),t(is),pi/18,[],0.08);
        b=intersect(psi0,f2n0);
        NestCoin(numloop).coin=is(b);
        NestCoin(numloop).lk=~isempty(b);
%         NestCo(i).lst=[NestCo(i).lst t(is(1))];
        
        % get incidents from frames
        [dum,dum,psi0len,ipsi0]=StartFinish(t(is),psi0,0.05);
        [dum,dum,f2n0len,if2n0]=StartFinish(t(is),f2n0,0.05);
        [dum,dum,lklen,ilk]=StartFinish(t(is),lk0,0.05);
        [sbs,sens,blens,imids]=StartFinish(t(is),b,0.05);

%         NestCo(i).Lincids=[NestCo(i).Lincids [is(imids);blens]];
%         NestCo(i).Linds=[NestCo(i).Linds is(b)];
        
        % data vectors
        vecp=[];vecf=[];vecc=[];veclk=[];
        ips=is(ipsi0)';v=ones(size(ips));
        vecp=[cs(ips,:) o2n(ips) psi0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(if2n0)';v=ones(size(ips));
        vecf=[cs(ips,:) o2n(ips) f2n0len' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        ips=is(ilk)';v=ones(size(ips));
        veclk=[cs(ips,:) o2n(ips) lklen' i*v ps(j)*v so(ips) cs(sp*v,:) co(ips)];
        
% %         lens=[lens blens];
        psif0=circ_median(ppsi(is(f2n0)));% MeanAngle(ppsi(is(f2n0)));% 
        tpsi0=median(t(is(psi0)));
        fpsi0=circ_median(f2n(is(psi0)));% MeanAngle(f2n(is(psi0)));% 
        tf0=median(t(is(f2n0)));
        
        clear d
        d.f2n=f2n(is)';
        d.psi=ppsi(is)';
        d.nor=s2n(is)';
        d.co=co(is)';
        d.t=t(is);
        d.ra_co=ra_co(is);
        d.fltnum=i;

        if(isempty(b)); d.coin=0;
        else d.coin=1;
        end
        for l=1:size(loops(i).LM,1)
            d.lmor(l,:)=NestCo(i).lmor(l,is);
        end
        
        if(h==1)
            psicw=[psicw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2ncw=[f2ncw;f2n(sp) f2n(ep)];
            f2n0cw=[f2n0cw;vecf];
            psi0cw=[psi0cw;vecp];
            lkcw=[lkcw;veclk];
            nfc(i)=nfc(i)+1;
            datcw=[datcw;d];
        else
            psiaw=[psiaw;ppsi(sp) ppsi(ep) fpsi0 psif0 tpsi0 tf0];
            f2naw=[f2naw;f2n(sp) f2n(ep)];
            f2n0aw=[f2n0aw;vecf];
            psi0aw=[psi0aw;vecp];
            lkaw=[lkaw;veclk];
            nfcc(i)=nfcc(i)+1;
            dataw=[dataw;d];
        end
        if(~isempty(b))
            %             mp=round(mean(is(b))); % single points
            %             com=MeanAngle(co(is(b)));
            b=imids;        % proper single points
            mp=is(b)';v=ones(size(mp));sp=v*sp;ep=v*ep;  % all the  points
            com=[];
            for l=1:length(sbs)
                com(l)=circ_median(co(is(sbs(l)):is(sens(l))));
            end
            %             com=co(mp);
            vecc=[cs(mp,:) o2n(mp) blens' i*v ps(j)*v so(mp) cs(sp,:) co(mp)];
            if(h==1)
                cocw=[cocw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfc(i)=nfc(i)+1;
                cwin=[cwin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=1;
            else
                coaw=[coaw;AngularDifference(co(sp),com),...
                    AngularDifference(co(ep),com) co(sp) co(ep) com' ...
                    relt(imids)' t(mp)' vecc];
%                 nfcc(i)=nfcc(i)+1;
                awin=[awin;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=3;
            end
        else
            if(h==1)
                cwout=[cwout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=2;
            else
                awout=[awout;co(is) f2n(is) ppsi(is) so(is) s2n(is)];
                sbp=4;
            end
        end;
        isp=sp:(min(sp+3,ep)); m3=MeanAngle(co(isp)); s3=MeanAngle(so(isp));
        isp=sp:(min(sp+5,ep)); m5=MeanAngle(co(isp)); s5=MeanAngle(so(isp));
        sp=sp(1);
        starts=[starts; sbp cs(sp,:) co(sp) so(sp) m3 m5 s3 s5];
        lens=[lens; length(imids) i j sbp co(sp) CartDist(cs(sp,:)) length(snp) length(snf)];
        
        ilo=max(1,is(1)-25);%GetTimes(t,t(is(1))-0.5);
        is2=ilo:is(end);
            
        lmor=[];
        o2lm=[];
        f2lm=[];
        for l=1:length(lor)
            lmor(l,:)=lor(l).LMOnRetina(is)';
            o2lm(l,:)=lor(l).OToLM(is)';
            f2lm(l,:)=AngularDifference(co(is)',o2lm(l,:));
            % get coincident points for LMs
            [lm0]=Thru0Pts(f2lm(l,:),t(is),pi/18,[],0.08);
            Lm0(l).LMCoin(numloop).inds=is(lm0);
            Lm0(l).LMCoin(numloop).coin=is(intersect(psi0,lm0));
            Lm0(l).LMCoin(numloop).lk=~isempty(Lm0(l).LMCoin(numloop).coin);
        end
        
        [PhDat,spp,tpp]=PhaseStuff(PhDat,f2n(is),co(is),s2n(is),so(is),o2n(is),...
            sbp,CartDist(cs(is(1),:)),t(is),cs(is,:),...
            co(is2),f2n(is2),t(is2),o2lm,lmor,f2lm,spee(is),ra_co(is),ra_so(is));
        te=[te;h,ad1];
        LMListPhase(sbp).LM=[LMListPhase(sbp).LM;LM];
        
        if(lnum>0)            
            [ind,td,fse,i_d]=OlapPt(is_str,fsecs,is,t);
            loops(i).loop(ps(j)).Smini=ind;
            loops(i).loop(ps(j)).Smint=td;
            loops(i).loop(ps(j)).Sfnum=lnum;
            loops(i).loop(ps(j)).Sfsec=fse;
            loops(i).loop(ps(j)).Sang=MeanAngle(fsec(fse).co);
            loops(i).loop(ps(j)).Scs=fsec(fse).cs;
            loops(i).loop(ps(j)).Sis=fsec(fse).is;            
        end
        
    
        % plot stuff
        if 0 %(length(imids)>0)
            % plot whole flight
            if(j>1)
                figure(10),
                PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0)
                hold on;
                plot(cs(oldis,1),cs(oldis,2),'k',cs(oldis(1:3),1),cs(oldis(1:3),2),'r-d'),
                plot(cs(is,1),cs(is,2),cs(is(1:3),1),cs(is(1:3),2),'r-d', ...
                    cs(is(psi0),1),cs(is(psi0),2),'ro',cs(is(f2n0),1),cs(is(f2n0),2),'gs',...
                    cs(is(b),1),cs(is(b),2),'rx',cs(is(spp),1),cs(is(spp),2),'k*'),               
%                 plot(cs(oldis,1),cs(oldis,2),'k',cs(oldis(1:3),1),cs(oldis(1:3),2),'r-d', ...
%                     cs(oldis(psi0),1),cs(oldis(psi0),2),'ro',cs(oldis(f2n0),1),cs(oldis(f2n0),2),'gs',...
%                     cs(oldis(b),1),cs(oldis(b),2),'rx',cs(oldis(spp),1),cs(oldis(spp),2),'k*'),
                ibet=(oldis(end)+1):(is(1)-1);
                plot(cs(ibet,1),cs(ibet,2),'r:'),
                for l=1:length(lor)
                    ilm=Lm0(l).LMCoin(numloop).coin
                    plot(cs((ilm),1),cs((ilm),2),'c*'),
                end
                text(cs(is(1),1),cs(is(1),2),int2str(j))
                title(['flight ' int2str(i) '; loop ' int2str(j)])
                hold off
                pause
            end
            
%             if(~isnan(tpp)) spp=[spp tpp];
%             else spp=[];
%             end
%             
%             figure(3),
%             plot(cs(is,1),cs(is,2),cs(is(1:3),1),cs(is(1:3),2),'r-d', ...
%                 cs(is(psi0),1),cs(is(psi0),2),'ro',cs(is(f2n0),1),cs(is(f2n0),2),'gs',...
%                 cs(is(b),1),cs(is(b),2),'rx',cs(is(spp),1),cs(is(spp),2),'k*'),
%             hold on;
%             PlotNestAndLMs(LM,LMWid,[0 0],0);
%             hold off%             title(['cwise: ang1 = ' int2str(ad1) ' ang2 = ' int2str(ad2)])
%             title(['cwise: flight ' int2str(i) '; loop ' int2str(j) 'o=psi0; square f2n=0'])
%             if(lnum>0)
%                 if(td<=0) ibet=fsec(fse).is(end):is(1);
%                 else ibet=is(end):fsec(fse).is(1);
%                 end
%                 hold on; plot(fsec(fse).cs(:,1),fsec(fse).cs(:,2),'r',...
%                     cs(ibet,1),cs(ibet,2),'g:')
%                 hold off,axis equal
%                 xlabel(['time off = ' num2str(td) '; i off = ' int2str(i_d)])
%             end
%             figure(7),
%             subplot(2,1,1)
%             plot(f2n(is)*180/pi,co(is)*180/pi,...
%                 f2n(is(1))*180/pi,co(is(1))*180/pi,'rd',...
%                 f2n(is(psi0))*180/pi,co(is(psi0))*180/pi,'ro',f2n(is(f2n0))*180/pi,co(is(f2n0))*180/pi,'gs',...
%                 f2n(is(b))*180/pi,co(is(b))*180/pi,'rx',f2n(is(spp))*180/pi,co(is(spp))*180/pi,'k*'),
%             axis equal,axis tight
%             subplot(2,1,2)
%             dco=AngularDifference(co(is(1:2:end)));
%             df2n=AngularDifference(f2n(is(1:2:end)));
%             [y,x]=hist(dco./df2n,-2:.05:2);
%             plot(x,y/sum(y)); axis tight;
%             
%             figure(5)
%             plot(t(is),co(is)*180/pi,t(is),f2n(is)*180/pi,'r:',...
%                 t(is(spp)),f2n(is(spp))*180/pi,'k*')
%             if((lnum>0)&&(abs(td)<=0.15))
%                 if(td<=0) ibet=fsec(fse).is(1):is(1);
%                 else ibet=is(end):fsec(fse).is(end);
%                 end
%                 ibet=fsec(fse).is;
%                 hold on;
%                 plot(t(ibet),co(ibet)*180/pi,'g--',t(ibet),f2n(ibet)*180/pi,'g--')
%                 hold off
%             end
%             axis tight
            
        end
        oldis=is;
    end
end
save LoopLMListPhase LMListPhase
if(nargin>=2)
    save LoopInPhaseDataAll
elseif(isequal(loops(1).fn(2),'E'))
    pea=1;
%     ephdat=PhDat;
%     ecwin=cwin;ecwout=cwout;eawin=awin;eawout=awout;
%      save temp2ELoopPhaseData ephdat ecwin ecwout eawin eawout
     save temp2ELoopPhaseDataAll% ephdat ecwin ecwout eawin eawout
else
    pea =2;
%     save temp2WLoopPhaseData PhDat %ecwin ecwout eawin eawout
     save temp2WLoopPhaseDataAll %ecwin ecwout eawin eawout
%     load ../2' east all'/temp2ELoopPhaseData.mat;
    
%     plotPhaseStuff(PhDat)
%     plotPhaseStuff(PhDat,ephdat)
%     plotPhaseStuff(ephdat)
end
PlotStarts(starts,LM,LMWid,2,cocw(:,8:end),coaw(:,8:end),loops) 
% for i=1:4
%     figure(1)
%     subplot(2,2,i);
%     axis equal;axis([-180 180 -180 180]);
%     xlabel('f dir rel. nest');ylabel('flt dir');
% %     xlabel('body O rel 2 nest');ylabel('body orientation');
%     hold off
% end
% 
% 
% 
% % [mean(lens(lens>0)) median(lens(lens>0))];
% % [x,y]=Frequencies(lens);[y';x]
% % awout=[awout;ewout];awout=[awout;eawout];
% % cwout=[cwout;ecwout];awin=[awin;eawin]
% PlotLoopPsi(psicw,psiaw,f2ncw,f2naw,cocw,coaw,ipl,pea,...
%     cwin*180/pi,awin*180/pi,cwout*180/pi,awout*180/pi)

function[ind,td,fsec,i_d]=OlapPt(is_str,fsecs,isl,t)

[c,ind]=intersect(is_str,isl);
if(~isempty(c))
    td=0;
    i_d=0;
    ind=ind(1);
else
    sp=isl(1);
    ep=isl(end);
    [msp,isp]=min(abs(t(is_str)-t(sp)));
    [mep,iep]=min(abs(t(is_str)-t(ep)));
    if(mep<msp)
        ind=iep;
        dts=t(is_str)-t(ep);
        i_d=is_str(ind)-ep;
    else
        ind=isp;
        dts=t(is_str)-t(sp);
        i_d=is_str(ind)-sp;
    end
    td=dts(ind);
end
fsec=fsecs(ind);
ind=is_str(ind);


function LoopFig7
load loopstatstemp
for i=1:length(loops)
    if(isequal(loops(i).fn,'2E20 12-07-07 13-27 27 out9All.mat'))
        tempL=loops(i);
        break;
    end
end
cs=tempL.cs;
co=tempL.Co;
rco=tempL.Co+4.9393;
len=50;
[psi0,meInd,snp]=Thru0Pts(tempL.fdir,tempL.t,pi/18,[],0.08);
[dum,dum,psi0len,ipsi0]=StartFinish(tempL.t,psi0,0.05);
figure(5)
is=23:length(tempL.t);
plot(cs(is,1),cs(is,2),'b- .')
hold on;
PlotNestAndLMs(tempL.LM,tempL.LMw,[0 0],0);
ipsi0=intersect(is,ipsi0);
% pbs=ipsi0;
% pbs([1 2 3 5])=pbs([1 2 3 5])-1;
% pbs(4)=pbs(4)+1;
% pbs=pbs(1:end-1);
% plot(t(pbs),ppsi(pbs),'gs')
% 
% ppsi=tempL.fdir;
% arco=AngleWithoutFlip(rco);
% for i=1:length(pbs)
%     j=pbs(i);
%     r=ppsi(j+1)-ppsi(j);
%     d=0-ppsi(j)/r;
%     newa(i)=arco(j)+d*(arco(j+1)-arco(j))
% end
% for i=1:length(newa)-1
%     j=ipsi0(i);
%     c=cs(j,:);
%     [x,y]=pol2cart(newa(i),50);
%     plot([c(1) x],[c(2) y],'r')
% end

for i=1:length(ipsi0)
    j=ipsi0(i);
    c=cs(j,:);
    [x,y]=pol2cart(rco(j),50);
    plot([c(1) x],[c(2) y],'k')
end

hold off
keyboard

function allloopdata
% load ../2' east all'/temp'2ELoopPhaseDataAlL.mat'
% datL2E=PhDat.dat1;
% for i=2:4
%     eval(['datL2E=[datL2E PhDat.dat' int2str(i) '];']);
% end
% load ../2' west'/temp2WLoopPhaseDataAll.mat
% datL2W=PhDat.dat1;
% for i=2:4
%     eval(['datL2W=[datL2W PhDat.dat' int2str(i) '];']);
% end
% datL=[datL2E datL2W];
% load ../2' east all'/temp'2EZZPhaseDataAlL.mat'
% datZ2E=PhDat.dat1;
% for i=2:4
%     eval(['datZ2E=[datZ2E PhDat.dat' int2str(i) '];']);
% end
% load ../2' west'/temp2WZZPhaseDataAll.mat
% datZ2W=PhDat.dat1;
% for i=2:4
%     eval(['datZ2W=[datZ2W PhDat.dat' int2str(i) '];']);
% end
% datZ=[datZ2E datZ2W];
% save 2E2WLoopZZPhDat datL datZ datL2E datL2W datZ2E datZ2W
load 2E2WLoopZZPhDat
figure(1),clf
[ccZ,psiZ,relfZ,lZ,rtsZ,tsZ,rafZ,racZ]=getparams(datZ,[],0,0);
[ccL,psiL,relfL,lL,rtsL,tsL,rafL,racL]=getparams(datL,[],1,0);
[y,x]=AngHist(psiL*180/pi);ypl=y./sum(y);
[y,x]=AngHist(psiZ*180/pi);ypz=y./sum(y);
[y,x]=AngHist(relfL*180/pi);yfl=y./sum(y);
[y,x]=AngHist(relfZ*180/pi);yfz=y./sum(y);
[y,xt]=hist(lL,0:0.1:3);yll=y./sum(y);
[y,xt]=hist(lZ,0:0.1:3);ylz=y./sum(y);
% subplot(1,2,1),
% MotifFigs(gcf,1)
plot(x,ypl,x,ypz,'r:')
Setbox,axis tight,ylow(0);
xlabel('psi')
ylabel('frequency')
% figure(2)
% subplot(1,2,2),
% MotifFigs(gcf,1)
plot(x,yfl,x,yfz,'r:')
% plot(xt,yll,xt,ylz,'r:')
Setbox,axis tight,ylow(0);
xlabel('f dir rel to nest')
ylabel('frequency')
% [y,xt]=hist(lL,-0.01:0.02:1);
% [yz,xt]=hist(lZ,-0.01:0.02:1);[y;yz]
t1=0.44;t2=t1+0.02;%0.475;
t1=0.35;t2=t1+0.02;%0.475;
isZ=find((lZ>=t1)&(lZ<=t2))
isL=find((lL>=t1)&(lL<=t2))
figure(7)
[ccZ,psiZ,relfZ,lZ,rtsZ,tsZ,rafZ,racZ]=getparams(datZ(isZ(9:end)),[],1,1);
figure(8)
[ccL,psiL,relfL,lL,rtsL,tsL,rafL,racL]=getparams(datL(isL(8:end)),[],0,1);
[dz,xp]=StatsOverX(tsZ,abs(rafZ),[0:0.04:0.4]-0.01);
[dl,xp]=StatsOverX(tsL,abs(rafL),[0:0.04:0.4]-0.01);
[dz,xp]=StatsOverX(tsZ,[datZ.spee],[0:0.04:0.4]-0.01);
[dl,xp]=StatsOverX(tsL,[datL.spee],[0:0.04:0.4]-0.01);
[dz,xp]=StatsOverX(tsZ,(racZ),[0:0.04:0.4]-0.01);
[dl,xp]=StatsOverX(tsL,(racL),[0:0.04:0.4]-0.01);
errorbar(xp,[dz.me],[dz.sd],'r:')
hold on;errorbar(xp,[dl.me],[dl.sd]),hold off
for i=1:length(dz)
    [y,x]=hist([dz(i).x],0:5:50);yz=y/sum(y);
    [y,x]=hist([dl(i).x],0:5:50);yl=y/sum(y);
    subplot(2,1,1),
    plot(x,yl,x,yz,'r:')
    xlabel('abolute angular rate of change')
    subplot(2,1,2),
    [y,x]=hist([dzr(i).x],-50:5:50);yzr=y/sum(y);
    [y,x]=hist([dlr(i).x],-50:5:50);ylr=y/sum(y);
    plot(x,ylr,x,yzr,'r:')
    xlabel('angular rate of change')
%     pause
end
% [dz,xp]=StatsOverX(abs(relfZ),abs(rafZ),);
[dz,xp]=StatsOverX(tsZ,abs(racZ),[0:0.04:0.4]-0.01);
[dl,xp]=StatsOverX(tsL,abs(racL),[0:0.04:0.4]-0.01);
errorbar(xp,[dz.me],[dz.sd],'r:')
hold on;errorbar(xp,[dl.me],[dl.sd]),hold off
% plot(relfL,tsL,'b.',relfZ,tsZ,'rx')
% plot(relfL,rtsL,'b.',relfZ,rtsZ,'rx')


function[cc,pp,relf,len,tst,tts,rafs,racs]=getparams(dat,m,isho,pl)
relf=[];relc=[];relt100=[];relt60=[];tts=[];cc=[];rellm=[];tst=[];
l1=[];len=[];len2tp=[];relt=[];relt1=[];relt2=[];l2=[];ddd=[];so=[];
o2n=[];o2lm=[];s2n=[];rafs=[];racs=[];
% pl=0;
% is100=~isnan(m(:,29));
% is60=~isnan(m(:,27));
% d1=180/pi*AngularDifference(m(is100,24)*pi/180,m(is100,29)*pi/180);
% d2=180/pi*AngularDifference(m(is60,24)*pi/180,m(is60,27)*pi/180);
% s100=AngularDifference(m(is100,29)*pi/180,0)*180/pi;
% s60=AngularDifference(m(is60,27)*pi/180,0)*180/pi;
% td20=m(:,36)-m(:,37);
% td40=m(:,36)-m(:,38);
% td60=m(:,36)-m(:,39);
% td80=m(:,36)-m(:,40);
% td100=m(:,36)-m(:,41);
% d60=m(:,42)-m(:,45);
% d100=m(:,42)-m(:,47);
for k=1:length(dat)
    inds=dat(k).is;
    inds=1:length(dat(k).t);
    rf=(dat(k).f2n(inds)*pi/180)';
    relf=[relf rf];
    rellm=[rellm dat(k).f2lm(:,inds)];
    o2lm=[o2lm dat(k).o2lm(:,inds)];
    o2n=[o2n dat(k).o2n(inds)'];
    nor=dat(k).s2n(inds)'*pi/180;
    if(isho)
        s2n=[s2n nor];
    else
        s2n=[s2n -nor];
    end
    co=(dat(k).co(inds)*pi/180)';
    so=[so (dat(k).so(inds)*pi/180)'];
    pps=AngularDifference(co,(dat(k).so(inds)*pi/180)');
    cc=[cc co];    
%     relc=[relc AngularDifference(co,m(k,24)*pi/180)];
%     t=dat(k).t(inds)-m(k,36);
      t_st=dat(k).t(inds)-dat(k).t(1);
      
     tts=[tts t_st];
%     relt100=[relt100 t/td100(k)];
%     relt60=[relt60 t/td60(k)];
     len=[len dat(k).t(end)-dat(k).t(1)];
%     len2tp=[len2tp m(k,36)-dat(k).t(1)];
%     l1=[l1 dat(k).t(inds(end))-dat(k).t(inds(1))];
%     l2=[l2 m(k,36)-dat(k).t(inds(1))];
%     relt=[relt t/len(k)];
     tst=[tst t_st/len(k)];
%     relt1=[relt1 t/l1(k)];
%     relt2=[relt2 t/l2(k)];
%     cs =dat(k).cs;
%     cd=diff(cs(inds,:));
%     ddd(k)=sum(CartDist(cd));
    raf=MyGradient(rf,t_st,1);
    rac=MyGradient(co,t_st,1);
    rafs=[rafs raf];
%     racs=[racs rac];
    dn=(CartDist(dat(k).cs(inds,:))');
    rsp=dat(k).spee./dn;
    racs=[racs rsp];
    
    mf(k)=MeanAngle(rf);
    sf(k)=rf(1);
    np(k)=length(rf);
    
%     plot(t/td100(k),dat(k).f2n(inds),'r:',...
%         t/td100(k),dat(k).co(inds))
    if pl
%     [y,x]=AngHist(pps*180/pi);yp=y./sum(y);
%     [y,x]=AngHist(dat(k).f2n(inds));yf=y./sum(y);
%     plot(x,yf,x,yp,'r:')
% Setbox,axis tight,ylow(0);
% xlabel('angle'),ylabel('frequency')
%          figure(3)
%         subplot(2,1,1)
        if(isho) 
            plot(rf*180/pi,t_st)
%             plot(nor*180/pi,t_st)
            hold on;
        else
            plot(rf*180/pi,t_st,'r:')
%             plot(AngularDifference(rf,rf(1))*180/pi,t_st,'r:')
%             plot(-nor*180/pi,t_st,'r:')
            hold on;
        end
%         d=diff(dat(k).cs(inds,:));
%         mea=mean(sum(abs(d(1:2:end,:)),2));
%         title(['ang=' int2str(mf(k)*180/pi) '; np=' int2str(np(k)) ...
%             '; st a=' num2str(mea) '; k=' int2str(k)]);
%         if(mea<0.1)
%             keyboard;
%             plot(rf(1:2:end)*180/pi,t_st(1:2:end),'r:')            
%         end

%         plot(t_st,rf*180/pi,t_st,co*180/pi,'r:'),axis tight
%         hold off
%         subplot(2,1,2)
%         plot(t_st,raf,t_st,rac,'r:');,axis tight
    end
end
hold off
MotifFigs(gcf,2);axis tight

% figure(5);
% plot(abs(mf*180/pi),abs(sf*180/pi),'o')
pp=AngularDifference(cc,so);

function tempPlotStarts(datL,datZ)
x=datL.x;
figure(2)
subplot(3,2,1),
plot(x,datL.soc,x,datZ.soc,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Body Orientation')
subplot(3,2,2)
plot(x,datL.soa,x,datZ.soa,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Body Orientation')
subplot(3,2,3),
plot(x,datL.lmc1,x,datZ.lmc1,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Retinal position N LM')
subplot(3,2,4),
plot(x,datL.lma1,x,datZ.lma1,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Retinal position N LM')
subplot(3,2,5),
plot(x,datL.lmc2,x,datZ.lmc2,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Retinal position S LM')
subplot(3,2,6),
plot(x,datL.lma2,x,datZ.lma2,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Retinal position S LM')

figure(3)
subplot(3,2,1),
plot(x,datL.f2c,x,datZ.f2c,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Flt Dir. Compass')
subplot(3,2,2)
plot(x,datL.f2a,x,datZ.f2a,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Flt Dir. Compass')
subplot(3,2,3),
plot(x,datL.f2l1c,x,datZ.f2l1c,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Flt Dir to N Lm')
subplot(3,2,4)
plot(x,datL.f2l1a,x,datZ.f2l1a,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Flt Dir to N Lm')
subplot(3,2,5),
plot(x,datL.f2l2c,x,datZ.f2l2c,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Flt Dir to S Lm')
subplot(3,2,6)
plot(x,datL.f2l2a,x,datZ.f2l2a,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Flt Dir to S Lm')

figure(4)
subplot(3,2,1),
plot(x,datL.o2nc,x,datZ.o2nc,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Angle relative to Nest')
subplot(3,2,2)
plot(x,datL.o2na,x,datZ.o2na,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Angle relative to Nest')
subplot(3,2,3),
plot(x,datL.olmc1,x,datZ.olmc1,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Angle relative to N LM')
subplot(3,2,4),
plot(x,datL.olma1,x,datZ.olma1,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Angle relative to N LM')
subplot(3,2,5),
plot(x,datL.olmc2,x,datZ.olmc2,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CW: Angle relative to S LM')
subplot(3,2,6),
plot(x,datL.olma2,x,datZ.olma2,'r:'),
axis tight,Setbox,ylabel('frequency'),xlabel('CCW: Angle relative to S LM')


function[dat]=PlotStarts(starts,LM,LMWid,m,cocw,coaw,zz,cw,aw)

str={' CW in';' CW out';' CCW in';' CCW out'};
g=colormap('gray');
csts=['rx';'rx';' o';' o'];
% for i=1:4
% %     subplot(2,2,i)
%     figure(i),MotifFigs(gcf,2);
%     xp=starts(starts(:,1)==i,[2 3]);
%     if(m<1)
%         plot(xp(:,1),xp(:,2),csts(i,:))%'x')%
%     else
%         [Dea,xs,ys,xps,yps]=Density2D(xp(:,1),xp(:,2),-30:m:30,-30:m:40);
%         contourf(xps,yps,Dea,[0 0.5:1:max(Dea(:))]),max(Dea(:))
%         colormap(g(end:-1:1,:));
%     end
%     hold on; PlotNestAndLMs(LM,LMWid,[0 0],0,[],1);%hold off
%     if(LM(1,1)<0)
%         axis equal,axis([-20 25 -17.5 27.5])%axis tight
%     else
%         axis equal,axis([-25 20 -15 30])%axis tight
%     end
%     title([int2str(size(xp,1)) char(str(i)) ' loops/' int2str(size(starts,1))]);
% end
figure(1)
for i=1:2
     subplot(2,2,i)
%     figure(i),MotifFigs(gcf,2);
    if (i==1) xp=cocw(:,[1 2]);
    else xp=coaw(:,[1 2]);
    end
    if (i==1) xp=cocw(:,[1 2 8 9]);
    else xp=coaw(:,[1 2 8 9]);
    end
    if(m<1)
        if(nargin>8)
            if (i==1) 
                plot(cw(:,1),cw(:,2),'b.')
            else 
                plot(aw(:,1),aw(:,2),'b.')
            end
            hold on
        end
        plot(xp(:,1),xp(:,2),csts(i,:))%'x')%
%         plot(xp(:,[1 3])',xp(:,[2 4])','b',xp(:,3),xp(:,4),'b.')%
    else
        [Dea,xs,ys,xps,yps]=Density2D(xp(:,1),xp(:,2),-30:m:30,-30:m:40);
        [Dea,xs,ys,xps,yps]=Density2D(xp(:,1),xp(:,2),-50:m:50,-40:m:60);
        contourf(xps,yps,Dea,[0 0.5:1:max(Dea(:))]),max(Dea(:))
        colormap(g(end:-1:1,:));
    end
    hold on; PlotNestAndLMs(LM,LMWid,[0 0],0,[],1);hold off
    if(LM(1,1)<0)
        axis equal,axis([-20 25 -17.5 27.5]),axis tight
    else
        axis equal,axis([-25 20 -15 30]),axis tight
    end
    axis equal
    title([int2str(size(xp,1)) char(str(2*i-1))]);
end
hold off
% LM oN retina and orientations
cs=cocw(:,[1 2]);
so=cocw(:,7);
for j=1:size(cocw,1)
    if(isfield(zz,'lm')) 
        LM=zz(cocw(j,5)).lm;
    else 
        LM=zz(cocw(j,5)).LM;
    end
    lmo=LMOrder(LM);
    LM=LM(lmo,:);
    for i=1:size(LM,1)
        LMc(i).VToLM(j,:)=[LM(i,1)-cs(j,1),LM(i,2)-cs(j,2)];
        LMc(i).OToLM(j)=mod(cart2pol(LMc(i).VToLM(j,1),LMc(i).VToLM(j,2))-4.9393,2*pi);
        LMc(i).LMOnRetina(j)=AngularDifference(LMc(i).OToLM(j),so(j))*180/pi;
        LMc(i).ftoLM(j)=AngularDifference(cocw(j,10),LMc(i).OToLM(j))*180/pi;
    end
end
cs=coaw(:,[1 2]);
so=coaw(:,7);
for j=1:size(coaw,1)
    if(isfield(zz,'lm')) 
        LM=zz(coaw(j,5)).lm;
    else 
        LM=zz(coaw(j,5)).LM;
    end
    lmo=LMOrder(LM);
    LM=LM(lmo,:);
    for i=1:size(LM,1)
        LMa(i).VToLM(j,:)=[LM(i,1)-cs(j,1),LM(i,2)-cs(j,2)];
        LMa(i).OToLM(j)=mod(cart2pol(LMa(i).VToLM(j,1),LMa(i).VToLM(j,2))-4.9393,2*pi);
        LMa(i).LMOnRetina(j)=AngularDifference(LMa(i).OToLM(j),so(j))*180/pi;
        LMa(i).ftoLM(j)=AngularDifference(coaw(j,10),LMa(i).OToLM(j))*180/pi;
    end
end
subplot(4,2,5)
[y,x]=AngHist(coaw(:,7)*180/pi);soa=y/sum(y);
y=AngHist(cocw(:,7)*180/pi);soc=y/sum(y);
y=AngHist(LMc(1).LMOnRetina);lmc1=y/sum(y);
y=AngHist(LMc(2).LMOnRetina);lmc2=y/sum(y);
y=AngHist(LMa(1).LMOnRetina);lma1=y/sum(y);
y=AngHist(LMa(2).LMOnRetina);lma2=y/sum(y);
plot(x,soc,x,lmc1,'r:',x,lmc2,'k--'),
% hist(CartDist(cocw(:,[1 2])-cocw(:,[8 9])))
axis tight,Setbox,ylabel('frequency'),xlabel('retinal angle')
subplot(4,2,6),plot(x,soa,x,lma1,'r:',x,lma2,'k--'),
% hist(CartDist(coaw(:,[1 2])-coaw(:,[8 9])))
axis tight,Setbox,ylabel('frequency'),xlabel('retinal angle')
subplot(4,2,7),
y=AngHist(LMc(1).OToLM*180/pi);olmc1=y/sum(y);
y=AngHist(LMc(2).OToLM*180/pi);olmc2=y/sum(y);
y=AngHist(LMa(1).OToLM*180/pi);olma1=y/sum(y);
y=AngHist(LMa(2).OToLM*180/pi);olma2=y/sum(y);
y=AngHist(cocw(:,3)*180/pi);o2nc=y/sum(y);
y=AngHist(coaw(:,3)*180/pi);o2na=y/sum(y);
plot(x,o2nc,x,olmc1,'r:',x,olmc2,'k--'),
axis tight,Setbox,ylabel('frequency'),xlabel('angular position')
subplot(4,2,8),plot(x,o2na,x,olma1,'r:',x,olma2,'k--'),
axis tight,Setbox,ylabel('frequency'),xlabel('angular position')
figure(2),
y=AngHist(cocw(:,10)*180/pi);f2c=y/sum(y);
y=AngHist(coaw(:,10)*180/pi);f2a=y/sum(y);
y=AngHist(LMc(1).ftoLM);f2l1c=y/sum(y);
y=AngHist(LMc(2).ftoLM);f2l2c=y/sum(y);
y=AngHist(LMa(1).ftoLM);f2l1a=y/sum(y);
y=AngHist(LMa(2).ftoLM);f2l2a=y/sum(y);
subplot(3,2,3),plot(x,f2c,x,f2l1c,'r:',x,f2l2c,'k--'),
axis tight,Setbox,ylabel('frequency'),xlabel('flgith direction')
subplot(3,2,4),plot(x,f2a,x,f2l1a,'r:',x,f2l2a,'k--'),
axis tight,Setbox,ylabel('frequency'),xlabel('flight direction')
dat.f2c=f2c;
dat.f2a=f2a;
dat.soc=soc;
dat.soa=soa;
dat.f2l1c=f2l1c;
dat.f2l1a=f2l1a;
dat.f2l2c=f2l2c;
dat.f2l2a=f2l2a;
dat.lmc1=lmc1;
dat.lma1=lma1;
dat.lmc2=lmc2;
dat.lma2=lma2;
dat.olmc1=olmc1;
dat.olma1=olma1;
dat.olmc2=olmc2;
dat.olma2=olma2;
dat.o2nc=o2nc;
dat.o2na=o2na;
dat.x=x;


function[out,pcs,dat]=PercentFlightsLorZZ(isloop,pn)
c=0;nflt2=0;nineach=[];pcs=[];
figure(4)
if(isloop==1)
    loopfile='loopstatstemp.mat';
    zzfile='processzigzagsout';
    linefile='processflightsecOut';
    ostr='out';
elseif(isloop==2)
    loopfile='loopstatsIn.mat';
    zzfile='processzigzagsin';
    linefile='processflightsecIn';
    ostr='in';
end
unproz=0;
if(isloop)
    load(loopfile);
    load(zzfile);
    zz=fltsec;
    load(linefile);
    nflt=length(dir(['*' ostr '*All.mat']));
    allfs=dir(['*' ostr '*All.mat']);
    nflt3=length(loops);
    % check those not processed
%     for j=1:length(allfs)
%         ffnn=allfs(j).name;
%         fl=0;
%         for i=1:nflt3
%             if(isequal(ffnn,loops(i).fn))
%                 fl=1;
%                 break;
%             end
%         end
%         if(~fl)
%             load(ffnn);
%             figure(10)
%             plot(Cents(:,1),Cents(:,2))
%             title(ff)
%             pause
%         end
%     end
    for i=1:nflt3
        nineach(i)=sum(loops(i).Picked);
        if(sum(loops(i).Picked))
            c=c+1;
        end
        if(~isempty(loops(i).loop))
            nflt2=nflt2+1;
        end
        fn=loops(i).fn;
        [out,bee(i),fnum(i)]=ProcessBeeFilename(fn);
        cs=loops(i).cs;
        t=loops(i).t;
        t_flt=t(end)-t(1);
        iall=1:length(t);
        
        if(isempty(loops(i).loop)) 
            ilo=[];
            isl=[];
            ps=[];
        else
            ilo=unique([loops(i).loop.is]);
            ps=find([loops(i).Picked]);
            isl=unique([loops(i).loop(ps).is]);
        end
        tsl=t(isl);
        
        lnum=-1;
        for k=1:length(fltsec)
            if(isequal(fn,fltsec(k).fn))
                lnum=k;
                break;
            end
        end
        if((lnum==-1)||isempty(fltsec(lnum).fsec)) 
            iss=[];
        else
            iss=unique([fltsec(lnum).fsec.is]);
        end

        lnum=-1;
        for k=1:length(zz)
            if(isequal(fn,zz(k).fn))
                lnum=k;
                break;
            end
        end
        
        iz2loop=[]; dz2loop=[]; il2zz=[]; dl2zz=[];
        numzz=0;
        dat(i).unproz=0;
        if(lnum==-1)
            isz=[];
            unproz=unproz+1;
            dat(i).unproz=1;
            fn
        elseif(isempty(zz(lnum).fsec))
            isz=[];
        else
            isz=unique([zz(lnum).fsec.is]);
            % check to see if each zigzag is within or near a loop
            for j=1:length(zz(lnum).fsec)
                zis=zz(lnum).fsec(j).is;
                if(length(zis)>=4)
                    numzz=numzz+1;
                    if(isempty(isl))
                        dz2loop=[dz2loop 1e6];
                        iz2loop=[iz2loop 1e6];
                    else
                        ds=[];dts=[];
                        for k=zis
                            ds=[ds abs(k-isl)];
                            dts=[dts abs(t(k)-tsl)];
                        end
                        iz2loop=[iz2loop min(ds)];
                        dz2loop=[dz2loop min(dts)];
                    end
                end
            end
        end
        dat(i).dz2loop=dz2loop;
        dat(i).iz2loop=iz2loop;

        % check to see if each loop is within or near a ZZ
        tsz=t(isz);
        for j=1:length(ps)
            if(isempty(isz))
                dl2zz(j)=1e6;
                il2zz(j)=1e6;
            else
                zis=loops(i).loop(ps(j)).is;
                ds=[];dts=[];
                for k=zis
                    ds=[ds abs(k-isz)];
                    dts=[dts abs(t(k)-tsz)];
                end
                [il2zz(j),dum]=min(ds);
                [dl2zz(j),dum]=min(dts);
            end
        end
        dat(i).dl2zz=dl2zz;
        dat(i).il2zz=il2zz;
        
        iss1=setdiff(iss,ilo);
        iss2=setdiff(iss,isl);
        ib1=union(iss,ilo);
        ib2=union(iss,isl);
        ib3=union(isz,isl);
        isn1=setdiff(iall,ib1);
        isn2=setdiff(iall,ib2);
        isn3=setdiff(iall,union(isz,ib1));
        isn4=setdiff(iall,union(isz,ib2));
        
        ln=length(iall);
%         pcs=[pcs;[round(100*[length(ilo) length(isl) length(isn1) ...
%             length(isn2) length(iss1) length(iss2)]/ln) fnum(i) bee(i)]];
        td=median(diff(t));

        pcs=[pcs;[round(100*[length(ilo) length(isl) length(isz) length(isn3) ...
            length(isn1) length(iss1) length(iss2)]/ln) fnum(i) bee(i) ...
            t_flt]];% td*(isn1) round(100*td(isn1)/t_flt]];
        
        dat(i).numloop=length(ps);
        dat(i).numzz=numzz;
        dat(i).tsn1=t(isn1);
        dat(i).pctn1=t(isn1)*100/t(end);
        dat(i).fnum=fnum(i);
        dat(i).bee=bee(i);
        dat(i).fn=fn;
        if 0%pl
            PlotNestAndLMs(loops(i).LM,loops(i).LMw,[0 0],0);
            hold on;
            plot(cs(:,1),cs(:,2),cs(ilo,1),cs(ilo,2),'.', ...
                cs(isl,1),cs(isl,2),'rx',cs(iss,1),cs(iss,2),'ks')           
            title(['flt ' int2str(fnum(i)) '; all L ' int2str(pcs(i,1)) '; loop ' int2str(pcs(i,2)) ...
                '; straight ' int2str(pcs(i,5)) '; not ' int2str(pcs(i,3))])
            hold off
            disp('press return to continue');
            pause
        end
    end
    d2l=[dat.dz2loop];
    dat(1).pcznrl=sum(d2l<=0.1)/sum([dat.numzz])
    d2l=[dat.dl2zz];
    dat(1).pclnrzz=sum(d2l<=0.1)/sum([dat.numloop])
    out=[nflt nflt3 nflt2 c ...
        round([100*c/nflt 100*dat(1).pcznrl 100*dat(1).pclnrzz]) unproz];

else
    load processflightsecIn
    stra=fltsec;
    load processzigzagsin
    nflt=length(dir('*in*All.mat'));
    nflt3=length(fltsec);
    for i=1:length(fltsec)
        nineach(i)=length(fltsec(i).fsec);
        for j=1:length(fltsec(i).fsec)            
            if(length(fltsec(i).fsec(j).is)>=4)
                c=c+1;
                break;
            end
        end
        fn=fltsec(i).fn;
        [out,bee(i),fnum(i)]=ProcessBeeFilename(fn);
        cs=fltsec(i).cs;
        t=fltsec(i).t;
        t_flt=t(end)-t(1);
        iall=1:length(t);
        
        if(isempty(fltsec(i).fsec)) 
            ilo=[];
        else
            nflt2=nflt2+1;
            ilo=unique([fltsec(i).fsec.is]);
        end
        
        lnum=-1;
        for k=1:length(stra)
            if(isequal(fn,stra(k).fn))
                lnum=k;
                break;
            end
        end
        if((lnum==-1)||isempty(stra(lnum).fsec)) iss=[];
        else iss=unique([stra(lnum).fsec.is]);
        end

        iss1=setdiff(iss,ilo);
        ib1=union(iss,ilo);
        isn1=setdiff(iall,ib1);
        
        ln=length(iall);
        pcs=[pcs;[round(100*[length(ilo) NaN length(isn1) ...
            NaN length(iss1) NaN]/ln) fnum(i) bee(i) t_flt]];

        dat(i).tsn1=t(isn1);
        dat(i).pctn1=t(isn1)*100/t(end);
        dat(i).fnum=fnum(i);
        dat(i).bee=bee(i);
        if 0%pl
            PlotNestAndLMs(fltsec(i).lm,fltsec(i).lmw,[0 0],0);
            hold on;
            plot(cs(:,1),cs(:,2),cs(ilo,1),cs(ilo,2),'rx', ...
                cs(iss,1),cs(iss,2),'ks')           
            title(['flt ' int2str(fnum(i)) '; all L ' int2str(pcs(i,1)) '; loop ' int2str(pcs(i,2)) ...
                '; straight ' int2str(pcs(i,5)) '; not ' int2str(pcs(i,3))])
            hold off
            disp('press return to continue');
            pause
        end
    end
out=[nflt nflt3 nflt2 c round(100*c/nflt)];
end
% out=nineach';
% to plot summary data from all LMs
% out=ts;pcs=y2s;dat=o2s; pn=6
pn=min(pn,6);
figure(1),subplot(3,2,pn);
hist([dat.tsn1],100);
xlabel('% time thru flight not loop/straight');
figure(2),subplot(3,2,pn);
hist([dat.pctn1],100);
xlabel('% thru flight not loop/straight');
figure(3),subplot(3,2,pn);
[da,x]=StatsOverX(pcs(:,7),pcs(:,3),0.5:1:15);
plot(x,[da.med]),xlabel('flight number');ylabel('% not loop/straight')
axis tight,ylim([0 100])
figure(4),subplot(3,2,pn);
plot(pcs(:,7),pcs(:,3),'.');
xlabel('flight number');ylabel('% not loop/straight')
axis tight,ylim([0 100])
figure(5),subplot(3,2,pn);
plot(pcs(:,end),pcs(:,3),'.');
xlabel('flight length');ylabel('% not loop/straight')
axis tight,ylim([0 100])

% for k=1:14
%     is=find(pcs(:,7)==k);
%     a=find(pcs(is,1)==0);
%     dat(is(a)).fn
%     len(k)=length(a);
%     nfs(k)=length(is);
%     pc(k)=len(k)/length(is);
% %     pause
% end

earlys=[1];
x1=[];
for k=earlys
    x1=[x1;da(k).x];
end
x2=[];
lates=4:14;
for k=lates
    x2=[x2;da(k).x];
end
[p,h]=ranksum(x1,x2)

function CheckAllCoincidences

load ../2' west'/temp2WLoopPhaseDataAll %PhDat 
cocwL=cocw;coawL=coaw;
load ../2' west'/temp2WZZPhaseDataAll
figure(1),[m1,n1]=CheckCoincidence(cocw,cocwL,loops,fltsec,10)
figure(2),[m2,n2]=CheckCoincidence(coaw,coawL,loops,fltsec,20)
load ../2' east all'/temp2ELoopPhaseDataAll
cocwL=cocw;coawL=coaw;
% PlotStarts(starts,LM,LMWid,2,cocwL(:,8:end),coawL(:,8:end),loops,f2n0cw,f2n0aw)
% % % figure(1); hold on; figure(2); hold on
% load temp2WZZPhaseDataAll
load ../2' east all'/temp2EZZPhaseDataAll
% PlotStarts(starts,LM,LMWid,-1,cocw(:,8:end),coaw(:,8:end),fltsec,f2n0cw,f2n0aw)
figure(3),[m3,n3]=CheckCoincidence(cocw,cocwL,loops,fltsec,30)
figure(4),[m4,n4]=CheckCoincidence(coaw,coawL,loops,fltsec,40)

for i=1:15
    for j=1:15
        [m,l]=MeanAngle([m1(i,j).as m2(i,j).as m3(i,j).as m4(i,j).as]);
        meana(i,j)=m;
        meanl(i,j)=l;
        meand(i,j)=mean([m1(i,j).ds m2(i,j).ds m3(i,j).ds m4(i,j).ds]);
    end
end
m=10;n=15;
figure(5),
subplot(2,2,1),imagesc(meand),axis([0 n 0 m]+.5),caxis([0 50])
xlabel('out num'),ylabel('return num'),title('distance'),colorbar
subplot(2,2,2),imagesc(abs(meana*180/pi)),axis([0 n 0 m]+.5),caxis([0 180])%,colorbar
xlabel('out num'),ylabel('return num'),title('mean angle'),colorbar
subplot(2,2,4),imagesc(meanl),axis([0 n 0 m]+.5),caxis([0 1])
xlabel('out num'),ylabel('return num'),title('mean angle length'),colorbar
subplot(2,2,3),imagesc(n1+n2+n3+n4),axis([0 n 0 m]+.5)%,caxis([0 1])
xlabel('out num'),ylabel('return num'),title('num flights'),colorbar


function[meanv,nums]=CheckCoincidence(cocw,cocwL,loops,fltsec,fadd)
% stuff to compare the positions of 'named' bees vs any bees
for i=1:size(cocwL,1)
    fn_n=loops(cocwL(i,12)).fn;
    [out,fn_ns(i),fnumL(i)]=ProcessBeeFilename(fn_n,1);
end
for i=1:size(cocw,1)
    fn_n=fltsec(cocw(i,12)).fn;
    [out,fn_nz(i),fnumZ(i)]=ProcessBeeFilename(fn_n,0);
end
% randomise the returning bees as a control
fn_nz=fn_nz(randperm(length(fn_nz)));

nums=zeros(15);
meandist=nums;
meanv(15,15).as=[];
meanv(15,15).ds=[];

fn_l=unique(fn_ns);
for j=1:length(fn_l)
    js=find(fn_ns==fn_l(j));
    % is there a matching return bee
    zs=find(fn_nz==fn_l(j));
    % plot the starting positions
%     if(~isempty(zs))
%         xL=cocwL(js,[8 9]);
%         snl=int2str(fnumL(js)');
%         xZ=cocw(zs,[8 9]);
%         snz=int2str(fnumZ(zs)');
%         figure(j+fadd)
%         plot(xL(:,1),xL(:,2),'kx',xZ(:,1),xZ(:,2),'r.');
%         ind=cocw(zs(1),12);
%         hold on;
%         PlotNestAndLMs(fltsec(ind).lm,fltsec(ind).lmw,[0 0]);axis equal
%         text(xL(:,1),xL(:,2)-1,snl,'Color','k')
%         text(xZ(:,1),xZ(:,2)-1,snz,'Color','r')
%         if(fadd) title(['bee ' int2str(fn_l(j)) '; CCW']) 
%         else title(['bee ' int2str(fn_l(j)) '; CW']) 
%         end
%         hold off
%     end
    
    % get distance data for all the matching bees as a matrix where the
    % data in row r column c is distances from return r to out c
    % tom thinks there should be correlation donw the diagonal
    for i=zs
        xz=cocw(i,[8 9]);
        th=cart2pol(xz(1),xz(2));
        r=fnumZ(i);
        for k=js
            xl=cocwL(k,[8 9]);
            thl=cart2pol(xl(1),xl(2));
            d=CartDist(xz-xl);
            ad=AngularDifference(thl,th);
            c=fnumL(k);
            nums(r,c)=nums(r,c)+1;
            meandist(r,c)=meandist(r,c)+d;
            meanv(r,c).as=[meanv(r,c).as ad];
            meanv(r,c).ds=[meanv(r,c).ds d];
        end
    end
%     for i=1:size(cocw,1)
%         x=cocw(i,[8 9]);
%         ds=CartDist(cocwL(js,8)-x(1),cocwL(js,9)-x(2));
%         mindist(i,j)=min(ds);
%     end 

% %         r=setdiff(1:size(cocwL,1),js);
% %     r=r(randperm(length(r)));
% %     ks=r(1:length(js));
% %     ds=CartDist(cocwL(ks,8)-x(1),cocwL(ks,9)-x(2));
% %     if(isempty(ks)) mind2(i)=NaN;
% %     else mind2(i)=min(ds);
% %     end
end
for i=1:15
    for j=1:15
        [m,l]=MeanAngle([meanv(i,j).as]);
        meana(i,j)=m;
        meanl(i,j)=l;
        meand(i,j)=mean([meanv(i,j).ds]);
    end
end
m=max(fnumZ);n=max(fnumL);
subplot(2,2,1),imagesc(meand),axis([0 n 0 m]+.5),caxis([0 50])
xlabel('out num'),ylabel('return num'),title('distance')
subplot(2,2,2),imagesc(abs(meana*180/pi)),axis([0 n 0 m]+.5),caxis([0 180])%,colorbar
xlabel('out num'),ylabel('return num'),title('mean angle')
subplot(2,2,4),imagesc(meanl),axis([0 n 0 m]+.5),caxis([0 1])
xlabel('out num'),ylabel('return num'),title('mean angle length')
subplot(2,2,3),imagesc(nums),axis([0 n 0 m]+.5)%,caxis([0 1])
xlabel('out num'),ylabel('return num'),title('num flights')


% for i=1:size(cocw,1)
%     [s,inds]=sort(mindist(i,:));
%     indz=find(fn_nz(i)==fn_l);
%     if(isempty(indz)) rank(i)=NaN;
%     else
%         rank(i)=find(indz==inds);
%     end
% end
% hist(rank,1:8);
% plot(1:length(mind),mind,'b- .',1:length(mind2),mind2,'r--x')

function plotbits(i,do,dc,dat)
is=dat(i).is;
f2n=dat(i).f2n(is);
o2n=dat(i).o2n(is);
aco=dat(i).co(is);
alo1=dat(i).f2lm(1,is);
alo2=dat(i).f2lm(2,is);
subplot(1,2,1),
plot(f2n,aco,'b',alo1*180/pi,aco,'k:',...
    alo2*180/pi,aco,'g:',o2n*180/pi,aco,'r--')
axis tight;
title(['ang diff = ' int2str(round(dc))]);
subplot(1,2,2),
plot(f2n,o2n*180/pi,'b',...
    f2n,(dat(i).o2lm(1,is))*180/pi,'k:',f2n,dat(i).o2lm(2,is)*180/pi,'g:')
axis tight;
title(['o2n diff = ' int2str(round(do))]);




function plotPhaseStuff(PhDat,phd2)

%     vec=[br(2) br(1) st.s i2 f2n(i2)'*180/pi ...
%             co(i2)'*180/pi s2n(i2)'*180/pi so(i2)'*180/pi ...
%             o2n(i2)'*180/pi length(is) ...
%             b1(2) b2(2) s1.s s2.s g2 xco*180/pi xf2*180/pi ...
%             xts xds cs(sp,:) cs(tp,:) xcs CartDist(d2) d];


Tstr={'CW in';'CW out';'CCW in';'CCW out'}
    is=[35 36 1:36 1];the=-190:10:190;
    
angs=[-140:40:180]*pi/180;
angm=[0:10:90]*pi/180;
angs=[angm;angm;-angm;-angm];
cst=['b  ';'r: ';'k--';'g:x']
for i=1:4
    figure(5)
    eval(['dat=PhDat.dat' int2str(i) ';']);
    if(nargin==2) eval(['m=[PhDat.m' int2str(i) ';phd2.m' int2str(i) '];']);
    else eval(['m=PhDat.m' int2str(i) ';']);
    end
    gs=find((m(:,3)<10)&(m(:,1)>0));

    % get angular changes from ang to nest 100 ->0 (d1) and 60->0 (d2)
    is100=find(~isnan(m(:,29)));
    is60=find(~isnan(m(:,27)));
    d1=180/pi*AngularDifference(m(is100,24)*pi/180,m(is100,29)*pi/180);
    d2=180/pi*AngularDifference(m(is60,24)*pi/180,m(is60,27)*pi/180);
    s100=AngularDifference(m(is100,29)*pi/180,0)*180/pi;
    s60=AngularDifference(m(is60,27)*pi/180,0)*180/pi;
    td20=m(:,36)-m(:,37);
    td40=m(:,36)-m(:,38);
    td60=m(:,36)-m(:,39);
    td80=m(:,36)-m(:,40);
    td100=m(:,36)-m(:,41);
    d60=m(:,42)-m(:,45);
    d100=m(:,42)-m(:,47);
    
    % examine bits where the orientation to the nest changes
    o2nd=m(is100,end-2);
    plot(d1,m(is100,end-2),'o');
    [so2n,so2ni]=sort(abs(o2nd),'descend');
    for j=1:length(so2n)
        plotbits(is100(so2ni(j)),so2n(j),d1(so2ni(j)),dat);
    end
    
    % get data on the time taken between 
    
    %     subplot(4,2,2*i-1),plot(m(gs,3),m(gs,1),'o')
%     ylabel('slope'),xlabel('fit error'),axis tight,
%     subplot(4,2,2*i),plot(m(gs,6),m(gs,1),'o',m(gs,8),m(gs,1),'rx')
%     ylabel('slope'),xlabel('starting angle'),axis tight
%     [dat,xp]=StatsOverX(m(:,end),m(:,6)*pi/180,0:5:60);meaf=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(m(:,end),m(:,8)*pi/180,0:5:60);meac=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(m(is100,end),d1*pi/180,0:5:60);mea100=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(m(is60,end),d2*pi/180,0:5:60);mea60=[dat.meang]*180/pi;
    [dat100,xp]=StatsOverX(m(is100,end-1),d1,0:2:20);mea100=[dat100.med];
    [dat60,xp]=StatsOverX(m(is60,end-1),d2,0:2:20);mea60=[dat60.med];
%     [dat,xp]=StatsOverX(td100(is100),d1*pi/180,0:0.02:0.5);mea100=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(td60(is60),d2*pi/180,0:0.02:0.5);mea60=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(d100(is100),d1*pi/180,0.1:0.5:10);mea100=[dat.meang]*180/pi;
%     [dat,xp]=StatsOverX(d60(is60),d2*pi/180,0.1:0.5:10);mea60=[dat.meang]*180/pi;
%     subplot(2,2,i),plot(m(gs,end),m(gs,6),'o',m(gs,end),m(gs,8),'rx')
%     subplot(2,2,i),
    plot(xp,mea100,xp,mea60,'r:')

    errorbar(xp,mea100,mea100-[dat100.p25],[dat100.p75]-mea100,'k:')
hold on;errorbar(xp,mea60,mea60-[dat60.p25],[dat60.p75]-mea60,'k:');hold off

    xlabel('distance'),ylabel('angular change'),axis tight,Setbox,ylim([50 155])
    title([char(Tstr(i)) ';  n=' int2str(length(gs)) '/' int2str(PhDat.c(i))])

    [y,x]=hist(td100,0.025:0.05:0.525);y100=y/sum(y);
    [y,x2]=hist(td60,0.0125:0.025:0.2625);y60=y/sum(y);
    plot(x,y100,x2,y60,'r:')

    [y,x]=hist(d1,90:2.5:150);y100=y/sum(y);
    [y,x2]=hist(d2,50:2.5:90);y60=y/sum(y);
    plot(y100,x,'b:',y60,x2,'r:')

    figure(6)
    subplot(2,2,i),
%     plot(m(is100,end-1),d1,'k.',m(is60,end-1),d2,'kd')%,...    
%     xlabel('distance'),ylabel('angular change'),axis tight; 
    plot(td100(is100),d1,'k.',td60(is60),d2,'kd')%,...    
    plot(td100(is100),d100(is100),'k.')
    figure(8)
    subplot(2,2,i),
    plot(td60(is60),d60(is60),'kd')%,...    
    xlabel('distance'),ylabel('angular change'),axis tight; 

    figure(4)
    subplot(2,2,i),
    [y,x]=hist(m(gs,1),[0.9:.01:1.1]);
    plot(x,y,cst(i,:)),%hold on
    ylabel('slope'),xlabel('frequency'),axis tight

%     figure(6)
    subplot(2,2,i),
    [y,x]=AngHist(m(:,6));ys=y/sum(y);
    [y,x]=AngHist(m(:,8));ym=y/sum(y);
    [y,x]=AngHist(m(:,14));cs=y/sum(y);
    plot(the,ym(is),the,ys(is),'r:')%,the,cs(is),'k--'),
    axis tight;ya=ylim;ylim([0 ya(2)]);
    xlabel('starting angle');ylabel('frequency');
%     title([char(Tstr(i)) ';  n=' int2str(length(gs)) '/' int2str(PhDat.c(i))])
    title(['blue flt dir, red f rel nest'])

    figure(7)
    subplot(2,2,i),
%     plot(m(gs,17),m(gs,18),'ro',m(gs,1),m(gs,18),'bx')
%     [y,x]=AngHist(m(gs,21),0:.1:2);b=y/sum(y);
%     [y,x]=AngHist(m(gs,22),0:.1:2);bs=y/sum(y);
%     [y,x]=AngHist(m(gs,23),0:.1:2);bm=y/sum(y);
%     [y,x]=AngHist(m(~isnan(m(:,24)),24));b=y/sum(y);
%     [y,x]=AngHist(m(is60,27));bs=y/sum(y);
%     [y,x]=AngHist(m(is100,29));bm=y/sum(y);
%     plot(x,b,x,bs,'r:',x,bm,'k--'),    axis tight
    
%     subplot(111),
    plot(s100,d1,'k.',s60,d2,'kd')%,...
    axis tight;axis equal,xlabel('Flight direction at start')
    ylabel('angular change'),Setbox     
%     figure(6)
%     subplot(2,2,i),
    plot(m(:,6),m(:,8),'kx'),axis equal 
    axis tight;xlabel('flt rel nest (start)'),ylabel('flt dir (start)'),Setbox   
    
%     figure(8)
%         subplot(111),%subplot(2,2,i),
%         ang2=[-190:20:90];
%     [da,xp]=StatsOverX(s100,d1,ang2);
%     dm=[da.med];errorbar(xp,dm,dm-[da.p25],[da.p75]-dm,'b:');
%     [da,xp]=StatsOverX(s60,d2,ang2);
%     dm=[da.med];
%     hold on;errorbar(xp,dm,dm-[da.p25],[da.p75]-dm,'r:');hold off
%     axis tight;xlabel('Flight direction at ''start'''),ylabel('angular change'),Setbox    
    
    
    
%     if(nargin==2) eval(['dat=[PhDat.dat' int2str(i) ';phd2.dat' int2str(i) '];']);
%     else eval(['dat=PhDat.dat' int2str(i) ';']);
%     end
    
    relf=[];relc=[];relt100=[];relt60=[];tts=[];
    l1=[];len=[];len2tp=[];relt=[];relt1=[];relt2=[];l2=[];ddd=[];
    for k=1:length(dat)
        inds=dat(k).is;
%         inds=1:length(dat(k).t);
        relf=[relf (dat(k).f2n(inds)*pi/180)'];
        relc=[relc (dat(k).co(inds)*pi/180)'];
        t=dat(k).t(inds)-m(k,36);
        tts=[tts t];
        relt100=[relt100 t/td100(k)];
        relt60=[relt60 t/td60(k)];
        len=[len dat(k).t(end)-dat(k).t(1)];
        len2tp=[len2tp m(k,36)-dat(k).t(1)];
        l1=[l1 dat(k).t(inds(end))-dat(k).t(inds(1))];
        l2=[l2 m(k,36)-dat(k).t(inds(1))];
        relt=[relt t/len(k)];
        relt1=[relt1 t/l1(k)];
        relt2=[relt2 t/l2(k)];
        cs =dat(k).cs;
        cd=diff(cs(inds,:));
        ddd(k)=sum(CartDist(cd));
        
%         plot(t/td100(k),dat(k).f2n(inds),'r:',...
%             t/td100(k),dat(k).co(inds))
    end
    hold off
    [y,x]=hist([td100./len' td100./len2tp' td60./len' td60./len2tp' ...
        l2'./len' l2'./len2tp'],0:0.05:1);
    plot(x,y(:,1:2:end)),legend('100->0','60->0','linear->0')
    
    allpc100(i).d=td100./len2tp';
    pc100(i,:)=[sum(~isnan(allpc100(i).d)) round(100*prctile(td100./len2tp',[50 25 75]))]
    allpc100(i).d2=td60./len2tp';
    pc60(i,:)=[sum(~isnan(allpc100(i).d2)) round(100*prctile(td60./len2tp',[50 25 75]))]
    x=relf;
%     [da,xpt]=StatsOverX(tts,x);
%     [dar,xpr]=StatsOverX(relt,x);
%     [dar1,xpr1]=StatsOverX(relt1,x);
%     [dar2,xpr2]=StatsOverX(relt2,x);
%     [da60,xp60]=StatsOverX(relt60,x,[0:0.1:2]);
%     [da100,xp100]=StatsOverX(relt100,x,[0:0.05:1]);
%         
%     figure(18),subplot(2,2,i)
%     plot(1:20,[da.meang]*180/pi,1:20,[dar.meang]*180/pi,'r:',...
%         1:20,[dar1.meang]*180/pi,'k--'),axis tight%,1:20,[dar2.meang]*180/pi,'k--'),axis tight;
%     figure(19),subplot(2,2,i)
%     plot(1:20,[da.meangL],1:20,[dar.meangL],'r:',...
%         1:20,[dar1.meangL],'k--',1:20,[dar2.meangL],'k--'),axis tight;
%     figure(20),subplot(2,2,i)
%     plot(1:20,[da60.meang]*180/pi,1:20,[da100.meang]*180/pi,'k--'),axis tight;
%     figure(21),subplot(2,2,i)
%     plot(1:20,[da60.meangL],1:20,[da100.meangL],'k--'),axis tight;
% 
%     x=relc;
%     [da,xpt]=StatsOverX(tts,x);
%     [dar,xpr]=StatsOverX(relt,x);
%     [dar1,xpr1]=StatsOverX(relt1,x);
%     [dar2,xpr2]=StatsOverX(relt2,x);
%     [da60,xp60]=StatsOverX(relt60,x,[0:0.1:2]);
%     [da100,xp100]=StatsOverX(relt100,x,[0:0.05:1]);
%     figure(22),subplot(2,2,i)
%     plot(1:20,[da.meang]*180/pi,1:20,[dar.meang]*180/pi,'r:',...
%         1:20,[dar1.meang]*180/pi,'k--'),axis tight%,1:20,[dar2.meang]*180/pi,'k--'),axis tight;
%     figure(23),subplot(2,2,i)
%     plot(1:20,[da.meangL],1:20,[dar.meangL],'r:',...
%         1:20,[dar1.meangL],'k--',1:20,[dar2.meangL],'k--'),axis tight;
%     figure(24),subplot(2,2,i)
%     plot(1:20,[da60.meang]*180/pi,1:20,[da100.meang]*180/pi,'k--'),axis tight;
%     figure(25),subplot(2,2,i)
%     plot(1:20,[da60.meangL],1:20,[da100.meangL],'k--'),axis tight;
%     
%     figure(30+i)
%     x=relf;dt=0.1;p1=5;p2=95;
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,tts,-190:20:190,...
%         prctile(tts,p1):0.08:prctile(tts,p2));
%     subplot(2,3,1)
%     contourf(xps,yps,Dea),axis tight
%     subplot(2,3,2)
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,relt,-190:20:190,...
%         prctile(relt,p1):dt:prctile(relt,p2));
%     contourf(xps,yps,Dea),axis tight
%     subplot(2,3,3)
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,relt1,-190:20:190,...
%         prctile(relt1,p1):dt:prctile(relt1,p2));
%     contourf(xps,yps,Dea),axis tight
%     subplot(2,3,4)
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,relt2,-190:20:190,...
%         prctile(relt2,p1):dt:prctile(relt2,p2));
%     contourf(xps,yps,Dea),axis tight
%     subplot(2,3,5)
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,relt60,-190:20:190,...
%         prctile(relt60,p1):dt:prctile(relt60,p2));
%     contourf(xps,yps,Dea),axis tight
%     subplot(2,3,6)
%     [Dea,xs,ys,xps,yps]=Density2DAng(x*180/pi,relt100,-190:20:190,...
%         prctile(relt100,p1):dt:prctile(relt100,p2));
%     contourf(xps,yps,Dea),axis tight

    
%     figure(8)
%     subplot(2,2,i),
%     if(i==1)
% to pick out bits for phase plots
%                 figure(9),subplot(111),
%         toplot=ang2*NaN;
%         % 3 6 4 12 6
%         for j=1:size(ang2,2)
% %             d=AngularDifference(m(:,29)*pi/180,angs(i,j))*180/pi;
%             %         [mk,k]=min(abs(d));
%             %         tplot(i,j)=gs(k);
%             d=AngularDifference(m(:,29)*pi/180,0)*180/pi-ang2(j);
%             gs=find((d>0)&(d<20));
%             figure(10)
%             for k=1:length(gs)
%                 inds=dat(gs(k)).is;
%                 %         plot(dat(gs(k)).f2n(inds),dat(gs(k)).co(inds)),hold on
%                 af2n=AngleWithoutFlip(dat(gs(k)).f2n(inds)*pi/180)*180/pi;
%                 aco=AngleWithoutFlip(dat(gs(k)).co(inds)*pi/180)*180/pi;
%                 plot(af2n,aco),hold on;
%                 if(~isempty(inds)) text(af2n(1),aco(1),int2str(k)); end;
%             end
%             hold off
%             keyboard
%             if(~isempty(gs)) 
%                 toplot(j)=gs(k);
%                 save tempPhasePlots toplot
%             end
%         end
%         MotifFigs(gcf,1);

        numl=length(dat);
        j=0;
        carryon=1;
        while 0
            j=j+1;
            figure(8+j)
%             subplot(2,2,i),
            for k=1:5
                ik=(j-1)*20+k;
                if(ik>numl)
                    carryon=0;
                    break;
                end
%                 inds=dat(ik).is;
                inds=1:dat(ik).is(end);
%                 inds=1:length(dat(ik).t);
                af2n=AngleWithoutFlip(dat(ik).f2n(inds)*pi/180)*180/pi;
                af2n=(dat(ik).f2n(inds)*pi/180)*180/pi;
                as2n=(dat(ik).s2n(inds)*pi/180)*180/pi;
                aco=AngleWithoutFlip(dat(ik).co(inds)*pi/180)*180/pi;
                aso=(dat(ik).so(inds)*pi/180)*180/pi;
                t=dat(ik).t(inds)-dat(ik).t(inds(1));
                raso=MyGradient(aso*pi/180,t)*180/pi;
                coex=AngleWithoutFlip(dat(ik).coex*pi/180)*180/pi;
                f2nex=(dat(ik).f2nex*pi/180)*180/pi;
                tex=dat(ik).tex-dat(ik).tex(1);
%                 racex=MyGradient(coex*pi/180,t)*180/pi;
%                 rf2ex=MyGradient(AngleWithoutFlip(f2nex*pi/180),t)*180/pi;
                tl1=dat(ik).t(inds(1))-dat(ik).tex(1);
               [m,ind]=min(abs(tl1-tex));
%                 plot(af2n,aco),hold on                
%                 plot(f2nex,coex,f2nex(ind),coex(ind),'ko')             
                plot(t,af2n,'r:',t,aco),              
%                 plot(tex,f2nex,'r:',tex,coex,...
%                     tex(ind),f2nex(ind),'ko',tex(ind),coex(ind),'ko')
%                 plot(tex,rf2ex,'r:',tex,racex,...
%                     tex(ind),rf2ex(ind),'ko',tex(ind),racex(ind),'ko')
%                 hold on                
            end
            axis tight,xlabel('time'),ylabel('flt dir');hold off
%             axis equal;axis tight;%([-180 180 -180 180]);
%             xlabel('f dir rel. nest');ylabel('flt dir');hold off
%             xlabel('f dir rel. nest');ylabel('body o rel 2 nest');hold off
%             ylabel('body orientation');xlabel('flt dir');hold off
%             xlabel('f dir rel. nest');ylabel('body orientation');hold off
            if(~carryon) break; end;
        end
%     end
end
figure(4),hold off;


function[PhDat,sp,tp,tpcs]=PhaseStuff(PhDat,f2n,co,s2n,so,o2n,sbp,d,t,cs,...
    coex,f2nex,tex,o2lm,lmor,f2lm,spee,ra_co,ra_so)
sp=1;
angs=[0:20:100]*pi/180;
af2n=AngleWithoutFlip(f2n);
aco=AngleWithoutFlip(co);
dvs=cumsum(CartDist(diff(cs([1 1:end],:))));

tp=find(diff(sign(af2n))~=0,1);
if(isempty(tp))
    tp=find(diff(sign(af2n+2*pi))~=0,1);
    if(isempty(tp))
        tp=find(diff(sign(af2n-2*pi))~=0,1);
        if(~isempty(tp)) 
            af2n=af2n-2*pi; 
        end
    else af2n=af2n+2*pi;
    end;
end;

% tp=[];
% for i=1:length(tps)
%     if(abs(f2n(tps(i)))<(pi/2))
%         tp=tps(i);
%         break;
%     end
% end

if(~isempty(tp))
    if 0%(abs(f2n(tp))>(pi/2)) 
        tp=NaN;
        keyboard;
    else
        tp=tp+1;
        sp=GetSP(af2n,tp,sp,aco);
        [xps,xco,rf2,xf2,xts,xds,xcs]=GetXP(aco,af2n,tp,sp,angs,t,dvs,cs);
    end
    tpcs=[xcs([1 5 11]);xcs([2 6 12])]';
else
    tp=NaN;
    tpcs=[NaN NaN];
end;

pl=0;
alo1=AngleWithoutFlip(f2lm(1,:));
% alo2=AngleWithoutFlip(f2lm(2,:));
if pl
    figure(2)
    subplot(2,2,sbp),
    plot(af2n*180/pi,(aco)*180/pi,'b',af2n*180/pi,o2n*180/pi,'r:',...
        af2n*180/pi,(o2lm(1,:))*180/pi,'k:',af2n*180/pi,o2lm(2,:)*180/pi,'g:')
    
    figure(1)
    subplot(2,2,sbp),
%     plot(af2n*180/pi,(aco)*180/pi,'b')
    plot(af2n*180/pi,(aco)*180/pi,'b',alo1*180/pi,aco*180/pi,'k:',...
        alo2*180/pi,aco*180/pi,'g:')
    hold on;
end
if(pl&(~isnan(tp)))
% plot(s2n*180/pi,(so)*180/pi),hold on;
%     plot(s2n(sp)*180/pi,(so(sp))*180/pi,'ro', ...
%         s2n(tp)*180/pi,(so(tp))*180/pi,'k.'),
    plot(af2n(sp)*180/pi,(aco(sp))*180/pi,'ro', ...
        af2n(tp)*180/pi,(aco(tp))*180/pi,'k*'),
    plot(xf2*180/pi,xco*180/pi,'bx')
end
is=sp:tp;
if(length(is)>=4)
    [br,st] = robustfit(af2n(is)*180/pi,aco(is)*180/pi);
%     br(1)=aco(tp)-br(2)*af2n(tp);
     if(pl)
        plot(af2n*180/pi,br(1)+br(2)*af2n*180/pi,'r:')
        hold off
     end
else
    br=[NaN NaN];
    st.s=NaN;
end

if(length(is)>=10)
    [b1,s1] = robustfit(f2n(sp:sp+5)*180/pi,(co(sp:sp+5))*180/pi);
    [b2,s2] = robustfit(f2n(tp-5:tp)*180/pi,(co(tp-5:tp))*180/pi);
    gs=MyGradient(co(is),f2n(is));%MyGradient(aco,af2n);
    g2=gs([end-1 end-5 end-9]);
else
    b1=[NaN NaN];
    s1.s=NaN;
    b2=[NaN NaN];
    s2.s=NaN;
    g2=[NaN NaN NaN];    
end


% figure(2)
% subplot(2,2,sbp),
% plot((s2n)*180/pi,(so)*180/pi),hold on;
PhDat.c(sbp)=PhDat.c(sbp)+1;
if(~isnan(tp))
    i2=[sp tp];
    d2=cs(tp,:)-cs(sp,:);
    do2n=AngularDifference(o2n(sp),o2n(tp))*180/pi;
%     if(f2n(sp)>f2n(tp)) br(2)=-br(2); end
    vec=[br(2) br(1) st.s i2 f2n(i2)'*180/pi ...
            co(i2)'*180/pi s2n(i2)'*180/pi so(i2)'*180/pi ...
            o2n(i2)'*180/pi length(is) ...
            b1(2) b2(2) s1.s s2.s g2 xco*180/pi xf2*180/pi ...
            xts xds cs(sp,:) cs(tp,:) xcs xds do2n CartDist(d2) d];

    % vec variables explained
    % 1 to 3 are straight line fit params of fltdir=k flight + c   
    % 4 to 5 are start and pt after 0 x-ing
    % 6 to 15 are 5 x 2 measurments (start, pt after 0 x-ing) of rel
    % fltdir, fltdir, retinal nest, body o and o to nest
    % 16 to 23: section length and more straight line fit params of fltdir=k flight + c 
    % next 4x6 data are various params interpolated at f2nest = 0:-20:-100  
    % 24 to 29 are flight dir (compass)
    % 30 to 35 are flight dir rel to nest = 0:-20:-100; good markers*!!
    % 36 to 41 are time
    % 42 to 47 cumulative distance thru flt section
    % 48 to 51 Positions of start and pt after 0 x-ing
    % 52 to 63 6 x 2 (x,y) positions at interpolated points
    % 64 to 69 cumulative distance thru flt section AGAIN** BUG**
    % 70  angular difference between start and 0-xing o to nest (degrees)
    % 71 to 72 distance from start to 0-xing, distance of start of section to nest
        
    eval(['PhDat.m' int2str(sbp) '=[PhDat.m' int2str(sbp) ';vec];']);
    eval(['vl=size(PhDat.m' int2str(sbp) ',1);'])
    eval(['PhDat.dat' int2str(sbp) '(vl).f2n=f2n*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).co=co*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).s2n=s2n*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).so=so*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).is=is;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).t=t;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).xps=xps;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).f2nex=f2nex*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).coex=coex*180/pi;']);
    eval(['PhDat.dat' int2str(sbp) '(vl).tex=tex;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).cs=cs;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).ds=dvs;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).o2lm=o2lm;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).lmor=lmor;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).f2lm=f2lm;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).o2n=o2n;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).spee=spee;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).ra_co=ra_co;']);    
    eval(['PhDat.dat' int2str(sbp) '(vl).ra_so=ra_so;']);    
    PhDat.m=[PhDat.m;vec];
end

function DistanceCompLoops
hcd=cd;
count=1;
dstarts=[];dAngends=[];allt=[];
for i=[3:5 7]%2%
    changedir(i);
    figure(i+10)
    load loopstatstemp
    dstarts=[dstarts CartDist(XPts)'];
    dVends=CartDist(maxds(:,1:2));
    dAngends=[dAngends CartDist(eptsMid(:,1:2))'];
    dAngCends=CartDist(eptsAngc(:,1:2));
    dMids=CartDist(midpts);
    allt=[allt relloopt];
    [ds,xp]=StatsOverX(allt,dstarts,[0.05 .2:.1:1]);
%     [dVe,xp]=StatsOverX(loopt,dVends,10);
    [dAe,xp]=StatsOverX(allt,dAngends,[0.05 .2:.1:1]);
%     [dAe2,xp]=StatsOverX(loopt,dAngCends,10);
%     [dm,xp]=StatsOverX(loopt,dMids,10);
%     [rs,xr]=StatsOverX(relloopt,dstarts,10);
%     [rVe,xr]=StatsOverX(relloopt,dVends,10);
%     [vAe,xr]=StatsOverX(relloopt,dAngends,10);
%     [vAe2,xr]=StatsOverX(relloopt,dAngCends,10);
%     [rm,xr]=StatsOverX(relloopt,dMids,10);
    figure(1),%subplot(2,1,1)
%     plot(xp,[ds.me],xp,[dVe.me],'r:',xp,[dm.me],'k--',...
%         xp,[dAe.me],'g:',xp,[dAe2.me],'c--')
    xlabel('time'),ylabel('distance (cm)'),axis tight,ylim([0 48])
%     plot(dstarts,dMids,'x',[0 25],[0 25]),axis tight,%axis equal
%     plot(loopt,dstarts,'o',loopt,dMids,'x'),axis tight,%axis equal
    plot(xp,[ds.med],xp,[dAe.med],'k:')
    np=.01;
    errorbar(xp-np,[ds.med],[ds.med]-[ds.p25],[ds.p75]-[ds.med],'k','LineWidth',1),hold on;
    errorbar(xp+np,[dAe.med],[dAe.med]-[dAe.p25],[dAe.p75]-[dAe.med],'k:','LineWidth',1),hold off;
    Setbox;
    mn=50;
    xlabel('time (normalised)'),ylabel('distance (cm)'),axis tight,    
    axis([0.1 1 0 mn])
    p=get(gca,'Position');
%     title(loops(1).fn(1:10))
    figure(2),%subplot(2,1,2)
%     plot(xr,[rs.me],xr,[rVe.me],'r:',xr,[rm.me],'k--',...
%         xr,[vAe.me],'g:',xr,[vAe2.me],'c--')
    xlabel('relative time'),axis tight,ylow(0)
    ma=max([dstarts dAngends])
    plot(dstarts,dAngends,'kx')
    hold on,plot([0 ma],[0 ma],'k','LineWidth',1),hold off,axis equal,axis tight,%
%     plot(loopt,dstarts,'o',loopt,dAngends,'x'),axis tight,%axis equal
    axis([0 mn 0 mn])
    xlabel('loop start (cm)'),ylabel('loop mid-point (cm)')
    set(gca,'Position',p)
    Setbox
    [ds.n]
    xp
    rats=dstarts./dAngends;
    medi(count)=median(rats)
    [pval(count),h(count)]=signtest(rats,1);
    figure(8),subplot(3,2,count)
    hist(rats,0:.25:2),xlim([0 2])
    count=count+1;
end
[medi;pval]
cd(hcd)

function TimeComparisonLoopsZZs

% load ../2' east all'/temp2ELoopPhaseDataAll.mat
load 2e2wPhaseDataAll

datLCoin=[wPhDat.dat1 wPhDat.dat3 ePhDat.dat1 ePhDat.dat3 ];
mLCoin=[wPhDat.m1;wPhDat.m3;ePhDat.m1;ePhDat.m3];
datZCoin=[wzPhDat.dat1 wzPhDat.dat3 ezPhDat.dat1 ezPhDat.dat3 ];
mZCoin=[wzPhDat.m1;wzPhDat.m3;ezPhDat.m1;ezPhDat.m3];

datL=[wPhDat.dat1 wPhDat.dat2 wPhDat.dat3 wPhDat.dat4 ...
    ePhDat.dat1 ePhDat.dat2 ePhDat.dat3 ePhDat.dat4];
mL=[wPhDat.m1;wPhDat.m2;wPhDat.m3;wPhDat.m4; ...
    ePhDat.m1;ePhDat.m2;ePhDat.m3;ePhDat.m4];
datZ=[wzPhDat.dat1 wzPhDat.dat2 wzPhDat.dat3 wzPhDat.dat4 ...
    ezPhDat.dat1 ezPhDat.dat2 ezPhDat.dat3 ezPhDat.dat4];
mZ=[wzPhDat.m1;wzPhDat.m2;wzPhDat.m3;wzPhDat.m4; ...
    ezPhDat.m1;ezPhDat.m2;ezPhDat.m3;ezPhDat.m4];

[xts]=GetTimeXings(datL,mL);
[xtzs]=GetTimeXings(datZ,mZ);
for i=1:5
    d=xts(:,i+1)-xts(:,i);
    dn=d(~isnan(d));
    nlf(i)=sum(~isnan(d));
    medlf(i)=median(dn);
    iqrlf(i,:)=prctile(dn,[25 75]);
    d=xtzs(:,i+1)-xtzs(:,i);
    dnz=d(~isnan(d));
    nzf(i)=sum(~isnan(d));
    medzf(i)=median(dnz);
    iqrzf(i,:)=prctile(dn,[25 75]);
    [p(i),h(i)]=ranksum(dn,dnz);
    subplot(3,2,i),hist(dn,[0:0.01:0.5])
end

ma=[wPhDat.m;ePhDat.m];
% ma=PhDat.m;
indis=37:41;
angs=[-20:-20:-100];

% distance from loop to start point
divs=0:10:50;
d_midpts=CartDist(ma(:,[52 53]));
xst='distance from nest to ftonest=0';

% % distance travelled from start to 0-xing
% divs=0:4:20;
% d_midpts=ma(:,71);
% xst='distance from start to 0 x-ing';

scat=0;
for i=1:5
%     dt(i,:)=(ma(:,36)-ma(:,indis(i)))';
    dt(i,:)=(ma(:,indis(i)-1)-ma(:,indis(i)))';
    dn=dt(i,~isnan(dt(i,:)));
    nl(i)=sum(~isnan(dt(i,:)));
    medl(i)=median(dn);
    iqrl(i,:)=prctile(dn,[25 75]);
    subplot(3,2,i)
    if(scat) plot(d_midpts,dt(i,:),'bo')
    else
        [da,xpt]=StatsOverX(d_midpts(~isnan(dt(i,:))),dn,divs);
        plot(xpt,[da.me],'k')
    end
    hold on   
end

% load ../2' east all'/temp2EZZPhaseDataAll.mat
ma=ezPhDat.m;
ma=[wzPhDat.m;ezPhDat.m];

d_midpts=CartDist(ma(:,[52 53]));
% d_midpts=ma(:,71);

for i=1:5
%     dz(i,:)=(ma(:,36)-ma(:,indis(i)))';
    dz(i,:)=(ma(:,indis(i)-1)-ma(:,indis(i)))';
    dn=dz(i,~isnan(dz(i,:)));
    nz(i)=sum(~isnan(dz(i,:)));
    medz(i)=median(dn);
    iqrz(i,:)=prctile(dn,[25 75]);
    subplot(3,2,i)
    if(scat) plot(d_midpts,dz(i,:),'rx')
    else
        [da,xpt]=StatsOverX(d_midpts(~isnan(dz(i,:))),dn,divs);
        plot(xpt,[da.me],'k:')
    end
    xlabel(xst)
%     ylabel(['time between ' int2str(angs(i)) ' and 0'])
    ylabel(['time between ' int2str(angs(i)) ' and ' int2str(angs(i)+20)])
    hold off
    axis tight
    ylim([0 0.08])
end
for i=1:5
    [p2(i),h]=ranksum(dt(i,~isnan(dt(i,:))),dz(i,~isnan(dz(i,:))));
end
x=-90:20:100;
medl=[medl(end:-1:1) medlf];iqrl=[iqrl(end:-1:1,:);iqrlf];
medz=[medz(end:-1:1) medzf];iqrz=[iqrz(end:-1:1,:);iqrzf];

subplot(3,2,6)
% plot(10:20:90,medl,'k',10:20:90,medz,'k:')
% plot(10:20:90,medl,'k',10:20:90,medz,'k:')
figure,MotifFigs(gcf,1)
errorbar(x-3,medl,medl-iqrl(:,1)',iqrl(:,2)'-medl,'k'),hold on;
errorbar(x+3,medz,medz-iqrz(:,1)',iqrz(:,2)'-medz,'k:'),hold off;
ylabel('median time for 20degs');xlabel('start angle')
axis tight;Setbox,ylow(0)
meds=[medl;medz]
ns=[nl(end:-1:1) nlf;nz(end:-1:1) nzf]
[p2(end:-1:1) p]

function[xts]=GetTimeXings(dat,m)
angs=[0:20:100];
f2ns=[];
for k=1:length(dat)
    inds=1:length(dat(k).t);
    f2n=(dat(k).f2n(inds))';
    f2ns=[f2ns f2n];
    co=(dat(k).co(inds))';
    t=dat(k).t(inds);
%     af2n=AngleWithoutFlip(rf);
    aco=AngleWithoutFlip(co);
    sp=m(k,4);
    tp=m(k,5);
    if(f2n(sp)<0)
        angs=-100:20:100;
    else
        angs=100:-20:-100;
    end
    if(~isnan(tp))
%         xts(k,:)=interp1(f2n(tp-1:end),t(tp-1:end),0:20:100);
%         xt2s(k,:)=interp1(f2n(tp-1:2:end),t(tp-1:2:end),0:20:100);
%         xts(k,:)=interp1(f2n(sp:end),t(sp:end),angs);
%         xt2s(k,:)=interp1(f2n(sp:2:end),t(sp:2:end),angs);
        [xps,xco,rf2,xf2,xts(k,:)]=GetXPFwd(aco,f2n,tp,sp,0:20:100,t);
    end
end



function[xps,xco,rf2,xf2,xts]=GetXPFwd(co,f2n,tp,sp,angs,t)
% function[xps,xco,rf2,xf2,xts,xds,xcs]=GetXPFwd(co,f2n,tp,sp,angs,t,ds,cs)
is=tp-1:length(co);
% is=tp:-1:sp;
m=f2n(sp);
xcs=ones(1,2*length(angs))*NaN;
for j=1:length(angs)
    if(m<0) 
        ind=find(f2n(is)>=angs(j),1);
        xf2(j)=angs(j);
    else
        ind=find(f2n(is)<=-angs(j),1);
        xf2(j)=-angs(j);        
    end
    if(isempty(ind))
        xps(j)=NaN;
        xco(j)=NaN;
        rf2(j)=NaN;
        xf2(j)=NaN;
        xts(j)=NaN;
%         xds(j)=NaN;
%         xcs(j,:)=[NaN NaN];
    else
        i1=is(ind);
        dc=co(i1)-co(i1-1);
        df=f2n(i1)-f2n(i1-1);
        d2=xf2(j)-f2n(i1-1);
        xps(j)=i1;
        xco(j)=co(i1-1)+dc*d2/df;
        rf2(j)=d2/df;
        dt=t(i1)-t(i1-1);
        xts(j)=t(i1-1)+dt*d2/df;
%         dd=ds(i1)-ds(i1+1);
%         xds(j)=ds(i1+1)+dd*d2/df;
%         dc=cs(i1,:)-cs(i1+1,:);
%         xcs([2*j-1 2*j])=cs(i1+1,:)+dc*d2/df;
    end
end
if(m<0) plot(t,f2n,xts,angs,'rx')
else plot(t,f2n,xts,-angs,'rx')
end

function IterateRobFit(x,y,LM,LMWid)

is=1:length(x);
while(length(is)>4)
    [br,s]=robustfit(x(is),y(is));
    yn=br(1)+br(2)*x(is);
    plot(x,y,'x',x(is),yn,x(is),y(is),'ro')
    hold on; PlotNestAndLMs(LM,LMWid,[0 0],0); hold off
    [m,ib]=max(abs(s.resid));
    is=is([1:(ib-1) (ib+1):end]);
end

function[sp]=GetSP(f2n,tp,sp,co)
lsm=tp:-1:1;
d=sign(diff(f2n(lsm)));
d2=sign(diff(co(lsm)));
d=d.*d2;
s=d(1);
for j=2:length(d)
    if(d(j)~=s)
        if(j==length(d))
            sp=lsm(j);
        elseif(d(j+1)~=s)
            sp=lsm(j);
            break;
        else
            i1=lsm(j);
            i2=lsm(j+1);
            dc=abs(AngularDifference(co(i1),co(i2)));
            df=abs(AngularDifference(f2n(i1),f2n(i2)));
%             dc=abs(co(i1)-co(i2));
%             df=abs(f2n(i1)-f2n(i2));
            if(max(dc,df)>pi/4)
                sp=lsm(j);
                break;
            end
        end
    end
end

function[xps,xco,rf2,xf2,xts,xds,xcs]=GetXP(co,f2n,tp,sp,angs,t,ds,cs)
is=tp:-1:sp;
m=f2n(sp);
xcs=ones(1,2*length(angs))*NaN;
for j=1:length(angs)
    if(m<0) 
        ind=find(f2n(is)<=-angs(j),1);
        xf2(j)=-angs(j);
    else
        ind=find(f2n(is)>=angs(j),1);
        xf2(j)=angs(j);        
    end
    if(isempty(ind))
        xps(j)=NaN;
        xco(j)=NaN;
        rf2(j)=NaN;
        xf2(j)=NaN;
        xts(j)=NaN;
        xds(j)=NaN;
    else
        i1=is(ind);
        dc=co(i1)-co(i1+1);
        df=f2n(i1)-f2n(i1+1);
        d2=xf2(j)-f2n(i1+1);
        xps(j)=i1;
        xco(j)=co(i1+1)+dc*d2/df;
        rf2(j)=d2/df;
        dt=t(i1)-t(i1+1);
        xts(j)=t(i1+1)+dt*d2/df;
        dd=ds(i1)-ds(i1+1);
        xds(j)=ds(i1+1)+dd*d2/df;
        dc=cs(i1,:)-cs(i1+1,:);
        xcs([2*j-1 2*j])=cs(i1+1,:)+dc*d2/df;
    end
end


function PlotLoopPsi(psicw,psiaw,f2ncw,f2naw,cocw,coaw,ipl,pea,...
    cwin,awin,cwout,awout)
ystr=('flt dir, psi=0 & f2n=0');% 
if((pea==1)|(pea==3)) lmst=['2 east: '];
elseif((pea==2)|(pea==4)) lmst=['2 west: '];
else lmst=[''];
end
% ystr=('body o, f2n=0');%psi=0 & 
figure(ipl+7)
% cc=find(te(:,1)==1);ac=find(te(:,1)==-1);
thd=10;
t3=[-180:thd:180+thd]-thd/2;
thd=20;
t2=[-180:thd:180+thd]-thd/2;
t=t2;%[0:thd:360+thd]-thd/2;
cocw(:,[1:5])=cocw(:,[1:5])*180/pi;
coaw(:,[1:5])=coaw(:,[1:5])*180/pi;
% cocw(:,[3 4])= mod(cocw(:,[3 4]),360);
% coaw(:,[3 4])= mod(coaw(:,[3 4]),360);

nstr=['CW=' int2str(size(cocw,1)) ' CCW=' int2str(size(coaw,1))];

subplot(3,2,1),plot(cocw(:,3),cocw(:,5),'o');axis equal;axis tight;xlabel('CW start'),ylabel(ystr)
subplot(3,2,2),plot(cocw(:,4),cocw(:,5),'ro');axis equal;axis tight;xlabel('CW end'),ylabel(ystr)
subplot(3,2,3),plot(coaw(:,3),coaw(:,5),'o');axis equal;axis tight;xlabel('CCW start'),ylabel(ystr)
subplot(3,2,4),plot(coaw(:,4),coaw(:,5),'ro');axis equal;axis tight;xlabel('CCW end'),ylabel(ystr)

subplot(3,2,5)

[y,x]=AngHist(cocw(:,3));yc=y/sum(y);
[y,x]=AngHist(coaw(:,3));ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,
xlabel(['flight direction at start' nstr]),
subplot(3,2,6)
[y,x]=AngHist(cocw(:,4));yce=y/sum(y);
[y,x]=AngHist(coaw(:,4));yae=y/sum(y);
plot(x,yce,x,yae,'r:'),axis tight,
xlabel(['flight direction at end' nstr]),

% [y,x]=AngHist(cocw(:,5));ycm=y/sum(y);
% [y,x]=AngHist(coaw(:,5));yam=y/sum(y);
% [y,x]=AngHist(f2ncw(:,1)*180/pi);ycfs=y/sum(y);
% [y,x]=AngHist(f2naw(:,1)*180/pi);yafs=y/sum(y);
% [y,x]=AngHist(f2ncw(:,2)*180/pi);ycfe=y/sum(y);
% [y,x]=AngHist(f2naw(:,2)*180/pi);yafe=y/sum(y);
% subplot(2,2,1),plot(x,yc,x,ycfs,'r:',x,ycm,'k--')
% subplot(2,2,2),plot(x,ya,x,yafs,'r:',x,yam,'k--')
% subplot(2,2,3),plot(x,yce,x,ycfe,'r:')
% subplot(2,2,4),plot(x,yae,x,yafe,'r:'),


h=figure(ipl+14);
[Dsc,xs,ys,xps,yps]=Density2DAng(cocw(:,3),cocw(:,5),t,t2);
[Dec,xs,ys,xps,yps]=Density2DAng(cocw(:,4),cocw(:,5),t,t2);
[Dsa,xs,ys,xps,yps]=Density2DAng(coaw(:,3),coaw(:,5),t,t2);
[Dea,xs,ys,xps,yps]=Density2DAng(coaw(:,4),coaw(:,5),t,t2);
nlev=8;
% Dsc=Dsc./max(Dsc(:));Dec=Dec./max(Dec(:));
% Dsa=Dsa./max(Dsa(:));Dea=Dea./max(Dea(:));
m1=max([Dsc(:);Dec(:)])
clev=0.5;
if(m1<=(10)) 
%     v1=[0 0.5 1:m1]; 
%     v1=[0:m1]; 
    v1=unique([0 [0:m1]-clev]); 
else g=m1/nlev;v1=[0:g:m1-g];
end
m2=max([Dsa(:);Dea(:)])
if(m2<=(nlev+1)) 
%     v2=[0 0.5 1:m2]; 
    v2=unique([0 [0:m2]-clev]);
else g=m2/nlev;v2=[0:g:m2-g]; 
end;
nw=1;
plnums=[1:4];            % for subplots
% plnums=ipl+[30 33 36 39];  % fpr sep[arate figs
contplot(xps,yps,Dsc,v1,ystr,[lmst 'CW start'],nw,pea,plnums(1))
contplot(xps,yps,Dec,v1,ystr,[lmst 'CW end' ],nw,pea,plnums(2))
contplot(xps,yps,Dsa,v2,ystr,[lmst 'CCW start'],nw,pea,plnums(3))
contplot(xps,yps,Dea,v2,ystr,[lmst 'CCW end'],nw,pea,plnums(4))

% figure(h);
% clf(h);MotifFigs(h,1);
subplot(3,1,3)
% load temp_ZZPsi
[y,x]=AngHist(cocw(:,5));yc=y/sum(y);
[y,x]=AngHist(coaw(:,5));ya=y/sum(y);
% [y,x]=AngHist(zzcw(:,5)*180/pi);yb=y/sum(y);
% [y,x]=AngHist(zzaw(:,5)*180/pi);yd=y/sum(y);
is=[35 36 1:36 1];the=-190:10:190;
plot(the,yc(is),the,ya(is),'r:'),axis tight;ya=ylim;ylim([0 ya(2)]);
% plot(the,yc(is),the,yb(is),'r:'),axis tight;ya=ylim;ylim([0 ya(2)]);
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
xlabel('flight direction in middle'),ylabel('frequency')

h=figure(ipl+40);MotifFigs(h,1);
[y,x]=hist(cocw(:,6),0:0.1:1);yc=y/sum(y);
[y,x]=hist(coaw(:,6),0:0.1:1);ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight;Setbox,
xlabel('relative time of mid-pts'),ylabel('frequency')

v1
v2

[pvalme, table] = circ_wwtest(cocw(:,5)*pi/180, coaw(:,5)*pi/180)
[pvalmed, med, P] = circ_cmtest(cocw(:,5)*pi/180, coaw(:,5)*pi/180)
medCW = circ_median(cocw(:,5)*pi/180)*180/pi;
medCCW = circ_median(coaw(:,5)*pi/180)*180/pi;
medians=[medCW medCCW]

% subplot(1,2,1),plot(psicw(:,1)*180/pi,te(cc,2),'o')
% subplot(1,2,2),plot(psiaw(:,1)*180/pi,te(ac,2),'ro')
figure(ipl)
subplot(3,2,1)
[y,x]=AngHist(psicw(:,1)*180/pi);yc=y/sum(y);
[y,x]=AngHist(psiaw(:,1)*180/pi);ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,xlabel('psi at start'),
title(['Cwise (blue) N=' int2str(size(psicw,1)) '; Anti (red :) N=' int2str(size(psiaw,1))])
subplot(3,2,2)
[y,x]=AngHist(f2ncw(:,1)*180/pi);yc=y/sum(y);
[y,x]=AngHist(f2naw(:,1)*180/pi);ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,xlabel('fdir rel 2 nest at start')
subplot(3,2,3)
[y,x]=AngHist(psicw(:,2)*180/pi);yc=y/sum(y);
[y,x]=AngHist(psiaw(:,2)*180/pi);ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,xlabel('psi at end')
subplot(3,2,4)
[y,x]=AngHist(f2ncw(:,2)*180/pi);yc=y/sum(y);
[y,x]=AngHist(f2naw(:,2)*180/pi);ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,xlabel('fdir rel 2 nest at end')
subplot(3,2,5)
[y,x]=AngHist(cocw(:,1));yc=y/sum(y);
[y,x]=AngHist(coaw(:,1));ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,
xlabel(['difference in flight direction at start' nstr]),
subplot(3,2,6)
[y,x]=AngHist(cocw(:,2));yc=y/sum(y);
[y,x]=AngHist(coaw(:,2));ya=y/sum(y);
plot(x,yc,x,ya,'r:'),axis tight,
xlabel(['difference in flight direction at end' nstr]),

figure(ipl+50)
% order 
% co(is) f2n(is) ppsi(is) so(is) s2n(is)
tp1=2;tp2=1;
% tp1=5;tp2=1;
[Dsc,xs,ys,xps,yps]=Density2DAng(cwin(:,tp1),cwin(:,tp2),t2,t2);
[Dec,xs,ys,xps,yps]=Density2DAng(awin(:,tp1),awin(:,tp2),t2,t2);
[Dsa,xs,ys,xps,yps]=Density2DAng(cwout(:,tp1),cwout(:,tp2),t2,t2);
[Dea,xs,ys,xps,yps]=Density2DAng(awout(:,tp1),awout(:,tp2),t2,t2);
nlev=8;

m1=max([Dsc(:);Dsa(:)]);
g=m1/nlev;v1=[0:g:m1-g];
m2=max([Dec(:);Dea(:)]);
g=m2/nlev;v2=[0:g:m2-g]; 

% strs={'flight direction','flight direction relative to nest','psi','body orientation',...
%     'body O rel 2 nest'};
strs={'flt dir','f dir rel. nest','psi','body orientation',...
    'body O rel 2 nest'};
plnums=[1:4];            % for subplots
% plnums=[61:64];  % fpr sep[arate figs
contplot2(xps,yps,Dsc,v1,strs,tp1,tp2,1,plnums(1));
contplot2(xps,yps,Dsa,v1,strs,tp1,tp2,1,plnums(2));
contplot2(xps,yps,Dec,v2,strs,tp1,tp2,1,plnums(3));
contplot2(xps,yps,Dea,v2,strs,tp1,tp2,1,plnums(4));
% for i=1:4     
%     subplot(2,2,i); axis equal;axis tight;
%     xlabel(char(strs(tp1)))
%     ylabel(char(strs(tp2)));
%     g=colormap('gray');g=g(end:-1:1,:);colormap(g);
% end

figure(ipl+21)
[y,x]=AngHist(cocw(abs(cocw(:,5))<10,3));
[y2,x]=AngHist(cocw(abs(cocw(:,5))<10,4));
[y3,x]=AngHist(coaw(abs(coaw(:,5))<10,3));
[y4,x]=AngHist(coaw(abs(coaw(:,5))<10,4));
y5=y+y2+y3+y4;
subplot(3,1,1),plot(x,y/sum(y),x,y2/sum(y2),'r:'),axis tight
subplot(3,1,2),plot(x,y3/sum(y3),x,y4/sum(y4),'r:'),axis tight
subplot(3,1,3),plot(x,y5/sum(y5)),axis tight

bsc=robustfit(psicw(:,5),psicw(:,6));
bsa=robustfit(psiaw(:,5),psiaw(:,6));
ncw=size(psicw,1);nccw=size(psiaw,1)
sts=[bsc bsa]
subplot(3,1,1),tdc=psicw(:,5)-psicw(:,6);[tc,x]=hist(tdc,-0.3:0.02:.3);
tda=psiaw(:,5)-psiaw(:,6);[ta,x]=hist(tda,-0.3:0.02:.3);
mtc=median(tdc(~isnan(tdc)));mta=median(tda(~isnan(tda)));ymt=[0 .1];
plot(x,tc/sum(tc),'b',x,ta/sum(ta),'r:',[mtc mtc],ymt,'k',[mta mta],ymt,'k:'),axis tight
xlabel('t when psi=0 - t when flying to nest; CW=blue, CCW red-dot');axis tight
lc=sum(~isnan(tdc));la=sum(~isnan(tda));
ylabel(['CW=' int2str(lc) '; CCW=' int2str(la)])
title(['Total CW=' int2str(ncw) '; Total CCW=' int2str(nccw)]);

subplot(3,1,2);[ya,x]=AngHist(psiaw(:,3)*180/pi);
[yc,x]=AngHist(psicw(:,3)*180/pi);
plot(x,yc/sum(yc),'b',x,ya/sum(ya),'r:'),axis tight
xlabel('flight direction when psi=0; CW=blue, CCW red-dot');
lc=sum(~isnan(psicw(:,3)));la=sum(~isnan(psiaw(:,3)));
ylabel(['CW=' int2str(lc) '; CCW=' int2str(la)])

subplot(3,1,3);[yc,x]=AngHist(psicw(:,4)*180/pi);
[ya,x]=AngHist(psiaw(:,4)*180/pi);
plot(x,yc/sum(yc),'b',x,ya/sum(ya),'r:'),axis tight
xlabel('psi when flying towards nest, CW=blue, CCW red-dot');
lc=sum(~isnan(psicw(:,3)));la=sum(~isnan(psiaw(:,3)));
ylabel(['CW=' int2str(lc) '; CCW=' int2str(la)])
figure(ipl+14)
% keyboard

function contplot2(xs,ys,D,v,strs,tp1,tp2,n,npl)
subplot(2,2,npl),
% h=figure(npl),
% MotifFigs(h,2);

L=size(D,1);
is=[L-n+1:L 1:L 1:n];
% is=[1:L 1:n];
D=D(:,is);
D=D(is,:);
if(n==1) 
    xps=[-180:20:200];
    yps=[-180:20:200];
elseif(n==2) 
    xps=[-200:20:220];
    yps=[-200:20:220];
else
    xps=xs;
    yps=ys;
end
contourf(xps,yps,D,v);
SetXTicks(gca,[],[],[],[-180 -90 0 90 180])
SetYTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
xlabel(char(strs(tp1)));
ylabel(char(strs(tp2)));
axis equal;axis tight;
g=colormap('gray');
g=g(end:-1:1,:);
colormap(g);


function contplot(xs,ys,D,v,xstr,ystr,n,pea,npl)
subplot(3,2,npl),
% h=figure(npl),
% MotifFigs(h,2);

L=size(D,1);
is=[L-n+1:L 1:L 1:n];
% is=[1:L 1:n];
D=D(:,is);
D=D(is,:);
if(n==1) 
    xps=[-180:20:200];
    yps=[-180:20:200];
elseif(n==2) 
    xps=[-200:20:220];
    yps=[-200:20:220];
else
    xps=xs;
    yps=ys;
end

contourf(xps,yps,D,v);
% imagesc(xps,yps,D);
% caxis([min(v) max(v)+v(2)]);
% set(gca,'YDir','normal')

peaks=[-160 -50 10 120;-160 -50 10 120;-160 -50 10 120;-160 -50 10 120]
% 2 east and 2 west combined in loops and zzs
peaks=[-170 -50 30 130;-170 -50 30 130;-140 -50 10 120;-140 -50 10 120]
if(pea<=4)
    hold on;
    plot([-180 200],[peaks(pea,:)' peaks(pea,:)'],'k:')
    plot([peaks(pea,:)' peaks(pea,:)'],[-180 200],'k:')
    hold off
end
axis equal;axis tight;
SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
SetYTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

ylabel(ystr)%xlabel(xstr),
g=colormap('gray');
g=g(end:-1:1,:);
colormap(g);

function[s,e,l,med_ind]=StartFinish(t,is,th)
s=[];e=[];l=[];med_ind=[];
if(isempty(is)) return; end;
i=1;
while 1
    s=[s is(i)];
    ex=find(diff(t(is(i:end)))>th,1);
    if(isempty(ex)) 
        e=[e is(end)];
        break;
    else e=[e is(i+ex-1)];
    end
    i=i+ex;
end
l=e-s+1;
for i=1:length(s)
    med_ind(i)=GetTimes(t,median(t(s(i):e(i))));
end

function MotifFigs(h,ty)

if(ty==1)  % non contour-plot)
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\StraightLineAngles In Loops And ZZs.fig',1)
    % p1=get(gcf,'Position')
    % set(gca,'Units','centimeters');Pos=get(gca,'Position')
    p1=[215 407 311 190];
    p2=[1.5334 0.6081 5.9078 4.0384];
else   % contour plot
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\FDirVsPsiContour Straights Ins.fig',1)
    % Pos=get(gcf,'Position')
    p1=[217 407 311 267];
    % uiopen('C:\_MyDocuments\WorkPrograms\Bees\bees07\WholeFlightStats\StraightLineAngles In Loops And ZZs.fig',1)
    % set(gca,'Units','centimeters');Pos=get(gca,'Position')
    p2=[1.5334 0.6081 5.9078 5.9078];
end
set(h,'Position',p1);
set(gca,'Units','centimeters','Position',p2);

function FlightDirAndBodyRel2CompassAndNest
load temp2e2w_LoopsAndZZs_bodyandflightdirections
is=[35 36 1:36 1];the=-190:10:190;
yl=[.055 .1 .055 .1];

for i=1:4
%     subplot(2,2,i)
    figure(i)
    MotifFigs(gcf,1)
    eval(['l=loo.y' int2str(i) ';']);% '/sum(loo.y' int2str(i) ');']);
    eval(['z=zz.y' int2str(i) ';']);%
    ns(i,:)=[sum(l) sum(z)];
    l=l/sum(l);
    z=z/sum(z);
    plot(the,l(is),'k',the,z(is),'k:','LineWidth',0.75)
    axis tight;
    ylim([0 yl(i)]);
    ylabel('frequency')
    Setbox,
    SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
end
ns






function[hand,angdiff,mad] = LoopHandednes(co)

smlen=2;
len=length(co);
en=min(1+smlen,len);
st=max(1,len-smlen);
angin=MeanAngle(co(1:en));
angout=MeanAngle(co(st:end));
angdiff=AngularDifference(angout+pi,angin);
if(angdiff<0) hand=-1;
else hand=1;
end
angdiff=round(angdiff*180/pi);
ad=medfilt1(gradient(AngleWithoutFlip(co)));
mad=round([median(ad) mode(ad)]*180/pi);
% figure(1),plot(ad*180/pi)

function StraightFigs2
load tmpscriptbees_straightdata
thd=15;
t2=[-180:thd:180+thd]-thd/2;
figure(5)
str=[' 2E';' 2W';' N8';' W8';' E8';'all']
for i=1:5
    subplot(3,2,i)
    plotStraightFigs2(sfs(i,:),t2)
    title(str(i,:))
end
subplot(3,2,6)
figure(10)
plotStraightFigs2(sfs,t2)
MotifFigs(gcf,2)
title(str(6,:))

figure(6)
% subplot(1,2,2)
for i=1:5
    subplot(3,2,i)
    plotStraightFigs2(sfsi(i,:),t2)
    title(str(i,:))
end
subplot(3,2,6)
figure(12)
plotStraightFigs2(sfsi,t2)
MotifFigs(gcf,2)
title(str(6,:))


function plotStraightFigs2(sfs,t2)
co=[sfs(:,:).co];
so=[sfs(:,:).so];
o2n=[sfs(:,:).o2n];
ppsi=AngularDifference(co,so)*180/pi;
s2n=AngularDifference(so,o2n)*180/pi;
fdir=AngularDifference(co,o2n)*180/pi;
ppsi=s2n;
[D,xs,ys,xps,yps]=Density2DAng(ppsi,fdir,t2,t2);
[c,h]=contourf(xps,yps,D);
g=colormap('gray');colormap(g(end:-1:1,:));axis equal
[da,x]=StatsOverX(fdir*(pi/180),ppsi*(pi/180),t2*(pi/180));
hold on;
plot([da.medang]*180/pi,x*180/pi,'r','LineWidth',2)
hold off
axis equal
% ylim([-120 120])
n=150;axis([-n n -n n])
grid;


function[sfs]=StraightFigs

sf=[];
origdir=cd;
thd=20;
thdiv=[-180:thd:180+thd]-thd/2;
thdiv2=[0:thd:360+thd]-thd/2;
for i=[1:5]
%     subplot(111)
% figure(i)
    changedir(i);
%     load processflightsecOut sfs
     load processflightsecIn sfs
     as=[sfs.a];
    co=AngularDifference([sfs.co],0);
    so=[sfs.so];
    o2n=[sfs.o2n];
    ppsi=AngularDifference(co,so)*180/pi;
    f2n=AngularDifference(co,o2n)*180/pi;
    b2n=AngularDifference(so,o2n)*180/pi;
    r=f2n./ppsi;
    figure(2),subplot(3,2,i); [dat,xp]=StatsOverX(ppsi,r);
    dm=[dat.med];errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm)
%     hist(r,[-20:0.25:20]),axis tight,xlim([-5 5])
    figure(1),subplot(3,2,i)
%     [Dpsif,xs,ys,xps,yps]=Density2D(ppsi,f2n,thdiv,thdiv);
    [Dpsif,xs,ys,xps,yps]=Density2D(ppsi,co*180/pi,thdiv,thdiv);
   contourf(xps,yps,Dpsif);axis tight;xlabel('\psi');ylabel('f dir 2 nest')
       
    sf=[sf;sfs];
    str=cd;sp=findstr(str,'\');
    title(str(sp(end)+1:end))
    cd(origdir);
end
sfs=sf;
co=[sfs.co];so=[sfs.so];o2n=[sfs.o2n];
ppsi=AngularDifference(co,so)*180/pi;
f2n=AngularDifference(co,o2n)*180/pi;
r=f2n./ppsi;
figure(2),subplot(3,2,6);[dat,xp]=StatsOverX(ppsi,r);
% dm=[dat.med];errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm)
hist(r,[-20:0.25:20]),axis tight,xlim([-5 5])
figure(12),%subplot(3,2,6)
[Dpsif,xs,ys,xps,yps]=Density2D(ppsi,f2n,thdiv,thdiv);
[Dpsif,xs,ys,xps,yps]=Density2D(ppsi,co*180/pi,thdiv,thdiv2);
contourf(xps,yps,max(Dpsif(:))-Dpsif);axis equal;axis tight;
xlabel('\psi');ylabel('f dir 2 nest')
xlabel('\psi');ylabel('f dir absolute')
keyboard

function[ys,yp,yf,yb,x]=PlotAllData(lfn,ppp,cst)
load(lfn)% allratesout
f2n=AngularDifference(allcos,allo2n);
s2n=AngularDifference(allsos,allo2n);
nors=AngularDifference(allo2n,allsos);
p=find(abs(allpsi)<(pi/18));
f=find(abs(f2n)<(pi/18));
s=find(abs(s2n)<(pi/18));
n=find(abs(nors)<(pi/18));
lk0ps0=intersect(p,n);

% get incidents from frames
% [dum,dum,psi0len,ips0]=StartFinish(allts,p,0.08);
% [dum,dum,psi0len,is2n0]=StartFinish(allts,s,0.08);
% [dum,dum,f2n0len,if0]=StartFinish(allts,f,0.05);
% [dum,dum,lklen,ilk]=StartFinish(allts,n,0.05);
% [dum,dum,blens,ilkpsi0]=StartFinish(allts,lk0ps0,0.05);

[ys,x]=AngHist(allsos(s)*180/pi,[],[],0);
% [ys,x]=AngHist(allsos*180/pi,[],[],0);
[yp,x]=AngHist(allsos(p)*180/pi,[],[],0);
[yf,x]=AngHist(allsos(f)*180/pi,[],[],0);
[yb,x]=AngHist(allsos(lk0ps0)*180/pi,[],[],0);
subplot(2,2,1)
plot(x,ys/sum(ys),cst),title(['facing n=' int2str(sum(ys))])
axis tight,ylim([0 0.15])
subplot(2,2,2)
plot(x,yf/sum(yf),cst),title(['flying towards nest n=' int2str(sum(yf))])
axis tight,ylim([0 0.15])
subplot(2,2,3)
plot(x,yp/sum(yp),cst),title(['psi 0 n=' int2str(sum(yp))])
axis tight,ylim([0 0.15])
subplot(2,2,4)
plot(x,yb/sum(yb),cst),title(['psi 0 and facing n=' int2str(sum(yb))])
axis tight,ylim([0 0.15])

return

disp(['nflts=' int2str(size(fltlen,1)) '; file ' lfn '; num frames =' int2str(length(allpsi))])
% subplot(3,1,1)
[s0,x]=AngHist(allpsi(s)*180/pi,[],[],0);
[f0,x]=AngHist(allpsi(f)*180/pi,[],[],0);
[y,x]=AngHist(allpsi*180/pi,[],[],0);
%     plot(x,s0/sum(s0),x,f0/sum(f0),'r:',x,y/sum(y),'g--')
figure(1)
if(ppp) plot(x,f0/sum(f0),'k'), hold on
else  plot(x,f0/sum(f0),'k:'), hold off
end
axis tight,xlabel('\psi when flying towards nest'),ylabel('Frequency (normalised)')
figure(4)
if(ppp) plot(x,y/sum(y),'k'), hold on
else  plot(x,y/sum(y),'k:'), hold off
end
axis tight,xlabel('\psi'),ylabel('Frequency (normalised)')


% subplot(3,1,2)
figure(2)
[s0,x]=AngHist(f2n(s)*180/pi,[],[],0);
[f0,x]=AngHist(f2n(p)*180/pi,[],[],0);
[y,x]=AngHist(f2n*180/pi,[],[],0);
% plot(x,s0/sum(s0),x,f0/sum(f0),'r:',x,y/sum(y),'g--')
if(ppp) plot(x,f0/sum(f0),'k'), hold on
else  plot(x,f0/sum(f0),'k:'), hold off
end
axis tight,xlabel('Flight direction relative to nest'),ylabel('Frequency (normalised)')
% subplot(3,1,3)
figure(3)
[s0,x]=AngHist(s2n(f)*180/pi,[],[],0);
[f0,x]=AngHist(s2n(p)*180/pi,[],[],0);
[y,x]=AngHist(s2n*180/pi,[],[],0);
% plot(x,s0/sum(s0),x,f0/sum(f0),'r:',x,y/sum(y),'g--')
if(ppp) plot(x,f0/sum(f0),'k'), hold on
else  plot(x,f0/sum(f0),'k:'), hold off
end
axis tight,xlabel('Body orientation relative to nest'),ylabel('Frequency (normalised)')
figure(5)
% subplot(3,2,1+ppp)
[D,xs,ys,xps,yps]=Density2D(allpsi*180/pi,f2n*180/pi,-180:10:180,-180:10:180);
contourf(xps,yps,-D+max(D(:))),axis equal,xlabel('psi'),ylabel('flight dir relative to nest')
% subplot(3,2,3+ppp)
% [D,xs,ys,xps,yps]=Density2D(allpsi*180/pi,s2n*180/pi,-180:10:180,-180:10:180);
% contourf(xps,yps,-D+max(D(:))),axis equal,xlabel('psi'),ylabel('body relative to nest')
% subplot(3,2,5+ppp)
% [D,xs,ys,xps,yps]=Density2D(s2n*180/pi,f2n*180/pi,-180:10:180,-180:10:180);
% contourf(xps,yps,-D+max(D(:))),axis equal,xlabel('body relative to nest'),ylabel('flight dir relative to nest')


function[lt,y2,o2,zy,oy,t]=ZZContours(ifig)
load processzigzagsin
dco=AngularDifference(allco,o2n);
istoa=find((AngularDifference(dco).*dco(1:end-1))<=0);
isawaya=find((AngularDifference(dco).*dco(1:end-1))>0);
% izBs=izPs;tzB=tzP;
iaway=intersect(isawaya,izBs);
ito=intersect(istoa,izBs);
% subplot(1,2,1)
% [D,xs,ys,xps,yps]=Density2D(mpsi(izBs)*180/pi,tzB,-180:20:180,0:0.05:1);
% % [D,xs,ys,xps,yps]=Density2D(mpsi(ito)*180/pi,allrelts(ito),-180:20:180,0:0.05:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('psi')
% subplot(1,2,2)
% [D,xs,ys,xps,yps]=Density2D(dang2s(izBs),tzB,-180:20:180,0:0.05:1);
% % [D,xs,ys,xps,yps]=Density2D(mpsi(iaway)*180/pi,allrelts(iaway),-180:20:180,0:0.05:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to nest')

figure(1)
subplot(2,2,1)
[D,xs,ys,xps,yps]=Density2D(mpsi(izPs)*180/pi,tzP,-180:20:180,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('psi')
subplot(2,2,2)
[D,xs,ys,xps,yps]=Density2D(ftonest(izPs)*180/pi,tzP,-180:20:180,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to nest')

subplot(2,2,3)
[D,xs,ys,xps,yps]=Density2D(allrelsp(isto),allrelts(isto),0:0.05:1,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('speed: to')
subplot(2,2,4)
[D,xs,ys,xps,yps]=Density2D(allrelsp(isaway),allrelts(isaway),0:0.05:1,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('speed: away')

lt=mpsi(izPs);y2=ftonest(izPs);t=tzP;
o2=relspzz;
zy=abs(ra_s(izPs));oy=allrelts(isto);
lt=allrelsp(isto);t=allrelts(isto);
lt=allrelsp(isaway);t=allrelts(isaway);

lt=dco;y2=dang2s;o2=mpsi;

figure(3)
subplot(1,2,1)
[D,xs,ys,xps,yps]=Density2D(abs(ra_s(izPs)),tzP,-60:60:840,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('rotational speed')
subplot(1,2,2)
[D,xs,ys,xps,yps]=Density2D(relspzz,tzP,0:0.05:1,0:0.05:1);
contourf(xps,yps,-D+max(D(:))),xlabel('translational speed')
% t=tzP;lt=ra_s(izPs);y2=relspzz;
% t=tzB;lt=ra_s(izBs);y2=relspzzB;


% 
% load processzigzagsout
% dco=AngularDifference(allco,o2n);
% subplot(2,2,3)
% [D,xs,ys,xps,yps]=Density2D(mpsi(iz2s)*180/pi,tz2,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('psi')
% subplot(2,2,4)
% [D,xs,ys,xps,yps]=Density2D(dco(iz2s)*180/pi,tz2,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to nest')

% load loopstatstemp
% [lt,xlt]=hist(looplen,0:0.1:2);%lt=lt/sum(lt);
% 
% lt=looplen;


function[lt,y2,o2,zy,oy,x]=ZZTimeDistributions(ifig)
load processzigzagsin
% [y,x]=hist(zztime,0:0.1:2);y1=y/sum(y);
% [y,x]=hist(zztime2,0:0.1:2);y2=y;%/sum(y);
% [y,x]=hist(zztimec,0:0.1:2);y3=y/sum(y);
% [y,x]=hist(zztimeP,0:0.1:2);y4=y/sum(y);
% [y,x]=hist(zztimeB,0:0.1:2);y5=y/sum(y);
% [y,x]=hist(zztimefb,0:0.1:2);y6=y/sum(y);
% [y,x]=hist(zzt,0:0.1:2);zy=y;%/sum(y);
% [y,x2]=hist(zds,-0.15:0.02:0.15);d1=y/sum(y);
% [y,x2]=hist(zds2,-0.15:0.02:0.15);d2=y/sum(y);
% [y,x2]=hist(zdsc,-0.15:0.02:0.15);d3=y/sum(y);
% [y,x2]=hist(zdsP,-0.15:0.02:0.15);d4=y/sum(y);
% [y,x2]=hist(zdsB,-0.15:0.02:0.15);d5=y/sum(y);
% [y,x2]=hist(zdsfb,-0.15:0.02:0.15);d6=y/sum(y);

mi=[median(abs(zds)) median(abs(zds2)) median(abs(zdsc)) ...
    median(abs(zdsB)) median(abs(zdsP)) median(abs(zdsfb))]; 

lt=(100*ZZProps(:,1)./ZZProps(:,3));
y2= 100*ZZProps(:,2)./ZZProps(:,3);
o2=round(median([lt y2]))

% y2=zztime2;zy=zzt;
load processzigzagsout
zy=(100*ZZProps(:,1)./ZZProps(:,3));
oy= 100*ZZProps(:,2)./ZZProps(:,3);
x=round(median([zy oy]))

subplot(3,2,ifig)
[y,x]=hist(lt,0:5:75);yi=y/sum(y);
[y,x]=hist(zy,0:5:75);yo=y/sum(y);
plot(x,yo,x,yi,'r:'),axis tight


% [y,x]=hist(zztime,0:0.1:2);o1=y/sum(y);
% [y,x]=hist(zztime2,0:0.1:2);o2=y;%/sum(y);
% [y,x]=hist(zztimec,0:0.1:2);o3=y/sum(y);
% [y,x]=hist(zztimeP,0:0.1:2);o4=y/sum(y);
% [y,x]=hist(zztimeB,0:0.1:2);o5=y/sum(y);
% [y,x]=hist(zztimefb,0:0.1:2);o6=y/sum(y);
% [y,x]=hist(zzt,0:0.1:2);oy=y;%/sum(y);
% 
% [y,x2]=hist(zds,-0.15:0.02:0.15);e1=y/sum(y);
% [y,x2]=hist(zds2,-0.15:0.02:0.15);e2=y/sum(y);
% [y,x2]=hist(zdsc,-0.15:0.02:0.15);e3=y/sum(y);
% [y,x2]=hist(zdsP,-0.15:0.02:0.15);e4=y/sum(y);
% [y,x2]=hist(zdsB,-0.15:0.02:0.15);e5=y/sum(y);
% [y,x2]=hist(zdsfb,-0.15:0.02:0.15);e6=y/sum(y);
% 
% o2=zztime2;oy=zzt;

mo=[median(abs(zds)) median(abs(zds2)) median(abs(zdsc)) ...
    median(abs(zdsB)) median(abs(zdsP)) median(abs(zdsfb))]; 
% load loopstatstemp
% [lt,xlt]=hist(looplen,0:0.1:2);%lt=lt/sum(lt);
% 
% lt=looplen;
% subplot(5,2,2*ifig-1)
% plot(xlt,lt,x,y3,'r--',x,zy,'k:')
% axis tight
% subplot(5,2,2*ifig)
% plot(xlt,lt,x,o3,'r--',x,oy,'k:')
% axis tight

% figure(ifig)
% subplot(4,1,1),plot(xlt,lt,x,oy,'g',x,zy,'r',x,y1,'r--',x,y2,'k:',x,y3,'g-s')
% subplot(4,1,2),plot(xlt,lt,x,y4,'r--',x,y5,'k:',x,y6,'g-s')
% subplot(4,1,3),plot(xlt,lt,x,o1,'r--',x,o2,'k:',x,o3,'g-s')
% subplot(4,1,4),plot(xlt,lt,x,o4,'r--',x,o5,'k:',x,o6,'g-s')
% 
% figure(ifig+1)
% subplot(4,1,1),plot(x2,d1,'r--',x2,d2,'k:',x2,d3,'g-s')
% subplot(4,1,2),plot(x2,d4,'r--',x2,d5,'k:',x2,d6,'g-s')
% subplot(4,1,3),plot(x2,e1,'r--',x2,e2,'k:',x2,e3,'g-s')
% subplot(4,1,4),plot(x2,e4,'r--',x2,e5,'k:',x2,e6,'g-s')



function RunLoopStats
origdir=cd;
loopfns={'Loopssingle_2east.mat';'Loopssingleloops_2west.mat';...
    'Loopsloopsingle_west8.mat';'LoopssingleloopsN8.mat'; ...
    'Loopssingle_east8.mat';'';'Loopssingleloops_1north2008.mat'};
loopfnsIn={'Loops_2east_ins.mat';'Loopsins2westall.mat';...
    'Loops_ins_west8.mat';'Loops_in_north8.mat'; ...
    'Loops_ins_east8.mat';'Loops_ins_south 8';'Loops_in_north2008.mat'};

for i=6:7%[1:5 7]
    figure(i)
    changedir(i);
    load(char(loopfnsIn(i)))
    loopstats(loops,'loopstatsIn.mat');
%     load loopstatstemp
% eval('ppsi=psi;');
% eval('c_os=cos;');
% BeeFDirPlot(sos,c_os,nors*180/pi,allLM,10,'loops: ',o2n,20)
% figure(20)
% [y,x]=AngHist(nors*180/pi,[],[],0); ynor=y/sum(y);
% subplot(2+nLM,2,1),hold on, plot(x,ynor,'r:');
% title('solid = psi0, red dotted all loop'),hold off;
% dtonest=AngularDifference(c_os,o2n)*180/pi;
% [y,x]=AngHist(dtonest,[],[],0); ynor=y/sum(y);
% subplot(2+nLM,2,2),hold on, plot(x,ynor,'r:');
% title('solid = psi0, red dotted all loop'),hold off;
% for i=1:nLM
%     [y,x]=AngHist(allLM(i).LMOnRetina*180/pi,[],[],0); ynor=y/sum(y);
%     subplot(2+nLM,2,3+i),hold on, plot(x,ynor,'r:');
%     title('solid = psi0, red dotted all loop'),hold off;
% end
% for i=1:nLM
%     dtolm=AngularDifference(c_os,allLM(i).OToLM)*180/pi;
%     [y,x]=AngHist(dtolm,[],[],0); ynor=y/sum(y);
%     subplot(2+nLM,2,3+nLM+i),hold on, plot(x,ynor,'r:');
%     title('solid = psi0, red dotted all loop'),hold off;
% end
%     
%     cd(origdir);
end
cd(origdir);

function PlotSpeedStats

load LoopSpeedStats2007
figure(1)
MotifFigs(gcf,1);
hist([[lstats.maxspt];[lstats.minspt]]',0.05:.1:1)
colormap gray
figure(2)
MotifFigs(gcf,1);
hist([[lstats.max_rast];[lstats.min_rast]]',0.05:.1:1)
colormap gray
[sp_l,sp_h]=ranksum([lstats.maxspt],[lstats.minspt])
[sp_h,sp_lk]=kstest2([lstats.maxspt],[lstats.minspt])
[ra_l,sp_h]=ranksum([lstats.max_rast],[lstats.min_rast])
[sp_h,ra_lk]=kstest2([lstats.max_rast],[lstats.min_rast])

rco=[lstats.rco];
ppsi=[lstats.psi];
t=[lstats.ts];
a1=AngularDifference(rco(t==0),rco(t==0.6))*180/pi;
a2=AngularDifference(ppsi(t==0),ppsi(t==0.6))*180/pi;
figure(5),subplot(2,2,1)
[y,x]=AngHist(a1(rco(t==0)<0));y1=y/sum(y);
[y,x]=AngHist(a1(rco(t==0)>0));y2=y/sum(y);
plot(x,y1,'k',x,y2,'k:')
subplot(2,2,2)
[y,x]=AngHist(a2(ppsi(t==0)<0));y1=y/sum(y);
[y,x]=AngHist(a2(ppsi(t==0)>0));y2=y/sum(y);
plot(x,y1,'k',x,y2,'k:')
[flocw]=circ_medtest(a1(rco(t==0)<0)*pi/180,0)
[floccw]=circ_medtest(a1(rco(t==0)>0)*pi/180,0)
[plocw]=circ_medtest(a2(ppsi(t==0)<0)*pi/180,0)
[ploccw]=circ_medtest(a2(ppsi(t==0)>0)*pi/180,0)

medians=[circ_median(a1(rco(t==0)<0)'*pi/180) circ_median(a1(rco(t==0)>0)'*pi/180) ...
    circ_median(a2(ppsi(t==0)<0)'*pi/180),circ_median(a2(ppsi(t==0)>0)'*pi/180)]*180/pi

rco0l=rco(t==0);
ppsi0l=ppsi(t==0);
ccwl=ppsi0l>0;
cwl=ppsi0l<0;
load ZZSpeedStats2007
rco0=rco(t==0);
ppsi0=ppsi(t==0);
ccw=ppsi0>0;
cw=ppsi0<0;
[cwf, t] = circ_wwtest(rco0l(cwl), rco0(cw))
[ccwf, t] = circ_wwtest(rco0l(ccwl), rco0(ccw))
[cwp, t] = circ_wwtest(ppsi0l(cwl), ppsi0(cw))
[ccwp, t] = circ_wwtest(ppsi0l(cwl), ppsi0(cw))

lstats=zstats;
figure(3)
MotifFigs(gcf,1);
hist([[lstats.maxspt];[lstats.minspt]]',0.05:.1:1)
colormap gray
figure(4)
MotifFigs(gcf,1);
hist([[lstats.max_rast];[lstats.min_rast]]',0.05:.1:1)
colormap gray
[sp_z,sp_h]=ranksum([lstats.maxspt],[lstats.minspt])
[sp_h,sp_zk]=kstest2([lstats.maxspt],[lstats.minspt])
[ra_z,sp_h]=ranksum([lstats.max_rast],[lstats.min_rast])
[sp_h,ra_zk]=kstest2([lstats.max_rast],[lstats.min_rast])
rco=[lstats.rco];
ppsi=[lstats.psi];
t=[lstats.ts];
a1=AngularDifference(rco(t==0),rco(t==0.6))*180/pi;
a2=AngularDifference(ppsi(t==0),ppsi(t==0.6))*180/pi;
a1cw=a1(rco(t==0)<0);
a1ccw=a1(rco(t==0)>0);
a2cw=a2(ppsi(t==0)<0);
a2ccw=a2(ppsi(t==0)>0);

% sort NaN
a1cw=a1cw(~isnan(a1cw));
a1ccw=a1ccw(~isnan(a1ccw));
a2cw=a2cw(~isnan(a2cw));
a2ccw=a2ccw(~isnan(a2ccw));
a1=a1(~isnan(a1));
a2=a2(~isnan(a2));

figure(5),subplot(2,2,3)
[y,x]=AngHist(a1cw);y1=y/sum(y);
[y,x]=AngHist(a1ccw);y2=y/sum(y);
plot(x,y1,'k',x,y2,'k:')
subplot(2,2,4)
[y,x]=AngHist(a2cw);y1=y/sum(y);
[y,x]=AngHist(a2ccw);y2=y/sum(y);
plot(x,y1,'k',x,y2,'k:')

[fzzcw]=circ_medtest(a1cw*pi/180,0)
[fzzccw]=circ_medtest(a1ccw*pi/180,0)
[pzzcw]=circ_medtest(a2cw*pi/180,0)
[pzzccw]=circ_medtest(a2ccw*pi/180,0)
medians=[circ_median(a1cw'*pi/180) circ_median(a1ccw'*pi/180) ...
    circ_median(a2cw'*pi/180),circ_median(a2ccw'*pi/180)]*180/pi
% stuff to plot zz contours
xps=-160:20:180;
yps=0.05:.1:.95;n=3;
% subplot(1,2,1),contourf(xps,yps(n:end),df2n(n:end,:)),xlabel('fdir rel to nest')
% subplot(1,2,2),contourf(xps,yps(n:end),dpsi(n:end,:)),xlabel('psi')



% plot([lstats.maxspt],[lstats.minspt],'o')
% 
% mar=[lstats.max_rast];
% mir=[lstats.min_rast];
% hist(mar(mir<=0.2))



function[ra_s,relspeed,zzspeed,mpsi,ra_f,tz2,stats]=ZZSpeeds(ino,f)
% relspeed,ra_f2n
figure(f)
load(['processzigzags' ino '.mat'])

% the correct relative time is in 
% use this to get indices of times to use
tz2=[];
for i=1:length(fltsec)
    f=fltsec(i).fsec;
    if(isfield(f,'reltDang2'))
        tz2=[tz2 [f.reltDang2]];
    end
end

ss=find(diff(tz2)<=0)+1;
if(ss(1)~=1) ss=[1 ss]; end
ss=[ss length(tz2)+1];
% relspeed=allrelsp(iz2s);
relspeed=NaN*allrelspB;   
for i=1:length(ss)-1
    is=ss(i):ss(i+1)-1;
    izs=is;%iz2s(is);
    relspeed(is)=zzspeed(is)/prctile(zzspeed(is),90);
    
if (length(is)>1)   
    stats(i).rco =interp1(tz2(is),AngleWithoutFlip(ftonest(izs)),0:0.05:1);
    stats(i).ts = 0:0.05:1;
    stats(i).psi =interp1(tz2(is),AngleWithoutFlip(mpsi(izs)),0:0.05:1);

    [m,ind]=min(zzspeed(izs));
    stats(i).minsp=zzspeed(izs(ind));
    stats(i).minspt=tz2(is(ind));
    [m,ind]=max(zzspeed(izs));
    stats(i).maxsp=zzspeed(izs(ind));
    stats(i).maxspt=tz2(is(ind));
    
    [m,ind]=min(abs(ra_s(izs)));
    stats(i).min_ras=abs(ra_s(izs(ind)));
    stats(i).min_rast=tz2(is(ind));
    [m,ind]=max(abs(ra_s(izs)));
    stats(i).max_ras=abs(ra_s(izs(ind)));
    stats(i).max_rast=tz2(is(ind));
end
    
    %     relspeed(is)=relspeed(is)/prctile(zzspeed(is),90);
end

divi=-720:60:720;
divi=-30:60:540;
rspdiv=0:0.05:1;
tdiv=0:0.1:1;
tdiv=0:0.05:1;
% iz2s=1:length(ra_s);tz2=dang2s;%mpsi;
subplot(3,2,1)
[Db,xs,ys,xps,yps]=Density2D(abs(ra_s),tz2,divi,tdiv);
contourf(xps,yps,-Db+max(Db(:))),xlabel('rotational speed (body)')
subplot(3,2,2)
% [Dc,xs,ys,xps,yps]=Density2D(abs(ra_c),tz2,divi*1.5,tdiv);
% contourf(xps,yps,-Dc+max(Dc(:))),xlabel('d flt-dir/dt')
[Df2n,xs,ys,xps,yps]=Density2DAng(ftonest*180/pi,tz2,-190:20:190,tdiv);
contourf(xps,yps,-Df2n+max(Df2n(:))),xlabel('fdir rel to nest')
[Drs2,xs,ys,xps,yps]=Density2D(allrelspB,tz2,rspdiv,tdiv);
contourf(xps,yps,-Drs2+max(Drs2(:))),xlabel('speed')
subplot(3,2,3)
[Ds,xs,ys,xps,yps]=Density2D(zzspeed,tz2,0:10:80,tdiv);
[Drs,xs,ys,xps,yps]=Density2D(relspeed,tz2,rspdiv,tdiv);
contourf(xps,yps,-Drs+max(Drs(:))),xlabel('speed')
subplot(3,2,4),
[Dpsi,xs,ys,xps,yps]=Density2DAng(mpsi*180/pi,tz2,-190:20:190,tdiv);
contourf(xps,yps,-Dpsi+max(Dpsi(:))),xlabel('psi')
[dat,xp]=StatsOverX(tz2,abs(ra_s),tdiv);d1=[dat.med];
[dat,xp]=StatsOverX(tz2,abs(ra_f),tdiv);d2=[dat.med];
[dat,xp]=StatsOverX(tz2,abs(ra_c),tdiv);d3=[dat.med];
[dat,xp]=StatsOverX(tz2,abs(mpsi)*180/pi,tdiv);dc=[dat.med];
[dat,xp]=StatsOverX(tz2,zzspeed,tdiv);dsp=[dat.med];
subplot(3,1,3)
plot(xp,dsp/max(dsp),xp,d1/max(d1),'r:o',xp,d2/max(d2),'k--',...
    xp,d3/max(d3),'g-x',xp,dc/max(dc),'b:','LineWidth',1.5)% ,xp,drsp,'b:x',xp,df2n/max(df2n),'k:x',
axis tight,ylim([0 1]),ylabel('speeds (normalised to max)')
xlabel('speed (blue), dbody/dt (red o), dpsi/dt (black) dflight direction/dt (x) f dir rel to nest (blue dot)')
% tz2=relts;
ra_s=Db;
relspeed=Drs;
zzspeed=Drs2;
ra_f=Dpsi;
tz2=Df2n;


function[ra_s,ra_c,lspeed,dco,ra_f,ts,relspeed,ra_f2n]=LoopSpeeds
load loopstatstemp
eval('ppsi=psi;');
eval('c_os=cos;');
dco=AngularDifference(c_os,o2n)*180/pi;

ss=find(ts==0);ss=[ss length(ts)];relspeed=lspeed;
for i=1:length(ss)-1
    is=ss(i):ss(i+1)-1;
    relspeed(is)=relspeed(is)/prctile(lspeed(is),90);
    
    stats(i).rco =interp1(ts(is),AngleWithoutFlip(dco(is)*pi/180),0:0.05:1);
    stats(i).ts = 0:0.05:1;
    stats(i).psi =interp1(ts(is),AngleWithoutFlip(ppsi(is)),0:0.05:1);

    [m,ind]=min(lspeed(is));
    stats(i).minsp=lspeed(is(ind));
    stats(i).minspt=ts(is(ind));
    [m,ind]=max(lspeed(is));
    stats(i).maxsp=lspeed(is(ind));
    stats(i).maxspt=ts(is(ind));
    [m,ind]=min(abs(ra_s(is)));
    stats(i).min_ras=abs(ra_s(is(ind)));
    stats(i).min_rast=ts(is(ind));
    [m,ind]=max(abs(ra_s(is)));
    stats(i).max_ras=abs(ra_s(is(ind)));
    stats(i).max_rast=ts(is(ind));
%     relspeed(is)=relspeed(is)/max(lspeed(is));
end
divi=-720:60:720;
divi=-30:30:540;
divi=-30:30:630;
subplot(3,2,1)
[Db,xs,ys,xps,yps]=Density2D(abs(ra_s),ts,divi,0:0.025:1);
contourf(xps,yps,-Db+max(Db(:))),xlabel('rotational speed (body)')
subplot(3,2,2)
[Dc,xs,ys,xps,yps]=Density2D(abs(ra_c),ts,divi*1.5,0:0.025:1);
% [Dc,xs,ys,xps,yps]=Density2D(abs(ra_f2n),ts,divi*1.5,0:0.025:1);
contourf(xps,yps,-Dc+max(Dc(:))),xlabel('d flt-dir/dt')
subplot(3,2,3)
[Ds,xs,ys,xps,yps]=Density2D(lspeed,ts,0:5:80,0:0.025:1);
[Ds,xs,ys,xps,yps]=Density2D(relspeed,ts,0:0.025:1.1,0:0.025:1);
contourf(xps,yps,-Ds+max(Ds(:))),xlabel('speed')
subplot(3,2,4),
[Df2n,xs,ys,xps,yps]=Density2D((dco),ts,-180:20:180,0:0.025:1);
[Df2n,xs,ys,xps,yps]=Density2D(abs(dco),ts,-10:10:180,0:0.025:1);
contourf(xps,yps,-Df2n+max(Df2n(:))),xlabel('fdir rel to nest')
[dat,xp]=StatsOverX(ts,abs(ra_s));d1=[dat.med];
[dat,xp]=StatsOverX(ts,abs(ra_f));d2=[dat.med];
[dat,xp]=StatsOverX(ts,abs(ra_f2n));df2n=[dat.med];
[dat,xp]=StatsOverX(ts,abs(ra_c));d3=[dat.med];
[dat,xp]=StatsOverX(ts,abs(dco));dc=[dat.med];
[dat,xp]=StatsOverX(ts,lspeed);dsp=[dat.med];
[dat,xp]=StatsOverX(ts,relspeed);drsp=[dat.med];
subplot(3,1,3)
plot(xp,dsp/max(dsp),xp,drsp,'b:x',xp,d1/max(d1),'r:o',xp,d2/max(d2),'k--',xp,df2n/max(df2n),'k:x',...
    xp,d3/max(d3),'g-x',xp,dc/max(dc),'b:','LineWidth',1.5)
axis tight,ylim([0 1]),ylabel('speeds (normalised to max)')
xlabel('speed (blue), dbody/dt (red o), dpsi/dt (black) dflight direction/dt (x) f dir rel to nest (blue dot)')
ra_f=ppsi;
ra_f2n=stats;
num=[sum([loops.Picked]) length(loops)]

function[ra_s,ra_c,lspeed,dco,ra_f,ts]=LoopTimeData
load loopstatstemp
eval('ppsi=psi;');
eval('c_os=cos;');
subplot(4,1,1),
[dat,xp]=StatsOverX(loopt,looplen);dm=[dat.med];
errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm)
hold on,errorbar(xp,[dat.me],[dat.sd],'r--'),hold off
axis tight,ylim([0 max([dat.p75])])
title('loop lengths as a funciton of time of loop. Median (blue), mean (red)')

dx=CartDist(XPts);dmid=CartDist(midpts);
de1=CartDist(eptsMid(:,[1 2]));de2=CartDist(eptsAngc(:,[1 2]));
allt=[loops.t];allc=[];relt=[];
c=1;relloopt=loopt;
for i=1:length(loops) 
    allc=[allc;loops(i).cs];
    maxt(i)=loops(i).t(end);
    relt=[relt [loops(i).t]/maxt(i)];
    for j=1:length(loops(i).loop)
        if(loops(i).Picked(j))
            relloopt(c)=loopt(c)/maxt(i);
            c=c+1;
        end
    end
end;
dall=CartDist(allc);

subplot(4,1,3),
[dat,xp]=StatsOverX(loopt,dmid);dm=[dat.med];
errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm,'b--'),hold on
[dat,xp]=StatsOverX(loopt,dx);d1=[dat.med];
[dat,xp]=StatsOverX(loopt,de1);d2=[dat.med];
[dat,xp]=StatsOverX(loopt,de2);d3=[dat.med];
[dat,xp]=StatsOverX(allt,dall);d4=[dat.med];
plot(xp,d1,'r',xp,d2,'g:',xp,d3,'g:',xp,d4,'k. -')
hold off,axis tight,ylim([0 max([dat.p75])])
title('distance of start (red) mid (blue) ends (green) and all (black) over time')

subplot(4,1,4),
[dat,xp]=StatsOverX(relloopt,dmid);dm=[dat.med];
errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm,'b--'),hold on
[dat,xp]=StatsOverX(relloopt,dx);d1=[dat.med];
[dat,xp]=StatsOverX(relloopt,de1);d2=[dat.med];
[dat,xp]=StatsOverX(relloopt,de2);d3=[dat.med];
[dat,xp]=StatsOverX(relt,dall);d4=[dat.med];
plot(xp,d1,'r',xp,d2,'g:',xp,d3,'g:',xp,d4,'k. -')
hold off,axis tight,ylim([0 max([dat.p75])])
title('dist of start (red) mid (blue) ends (green) and all (black) over time')


subplot(4,1,2),
[dat,xp]=StatsOverX(dx,dmid);dm=[dat.med];
errorbar(xp,dm,dm-[dat.p25],[dat.p75]-dm,'b--'),hold on
[dat,xp]=StatsOverX(dx,de1);d1=[dat.med];
[dat,xp]=StatsOverX(dx,de1);d2=[dat.med];
plot(xp,d1,'r',[0 50],[0 50],'k--'),hold off,axis tight,ylim([0 max([dat.p75])])
title('distance of mids (blue) and ends(red) over start dists')


% function[st,s2]=allLoopdata
function[pc1,pc2]=allLoopdata
load loopstatstemp
eval('ppsi=psi;');
eval('c_os=cos;');
% subplot(3,2,1)
% [D,xs,ys,xps,yps]=Density2D(ppsi*180/pi,ts,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('psi')
% subplot(3,2,4)
% [D,xs,ys,xps,yps]=Density2D(dangcs*180/pi,ts,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to maj ax')
% subplot(3,2,3)
% [D,xs,ys,xps,yps]=Density2D(nors*180/pi,ts,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('nest on retina')
% subplot(3,2,2)
% [D,xs,ys,xps,yps]=Density2D(AngularDifference(c_os,o2n)*180/pi,ts,-180:10:180,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to nest')
% subplot(3,2,5)
% [D,xs,ys,xps,yps]=Density2D(c_os*180/pi,ts,0:10:360,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('flt dir')
% subplot(3,2,6)
% [D,xs,ys,xps,yps]=Density2D(sos*180/pi,ts,0:10:360,0:0.025:1);
% contourf(xps,yps,-D+max(D(:))),xlabel('body orientation')

o2lm=allLM(1).OToLM;
lmor=allLM(1).LMOnRetina;
subplot(2,2,1)
[D,xs,ys,xps,yps]=Density2D(ppsi*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:))),xlabel('psi')
subplot(2,2,2)
[D,xs,ys,xps,yps]=Density2D(AngularDifference(c_os,o2lm)*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to LM')
subplot(2,2,4)
[D,xs,ys,xps,yps]=Density2D(AngularDifference(c_os,o2n)*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:))),xlabel('fdir rel to nest')
subplot(2,2,3)
[D,xs,ys,xps,yps]=Density2D(lmor*180/pi,ts,-180:10:180,0:0.025:1);
contourf(xps,yps,-D+max(D(:))),xlabel('LM on retina')

pc1=round(100*[LoopProps(:,1)./LoopProps(:,3)]);
pc2=round(100*[LoopProps(:,2)./LoopProps(:,3)]);
st=[mean(pc1) std(pc1) median(pc1) iqr(pc1)]; 
s2=[mean(pc2) std(pc2) median(pc2) iqr(pc2)]; 
% boxplot([pc1 pc2])



function changedir(fn)
if(fn==1) cd ../2' east all'/
elseif(fn==2) cd ../'2 west'/
elseif(fn==3) cd ../'west 8'/
elseif(fn==4) cd ../'north 8'/
elseif(fn==5) cd ../'east 8'
elseif(fn==6) cd ../'south 8'
elseif(fn==7) cd ../../'bees 2008'/'1 north 2008 all'/
end

function AllData(inout)

rs=[];rsm=[];ra_s=[];ra_sm=[];ra_sn=[];ra_sl=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];ra_cn=[];ra_cl=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];ra_fn=[];ra_fl=[];ra_f2n=[];ra_s2n=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];
ts=[];meanrates=[];meanratesN=[];meanratesL=[];

nolook=[];nolooki=[];pcN=[];pcNind=[];pcL=[];
majax=[];a2nest=[];maxds=[];XPts=[];loopt=[];a2lm=[];looplen=[];
allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];allts=[];relts=[];allsp=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

allpsin=[];allpsi=[];

flist=(dir(['*' inout '*All.mat']));
for j=1:length(flist)
    fn=flist(j).name
    load(fn);
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end
    fdir=AngularDifference(Cent_Os,sOr);
    [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);
    %
    allsos=[allsos sOr];
    allcos=[allcos Cent_Os'];
    allo2n=[allo2n OToNest'];
    allpsi=[allpsi fdir'];
    allpsin=[allpsin fdir(in)'];
    allcs=[allcs;Cents];
    allts=[allts t];
    relts=[relts (t-t(1))/(t(end)-t(1))];
    allsp=[allsp Speeds'];
    
    as=AngleWithoutFlip(sOr)*180/pi;
    ac=AngleWithoutFlip(Cent_Os)*180/pi;
    af=AngleWithoutFlip(fdir)*180/pi;
    af2n=AngleWithoutFlip(AngularDifference(Cent_Os,OToNest))*180/pi;
    as2n=AngleWithoutFlip(AngularDifference(sOr,OToNest))*180/pi;
    
    asm=TimeSmooth(as,t,0.1);
    acm=TimeSmooth(ac,t,0.1);
    afm=TimeSmooth(af,t,0.1);
    
    smm=5;
    gr_as=MyGradient(as,t);
    gr_ac=MyGradient(ac,t);
    gr_af=MyGradient(af,t);
    gr_af2n=MyGradient(af2n,t);
    gr_as2n=MyGradient(as2n,t);
    ra_s=[ra_s gr_as];
    ra_c=[ra_c gr_ac];
    ra_f=[ra_f gr_af];
    ra_f2n=[ra_f2n gr_af2n];
    ra_s2n=[ra_s2n gr_as2n];
    
    ra_sn=[ra_sn gr_as(in)];
    ra_sl=[ra_sl gr_as(ils(1).is)];
    ra_cn=[ra_cn gr_ac(in)];
    ra_cl=[ra_cl gr_ac(ils(1).is)];
    ra_fn=[ra_fn gr_af(in)];
    ra_fl=[ra_fl gr_af(ils(1).is)];
    
    meanrates=[meanrates; ...
        mean(abs(gr_as)) mean(abs(gr_ac)) mean(abs(gr_af)) ...
        median(abs(gr_as)) median(abs(gr_ac)) median(abs(gr_af)) ...
        mean(abs(gr_af2n)) mean(abs(gr_as2n))];
    
    meanratesL=[meanratesL; ...
        mean(abs(gr_as(ils(1).is))) mean(abs(gr_ac(ils(1).is))) mean(abs(gr_af(ils(1).is))) ...
        median(abs(gr_as(ils(1).is))) median(abs(gr_ac(ils(1).is))) median(abs(gr_af(ils(1).is))) ...
        mean(abs(gr_af2n(ils(1).is))) mean(abs(gr_as2n(ils(1).is)))];
    
    meanratesN=[meanratesN; ...
        mean(abs(gr_as(in))) mean(abs(gr_ac(in))) mean(abs(gr_af(in))) ...
        median(abs(gr_as(in))) median(abs(gr_ac(in))) median(abs(gr_af(in))) ...
        mean(abs(gr_af2n(in))) mean(abs(gr_as2n(in)))];
    
    ra_sm=[ra_sm medfilt1(gr_as,smm)];
    ra_cm=[ra_cm medfilt1(gr_ac,smm)];
    ra_fm=[ra_fm medfilt1(gr_af,smm)];
end
ff=['allrates' inout '.mat'];
save(ff)


function AllRates(inout,dirs,outstr,TimeLims)
if(nargin<4) TimeLims=[-1 1e9]; end;
dwork
cd bees\bees07\WholeFlightStats\

rs=[];rsm=[];ra_s=[];ra_sm=[];ra_sn=[];ra_sl=[];
c_os=[];csm=[];ra_c=[];ra_cm=[];ra_cn=[];ra_cl=[];
fs=[];fsm=[];ra_f=[];ra_fm=[];ra_fn=[];ra_fl=[];ra_f2n=[];ra_s2n=[];
psi=[]; relfs=[];nors=[]; daxis=[]; dloop=[];
maxpsi=[];sos=[];cos=[];psinest=[];
ts=[];meanrates=[];meanratesN=[];meanratesL=[];

nolook=[];nolooki=[];pcN=[];pcNind=[];pcL=[];
majax=[];a2nest=[];maxds=[];XPts=[];loopt=[];a2lm=[];fltlen=[];
allcs=[];o2n=[];o2lm=[];allo2n=[];allsos=[];allcos=[];allts=[];allsp=[];relts=[];
allLM.LMOnRetina=[]; allLM(1).OToLM=[]; allLM(1).psilm=[]; allLM(1).allpsilm=[];

allpsin=[];allpsi=[];ms2n=[];mf2n=[];mepsi=[];
psi0=[]; ins=[]; psi0n=[];pc=[];
ipsi0s=[];ilk0s=[];if0s=[];is2n0s=[];ilkpsi0s=[];
cCorr=[];

for i=1:4
    il(i).is=[];
    il(i).pc=[];
end;
origdir=cd;
% for i=2:6
for i=dirs
    changedir(i);
    flist=(dir(['*' inout '*All.mat']));
    for j=1:length(flist)
        fn=flist(j).name;
        clear sOr Cent_Os
        load(fn);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        tlen=t(end)-t(1);
        if((tlen>=TimeLims(1))&(tlen<TimeLims(2)))
            numfr=length(t);
            disp([fn '; length: ' num2str(tlen)])
            fdir=AngularDifference(Cent_Os,sOr);
            ps0=find(abs(fdir)<(pi/18));
            psi0=[psi0 ps0'];
            [meanC,meanT,meanTind,len,in,ils,sn,en]=LookingPtsExpt2(fn,10);
            ins=[ins in'];
            pn=intersect(ps0',in);psi0n=[psi0n pn];
            pc=[pc;100*[length(ps0) length(in) length(pn)]/numfr ...
                100*length(pn)/length(ps0) 100*length(pn)/length(in) numfr];
            for nl=1:length(ils)
                il(nl).is=[il(nl).is;ils(nl).is];
                pl=length(intersect(ps0',ils(nl).is));
                il(nl).pc=[il(nl).pc; length(ils(nl).is)*100/numfr pl*100/length(ps0) pl*100/length(ils(nl).is)];
            end;

            %
            allsos=[allsos sOr];
            allcos=[allcos Cent_Os'];
            allo2n=[allo2n OToNest'];
            allpsi=[allpsi fdir'];
            allpsin=[allpsin fdir(in)'];
            allcs=[allcs;Cents];
            allts=[allts t];
            fltlen=[fltlen;t(end) (t(end)-t(1))];
            relts=[relts (t-t(1))/(t(end)-t(1))];
            allsp=[allsp Speeds'];

            as=AngleWithoutFlip(sOr)*180/pi;
            ac=AngleWithoutFlip(Cent_Os)*180/pi;
            af=AngleWithoutFlip(fdir)*180/pi;
            f2n=AngularDifference(Cent_Os,OToNest);
            s2n=AngularDifference(sOr,OToNest);
            af2n=AngleWithoutFlip(f2n)*180/pi;
            as2n=AngleWithoutFlip(s2n)*180/pi;

            s0=find(abs(s2n)<(pi/18));
            f0=find(abs(f2n)<(pi/18));
            ps0=find(abs(fdir)<(pi/18));
        
            [m,l]=MeanAngle(f2n);
            [m0,l0]=MeanAngle(f2n(ps0));
            [m1,l1]=MeanAngle(f2n(s0));
            mf2n=[mf2n; m l m0,l0 m1 l1];
            [m,l]=MeanAngle(s2n);
            [m0,l0]=MeanAngle(s2n(ps0));
            [m1,l1]=MeanAngle(s2n(f0));
            ms2n=[ms2n; m l m0,l0 m1 l1];
            [m,l]=MeanAngle(fdir);
            [m0,l0]=MeanAngle(fdir(s0));
            [m1,l1]=MeanAngle(fdir(f0));
            mepsi=[mepsi; m l m0,l0 m1 l1];

            asm=TimeSmooth(as,t,0.1);
            acm=TimeSmooth(ac,t,0.1);
            afm=TimeSmooth(af,t,0.1);

            smm=5;
            gr_as=MyGradient(as,t);
            gr_ac=MyGradient(ac,t);
            gr_af=MyGradient(af,t);
            gr_af2n=MyGradient(af2n,t);
            gr_as2n=MyGradient(as2n,t);
            ra_s=[ra_s gr_as];
            ra_c=[ra_c gr_ac];
            ra_f=[ra_f gr_af];
            ra_f2n=[ra_f2n gr_af2n];
            ra_s2n=[ra_s2n gr_as2n];

            ra_sn=[ra_sn gr_as(in)];
            ra_sl=[ra_sl gr_as(ils(1).is)];
            ra_cn=[ra_cn gr_ac(in)];
            ra_cl=[ra_cl gr_ac(ils(1).is)];
            ra_fn=[ra_fn gr_af(in)];
            ra_fl=[ra_fl gr_af(ils(1).is)];

            meanrates=[meanrates; ...
                mean(abs(gr_as)) mean(abs(gr_ac)) mean(abs(gr_af)) ...
                median(abs(gr_as)) median(abs(gr_ac)) median(abs(gr_af)) ...
                mean(abs(gr_af2n)) mean(abs(gr_as2n)) ...
                prctile(abs(gr_as),[25 75]) prctile(abs(gr_ac),[25 75]) ...
                prctile(abs(gr_af),[25 75])];

            meanratesL=[meanratesL; ...
                mean(abs(gr_as(ils(1).is))) mean(abs(gr_ac(ils(1).is))) mean(abs(gr_af(ils(1).is))) ...
                median(abs(gr_as(ils(1).is))) median(abs(gr_ac(ils(1).is))) median(abs(gr_af(ils(1).is))) ...
                mean(abs(gr_af2n(ils(1).is))) mean(abs(gr_as2n(ils(1).is)))];

            meanratesN=[meanratesN; ...
                mean(abs(gr_as(in))) mean(abs(gr_ac(in))) mean(abs(gr_af(in))) ...
                median(abs(gr_as(in))) median(abs(gr_ac(in))) median(abs(gr_af(in))) ...
                mean(abs(gr_af2n(in))) mean(abs(gr_as2n(in)))];

            ra_sm=[ra_sm medfilt1(gr_as,smm)];
            ra_cm=[ra_cm medfilt1(gr_ac,smm)];
            ra_fm=[ra_fm medfilt1(gr_af,smm)];

%             % correlation stuff
%             [c1,c2,c3]=GetCorrelation(f2n,s2n,fdir,t);
        end
    end
end
allds=CartDist(allcs);
cd(origdir);
% ff=['allratesNoEast' inout '.mat'];
ff=['allrates' inout outstr '.mat'];
save(ff)
plotrates(ff,'all')

% save allratesNoEastin
% plotrates('allratesNoEastin')

function[c1,c2,c3]=GetCorrelation(f2n,s2n,fdir,t)
[c1 p1] = circ_corrcc(f2n,s2n);
[c2 p2] = circ_corrcc(f2n,fdir);
[c3 p3] = circ_corrcc(s2n,fdir);

af=AngleWithoutFlip(f2n);
as=AngleWithoutFlip(s2n');
ap=AngleWithoutFlip(fdir);
C=xcorr([af as ap]);

seclen=0.5;
mt=length(t);
sp=1;ep=0;
while(ep<mt);
    ep=GetTimes(sp(1)+seclen);
end



function[st]= plotrates(fn,tstr,ra_s,ra_c,ra_f,meanrates)
if(nargin<3) 
    load(fn);
end
subplot(3,1,1);%figure(1)
[y1,x1]=hist(abs(ra_s),10:20:2000);
[y2,x2]=hist(abs(ra_c),10:20:2000);
[y3,x3]=hist(abs(ra_f),10:20:2000);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
axis tight,xlabel('rates'),title(tstr)
% subplot(2,2,2);%figure(2)
% [y1,x1]=hist(abs(ra_sm),0:20:2000);
% [y2,x2]=hist(abs(ra_cm),0:20:2000);
% [y3,x3]=hist(abs(ra_fm),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('smoothed rates')
% subplot(3,1,2);%figure(3)
% [y1,x1]=hist(abs(ra_sn),0:20:2000);
% [y2,x2]=hist(abs(ra_cn),0:20:2000);
% [y3,x3]=hist(abs(ra_fn),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('nest looking rates')
% subplot(3,1,3);%figure(4)
% [y1,x1]=hist(abs(ra_sl),0:20:2000);
% [y2,x2]=hist(abs(ra_cl),0:20:2000);
% [y3,x3]=hist(abs(ra_fl),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('LM looking rates')
subplot(3,1,2);%figure(5)
[y1,x1]=hist(meanrates(:,1),0:20:1000);
[y2,x2]=hist(meanrates(:,2),0:20:1000);
[y3,x3]=hist(meanrates(:,3),0:20:1000);
[y4,x1]=hist(meanrates(:,4),0:20:1000);
[y5,x2]=hist(meanrates(:,5),0:20:1000);
[y6,x3]=hist(meanrates(:,6),0:20:1000);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
xlabel('mean rates')
plot(x3,y4/sum(y4),'b:',x3,y5/sum(y5),'r:',x3,y6/sum(y6),'k--x')
xlabel('median rates (degrees/s)'),axis tight
subplot(3,1,3);%figure(6)
% plot(x1,y4/sum(y4),x2,y5/sum(y5),'r:',x3,y6/sum(y6),'k--x')
% xlabel('median rates')
m1=meanrates(:,2)./meanrates(:,1);
% m2=meanrates(:,3)./meanrates(:,1);
m2=meanrates(:,5)./meanrates(:,4);
m3=meanrates(:,6)./meanrates(:,4);
[y1,x1]=hist(m1,0:0.2:5);
[y2,x2]=hist(m2,0:0.2:5);
[y3,x3]=hist(m3,0:0.2:5);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:')
plot(x2,y2/sum(y2),x3,y3/sum(y3),'k--x')
xlabel('ratio median rates'),axis tight
st=[mean([m1 m2]) std([m1 m2])];% size(m1,1)];

function[st]= plotratesNest(fn,tstr)
load(fn)
subplot(3,1,1);%figure(1)
[y1,x1]=hist(abs(ra_s2n),0:20:2000);
[y2,x2]=hist(abs(ra_c),0:20:2000);
[y3,x3]=hist(abs(ra_f2n),0:20:2000);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
xlabel('rates'),title(tstr)
% subplot(2,2,2);%figure(2)
% [y1,x1]=hist(abs(ra_sm),0:20:2000);
% [y2,x2]=hist(abs(ra_cm),0:20:2000);
% [y3,x3]=hist(abs(ra_fm),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('smoothed rates')
% subplot(3,1,2);%figure(3)
% [y1,x1]=hist(abs(ra_sn),0:20:2000);
% [y2,x2]=hist(abs(ra_cn),0:20:2000);
% [y3,x3]=hist(abs(ra_fn),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('nest looking rates')
% subplot(3,1,3);%figure(4)
% [y1,x1]=hist(abs(ra_sl),0:20:2000);
% [y2,x2]=hist(abs(ra_cl),0:20:2000);
% [y3,x3]=hist(abs(ra_fl),0:20:2000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('LM looking rates')
subplot(3,1,2);%figure(5)
[y1,x1]=hist(meanrates(:,5),0:20:1000);
[y2,x2]=hist(meanrates(:,5),0:20:1000);
[y3,x3]=hist(meanrates(:,6),0:20:1000);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
xlabel('mean rates')
subplot(3,1,3);%figure(6)
% [y1,x1]=hist(meanrates(:,4),0:20:1000);
% [y2,x2]=hist(meanrates(:,5),0:20:1000);
% [y3,x3]=hist(meanrates(:,6),0:20:1000);
% plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:',x3,y3/sum(y3),'k--x')
% xlabel('median rates')
m1=meanrates(:,5)./meanrates(:,6);
m2=meanrates(:,5)./meanrates(:,1);
[y1,x1]=hist(m1,0:0.2:4);
[y2,x2]=hist(m2,0:0.2:4);
plot(x1,y1/sum(y1),x2,y2/sum(y2),'r:')
xlabel('ratio rates')
st=[mean([m1 m2]) std([m1 m2])];% size(m1,1)];



function[loops]=LoopAngles(cs,inds,co,ts,cmpdir,l1)
loops=[];

is=1:size(cs,1);
if(isempty(is)) return; end;
smlo=1;
smhi=2;
for i=1:(length(is)-1)
    js=(i+3):size(cs,1)-1;%GetTimes(t(1:end-1),t1+tlim);
    for j=js
        if(isCross(cs(is(i):is(i)+1,:),cs(j:j+1,:)))
            if(l1) ils=is(i):j+1;
            else
                i2s=size(cs,1):-1:1;
                cs=cs(i2s,:);
                ils=i2s(j+1):i2s(is(i));
            end
            len=length(ils);
            len2=floor(0.5*len);
            loops.is=inds(ils);
            loops.cs=cs(ils,:);
            loops.co=co(ils);
            loops.ts=ts(ils);
            loops.ds=CartDist(cs(ils,:),cs(ils(1),:));
            loops.len=max(loops.ds);
            loops.t=ts(ils(end))-ts(ils(1));
            loops.xp=GetXPt(ils(1),ils(end),cs);
            
            loops.angin=co(ils(1));
            loops.angout=co(ils(end-1));
            
            st=max(is(1),ils(1)-smlo);
            en=ils(1)+min(smhi,len2);
            loops.angsin=co(st:en);
            
            en=min(length(is),len-1+smlo);
            st=len-1-min(smhi,len2);
            loops.angsout=co(st:en);
            
            loops.angdiff=AngularDifference(loops.angout+pi,loops.angin);
            loops.xangle=MeanAngle([loops.angout+pi loops.angin]);
            if(loops.angdiff<0) loops.hand=-1;
            else loops.hand=1;
            end
            
            vs=cs(ils,:) - ones(length(ils),1)*loops.xp;
            [area,axes,angles,ellip] = ellipse(cs(ils,1),cs(ils,2),[],0.8535);
            [gx,gy]=pol2cart(angles(1),1);
            dds=vs*[gx;gy]; dds([1 end])=0;
            loops.dds=dds;
            [maxi,maxind]=max(abs(dds));
            if(dds(maxind)<0) angles(1)=mod(angles(1)-pi,2*pi);end
            [px,py]=pol2cart(angles(1),maxi);
            
            %             dloop=[dloop [abs(dvs)/max(dvs)]'];
            %             daxis=[daxis [abs(dds)/maxi]'];
            
            loops.ep=loops.xp+[px py];
            loops.ept=ts(ils(maxind));
            loops.len2=maxi;
            loops.ang=mod(angles(1)-cmpdir,2*pi);
            
            loops.cp=mean(cs(ils,:),1);
            mpv=loops.cp-loops.xp;
            loops.cpang=mod(cart2pol(mpv(1),mpv(2))-cmpdir,2*pi);
            loops.a2nest=mod(cart2pol(loops.xp(1),loops.xp(2))-cmpdir,2*pi);
            %             a2lm=[a2lm
            %             mod(cart2pol(loops(i).LM(1,1)-xp(1),loops(i).LM(1,2)-xp(2))-loops(i).cd,2*pi)];
            if(0)
                [tmpx,tmpy]=pol2cart(loops.xangle+cmpdir,loops.len);
                lxs=[loops.xp;loops.xp+[tmpx,tmpy]];
                plot(cs(:,1),cs(:,2),'r--',loops.cs(:,1),loops.cs(:,2),'k- .');hold on;
                plot(lxs(:,1),lxs(:,2),loops.xp(1),loops.xp(2),'bs',...
                    loops.cp(1),loops.cp(2),'rx',loops.ep(1),loops.ep(2),'bo')
                title(['Hand ' int2str(loops.hand)])
                CompassAndLine('k',1); axis equal; hold off
                drawnow;
            end
            return;
        end
    end
end


function[cr]=isCross(l1,l2)

x1=l1(1,1); y1=l1(1,2);
x2=l1(2,1); y2=l1(2,2);
x3=l2(1,1); y3=l2(1,2);
x4=l2(2,1); y4=l2(2,2);

[x,y]=IntersectionPoint(x1,x2,x3,x4,y1,y2,y3,y4);

cr=0;
if((x>=min(x1,x2))&&(x<=max(x1,x2)))
    if((y>=min(y1,y2))&&(y<=max(y1,y2)))
        if((x>=min(x3,x4))&&(x<=max(x3,x4)))
            if((y>=min(y3,y4))&&(y<=max(y3,y4))) cr=1; end
        end
    end
end


function[pcN,pcL,pcNind,nolook,nolooki]= LookPts(t,loop,cs,in,ils,inds,pic,LM,LMWid)

nL=length(loop)
% divide arcs into10
narc=10;
nls=zeros(nL,2*narc);
nlind=zeros(nL,2*narc);
nt_is=zeros(nL,2*narc);
nolook=[];nolooki=[];pcN=[];pcNind=[];
for i=1:length(ils)
    pcL(i).nolook=[];pcL(i).nolooki=[];pcL(i).pc=[];pcL(i).pci=[];
end
for k=1:nL
    if(pic(k))
        % time based loop
        is=loop(k).is;
        tr=[t([is(1) is(end)])];
        tl=tr(2)-tr(1);
        t_is=GetTimes(t,tr);
        lks=intersect(t_is,in);
        if(~isempty(lks)) pcN=[pcN (t(lks)-tr(1))/tl];
        else nolook=[nolook; k tr(1) tl];
        end;
        lks=intersect(t_is,inds);
        if(~isempty(lks)) pcNind=[pcNind (t(lks)-tr(1))/tl];
        else nolooki=[nolooki; k tr(1) tl];
        end;
        for i=1:length(ils)
            lks=intersect(t_is,ils(i).is);
            if(~isempty(lks)) pcL(i).pc=[pcL(i).pc (t(lks)-tr(1))/tl];
            else pcL(i).nolook=[pcL(i).nolook k];
            end;
            lks=intersect(t_is,ils(i).meanTind);
            if(~isempty(lks)) pcL(i).pci=[pcL(i).pci (t(lks)-tr(1))/tl];
            else pcL(i).nolooki=[pcL(i).nolooki k];
            end;
        end
        
        ds=CartDist(cs(is,:),cs(is(1),:));
        figure(1),plot(t(is),ds);
        lks=intersect(t_is,in);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(t(lks),d2,'r.');  hold off
        end
        lks=intersect(t_is,ils(1).is);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(t(lks),d2,'gs');  hold off
        end
        title(num2str(tr))
        
        figure(2),plot(cs(is,1),cs(is,2));
        lks=intersect(t_is,in);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(cs(lks,1),cs(lks,2),'r.');  hold off
        end
        lks=intersect(t_is,ils(1).is);
        if(~isempty(lks))
            hold on;d2=CartDist(cs(lks,:),cs(is(1),:));
            plot(cs(lks,1),cs(lks,2),'gs');  hold off
        end
        hold on; PlotNestAndLMs(LM,LMWid,[0 0],0);
        
        
        hold off
        
        axis equal
        title(num2str(tr))
        
        %     tr=[mi2ma(i,1) mi2ma(i,4)];
        %     ts =(tr(2)-tr(1))/narc;
        %     for j=1:narc
        %         t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
        %         lks=intersect(t_is,ils);
        %         nt_is(k,j)=nt_is(k,j)+length(t_is);
        %         nls(k,j)=nls(k,j)+length(lks);
        %         lks=intersect(t_is,inds);
        %         nlind(k,j)=nlind(k,j)+length(lks);
        %     end
        %     tr=[mi2ma(i,4) mi2ma(i+1,1)];
        %     ts =(tr(2)-tr(1))/narc;
        %     for j=1:narc
        %         t_is=GetTimes(t,[tr(1)+(j-1)*ts tr(1)+j*ts]);
        %         nt_is(k,j+narc)=nt_is(k,j+narc)+length(t_is);
        %         lks=intersect(t_is,ils);
        %         nls(k,j+narc)=nls(k,j+narc)+length(lks);
        %         lks=intersect(t_is,inds);
        %         nlind(k,j+narc)=nlind(k,j+narc)+length(lks);
        %     end
    end
end
% keyboard


function[X]=GetXPt(i1,i2,c)
[x,y]=IntersectionPoint(c(i1,1),c(i1+1,1),c(i2,1),c(i2-1,1),...
    c(i1,2),c(i1+1,2),c(i2,2),c(i2-1,2));
X=[x y];