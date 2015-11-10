% inout plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: inout('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function inoutDist(fbit,dinc,aso,alo,hrs,ndiv)
tso=[];
tsi=[];
if((nargin<1)) fbit=[]; end;
if(nargin<6) ndiv=10;end;

% if((nargin<3)|isempty(or)) or=[];
%     disp('Enter range of orientations in DEGREES as [a b] between 0 and 360');
%     or=input('Enter return for all flight: ');
% end;

% out stuff
if((nargin<2)|isempty(dinc))
    disp('  ');
    while 1
        dinc=input('Enter distance increments from nest in cm:  ');
        if(length(dinc)==1) break; end
    end
end;
if((nargin<3)|isempty(aso))
    disp('  ');
    disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
    aso=input('Enter just: r for [-r r] or return for all flight: ');
end;
% if((nargin<6)|isempty(tso))
%     disp('  ');
%     %     disp('Enter times as [t1 t2] in the range [' num2str([min(t) max(t)]) '].']);
%     disp('Enter times as [t1 t2] in secs.');
%     tso=input('Enter just t for [0 t] or return for all flight: ');
% end;
if((nargin<4)|isempty(alo))
    disp('  ');
    disp('Enter range of retinal positions of LMs as [r1 r2] in degrees.');
    alo=input('Enter just: r for [-r r] or return for all flight: ');
end;
if((nargin<5)|isempty(hrs))
    disp('  ');
    disp('Enter hours of day in 24 hr format as [h1 h2] in hours.');
    hrs=input('Enter return for all flight: ');
    if(isempty(hrs)) hrs=0; end;
end;

% % in stuff
% if((nargin<3)|isempty(din))
%     disp('  ');disp('INS:')
%     %     disp('Enter range of distances from nest as [d1 d2] in cm, max ' num2str);
%     disp('Enter range of distances from nest as [d1 d2] in cm.');
%     din=input('Enter just: d for [0 d] or return for all flight: ');
% end;
% if((nargin<5)|isempty(asi))
%     disp('  ');
%     disp('Enter range of retinal positions of nest as [r1 r2] in degrees.');
%     asi=input('Enter just: r for [-r r] or return for all flight: ');
% end;
% if((nargin<6)|isempty(tsi))
%     disp('  ');
%     disp('Enter times as [t1 t2] in secs.');
%     tsi=input('Enter just t for last t secs or return for all flight: ');
%     %     if(length(tsi==1)) tsi=-tsi;
% end;
% if((nargin<9)|isempty(ali))
%     disp('  ');
%     disp('Enter range of retinal positions of LMs as [r1 r2] in degrees.');
%     ali=input('Enter just: r for [-r r] or return for all flight: ');
% end;

[outs,mouts,outfs]=histdataLMDist([fbit '*out'],dinc,0,aso,tso,alo,hrs);
[ins,mins,infs]=histdataLMDist([fbit '*in'],dinc,0,aso,tso,alo,hrs);

% save inoutDist2EastAllLMLooking.mat
% if(isequal(hrs,0)) outna='inoutDist';
% else outna=['inoutDist' num2str(hrs(1))
% end
disp('')
fnsave=input('Save as: inoutDist*.mat, return to skip:  ','s');
if(isempty(fnsave))
    save inoutDistData
else save(['inoutDist' fnsave '.mat']);
end

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
    for k=1:nLM
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
                inp=input('press return to continue, 0 to stop');
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
    figure,pcolor(mouts.BeeDists,[-170:10:180],fo_out(k).fs')
    title(['OUTS: Body Orientation when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Orientation (degrees, N=0)')
	figure,pcolor(mouts.BeeDists,[-170:10:180],fo_in(k).fs')
    title(['INS: Body Orientation when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Orientation (degrees, N=0)')
    figure,pcolor(mouts.BeeDists,[-170:10:180],frn_out(k).fs')
    title(['OUTS: Retinal nest position when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')
    figure,pcolor(mouts.BeeDists,[-170:10:180],frn_in(k).fs')
    title(['INS: Retinal nest position when looking at ' lmst],'Color',lmc)
    xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
    for j=1:nl 
        figure,pcolor(mouts.BeeDists,[-170:10:180],frl_out(k,j).fs')
        lms=LMStr(j,mouts.LM(lmo,:));
        title(['OUTS: ' lms ' LM on Retina when looking at ' lmst],'Color',lmc)
        xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
        figure,pcolor(mouts.BeeDists,[-170:10:180],frl_in(k,j).fs')
        lms=LMStr(j,mouts.LM(lmo,:));
        title(['INS: ' lms ' LM on Retina when looking at ' lmst],'Color',lmc)
        xlabel('distance (cm)');ylabel('Position (degrees, 0=facing)')    
    end
end
NumOuts=[mouts.nPts';mouts.nFlts']
NumIns=[mins.nPts';mins.nFlts']
% Density plots
m=3;
while(~isempty(m)||(m==0))
    BeePosPlot(outs,mouts.BeeDists,mouts.LM,mouts.LMWid,mouts.nest,m,'outs')
    m=input('change spacing? return to end:   ');
end
m=3;
while(~isempty(m)||(m==0))
    BeePosPlot(ins,mins.BeeDists,mins.LM,mins.LMWid,mins.nest,m,'ins')
    m=input('change spacing? return to end:   ');
end

% funcrtion

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
    figure(h2(k)),pcolor(sumd),colorbar
    set(gca,'YDir','reverse')
    title([ts ';  total relative frequency'])
end