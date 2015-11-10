function SingVsDispersedPics(Sp,Sq,x,t,Th,s)
if(nargin<6) s=1;end;
dsmall;
cd BuildUp
%BuildUpFigsMesh(55)
%BuildUpFigsMesh(35)
%BuildUpFigsMesh(2)
% SingPicAxBreak(Sp,Sq,x,t)
%SingPic(Sp,Sq,x,t)
dsmall;
cd BuildUp
TimePic
%DrawOutline(Sp,Sq,x,t,Th,s)

function SingPicAxBreak(Sp,Sq,x,t,Th)
figure;
Singplot(gcf)
h=load(['Mesh2dSSt1B1Gr1000X' int2str(x) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'Line500T' int2str(t) '.dat'])*1.324e-4;
x=-250:250;
[h1,h2]=AxisBreakY(x,h(x+501),0.3e-6,1.9e-6);
subplot(h1);
set(gca,'FontSize',12)
xlabel('Distance (\mum)')
ylabel('Concentration (\muM)')
XLim([-200 200]);
YLim([0 0.3e-6]);
SetYTicks(h1,4,1e6);
if(nargin==5)
    hold on
    plot([x(1) x(end)],[1 1]*Th,'g--');
    hold off;
end
subplot(h2),
set(gca,'FontSize',12)
XLim([-200 200]);
YLim([1.9 2]*1e-6);
SetYTicks(h2,2,1e6)

function SingPic(Sp,Sq,x,t,Th)
figure;
Singplot(gcf)
h=load(['Mesh2dSSt1B1Gr1000X' int2str(x) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'Line500T' int2str(t) '.dat'])*1.324e-4;
x=-250:250;
plot(x,h(x+501))
set(gca,'FontSize',12)
xlabel('Distance (\mum)')
ylabel('Concentration (\muM)')
if(nargin==5)
    hold on
    plot([x(1) x(end)],[1 1]*Th,'g--');
    hold off;
end
% need to be in line with axbreak figure so need to work ou
% what ylim should be
YLim([0 0.44e-6]);
XLim([-200 200]);
SetYTicks(gca,3,1e6,1,[0:0.1:0.4]*1e-6)
Setbox;

function TimePic
figure;
Singplot(gcf)
Spacings=[2:42];
m=load('Mesh2dSSt1B2Gr1000X100Sq2DelayTimes.dat');
plot(m(:,1),m(:,2));
Setbox;
set(gca,'FontSize',12)
xlabel('Spacing (\mum)');
ylabel('Delay (s)');
axis tight;
SetXLim(gca,2,40);
SetXTicks(gca,2,1,2,[10:10:40])
set(gca,'YLim',[0 0.57])
SetYTicks(gca,[],1,[],[0:0.25:0.5])

function DrawOutline(Sp,Sq,x,t,Th,s)
figure;
m=load(['Mesh2dSSt1B1Gr1000X' int2str(x) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'T' int2str(t) '.dat'])*1.324e-4;
ms=load(['Mesh2dSSt1B1Gr1000X' int2str(x) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'T-1.dat']);
% mp=min(1,(m<Th)+gl+(ms>0));
% pcolor(mp),shading flat;
colormap(gray)
[c,h]=contourf(m,[Th Th]);
hold on
[i,j]=find(ms>0)
for k=1:length(i) 
    h=plot(i(k),j(k),'ko');
    set(h,'MarkerSize',1,'MarkerFaceColor','k')
end;    
axis off;
axis([1 500 1 500])
axis square
hold off
%set(gca,'TickLength',[0 0],'XTickLabel','','YTickLabel','','Box','off')