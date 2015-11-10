function WriteParams(fout,nPts1,nPred1,nPts2,nPred2)
fid=fopen(fout,'a');

fprintf(fid,'\nNumPts = %d\t\t NumPredict = %d\n\n',nPts1,nPred1);

if(nargin==5)
    fprintf(fid,'\nNumPts 2 = %d\t\t NumPredict 2 = %d\n\n',nPts2,nPred2);    
end
fclose(fid);