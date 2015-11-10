function[newA] = SetToCol(A,i,j,Col)
newA=A;
for k=1:length(i)
    newA(i(k),j(k))=Col;
end
