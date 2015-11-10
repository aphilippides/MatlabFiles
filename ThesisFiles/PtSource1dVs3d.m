function PtSource1dVs3d(t_half,x,NVal,NVal2)
if(nargin<2) x=30; end;
if(nargin<3) NVal=10; end;
X=0:0.1:x
Figure1(t_half,X,NVal,NVal2)
%Norm(t_half,X,NVal)
%NonNorm(t_half,X)

function NonNorm(t_half,X)
%X=[x:-0.1:0.1 X];
k1=-log(2)/sqrt(6600*t_half)
k2=-sqrt(log(2)/(3300*t_half))
Lanc1d=MirrorVec(exp(k1.*X));
Pt1d=MirrorVec(exp(k2.*X));
X=MirrorVecMinus(X);
plot(X,Lanc1d,X,Pt1d)
legend('Lanc','Pt1d')

function Norm(t_half,X,NVal)

Fact=Lanc1dSS(NVal,t_half)/Pt1dSS(NVal,t_half);
%X=[x:-0.1:0.1 X];
k1=-log(2)/sqrt(6600*t_half)
k2=-sqrt(log(2)/(3300*t_half))
Lanc1d=MirrorVec(exp(k1.*X));
Pt1d=MirrorVec(exp(k2.*X))*Fact;
Pt3d=MirrorVec((1./X).*exp(k2.*X))*Fact*NVal;
X=MirrorVecMinus(X);
plot(X,Lanc1d,X,Pt1d,X,Pt3d)
legend('Lanc','Pt1d','Pt3d')
%SetXLim(gca,NVal,X(end))
SetYLim(gca,0,3)

function Figure1(t_half,X,NVal,NVal2)

SingPLot(gcf)
Fact=Pt3dSS(NVal,t_half)/Pt1dSS(NVal,t_half);
Fact2=Pt3dSS(NVal2,t_half)/Pt1dSS(NVal2,t_half);
k1=-log(2)/sqrt(6600*t_half)
k2=-sqrt(log(2)/(3300*t_half))
Pt1d=MirrorVec(Pt1dSS(X,t_half));
Pt3d=MirrorVec(Pt3dSS(X,t_half))/Fact;
Pt3d2=MirrorVec(Pt3dSS(X,t_half))/Fact2;
X=MirrorVecMinus(X);
plot(X,Pt1d,X,Pt3d,'r:',X,Pt3d2,'g--')
h=legend('1D pt source',['3D pt source (' int2str(NVal) ')'],['3D pt source (' int2str(NVal2) ')'])
%SetXLim(gca,NVal,X(end))
SetYLim(gca,0,3)
set(gca,'Box','off','TickDir','out')
ylabel('Concentration')
xlabel('Distance (\mum)')
SetXTicks(gca,5)
%LegBoxOff(h)

