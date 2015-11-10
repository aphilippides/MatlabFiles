% function[fos,frns,rl,fns]=histdata(inout,dn)
%
% first argument is a string to filter which files are picked
% second argument is the range of distances from nest you want to use
% USAGE:
%
% to choose files and distances: >> histdata
% to choose files with 'out' in them and distances: >> histdata('out')
% to choose files and data less than 5 from the nest >> histdata([],5)

function[rl,fns]=histdataLM(inout,dn,plotting,an,ts,al,ndiv)

if(nargin<1) inout=[]; end;
if(nargin<2)
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    dn=input('Enter just: d for [0 d] or return for all flight: ');
end;
% dn=dn*10;
if(nargin<3) plotting=1; end;
if(nargin<4) an=[]; end;
if(nargin<5) ts=[]; end;
if(nargin<6) al=[]; end;
if(nargin<7) ndiv=10; end;

% s=dir(['*' inout '*Path.mat']);
s=dir(['*' inout '*All.mat']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers. Return to select all:   ');
if(isempty(Picked)) Picked=1:length(s); end;
fos=[];frns=[];

if(length(ts)==1)
    for i=1:length(Picked)
        fn=s(Picked(i)).name;
        load(fn)
        FlightLength(i)=t(end)-t(1);
    end
    longs=find(FlightLength>=ts);
    Picked=Picked(longs);
end

xs=[0:ndiv:360];
for i=1:length(Picked)
    fn=s(Picked(i)).name;
    load(fn)
    lmo=LMOrder(LM);
    TimeOfDay=TimeFromFn(s(Picked(i)).name);
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
    for k=1:length(LMs)
        is=GetIs(dn,an,ts,al,DToNest,rn,t,o,rl(k).rl);        
        for j=1:length(LMs)
%             f=hist(rl(j).rl(is),[-180:ndiv:180]);
            f=AngHist(rl(j).rl(is),xs,0,0);
            if(i==1) rl(k).frls(j,:)=f;
            else rl(k).frls(j,:)=rl(k).frls(j,:)+f;
            end
        end
        fo=AngHist(o(is),xs,1,0);
        frn=AngHist(rn(is),xs,0,0);
        [dum,ind]=max(fo);
        rl(k).PeakOs(i)=xs(ind);
        rl(k).TOfDay(i)=TimeOfDay;
        if(i==1) 
            rl(k).fos=fo;
            rl(k).frns=frn;
            rl(k).Cents=Cents(is,:);
            rl(k).EndPt=EndPt(is,:);
            rl(k).sOr=sOr(is);
            rl(k).nest=nest;
        else
            rl(k).fos=rl(k).fos+fo;
            rl(k).frns=rl(k).frns+frn;
            rl(k).Cents=[rl(k).Cents; Cents(is,:)];
            rl(k).EndPt=[rl(k).EndPt; EndPt(is,:)];
            rl(k).sOr=[rl(k).sOr sOr(is)];
        end
    end
end

if(plotting)
    nLM=length(LMs);
    for k=1:nLM
        if(k==1) fh1=figure; 
        else figure(fh1)
        end;
        subplot(nLM,1,k)
        bar([0:ndiv:350],rl(k).fos)
        axis tight, title(['Orientation when looking at ' num2str(LMs(k).LM)])
        if(k==1) fh2=figure; 
        else figure(fh2)
        end;
        subplot(nLM,1,k)
        x=[-170:ndiv:180];
        bar(x,rl(k).frns)
        axis tight, title(['Retinal position of nest when looking at ' num2str(LMs(k).LM)])
        for j=1:length(LMs)
            if(k==1) fh(j)=figure;
            else figure(fh(j))
            end;
            subplot(nLM,1,k)
            bar(x,rl(k).frls(j,:))
            axis tight,
            title(['Retinal position of LM at ' num2str(LMs(j).LM) ' when looking at ' num2str(LMs(k).LM)])
        end
    end
end
fns=s(Picked);

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