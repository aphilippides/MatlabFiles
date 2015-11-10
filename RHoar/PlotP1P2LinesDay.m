function PlotP1P2LinesDay(i,l1line,l2line,exl1,exl2,Hi2Day,Low1Day,...
    DiagL1,DiagL2,exDiag1,exDiag2,DLinesL1,DLinesL2,HLinesL1,HLinesL2,sp,axlen)

% n=min(100,0.01*i);
% n=max(100,0.01*axlen);
n=0.01*axlen;
% ab=0.115*axlen;
% ab=0.075*axlen;
ab=-1.1*axlen;

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
% stop lines
hlines=[HLinesL1;HLinesL2];
nhl1=size(HLinesL1,1);
% nhl2=size(HLinesL2,1);
if(~isempty(hlines))
    [ord is]=sort([hlines(:,3)]);
    for k=1:length(is) ord(k)=find(is==k); end;
    adds=mod(ord,2)*ab;
    addsbuy=adds(1:nhl1);
    addsell=adds(nhl1+1:end);
end
for k=1:nhl1-1
    plot([HLinesL1(k,1) i],[HLinesL1(k,2) HLinesL1(k,2)],'b');
    text(i+n+addsbuy(k),HLinesL1(k,2),int2str((HLinesL1(k,3))),'Color','b')
%     text(i+n,HLinesL1(k,2),num2str(HLinesL1(k,3)),'Color','b')
end
if(~isempty(HLinesL1)) 
    plot([HLinesL1(end,1) i],[HLinesL1(end,2) HLinesL1(end,2)],'b','LineWidth',2);
    text(i+n+addsbuy(end),HLinesL1(end,2),int2str(round(HLinesL1(end,3))),'Color','b')
%     text(i+n,HLinesL1(end,2),num2str(HLinesL1(end,3)),'Color','b')
end;

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
% stop lines
for k=1:size(HLinesL2,1)-1
    plot([HLinesL2(k,1) i],[HLinesL2(k,2) HLinesL2(k,2)],'r');
    text(i+n+addsell(k),HLinesL2(k,2),int2str(round(HLinesL2(k,3))),'Color','r')
%     text(i+n,HLinesL2(k,2),num2str(HLinesL2(k,3)),'Color','r')
end
if(~isempty(HLinesL2)) 
    plot([HLinesL2(end,1) i],[HLinesL2(end,2) HLinesL2(end,2)],'r','LineWidth',2);
%     text(i+n,HLinesL2(end,2),num2str(HLinesL2(end,3)),'Color','r')
	text(i+n+addsell(end),HLinesL2(end,2),int2str(round(HLinesL2(end,3))),'Color','r')
end;

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