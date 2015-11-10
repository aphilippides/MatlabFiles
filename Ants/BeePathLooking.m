% function BeePathLooking(fn,th,ts,nframe,PPic)
%
% function to plot a bee path in file fn
% ts specifies which times to show (default all)
% nframe says to plot every nframe'th frame (default 1)
% set nframe < 0 to not plot iteratively
%
% PPic used to generate final figs for journal publication
%
% Examples:
% To plot the whole file do:                  BeePathLooking(fn,10)
% To plot times 3 to 14 do:                   BeePathLooking(fn,10,[3 14])
% To plot every 2nd frame from 1 to 10 do:    BeePathLooking(fn,20,[1 10],2)
% To plot every 3rd frame for whole file do:  BeePathLooking(fn,15,[],3)

function BeePathLooking(fn,th,ts,nframe,PPic)

if((nargin<1)||isempty(fn))
    s=dir('*All.mat');
    if(isempty(s))
        disp(' no *All.mat files in folder');
        return;
    end;
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers. Return to select all:   ');
    if(isempty(Picked)) 
        Picked=1:length(s); 
    end;
elseif(~isfile(fn))
    s=dir(['*' fn '*All.mat']);
    if(isempty(s))
        disp([' no files in folder matching: *' fn '*All.mat']);
        return;
    end;
    WriteFileOnScreen(s,1);
    Picked=input('select file numbers. Return to select all:   ');
    if(isempty(Picked)) 
        Picked=1:length(s); 
    end;
else
    Picked=-1;
end
lcol=['ro';'ko';'yo';'go'];
if((nargin<2)||isempty(th))
    disp(' ')
    disp('Enter range of retinal positions of nest/LMs as [r1 r2] in degrees.');
    th=input('Enter just r for [-r r], -r for nest only, or return to skip: ');
end
if(nargin<5) 
    PPic=0; 
end;

plot_it=1;
if((nargin<4)||isempty(nframe)) 
    nframe=1;
elseif(nframe<0)
    nframe=-nframe;
    plot_it=0;
end;

for i=1:length(Picked)
    if(Picked(i)>0)
        fn=s(Picked(i)).name;
    end
    load(fn)
    if(~exist('t','var')) 
        t=FrameNum*0.02; 
    end;
    if(~exist('sOr','var')) 
        sOr=TimeSmooth(ang_e,t,0.1); 
    end; 
    if(~exist('compassDir','var')) 
        compassDir=4.9393; 
    end;
    if(~exist('cmPerPix','var')) 
        cmPerPix=0.1; 
    end;

    if(nargin<3)
        disp(' ')
        disp(['Pick times between ' num2str(t(1)) ' and ' num2str(t(end))]);
        ts=input('Format is [t1 t2]. Return for all flight:  ');
        if(isempty(ts)) 
            inds=1:length(t);
        else
            inds=GetTimes(t,ts);
        end
    elseif(isempty(ts)) 
        inds=1:length(t);
    else
        inds=GetTimes(t,ts);
    end
    disp(' ')
    st=file2struct(fn);
    if(isempty(th)) 
        ins=[]; 
        ils=[];
    elseif((length(th)==1)&&(th<0)) 
        th=-1*th;
        [ins,ils]=LookingPts(th,[],st);
    else
        [ins,ils]=LookingPts(th,th,st);
    end

    [ep(:,1),ep(:,2)]=pol2cart(sOr,1.25/cmPerPix);
    EndPt=-ep+Cents;
    c=inds(1);
    pausing=1;
    sk=[];
    nc=max(4,nframe);
    if(i==1) 
        hsing=gcf;
    else figure(hsing);
    end

    if(plot_it)
        while(c<=inds(end))
            oc=c;
            c=c+nc;
            is=oc:nframe:min(c,inds(end));
            i2=inds(1):nframe:min(c,inds(end));

            if(pausing)
                PlotNestAndLMs(LM,LMWid,nest,0);
                hold on;
                plot(Cents(i2,1),Cents(i2,2),'r.')
                plot([Cents(i2,1) EndPt(i2,1)]',[Cents(i2,2) EndPt(i2,2)]','r')
                plot(Cents(is,1),Cents(is,2),'b.')
                plot([Cents(is,1) EndPt(is,1)]',[Cents(is,2) EndPt(is,2)]','b')
                inps=intersect(ins,i2);
                plot(Cents(inps,1),Cents(inps,2),'bo')
                for j=1:length(ils)
                    ks=intersect(ils(j).is,i2);
                    plot(Cents(ks,1),Cents(ks,2),lcol(j,:))
                end
                title(['time ' num2str(t(is(1))) ' to time ' num2str(t(is(end)))])
                xlabel(fn)
                axis equal;
                CompassAndLine('k',cmPerPix,[],compassDir)
                hold off;
                sk=input('return continue, 0 to end, # to show more frames at once');
            end
            if(sk==0) 
                pausing=0;
            elseif(isnumeric(sk)&&(~isempty(sk))) 
                nc=sk;
            end
        end
    end
    
    % plot all data
    bsize=18;
    LkSize=10;
    PlotNestAndLMs(LM,LMWid,nest,0,[],PPic);
    hold on;
    iall=inds(1:nframe:end);
    plot(Cents(iall,1),Cents(iall,2),'k.','MarkerSize',bsize)
    plot([Cents(iall,1) EndPt(iall,1)]',[Cents(iall,2) EndPt(iall,2)]','k')
    
    PlotLkPts(ins,iall,Cents,EndPt,ep,ils,lcol,bsize,LkSize,PPic)
    xlabel(fn)
    axis equal
    CompassAndLine('k',cmPerPix,[],compassDir)
    hold off;
    
    if(plot_it)
        if(i==1)
            hall=figure;
%             if(PPic) PrettyPic; end;
            PlotNestAndLMs(LM,LMWid,nest,0,[],PPic);
            hold on;
        else figure(hall);
        end
        hold on;
        iall=inds(1:nframe:end);
%         plot(Cents(:,1),Cents(:,2),'k- .')
        plot(Cents(iall,1),Cents(iall,2),'k- .')
        inps=intersect(ins,iall);
        if(PPic)
%             plot(Cents(inps,1),Cents(inps,2),'ko',)
            cp2=-ep+Cents;
            plot([Cents(inps,1) cp2(inps,1)]',[Cents(inps,2) cp2(inps,2)]','k')
            for j=1:length(ils)
                ks=intersect(ils(j).is,iall);
                if(j==1) 
                    plot(Cents(ks,1),Cents(ks,2),'ko','MarkerSize',LkSize)
                elseif(j==2) 
                    plot(Cents(ks,1),Cents(ks,2),'k*','MarkerSize',LkSize)
                else
                    plot(Cents(ks,1),Cents(ks,2),[lcol(j,1) '.'])
                end
            end
        else
            plot(Cents(inps,1),Cents(inps,2),'b.')
            for j=1:length(ils)
                ks=intersect(ils(j).is,iall);
                plot(Cents(ks,1),Cents(ks,2),[lcol(j,1) '.'])
            end
        end
        axis equal
        if(i==1) 
            CompassAndLine('k',cmPerPix,[],compassDir); 
        end;
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
if(PPic)
    
    outf=[fn(1:end-7) 'Time' num2str(ts(1)) '_' num2str(ts(2))];
    PrettyPic;
    saveas(gcf,[outf 'Flight'], 'fig')
    saveas(gcf,[outf 'Flight'], 'ai')
    figure(hsing)
    saveas(gcf,[outf 'BallStick'], 'fig')
    saveas(gcf,[outf 'BallStick'], 'ai')
    PrettyPic;
end
figure(hsing)
    
function PrettyPic
SetXTicks(gca,0);
SetYTicks(gca,0);
a = findall(gcf);
d = findall(a,'Type','text');
set(d,'FontName','Arial');
% set(gcf,'FontName','Arial','FontSize',10)
% set(gca,'FontName','Arial','FontSize',8)


function PlotLkPts(ins,iall,Cents,EndPt,ep,ils,lcol,bsize,LkSize,PPic)
inps=intersect(ins,iall);
%     plot(EndPt(inps,1),EndPt(inps,2),'bo')
if(PPic)
    cp2=-2*ep+Cents;
    plot([Cents(inps,1) cp2(inps,1)]',[Cents(inps,2) cp2(inps,2)]','k','LineWidth',2)
else
    plot(Cents(inps,1),Cents(inps,2),'b.','MarkerSize',bsize)
    plot([Cents(inps,1) EndPt(inps,1)]',[Cents(inps,2) EndPt(inps,2)]','b')
end;

for j=1:length(ils)
    ks=intersect(ils(j).is,iall);
    if((j<3)&&PPic)
        if(j==1) 
            plot(Cents(ks,1),Cents(ks,2),'ko','MarkerSize',LkSize)
        else
            plot(Cents(ks,1),Cents(ks,2),'k*','MarkerSize',LkSize)
        end;
        plot([Cents(ks,1) EndPt(ks,1)]',[Cents(ks,2) EndPt(ks,2)]','k')
    else
        plot(Cents(ks,1),Cents(ks,2),[lcol(j,1) '.'],'MarkerSize',bsize)
        plot([Cents(ks,1) EndPt(ks,1)]',[Cents(ks,2) EndPt(ks,2)]',lcol(j,1))
    end
end


function[is]=GetTimes(t,Ts)
is=[];
for i=1:size(Ts,1)
    [m,si]=min(abs(t-Ts(i,1)));
    [m,ei]=min(abs(t-Ts(i,2)));
    is=[is si:ei];
end


function[ins,ils]=LookingPts(ns,ls,st)
if(isempty(ns)) 
    ins=[];
else
    if(length(ns)==1) ns=[-ns ns]; end;
    ns=ns*pi/180;
    n=st.NestOnRetina;
    ins=find((n>=ns(1))&(n<ns(2)));
end

for i=1:length(st.LMs) LMs(i,:)=st.LMs(i).LM; end;
if(isempty(ls)) ils=[];
else
    if(length(ls)==1) ls=[-ls ls]; end;
    ls=ls*pi/180;
    lmo=LMOrder(LMs);
    for i=1:length(st.LMs)
        ll=st.LMs(i).LMOnRetina;
        ils(lmo(i)).is=find((ll>=ls(1))&(ll<ls(2)));
    end
end