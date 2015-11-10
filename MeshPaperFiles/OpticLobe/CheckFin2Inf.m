% function to check timestep differences for 2D results

function[MeanErr,SDErr]=CheckFin2Inf(SSt,Sq,Sp,X,Z,T,Tol,Inn,Line,Sl,MAll)

%Get2dData(Sq,Sp,X,T,Inn);
%PlotLine(Sq,Sp,X,Z,T,Tol,Inn,Line,Sl,MAll);
%figure
%[MeanErr,SDErr]=PlotAll(Sq,Sp,X,Z,T,Tol,Inn,MAll,Sl);
%M=GetM(MAll,T);
%[MeanErr,SDErr]=PlotAll2(Sq,Sp,X,Z,T,Tol,SSt,MAll,Sl);
%CompareMaxMinAll(Sq,Sp,X,Z,T,Tol,Inn,Sl)
%CheckNumOver(Sq,Sp,X,Z,T,Tol,Inn,Sl,MAll)
GetSlNumOverDat(Sq,Sp,X,Z,T,Tol,Inn,Sl,MAll)

function GetSlNumOverDat(Sq,Sp,X,Z,T,Tol,Inn,Sl,MAll)
Ss=2;
THRESHC=0.00188;
dsmall
fn=['Lobe/MeshSSt'x2str(Ss) 'MaxGr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
M=load(fn);
cd ../MaxMinPerp;
for i=1:length(Z)
   M3=GetM(MAll,T(i));
   NumOver2dOth(i)=NumOver(M3);
   fn2=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
   M2=load(fn2);
   NumOver3dMax(i)=NumOver(M2,Inn,300);
   fn2=['LobeMin/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
   if(IsFile(fn2)) NumOver3dMin(i)=NumOver3dMax(M2,Inn,300);
   else NumOver3dMin(i)=[];
   end      
   ind=find(M(2:end,1)==T(i)/1000)
   NumOver2d(i)=1e6-M(ind,4);
end
Est3d=0.5*(NumOver3dMax+NumOver3dMin)
Err3d=(NumOver3dMax-Est3d)./Est3d
FinErr1=(Est3d-NumOver2d)./NumOver2d
FinErr2=(Est3d-NumOver2d)./NumOver2dOth
fn=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'AllZ'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) 'NumOver.mat'];
save(fn,'T','NumOver2d','NumOver3dMax','NumOver3dMin')
plot(T,NumOver2d,T,NumOver3dMax,'r:',T,NumOver3dMin,'g--',T,NumOver2dOth,'y--')

function CheckNumOver(Sq,Sp,X,Z,T,Tol,Inn,Sl,MAll)
dsmall
SS=2
fn=['Lobe/MeshSSt'x2str(Ss) 'MaxGr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
M=load(fn);
for i=1:length(T)
    dsmall;
   M3=GetM(MAll,T(i))*1.324e-4;
   NumOver2dOth(i)=length(find(M3>=2.5e-7));
  cd ../MaxMinPerp;
  fn2=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(i)) '.dat'];
   M2=load(fn2);
   X2=Inn+1:300-Inn;
   L2=M2(X2,X2)*1.324e-4;
   NumOver3dMax(i)=length(find(L2>=2.5e-7));
   fn2=['LobeMin/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(i)) '.dat'];
   M2=load(fn2);
   L2=M2(X2,X2)*1.324e-4;
   NumOver3dMin(i)=length(find(L2>=2.5e-7));
   ind=find(M(2:end,1)==T(i)/1000)
   NumOver2d(i)=1e6-M(ind,4);
end
fn=['LobeMax/MeshSStGr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'NumOver.mat'];
save(fn,'T','NumOver2d','NumOver3dMax','NumOver3dMin')
plot(T,NumOver2d,T,NumOver3dMax,'r:',T,NumOver3dMin,'g--',T,NumOver2dOth,'y--')

function[M]= GetM(MAll,T)
if(T>=0) eval(['M=MAll.M2dT' int2str(T) ';']);
else eval(['M=MAll.M2dTSource;']);
end

function[MeanRDiff, StdRDiff]=PlotAll2(Sq,Sp,X,Z,T,Tol,SSt,M,Sl)
for t=1:length(T)
   dsmall
   fn=['Lobe/Mesh2dCheckSSt'x2str(SSt) 'Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T(t)) '.dat'];
   M=load(fn)*1.324e-4;
   dmmp
   fn=['LobeMax/MeshSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(t)) '.dat'];
   %fn=['LobeMaxMin/MaxMinEstSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(t)) '.dat'];
   M2=load(fn)*1.324e-4;
   [Differ, RelDiff,NewM,NewM2]=Compare2RegInt(M,M2,Tol);
   [i,j,v]=find(RelDiff);
   if(isempty(v)) v=0; end;
   MeanRDiff(t)=mean(v)
   StdRDiff(t)=std(v)
end
Plotting=0;
if(Plotting==1)
	X=max(min(i)-3,1):min(max(i)+3,300);Y=max(min(j)-3,1):min(max(j)+3,300);
	if(length(X)<2) X=1:300;end
	if(length(Y)<2) Y=1:300;end
	subplot(1,3,1),pcolor(RelDiff(X,Y)),colorbar,shading interp,
	subplot(1,3,2),pcolor(M(X,Y)),shading interp;
   subplot(1,3,3),pcolor(Difer(X,Y)*1.324e-4),colorbar,shading interp
end


function[MeanRDiff, StdRDiff]=PlotAll(Sq,Sp,X,Z,T,Tol,Inn,MAll,Sl)
M=GetM(MAll,T);
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
Xf=get(FigHdl,'Position');
set(FigHdl,'Position',[Xf(1) Xf(2) 18 10]);
set(FigHdl,'PaperPositionMode','auto');

dsmall
fn2=['../MaxMinPerp/LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M2=load(fn2);
X2=Inn+1:300-Inn;
subplot(1,3,1),
pcolor(M(X2,X2)),shading interp
subplot(1,3,2),
pcolor(M2(X2,X2)),shading interp
subplot(1,3,3),
RelDiff=(M2(X2,X2)-M(X2,X2)).*100./M2(X2,X2);
[i,j]=find(isnan(RelDiff));
RelDiff(i,j)=0;
pcolor(RelDiff),shading interp,colorbar
MeanRDiff=MMean(RelDiff);
StdRDiff=MStd(RelDiff);

function[PlusDiffs,MinusDiffs,PlusRels,MinusRels,numbad]=Compare2(M1,M2,Tol)

Difer=M2-M1 ;
RelDif=Difer./M2;
PlusRels=max(max(RelDif));
MinusRels=min(min(RelDif));
PlusDiffs=max(max(Difer));
MinusDiffs=min(min(Difer));
Reld=abs(RelDif);
Rel=(Reld>Tol);
numbad=sum(sum(Rel));
subplot(1,3,1),pcolor(RelDif),colorbar,shading interp,subplot(1,3,2),pcolor(M1)
shading interp,subplot(1,3,3),pcolor(Difer),colorbar,shading interp
%contour(RelVal,[ .025 ]) 
%[c,h]=contour(RelVal,[ .05 .025 .01]) ;
%clabel(c,h)

function MaxMinDiffs(M,M2)
MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);
PCNotHndl=subplot('position',[0.55 0.55 0.4 0.4]);

PlotMaxes(M,'b',MinMaxHndl,PCNotHndl);
subplot(MinMaxHndl),hold on;subplot(PCNotHndl),hold on;
PlotMaxes(M2,'r:',MinMaxHndl,PCNotHndl);
subplot(MinMaxHndl),hold off;subplot(PCNotHndl),hold off;
[Y,X]=size(M);
[Y2,X]=size(M2);
if(Y2<Y) Y=Y2;end
Times=M(2:Y,1);
MaxDiffs=(M(2:Y,2)-M2(2:Y,2));
RelMaxDiffs=MaxDiffs./max(M(2:Y,2));
NumOverDiffs=(M(2:Y,4)-M2(2:Y,4));
RelNumOverDiffs=NumOverDiffs./max(M(2,4)-(M(2:Y,4)));
subplot('position',[0.05 0.05 0.3 0.4]);
plot(Times,MaxDiffs,Times,MinDiffs);
subplot('position',[0.35 0.05 0.15 0.4]);
plot(Times,NumOverDiffs,'b- .'),
subplot('position',[0.55 0.05 0.3 0.4]);
plot(Times,RelMaxDiffs,'b- .');
subplot('position',[0.85 0.05 0.15 0.4]);
plot(Times,RelNumOverDiffs,'b- .'),

function PlotMaxes(M,LineC,h1,h2)
Times=M(2:end,1);
Thresh=ones(size(Times))*.00188;
Maximums=M(2:end,2);
Minimums=M(2:end,3);
NumOver=M(2,4)-M(2:end,4);
subplot(h1);plot(Times,Maximums,LineC,Times,Minimums,LineC,Times,Thresh)
subplot(h2);plot(Times,NumOver,LineC),title('# over thresh');

function Get2dData(Sq,Sp,X,Times,Inn);
dsmall
for i=1:length(Times)
	fn=['Lobe/MeshSSt'x2str(Ss) 'Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(Times(i)) '.dat'];
   M=load(fn);
   i
   X1=350+Inn+1:1000-350-Inn;
   if(Times(i)>0) eval(['M2dT' int2str(Times(i)) '=M(X1,X1);']);
   else eval(['M2dTSource=M(X1,X1);']);
   end
   fn2=['Lobe/MeshSSt'x2str(Ss) 'Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Inn'x2str(300-Inn) 'Data.mat'];
   if(i==1)
      eval(['save ' fn2 ' M2dTSource']);
	else
   	eval(['save ' fn2 ' M2dT' int2str(Times(i)) ' -append']);
	end
end

function[Over]=NumOver(M,Inn,Gr)

THRESHC=0.00188;
Dim=ndims(M);
if(nargin>1) X=Inn+1:Gr-Inn;
else X=1:length(M)
end
if(Dim==1) L=M(X,X);
elseif(Dim==2) L=M(X,X);
else L=M(X,X,X);
end
Over=length(find(L>=THRESHC));
