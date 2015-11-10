function BeeReturnDist(ddivs)
fn='DistLoopdataOuts.mat';
if(~isfile(fn)) DistanceLoops; end
load(fn); 

if(nargin<1) ddivs=[0:10:60]; end;
xs=-50:2.5:50;
ys=-50:2.5:50;
for i=1:length(ddivs)-1
    
    dst=[ma2miP.dstart];
    inds=find((dst>=ddivs(i))&(dst<ddivs(i+1)));
    cs=[];maxs=[];mins=[];
    for j=inds  
        cs=[cs;ma2miP(j).path]; 
        maxs=[maxs;ma2miP(j).path(1,:)];
        mins=[mins;ma2miP(j).path(end,:)];
    end
    if(~isempty(cs))
        [d,a,b,x1,y]=Density2D(cs(:,1),cs(:,2),xs,ys);
%     pts(i).cs=cs;
    figure(1)
    pcolor(x1,y,max(d(:))-d),shading flat
    contourf(x1,y,max(d(:))-d)
    colormap gray
    hold on,
    PlotNestAndLMs(LM,LMWid,[0 0],0);    
    h=MyCircle(0,0,ddivs(i+1),'r');
    set(h,'LineWidth',2)
    hold off
    title(['data returning from ' num2str(ddivs(i)) ' to ' num2str(ddivs(i+1))]);
    figure(2)
    dds=[CartDist(cs)]; 
    dma=CartDist(maxs); dmi=CartDist(mins);
    [y,x]=hist(dds,0:1:50);y=y/sum(y);
    [ymi,x]=hist(dmi,0:1:50);ymi=ymi/sum(ymi);
    [yma,x]=hist(dma,0:1:50);yma=yma/sum(yma);
    plot(x,y,x,yma,'k--',x,ymi,'r:o'),axis tight
    title(['distances (solid) mins (o), maxs (--) from ' num2str(ddivs(i)) ' to ' num2str(ddivs(i+1))]);
%     colormap gray
    end
disp(' ');
    disp('press any key to continue');
    pause
end