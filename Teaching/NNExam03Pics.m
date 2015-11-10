function NNExam03Pics

D1=[0 1; 1 2; 1 0; 2 0; 2 1; 2 2; 3 0];
D2=[1 1;  3 1; 3 2; 4 0];
plot(D1(:,1),D1(:,2),'rx',D2(:,1),D2(:,2),'bo')
SetYTicks(gca,5)
%SetXTicks(5)
axis equal
grid
axis([-0.1 4.1 -0.1 2.1])
