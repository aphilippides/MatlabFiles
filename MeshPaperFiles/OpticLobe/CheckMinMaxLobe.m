% function to check timestep differences for 2D results

function[MeanErr, SDErr]=CheckMinMaxLobe(SSt,Sq,Sp,X,Z,T,Tol,Inn,Sl)
MeanErr=0;SDErr=0;
%PlotLine(Sq,Sp,X,Z,T,Tol,Inn,Line,Sl,MAll);
%figure
[MeanErr, SDErr]=PlotAll2(SSt,Sq,Sp,X,Z,T,Tol,Sl);
%GetMMEsts(SSt,Sq,Sp,X,Z,T,Tol,Sl);
%CompareMaxMinAll(Sq,Sp,X,Z,T,Tol,Inn,Sl)
%CheckNumOver(Sq,Sp,X,Z,T,Tol,Inn,Sl,MAll)
%figure
%GetSlNumOverDat(Sq,Sp,X,Z,T,Inn,Sl)


function PlotAll(X,Z,T,Tol,Inn,MAll,Sl)
dmmp
fn=['LobeMax/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq2Sp10Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M=load(fn);
Is=1+Inn:length(M)-Inn;
MMax=M(Is,Is);
min(min(MMax))*1.324e-4
fn=['LobeMin/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq2Sp10Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M=load(fn);
MMin=M(Is,Is);
Est=(MMax+MMin)*0.5;
[RelErr,SDErr]=Compare2(MMax,Est,Tol)

function[MeanRDiff, StdRDiff]=PlotAll2(SSt,Sq,Sp,X,Z,T,Tol,Sl)
dmmp
for t=1:length(T)
   fn=['LobeMin/MeshSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(t)) '.dat'];
   M=load(fn)*1.324e-4;
   fn=['LobeMax/MeshSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T(t)) '.dat'];
   M2=load(fn)*1.324e-4;
   [Differ, RelDiff,NewM,NewM2]=Compare2RegInt(M,M2,Tol);
   [i,j,v]=find(RelDiff);
   if(isempty(v)) v=0; end;
   MeanRDiff(t)=mean(v)
   StdRDiff(t)=std(v)
end

function GetMMEsts(SSt,Sq,Sp,X,Z,T,Tol,Sl)
dmmp
fn=['LobeMin/MeshSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M=load(fn)*1.324e-4;
fn=['LobeMax/MeshSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M2=load(fn)*1.324e-4;
MMEst=(M+M2).*0.5;
fn=['LobeMaxMin/MaxMinEstSSt'x2str(SSt) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
save(fn,'MMEst','-ascii')


function MaxMinDiffs(M,M2)

MinMaxHndl=subplot('position',[0.05 0.55 0.4 0.4]);
PCNotHndl=subplot('position',[0.55 0.55 0.4 0.4]);

PlotMaxes(M,'b',MinMaxHndl,PCNotHndl);
subplot(MinMaxHndl),hold on;subplot(PCNotHndl),hold on;
PlotMaxes(M2,'r:',MinMaxHndl,PCNotHndl);
subplot(MinMaxHndl),hold off;subplot(PCNotHndl),hold off;
[Y,X]=size(M);
[Y2,X]=size(M2);
if(Y2<Y)
   Y=Y2;
end
%Times=2:1:Y;
Times=M(2:Y,1);
MaxDiffs=(M(2:Y,2)-M2(2:Y,2));
RelMaxDiffs=MaxDiffs./max(M(2:Y,2));
MinDiffs=(M(2:Y,3)-M2(2:Y,3));
RelMinDiffs=MinDiffs./max(M(2:Y,3));
NumOverDiffs=(M(2:Y,4)-M2(2:Y,4));
RelNumOverDiffs=NumOverDiffs./max(M(2,4)-(M(2:Y,4)));
subplot('position',[0.05 0.05 0.3 0.4]);
plot(Times,MaxDiffs,Times,MinDiffs);
subplot('position',[0.35 0.05 0.15 0.4]);
plot(Times,NumOverDiffs,'b- .'),
subplot('position',[0.55 0.05 0.3 0.4]);
plot(Times,RelMaxDiffs,'b- .',Times,RelMinDiffs,'r- .');
subplot('position',[0.85 0.05 0.15 0.4]);
plot(Times,RelNumOverDiffs,'b- .'),

function[Over]=NumOver(M,Inn,Gr)

THRESHC=0.00188;
Dim=ndims(M);
if(nargin>1) X=Inn+1:Gr-Inn;
else X=1:length(M);
end
if(Dim==1) L=M(X,X);
elseif(Dim==2) L=M(X,X);
else L=M(X,X,X);
end
Over=length(find(L>THRESHC));

function[MeanRel,SDRel]=Compare2(M1,M2,Tol)
Difer=M2-M1 ;
RelDif=Difer*100./M2;
PlusRels=max(max(RelDif));
MinusRels=min(min(RelDif));
PlusDiffs=max(max(Difer));
MinusDiffs=min(min(Difer));
Reld=abs(RelDif);
Rel=(Reld>Tol);
numbad=sum(sum(Rel))
subplot(1,3,1),pcolor(RelDif),colorbar,shading interp,subplot(1,3,2),pcolor(M1)
shading interp,subplot(1,3,3),pcolor(Difer),colorbar,shading interp
MeanRel=MMean(RelDif);
SDRel=MStd(RelDif);
Median=MMedian(RelDif)

function GetSlNumOverDat(Sq,Sp,X,Z,T,Inn,Sl)

THRESHC=0.00188;
dsmall
fn=['Lobe/MeshSSt1MaxGr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
M=load(fn);
cd ../MaxMinPerp;
ind=find(M(:,1)==T/1000)
NumOver2d=1e6-M(ind,4)*ones(size(Z))
for i=1:length(Z)
   fn2=['LobeMax/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
   M2=load(fn2);
   NumOver3dMax(i)=NumOver(M2,Inn,300)
   fn2=['LobeMin/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
   if(IsFile(fn2)) 
	   M2=load(fn2);
      NumOver3dMin(i)=NumOver(M2,Inn,300)
   else 
      NumOver3dMin(i)=NumOver3dMax(i)
   end      
end
Est3d=0.5*(NumOver3dMax+NumOver3dMin)
Err3d=(NumOver3dMax-Est3d)./Est3d
FinErr1=(Est3d-NumOver2d)./NumOver2d
fn=['LobeMax/MeshSSt1Gr300X'x2str(X) 'AllZSq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) 'NumOver.mat'];
save(fn,'T','NumOver2d','NumOver3dMax','NumOver3dMin')
plot(Z,NumOver2d,Z,NumOver3dMax,'r:',Z,NumOver3dMin,'g--',Z,Est3d,'y')
