function StraightLines(f,th)%,fs,ts,ns,ls)

if(nargin<1) f=[]; end;
if((isempty(f))|(ischar(f)))
    s=dir(['*' f '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(f);
end

last1=0;

if(nargin<2) th=0.5;
    %input('enter n where n=0 for last look, 1 for penultimate etc; return for last look');
    %     dtoN=input('enter distance to limit starting point within:  ');
end

looklength=0;
tns=[];
pts=[];
for j=1:4 tls(j).tls=[]; end

tThresh=0.2;
plotting=0;
bs=[];ls=[];sts=[];ens=[];robbs=[];es=[];rs=[];
bs2=[];ls2=[];sts2=[];ens2=[];robbs2=[];es2=[];
for k=1:length(fn)
    k
    load(fn(k).name);
    eThresh=0.9;
    [b,st,en,err,r,robb,l]=GetStraightBits(Cents,t,tThresh,LM,LMWid,nest,eThresh,1);
    if(plotting)
        figure(1)
        plot(Cents(:,1),Cents(:,2),'g'),hold on;
        goods=find(r>eThresh);
        for i=goods
            is=st(i):en(i);
            Plotstuff(Cents,is,b(:,i),err(i),0,'b');
            Plotstuff(Cents,is,robb(:,i),err(i),0,'k');
        end;
        PlotNestAndLMs(LM,LMWid,nest),axis equal,hold off
    end
    bs=[bs b];ls=[ls l];robbs=[robbs robb];
    rs=[rs r];sts=[sts st];ens=[ens en];es=[es err];
    out(k).b=b(:,goods);
    out(k).l=l(:,goods);
    out(k).robb=robb(:,goods);
%     eThresh=0.95;
%     [b,st,en,err,robb,l]=GetStraightBits(Cents,t,tThresh,LM,LMWid,nest,eThresh,1);
%     bs2=[bs2 b];ls2=[ls2 l];robbs2=[robbs2 robb];sts2=[sts2 st];ens2=[ens2 en];es2=[es2 err];
%     if(plotting)
%         figure(1)
%         plot(Cents(:,1),Cents(:,2),'g'),hold on;
%         goods=find(err>eThresh);
%         for i=goods
%             is=st(i):en(i);
%             Plotstuff(Cents,is,b(:,i),err(i),0,'b');
%             Plotstuff(Cents,is,robb(:,i),err(i),0,'k');
%         end;
%         PlotNestAndLMs(LM,LMWid,nest),axis equal,hold off
%     end
    save straightlines
end
save straightlines
keyboard

function[bs,sts,ens,err,svs,robb,ls]= GetStraightBits(Cents,t,tThresh,LM,LMWid,nest,rsq,opt)
nrob=5;
sThresh=0.5;
st=1;
c=1;
plotting=0;
npts=length(t);
while 1
    if(st>npts) break; end
    et=t(st)+tThresh;
    en=max(st+nrob,find(t>=et,1));
    if(isempty(en)|(en>npts)) break; end;
    is=st:en;
    %     [b,stats]=robustfit(Cents(is,1),Cents(is,2));
    [b,conf,res,rint,stats]=regress(Cents(is,2),[ones(length(is),1) Cents(is,1)]);
    sts(c)=st;ens(c)=en;
    svs(c,:)=stats;
    err(c)=(mean(res.^2));
    %     err(c)=mean(abs(res));
    bs(:,c)=b;
    if(plotting) Plotstuff(Cents,is,b,svs(c,1),err(c),'g'); end;

    % is it a candidate line?
    isL=IsLine(opt,stats(1),err(c),rsq);
    if(~isL) st=st+1;
    else
        while 1
            en=en+1;
            if(en>npts) st=en; break; end;
            is=st:en;
            %     [b,stats]=robustfit(Cents(is,1),Cents(is,2));
            [b,conf,res,rint,stats]= ...
                regress(Cents(is,2),[ones(length(is),1) Cents(is,1)]);
            e=(mean(res.^2));%mean(abs(res));
            if(plotting) Plotstuff(Cents,is,b,stats(1),e,'b'); end;
           isL=IsLine(opt,stats(1),e,rsq);
           if(~isL)
                st=en;
                break;
            else
                sts(c)=st;ens(c)=en;
                svs(c,:)=stats;
                bs(:,c)=b;
                err(c)=e;
            end
        end
        is=sts(c):ens(c);
        mb=MyGradient(Cents(is,2),Cents(is,1));
        medb=median(mb);
        mp=Cents(is(round(length(is)/2)),:);
        cp=mp(2)-medb*mp(1);
%         robb(:,c)=[bs(1,c);medb];
%         if(plotting) 
    [b,stats]=robustfit(Cents(is,1),Cents(is,2));
    robb(:,c)=b;
            Plotstuff(Cents,is,bs(:,c),svs(c,1),err(c),'b'); hold on;
             Plotstuff(Cents,is,robb(:,c),svs(c,1),err(c),'k--'); 
            Plotstuff(Cents,is,[cp;medb],svs(c,1),err(c),'g'); hold off 
            
%         end;
    end
    ls(c)=CartDist(Cents(sts(c),:),Cents(ens(c),:));
%     is=sts(c):ens(c);
    c=c+1;
end

function[isL]=IsLine(opt,s,e,rsq);
if((opt==1)&(s>rsq)) isL=1;
elseif ((opt==0)&(e<rsq)) isL=1;
else isL=0;
end


function  Plotstuff(Cents,is,b,rsq,e,c)
xs=Cents(is,1);
xp=[min(xs);max(xs)];
yp=[[1;1] xp]*b;
plot(Cents(is,1),Cents(is,2),'r',xp,yp,c),axis equal
title(['frames ' int2str(is(1)) ' to ' int2str(is(end)) ...
    '; r-squared = ' num2str(rsq,3) '; err = ' num2str(e,3)])