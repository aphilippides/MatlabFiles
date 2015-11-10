function AnalysisScript
dwork
cd GantryProj\Bees\OFs16-21\Done\
dn=['F:\bumblebee flights\']
% dn=['../../OutdoorOFs/']
global im;

s1=dir('90*_*All.mat'); T
s2=dir('bee*_*All.mat');
s=[s1;s2];
% s=dir('*All.mat');
nps=[];nnots=[];
lps=[];lnots=[];
als=[];ats=[];
c1s=[];c2s=[];c3s=[];
is=1:length(s);
% is=[3 15:17 19 20 22 23 26 33:36 40 50 54 60 64 70 71]
load BigOrNoLm
is=[lefts rights];% 
% is=rights;
% is=[15 59];
% for i=is
%     i
%     fn=s(i).name;
%     load(fn);
% %     f=aviread([dn fn(1:end-7) '.avi'],1);
% %     im=f.cdata;
% %     imagesc(im);
% %     hold on; BeePath(fn);axis tight,axis off
% %     d(i,:)=[LM-nest LMWid];
%     c1s=[c1s;Cents(:,1)-nest(1) Cents(:,2)-nest(2)];
%     ls(i)=t(end)-t(1);
% %     [cn,cl,ln,ll,cnt,clt,in,il,ib] = LookingPts(fn,pi/18,0);
% %     [cn,cl,ln,ll,cnt,clt,in,il,ib] = LookingPts(fn,4*pi/18,0,0,6*pi/18);
% %     c1s=[c1s length(in)/length(t)];c2s=[c2s length(il)/length(t)];
% %     c3s=[c3s cnt-t(1)];als=[als ln];ats=[ats ll];nps=[nps clt-t(1)];
%     k=find(DToNest>50,1);
%     if(~isempty(k))
% %     figure(2),plot(t,medfilt1(Speeds)*5,t(k),Speeds(k)*5,'r.')
% %     axis tight
% %     xlabel('Time (s)')
% %     ylabel('Speed (cm/s)')
% %     SetBox
% %     figure(2),plot(t,DToNest/10,t(k),DToNest(k)/10,'r.')
% %     axis tight
% %     xlabel('Time (s)')
% %     ylabel('Distance from nest (cm)')
% %     SetBox
%     t1s(i)=t(k)-t(1);
%     t2s(i)=t(end)-t(k);
%     end
% end
% return
% plot(ls)
% return
% is=NoLMs;
for i=is
    i
    fn=s(i).name;
    load(fn);
%     f=aviread([dn fn(1:end-7) '.avi'],1);
%     im=f.cdata;
%     figure(6)
%     imagesc(im);
%     hold on;
%     xlabel(fn);
%     BeePath(fn);
%     hold off;
     
%    o=TimeSmooth(AngleWithoutFlip(OToNest),t,sm_len);
    % DISCRIMINATE BASED ON BEES ORIENTATION
%     load([fn(1:end-7) '2_5Deg25msArcs.mat'])
%     nots=setdiff(1:length(t),ps);
%     
%     ps=endpts;
%     als=[als al];ats=[ats at];
%     nnots=[nnots NestOnRetina(nots)'];
%     nps=[nps NestOnRetina(ps)'];
%     lnots=[lnots LMOnRetina(nots)'];
%     lps=[lps LMOnRetina(ps)'];
%     figure(1)
%     subplot(2,1,1),hist([NestOnRetina(midpts)],-pi:(pi/18):pi);title(fn),axis tight
%     subplot(2,1,2),hist([LMOnRetina(midpts)],-pi:(pi/18):pi);axis tight
%     figure(2)
% %     if(~isempty(al)) plot(abs(al./at)); end;
%     subplot(2,1,1),hist([NestOnRetina(ps)],-pi:(pi/18):pi);title(fn);axis tight
%     subplot(2,1,2),hist([LMOnRetina(ps)],-pi:(pi/18):pi);axis tight
%     figure(3)
%     subplot(2,1,1),hist(NestOnRetina(nots),-pi:(pi/18):pi);axis tight
%     subplot(2,1,2),hist(LMOnRetina(nots),-pi:(pi/18):pi);axis tight
%     xn(i,:)=[mean([NestOnRetina(ps) LMOnRetina(ps)]) mean([NestOnRetina(nots) LMOnRetina(nots)])];
%     sn(i,:)=[std([NestOnRetina(ps) LMOnRetina(ps)]) std([NestOnRetina(nots) LMOnRetina(nots)])];
%     [h(i),q(i)]=ttest2(NestOnRetina(ps),NestOnRetina(nots))
%     [hl(i),ql(i)]=ttest2(LMOnRetina(ps),LMOnRetina(nots))

    % DISCRIMINATE BASED ON WHEN LOOKING AT LM OR NEST

% figure(2),[in,il,ib]=PlotLooking(AngleWithoutFlip(o),fn,pi/12,1);
%         figure(2)
         [in,il,ib]=PlotLooking(AngleWithoutFlip(sOr),fn,pi/36,1);
         nots=setdiff(1:length(t),union(in,il));
         figure(1)
         hold off;
         as=AngleWithoutFlip(sOr)*180/pi;
         aon=AngleWithoutFlip(OToNest)*180/pi;
         aol=AngleWithoutFlip(OToLM)*180/pi;
         aall=[as' aon aol];
         %          v=[min([as,aon,aol]),max([as,aon,aol])];
         plot(t,as,t,aon,'r',t,aol,'g',t(in),aall(in,:),'r.',t(il),aall(il,:),'k.',t(ib),aall(ib,:),'y.')
         grid,axis tight
         title([int2str(i) ' = ' fn])
         figure(2)
         an=AngleWithoutFlip(NestOnRetina)*180/pi;
         lm=AngleWithoutFlip(LMOnRetina)*180/pi;
         plot(t,an,'b',t(in),an(in),'r.',t,lm,'r',t(il),lm(il),'k.')
         grid,axis tight

%          [ps,o_al,o_at,SOpt,SOptt]=BeeArcs(Cents,EndPt,sOr,t,[nest;LM]);
%          [ps,p_al,p_at,NOpt,NOptt]=BeeArcs(Cents,EndPt,OToNest,t,[nest;LM]);
         %      [t_shift(i),a_shift(i)]=AlignArcs(AngleWithoutFlip(OToNest),NOpt,NOptt,AngleWithoutFlip(sOr),SOpt,SOptt,t);
          [cn,cl,ln,ll,cnt,clt,ib] = LookingPts(fn,pi/18,0);
%         [cn,cl,ln,ll,cnt,clt,ib] = LookingPts(fn,3*pi/18,0,0,5*pi/18);
%          [ArcLM]=SelectArcs(LMOnRetina,t);
         figure(4),[ArcONest]=SelectArcs(OToNest,t);         
         Nestlooks(i).nt=cnt-t(1);
         Nestlooks(i).fn=fn;
         Nestlooks(i).LMOnRet=LMOnRetina(in);
         Nestlooks(i).TtoPeak=TimeToPeak(cnt,ArcONest(:,1)');

         figure(3),[ArcOLM]=SelectArcs(OToLM,t,0.17);
         hold on; plot(t(il),aol(il)*pi/180,'k.'), hold off
         grid,axis tight;
         ttp=TimeToPeak(clt,ArcOLM(:,1)');
         nps=[nps, ttp];
          LMlooks(i).TtoPeak=ttp;
          LMlooks(i).lmt=clt;
          LMlooks(i).fn=fn;
          LMlooks(i).NestOnRet=NestOnRetina(il);
%           figure(1),
        [ArcBody]=SelectArcs(sOr,t);
         [ArcNest]=SelectArcs(NestOnRetina,t);
          
%           if(size(ArcBody,1)>1)
%               [c3,c1,c2,cs(i)]=ArcCentre(fn,ArcBody(:,3));
% %           figure(5),plot(c2(:,1),c2(:,2),'kd',c1(:,1),c1(:,2),'bo',LM(1)-nest(1),LM(2)-nest(2),'ro')
% %            figure(4), bar(c3*180/pi)
% %           cs(i).arcpt=c1;cs(i).fixpt=c2;cs(i).fixa=c3;cs(i).NoArcs=0;
%           c1s=[c1s;c1];c2s=[c2s;c2];c3s=[c3s c3];
%           else cs(i).NoArcs=1;
%           end  

%         if(size(ArcBody,1)>1)
%            [mr,pp,npp,neg,pos]=TurnRates(ArcBody,sOr,t,'b',NestOnRetina,OToNest);
%            nnots=[nnots;npp];
%            nps=[nps;pp];
%            NestOnRet(i).fn=fn;
%            NestOnRet(i).p_arcs=mr.pjs;
%            NestOnRet(i).p_ends=mr.pnjs;
%            NestOnRet(i).p_all=mr.pis;
%            NestOnRet(i).Arcs=pp;
%            NestOnRet(i).Ends=npp;
%            NestOnRet(i).ArcsNeg=neg;
%            NestOnRet(i).ArcsPos=pos;
%            NestOnRet(i).NoArcs=0; 
%            NestOnRet(i).rates=mr.mr;
%            NestOnRet(i).ArcBody=ArcBody;
%            NestOnRet(i).NumArcs=size(ArcBody,1)-1;
%            [mr,pp,npp,neg,pos]=TurnRates(ArcBody,sOr,t,'b',LMOnRetina,OToLM);
%            LMOnRet(i).fn=fn;
%            LMOnRet(i).p_arcs=mr.pjs;
%            LMOnRet(i).p_ends=mr.pnjs;
%            LMOnRet(i).p_all=mr.pis;
%            LMOnRet(i).Arcs=pp;
%            LMOnRet(i).Ends=npp;
%            LMOnRet(i).ArcsNeg=neg;
%            LMOnRet(i).ArcsPos=pos;
%            LMOnRet(i).NoArcs=0; 
%            LMOnRet(i).rates=mr.mr;
%            LMOnRet(i).ArcBody=ArcBody;
%         else
%            NestOnRet(i).rates=0;NestOnRet(i).NoArcs=1; 
%            LMOnRet(i).rates=0;LMOnRet(i).NoArcs=1; 
%         end

%           figure(3),hist(lps)
%           figure(4),bar(-180:9:180,mean(nps)),figure(5),bar(-180:9:180,mean(nnots))

         % %         [in,il,ib]=PlotLooking(TimeSmooth(Speeds,t,0.1),fn,pi/12,1);
%         figure(1);
%         plot(t,AngleWithoutFlip(NestOnRetina),t,AngleWithoutFlip(LMOnRetina),'r')
%        [in,il,ib]=PlotLooking(Cents,fn,pi/12,1);
%         x=TimeSmooth((AngularDifference(OToNest')./diff(t)),t(2:end),0.1);%Speeds;
%         pivs=GetAllArcs(fn,t);
         x=TimeSmooth((AngularDifference(sOr)./diff(t)),t(2:end),0.1);%Speeds;
         x=abs([x x(end)]);
%         x=TimeSmooth(Speeds,t,0.1);%[x x(end)];
%        x=mod(OToLM,2*pi)';
%          [cn,cl,ln,ll]=LookingPts(fn,5*pi/180,1);
%          if(~isempty(cn)) cn=[cn(:,1)-nest(1) cn(:,2)-nest(2)];end;
%          if(~isempty(cl)) cl=[cl(:,1)-nest(1) cl(:,2)-nest(2)];end;
        x=[Cents(:,1)-nest(1) Cents(:,2)-nest(2)];
 
%          if(~isempty(cn)) cn=[cn(:,1)-LM(1) cn(:,2)-LM(2)];end;
%          if(~isempty(cl)) cl=[cl(:,1)-LM(1) cl(:,2)-LM(2)];end;
%         x=[Cents(:,1)-LM(1) Cents(:,2)-LM(2)];
 
        dlim=find(DToNest>0,1);
        if(isempty(dlim)) dlim=length(t); end;
%         in=in(find(in>dlim));
%         il=il(find(il>dlim));
%         nots=nots(find(nots>dlim));
%        is=find(x<=0.1);

%         x=OToNest;
%        figure(2),plot(t,x)
%        figure(2),plot(t,AngleWithoutFlip(sOr))
        
        % implement a cutoff point
%         cutof= ceil(0.5*length(sOr));
%         in=in(find(in<=cutof));
%         il=il(find(il<=cutof));
%         nots=nots(find(nots<=cutof));
%         hold on
%        [p(i), h(i)]=ranksum(x(in),x(nots))
        % [h(i),q(i)]=ttest2(x(in),x(nots))
%        figure(3)
%         subplot(1,3,3)%figure(3)
%         [dum,ss]=hist(x(nots),30);hist(x(nots),ss);
%         subplot(1,3,1)%figure(1)
%         hist(x(in),ss);
%         subplot(1,3,2)%figure(2)
%         hist(x(il),ss);
        
%         subplot(1,3,3)%figure(3)
%         rose(x(nots),36);
%         subplot(1,3,1)%figure(1)
%         rose(x(in),36);
%         subplot(1,3,2)%figure(2)
%         rose(x(il),36); 
%         rose(OToLM(il)); 

%         nnots=[nnots;nest];
%         nps=[nps;LM];
%         lps=[lps length(t)];
%         nnots=[nnots x(nots)];
%           nnots=[nnots NestOnRetina(1:ceil(end))'];
           nnots=[nnots mod(sOr(1:ceil(end/2)),2*pi)-pi];
            sss=mod(sOr+pi,2*pi)-pi;
%           nnots=[nnots sss(1:ceil(end/2))];
%             f=hist(sss(1:ceil(end/2))*180/pi,-180:9:180);
%             bar(-180:9:180,f);
%             nps=[nps;f/length(OToNest)];
%             xlim([-180 180])

%         nps=[nps x(in)];
%        lps=[lps x(il)];
%        nnots=[nnots; x(nots,:)];
%         lps=[lps;x(il,:)];
%         nps=[nps;x(in,:)];

%         lps=[lps;cn];
%         nps=[nps;cl];
%         subplot(1,2,1)
%         figure(1)
%        plot(Cents(in,1),Cents(in,2),'r.',nest(1),nest(2),'rs',LM(1),LM(2),'ko')%,Cents(il,1),Cents(il,2),'r.');
%         axis equal
% %         subplot(1,2,2),  
%         figure(2)
%         plot(Cents(il,1),Cents(il,2),'k.',nest(1),nest(2),'rs',LM(1),LM(2),'ko');
%         title(fn)
%         axis equal
        %        lps=[lps OToLM(il)'];

%         subplot(1,3,3)%figure(3)
%         rose(NestOnRetina(setdiff(1:length(t),is)))
%         subplot(1,3,1)%figure(1)
%         if(~isempty(is)) rose(NestOnRetina(is)); end;
%         subplot(1,3,2)%figure(2)
%         if(~isempty(is)) rose(LMOnRetina(is)); end;
%         nnots=[nnots NestOnRetina(setdiff(1:length(t),is))'];
%         nps=[nps NestOnRetina(is)'];
%         lps=[lps LMOnRetina(is)'];
        a=LM-nest
%         xlabel(int2str(round(cart2pol(a(1),a(2))*180/pi)))
        title(fn); 
%         x=abs(x);
        xn(i)=mean(x(in));
        xl(i)=mean(x(il));
        xb(i)=mean(x(ib));
        xo(i)=mean(x(nots));
    % *** DISTANCES STUFF - OLD ***
    %     [d_cutOff(i),i_cutOff(i)]=getDistances(DToNest,Cents,EndPt,NestOnRetina,[nest;LM],t);
end
hist(nnots,40)
keyboard
c_ns=nps;c_ls=lps;c_os=nnots;
k=10;
[Dn,x,y,xp,yp]=Density2D(c_ns,[],-400:k:250,-300:k:400);
[Dl,x,y,xp,yp]=Density2D(c_ls,[],-400:k:250,-300:k:400);
[Do,x,y,xp,yp]=Density2D(c_os,[],-400:k:250,-300:k:400);
figure(1),pcolor(xp,yp,Dn),shading flat;
hold on;plot(0,0,'wx',LM(1)-nest(1),LM(2)-nest(2),'wo');hold off
% hold on;plot(-LM(1)+nest(1),-LM(2)+nest(2),'wx',0,0,'wo');hold off
figure(2),pcolor(xp,yp,Dl),shading flat;
hold on;plot(0,0,'wx',LM(1)-nest(1),LM(2)-nest(2),'wo');hold off
% hold on;plot(-LM(1)+nest(1),-LM(2)+nest(2),'wx',0,0,'wo');hold off
figure(3),pcolor(xp,yp,Do),shading flat;
hold on;plot(0,0,'wx',LM(1)-nest(1),LM(2)-nest(2),'wo');hold off
% hold on;plot(-LM(1)+nest(1),-LM(2)+nest(2),'wx',0,0,'wo');hold off
% plot(1:11,xn,1:11,xl,'r',1:11,xb,'y',1:11,xo,'k')
bar([xn;xl;xo]')
plot(abs(als./ats),'o')
figure(2),hist(nps,-pi:(pi/18):pi);axis tight
figure(3),hist(nnots,-pi:(pi/18):pi);axis tight

figure(2),hist(lps,-pi:(pi/18):pi);axis tight
figure(3),hist(lnots,-pi:(pi/18):pi);axis tight

subplot(1,3,3),[dum,ss]=hist(nnots,[0:0.01:0.5]);hist(nnots,ss);axis tight
subplot(1,3,1),hist(nps,ss);axis tight
subplot(1,3,2),hist(lps,ss);axis tight

subplot(1,3,3),rose(nnots,36);
subplot(1,3,1),rose(nps,36);
subplot(1,3,2),rose(lps,36);

subplot(1,3,3),[dum,ss]=hist(abs(nnots),30);hist(abs(nnots),ss);
subplot(1,3,1),hist(abs(nps),ss);
subplot(1,3,2),hist(abs(lps),ss);

function[pivots]=GetAllArcs(fn,t)
pivots=[];
t2=0;
fout=['Pivots_' fn];
if(isfile(fout)) 
    load(fout);
    t2=pivots(end,6);
end

while(ie<length(t)) 
    [m,s,t1,t2,is,ie]=PivotPoints(fn,t2+.01);
    pivots=[pivots;m,s,t1,t2,is,ie];
    save(fout,'pivots');
end

function[in,il,ib] = PlotLooking(o,fn,th,Plotting)
global im;
load(fn);
pos=[nest;LM];
in=find((NestOnRetina<th)&(NestOnRetina>-th));
il=find((LMOnRetina<th)&(LMOnRetina>-th));
ib=intersect(in,il);
if(Plotting)
    if(min(size(o))==1) plot(t,o,t(in),o(in),'k.',t(il),o(il),'r.',t(ib),o(ib),'y.')
    else
        figure(1)
        subplot(1,3,1)%figure(1)
        %imagesc(im); hold on;
        PlotArc(o,EndPt,pos,[1:length(t)],'y')
        hold on; PlotArc(o,EndPt,pos,in,'k'); hold off;
        subplot(1,3,2)%figure(2)
        % imagesc(im); hold on;
        PlotArc(o,EndPt,pos,[1:length(t)],'y')
        hold on; PlotArc(o,EndPt,pos,il,'k'); hold off;
        subplot(1,3,3)%figure(3)
        % imagesc(im); hold on;
        PlotArc(o,EndPt,pos,[1:length(t)],'y')
        hold on; PlotArc(o,EndPt,pos,ib,'k'); hold off;
    end
end

function[d_cutOff,i_cutOff]=getDistances(d,Cents,EndPt,os,pos,t,d_cutOff)
global im;
if(nargin<7) d_cutOff=0.25*max(d); end;

i_cutOff=max(1,find(d>=d_cutOff,1));
t_cut=t(i_cutOff)-t(1);
while(1)
    figure(1)
    plot(t-t(1),d,[t_cut t_cut],[0 2*d_cutOff],'r')
    figure(2)
    is=1:i_cutOff;
    i2=i_cutOff+1:min(i_cutOff+50,length(d));
    imagesc(im); hold on;
    PlotArc(Cents,EndPt,pos,is,'r')
    hold on; PlotArc(Cents,EndPt,pos,i2,'y'); hold off;
    figure(3),
    rose(os(is),90);
    hist(os(is),[-180:4:180]*pi/180);
    d2=input('enter cut-off time:  ');
    if(isempty(d2)) break;
    else
        t_cut=d2;
        [m,i_cutOff]=min(abs(t-t_cut-t(1)));
        d_cutOff=d(i_cutOff);
    end;
end

function[pts,arc_len,arc_t,opt,optt] = BeeArcs(Cents,EndPt,os,t,pos,fn)
global im;
figure(1)
Drawing=0;

if(size(os,1)>size(os,2)) os=os'; end;
[ma_t,ma_s,mi_t,mi_s]=GetArcs(os,t,0.175,0.05);
% [ma_t,ma_s,mi_t,mi_s]=GetArcs(os,t,0.087,0.05);
% [ma_t,ma_s,mi_t,mi_s]=GetArcs(os,t,0.35,0.2);

pts=[];arc_t=[];arc_len=[];opt=[];optt=[];
if(isempty(ma_s)|isempty(mi_s)) return; end;
for tpt=[ma_t mi_t]
    pts=union(pts,find((t>(tpt-0.05))&(t<(tpt+0.05))));
end
[optt,i]=sort([ma_t mi_t]);
v=[ma_s mi_s]
opt=v(i);
if(ma_t(1)<mi_t(1))
    for i=1:length(ma_t)
        if(i>length(mi_t)) break; end;
        arc_len=[arc_len ma_s(i)-mi_s(i)];
        arc_t=[arc_t ma_t(i)-mi_t(i)];
        if(Drawing)
            figure(2)
            imagesc(im), hold on;
            PlotArc(Cents,EndPt,pos,t,ma_t(i),mi_t(i));
        end
        if((i+1)>length(ma_t)) break; end;
        arc_len=[arc_len mi_s(i)-ma_s(i+1)];
        arc_t=[arc_t mi_t(i)-ma_t(i+1)];
        if(Drawing)
            %        figure(3)
            % imagesc(im),
            hold on;
            PlotArc(Cents,EndPt,pos,t,mi_t(i),ma_t(i+1),'r');
            pause
        end
    end
else
    for i=1:length(mi_t)
        if(i>length(ma_t)) break; end;
        arc_len=[arc_len mi_s(i)-ma_s(i)];
        arc_t=[arc_t mi_t(i)-ma_t(i)];
        if(Drawing)
            figure(2)
            imagesc(im), hold on;
            PlotArc(Cents,EndPt,pos,t,mi_t(i),ma_t(i));
        end
        if((i+1)>length(mi_t)) break; end;
        arc_len=[arc_len ma_s(i)-mi_s(i+1)];
        arc_t=[arc_t ma_t(i)-mi_t(i+1)];
        if(Drawing)
            %        figure(3)
            %imagesc(im),
            hold on;
            PlotArc(Cents,EndPt,pos,t,ma_t(i),mi_t(i+1),'r');
            pause
        end
    end
end

if(nargin==6)
    ma_type=[];mi_type=[];
    hold on;
    mo_type=ones(1,length([ma_s mi_s]));
    ps=[ma_t mi_t;ma_s mi_s]';
    title('left click if end, right click if centre, else dont know')
    xlabel('default is all ends, ie un-starred points')
    while(1)
        [p,q,r]=ginput(1);
        if(isempty(r)) break; end;
        [mini_d,i]=min(sum((ps-ones(length(ps),1)*[p,q]).^2,2));
        if(r==1)
            mo_type(i)=1;
            plot(ps(i,1),ps(i,2),'g*');
        elseif(r==3)
            mo_type(i)=2;
            plot(ps(i,1),ps(i,2),'k*');
        else
            mo_type(i)=2;
            plot(ps(i,1),ps(i,2),'c*');
        end
    end
    hold off;
    ma_type=mo_type(1:length(ma_s));
    mi_type=mo_type(length(ma_s)+1:end);
    endpts=[];
    for tpt=ps(find(mo_type==1),1)'
        endpts=union(endpts,find((t>(tpt-0.05))&(t<(tpt+0.05))));
    end
    midpts=[];
    for tpt=ps(find(mo_type==2),1)'
        midpts=union(midpts,find((t>(tpt-0.05))&(t<(tpt+0.05))));
    end
    save([fn '5Deg50msArcs.mat'],'ma_type','mi_type','endpts','midpts','arc_len','arc_t');
else
    hold on;
    a=AngleWithoutFlip(os);
    plot(t(pts),a(pts)-0.1,'k.')
    hold off;
end