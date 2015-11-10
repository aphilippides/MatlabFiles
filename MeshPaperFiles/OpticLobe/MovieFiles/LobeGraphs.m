function LobeGraphs(Spacings,SpaceSteps,SquareSizes,GridSizes,Ranges)

Colors=['b-* ';'g--o';'y-d ';'k-.s';'c-^ ';'r--x'];
Len=max([length(Spacings),length(SpaceSteps),length(SquareSizes),length(GridSizes),length(Ranges)]);
for i=1:Len
   if(length(SquareSizes)>1)
      Sq=SquareSizes(i);
   else 
      Sq=SquareSizes;
   end
   
   if(length(Spacings)>1)
      Space=Spacings(i);
   else 
      Space=Spacings;
   end
   
   if(length(GridSizes)>1)
      Gr=GridSizes(i);
   else 
      Gr=GridSizes;
   end
   GrSq=Gr^2;   
   
   if(length(SpaceSteps)>1)
      SSt=SpaceSteps(i);
   else 
      SSt=SpaceSteps;
   end
   if(length(Ranges)>1)
      Range=Ranges(i);
   else 
      Range=Ranges;
   end
   
   filename2=['Lobe/MeshSSt' int2str(SSt) 'MaxGr' int2str(Gr) 'X' ...
         num2str(Range) 'Sq' num2str(Sq) 'Sp' int2str(Space) '.dat']
   M2=load(filename2);
   if(i==1)
      MFirst=M2;
      GrFirst=GrSq;
      SStFirst=SSt;
   elseif(i==2)
      MSecond=M2;
      GrSecond=GrSq;
      SStSecond=SSt;
   end
   
   [x2,y]=size(M2);
   plot(M2(2:x2,1),(GrSq-M2(2:x2,4))/(SSt*SSt),Colors(i,:),'MarkerSize',8),hold on
end

if length(Spacings==1)
   Spacings=ones(1,i).*Spacings
end
SSt
if(length(SpaceSteps)>1)
   legend(num2str((Spacings/SpaceSteps(i))'))
else
   legend(num2str((Spacings./SSt)'))
end

title(['SquareSize' num2str(Sq/SpaceSteps(1)) ])
hold off

if(i==2)
	ShowDiffs(MFirst,MSecond,GrFirst,GrSecond,SStFirst,SStSecond)
end

function ShowDiffs(M,N,Gr1,Gr2,SSt1,SSt2)

figure
[x,y]=size(M);
[x2,y2]=size(N);
Len=min(x,x2);
MaxDiffs=M(2:Len,2)-N(2:Len,2);
RelMax=MaxDiffs./max(M(2:Len,2));
MinDiffs=M(2:Len,3)-N(2:Len,3);
RelMin=MinDiffs./max(M(2:Len,3));
NumOverDiffs=((Gr1-M(2:Len,4))/(SSt1*SSt1))-((Gr2-N(2:Len,4))/(SSt2*SSt2));
RelOver=NumOverDiffs./max(((Gr1-M(2:Len,4))/(SSt1*SSt1))); 
Times=M(2:Len,1);
subplot(3,2,1),plot(Times,MaxDiffs);
title(['Max MaxDiff=' num2str(max(abs(MaxDiffs))) '; Rel Max=' num2str(max(abs(RelMax))) ])
subplot(3,2,2),plot(Times,M(2:Len,2),Times,N(2:Len,2),'r:');

subplot(3,2,3),plot(Times,MinDiffs);
title(['Max MinDiff=' num2str(max(abs(MinDiffs))) '; Rel Min=' num2str(max(abs(RelMin)))]);
subplot(3,2,4),plot(Times,M(2:Len,3),Times,N(2:Len,3),'r:');

subplot(3,2,5),plot(Times,NumOverDiffs);
title(['Max OverDiff=' num2str(max(abs(NumOverDiffs))) '; Rel Over=' num2str(max(abs(RelOver)))])
subplot(3,2,6),plot(Times,(Gr1-M(2:Len,4))/(SSt1*SSt1),Times,(Gr2-N(2:Len,4))/(SSt1*SSt1),'r:');
