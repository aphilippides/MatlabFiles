function CheckTubesInLine(T)
dsmall
fn=['SingleSource/MeshSSt1Gr1000Sq23InLineT' int2str(T*1000) '.dat'];
M=load(fn);
pcolor(M)
L=M(100,:)*1.324e-4*(pi/4);
[C,d]=TubesInline(3,100,200,T,2,10);
close
plot(d+100+0.5,C, 'b- .')
hold on
plot(L,'r: .')
hold off