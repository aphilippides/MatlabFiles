% function to draw Figure4 at time Timez

function Fig4PicV2(Time,X)

if(nargin==0) 
    Time=1;
    X=25;
end
close(gcf)
Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Space=10;
Sq=2;
subplot('Position',[0.1 0.6 0.4 0.35])
XT=2:15;
NumTs=XT.^2;
AffVol=GetLobeAffVolumes(NumTs,Time,Sq,Space);
SynthArea=(XT*(Space+Sq)-Space).^2;
plot(NumTs,AffVol,'b- .')
axis tight
xlabel('Number of Tubes')
ylabel('Affected Volume \div Synth. Volume')
set(gca,'TickDir','out','Box','off')%,'YTickLabel',YTickStr,'XTickLabel',NumTs)
subplot('Position',[ 0.09 0.025 0.425 0.425 ])
X=25;
Time=500;
DrawLobeOutline(X,Sq,Space,Time);

function[AffVol]= GetLobeAffVolumes(NumTs,Time,Square,Space)

dsmall
for i=1:length(NumTs)
   filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumTs(i)) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat'];
   M=load(filename);
   [X,Y]=size(M);
   Timez=M(2:X,1)
   NumOver=1e6-M(2:X,4);
   AffVol(i)=NumOver(find(Timez==Time));
end
dtube

function[XTPos]=GetTickPos(XLim,AxLims,XTLabs)

Fact=AxLims(2)-AxLims(1);
for i=1:length(XTLabs)
   Facts(i,1)=(AxLims(2)-XTLabs(i))/Fact;
   Facts(i,2)=(XTLabs(i)-AxLims(1))/Fact;
end
XTPos=Facts*XLim';

function DrawLobeOutline(XS,Sq,Sp,T)

x1=400;
x2=600;
DataNeeded=0;
fname=['MeshPaper/Fig4Data/Fig4OutLineDataSq'int2str(Sq) 'Sp'int2str(Sp) '.mat'];
VarName=['ConcX'int2str(XS) 'T'int2str(T)];
if(DataNeeded)
   eval([VarName '=GetLobeDat(Sq,Sp,XS,T,x1,x2);']);
   a=dir(fname);
   if(length(a)==0)
   	save(fname,VarName)
	else
   	save(fname,VarName,'-append')
   end
end
load(fname);
eval(['M=' VarName ';']);
edge=40;
[X,Y]=size(M);
MData=M(edge+1:X-edge,edge+1:Y-edge);
aff=2.5e-7;
SynthArea=(sqrt(XS)*(Sp+Sq)-Sp);
pcolor(MData<aff);
caxis([-3 1])
colormap(gray)
shading interp
hold on

centx=X/2-edge;
centy=Y/2-edge;
Xl=(sqrt(XS)-1)/2;
left=centx-Xl*Sp;
right=centx+Xl*Sp;
bott=centy-Xl*Sp;
top=centy+Xl*Sp;

% Draw White
XW=[left right right left left];
YW=[bott bott top top bott];
%h=patch(XW,YW,'r'),set(h,'EdgeColor','b')

XRow=sqrt(XS);
DrawSources(left,right,top,bott,Sp,XRow)
%DrawBox(left,right,top,bott,XRow,Sp)

[c,h]=contour(MData,[aff aff],'k--');
axis square
hold off
set(gca,'TickLength',[0 0],'XTickLabel','','YTickLabel','','Box','off')


function DrawSources(left,right,top,bott,Sp,X)

hold on
XLine=[left right right left left];
YLine=[bott bott top top bott];
plot(XLine,YLine,'k')
Xes=left:Sp:right;
Ys=bott:Sp:top;
for i=1:length(Xes)
   Xs=ones(1,X)*Xes(i);
  h=plot(Xs,Ys,'bo');
  set(h,'MarkerSize',4,'MarkerFaceColor','b')
end

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



function[MData,MDataMax,MDataMin]=GetLobeDat(Square,Space,NumSources,Time,x1,x2)

r1=1;
d2dmm
y1=x1;y2=x2;r2=r1;
filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Time) '.dat']
M=load(filename);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
dtube

