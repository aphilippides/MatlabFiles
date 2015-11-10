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

allang3=[];x3=[];x3i=[];
allang=[];x=[];xi=[];
sfs=[];sfsi=[];

% load straight_1north08_outData
% [ang3,ang,sf]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
% x3=[x3;AngHist(ang3*180/pi)]; 
% x=[x;hist(ang*180/pi,0:10:180)];

% cd ../../bees07/2' east all'/
load straight_2east_outData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load straight_2westoutData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load straight_out_north8_2007Data
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load straight_west8_outData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
x3=[x3;AngHist(ang3*180/pi)]; 
x=[x;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load straight_east8_outData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
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
% [ang3,ang,sf]=ProcessFlightSections(fltsec)
% allang3=[allang3 ang3]; allang=[allang ang]; sfs=[sfs;sf];
% x3i=[x3i;AngHist(ang3*180/pi)]; 
% xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../2' east all'/
load straight_2east_inData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'2 west'/
load straight_2west_inData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'north 8'/
load straight_in_north8_2007Data
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'west 8'/
load straight_west8_inData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];
x3i=[x3i;AngHist(ang3*180/pi)]; 
xi=[xi;hist(ang*180/pi,0:10:180)];

cd ../'east 8'/
load straight_east8_inData
[ang3,ang,sf]=ProcessFlightSections(fltsec)
allang3=[allang3 ang3]; allang=[allang ang]; sfsi=[sfsi;sf];
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
figure(9)
a=sum(xb)./sum(sum(xb));b=sum(xbi)./sum(sum(xbi));
plot(the,a(is),the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
figure(10)
a=sum(x3)./sum(sum(x3));b=sum(x3i)./sum(sum(x3i));
plot(the,a(is),the,b(is),'r')
axis tight;ya=ylim;ylim([0 ya(2)])%ylim([0 1])
Setbox,SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})

strs={'2 east';'2 west';'north 8';'east 8';'west 8'};
for i=1:5
    a=x3(i,:)./sum(x3(i,:));b=x3i(i,:)./sum(x3i(i,:));
    subplot(5,1,i)
plot(the,a(is),the,b(is),'r')
%     subplot(5,2,2*i-1),plot(the,a(is))
if(i==5) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
else SetXTicks(gca,0,[],[]);
end
axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),
xlabel([char(strs(i)) '; n=' int2str(sum(x3(i,:))) ' (out), ' int2str(sum(x3i(i,:))) ' (in)']),
% xlabel([char(strs(i)) '; n=' int2str(sum(x3(i,:))) ' (out)']),
    Setbox,%ylim([0 1]),
%     subplot(5,2,2*i),plot(the,b(is))
% if(i==5) SetXTicks(gca,[],[],[],[-180 -90 0 90 180],{'S';'W';'N';'E';'S'})
% else SetXTicks(gca,0,[],[]);
% end
% axis tight;ya=ylim;ylim([0 ya(2)]),ylabel('frequency'),
% xlabel([char(strs(i)) '; n=' int2str(sum(x3i(i,:))) ' (in)']),
%     Setbox,%ylim([0 1]),
end
save ../tmpscriptbees_straightdata

pea=[2,13,21,32]
thr=5;
for i=1:4
    ypsi(i,:)=AngHist([sfs(:,pea(i)).psi]*180/pi);
    ypsii(i,:)=AngHist([sfsi(:,pea(i)).psi]*180/pi);
    ypsi2(i,:)=AngHist([sfs(:,pea(i)).psi2]*180/pi);
    ypsi2i(i,:)=AngHist([sfsi(:,pea(i)).psi2]*180/pi);
    
    is=find(([sfs(:,pea(i)).rpsi]*180/pi)<thr);
    mas=[sfs(:,pea(i)).psi];
    ypsi3(i,:)=AngHist(mas(is)*180/pi)
    is=find(([sfsi(:,pea(i)).rpsi]*180/pi)<thr);
    mas=[sfsi(:,pea(i)).psi];
    ypsi3i(i,:)=AngHist(mas(is)*180/pi)
    
    spsi(i,:)=hist([sfs(:,pea(i)).spsi],0.9:0.01:1);
    rpsi(i,:)=hist([sfs(:,pea(i)).rpsi]*180/pi,5:10:95);
    rpsi2(i,:)=hist([sfs(:,pea(i)).rpsi2]*180/pi),5:10:95;

    spsii(i,:)=hist([sfsi(:,pea(i)).spsi],0.9:0.01:1);
    rpsii(i,:)=hist([sfsi(:,pea(i)).rpsi]*180/pi,5:10:95);
    rpsi2i(i,:)=hist([sfsi(:,pea(i)).rpsi2]*180/pi),5:10:95;
    
end 
for i=1:4
    subplot(2,2,i),
    plot(-170:10:180,ypsi(i,:)/sum(ypsi(i,:)),-170:10:180,ypsi3(i,:)/sum(ypsi3(i,:)),'b:')%, ...
%      plot(-170:10:180,ypsii(i,:)/sum(ypsii(i,:)),'r',-170:10:180,ypsi3i(i,:)/sum(ypsi3i(i,:)),'r:')
%     plot(5:10:95,rpsi(i,:)/sum(rpsi(i,:)),5:10:95,rpsii(i,:)/sum(rpsii(i,:)),'r')
%     plot(5:10:95,rpsi2(i,:)/sum(rpsi2(i,:)),'b'),hold on,plot(5:10:95,rpsi2i(i,:)/sum(rpsi2i(i,:)),'r'),hold off
    axis tight
end    

return


% [length(dir('*.avi')) length(dir('*All.mat')) length(dir('*Prog.mat')) ...
%     length(dir('*ProgWhole.mat')) length(dir('*ALev.mat'))]


% s=dir('2E20 11*.avi');
% s=dir('*All.mat');
% jnds=1:length(s)
LM1=[];
LM2=[];
ns=[];
xs=[0:10:360];
[a,b]=xlsread('Roof WindDir.xls');
cdirs={'n','nne','ne','ene','e','ese','se','sse','s','ssw','sw','wsw','w','wnw','nw','nnw','calm'};
lcd=length(cdirs);
fos=zeros(lcd,36);
foos=zeros(lcd,36);
fois=zeros(lcd,36);
for j=1:lcd
    inds(j).is=[];
    c=char(cdirs(j));
    c=(cdirs(j));
    for k=1:size(b,1)
        if(isequal(b(k,5),c))
            inds(j).is=[inds(j).is;k];
        end
    end
    jnds=[inds(j).is];
    for i=jnds'
        fn=char(b(i,1));%s(i).name;
        load(fn)
        lmo=LMOrder(LM);
        if(exist('cmPerPix'))
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
        else
            [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
                ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
        end
        %     o=(mod(sOr,2*pi))*180/pi;
        o=sOr_sc*180/pi;
        fo=AngHist(o,xs,1,1);
        fos(j,:)=fos(j,:)+fo;
        if(~isempty(strfind(fn,'in'))) fois(j,:)=fois(j,:)+fo;
        else foos(j,:)=foos(j,:)+fo;
        end

        %     inp=input('return if unimodal, 1 if bimodal, 0 else');
        %     if(isequal(inp,1)) mods(i)=2;
        %     elseif(isequal(inp,0)) mods(i)=0;
        %     else mods(i)=1;
        %     end
        %     save unibi mods
    end
end

k2=([31:36 1:36 1:5]);
x2=[-230:10:230];
x=[-170:10:180];
figure(1),subplot(111)
% hack to make N plot in centre of the graph
lx=length(x);
m=round(0.5*lx);
kk=([m+1:lx 1:m]);

for j=1:lcd
    lo=fos(j,kk)/sum(fos(j,:));
    li=foos(j,kk)/sum(foos(j,:));
    la=fois(j,kk)/sum(fois(j,:));
end
plot(x2,lo(k2),x2,li(k2),'r',x2,la(k2),'k','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(oo)) ') vs S (red, n=' int2str(sum(oi)) ') vs calm (black, n= ' int2str(sum(oa)) ')'];
Setbox;title(['Body orientation, N ' tstr])
figure(2),subplot(2,1,1)
lo=ooo(kk)/sum(ooo);
li=oio(kk)/sum(oio);
la=oao(kk)/sum(oao);
plot(x2,lo(k2),x2,li(k2),'r',x2,la(k2),'k','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(ooo)) ') vs S (red, n=' int2str(sum(oio)) ') vs calm (black, n= ' int2str(sum(oao)) ')'];
Setbox;title(['Body orientation, N ' tstr])
subplot(2,1,2)
lo=ooi(kk)/sum(ooi);
li=oii(kk)/sum(oii);
la=oai(kk)/sum(oai);
plot(x2,lo(k2),x2,li(k2),'r',x2,la(k2),'k','LineWidth',2);
axis tight; ax=axis; ylim([0 ax(4)])
tstr=['(blue, n=' int2str(sum(ooi)) ') vs S (red, n=' int2str(sum(oii)) ') vs calm (black, n= ' int2str(sum(oai)) ')'];
Setbox;title(['Body orientation, N ' tstr])
% % plot(LM1(:,1),LM1(:,2),'ro',LM2(:,1),LM2(:,2),'ko')
% figure(1);
% MyCircle(LM1(:,[1 2]),LM1(:,3)/2,'r');hold on
% MyCircle(LM2(:,[1 2]),LM2(:,3)/2,'k');
% plot(ns(:,1),ns(:,2),'bx')
% axis equal;set(gca,'YDir','reverse');
% hold off;
% figure(2),
% d1s=CartDist(LM1(:,[1 2]),ns(:,[1 2]));
% d2s=CartDist(LM2(:,[1 2]),ns(:,[1 2]));
% plot(jnds,LM1(:,3),jnds,d1s,'r',jnds,d2s,'g')
% figure(3),
% plot(LM1(:,[1 2]),'r'),hold on;
% plot(LM2(:,[1 2]),'k')
% plot(ns(:,[1 2]),'b')
%
% return
%
% ts=[20:5:75];
% for t=ts
%     TrackBeeExpt2(fn,fr,t)
% end
return

rs=[];cs=[];
refim=MyAviRead(fn,1,345);
ne=[691,533];
lm=[864,553];
for i=1:345
    im=MyAviRead(fn,i,345);
    if(i==1)
        [n1(i,:),n2(i,:),nw(i),na(i),lm1(i,:),lm2(i,:),lmw(i),lma(i)] ...
            =MatchNestAndLM(ne,lm,refim,im);
    else
        [n1(i,:),n2(i,:),nw(i),na(i),lm1(i,:),lm2(i,:),lmw(i),lma(i)] ...
            =MatchNestAndLM(n1(1,:),lm(1,:),refim,im,na(1),lma(1));
    end
    %     [B,L,N,A] = bwboundaries(bwclean);
    %     boundary(i).b=B{1};
    %     rs=[rs;d(:,865)'];
    %     cs=[cs;d(:,750)'];
    %     cc=normxcorr2(templat,d2);
    %     [max_cc, imax] = max(abs(cc(:)));
    %     [ypeak(i), xpeak(i)] = ind2sub(size(cc),imax(1));
    %       b=boundary(i).b;
    %       c=S(i).Centroid;
    %       imagesc(d2);
    %       hold on
    %       plot(b(:,2),b(:,1),'r',c(1),c(2),'r.')
    %       axis equal,hold off
end
return

lcol=['r';'k';'y';'g'];
clear lmw

for j=1:size(LM,1)
    MyCircle(lmw(:,[3*j-2 3*j-1]),lmw(:,3*j),lcol(j,:));
    hold on
end;
MyCircle(lmw(:,[end-2 end-1]),lmw(:,end),'b')
return
load BigOrNoLm
load OnRetinaData_AllArc
pj=[];r=[];
for i=[lefts rights]
    pj=[pj LMOnRet(i).ArcsNeg];
    r=[r LMOnRet(i).ArcsPos];
    %     p=NestOnRet(i).p_arcs;
    %     if(length(p)>0)
    %     is=find(p(:,1)>10);
    %     if(~isempty(is)) r=[r NestOnRet(i).rates(is)]; end;
    %     if(~isempty(is)) pj=[pj; p(is,:)]; end;
    %     end
end
% for i=rights
%     is=find(abs(lps(i).mr)>4);
%     pj=[pj;lps(i).pjs(is,2),lps(i).pjs(is,3),lps(i).pjs(is,4),...
%     lps(i).pnjs(is,2),lps(i).pnjs(is,3),lps(i).pnjs(is,4),...
%     lps(i).pis(is,2),lps(i).pis(is,3),lps(i).pis(is,4)];
%
%     r=[r;lps(i).pjs(is,5),lps(i).pjs(is,6), lps(i).pjs(is,7),...
%     lps(i).pnjs(is,5),lps(i).pnjs(is,6), lps(i).pnjs(is,7),...
%     lps(i).pis(is,5),lps(i).pis(is,6),lps(i).pis(is,7)];
% end
% return

% for j=1:25
%      a=[arccents(j).fix];
% %     a=[arccents(j).arc];
% %     a=([arccents(j).ang])*180/pi;
% %     hist(a,-180:9:180)
% %     m(j)=mean(a);
% %     s(j)=std(a);
%
%     n(j)=size(a,1);
%     if(n(j)>1)
%         ds=sqrt(sum(a.^2,2));
%         d(j)=mean(ds);
%         sd(j)=std(ds);
%         m(j,:)=mean(a);
%         s(j,:)=std(a);
% %         error_ellipse(cov(a),mean(a))
%         plot(a(:,1),a(:,2),'ro')
%     else
%         return
%     end
% %     hold on
% %    arccents(j).fix=[];
% %    arccents(j).arc=[];
% %    arccents(j).ang=[];
% end
% return
% for i=lefts
%     l=size([cs(i).fixpt],1);
%     for j=1:l
%         arccents(j).fix=[arccents(j).fix;cs(i).fixpt(j,:)]
%     end
%         l=size([cs(i).arcpt],1);
%     for j=1:l
%         arccents(j).arc=[arccents(j).arc;cs(i).arcpt(j,:)]
%         arccents(j).ang=[arccents(j).ang cs(i).fixa(j)]
%     end
% end


