function PlotP1P2LinesG1(i,MLines,BLines,fbsline,axlen,NextETUp,NextETD)

% n=min(100,0.01*i);
% n=max(100,0.01*axlen);
n=0.01*axlen;
% ab=0.115*axlen;
ab=0.075*axlen;
n2=0.11*axlen;
% n2=2*n+ab;

darkG=[0 0.5 0];
purpl=[1 0 1];

% Next Poss midlines
if(~isempty(NextETUp)) 
    plot([NextETUp(1,1) i],[NextETUp(1,2) NextETUp(1,2)],'b','LineWidth',2);
    text(i+n+ab,NextETUp(1,2),int2str(NextETUp(1,3)),'Color','b')
end
if(~isempty(NextETD)) 
    plot([NextETD(1,1) i],[NextETD(1,2) NextETD(1,2)],'r','LineWidth',2);
    text(i+n,NextETD(1,2),int2str(NextETD(1,3)),'Color','r')
end

% Mid lines
if(~isempty(MLines))
    [ord is]=sort([MLines(:,3)]);
    for k=1:length(is) ord(k)=find(is==k); end;
    adds=mod(ord,2)*ab;
    plot([MLines(1,1) i],[MLines(1,2) MLines(1,2)],'g','LineWidth',2);
    text(i+n+adds(1),MLines(1,2),int2str(MLines(1,3)),'Color',darkG)
    nl=size(MLines,1)-1;
%     for k=2:nl
%         plot([MLines(k,1) i],[MLines(k,2) MLines(k,2)],'m');
%         text(i+n+adds(k),MLines(k,2),int2str(MLines(k,3)),'Color',purpl)
%     end
    if(nl>0)
        plot([MLines(end,1) i],[MLines(end,2) MLines(end,2)],'m','LineWidth',2);
        text(i+n+adds(end),MLines(end,2),int2str(MLines(end,3)),'Color',purpl)
    end
end;

% fast buy sell line
if(length(fbsline.xs)==2)
    plot(fbsline.xs,fbsline.ys,'k')
end
% % box lines
% if(~isempty(BLines))
%     [ord is]=sort([BLines(:,3)]);
%     for k=1:length(is) ord(k)=find(is==k); end;
%     adds=mod(ord,2)*ab;
%     nl=size(BLines,1)-1;
%     plot([BLines(1,1) i],[BLines(1,2) BLines(1,2)],'c','LineWidth',2);
%     text(axst-n2-adds(1),BLines(1,2),int2str(BLines(1,3)),'Color',purpl)
%     for k=2:nl
%         plot([BLines(k,1) i],[BLines(k,2) BLines(k,2)],'c');
%         text(axst-n2-adds(k),BLines(k,2),int2str(BLines(k,3)),'Color',purpl)
%     end
%     if(nl>0)
%         plot([BLines(end,1) i],[BLines(end,2) BLines(end,2)],'c','LineWidth',2);
%         text(axst-n2-adds(end),BLines(end,2),int2str(BLines(end,3)),'Color',purpl)
%     end
% end;