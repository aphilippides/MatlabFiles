% function[fos,frns,rl,fns]=histdataLMDist(inout,dn)
%
% first argument is a string to filter which files are picked
% second argument is the range of distances from nest you want to use
% USAGE:
%
% to choose files and distances: >> histdata
% to choose files with 'out' in them and distances: >> histdata('out')
% to choose files and data less than 5 from the nest >> histdata([],5)

function[out,ms,fns]=histdataLMDist(inout,dn,plotting,an,ts,al,hrs,ndiv)

if(nargin<1) inout=[]; end;
if(nargin<2)
%     disp('Enter distanc increment to gather data over.');
    dn=input('Enter distance (from nest) increment to gather data over: ');
end;
BeeDists=[0:dn:100 1e6];
% dn=dn*10;
if(nargin<3) plotting=1; end;
if(nargin<4) an=[]; end;
if(nargin<5) ts=[]; end;
if(nargin<6) al=[]; end;
if(nargin<7) hrs=[0 24]; end;
if(nargin<8) ndiv=10; end;

% s=dir(['*' inout '*Path.mat']);
s=dir(['*' inout '*All.mat']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers. Return to select all:   ');
if(isempty(Picked)) Picked=1:length(s); end;
fos=[];frns=[];

if(isempty(al)|isequal(al,180)|(range(al)>=360)) NoLM=1;
else NoLM=0;
end

if(~isequal(hrs,0))
    for i=1:length(Picked)
        TimeOfDay(i)=TimeFromFn(s(Picked(i)).name);
    end
    timeis=find((TimeOfDay>=hrs(1))&(TimeOfDay<hrs(2)));
    TimeOfDay(timeis)
    NumFlights=length(timeis)
    Picked=Picked(timeis);
end

for i=1:length(Picked)
    i
    clear DToNest;
    fn=s(Picked(i)).name;
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
    rn=(mod(NestOnRetina+pi,2*pi)-pi)*180/pi;
    for k=1:length(LMs)
        rl(lmo(k)).rl=(mod(LMs(k).LMOnRetina+pi,2*pi)-pi)*180/pi;
        rl(lmo(k)).LM=[LM(k,:)];
        rl(lmo(k)).LMWid=LMWid(k);
    end
    if(NoLM) nlms=1;
    else nlms=length(LMs);
    end
    for k=1:nlms
        for d=1:length(BeeDists)-1
            is=GetIs([BeeDists(d) BeeDists(d+1)],an,ts,al,DToNest,rn,t,o,rl(k).rl);
            if(i==1) out(d).rl(k).nFlt=0; end; 
            if(~isempty(is)) out(d).rl(k).nFlt=out(d).rl(k).nFlt+1; end;
            for j=1:length(LMs)
                %             f=hist(rl(j).rl(is),[-180:ndiv:180]);
                f=AngHist(rl(j).rl(is),[0:ndiv:360],0,0);
                if(i==1) 
                    out(d).rl(k).frls(j,:)=f;
                    out(d).rl(k).viewedL(j).angs=(rl(j).rl(is))';
                else 
                    out(d).rl(k).frls(j,:)=out(d).rl(k).frls(j,:)+f;
                    out(d).rl(k).viewedL(j).angs=[out(d).rl(k).viewedL(j).angs (rl(j).rl(is))'];
                end                
            end
            %         fo=hist(o(is),[0:ndiv:360]);
            %         frn=hist(rn(is),[-180:ndiv:180]);
            fo=AngHist(o(is),[0:ndiv:360],1,0);
            frn=AngHist(rn(is),[0:ndiv:360],0,0);
            if(i==1)
                out(d).rl(k).fos=fo;
                out(d).rl(k).os=o(is);
                out(d).rl(k).frns=frn;
                out(d).rl(k).Cents=Cents(is,:);
                out(d).rl(k).EndPt=EndPt(is,:);
                out(d).rl(k).sOr=sOr(is);
                out(d).rl(k).nest=nest;
                out(d).rl(k).nr=rn(is)';
                out(d).rl(k).flt=i*ones(1,length(is));
            else
                out(d).rl(k).fos=out(d).rl(k).fos+fo;
                out(d).rl(k).os=[out(d).rl(k).os o(is)];
                out(d).rl(k).frns=out(d).rl(k).frns+frn;
                out(d).rl(k).Cents=[out(d).rl(k).Cents; Cents(is,:)];
                out(d).rl(k).EndPt=[out(d).rl(k).EndPt; EndPt(is,:)];
                out(d).rl(k).sOr=[out(d).rl(k).sOr sOr(is)];
                out(d).rl(k).nr=[out(d).rl(k).nr (rn(is))'];
                out(d).rl(k).flt=[out(d).rl(k).flt i*ones(1,length(is))];
            end
        end
    end
end

for d=1:length(BeeDists)-1
    for k=1:length(out(d).rl)
        angs=[out(d).rl(k).sOr];
        nPts(d,k)=length(angs);
        nFlts(d,k)=out(d).rl(k).nFlt;
        if(isempty(angs))
            MeanOr(d,k)=NaN;LOr(d,k)=NaN;
            MeanNest(d,k)=NaN;LNest(d,k)=NaN;
            Mean2Nest(d,k)=NaN;L2Nest(d,k)=NaN;
            for j=1:length(LMs) MeanLM(d,k,j)=NaN;LLM(d,k,j)=NaN; end
        else
            angs=[out(d).rl(k).os]*pi/180;
            [MeanOr(d,k),LOr(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
            angs=[out(d).rl(k).nr]*pi/180;
            [MeanNest(d,k),LNest(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
            angs=cart2pol(out(d).rl(k).Cents(:,1),out(d).rl(k).Cents(:,2));
            [Mean2Nest(d,k),L2Nest(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
            for j=1:length(LMs)
                angs=[out(d).rl(k).viewedL(j).angs]*pi/180;
                [MeanLM(d,k,j),LLM(d,k,j)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
            end
        end
    end
end
ms.MeanOr=MeanOr;
ms.MeanNest=MeanNest;
ms.Mean2Nest=Mean2Nest;
ms.MeanLM=MeanLM;
ms.LOr=LOr;
ms.LNest=LNest;
ms.L2Nest=L2Nest;
ms.LLM=LLM;
ms.BeeDists=BeeDists(1:end-1);
ms.LM=LM;
ms.LMWid=LMWid;
ms.nest=nest;
ms.nPts=nPts;
ms.nFlts=nFlts;

if(plotting)
    nLM=length(out(1).rl);
    figure(1)
    for k=1:nLM
        for d=1:length(BeeDists)-1
            c=out(d).rl(k).Cents;
            if(~isempty(c))
            e=out(d).rl(k).EndPt;
            plot(e(:,1),e(:,2),'r.',[c(:,1) e(:,1)]',[c(:,2) e(:,2)]','r')
            hold on;
            PlotNestAndLMs(LM,LMWid,nest);
            CompassAndLine('k',[],[],0)
            axis equal,
            title(num2str(BeeDists(d)))
            hold off;
            inp=input('press return to continue, 0 to stop');
            if(isequal(inp,0)) break; end;
            end
        end
        if(isequal(inp,0)) break; end;
    end
    f=100;
    for k=1:nLM
        if(k==1) fh1=figure(2);
        else figure(fh1)
        end;
        subplot(nLM,1,k)
        errorbar(BeeDists(1:end-1),MeanOr(:,k)*180/pi,f*(1-LOr(:,k)));
        if(isempty(al)) 
            if(isempty(an)) lmst='nothing';lmc='b';
            else lmst='nest';lmc='b';
            end
        else [lmst,lmc]=LMStr(k,LM(lmo,:)); lmst=[lmst  ' LM'];
        end
        axis tight, 
        title(['Orientation when looking at ' lmst],'Color',lmc)
        if(k==1) fh2=figure(3);
        else figure(fh2)
        end;
        subplot(nLM,1,k)
        errorbar(BeeDists(1:end-1),MeanNest(:,k)*180/pi,f*(1-LNest(:,k)));        
        axis tight, title(['Retinal position of nest when looking at ' lmst],'Color',lmc)
        if(k==1) fh2=figure(4);
        else figure(fh2)
        end;
        subplot(nLM,1,k)
        errorbar(BeeDists(1:end-1),Mean2Nest(:,k)*180/pi,f*(1-L2Nest(:,k)));        
        axis tight, title(['Angular position relative to nest when looking at ' lmst],'Color',lmc)
        for j=1:length(LMs)
            if(k==1) fh(j)=figure(4+j);
            else figure(fh(j))
            end;
            subplot(nLM,1,k)
            errorbar(BeeDists(1:end-1),MeanLM(:,k,j)*180/pi,f*(1-LLM(:,k,j)));                
            axis tight,
            lms=LMStr(j,LM(lmo,:));
            title([lms ' LM on Retina when looking at ' lmst],'Color',lmc)
        end
    end
end
fns=s(Picked);
nPts'
nFlts'
save histdataLMDistData
% keyboard;

function[is]=GetIs(dn,as,rt,al,DToNest,NOnR,t,sOr,LMs)
if(isempty(dn)) dn=[0 max(DToNest)+.001];
elseif(length(dn)==1) dn=[0 dn];
end;
if(isempty(as)) as=[-180.01 180.01];
elseif(length(as)==1) as=[-as as];
end;
if(isempty(rt)) rt=[0 t(end)+.001];
elseif(length(rt)==1) rt=[t(end)-rt t(end)];
end;
if(isempty(al)) al=[-180.01 180.01];
elseif(length(al)==1) al=[-al al];
end;

ias=find((NOnR>=as(1))&(NOnR<as(2)));
ids=find((DToNest'>=dn(1))&(DToNest'<dn(2)));
is=intersect(ias,ids);
its=find((t>=rt(1))&(t<rt(2)));
ial=find((LMs>=al(1))&(LMs<al(2)));
i2=intersect(ial,its);
is=intersect(is,i2);

function WriteFileOnScreen(fns, NumOnLine)
if isempty(fns) return; end
L=size(fns,1);
N=fix(L/NumOnLine)-1;
M=rem(L,NumOnLine);
for i=0:N
    for j=1:NumOnLine
        fn=i*NumOnLine+j;
        fprintf('%d:  %s ',fn,fns(fn).name);
    end
    fprintf('\n');
end
for i=1:M
    fn=(N+1)*NumOnLine+i;
    fprintf('%d:  %s ',fn,fns(fn).name);
end