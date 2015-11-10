function CheckTubesInLine(T)
dsmall
fn=['Lobe/MeshSSt1Gr1000X4Sq2Sp10Inn300Data.mat'];
load(fn)
eval(['M=M2dT' int2str(T*1000) ';'])
L=M(125,:)*1.324e-4*(pi/4);
[C,d]=TubesInSquare;%(3,100,200,T,2,10);
close
plot(d+155-0.5,C, 'b- .')
hold on
plot(L,'r: .')
hold off