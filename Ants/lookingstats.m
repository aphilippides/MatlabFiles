function lookingstats(f,th)%,fs,ts,ns,ls)

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

if(nargin<2) th=10;
    %input('enter n where n=0 for last look, 1 for penultimate etc; return for last look');
%     dtoN=input('enter distance to limit starting point within:  ');
end

looklength=0;
tns=[];
pts=[];
for j=1:4 tls(j).tls=[]; end
NLooks.cs=[];
NLooks.ts=[];
NLooks.ls=[];
for i=1:4
    LMLooks(i).cs=[];
    LMLooks(i).ts=[];
    LMLooks(i).ls=[];
end

tThresh=0.2;
trail=3;
for k=1:length(fn)
    k
    load(fn(k).name);
    [meanC,meanT,meanTInd,len,in,ils,sn,en,cs,es,nest,LM,LMWid] = LookingPtsExpt2(fn(k).name,th,looklength);
    np=size(cs,1);
    nLM=length(ils);
    NLooks.cs=[NLooks.cs;meanC]; 
    NLooks.ts=[NLooks.ts meanT]; 
    NLooks.ls=[NLooks.ls len]; 
    for i=1:nLM
        LMLooks(i).cs=[LMLooks(i).cs; ils(i).meanC];
        LMLooks(i).ts=[LMLooks(i).ts ils(i).meanT];
        LMLooks(i).ls=[LMLooks(i).ls ils(i).len];
    end
    TToL=NaN*ones(nLM,1);
    for j=1:nLM
        [lst,lc]=LMStr(j,[0 0;0 1]);
        for i=1:length(meanT)
            if(isempty(ils(j).meanT))
                TToL(j,i)=NaN;
                NToL(j,i).good=0;
            else
                td=ils(j).meanT-meanT(i);
                aft=find(td>0,1);
                if(isempty(aft))
                    TToL(j,i)=NaN;NToL(j,i).good=0;
                else
                    TToL(j,i)=td(aft);
                    if((TToL(j,i)<=tThresh))
                        s=min(sn(i),ils(j).sl(aft));
                        e=max(en(i),ils(j).el(aft));
                        ilks=s:e;
                        i1s=sn(i):en(i); i2s=ils(j).sl(aft):ils(j).el(aft);
                        itrail=max(s-3,1):min(e+3,np);
                        NToL(j,i).cs=cs(ilks,:);NToL(j,i).es=es(ilks,:);
                        NToL(j,i).tcs=cs(itrail,:);NToL(j,i).tes=es(itrail,:);
%                         figure(1)
%                         plot([NToL(j,i).cs(:,1) NToL(j,i).es(:,1)]',[NToL(j,i).cs(:,2) NToL(j,i).es(:,2)]','b-', ...
%                             NToL(j,i).es(:,1),NToL(j,i).es(:,2),'b.',NToL(j,i).tcs(:,1),NToL(j,i).tcs(:,2),'r', ...
%                             es(i1s,1),es(i1s,2),'bo',es(i2s,1),es(i2s,2),'ro')
%                         hold on; PlotNestAndLMs(LM,LMWid,nest); hold off; axis equal
%                         title(['nest ' int2str(i) ' to LM ' int2str(j) '; time diff = ' num2str(TToL(j,i))])
                        inp=[];%input('return if ok, else not');
                        if(isempty(inp))
                            NToL(j,i).good=1;
                            figure(j)
                            plot([NToL(j,i).cs(:,1) NToL(j,i).es(:,1)]',[NToL(j,i).cs(:,2) NToL(j,i).es(:,2)]','b-', ...
                                NToL(j,i).es(:,1),NToL(j,i).es(:,2),'b.',NToL(j,i).tcs(:,1),NToL(j,i).tcs(:,2),'r', ...
                                es(i1s,1),es(i1s,2),'bs',es(i2s,1),es(i2s,2),[lc 'o'])
% plot([ils(j).meanC(aft,1) meanC(i,1)],[ils(j).meanC(aft,2) meanC(i,2)],lc,ils(j).meanC(aft,1),ils(j).meanC(aft,2),[lc 'o'],meanC(i,1),meanC(i,2),['bo'])
                            hold on
                        else NToL(j,i).good=0;
                        end
                    else NToL(j,i).good=0;
                    end
                end
            end
        end
    end
    for j=1:nLM
        [lst,lc]=LMStr(j,[0 0;0 1]);
        TToN(j).tl=NaN;
        for i=1:length(ils(j).meanT)
            if(isempty(meanT)) TToN(j).tl(i)=NaN;
            else
                td=meanT-ils(j).meanT(i);
                aft=find(td>0,1);
                if(isempty(aft)) TToN(j).tl(i)=NaN;
                else 
                    TToN(j).tl(i)=td(aft);
                    if(TToN(j).tl(i)<=tThresh)
                        s=min(sn(aft),ils(j).sl(i));
                        e=max(en(aft),ils(j).el(i));
                        ilks=s:e;
                        i1s=sn(aft):en(aft); i2s=ils(j).sl(i):ils(j).el(i);
                        itrail=max(s-3,1):min(e+3,np);
%                         NToL(j,i).cs=cs(ilks,:);NToL(j,i).es=es(ilks,:);
%                         NToL(j,i).tcs=cs(itrail,:);NToL(j,i).tes=es(itrail,:);
                        inp=[];%input('return if ok, else not');
                        if(isempty(inp))
%                             NToL(j,i).good=1;
                            figure(2+j)
                            plot([cs(ilks,1) es(ilks,1)]',[cs(ilks,2) es(ilks,2)]','b-', ...
                                es(ilks,1),es(ilks,2),'b.',cs(itrail,1),cs(itrail,2),'r', ...
                                es(i1s,1),es(i1s,2),'bo',es(i2s,1),es(i2s,2),[lc 's'])
% plot([ils(j).meanC(i,1) meanC(aft,1)],[ils(j).meanC(i,2) meanC(aft,2)],lc,ils(j).meanC(i,1),ils(j).meanC(i,2),[lc 's'],meanC(aft,1),meanC(aft,2),['bo'])
hold on
%                         else NToL(j,i).good=0;
                        end
%                     else NToL(j,i).good=0;
                    end

                end
            end
        end
    end
    TimeToN(k).TToN=TToN;
    TimeToL(k).TToL=TToL;
    n2l(k).nl=NToL;
    tns=[tns TToL];
    for j=1:nLM tls(j).tls=[tls(j).tls TToN(j).tl]; end
    save(['lookingstats.mat'])
end
figure(5),    
plot(NLooks.cs(:,1),NLooks.cs(:,2),'b.'),hold on;
PlotNestAndLMs(LM,LMWid,nest); hold off; axis equal
title(['Nest looks'],'Color','b')

for i=1:nLM
    [lst,lc]=LMStr(i,[0 0;0 1]);
    figure(i),
    PlotNestAndLMs(LM,LMWid,nest); hold off; axis equal
    title(['Nest look to ' lst ' LM (squares to circles)'],'Color',lc)
    figure(i+2),
    PlotNestAndLMs(LM,LMWid,nest); hold off; axis equal
    title([lst ' LM look to Nest (squares to circles)'],'Color',lc)
    figure(i+5),
    plot(LMLooks(i).cs(:,1),LMLooks(i).cs(:,2),[lc '.']),hold on;
    PlotNestAndLMs(LM,LMWid,nest); hold off; axis equal
    title([lst ' LM looks'],'Color',lc)
end
mv=0.5;
for j=1:nLM
    [lst,lc]=LMStr(j,[0 0;0 1]);axis tight
    [y,x]=hist(tns(j,:),[0:0.02:mv]);
    [y2,x2]=hist(tls(j).tls,[0:0.02:mv]);
    figure(j+7);
    subplot(nLM,1,1)
    bar(x(1:end-1),y(1:end-1));
    axis tight,
    title(['Time after nest look before ' lst ' LM look'],'Color',lc)
    tn(j).tn=tns(j,~isnan(tns(j,:)));
    medNToL(j)=median(tn(j).tn);
    xlabel(['Median = ' num2str(medNToL(j)) ...
        ';  Num Over ' int2str(mv) 's = ' int2str(y(end))])
    subplot(nLM,1,2)
    bar(x2(1:end-1),y2(1:end-1));
    axis tight,
    tls(j).tl=tls(j).tls(~isnan(tls(j).tls));
    medLtoN(j)=median(tls(j).tl);
    xlabel(['Median = ' num2str(medLtoN(j)) ... 
        ';  Num Over ' int2str(mv) 's = ' int2str(y2(end))])
    title(['Time after ' lst ' LM look before nest look'],'Color',lc)
    pdif(j)=ranksum(tn(j).tn,tls(j).tl)
end
if(ischar(f)) save(['lookingstats' f '.mat'])
else save(['lookingstats.mat'])
end
meds=[medNToL;medLtoN]
prdif=pdif
% pn2n=ranksum(tn(1).tn,tn(2).tn)
% pl2l=ranksum(tls(1).tl,tls(2).tl)