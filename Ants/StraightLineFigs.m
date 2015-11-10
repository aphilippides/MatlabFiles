function StraightLineFigs
% for i=1:length(s)
%     clear t Cents
% load(s(i).name);
% el=length(t);
% sl=round(el/2);
% l=min(sl+100,el);
% subplot(1,2,1)
% plot(Cents(sl:l,2),Cents(sl:l, 1))
% subplot(1,2,2)
% plot(t(sl+1:l),diff(Cents(sl:l, :)))
% % plot(sOr(1:l))
% title([int2str(i) ' : ' s(i).name])
% end

Plot_Straight2008VsOther
keyboard
allang3=[];x3=[];x3i=[];
allang=[];x=[];xi=[];
sfs=[];sfsi=[];


% load straight_1north08_outData
% [ang3,ang,sf,od]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
% x3=[x3;AngHist(ang3*180/pi)]; 
% x=[x;hist(ang*180/pi,0:10:180)];

dwork;
cd Bees\bees07\'2 east all'\
load straight_2east_outData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'Out')
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=od;
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load straight_2westoutData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'Out')
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load straight_out_north8_2007Data
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'Out')
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load straight_west8_outData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'Out')
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load straight_east8_outData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'Out')
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

x(:,1)=x(:,1)+x(:,19);
x=x(:,1:18);
xb=x3./(sum(x3,2)*ones(1,36));
xc=x./(sum(x,2)*ones(1,18));
figure(4)
plot(-170:10:180,sum(x3)./sum(sum(x3)),'r',-170:10:180,sum(xb)./sum(sum(xb)))
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
figure(5)
plot(0:10:170,sum(x)./max(sum(x)),'r',0:10:170,sum(xc)./max(sum(xc)))
axis tight;ylim([0 1])
% cd ../../'bees 2008'/'1 north 2008 all'/

% ins
% load straight_1north_inData
% [ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
% allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];odat=[odat;od];
% x3i=[x3i;AngHist(ang3*180/pi)]; 
% xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../2' east all'/
load straight_2east_inData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];odati=od;
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load straight_2west_inData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];odati=[odati;od];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load straight_in_north8_2007Data
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];odati=[odati;od];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load straight_west8_inData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];odati=[odati;od];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load straight_east8_inData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];odati=[odati;od];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];


% 
xi(:,1)=xi(:,1)+xi(:,19);
xi=xi(:,1:18);
xbi=x3i./(sum(x3i,2)*ones(1,36));
xci=xi./(sum(xi,2)*ones(1,18));
figure(6)
% plot(-170:10:180,sum(x3i)./max(sum(x3i)),'r',-170:10:180,sum(xbi)./max(sum(xbi)))
plot(-170:10:180,sum(x3i)./sum(sum(x3i)),'r',-170:10:180,sum(xbi)./sum(sum(xbi)))
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
figure(7)
plot(0:10:170,sum(xi)./max(sum(xi)),'r',0:10:170,sum(xci)./max(sum(xci)))
axis tight;ylim([0 1])
% cd ../../'bees 2008'/'1 north 2008 all'/

is=[35 36 1:36 1];the=-190:10:190;
% Plot the angles of the straight lines where the data is normalised before
% adding together ie each config contributes equally indepdt of # lines
figure(9)
a=sum(xb)./sum(sum(xb));b=sum(xbi)./sum(sum(xbi));
plot(the,a(is),the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

% Plot the angles of the straight lines where the data is not normalised 
% ie each config contributes unequally depdt of # lines: this seems best
figure(10)
% subplot(2,1,1)
b=sum(x3)./sum(x3(:));b=sum(x3i)./sum(x3i(:));
% a=a+b;b=a;
plot(the,a(is),'k',the,b(is),'k:')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

% Plot the data from 2008
cd ../'bees 2008'/'1 north 2008 all'/
load straight_1north08_outData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'out')
Ex_x3=AngHist(ang3*180/pi);
load straight_1north_inData
[ang3,ang,sf,od]=ProcessFlightSections(fltsec,0,'In')
Ex_x3i=AngHist(ang3*180/pi);
figure(15)
MotifFigs(gcf)% subplot(2,1,2)
a=Ex_x3./sum(Ex_x3);b=Ex_x3i./sum(Ex_x3i);
% a=a+b;b=a;
plot(the,a(is),'k',the,b(is),'k:')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})



% Plot the angles of the straight ins and outs combined
% data is not normalised (top) normalised bottom
% ie each config contributes unequally depdt of # lines: this seems best
figure(12)
alld=[x3;x3i];
c=sum(alld)/sum(alld(:)); 
alldnorm=alld./(sum(alld,2)*ones(1,36));
d=sum(alldnorm)/sum(alldnorm(:));
subplot(2,1,1)
plot(the,c(is),'k',the,d(is),'k:',the,(a(is)+b(is))*0.5,'k:*')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})


% certain configs only
confs=[1 2]; alld=[x3(confs,:);x3i(confs,:)];
subplot(2,1,2)
c=sum(alld)/sum(alld(:)); 
alldnorm=alld./(sum(alld,2)*ones(1,36));
d=sum(alldnorm)/sum(alldnorm(:));
plot(the,c(is),'k',the,d(is),'k:')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})


% correlations betwen straught lines in outs and ins
is=[1:36]
for i=1:36
    ks=is([i:36 1:(i-1)]);
    [cc(i)]=xcorr(a,b(ks),0);
end
js=[19:36 1:18];
tp=[-180:10:170];%=[0:10:350];
plot(tp,cc(js));

is=[35 36 1:36 1];the=-190:10:190;
strs={'2 east';'2 west';'north 8';'west 8';'east 8';'1 North 2008'};
x3=[x3;Ex_x3];
x3i=[x3i;Ex_x3i];

n=6;
for i=1:n
    a=x3(i,:)./sum(x3(i,:));b=x3i(i,:)./sum(x3i(i,:));
    subplot(n,1,i)
    plot(the,a(is),'k',the,b(is),'k:')
    %     subplot(5,2,2*i-1),plot(the,a(is))
    if(i==n) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
    else SetXTicks(gca,0,[],[]);
    end
    axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),
    xlabel([char(strs(i)) '; n=' int2str(sum(x3(i,:))) ' (out), ' int2str(sum(x3i(i,:))) ' (in)']),
    % xlabel([char(strs(i)) '; n=' int2str(sum(x3(i,:))) ' (out)']),
    Setbox,%ylim([0 1])
    %     subplot(5,2,2*i),plot(the,b(is))
    % if(i==5) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
    % else SetXTicks(gca,0,[],[]);
    % end
    % axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),
    % xlabel([char(strs(i)) '; n=' int2str(sum(x3i(i,:))) ' (in)']),
    %     Setbox,%ylim([0 1]),

    [hts(i,:),peaks(i,:)]=GetPeaks(x3(i,:),[1:9:37]);
    [htsi(i,:),peaksi(i,:)]=GetPeaks(x3i(i,:),[1:9:37]);
    hold on
    plot(the(peaks(i,:)+2),hts(i,:)./sum(x3(i,:)),'o',...
        the(peaksi(i,:)+2),htsi(i,:)./sum(x3i(i,:)),'rd')
    hold off
end


figure(11)
for i=1:5
    subplot(5,1,i)
%     plot(the,odat(i).prn(is),the,odati(i).prn(is),'r:')
    plot(thet,odat(i).prl(:,1),thet,odati(i).prl(:,1),'r:')
if(i==5) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
else SetXTicks(gca,0,[],[]);
end
xlabel([char(strs(i))])% '; n=' int2str(sum(x3(i,:))) ' (out), ' int2str(sum(x3i(i,:))) ' (in)']),
axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),Setbox,%ylim([0 1])
end

figure(13)
for i=1:2
    subplot(2,1,i)
%     plot(the,odat(i).prn(is),the,odati(i).prn(is),'r:')
    plot(thet,odat(i).prl(:,1),thet,odati(i).prl(:,1),'r:')
if(i==2) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
else SetXTicks(gca,0,[],[]);
end
xlabel([char(strs(i))])% '; n=' int2str(sum(x3(i,:))) ' (out), ' int2str(sum(x3i(i,:))) ' (in)']),
axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),Setbox,%ylim([0 1])
end

p_thr=0.1745;
for i=1:36
    a=[]; for j=1:5 a=[a abs([sfs(j,i).nor])']; end;
    a=abs(a)';prn(i)=round(100*length(find(a<p_thr))/length(a));
    a=[]; for j=1:5 a=[a abs([sfsi(j,i).nor])']; end;
    prni(i)=round(100*length(find(a<p_thr))/length(a));

    a=[]; for j=1:5 a=[a abs([sfs(j,i).lor(1).lor])']; end;
    b=[]; for j=1:2 b=[b abs([sfs(j,i).lor(2).lor])']; end;
    prl(i,1)=round(100*length(find(a<p_thr))/length(a));
    prl(i,2)=round(100*length(find(b<p_thr))/length(b));

    a=[]; for j=1:5 oda=[a abs([sfsi(j,i).lor(1).lor])']; end;
    b=[]; for j=1:2 b=[b abs([sfsi(j,i).lor(2).lor])']; end;
    prli(i,1)=round(100*length(find(a<p_thr))/length(a));
    prli(i,2)=round(100*length(find(b<p_thr))/length(b));

    nf(i)=sum([sfs(:,i).numflt]);
    nfi(i)=sum([sfsi(:,i).numflt]);
    nf2(i)=sum([sfs([1 2],i).numflt]);
    nfi2(i)=sum([sfsi([1 2],i).numflt]);
end
prn(find(nf==0))=0;prl(find(nf==0),1)=0;
prni(find(nfi==0))=0;prli(find(nfi==0),1)=0;
prli(find(nfi2==0),2)=0;prl(find(nf2==0),2)=0;
plot(thet,prn,thet,prni,'r:')

keyboard
save ../tmpscriptbees_straightdata
pea=[2,13,21,32]  % this might not be right!!

thr=5;
for i=1:4
    ypsi(i,:)=AngHist([sfs(:,pea(i)).psi]*180/pi);
    ypsii(i,:)=AngHist([sfsi(:,pea(i)).psi]*180/pi);
    ypsi2(i,:)=AngHist([sfs(:,pea(i)).psi2]*180/pi);
    ypsi2i(i,:)=AngHist([sfsi(:,pea(i)).psi2]*180/pi);
    yso(i,:)=AngHist(so);
    ysoi(i,:)=AngHist(soi);
%     is=find(([sfs(:,pea(i)).rpsi]*180/pi)<thr);
%     mas=[sfs(:,pea(i)).psi];
%     ypsi3(i,:)=AngHist(mas(is)*180/pi)
%     is=find(([sfsi(:,pea(i)).rpsi]*180/pi)<thr);
%     mas=[sfsi(:,pea(i)).psi];
%     ypsi3i(i,:)=AngHist(mas(is)*180/pi)
%     
%     spsi(i,:)=hist([sfs(:,pea(i)).spsi],0.9:0.01:1);
%     rpsi(i,:)=hist([sfs(:,pea(i)).rpsi]*180/pi,5:10:95);
%     rpsi2(i,:)=hist([sfs(:,pea(i)).rpsi2]*180/pi),5:10:95;
% 
%     spsii(i,:)=hist([sfsi(:,pea(i)).spsi],0.9:0.01:1);
%     rpsii(i,:)=hist([sfsi(:,pea(i)).rpsi]*180/pi,5:10:95);
%     rpsi2i(i,:)=hist([sfsi(:,pea(i)).rpsi2]*180/pi),5:10:95;
    
end 
thet=-170:10:180;
pea=[2,13,21,32]
pea_ang=thet(pea);
peaL=(pea_ang-5)*pi/180;
peaH=(pea_ang+5)*pi/180;
for i=1:4
%     subplot(2,2,i),
    %     plot(-170:10:180,ypsi(i,:)/sum(ypsi(i,:)),-170:10:180,ypsi3(i,:)/sum(ypsi3(i,:)),'b:')%, ...
%      plot(-170:10:180,ypsii(i,:)/sum(ypsii(i,:)),'r',-170:10:180,ypsi3i(i,:)/sum(ypsi3i(i,:)),'r:')
%     plot(5:10:95,rpsi(i,:)/sum(rpsi(i,:)),5:10:95,rpsii(i,:)/sum(rpsii(i,:)),'r')
%     plot(5:10:95,rpsi2(i,:)/sum(rpsi2(i,:)),'b'),hold on,plot(5:10:95,rpsi2i(i,:)/sum(rpsi2i(i,:)),'r'),hold off
    inds=find((allang3>=peaL(i))&(allang3<peaH(i)));
actualpeaks(i)=MeanAngle(allang3(inds))*180/pi;
% ls(i)=length(inds);
end    

load tmpscriptbees_straightdata
for k=1:5
figure(k)
BodyOPics(k,sfs,sfsi)
end
figure(6)
BodyOPics([1:5],sfs,sfsi)

function BodyOPics(dists,sfs,sfsi,peaks)
thet=-170:10:180;
pea=[2,13,21,32]
thr=5;
is=[35 36 1:36 1];the=-190:10:190;
nf=zeros(1,length(pea));nfi=zeros(1,length(pea));
for i=1:4
so=[];soi=[];
    for j=dists
        so=[so [sfs(j,pea(i)).so]'*180/pi];
        soi=[soi [sfsi(j,pea(i)).so]'*180/pi];
        nf(i)=nf(i)+length(sfs(j,pea(i)).nf);
        nfi(i)=nfi(i)+length(sfsi(j,pea(i)).nf);
    end
    yso(i,:)=AngHist(so);
    ysoi(i,:)=AngHist(soi);
end
for i=1:4
    subplot(2,2,i),
    a=yso(i,:)/sum(yso(i,:));b=ysoi(i,:)/sum(ysoi(i,:));
    plot(the,a(is),the,b(is),'r:',[thet(pea(i)) thet(pea(i))],[0 max([a b])],'k--')%, ...
SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),
xlabel(['body orientation n=' int2str(nf(i)) ' (out), ' int2str(nfi(i)) ' (in)']),Setbox,%ylim([0 1]),
end

function Plot_Straight2008VsOther

load tmpscriptbees_straightdata.mat
a=Ex_x3./sum(Ex_x3);ai=Ex_x3i./sum(Ex_x3i);
i=3;b=x3(i,:)./sum(x3(i,:));bi=x3i(i,:)./sum(x3i(i,:));
c=sum(x3)./sum(x3(:));d=sum(x3i)./sum(x3i(:));
a=(a+ai)/2;
b=(bi+b)/2;
c=(c+d)/2;
h=figure(14);
MotifFigs(h,1);
plot(the,a(is),'k',the,b(is),'r:','LineWidth',1)
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
h=figure(16);
MotifFigs(h,1);
plot(the,a(is),'k',the,c(is),'b--','LineWidth',1)
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
out=[sum(x3,2);sum(Ex_x3);100*sum(x3,2)/sum(x3(:))]
in=[sum(x3i,2);sum(Ex_x3i);100*sum(x3i,2)/sum(x3i(:))]

function[h,p]=GetPeaks(x,ls)
for i=1:(length(ls)-1)
    [h(i),p(i)]=max(x(ls(i):(ls(i+1)-1)));
    p(i)=p(i)+ls(i)-1;
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