function GetFin2InfData
for t=500:500:2000
    GetNumOverDatAllZ(1,5,49,[50:50:250],t,0,1)
    GetNumOverDatAllZ(1,5,49,[50:50:250],t,0,2)
    %GetNumOverDatAllSl(1,5,49,250,t,0,0:3)
    X=[2,4,5,7,8,9,10].^2;
 %   GetNumOverDatAllX(1,5,X,100,t,0,0)
end

function GetNumOverDatAllZ(Sq,Sp,X,Z,T,Inn,Sl)
Ss=2;
dsmall
fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'MaxGr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
M=load(fn);
for i=1:length(Z)
    dsmall
    fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T) '.dat'];
    M3=load(fn);
    NumOver2dM(i)=NumOver(M3,Inn,300);
    cd ../MaxMinPerp;
    fn2=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
    M2=load(fn2);
    NumOver3dMax(i)=NumOver(M2,Inn,300);
    fn2=['LobeMin/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
    if(IsFile(fn2)) 
        M2=load(fn2);
        NumOver3dMin(i)=NumOver(M2,Inn,300);
    else 
        NumOver3dMin(i)=0;%NumOver3dMax(i);
    end      
    ind=find(M(2:end,1)==T/1000)
    NumOver2d(i)=1e6-M(ind,4);
end
Est3d=0.5*(NumOver3dMax+NumOver3dMin)
MinMaxErr3d=(NumOver3dMax-Est3d)./Est3d
FinInfErr=(NumOver3dMax-NumOver2d)./NumOver2d
FinInfErrEst=(Est3d-NumOver2d)./NumOver2d
dthesisdat
fn=['MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'AllZSq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) 'NumOver.mat'];
save(fn,'Z','NumOver2d','NumOver3dMax','NumOver3dMin','NumOver2dM')
plot(Z,NumOver2d,Z,NumOver3dMax,'r:',Z,NumOver3dMin,'g--',Z,NumOver2dM,'y--')

function GetNumOverDatAllSl(Sq,Sp,X,Z,T,Inn,Sl)
Ss=2;
dsmall
fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'MaxGr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
M=load(fn);
for i=1:length(Sl)
    dsmall
    fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'Gr1000X'x2str(X) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T) '.dat'];
    M3=load(fn);
    NumOver2dM(i)=NumOver(M3,Inn,300);
    cd ../MaxMinPerp;
    fn2=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl(i)) 'T'x2str(T) '.dat'];
    M2=load(fn2);
    NumOver3dMax(i)=NumOver(M2,Inn,300);
    fn2=['LobeMin/MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl(i)) 'T'x2str(T) '.dat'];
    if(IsFile(fn2)) 
        M2=load(fn2);
        NumOver3dMin(i)=NumOver(M2,Inn,300);
    else 
        NumOver3dMin(i)=0;%NumOver3dMax(i);
    end      
    ind=find(M(2:end,1)==T/1000)
    NumOver2d(i)=1e6-M(ind,4);
end
dthesisdat
fn=['MeshSSt'x2str(Ss) 'Gr300X'x2str(X) 'AllSlZ'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T) 'NumOver.mat'];
save(fn,'Sl','NumOver3dMax','NumOver3dMin','NumOver2d','NumOver2dM')

function GetNumOverDatAllX(Sq,Sp,X,Z,T,Inn,Sl)
Ss=2;
dsmall

for i=1:length(X)
    dsmall
    fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'MaxGr1000X'x2str(X(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) '.dat'];
    M=load(fn);
    fn=['Lobe/Mesh2dCheckSSt'x2str(Ss) 'Gr1000X'x2str(X(i)) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'T'x2str(T) '.dat'];
    M3=load(fn);
    NumOver2dM(i)=NumOver(M3,Inn,300);
    cd ../MaxMinPerp;
    fn2=['LobeMax/MeshSSt'x2str(Ss) 'Gr300X'x2str(X(i)) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
    M2=load(fn2);
    NumOver3dMax(i)=NumOver(M2,Inn,300);
    fn2=['LobeMin/MeshSSt'x2str(Ss) 'Gr300X'x2str(X(i)) 'Z'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) '.dat'];
    if(IsFile(fn2)) 
        M2=load(fn2);
        NumOver3dMin(i)=NumOver(M2,Inn,300);
    else 
        NumOver3dMin(i)=0;%NumOver3dMax(i);
    end      
    ind=find(M(2:end,1)==T/1000)
    NumOver2d(i)=1e6-M(ind,4);
end
dthesisdat
fn=['MeshSSt'x2str(Ss) 'Gr300AllXZ'x2str(Z) 'Sq'x2str(Sq) 'Sp'x2str(Sp) 'Sl'x2str(Sl) 'T'x2str(T) 'NumOver.mat'];
save(fn,'X','NumOver3dMax','NumOver3dMin','NumOver2d','NumOver2dM')


function[Over]=NumOver(M,Inn,Gr)

THRESHC=0.00188;
Dim=ndims(M);
if(nargin>1) X=Inn+1:Gr-Inn;
else X=1:length(M)
end
if(Dim==1) L=M(X,X);
elseif(Dim==2) L=M(X,X);
else L=M(X,X,X);
end
Over=length(find(L>THRESHC));