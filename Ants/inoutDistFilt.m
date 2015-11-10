% inout plots ins vs outs
%
% first argument is a string to filter which files are picked
% so that eg: inout('27') would show only the 27 files.
%
% you can then select the raneg of data etc that you want to plot

function inoutDistFilt(fn)

if(nargin<1) load inoutDistData;
else load(fn)
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
                inp=input('press return to continue, 0 to stop, 1 to enter filtering angles');
                if(isequal(inp,0)) break; end;
                if(isequal(inp,1)) break; end;
            end
        end
        if(isequal(inp,0)) break; end;
        if(isequal(inp,1)) break; end;
    end
    if(isequal(inp,1))
        hold on;h=[];
        as=cart2pol(out(d).rl(k).Cents(:,1),out(d).rl(k).Cents(:,2));
        while 1
            rads=input('Enter angular vals for filtering, return to finish')
            if(isempty(rads)) break; 
            else 
                if(~isempty(h)) 
                    delete(h); 
                    delete(h2);
                end;
                r=rads*pi/180;
                [x1,y1]=pol2cart(r(1),m.BeeDists(d)+5);
                [x2,y2]=pol2cart(r(2),m.BeeDists(d)+5);
                h=plot([x1 0 x2],[y1 0 y2],'k:');
                is=find((as>r(1))&(as<=r(2)));
                h2=plot(e(is,1),e(is,2),['k.'],[c(is,1) e(is,1)]',[c(is,2) e(is,2)]','k');
            end
        end
        if(i==1) 
            rout=rads;
            fl_out=unique(outs(d).rl(k).flt(is));
        else 
            rin=rads;
            fl_in=unique(ins(d).rl(k).flt(is));
        end
        hold off;
    end
end

for i=1:2
    plo=1;
    if(i==1)
        out=outs;
        m=mouts;
        col='b';
    else
        out=ins;m=mins;
        col='r';
    end
    nLM=length(out(1).rl);
    for d=1:length(m.BeeDists)
        for k=1:length(out(d).rl)
            is=[];
            for fl=fl_out
                is=[is find(out(d).rl(k).flt==fl)];
            end
            figure(1)
            c=out(d).rl(k).Cents;
            if(plo&~isempty(c))
                e=out(d).rl(k).EndPt;
                plot(e(:,1),e(:,2),[col '.'],[c(:,1) e(:,1)]',[c(:,2) e(:,2)]',col)
                hold on;
                plot(e(is,1),e(is,2),['k.'],[c(is,1) e(is,1)]',[c(is,2) e(is,2)]','k');                PlotNestAndLMs(m.LM,m.LMWid,m.nest);
                CompassAndLine('k',[],[],0)
                axis equal,
                title(num2str(m.BeeDists(d)))
                hold off;
                inp=input('press return to continue, 0 to stop');
                if(isequal(inp,0)) plo=0; end;
            end

            nPts(d,k)=length(is);
            if(isempty(is))
                MeanOr(d,k)=NaN;LOr(d,k)=NaN;
                MeanNest(d,k)=NaN;LNest(d,k)=NaN;
                Mean2Nest(d,k)=NaN;L2Nest(d,k)=NaN;
                for j=1:nLM MeanLM(d,k,j)=NaN;LLM(d,k,j)=NaN; end
            else
                angs=[out(d).rl(k).os(is)]*pi/180;
                [MeanOr(d,k),LOr(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
                angs=[out(d).rl(k).nr(is)]*pi/180;
                [MeanNest(d,k),LNest(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
                angs=cart2pol(out(d).rl(k).Cents(is,1),out(d).rl(k).Cents(is,2));
                [Mean2Nest(d,k),L2Nest(d,k)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
                for j=1:nLM
                    angs=[out(d).rl(k).viewedL(j).angs(is)]*pi/180;
                    [MeanLM(d,k,j),LLM(d,k,j)]=cart2pol(mean(cos(angs)),mean(sin(angs)));
                end
            end
        end
    end
    if(i==1) 
        mouts.MeanOr=MeanOr;
        mouts.MeanNest=MeanNest;
        mouts.Mean2Nest=Mean2Nest;
        mouts.MeanLM=MeanLM;
        mouts.LOr=LOr;
        mouts.LNest=LNest;
        mouts.L2Nest=L2Nest;
        mouts.LLM=LLM;
        mouts.nPts=nPts;
    else
        mins.MeanOr=MeanOr;
        mins.MeanNest=MeanNest;
        mins.Mean2Nest=Mean2Nest;
        mins.MeanLM=MeanLM;
        mins.LOr=LOr;
        mins.LNest=LNest;
        mins.L2Nest=L2Nest;
        mins.LLM=LLM;
        mins.nPts=nPts;
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
    if(k==1) fh2=figure(4);
    else figure(fh2)
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
end
NumOuts=[mouts.nPts';mouts.nFlts']
NumInts=[mins.nPts';mins.nFlts']

% Get filtered means etc

%     % Density plots
%     m=2;
%     while(~isempty(m))
%         for j=1:nLM
%             [lmst,lmc]=LMStr(j,LM);
%             mi=min([outs(j).Cents;ins(j).Cents]);
%             ma=max([outs(j).Cents;ins(j).Cents]);
%             figure(3*nLM+2*j);BeePosPlot(outs(j).Cents,m,LM,LMWid,outs(1).nest,mi,ma)
%             title(['Positions when looking at ' lmst ' LM: Outs'],'Color',lmc);
%             figure(1+3*nLM+2*j);BeePosPlot(ins(j).Cents,m,LM,LMWid,outs(1).nest,mi,ma)
%             title(['Positions when looking at ' lmst ' LM: Ins'],'Color',lmc);
%         end
%         m=input('change spacing? return to end:   ');
%     end


function BeePosPlot(cs,m,LM,LMWid,nest,mi,ma)
% [d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[mi(1):m:ma(1)],[mi(2):m:ma(2)]);
if(isempty(cs)) return; end;
% [d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[300:m:1200],[100:m:1000]);
[d,a,b,x,y]=Density2D(cs(:,1),cs(:,2),[-55:m:55],[-55:m:55]);
d=d.*(d>1);
% [d,a,b,x,y]=Density2D(cs,[],m);
contourf(x,y,max(d(:))-d);
colormap gray
hold on;
PlotNestAndLMs(LM,LMWid,nest);
hold off
CompassAndLine('k',[],[],0)
axis equal