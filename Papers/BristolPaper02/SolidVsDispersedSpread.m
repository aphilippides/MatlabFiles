function SolidVsDispersedSpread

[h1,h2]=Subplot2(gcf)
subplot(h1);
set(gca,'FontSize',12)
d=-6:0.01:6;
r=5;
y=f1(d,r);
z=f2(d,r);
plot(d,y,d,z,'r:')
legend('GasNet','Plexus')
SetBox;
xlabel('Distance from emitter')
ylabel('Maximum gas concentration')
SetXLim(gca,-6,6)
SetXTicks(gca,5);
SetYTicks(gca,5);

subplot(h2)
set(gca,'FontSize',12)
PlotBuildUp(100,36,[1000],24,475,200)

function PlotBuildUp(X,Sp,t,x1,x2,l)
%plot([1 x2-x1], [2.5e-7 2.5e-7],'g--')
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
dsmall
load BuildUp/BuildUpData.mat
plot(L([1:210 243:end]),'r:');
hold on;
plot(L2([1:210 243:end]),'b-');
legend('Dispersed','Single')

hold off
SetBox;
xlabel('Distance (\mum)');
ylabel('Concentration (\muM)');
axis tight
SetXLim(gca,25,395)
SetYTicks(gca,3,1e6,2,[0.5:0.5:1.5]*1e-6)

function[y]=f1(d,r)
i=find(abs(d)>r);
y=exp(-2*abs(d)./r);
y(i)=0;

function[y]=f2(d,r)
i=find(abs(d)>r);
y=0.5*ones(size(d));
y(i)=0;