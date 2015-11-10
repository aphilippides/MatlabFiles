function BuildUp(t2,l)

dsmall
SingPlot(gcf);
t=[1000:25:1050];
PlotBuildUp(4,10,t,40,59,50)
SetYTicks(gca,5,1e6,2,[0.21:0.01:0.25]*1e-6)
legend('Threshold','1s','1.025s','1.05s')
h=figure;
[h1,h2]=Subplot2(h);
subplot(h1)
SetYTicks(gca,4,1e6)
%PlotBuildUp(100,36,[625:25:675],24,375,200)
SetYTicks(gca,3,1e6,2,[0.15:0.05:0.25]*1e-6)
legend('Threshold','0.625s','0.65s','0.675s')

subplot(h2)
fn=['BuildUp/Mesh2dSSt1B2MaxGr1000X100Sq2Sp36.dat'];
M=load(fn);
[Over,T]=NumOver(M);
hold on;plot(T,Over,'b-x');hold off
SetBox;
xlabel('Time (s)');
ylabel('Area over threshold (x10^3 \mum^2)');
SetYTicks(gca,5,1e-3)

function PlotBuildUp(X,Sp,t,x1,x2,l)
plot([1 x2-x1], [2.5e-7 2.5e-7],'g--')
hold on;
C=['b-.';'r: ';'k- '];
for i=1:length(t)
    fn=['BuildUp/Mesh2dSSt1B2Gr1000X'int2str(X) 'Sq2Sp'int2str(Sp) 'T' int2str(t(i)) '.dat'];
    M=load(fn)*1.324e-4;
    Over(i)=length(find(M>=2.5e-7))
    L=M(l,x1:x2);
    plot(L,C(i,:));
end
hold off
SetBox;
xlabel('Distance (\mum)');
ylabel('Concentration (\muM)');
axis tight
