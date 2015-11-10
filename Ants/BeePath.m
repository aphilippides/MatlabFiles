% function BeePath(fn,ts,nframe,PPic)
%
% function to plot a bee path in file fn
% ts specifies which times to show (default all)
% nframe says to plot every nframe'th frame (default 1)
% PPic specifies whether to plot
% 
% Examples:
% To plot the whole file do:                  BeePath(fn)
% To plot times 3 to 14 do:                   BeePath(fn,[3 14])
% To plot every 2nd frame from 1 to 10 do:    BeePath(fn,[1 10],2)
% To plot every 3rd frame for whole file do:  BeePath(fn,[],3)

function BeePath(fn,ts,nframe,PPic)

load(fn)
if(~exist('t')) t=FrameNum*0.02; end;
if(~exist('sOr')) sOr=TimeSmooth(ang_e,t,0.1); end;

if(nargin<4) PPic=0; end;
if(nargin<3) nframe=1; end;
if((nargin<2)||isempty(ts)) inds=1:length(t);
else inds=GetTimes(t,ts);
end

[EndPt(:,1),EndPt(:,2)]=pol2cart(sOr,10);
EndPt=EndPt+Cents;
c=inds(1);
pausing=1;
sk=[];
nc=max(4,nframe);
while(c<=inds(end))
    oc=c;
    c=c+nc;
    is=oc:nframe:min(c,inds(end));
    i2=inds(1):nframe:min(c,inds(end));

    if(pausing)
        PlotNestAndLMs(LM,LMWid,nest);
        hold on;
        CompassAndLine('k',[],[],0)
        plot(EndPt(i2,1),EndPt(i2,2),'r.')
        plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','r')
        plot(EndPt(is,1),EndPt(is,2),'b.')
        plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','b')
        title(['time ' num2str(t(is(1))) ' to time ' num2str(t(is(end)))])
        xlabel(fn)
        axis equal;
        hold off;
        sk=input('return continue, 0 to end, # to show more frames at once');
    end
    if(sk==0) pausing=0;
    elseif(isnumeric(sk)&~isempty(sk)) nc=sk;
    end
end
PlotNestAndLMs(LM,LMWid,nest);
hold on;
CompassAndLine('k',[],[],0)
plot(EndPt(inds(1:nframe:end),1),EndPt(inds(1:nframe:end),2),'b.')
plot([Cents(inds(1:nframe:end),1) EndPt(inds(1:nframe:end),1)]',[Cents(inds(1:nframe:end),2) EndPt(inds(1:nframe:end),2)]','b')
% plot(Cents(i2,1),Cents(i2,2),'r')
xlabel(fn)
hold off;
axis equal

function[is]=GetTimes(t,Ts)
is=[];
for i=1:size(Ts,1)
    [m,si]=min(abs(t-Ts(i,1)));
    [m,ei]=min(abs(t-Ts(i,2)));
    is=[is si:ei];
end