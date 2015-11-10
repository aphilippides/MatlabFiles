function PlotP1P2LinesMid(i,l1line,l2line,exl1,exl2,Hi2Day,Low1Day,...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,...
    MLines,BLines,oBox,sp,axlen,opt,axst,ask,bid)

% n=min(100,0.01*i);
% n=max(100,0.01*axlen);
n=0.01*axlen;
% ab=0.115*axlen;
ab=0.075*axlen;
n2=0.11*axlen;
% n2=2*n+ab;

darkG=[0 0.5 0];
purpl=[1 0 1];

% % DrawBox
% if(size(oBox,1)==2)
%     st=oBox(1,1);
%     y1=oBox(1,2);
%     y2=oBox(2,2);
%     patch([st st i i st],[y1 y2 y2 y1 y1],'w')
%     plot([st st i i st],[y1 y2 y2 y1 y1],'g')
% end

% l1 line
% current active one
if(l1line.p1(2)~=1e9)
    plot([l1line.p1(1),l1line.p2(1),i],[l1line.p1(2),l1line.p2(2),exl1],'b-','LineWidth',2);
    plot([l1line.p1(1),l1line.p2(1),i],[l1line.p1(2),l1line.p2(2),exl1]-sp,'b:','LineWidth',2);
    plot(l1line.low(1),l1line.low(2),'bo')%,'MarkerFaceColor','b')
end
for k=1:size(DLinesL1,1)
    ex=DLinesL1(k).p1(2)+(i-DLinesL1(k).p1(1))*DLinesL1(k).gr;
    plot([DLinesL1(k).p1(1) i],[DLinesL1(k).p1(2) ex],'b');
end
% new points and low points
plot([l1line.p1new(1),l1line.p2new(1)],[l1line.p1new(2),l1line.p2new(2)],'go')%,'MarkerFaceColor','g');
plot(l1line.currlow(1),l1line.currlow(2),'gx',l1line.lownew(1),l1line.lownew(2),'gd')%,'MarkerFaceColor','g');

BoxFlag=-1;
nhl1=size(HLinesL1,1);
nhl2=size(HLinesL2,1);
% Mid lines
if(~isempty(MLines))
    plot([MLines(1,1) i],[MLines(1,2) MLines(1,2)],'g','LineWidth',2);
    text(axst-n2,MLines(1,2),int2str(MLines(1,3)),'Color',darkG)
    
    % Check whether to plot more lines
    if((ask>MLines(1,3))&&(nhl2>2)) BoxFlag=0;
    elseif((bid<MLines(1,3))&&(nhl1>2)) BoxFlag=1;
    end
    
%     [ord is]=sort([MLines(:,3)]);
%     for k=1:length(is) ord(k)=find(is==k); end;
%     adds=mod(ord,2)*ab;
%     nl=size(MLines,1)-1;
%     for k=2:nl
%         plot([MLines(k,1) i],[MLines(k,2) MLines(k,2)],'m');
%         text(-n-adds(k),MLines(k,2),int2str(MLines(k,3)),'Color','m')
%     end
%     plot([MLines(1,1) i],[MLines(1,2) MLines(1,2)],'g','LineWidth',2);
%     text(-n-adds(1),MLines(1,2),int2str(MLines(1,3)),'Color','g')
%     if(nl>0)
%         plot([MLines(end,1) i],[MLines(end,2) MLines(end,2)],'m','LineWidth',2);
%         text(-n-adds(end),MLines(end,2),int2str(MLines(end,3)),'Color','m')
%     end
end;

% box lines
if(~isempty(BLines))
    [ord is]=sort([BLines(:,3)]);
    for k=1:length(is) ord(k)=find(is==k); end;
    adds=mod(ord,2)*ab;
    nl=size(BLines,1)-1;
    plot([BLines(1,1) i],[BLines(1,2) BLines(1,2)],'c','LineWidth',2);
    text(axst-n2-adds(1),BLines(1,2),int2str(BLines(1,3)),'Color',purpl)
    for k=2:nl
        plot([BLines(k,1) i],[BLines(k,2) BLines(k,2)],'c');
        text(axst-n2-adds(k),BLines(k,2),int2str(BLines(k,3)),'Color',purpl)
    end
    if(nl>0)
        plot([BLines(end,1) i],[BLines(end,2) BLines(end,2)],'c','LineWidth',2);
        text(axst-n2-adds(end),BLines(end,2),int2str(BLines(end,3)),'Color',purpl)
    end
end;


% stop lines
HLFsize=12;
hlines=[HLinesL1;HLinesL2];
nhl1=size(HLinesL1,1);
nhl2=size(HLinesL2,1);

if(opt)
    %     if(~isempty(hlines))
    %         [ord is]=sort([hlines(:,3)]);
    %         for k=1:length(is) ord(k)=find(is==k); end;
    %         adds=mod(ord,2)*ab;
    %         addsbuy=adds(1:nhl1);
    %         addsell=adds(nhl1+1:end);
    %     end

    if(BoxFlag==1)
        [ord is]=sort([HLinesL1(:,3)]);
        for k=1:length(is) ord(k)=find(is==k); end;
        adds=mod(ord,2)*ab;
        for k=1:nhl1-2
            plot([HLinesL1(k,1) i],[HLinesL1(k,2) HLinesL1(k,2)],'b');
            text(i+n+adds(k),HLinesL1(k,2),int2str((HLinesL1(k,3))),'Color','b')
        end
    elseif(BoxFlag==0)
        [ord is]=sort([HLinesL2(:,3)]);
        for k=1:length(is) ord(k)=find(is==k); end;
        adds=mod(ord,2)*ab;
        for k=1:nhl2-2
            plot([HLinesL2(k,1) i],[HLinesL2(k,2) HLinesL2(k,2)],'r');
            text(i+n+adds(k),HLinesL2(k,2),int2str(round(HLinesL2(k,3))),'Color','r')
        end
    end

    if(~isempty(HLinesL1))
        plot([HLinesL1(end,1) i],[HLinesL1(end,2) HLinesL1(end,2)],'b','LineWidth',2);
        text(i+n+ab,HLinesL1(end,2),int2str(round(HLinesL1(end,3))),...
            'Color','b','FontSize',HLFsize)
        if(nhl1>1)
            plot([HLinesL1(end-1,1) i],[HLinesL1(end-1,2) HLinesL1(end-1,2)],'b','LineWidth',2);
            text(i+n,HLinesL1(end-1,2),...
                int2str(round(HLinesL1(end-1,3))),'Color','b','FontSize',HLFsize)
        end;
    end;

    if(~isempty(HLinesL2))
        plot([HLinesL2(end,1) i],[HLinesL2(end,2) HLinesL2(end,2)],'r','LineWidth',2);
        text(i+n+ab,HLinesL2(end,2),int2str(round(HLinesL2(end,3))),...
            'Color','r','FontSize',HLFsize)
        if(nhl2>1)
            plot([HLinesL2(end-1,1) i],[HLinesL2(end-1,2) HLinesL2(end-1,2)],'r','LineWidth',2);
            text(i+n,HLinesL2(end-1,2),...
                int2str(round(HLinesL2(end-1,3))),'Color','r','FontSize',HLFsize)
        end;
    end;

    %     for k=1:nhl1-2
    %         plot([HLinesL1(k,1) i],[HLinesL1(k,2) HLinesL1(k,2)],'b');
    %         text(i+n+addsbuy(k),HLinesL1(k,2),int2str((HLinesL1(k,3))),'Color','b')
    %     end
    %     for k=1:nhl2-2
    %         plot([HLinesL2(k,1) i],[HLinesL2(k,2) HLinesL2(k,2)],'r');
    %         text(i+n+addsell(k),HLinesL2(k,2),int2str(round(HLinesL2(k,3))),'Color','r')
    %     end
else
    if(~isempty(hlines))
        [ord is]=sort([hlines(:,3)]);
        for k=1:length(is) ord(k)=find(is==k); end;
        adds=mod(ord,2)*ab;
        addsbuy=adds(1:nhl1);
        addsell=adds(nhl1+1:end);
        % Get Last Lines
        [dum,last_i]=max(hlines(:,1));
        if(last_i<=nhl1) plot([hlines(last_i,1) i],[hlines(last_i,2) hlines(last_i,2)],'b','LineWidth',2);
        else plot([hlines(last_i,1) i],[hlines(last_i,2) hlines(last_i,2)],'r','LineWidth',2);
        end
        if(size(hlines,1)>=2)
            hlines(last_i,1)=0;
            [dum,last_i]=max(hlines(:,1));
            if(last_i<=nhl1) plot([hlines(last_i,1) i],[hlines(last_i,2) hlines(last_i,2)],'b','LineWidth',2);
            else plot([hlines(last_i,1) i],[hlines(last_i,2) hlines(last_i,2)],'r','LineWidth',2);
            end
        end
    end
    for k=1:nhl1
        %     plot([HLinesL1(k,1) i],[HLinesL1(k,2) HLinesL1(k,2)],'b');
        text(i+n+addsbuy(k),HLinesL1(k,2),int2str((HLinesL1(k,3))),'Color','b')
    end
    for k=1:size(HLinesL2,1)
        %     plot([HLinesL2(k,1) i],[HLinesL2(k,2) HLinesL2(k,2)],'r');
        text(i+n+addsell(k),HLinesL2(k,2),int2str(round(HLinesL2(k,3))),'Color','r')
    end
end

% line l2
% current line
if(l2line.p1(2)~=-1e9)
    plot([l2line.p1(1),l2line.p2(1),i],[l2line.p1(2),l2line.p2(2),exl2],'r-','LineWidth',2);
    plot([l2line.p1(1),l2line.p2(1),i],[l2line.p1(2),l2line.p2(2),exl2]+sp,'r:','LineWidth',2);
    plot(l2line.high(1),l2line.high(2),'ro')%,'MarkerFaceColor','r')
end
for k=1:size(DLinesL2,1)
    ex=DLinesL2(k).p1(2)+(i-DLinesL2(k).p1(1))*DLinesL2(k).gr;
    plot([DLinesL2(k).p1(1) i],[DLinesL2(k).p1(2) ex],'r');
end
% new points and high points
plot([l2line.p1new(1),l2line.p2new(1)],[l2line.p1new(2),l2line.p2new(2)],'go')%,'MarkerFaceColor','g');
plot(l2line.currhigh(1),l2line.currhigh(2),'gx',l2line.highnew(1),l2line.highnew(2),'gd')%,'MarkerFaceColor','g');

% day high and low
plot(Low1Day(1),Low1Day(2),'g*',Hi2Day(1),Hi2Day(2),'g*','LineWidth',2);

% diag lines
if(DiagL1.gr~=1e9)
    plot([DiagL1.p1(1),DiagL1.p2(1),i],[DiagL1.p1(2),DiagL1.p2(2),exDiag1],'g--','LineWidth',2)
    plot([DiagL1.p1(1),DiagL1.p2(1),i],[DiagL1.p1(2),DiagL1.p2(2),exDiag1]+sp,'g--','LineWidth',2)
end
if(DiagL2.gr~=-1e9)
    plot([DiagL2.p1(1),DiagL2.p2(1),i],[DiagL2.p1(2),DiagL2.p2(2),exDiag2],'g--','LineWidth',2)
    plot([DiagL2.p1(1),DiagL2.p2(1),i],[DiagL2.p1(2),DiagL2.p2(2),exDiag2]-sp,'g--','LineWidth',2)
end