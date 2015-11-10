% function[fos,frns,rl,fns]=histdata(inout,dn)
%
% first argument is a string to filter which files are picked
% second argument is the range of distances from nest you want to use
%
% USAGE:
%
% to choose files and distances: >> histdata
% to choose files with 'out' in them and distances: >> histdata('out')
% to choose files and data less than 5 from the nest >> histdata([],5)

function[fos,frns,rl,fns,PeakOs,TimeOfDay,Peak2Os]=histdata(inout,dn,plotting,an,ts,ndiv)

if(nargin<1) inout=[]; end;
if(nargin<2)
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    dn=input('Enter just: d for [0 d] or return for all flight: ');
end;
if(nargin<3) plotting=1; end;
if(nargin<4) an=[]; end;
if(nargin<5) ts=[]; end;
if(nargin<6) ndiv=10; end;

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
    fn=s(Picked(i)).name
    clear DToNest;
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
    is=GetIs(dn,an,ts,[],DToNest,rn,t,o);
    for j=1:length(LMs)
        rl(lmo(j)).rl=(mod(LMs(j).LMOnRetina(is)+pi,2*pi)-pi)*180/pi;
        rl(lmo(j)).LM=LM(j,:);
        rl(lmo(j)).LMWid=LMWid(j);
        rl(lmo(j)).OToLM=LMs(j).OToLM(is);
    end
    s(i).inds=is;
    s(i).Cents=Cents(is,:);
    s(i).EndPt=EndPt(is,:);
    s(i).sOr=sOr_sc(is);
    s(i).nest=nest;
    s(i).fdir=Cent_Os(is)';
    s(i).nOnR=rn(is)';    
    s(i).lOnR=rl;
    s(i).o2nest=OToNest(is)';

    frn=AngHist(rn(is),xs,0,0);
    TimeOfDay(i)=TimeFromFn(s(Picked(i)).name);
    fo=AngHist(o(is),xs,1,0);
%     fo=AngHist(o(is),xs,1,1);
%     title(['T = ' num2str(TimeOfDay(i))])
    % get Peak Os and time of day
    [mb,mx,ma]=CircularPeaks(fo,xs);
    PeakOs(i)=NaN;
    Peak2Os(i)=NaN;
    if(length(mb)>1)
        PeakOs(i)=mx(1);
        Peak2Os(i)=mx(2);
    elseif(length(mb)==1)
        PeakOs(i)=mx(1);
    end
    if(i==1)
        frns=frn;
        fos=fo;
    else
        frns=frns+frn;
        fos=fos+fo;
    end
    for j=1:length(LMs)
        rl(j).frl=AngHist(rl(j).rl,xs,0,0);
        if(i==1) rl(j).frls=rl(j).frl;
        else rl(j).frls=rl(j).frls+rl(j).frl;
        end
    end
end

if(plotting)
    figure
    bar([0:ndiv:350],fos)
    axis tight, title('Orientation')
    figure
    x=[-170:ndiv:180];
    bar(x,frns)
    axis tight, title('Retinal position of nest')
    for j=1:length(LMs)
        figure
        bar(x,rl(j).frls)
        axis tight,
        title(['Retinal position of LM at ' num2str(LMs(j).LM)])
    end
end
fns=s(Picked);

function[is,ios,its,ids]=GetIs(dn,as,rt,or,DToNest,NOnR,t,sOr)
if(isempty(dn)) dn=[0 max(DToNest)+.001];
elseif(length(dn)==1) dn=[0 dn];
end;
if(isempty(as)) as=[-180.01 180.01];
elseif(length(as)==1) as=[-as as];
end;
if(isempty(rt)) rt=[0 t(end)+.001];
elseif(length(rt)==1) rt=[t(end)-rt t(end)];
end;
if(isempty(or)) or=[-0.01 360.01]; end;
ias=find((NOnR>=as(1))&(NOnR<as(2)));
ids=find((DToNest'>=dn(1))&(DToNest'<dn(2)));
is=intersect(ias,ids);
its=find((t>=rt(1))&(t<rt(2)));
is=intersect(is,its);

% o=(mod(sOr,2*pi))*180/pi;
% ios=find((o>=or(1))&(o<or(2)));
% is=intersect(ios,its);

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