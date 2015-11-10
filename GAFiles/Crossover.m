function[C]=Crossover(P1,P2)

XLen=min(length(P1),length(P2));
XPt=IRnd(XLen)+1;
C=[P1(1:XPt) P2(XPt+1:end)];
