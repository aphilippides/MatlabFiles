function lookingplots2(fn,pos)%,fs,ts,ns,ls)

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
    end
    clear NestOnRetina
end
fs=fs(goods);

h1=figure(1);
h2=figure(2);
h3=figure(3);
opt=1;optf=1;
DLim=100;
TLim=0.5;
pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
while 1
    figure(h1)
    tst=[{'0=nest-nest; 1=nest-N; 2=nest-S; 3=N-N; 4=N-nest; 5=N-S';...
        '6=S-S; f=Fwrd; b=Back; r6=Radius 6 cm; t1=Time 1; return to quit'}];
    title(tst);
    disp('0=nest-nest; 1=nest-N; 2=nest-S; 3=N-N; 4=N-nest; 5=N-S');
    disp('6=S-S; f=Fwrd; b=Back; r6=Radius 6; t1=Time 1; return to quit');
    b=input('enter an option:   ','s');
    if(isempty(b)) break;
    elseif(isequal(b,'0'))
        opt=0;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'1'))
        opt=1;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'2'))
        opt=2;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'3'))
        opt=3;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'4'))
        opt=4;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'5'))
        opt=5;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'6'))
        opt=6;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'f'))
        optf=0;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b,'b'))
        optf=1;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b(1),'r'))
        DLim=str2num(b(2:end));
        DLim=10*DLim;
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    elseif(isequal(b(1),'t'))
        TLim=str2num(b(2:end));
        pts=PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
    end
        PlotSpag(fs,opt,optf,h2,h3,LM,LMWid,nest,DLim,TLim);
end

function[pts] = PlotLooks(fs,opt,optf,h1,LM,LMWid,nest,DLim);
figure(h1);
pts=[];
if(optf) fstr=[' Back to ' num2str(DLim/10) 'cm'];
else fstr=[' Forwards ' num2str(DLim/10) 'cm'];
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

function[dt]=PlotSpag(fs,opt,optf,h2,h3,LM,LMWid,nest,DLim,TLim);
figure(h2);
if(optf) 
    fstr=[' Back to ' num2str(DLim/10) 'cm and ' num2str(TLim) 's'];
    ts=[0:0.1:4];
else
    fstr=[' Forwards ' num2str(DLim/10) 'cm and ' num2str(TLim) 's'];
    ts=[-4:0.1:0];
end
if(opt==0) tst=['Nest to nest;' fstr];lc='b';sc='b';
elseif(opt==1) tst=['Nest to N LM;' fstr];lc='r';sc='b';
elseif(opt==2) tst=['Nest to S LM;' fstr];lc='k';sc='b';
elseif(opt==3) tst=['N LM to N LM;' fstr];lc='r';sc='r';
elseif(opt==4) tst=['N LM to nest;' fstr];lc='b';sc='r';
elseif(opt==5) tst=['N LM to S LM;' fstr];lc='k';sc='r';
else tst=['S LM to S LM;' fstr];lc='k';sc='k';
end

dt=[];dt2=[];
for i=1:length(fs)
    if(opt<3) st=fs(i).nest;
    elseif(opt==6) st=fs(i).ils(2);
    else st=fs(i).ils(2);
    end
    if(opt==3) ss=fs(i).ils(1);
    elseif(opt==4) ss=fs(i).nest;
    else ss=fs(i).ils(2);
    end

    for j=1:length(st.meanT)
        mti=st.meanTind(j);
        mt=st.meanT(j);
        mc=st.meanC(j,:);
%         hdl=plot(mc(1),mc(2),[sc 'o']);%,'MarkerFaceColor',sc)
        if(optf) ind=find(ss.meanT<mt,1,'last');
        else ind=find(ss.meanT>mt,1);
        end

        if(~isempty(ind))
            i2=ss.meanTind(ind);
            ic=ss.meanC(ind,:);
            td=mt-ss.meanT(ind);
            dt2=[dt2 td];
            di=abs(CartDist(ic,mc));
            dt=[dt di];
            if((di<=DLim)&(abs(td)<=TLim))
                if(optf) is=i2:mti;
                else is=mti:i2;
                end
                plot(fs(i).c(is,1),fs(i).c(is,2),sc)
                hold on;
                plot(ic(1),ic(2),[lc 'o'])
                plot(mc(1),mc(2),[sc 'o'],'MarkerFaceColor',sc);
            end
        end;
    end
end
title(tst);
PlotNestAndLMs(LM,LMWid,nest);axis equal
CompassAndLine('k');
hold off,
% figure(h3),hist(dt,ts)
figure(h3),hist(dt/10,0:0.5:20),axis tight
figure(4),plot(dt/10,dt2,'bo')