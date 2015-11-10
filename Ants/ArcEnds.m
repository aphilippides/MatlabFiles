% ino plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: ino('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function ArcEnds(fn,dout,Plotting)

if(nargin<1) fn=['out']; end;
if(nargin<3) Plotting=0; end;

if(isequal('out',fn)) ino=0;
else ino=1;% elseif(isequal('in',fn)) ino=1;
end

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

% out stuff
if((nargin<2)|isempty(dout))
    disp('  ');
    disp('Enter range of distances from nest as [d1 d2] in cm.');
    %     disp('Enter a negative value -d for [d end].');
    dout=input('Enter: d for [0 d], -d for [d inf], return for all flight: ');
end;
if(isempty(dout)) dout=[0 1e6];
elseif(length(dout)==1)
    if(dout>0) dout=[0 dout];
    else dout=[-dout 1e6];
    end
end

angs=[];cs=[];ep=[];lor=[];ns=[];
for i=1:4 lm(i).lm=[]; end

for j=1:length(fn)
    j
    load(fn(j).name);
    lmo=LMOrder(LM)
    if(exist('cmPerPix'))
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,cmPerPix,compassDir);
    else
    [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,so_resc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
        ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn(j).name,t,OToNest,[],[]);
    end
    angtest=OToNest;
    if(Plotting)
        figure(2);
        arcs=SelectArcs(angtest,t,0.349,0.05);
    else arcs=SelectArcs(angtest,t,0.349,0.05,0);
    end
    if(~isempty(arcs))
        ds=DToNest(arcs(:,3));
        inds=find((ds>=dout(1))&(ds<dout(2)));
        is=arcs(inds,3);
%         angs=[angs mod(arcs(:,2),2*pi)'*180/pi];
        angs=[angs so_resc(is)*180/pi];
        cs=[cs;Cents(is,:)];
        ep=[ep;EndPt(is,:)];
        ns=[ns mod(NestOnRetina(is),2*pi)'*180/pi];
        for i=1:length(LMs)
            lm(lmo(i)).lm=[lm(lmo(i)).lm mod(LMs(i).LMOnRetina(is),2*pi)'*180/pi];
        end
        if(Plotting)
            figure(1)
            AngHist(angs,0:10:360);
            title('Heading')
            figure(2)
            PlotBee(cs,ep)
            hold on;
            PlotNestAndLMs(LM,LMWid,nest);
            hold off
            figure(3);
            AngHist(ns,0:10:360);
            title('Retinal position of Nest')
            for i=1:length(LMs)
                figure(3+i)
                AngHist(lm(i).lm,0:10:360);
                [lms,lc]=LMStr(i,LM(lmo,:));
                title(['retinal position of ' lms ' LM'],'Color',lc)
            end
        end
    end
    save ArcEndsData
end
figure(1)
[y,x]=AngHist(angs,0:10:360);
title('Heading')
figure(2)
PlotBee(cs,ep)
hold on;
PlotNestAndLMs(LM,LMWid,nest);
CompassAndLine('k',[],[],0)
hold off
figure(3);
AngHist(ns,0:10:360);
title('Retinal position of Nest')
for i=1:length(LMs)
    figure(3+i)
    AngHist(lm(i).lm,0:10:360);
    [lms,lc]=LMStr(i,LM(lmo,:));
    title(['retinal position of ' lms ' LM'],'Color',lc)
end
% LMAngs=mod(cart2pol(LM(:,1)-nest(1),LM(:,2)-nest(2)),2*pi)*180/pi

function dummybit
    if(isempty(dout)) is=1:length(DToNest);
    elseif(length(dout==1))
        if(ino==1)
            g = find(DToNest<abs(dout),1);
            if(dout<0) is=1:g;
            else is=g:length(DToNest);
            end
        else
            g = find(DToNest>=abs(dout),1);
			if(dout>0) is=1:g;
            else is=g:length(DToNest);
            end
        end
        
    else is = find((DToNest>=dout(1))&(DToNest<(dout(2))));
    end