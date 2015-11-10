function BuildUp(t2,l)

dsmall
[h1,h2]=Subplot2(gcf);
subplot(h1)
set(gca,'FontSize',12)
PlotBuildUp(100,36,[1000],24,475,200)
SetYTicks(gca,3,1e6,2,[0.5:0.5:1.5]*1e-6)

subplot(h2)
set(gca,'FontSize',12)
fn=['BuildUp/Mesh2dSSt1B2MaxGr1000X100Sq2Sp36.dat'];
M=load(fn);
[Over,T]=NumOver(M);
plot(T,Over,'b-x');
fn=['BuildUp/Mesh2dSSt1B2MaxGr1000X100Sq2Sp2.dat'];
M=load(fn);
[Over,T]=NumOver(M);
hold on;plot(T,Over,'r:');hold off;
SetBox;
SetXLim(gca,0,1.5);
xlabel('Time (s)');
ylabel('Area over threshold (x10^3 \mum^2)');
SetYTicks(gca,[],1e-3,[],[0:4:12].*1e4)
legend('Dispersed','Single')


function PlotBuildUp(X,Sp,t,x1,x2,l)
plot([1 x2-x1], [2.5e-7 2.5e-7],'g--')
hold on;
C=['b- ';'r: ';'k- ';'b-.'];
DataNeeded=0;
if(DataNeeded==1)
    fn=['BuildUp/Mesh2dSSt1B2Gr1000X'int2str(X) 'Sq2Sp'int2str(Sp) 'T' int2str(t) '.dat'];
    M=load(fn)*1.324e-4;
    L=M(l,x1:x2);
    fn=['BuildUp/Mesh2dSSt1B2Gr1000X'int2str(X) 'Sq2Sp2T' int2str(t) '.dat'];
    M=load(fn)*1.324e-4;
    L2=M(l,x1:x2);
    save BuildUp/BuildUpData.mat L L2;
end
load BuildUp/BuildUpData.mat
plot(L,C(1,:));
plot(L2,C(2,:));

legend('Threshold','Dispersed','Single')

hold off
SetBox;
xlabel('Distance (\mum)');
ylabel('Concentration (\muM)');
axis tight
