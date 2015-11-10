% inout plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: inout('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function PlotinoutDist(fbit)
if(nargin<1)
    s=dir(['inoutDist*.mat']);
    WriteFileOnScreen(s,1);
    Picked=input('select file number to load:   ');
    if(isempty(Picked)) return;
    else load(s(Picked).name);
    end
else load(fbit);
end

DLim=50;

for i=1:2
    if(i==1)
        out=outs;
        m=mouts;
        col='b';
    else
        out=ins;m=mins;
        col='r';
    end
    nLM=length(out(1).rl);
    figure(1)
    for k=1:0%nLM
        for d=1:length(m.BeeDists)
            c=out(d).rl(k).Cents;
            if(~isempty(c))
                e=out(d).rl(k).EndPt;
                plot(e(:,1),e(:,2),[col '.'],[c(:,1) e(:,1)]',[c(:,2) e(:,2)]',col)
                hold on;
                PlotNestAndLMs(m.LM,m.LMWid,m.nest);
                CompassAndLine('k',[],[],0)
                axis equal,
                title(num2str(m.BeeDists(d)))
                hold off;
                inp=input('press return to continue, 0 to stop: ');
                if(isequal(inp,0)) break; end;
            end
        end
        if(isequal(inp,0)) break; end;
    end
end
f=100;
lmo=LMOrder(mouts.LM);
for k=1:nLM
    if(k==1) fh1=figure(2);
    else figure(fh1)
    end;
    subplot(nLM,1,k)
    errorbar(mouts.BeeDists,mouts.MeanOr(:,k)*180/pi,f*(1-mouts.LOr(:,k)));
    hold on;
    errorbar(mins.BeeDists,mins.MeanOr(:,k)*180/pi,f*(1-mins.LOr(:,k)),'r');
    hold off;
    if(isempty(alo))
        if(isempty(aso)) lmst='nothing';lmc='b';
        else lmst='nest';lmc='b';
        end
    else [lmst,lmc]=LMStr(k,mouts.LM(lmo,:)); lmst=[lmst  ' LM'];
    end
    axis tight,
    title(['Orientation when looking at ' lmst],'Color',lmc)
    if(k==1) fh2=figure(3);
    else figure(fh2)
    end;
    subplot(nLM,1,k)
    errorbar(mouts.BeeDists,mouts.MeanNest(:,k)*180/pi,f*(1-mouts.LNest(:,k)));
    hold on;
    errorbar(mins.BeeDists,mins.MeanNest(:,k)*180/pi,f*(1-mins.LNest(:,k)),'r');
    hold off;
    axis tight, title(['Retinal position of nest when looking at ' lmst],'Color',lmc)
    if(k==1) fh3=figure(4);
    else figure(fh3)
    end;
    subplot(nLM,1,k)
    errorbar(mouts.BeeDists,mouts.Mean2Nest(:,k)*180/pi,f*(1-mouts.L2Nest(:,k)));
    hold on;
    errorbar(mins.BeeDists,mins.Mean2Nest(:,k)*180/pi,f*(1-mins.L2Nest(:,k)),'r');
    hold off;
    axis tight, title(['Angular position relative to nest when looking at ' lmst],'Color',lmc)
    for j=1:size(mouts.MeanLM,3)
        if(k==1) fh(j)=figure(4+j);
        else figure(fh(j))
        end;
        subplot(nLM,1,k)
        errorbar(mouts.BeeDists,mouts.MeanLM(:,k,j)*180/pi,f*(1-mouts.LLM(:,k,j)));
        hold on;
        errorbar(mins.BeeDists,mins.MeanLM(:,k,j)*180/pi,f*(1-mins.LLM(:,k,j)),'r');
        hold off;
        axis tight,
        lms=LMStr(j,mouts.LM(lmo,:));
        title([lms ' LM on Retina when looking at ' lmst],'Color',lmc)
    end
    
    % hack to make N plot in centre of the graph
    kk=([19:36 1:18]);
    nl=size(outs(1).rl(k).frls,1);
    fo_out(k).fs=zeros(length(outs),length(outs(i).rl(k).fos));
    frn_out(k).fs=fo_out(k).fs;
    fo_in(k).fs=zeros(length(ins),length(ins(i).rl(k).fos));
    frn_in(k).fs=fo_in(k).fs;
    for j=1:nl
        frl_out(k,j).fs=zeros(length(outs),length(outs(i).rl(k).fos));
        frl_in(k,j).fs=zeros(length(ins),length(ins(i).rl(k).fos));
    end
    for i=1:length(outs)
        if((mouts.nFlts(i)>2)&(mouts.nPts(i)>5))
            fo_out(k).fs(i,:)=outs(i).rl(k).fos(kk)/mouts.nPts(i);
            frn_out(k).fs(i,:)=outs(i).rl(k).frns/mouts.nPts(i);
            for j=1:nl
                frl_out(k,j).fs(i,:)=outs(i).rl(k).frls(j,:)/mouts.nPts(i);
            end
        end
        if((mins.nFlts(i)>2)&(mins.nPts(i)>5))
            fo_in(k).fs(i,:)=ins(i).rl(k).fos(kk)/mins.nPts(i);
            frn_in(k).fs(i,:)=ins(i).rl(k).frns/mins.nPts(i);
            for j=1:nl
                frl_in(k,j).fs(i,:)=ins(i).rl(k).frls(j,:)/mins.nPts(i);
            end
        end
    end
    ds=find(mouts.BeeDists<=DLim);
    figure,pcolor(mouts.BeeDists(ds),[-170:10:180],fo_out(k).fs(ds,:)')
    title(['OUTS: Body Orientation when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Orientation (degrees, N=0)')
	figure,pcolor(mouts.BeeDists(ds),[-170:10:180],fo_in(k).fs(ds,:)')
    title(['INS: Body Orientation when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Orientation (degrees, N=0)')
    figure,pcolor(mouts.BeeDists(ds),[-170:10:180],frn_out(k).fs(ds,:)')
    title(['OUTS: Retinal nest position when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')
    figure,pcolor(mouts.BeeDists(ds),[-170:10:180],frn_in(k).fs(ds,:)')
    title(['INS: Retinal nest position when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
    for j=1:nl 
        figure,pcolor(mouts.BeeDists(ds),[-170:10:180],frl_out(k,j).fs(ds,:)')
        lms=LMStr(j,mouts.LM(lmo,:));
        title(['OUTS: ' lms ' LM on Retina when looking at ' lmst],'Color',lmc)
        xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
        figure,pcolor(mouts.BeeDists(ds),[-170:10:180],frl_in(k,j).fs(ds,:)')
        lms=LMStr(j,mouts.LM(lmo,:));
        title(['INS: ' lms ' LM on Retina when looking at ' lmst],'Color',lmc)
        xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
    end
end
NumOuts=[mouts.nPts';mouts.nFlts']
NumIns=[mins.nPts';mins.nFlts']

% Density plots
m=3;
while(~isempty(m))
    BeePosPlot(outs,mouts.BeeDists,mouts.LM,mouts.LMWid,mouts.nest,m,'outs')
    m=input('change spacing? return to end:   ');
end
m=3;
while(~isempty(m))
    BeePosPlot(ins,mins.BeeDists,mins.LM,mins.LMWid,mins.nest,m,'ins')
    m=input('change spacing? return to end:   ');
end


function BeePosPlot(outs,ds,LM,LMWid,nest,m,Tstr)
gr=[-55:m:55];
sumd=zeros(length(gr)-1,length(gr)-1);
nLM=length(outs(1).rl);
h1=figure;
h2=figure;
lmo=LMOrder(LM);
for k=1:nLM
    if(nLM==1)     
        ts=[Tstr ': looking at nest']; 

    else
    [lmst,lmc]=LMStr(k,LM(lmo,:));
    ts=[Tstr ': looking at ' lmst ' LM']; 
    end
    inp=[];
    h1(k)=figure;
    h2(k)=figure;
    for d=2:length(ds)
        cs=outs(d).rl(k).Cents;
        nf(d)=size(cs,1);
        if(nf(d)>0)
            [den,a,b,x,y]=Density2D(cs(:,1),cs(:,2),gr,gr);
            md(d)=max(den(:));
            if(md(d)>0)
                dens(d).d=den/md(d);
                sumd=sumd+dens(d).d;
                if(isempty(inp))
                    figure(h1(k)),pcolor(x,y,den/md(d))
                    set(gca,'YDir','reverse') 
                    title([ts ';  single distances'])
                    figure(h2(k)),pcolor(x,y,sumd),colorbar
                    set(gca,'YDir','reverse') 
                    title([ts ';  total relative frequency'])
                    inp=input('press return to continue, 0 to stop;  ');
                end
            end
        else dens(d).d=zeros(size(sumd));
        end
    end
    figure(h2(k)),pcolor(x,y,sumd),colorbar
    set(gca,'YDir','reverse')
    title([ts ';  total relative frequency'])
end