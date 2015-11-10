function[a,b]=NewPaperFigs(x,y)
dwork
ParallelArrayConcs(x)
%PlexusSlices(x)
%SpreadPics
%DiffParamsPicsTube
% Singplot,ConcVsDistPic
% figure,Singplot,SurfPic
% figure,TreePics

function PlexusSlices(w)
cd DiffEqun\MeshTube\MaxMinTree\
Singplot;
load(['MaxW' int2str(w) 'Rho100\TreeSst1OneDSlicesGr300X100Z100Sq1Sp10T1000.mat'])
load ConcThruEquivalentSphereB1T1Radius62
plot(mirrorvecminus(DistVec),mirrorvec(Conc*0.01),'b',[-149.5:149.5],Slices'*1.324e-4,'r')
SetBox
xlabel('distance (\mum)','FontSize',14)
YLim([0 12e-7])
setyticks(gca,[],1e9)
ylabel('concentration (nM)','FontSize',14)

function SpreadPics
dtube;cd MeshPaper\Fig1Data\
Singplot;
set(gca,'FontSize',14);
ds=[330  1100 1650 3300 6600]%, 3300];
for i=1:length(ds)
    load(['TubeDiam1B1Diff' x2str(ds(i)) 'SpreadDistsLams2.mat'])
    %plot(lams,Spread,Colour(i)),hold on,
    semilogx(lams,Spread,Colour(i)),hold on,
%    semilogx(lams,Spread./max(Spread),Colour(i)),hold on,
end
hold off
SetBox
xlabel('t_{1/2} (ms)','FontSize',14),ylabel('distance (\mum)','FontSize',14)

function DiffParamsPicsTube
dtube
cd MeshPaper\Fig1Data\
Singplot;
set(gca,'FontSize',14);
ds=[330 3300 6600 1100 1650 ];
ls=[ 5000 1000 500 100 10 1];
for i=1:length(ds)
    load(['TubeDiam1B1Diff' int2str(ds(i)) 'Lam' int2str(ls(4)) 'T1.mat'])
% for i=1:length(ls)
%     load(['TubeDiam1B1Diff' int2str(ds(4)) 'Lam' int2str(ls(i)) 'T1.mat'])
    plot(mirrorvecminus(DistVec),mirrorvec(Conc),Colour(i))
    %plot(mirrorvecminus(DistVec),mirrorvec(Conc./max(Conc)),Colour(i))
    C=Conc(3:end);
    %    plot(DistVec(3:end),C./max(C),Colour(i))
    hold on
end
SetBox
xlabel('distance (\mum)','FontSize',14)
ylabel('concentration (normalised)','FontSize',14)
setyticks(gca,[],1e9)
ylabel('concentration (nM)','FontSize',14)
hold off
XLim([-25 25])

function ParallelArrayConcs(Xs)
dsmall
for x=Xs
    x1=126; x2=275;
%    m=load(['BuildUp/Mesh2DSSt1Half' int2str(x) 'B1Gr1000X36Sq2Sp10T1000.dat'])*1.324e-8;
 %   m=load(['BuildUp/Mesh2DSSt1Diff' int2str(x) 'B1Gr1000X36Sq2Sp10T1000.dat'])*1.324e-8;
        load(['Lobe/MeshSSt1Gr1000X' int2str(x) 'Sq2Sp10Inn300Data.mat']);
        eval(['m=M2dT1000*1.324e-4;']);
    figure
    set(gcf,'Units','centimeters');
    X=get(gcf,'Position');
    set(gcf,'Position',[X(1) X(2) 3.1 3.1]);
    set(gcf,'PaperPositionMode','auto');
    set(gca,'Units','centimeters','Position',[0.1 0.1 2.85 2.85]);
    pcolor(m(x1:x2,x1:x2));
    %AxLims=[0 1.3e-6];
    ma=max(max(m))
    min(min(m))
    caxis([0 ma]);
    shading interp
     colormap(FullGrayMap)
    axis off
end

function TreePics
dwork;
cd(['DiffEqun\MeshTube\MaxMinTree\']);
% [cx1,cy1]=GetData(1,1:35)
% [cx5,cy5]=GetData(5,1:35)
load CentMassAndRangeDataWidth1
stats1=[mean(interq) std(interq);mean(ranges) std(ranges);mean(conf99) std(conf99);mean(conf95) std(conf95);mean(conf90) std(conf90)];
cx1=cx; cy1 = cy;
load CentMassAndRangeDataWidth5
stats5=[mean(interq) std(interq);mean(ranges) std(ranges);mean(conf99) std(conf99);mean(conf95) std(conf95);mean(conf90) std(conf90)];
cx5=cx; cy5 = cy;
scatter(cx1,cy1,100,'ro')
hold on
scatter(cx5,cy5,100,'bx')
hold off
set(gca,'FontSize',14)
axis([100 200 100 200])
axis square
box on
set(gca,'TickDir','out')
SetXTicks(gca,[],1,0,[100:25:200],int2str([0:25:100]'))
SetYTicks(gca,[],1,0,[100:25:200],int2str([0:25:100]'))
es=[stats1(:,2) stats5(:,2)]*1.324e-4;
ms=[stats1(:,1) stats5(:,1)]*1.324e-4;
% DrawBits(ms,es,1);
% figure,DrawBits(ms,es,2);
% figure,DrawBits(ms,es,3);
% figure,DrawBits(ms,es,4);
% figure,DrawBits(ms,es,5);

function DrawBits(ms,es,i)
Singplot;
barerrorbar([],ms(i,:),es(i,:));
SetXTicks(gca,[],1,0,[1 2],{'Thin fibres';'Thick fibres'})
SetYTicks(gca,[],1e9)
ylabel('Concentration ranges nM')
Setbox;

function[cx,cy]=GetData(w,v)
%vs=v;
for i=1:length(v)
    fn=['MaxW' int2str(w) 'Rho100\TreeSSt1V' int2str(v(i)) 'Gr300X100Z100Sq1Sp10Sl0T1000.dat'];
    h=load(fn);  
    [cx(i),cy(i)]=centerofmass(h);
    ranges(i)=Range(h);
    x=h(101:200,101:200);
    interq(i)=PCRange(x,50);
    conf99(i)=PCRange(x,99);
    conf95(i)=PCRange(x,95);
    conf90(i)=PCRange(x,90);
end
save(['CentMassAndRangeDataWidth' int2str(w) '.mat'],'cx','cy','v','ranges','interq','conf99','conf95','conf90')

function ConcVsDistPic
dwork;
cd TubeData/MeshPaper/Fig1Data
load TubeDiam0_1B1T1
plot(DistVec-DistVec(1),Conc./max(Conc))
hold on
load TubeDiam1B1T1
plot(DistVec-DistVec(1),Conc./max(Conc),':')
load TubeDiam5B1T1
plot(DistVec-DistVec(1),Conc./max(Conc),'--')
XLim([0 25])
set(gca,'FontSize',14)
xlabel('Distance from surface of fibre (\mum)')
ylabel('Fraction of surface concentration')
SetYTicks(gca,5);
Setbox

function SurfPic
dwork;
cd TubeData/MeshPaper/Fig1Data
load TubeSurfaceConcDiam0_1_10B1
plot([Diams 0],[SurfaceTubeConc 0])
%XLim([0 5])
XLim([0 0.5])
set(gca,'FontSize',14)
xlabel('Fibre diameter (\mum)')
ylabel('Concentration nM')
SetYTicks(gca,[],1e9);
Setbox