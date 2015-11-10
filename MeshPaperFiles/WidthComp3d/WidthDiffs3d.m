function TreeDiffs3d(GridSize, Density,Version,Version2)

Sqare=1;
filename=['TreeRho' num2str(Density) '/TreeV' int2str(Version) 'MaxGr' num2str(GridSize) 'Sq' num2str(Sqare) '.dat']
filename2=['TreeRho' num2str(Density) '/TreeV' int2str(Version2) 'MaxGr' num2str(GridSize) 'Sq' num2str(Sqare) '.dat']
M=load(filename);
M2=load(filename2);
[Y,X]=size(M);
[Y2,X]=size(M2);
if(Y2<Y)
   %Y=Y2;
end
%Times=2:1:Y;
Times1=M(2:Y,1);
Max1=M(2:Y,2);
Min1=M(2:Y,3);
Not1=M(2:Y,4);
Times2=M2(2:Y2,1);
Max2=M2(2:Y2,2);
Min2=M2(2:Y2,3);
Not2=M2(2:Y2,4);
subplot(1,2,1)
MaxDiffs=(M(2:Y,2)-M2(2:Y,2))./M(2:Y,2);
MinDiffs=(M(2:Y,3)-M2(2:Y,3))./M(2:Y,3);
%plot(Times1,MaxDiffs,Times,MinDiffs)%,Times,NumNotDiffs),
plot(Times1,Max1,Times1,Min1,Times2,Max2,'r',Times2,Min2,'r')%,Times,NumNotDiffs),
subplot(1,2,2)
NumNotDiffs=((M(2:Y,4)./3375000)-(M2(2:Y,4)./1e6))./(M(2:Y,4)./3375e3);
%plot(Times,MaxDiffs,Times,MinDiffs)%,Times,NumNotDiffs),
%legend('MaxDiffs','MinDiffs','NumNotDiffs')
PCNot1=M(2:Y,4)./3375000;
PCNot2=M2(2:Y2,4)./3.375e6;
plot(Times1,PCNot1,Times2,PCNot2)