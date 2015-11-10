% function to check the differences betwwen Max and min versions 
% function MaxMinDiffs2d(Gr,Sq,Sp,X,T)

function MaxMinDiffs3d(Gr,Sq,Sp,X,V,Sl,Rho)%Timez,Tol,Inn)

d3dmm
Timez=-1;
Tol=0.01;
Inn=0;
CompareAll(Gr,Sq,Sp,X,V,Rho,Timez,Tol,Inn)
%TMaxMinDiffs(Gr,Sq,Sp,X,V,Sl,Rho)
%WMaxMinDiffs(Gr,Sq,Sp,X,V,Sl,Rho,4,4)

function CompareAll(Gr,Sq,Sp,X,V,Rho,Timez,Tol,Inn)
for k=1:length(Timez)
   T = Timez(k)
	filename=['MaxTreeRho' int2str(Rho) '/TreeSSt1V' int2str(V) 'Gr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'T'int2str(T) '.dat']
	filename2=['MinTreeRho' int2str(Rho) '/TreeSSt1V' int2str(V) 'Gr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'T'int2str(T) '.dat']
   L1=load(filename );
   L2=load(filename2);
   M1=L1;%(1+Inn:Gr-Inn,1+Inn:Gr-Inn);
   M2=L2;%(1+Inn:Gr-Inn,1+Inn:Gr-Inn);
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
 %  subplot(1,3,1),pcolor(RelDif),colorbar,shading interp,subplot(1,3,2),pcolor(M1),shading interp,subplot(1,3,3),pcolor(Difer),colorbar,shading interp
   pcolor(Difer),colorbar,shading interp,
   figure
   %contour(RelVal,[ .025 ]) 
   %[c,h]=contour(RelVal,[ .05 .025 .01]) ;
   %clabel(c,h)
end
subplot(3,1,1),plot(Timez,PlusRels,Timez,MinusRels,'r:')
subplot(3,1,2),plot(Timez,PlusDiffs,Timez,MinusDiffs,'r:')
subplot(3,1,3),plot(Timez,numbad)

function TMaxMinDiffs(Gr,Sq,Sp,X,V,Sl,Rho)

filename=['MaxTreeRho' int2str(Rho) '/TreeSSt1V' int2str(V) 'MaxGr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'Sl'int2str(Sl) '.dat']
filename2=['MinTreeRho' int2str(Rho) '/TreeSSt1V' int2str(V) 'MaxGr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'Sl'int2str(Sl) '.dat']
M2=load(filename);
M=load(filename2);
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
RelMaxDiffs=MaxDiffs./(M(2:Y,2));
MinDiffs=(M(2:Y,3)-M2(2:Y,3));
RelMinDiffs=MinDiffs./(M(2:Y,3));
NumOverDiffs=(M(2:Y,4)-M2(2:Y,4));
RelNumOverDiffs=NumOverDiffs./(M(2,4)-(M(2:Y,4)));
subplot('position',[0.05 0.05 0.3 0.4]);
plot(Times,MaxDiffs,Times,MinDiffs);
subplot('position',[0.35 0.05 0.15 0.4]);
plot(Times,NumOverDiffs),
subplot('position',[0.55 0.05 0.3 0.4]);
plot(Times,RelMaxDiffs,Times,RelMinDiffs);
subplot('position',[0.85 0.05 0.15 0.4]);
plot(Times,RelNumOverDiffs),

function WMaxMinDiffs(Gr,Sq,Sp,X,V,Sl,Rho,W,W2)

filename=['MaxW' int2str(W) 'Rho'int2str(Rho) '/TreeSSt1V' int2str(V) 'MaxGr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'Sl'int2str(Sl) '.dat']
filename2=['MinW' int2str(W2) 'Rho'int2str(Rho) '/TreeSSt1V' int2str(V) 'MaxGr' int2str(Gr) 'X' int2str(X) 'Z' int2str(X) 'Sq' int2str(Sq) 'Sp'int2str(Sp) 'Sl'int2str(Sl) '.dat']
M2=load(filename);
M=load(filename2);
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
RelMaxDiffs=MaxDiffs./(M(2:Y,2));
MinDiffs=(M(2:Y,3)-M2(2:Y,3));
RelMinDiffs=MinDiffs./(M(2:Y,3));
NumOverDiffs=(M(2:Y,4)-M2(2:Y,4));
RelNumOverDiffs=NumOverDiffs./(M(2,4)-(M(2:Y,4)));
subplot('position',[0.05 0.05 0.3 0.4]);
plot(Times,MaxDiffs,Times,MinDiffs);
subplot('position',[0.35 0.05 0.15 0.4]);
plot(Times,NumOverDiffs),
subplot('position',[0.55 0.05 0.3 0.4]);
plot(Times,RelMaxDiffs,Times,RelMinDiffs);
subplot('position',[0.85 0.05 0.15 0.4]);
plot(Times,RelNumOverDiffs),


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
