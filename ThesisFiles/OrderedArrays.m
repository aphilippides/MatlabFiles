% function to draw Figure4 at time Timez

function OrderedArrays(Time,X)

if(nargin==0) 
    Time=1;
    X=35;
end
Space=10;
Sq=2;
% FigHdl=gcf;
% set(FigHdl,'Units','centimeters');
% X=get(FigHdl,'Position');
% set(FigHdl,'Position',[X(1) X(2) 9 4.5]);
% set(FigHdl,'PaperPositionMode','auto');
% cla
% subplot('Position',[0.025 0.025 0.45 0.9])
%DrawLobeOutline(25,2,12,500);
DrawLobeOutline(100,2,X,Time*1000);
axis off
% subplot('Position',[ 0.525 0.025 0.45 0.9 ])
% Time=500;
% DrawLobeOutline(22,2,12,500);
% axis off

function DrawLobeOutline(XS,Sq,Sp,T)
%x1=50;x2=250;
x1=1;x2=600;
DataNeeded=1;
fname=['OrdArrayOutLineDataSq' int2str(Sq) 'Sp' int2str(Sp) '.mat'];
VarName=['ConcX' int2str(XS)];
if(DataNeeded)
   eval([VarName '=GetLobeDat(Sq,Sp,XS,T,x1,x2);']);
   a=dir(fname);
   dthesisdat;
    if(length(a)==0)
   	save(fname,VarName)
	else
   	save(fname,VarName,'-append')
   end
end
   dthesisdat;
load(fname);
eval(['M=' VarName ';']);
edge=0;
[X,Y]=size(M);
dsmall;
ms=load(['BuildUp/Mesh2dSSt1B2Gr1000X100Sq2Sp' int2str(Sp) 'T-1.dat']);

MData=M(edge+1:X-edge,edge+1:Y-edge);
msrc=ms(edge+1:X-edge,edge+1:Y-edge);
[i,j]=find(msrc>0);
aff=2.5e-7;
%SynthArea=(sqrt(XS)*(Sp+Sq)-Sp);

centx=X/2-edge;
centy=Y/2-edge;
Xl=(ceil(sqrt(XS))-1)/2;
left=centx-Xl*Sp;
right=centx+Xl*Sp;
bott=centy-Xl*Sp;
top=centy+Xl*Sp;

% Draw White
XRow=ceil(sqrt(XS));
if(XS==22) DrawSources2(left,right,top,bott,Sp,5);
else %DrawSources(left,right,top,bott,Sp,XRow,MData)
end
mbin=double(MData<aff);
pcolor(MData)
figure
for k=1:length(i) mbin(i,j)=-3; end;    
pcolor(mbin);
caxis([-3 1])
colormap(gray)
shading flat
hold on
%[c,h]=contour(MData,[aff aff],'k-');
axis square
hold off
set(gca,'TickLength',[0 0],'XTickLabel','','YTickLabel','','Box','off')

function[Xs,Ys,NewM]= DrawSources(left,right,top,bott,Sp,X,M)

hold on
XLine=[left right right left left];
YLine=[bott bott top top bott];
plot(XLine,YLine,'k')
Xes=left:Sp:right;
Ys=bott:Sp:top;
for i=1:length(Xes)
   Xs=ones(1,X)*Xes(i);
   M([Xes(i)+1],Ys)=-3;
   M([Xes(i)+1],Ys+1)=-3;
%   h=plot(Xs,Ys,'bo');
%   set(h,'MarkerSize',4,'MarkerFaceColor','b')
end

function DrawSources2(left,right,top,bott,Sp,X)

hold on
XLine=[left right right left left];
YLine=[bott bott top top bott];
plot(XLine,YLine,'k')
Gap=4;
Xes=[left:Sp-2:right]+Gap;
Ys=[bott:Sp-2:top]+Gap;
for i=1:length(Xes)-1
   Xs=ones(1,X)*Xes(i);
  h=plot(Xs,Ys,'bo');
  set(h,'MarkerSize',4,'MarkerFaceColor','b')
end
   Xs=ones(1,2)*Xes(5);
  Ys=[55.5 65.5];
h=plot(Xs,Ys,'bo');
  set(h,'MarkerSize',4,'MarkerFaceColor','b')


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
fn=['BuildUp/Mesh2dSSt1B2Gr1000X100Sq2Sp' int2str(Sp) 'T' num2str(Time) '.dat'];
M=load(fn);
MData= M(x1:r1:x2,y1:r2:y2)*1.324e-4;
MDataMax=max(max(MData));
MDataMin=min(min(MData));
