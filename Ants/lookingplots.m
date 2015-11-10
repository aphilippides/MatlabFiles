function lookingplots(fn,pos)%,fs,ts,ns,ls)

if(nargin<1) fn=[]; end;
if((isempty(fn))|(ischar(fn)))
    s=dir(['*' fn '*All.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers:   ');
    if(isempty(Picked)) fn=s;
    else fn=s(Picked);
    end
else
    s=dir(['*All.mat']);
    fn=s(fn);
end
goods=[];
for i=1:length(fn)
    i
    load(fn(i).name);
    if(exist('NestOnRetina'))
        goods=[goods i];
        fs(i).c=Cents;
        %     [fs(i).meanC,fs(i).meanT,fs(i).meanTind,fs(i).len,fs(i).in,fs(i).ils] ...
        [fs(i).nest.meanC,fs(i).nest.meanT,fs(i).nest.meanTind,fs(i).nest.len,fs(i).in,fs(i).ils] ...
            = LookingPtsExpt2(fn(i).name,10);
        clear NestOnRetina
    end
end
fs=fs(goods);

h1=figure(1);
h2=figure(2);
h3=figure(3);
opt=1;optf=1;
pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
DLim=30;
while 1
    figure(h1)
    tst=[{'0=nest-nest; 1=nest-N; 2=nest-S; 3=N-N; 4=N-nest';...
        '5=N-S; 6=S-S; f=Fwrd; b=Back; ; r=Radius; Right-click=quit'}];
    [ind,b]=GetNearestClickedPt(pts,tst);
    b=char(b);
    if(isempty(b)|b==2|b==3) break;
    elseif(isequal(char(b),'0'))
        opt=0;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'1'))
        opt=1;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'2'))
        opt=2;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'3'))
        opt=3;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'4'))
        opt=4;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'5'))
        opt=5;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'6'))
        opt=6;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'f'))
        optf=0;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'b'))
        optf=1;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
    elseif(isequal(char(b),'r'))
        while 1
            ski=input('enter 0 to continue:  ');
            if(ski==0) break;end
        end
        DLim=input('enter a radius in cm:   ');
        DLim=10*DLim;
        if(exist('oldind'))
            pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
            hold on;
            ind=oldind;
            plot(pts(ind,1),pts(ind,2),'ko','MarkerSize',10,'MarkerFaceColor','k');
            hd=MyCircle(pts(ind,:),DLim,'k');
            set(hd,'LineWidth',2);
            hold off;
            PlotSpag(fs,opt,optf,h2,h3,pts(ind,:),LM,LMWid,nest,DLim);
        end
    else
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
        hold on;
        oldind=ind;
        plot(pts(ind,1),pts(ind,2),'ko','MarkerSize',10,'MarkerFaceColor','k');
        hd=MyCircle(pts(ind,:),DLim,'k');
        set(hd,'LineWidth',2);
        hold off;
        PlotSpag(fs,opt,optf,h2,h3,pts(ind,:),LM,LMWid,nest,DLim);
    end
end

function[pts] = PlotLooks(fs,opt,optf,h1,LM,LMWid,nest);
figure(h1);
pts=[];
if(optf) fstr=' Back';
else fstr=' Forwards';
end
if(opt<3)
    for i=1:length(fs) pts=[pts;fs(i).nest.meanC]; end;
    plot(pts(:,1),pts(:,2),'bo');
    if(opt==0) xlabel(['Nest to nest;' fstr])
    elseif(opt==1) xlabel(['Nest to N LM;' fstr])
    else xlabel(['Nest to S LM;' fstr])
    end
else
    if(opt==6) lm=2;
    else lm=1;
    end;
    [lst,lc]=LMStr(lm,[0 0;0 1]);
    for i=1:length(fs) pts=[pts;fs(i).ils(lm).meanC]; end
    plot(pts(:,1),pts(:,2),[lc 'o']);
    if(opt==6) xlabel(['S LM to S LM;' fstr])
    elseif(opt==5) xlabel(['N LM to S LM;' fstr])
    elseif(opt==4) xlabel(['N LM to nest;' fstr])
    else xlabel(['N LM to N LM;' fstr])
    end
end
hold on;
PlotNestAndLMs(LM,LMWid,nest);axis equal
CompassAndLine('k');
hold off;

function[dt]=PlotSpag(fs,opt,optf,h2,h3,pos,LM,LMWid,nest,DLim);
if(optf) fstr=' Back';
else fstr=' Forwards';
end
if(opt==0) tst=['Nest to nest;' fstr];lc='b';sc='b';
elseif(opt==1) tst=['Nest to N LM;' fstr];lc='r';sc='b';
elseif(opt==2) tst=['Nest to S LM;' fstr];lc='k';sc='b';
elseif(opt==3) tst=['N LM to N LM;' fstr];lc='r';sc='r';
elseif(opt==4) tst=['N LM to nest;' fstr];lc='b';sc='r';
elseif(opt==5) tst=['N LM to S LM;' fstr];lc='k';sc='r';
else tst=['S LM to S LM;' fstr];lc='r';sc='k';
end

for i=1:length(fs)
    if(opt<3) st=fs(i).nest;
    elseif(opt==6) st=fs(i).ils(2);
    else st=fs(i).ils(2);
    end

    if(~isempty(st.meanC))
        ds=CartDist(st.meanC,pos);
        [md,ind]=min(ds);
        if(md<=DLim)
            mti=st.meanTind(ind);
            mt=st.meanT(ind);
            mc=st.meanC(ind,:);
            if(opt==3) ss=fs(i).ils(1);
            elseif(opt==4) ss=fs(i).nest;
            else ss=fs(i).ils(2);
            end

            if(optf) ind=find(ss.meanT<mt,1,'last');
            else ind=find(ss.meanT>mt,1);
            end

            if(isempty(ind)) dt(i)=NaN;
            else
                i2=ss.meanTind(ind);
                ic=ss.meanC(ind,:);
                if(optf) is=i2:mti;
                else is=mti:i2;
                end
                plot(fs(i).c(is,1),fs(i).c(is,2),sc)
                hold on
                plot(ic(1),ic(2),[lc 'o'])
                dt(i)=mt-ss.meanT(ind);
            end;
            plot(mc(1),mc(2),[sc 'o'],'MarkerFaceColor',sc)
        else dt(i)=NaN;
        end
    else dt(i)=NaN;
    end
end
title(tst);
PlotNestAndLMs(LM,LMWid,nest);axis equal
CompassAndLine('k');
hold off,
figure(h3),hist(dt)