% function to check timestep differences for 2D results

function CheckSpaceStep(Sq,Sp,X,T,SSt,Tol,Inn)

%dumm
PlotAll(Sq,Sp,X,SSt(1),SSt(2),T,Tol,Inn);

function dumm
M=zeros(16,16);
M(4,4)=1;
M(5,4)=2;
M(4,5)=3;
M(5,5)=4;
pcolor([M M;M M]);
figure
N=GetAvg([M M;M M]);
figure,pcolor(N)
%X=245:260;
X=1:15;
subplot(2,2,1);pcolor(M11(X,X));,shading flat
subplot(2,2,2);pcolor(M12(X,X));,shading flat
subplot(2,2,3);pcolor(M21(X,X));,shading flat
subplot(2,2,4);pcolor(M22(X,X));,shading flat


function PlotLine(Sq,Sp,X,Z,T,Tol,Inn,Line,Sl,MAll)
M=GetM(MAll,T);
L=M(Line,:);
dsmall
fn2=['../MaxMinPerp/LobeMax/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
M2=load(fn2);
X2=Inn+1:300-Inn;
L2=M2(Line,X2)*1.324e-4;
L=L(X2)*1.324e-4;
subplot(3,1,1),
plot(X2,L,'b',X2,L2,'r:')
legend('2d','3d',0)
subplot(3,1,2),
plot((L-L2)*100./L2)
subplot(3,1,3),
plot(L-L2)
%X2=Inn+1:100-Inn;
%L2=M2(50-Line,X2);
%fn2=['../MaxMinPerp/LobeMax/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T-1.dat'];
%pcolor(M2-M(X,X)*8)

function PlotAll(Sq,Sp,X,SSt1,SSt2,T,Tol,Inn)
FigHdl=gcf;
set(FigHdl,'Units','centimeters');
Xf=get(FigHdl,'Position');
set(FigHdl,'Position',[Xf(1) Xf(2) 18 10]);
set(FigHdl,'PaperPositionMode','auto');
Gr=1000;
dsmall
fn1=['Lobe/MeshSSt'x2str(SSt1) 'Gr'x2str(Gr) 'X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T) '.dat'];
fn2=['Lobe/MeshSSt'x2str(SSt2) 'Gr'x2str(Gr/SSt2) 'X'x2str(X) 'Sq'x2str(Sq/SSt2) 'Sp'x2str(Sp/SSt2) 'T'x2str(T) '.dat'];
M=load(fn1);
M1=GetAvg(M);
M2=load(fn2);
X2=Inn+1:Gr/SSt2-Inn;
subplot(1,3,1),pcolor(M1(X2,X2)),colorbar,shading flat
subplot(1,3,2),pcolor(M2(X2,X2)),colorbar,shading flat
subplot(1,3,3),
%pcolor((M2(X2,X2)-M1(X2,X2)).*100./M2(X2,X2)),shading interp,colorbar
pcolor((M2(X2,X2)-M1(X2,X2))),shading interp,colorbar


function[NewM]=GetAvg(M)

M11=M(2:2:end-1,2:2:end-1);
M12=M(3:2:end,2:2:end-1);
M21=M(2:2:end-1,3:2:end);
M22=M(3:2:end,3:2:end);
NewM=(M11+M12+M21+M22)*0.25;

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

function CompareMaxMinAll(Sq,Sp,X,Z,Timez,Tol,Inn,Sl)
dsmall
cd ../MaxMinPerp/;
Gr=300;
for k=1:length(Timez)
   T = Timez(k)
	fn=['LobeMax/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
	fn2=['LobeMin/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
   L1=load(fn );
   L2=load(fn2);
   M1=L1(1+Inn:Gr-Inn,1+Inn:Gr-Inn);
   M2=L2(1+Inn:Gr-Inn,1+Inn:Gr-Inn);
   Difer=M2-M1 ;
   total = 0;
   RelDif=Difer./M2;
   %   RelDif=Difer/max(max(M1));
   Timez(k)=T;
   PlusRels(k)=max(max(RelDif))
   MinusRels(k)=min(min(RelDif))
   PlusDiffs(k)=max(max(Difer))
   MinusDiffs(k)=min(min(Difer))
   Reld=abs(RelDif);
   Rel=(Reld>Tol);
   numbad(k)=sum(sum(Rel))
   subplot(1,3,1),pcolor(RelDif),colorbar,shading interp,subplot(1,3,2),pcolor(M1)
   shading interp,subplot(1,3,3),pcolor(Difer),colorbar,shading interp
   figure
   %contour(RelVal,[ .025 ]) 
   %[c,h]=contour(RelVal,[ .05 .025 .01]) ;
   %clabel(c,h)
end
subplot(3,1,1),plot(Timez,PlusRels,Timez,MinusRels,'r:')
subplot(3,1,2),plot(Timez,PlusDiffs,Timez,MinusDiffs,'r:')
subplot(3,1,3),plot(Timez,numbad)

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

function PlotMaxes(M,LineC,h1,h2)

[Y,X]=size(M);
%Times=2:1:Y;
Times=M(2:Y,1);
Thresh=ones(Y-1)*.00188;
Maximums=M(2:Y,2);
Minimums=M(2:Y,3);
NumOver=M(2,4)-M(2:Y,4);
%PCNot=NumNot./((GridSize/2)^3);
subplot(h1);
plot(Times,Maximums,LineC,Times,Minimums,LineC,Times,Thresh)
%legend('Max Conc', 'Min Conc','Thresh Conc');
subplot(h2);
plot(Times,NumOver,LineC),title('# over thresh');

function Get2dData(Sq,Sp,X,Times,Inn);

dsmall
for i=1:length(Times)
	fn=['Lobe/MeshSSt1Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(Times(i)) '.dat'];
%	fn=['SingleSource/MeshSSt1Gr1000Sq'x2str(Sq) 'SingT'x2str(Times(i)) '.dat'];
   M=load(fn);
   i
   X1=350+Inn+1:1000-350-Inn;
   if(Times(i)>0) eval(['M2dT' int2str(Times(i)) '=M(X1,X1);']);
   else eval(['M2dTSource=M(X1,X1);']);
   end
   fn2=['Lobe/MeshSSt1Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Inn'x2str(300-Inn) 'Data.mat'];
   if(i==1)
      eval(['save ' fn2 ' M2dTSource']);
	else
   	eval(['save ' fn2 ' M2dT' int2str(Times(i)) ' -append']);
	end
end

function TempChangeNames(Sq,Sp,X,T);

dsmall
Sl=0:2;
Z=[50 250 100 200 250];
for i=1:length(Sl)
   for j=1:2%length(Z)
      for k=1:length(T)
         [i j k]
         fn2=['../MaxMinPerp/LobeMin/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z(j)) 'Sq'x2str(Sq) 'Sp0Sl'x2str(Sl(i)) 'T'x2str(T(k)) '.dat'];
         M=load(fn2);
         fn2=['../MaxMinPerp/TempMin/MeshSSt1Gr300X'x2str(X) 'Z'x2str(Z(j)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl(i)) 'T'x2str(T(k).*4) '.dat'];
         save(fn2,'M','-ascii');
      end
   end
end

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
