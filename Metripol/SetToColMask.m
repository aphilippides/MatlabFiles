function[newA] = SetToColMask(A,mask,Col)
% func=inline('SetToColFilt(x,c)');
newA=roifilt2(A,mask,'SetToColFilt',Col);

function dummy
newA=A;
[i,j]=find(m);
for k=1:length(i)
    newA(i(k),j(k))=Col;
end