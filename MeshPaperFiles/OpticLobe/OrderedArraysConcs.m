% function to draw Figure4 at time Timez

function OrderedArraysConcs(Time,X)

if(nargin==0) 
    Time=1;
    X=35;
end
% FigHdl=gcf;
% set(FigHdl,'Units','centimeters');
% X=get(FigHdl,'Position');
% set(FigHdl,'Position',[X(1) X(2) 9 4.5]);
% set(FigHdl,'PaperPositionMode','auto');
% cla
% subplot('Position',[0.025 0.025 0.45 0.9])
%DrawLobeOutline(25,2,12,500);
DrawLobeOutline(100,1,X,Time*1000);
axis off
% subplot('Position',[ 0.525 0.025 0.45 0.9 ])
% Time=500;
% DrawLobeOutline(22,2,12,500);
% axis off

function DrawLobeOutline(XS,Sq,Sp,T)
%x1=50;x2=250;
x1=1;x2=400;

M=GetLobeDat(Sq,Sp,XS,T,x1,x2);
edge=80;
dsmall;
ms=load(['BuildUp/Mesh2dSSt1B1Gr1000X' int2str(XS) 'Sq' num2str(Sq) 'Sp' int2str(Sp) 'T-1.dat']);
MData=M(edge+x1:x2-edge,edge+x1:x2-edge);
msrc=ms(edge+x1:x2-edge,edge+x1:x2-edge);
aff=1e-7;

[i,j]=find(msrc>0);
% MData=double(MData>aff);
contourf(MData,[1 1]*1e-7,'k');
cax=[0 2e-7];

%for k=1:length(i) MData(i(k),j(k))=-2; end;    
% cax=[-1.6e-7 0e-7];

%[MData,cax] = AdjustColours(MData,cax,5e7);
% cax=[-2 1];
% pcolor(-MData);
% shading interp
% hold on
% contourf(MData,[1 1]*1e-7,'k');
% hold off
caxis(cax)
colormap(FullGrayMap)
% colormap(imadjust(FullGrayMap,[],[],0.4))
hold on
%[c,h]=contour(MData,[aff aff],'k-');
% DrawSources(msrc,'k');
axis square
hold off
set(gca,'TickLength',[0 0],'XTickLabel','','YTickLabel','','Box','off')

function DrawSources(m,col)
[i,j]=find(m>0);
i=i';
j=j';
x=[i;i+1;i+1;i;i];
y=[j;j;j+1;j+1;j];
patch(x,y,col)
% for k=1:length(i)
% plot(i(k),j(k),[col 'o'],'MarkerSize',4,'MarkerFaceColor',col);
% end

function DrawBox(left,right,top,bott,X)

Xes=left:(Sp):right;
Ys=bott:(Sp):top;
botts=ones(1,X)*bott;
tops=ones(1,X)*top;
rights=ones(1,X)*right;
lefts=ones(1,X)*left;
SourceX=[Xes rights invert(Xes) lefts];
SourceY=[botts Ys tops invert(Ys)];
plot(SourceX,SourceY,'b:o')

function[MData,MDataMax,MDataMin]=GetLobeDat(Square,Sp,NumSources,Time,x1,x2)

r1=1;
dsmall
y1=x1;y2=x2;r2=r1;
%fn=['Density50/Mesh2dSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Sp) 'T' num2str(Time) '.dat']
%fn=['BuildUp/Mesh2dSSt1B2Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' int2str(Sp) 'T' num2str(Time) '.dat'];
fn=['BuildUp/Mesh2dSSt1B1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' int2str(Sp) 'T' num2str(Time) '.dat'];
M=load(fn);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData))
MDataMin=min(min(MData))
