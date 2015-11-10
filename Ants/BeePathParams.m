% function BeePathParam(fn,th,ts,nframe,PPic)
%
% function to plot a bee path in file fn
% ts specifies which times to show (default all)
% nframe says to plot every nframe'th frame (default 1)
% set nframe < 0 to not plot iteratively
%
% PPic not used at mo
%
% Examples:
% To plot the whole file do:                  BeePathLooking(fn,10)
% To plot times 3 to 14 do:                   BeePathLooking(fn,10,[3 14])
% To plot every 2nd frame from 1 to 10 do:    BeePathLooking(fn,20,[1 10],2)
% To plot every 3rd frame for whole file do:  BeePathLooking(fn,15,[],3)

function BeePathLooking(fn,ang,th,ts,nframe,PPic)

if((nargin<1)|isempty(fn))
    s=dir(['*All.mat']);
    if(isempty(s))
        disp(' no *All.mat files in folder');
        return;
    end;
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers. Return to select all:   ');
    if(isempty(Picked)) Picked=1:length(s); end;
elseif(~isfile(fn))
    s=dir(['*' fn '*All.mat']);
    if(isempty(s))
        disp([' no files in folder matching: *' fn '*All.mat']);
        return;
    end;
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers. Return to select all:   ');
    if(isempty(Picked)) Picked=1:length(s); end;
end
lcol=['ro';'ko';'yo';'go'];
if(nargin<3)
    disp(' ')
    disp('Enter range of retinal positions of nest/LMs as [r1 r2] in degrees.');
    th=input('Enter just r for [-r r] or return to skip: ');
end
if(nargin<6) PPic=0; end;
plot_it=1;
if(nargin<5) nframe=1;
elseif(nframe<0)
    nframe=-nframe;
    plot_it=0;
end;

for i=1:length(Picked)
    fn=s(Picked(i)).name;
    load(fn)
    if(~exist('t')) t=FrameNum*0.02; end;
    if(~exist('sOr')) sOr=TimeSmooth(ang_e,t,0.1); end; 
    if(~exist('compassDir')) 
        compassDir=4.9393; 
    end;

    if(nargin<4)
        disp(' ')
        disp(['Pick times between ' num2str(t(1)) ' and ' num2str(t(end))]);
        ts=input('Format is [t1 t2]. Return for all flight:  ');
        if(isempty(ts)) inds=1:length(t);
        else inds=GetTimes(t,ts);
        end
    elseif(isempty(ts)) inds=1:length(t);
    else inds=GetTimes(t,ts);
    end
    disp(' ')
    st=file2struct(fn);
    if(isempty(th)) ins=[]; ils=[];
    else [ins,ils]=LookingPts(ang,th,st);
    end

    [EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,10);
    EndPt=EndPt+Cents;
    c=inds(1);
    pausing=1;
    sk=[];
    nc=max(4,nframe);
    if(i==1) hsing=gcf;
    else figure(hsing);
    end

    if(plot_it)
        while(c<=inds(end))
            oc=c;
            c=c+nc;
            is=oc:nframe:min(c,inds(end));
            i2=inds(1):nframe:min(c,inds(end));

            if(pausing)
                PlotNestAndLMs(LM,LMWid,nest);
                hold on;
                CompassAndLine('k',[],[],compassDir)
                plot(EndPt(i2,1),EndPt(i2,2),'r.')
                plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','r')
                plot(EndPt(is,1),EndPt(is,2),'b.')
                plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','b')
                inps=intersect(ins,i2);
                plot(EndPt(inps,1),EndPt(inps,2),'bo')
                for j=1:length(ils)
                    ks=intersect(ils(j).is,i2);
                    plot(EndPt(ks,1),EndPt(ks,2),lcol(j,:))
                end
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
    end
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
    CompassAndLine('k',[],[],compassDir)
    iall=inds(1:nframe:end);
    plot(EndPt(iall,1),EndPt(iall,2),'b.')
    plot([Cents(iall,1) EndPt(iall,1)]',[Cents(iall,2) EndPt(iall,2)]','b')
    inps=intersect(ins,iall);
    plot(EndPt(inps,1),EndPt(inps,2),'bo')
    for j=1:length(ils)
        ks=intersect(ils(j).is,iall);
        plot(EndPt(ks,1),EndPt(ks,2),lcol(j,:))
    end
    % plot(Cents(i2,1),Cents(i2,2),'r')
    xlabel(fn)
    hold off;
    axis equal
    if(plot_it)
        if(i==1)
            hall=figure;
            PlotNestAndLMs(LM,LMWid,nest);
            hold on;
            CompassAndLine('k',[],[],compassDir)
        else figure(hall);
        end
        hold on;
        iall=inds(1:nframe:end);
        plot(Cents(:,1),Cents(:,2),'b')
        plot(EndPt(inps,1),EndPt(inps,2),'bo')
        for j=1:length(ils)
            ks=intersect(ils(j).is,iall);
            plot(EndPt(ks,1),EndPt(ks,2),lcol(j,:))
        end
        axis equal
        hold off
    end
    if(length(Picked)>1)
        title('press return to continue')
        inpi=input('press return to continue');
%     if(isempty(inpi)) zz(i)=0;
%     else zz(i)=1;
%     end
%     save zigzagin zz
    end
end
figure(hsing)

function[is]=GetTimes(t,Ts)
is=[];
for i=1:size(Ts,1)
    [m,si]=min(abs(t-Ts(i,1)));
    [m,ei]=min(abs(t-Ts(i,2)));
    is=[is si:ei];
end

% function MyCircle(x,y,Rad,NumPts)
% Function draws a circle of rradius rad at x,y

function MyCircle(x,y,Rad,col,NumPts)

if(length(x)==2)
    if(nargin<4) NumPts=50;
    else NumPts=col;
    end;
    if(nargin<3) col = 'b';
    else col=Rad;
    end;
    Rad=y;
    y=x(2);
    x=x(1);
else
    if(nargin<5) NumPts=50; end;
    if(nargin<4) col = 'b'; end;
end

Thetas=0:2*pi/NumPts:2*pi;
[Xs,Ys]=pol2cart(Thetas,Rad);
plot(Xs+x,Ys+y,col)

function[ins,ils]=LookingPts(ang,th,st);
% if(isempty(ang)) ins=[];
% else
    ang=ang*pi/180;
    n=st.sOr;
    d=abs(AngularDifference(n,ang(1)))*180/pi;
    d2=abs(AngularDifference(n,ang(1)))*180/pi;
    ins=find(d<th);
    ils(1).is=find(d2<th);
% end