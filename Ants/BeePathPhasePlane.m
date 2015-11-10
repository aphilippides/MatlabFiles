% function BeePathLooking(fn,th,ts,nframe,PPic)
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

function BeePathPhasePlane(fn,th,ts,nframe,PPic)

msize=6;

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
lcol=['rs';'ks';'ys';'gs'];
% if(nargin<2)
%     disp(' ')
%     disp('Enter range of retinal positions of nest/LMs as [r1 r2] in degrees.');
%     th=input('Enter just r for [-r r] or return to skip: ');
% end
th=10;
if(nargin<5) PPic=0; end;
plot_it=1;
if(nargin<4) nframe=1;
elseif(nframe<0)
    nframe=-nframe;
    plot_it=0;
end;

for i=1:length(Picked)
    fn=s(Picked(i)).name;
    load(fn)
    if(~exist('compassDir')) 
        compassDir=4.9393; 
    end;
    if(exist('cmPerPix'))
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,cmPerPix,compassDir);
    else
        [nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr_sc,sc,Speeds,Vels,Cent_Os,OToNest]= ...
            ReScaleDataExpt2(nest,LM,LMWid,DToNest,Cents,EndPt,LMs,sOr,fn,t,OToNest,[],[]);
    end
    fdif=AngularDifference(Cent_Os,sOr_sc)*180/pi;
    nlm=length(LMs);
    lmo=LMOrder(LM);

    if(nargin<3)
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
    else [ins,ils]=LookingPts(th,th,st);
    end

    [EndPt(:,1) EndPt(:,2)]=pol2cart(sOr,1);
    EndPt=EndPt+Cents;
    c=inds(1);
    pausing=1;
    sk=[];
    nc=max(4,nframe);
    if(i==1) hsing=gcf;
    else figure(hsing);
    end

    tps=[];
    curr_n=ceil(t(c));
    startn=curr_n;
    nor=NestOnRetina*180/pi;
    lor1=LMs(lmo(1)).LMOnRetina*180/pi;
    if(nlm>1) lor2=LMs(lmo(2)).LMOnRetina*180/pi; end;
    if(plot_it)
        while(c<=inds(end))
            oc=c;
            c=c+nc;
            endp=min(c,inds(end));
            is=oc:endp;
            i2=inds(1):endp;
            isx=oc:nframe:endp;
            i2x=inds(1):nframe:endp;
            
            if(pausing)
                subplot(2,2,1)
                PlotNestAndLMs(LM,LMWid,nest);
                hold on;
%                 CompassAndLine('k',[],[],compassDir)
                plot(EndPt(i2x,1),EndPt(i2x,2),'r.')
                plot([Cents(i2x,1) EndPt(i2x,1)]',[Cents(i2x,2) EndPt(i2x,2)]','r')
                plot(EndPt(isx,1),EndPt(isx,2),'b.')
                plot([Cents(isx,1) EndPt(isx,1)]',[Cents(isx,2) EndPt(isx,2)]','b')
%                 inps=intersect(ins,i2);
%                 plot(EndPt(inps,1),EndPt(inps,2),'bo')
%                 for j=1:length(ils)
%                     ks(j).i=intersect(ils(j).is,i2);
%                     plot(EndPt(ks(j).i,1),EndPt(ks(j).i,2),lcol(j,:))
%                 end
                title(['time ' num2str(t(is(1))) ' to time ' num2str(t(is(end)))])
                if(t(is(end))>=curr_n)
                    tps=[tps;is(end) curr_n];
                    curr_n=curr_n+1;
                end
                if(~isempty(tps)) text(Cents(tps(:,1),1),Cents(tps(:,1),2),int2str(tps(:,2))); end;
                xlabel(fn)
                axis equal;
                hold off;
                subplot(2,2,2),
                plot(nor(i2),fdif(i2),'r- .',nor(is),fdif(is),'b- .','MarkerSize',msize)%,nor(inps),fdif(inps),'bo')%,axis equal
                if(~isempty(tps)) text(nor(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
                xlabel('Nest on retina')
                subplot(2,2,3)
                plot(lor1(i2),fdif(i2),'r- .',lor1(is),fdif(is),'b- .','MarkerSize',msize)%,lor1(ks(1).i),fdif(ks(1).i),lcol(1,:))%,axis equal
                xlabel('N/single LM on retina')
                if(~isempty(tps)) text(lor1(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
                if(nlm>1)
                    subplot(2,2,4)
                    plot(lor2(i2),fdif(i2),'r- .',lor2(is),fdif(is),'b- .','MarkerSize',msize)%,lor2(ks(2).i),fdif(ks(2).i),lcol(2,:))%,axis equal
                    if(~isempty(tps)) text(lor2(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
                    xlabel('S/second LM on retina')
                end
               sk=input('return continue, 0 to end, # to show more frames at once');
            end
            if(sk==0) pausing=0;
            elseif(isnumeric(sk)&~isempty(sk)) nc=sk;
            end
        end
    end
    subplot(2,2,1)
    PlotNestAndLMs(LM,LMWid,nest);
    hold on;
%     CompassAndLine('k',[],[],compassDir)
    iall=inds(1:nframe:end);
    plot(EndPt(iall,1),EndPt(iall,2),'b.')
    plot([Cents(iall,1) EndPt(iall,1)]',[Cents(iall,2) EndPt(iall,2)]','b')
%     inps=intersect(ins,iall);
%     plot(EndPt(ins,1),EndPt(ins,2),'bo')
%     for j=1:length(ils)
%         ks=ils(j).is;%intersect(ils(j).is,iall);
%         plot(EndPt(ks,1),EndPt(ks,2),lcol(j,:))
%     end
    ns=startn:floor(t(iall(end)));
    ips=GetTimes(t,ns');
    tps=[ips' ns']; 
    if(~isempty(tps)) text(Cents(tps(:,1),1),Cents(tps(:,1),2),int2str(tps(:,2))); end;
    xlabel(fn)
    hold off;
    axis equal
    subplot(2,2,2),
    plot(nor(inds),fdif(inds),'b- .','MarkerSize',msize)%,nor(ins),fdif(ins),'bo')
    if(~isempty(tps)) text(nor(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
    title('Nest on retina')
    subplot(2,2,3)
    plot(lor1(inds),fdif(inds),'b- .','MarkerSize',msize)%,lor1(ils(1).is),fdif(ils(1).is),lcol(1,:))
    if(~isempty(tps)) text(lor1(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
    xlabel('N/single LM on retina')
    if(nlm>1)
        subplot(2,2,4)
        plot(lor2(inds),fdif(inds),'b- .','MarkerSize',msize)%,lor2(ils(2).is),fdif(ils(2).is),lcol(2,:))
        if(~isempty(tps)) text(lor2(tps(:,1)),fdif(tps(:,1)),int2str(tps(:,2))); end;
        xlabel('S/second LM on retina')
    end
%     figure(2),
%     subplot(2,1,1)
%     ti=t(inds);
%     plot(ti,fdif(inds),'k',ti,Cent_Os(inds)*180/pi,'r',ti,sOr_sc(inds)*180/pi)
%     subplot(2,1,2)
%     if(nlm>1) plot(ti,nor(inds),'k',ti,lor1(inds),ti,lor2(inds),'r')
%     else plot(ti,nor(inds),'k',ti,lor1(inds))
%     end
%     if(plot_it)
%         if(i==1)
%             hall=figure;
%             PlotNestAndLMs(LM,LMWid,nest);
%             hold on;
%             CompassAndLine('k',[],[],compassDir)
%         else figure(hall);
%         end
%         hold on;
%         iall=inds(1:nframe:end);
%         plot(Cents(:,1),Cents(:,2),'b')
%         plot(EndPt(ins,1),EndPt(ins,2),'bo')
%         for j=1:length(ils)
%             ks=ils(j).is;%intersect(ils(j).is,iall);
%             plot(EndPt(ks,1),EndPt(ks,2),lcol(j,:))
%         end
%         axis equal
%         hold off
%     end
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

function[ins,ils]=LookingPts(ns,ls,st);
if(isempty(ns)) ins=[];
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