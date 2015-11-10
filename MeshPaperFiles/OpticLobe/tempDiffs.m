function tempDiffs(Sq,t)
dsmall
Diam=2;
fn1=['SingleSource/MeshSSt1Gr1000Sq'num2str(Sq) 'SingStr1000T' num2str(t) '.dat'];
fn1=['SingleSource/MeshSSt1Gr1000Sq'num2str(Sq) 'SingTSt_01T' num2str(t) '.dat'];
fn2=['SingleSource/MeshSSt1Gr1000Sq'num2str(Sq) 'SingT' num2str(t) '.dat'];
M=load(fn1);
N=load(fn2);
L=N(401:600,401:600);
pcolor(L-M)
shading interp
colorbar
figure
plot((M(:,100)-L(:,100))./M(:,100))