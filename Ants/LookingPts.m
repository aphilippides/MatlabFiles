% function[cn,cl,ln,ll,cnt,clt,ib] = LookingPts(fn,th1,iLen,Pl,th2)
%
% function which calculates the looking events at nest and LM 
% in file fn between retinal angles th1 and th2 where th1<th2
% if th2 unspecified it is assumed that th2=-th1
%
% Can specify only events over length iLen (default=1) are returned
% Pl specifies whether to plot them or not (default 0)
%
% returned values are mean pos nest, mean pos lm, length nest events
% length lm events, mean time nest, mean time lm, inds looking both

function[cn,cl,ln,ll,cnt,clt,in,il,ib] = LookingPts(fn,th1,iLen,Pl,th2)
if(nargin<5)
    th2=abs(th1);
    th1=-th2;
end
if(nargin<4) Pl=0; end;
if(nargin<3) iLen = 1; end;

load(fn);
in=find((NestOnRetina<th2)&(NestOnRetina>=th1));
il=find((LMOnRetina<th2)&(LMOnRetina>=th1));
ib=intersect(in,il);
[sn,en,ln]=StartFinish(t,in,0.08);
js=find(ln>=iLen);sn=sn(js);en=en(js);
[sl,el,ll]=StartFinish(t,il,0.08);
js=find(ll>=iLen);sl=sl(js);el=el(js);
cn=[];cl=[];
cnt=[];clt=[];
for i=1:length(sn)
    is=sn(i):en(i);
    cn(i,:)=mean(Cents(is,:),1);
    cnt(i)=mean(t(is));
end
for i=1:length(sl)
    is=sl(i):el(i);
    cl(i,:)=mean(Cents(is,:),1);
    clt(i)=mean(t(is));
end

if(Pl)
    figure(2)    
    plot(Cents(il,1),Cents(il,2),'y.')
    if(length(cl)) hold on;plot(cl(:,1),cl(:,2),'k.')
    plot(nest(1),nest(2),'rx',LM(1),LM(2),'kx'),
    MyCircle([nest;LM],[NestWid;LMWid]/2,['r';'k']);hold off;
    axis equal
    end
    title(fn)
    figure(1)
    plot(Cents(in,1),Cents(in,2),'y.')%,Cents(ib,1),Cents(ib,2),'ko')
   if(length(cn)) hold on;plot(cn(:,1),cn(:,2),'r.')
    MyCircle([nest;LM],[NestWid;LMWid]/2,['r';'k']);hold off;
    axis equal
   end
end
% figure(3)
% NNs=GetLines(cn,nest,NestWid,pi/4)
% % figure(2)
% LNs=GetLines(cl,nest,NestWid,pi/4)
% NLs=GetLines(cn,LM,LMWid,pi/16)
% LLs=GetLines(cl,LM,LMWid,pi/16)

function[SelLines]=GetLines(ns,p,pw,sec)
x=ns(:,1)-p(1);
y=ns(:,2)-p(2);
[t,r]=cart2pol(x,y);
if(nargin<4) sec=pi/4;end;
ts=0:sec:(2*pi-0.1);
if(length(t)>=2)
    plot(x,y,'b.')
    hold on;MyCircle([0 0],pw,'r');
    axis equal
    ds=sqrt(x.^2+y.^2);
    for i=1:length(ts)
        td=abs(AngularDifference(ts(i),t));
%         [st,is]=sort(td);
        ins=find(td<=sec);
        if(length(ins)>=2)
            [b,st]=robustfit([x(ins);0],[y(ins);0]);
            xl=sort([x(ins);0])*1.1;
            plot(xl,b(1)+b(2)*xl,'r')
            [md(i),ind]=max(ds(ins));
            text(x(ins(ind)),y(ins(ind)),int2str(i));
            title(['Err = ' num2str(st.s)])
            bs(i,:)=b';
            es(i)=st.s;
        else bs(i,:)=[NaN,NaN];
            es(i)=inf;
            md(i)=0;
        end
%         NumIn20(i)=length(ins);
%         if(~isempty(ins)) ange(i)=mean(td(ins));
%         else ange(i)=pi;
%         end
%         sm2(i)=st(2);
    end
    hold off;
    a=[1:length(ts);es]
    ls=input('enter number of lines\n');
    SelLines=[bs(ls,:) es(ls)' md(ls)'];
%     figure(3)
%     plot(ange)
%     plot(sm2)
else SelLines=[];
end        
%     dfroml=r(is).*sin(td(is));

function[s,e,l]=StartFinish(t,is,th)
s=[];e=[];l=[];
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