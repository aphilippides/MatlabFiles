function orientplots(or,inout,m)

if((nargin<1)|isempty(or)) 
    or=input('Enter range of orientations in DEGREES as [a b]. return for all flight: ')
    if(isempty(or)) or = [-.01 360.01]; end;
end;

if(nargin<2) inout=[]; end;
if(nargin<3) m=5; end;
s=dir(['*' inout '*All.mat']);
% s=dir(['*' inout '*Path.mat']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers. Return to select all.   ');
if(isempty(Picked)) Picked=1:length(s); end;
fos=[];frns=[];

for i=1:length(Picked)
    load(s(i).name)
    o=(mod(sOr,2*pi))*180/pi;
    is=find((o>=or(1))&(o<or(2)));
    fos=[fos;Cents(is,:)];
end

[d,a,b,x,y]=Density2D(fos(:,1),fos(:,2),[0:m:1000],[200:m:800]);
pcolor(x,y,d);shading flat;
title(['position of bee when orientation is in range:  ' num2str(or,3)]); 
hold on;
PlotNestAndLMs(LM,LMWid,nest);
hold off
CompassAndLine('w');

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