% function[fos,frns,rl,fns]=histdata(inout,dn)
%
% first argument is a string to filter which files are picked
% second argument is the range of distances from nest you want to use
% USAGE:
%
% to choose files and distances: >> histdata
% to choose files with 'out' in them and distances: >> histdata('out')
% to choose files and data less than 5 from the nest >> histdata([],5)

function[fos,frns,rl,fns]=histdata(inout,dn,plotting)

if(nargin<1) inout=[]; end;
if(nargin<2)
    disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
    dn=input('Enter just: r for [-r r] or return for all flight: ');
end;
if(nargin<3) plotting=1; end;

% s=dir(['*' inout '*Path.mat']);
s=dir(['*' inout '*All.mat']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers. Return to select all:   ');
if(isempty(Picked)) Picked=1:length(s); end;
fos=[];frns=[];

for i=1:length(Picked)
    load(s(Picked(i).name)
    o=(mod(sOr,2*pi))*180/pi;
    is=GetIs([],[],[],dn,s(i).name);
    fo=hist(o(is),[0:10:360]);
    if(i==1) fos=fo;
    else fos=fos+fo;
    end
    rn=(mod(NestOnRetina(is)+pi,2*pi)-pi)*180/pi;
    frn=hist(rn,[-180:10:180]);
    if(i==1) frns=frn;
    else frns=frns+frn;
    end
    lmo=LMOrder(LM);
    for j=1:length(LMs)
        rl(lmo(j)).rl=(mod(LMs(j).LMOnRetina(is)+pi,2*pi)-pi)*180/pi;
    end
    for j=1:length(LMs)
        rl(j).frl=hist(rl(j).rl,[-180:10:180]);
        if(i==1) rl(j).frls=rl(j).frl;
        else rl(j).frls=rl(j).frls+rl(j).frl;
        end
    end
end

if(plotting)
    figure
    bar([0:10:360],fos)
    axis tight, title('Orientation')
    figure
    x=-180:10:180;
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

function[is,ios,its,ids]=GetIs(or,rt,dn,as,fn)
load(fn)
if(isempty(or)) or=[-0.01 360.01]; end;
if(isempty(rt)) rt=[0 t(end)+.001];
elseif(length(rt)==1) rt=[0 rt];
end;
if(isempty(dn)) dn=[0 max(DToNest)+.001];
elseif(length(dn)==1) dn=[0 dn];
end;
if(isempty(as)) as=[-180.01 180.01];
elseif(length(as)==1) as=[-as as];
end;

o=(mod(sOr,2*pi))*180/pi;
ios=find((o>=or(1))&(o<or(2)));
its=find((t>=rt(1))&(t<rt(2)));
ids=find((DToNest'>=dn(1))&(DToNest'<dn(2)));
is=intersect(ios,its);
is=intersect(is,ids);
an=(mod(NestOnRetina+pi,2*pi)-pi)*180/pi;
ias=find((an>=as(1))&(an<as(2)));
is=intersect(is,ias);

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