function LobeMaxMinDiffs(Sq,Sp,SSt,X,Z,Sl)

Sqare=1;
dmmp;
%filename=['Lobe/MeshSSt' x2str(SSt) 'MaxGr300X' x2str(X) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'Sl' int2str(Sl) '.dat']
fn=['LobeMax/MeshSSt' x2str(SSt) 'MaxGr300X' x2str(X) 'Z' x2str(Z) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'Sl' int2str(Sl) '.dat']
fn2=['LobeMin/MeshSSt' x2str(SSt) 'MaxGr300X' x2str(X) 'Z' x2str(Z) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'Sl' int2str(Sl) '.dat']
M2=load(fn);
M=load(fn2);
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