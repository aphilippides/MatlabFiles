function BuildUpFigsMesh(Sp,l,sq)

if (nargin<2) l=200; end
if (nargin<3) sq=1; end
dsmall
% h=figure;
% Singplot(h);
% set(gca,'FontSize',14)
BuildUpTime(Sp,sq)
return
PlotBuildUp(100,Sp,[500],100,300,l)
h=figure;
Singplot(h);
set(gca,'FontSize',14)
PlotBuildUp(100,Sp,[515],100,300,l)
h=figure;
Singplot(h);
set(gca,'FontSize',14)
PlotBuildUp(100,Sp,[530],100,300,l)

% h=figure;
% Singplot(h);
% set(gca,'FontSize',12)
% BuildUpTime(Sp)

function BuildUpTime(Sp,sq)
set(gca,'FontSize',12)
%fn=['Density/Mesh2dSSt1MaxGr1000X100Sq2Sp' int2str(Sp) '.dat'];
fn=['BuildUp/Mesh2dSSt1B1MaxGr1000X100Sq' int2str(sq) 'Sp' int2str(Sp) '.dat'];
M=load(fn);
% [Over,T]=NumOver(M);
T=M(:,1);
Over=M(:,7);
plot(T,Over,'b-');
SetBox;
XLim([0,1]);
YLim([0,55e3]);
xlabel('Time (s)');
ylabel('Volume over [100nM] (x10^3 \mum^3)');
SetYTicks(gca,[],1e-3,[],[0:25:50].*1e3)
%legend('Dispersed','Single')

function PlotBuildUp(X,Sp,t,x1,x2,l,CSty)
if(nargin<7) CSty=1; end;
lim=floor((x2-x1)/2);
plot([-lim lim], [1e-7 1e-7],'k--')
hold on;
C=['b- ';'r: ';'k- ';'b-.'];
%fn=['BuildUp/Mesh2dSSt1B1Gr1000X' int2str(X) 'Sq1Sp' int2str(Sp) 'Line' int2str(l) 'T' int2str(t) '.dat'];
fn=['BuildUp/Mesh2dSSt1B1Gr1000X' int2str(X) 'Sq1Sp' int2str(Sp) 'T' int2str(t) '.dat'];
M=load(fn)*1.324e-4;
L=M(l,x1:x2);
%plot(-lim:lim,L,C(CSty,:));
plot(-lim:lim,L,'k');
%plot(L,C(1,:));

%legend('Threshold','Dispersed','Single')

SetBox;
xlabel('Distance (\mum)');
ylabel('Concentration (nM)');
axis tight
YLim([8,10.6]*1e-8)
SetYTicks(gca,3,1e9,0,[8:10]*1e-8,int2str([80:10:100]'))
