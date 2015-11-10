function PrettyPics

function tempDiffs(t)
t=500
dsmall
fn1=['SingleSource/MeshSSt1Gr1000Sq2SingStr1000T' num2str(t) '.dat'];
fn2=['SingleSource/MeshSSt1Gr1000Sq2SingT' num2str(t) '.dat'];
M=load(fn1);
N=load(fn2);
L=N(401:600,401:600);
pcolor(L*1000-M)
pcolor(L*1000-M)
shading interp