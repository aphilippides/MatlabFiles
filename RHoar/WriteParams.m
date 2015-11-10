function WriteParams(fout,nSmooth,Thresh,EndPt,TimeLim,MultipleLimit,EndPt2,nSmoothL1)
fid=fopen(fout,'a');

if(nargin==6)
    fprintf(fid,'\nnSmooth = %d\t Thresh = %f\t EndPt = %d\t TimeLim = %d\t MultipleLimit = %d\n', ...
        nSmooth,Thresh,EndPt,TimeLim,MultipleLimit);
elseif(nargin==8)
    fprintf(fid,'\nnSmooth = %d\t Thresh = %f\t EndPt = %d\t nSmoothL1 = %d\t nSmoothL2 = %d\nTimeLim = %d\t MultipleLimit = %d\n', ...
        nSmooth,Thresh,EndPt,nSmoothL1,EndPt2,TimeLim,MultipleLimit);
elseif(nargin==7)
    fprintf(fid,'\nnSmooth = %d\t Up EndPt = %d\t Down EndPt = %d\n', ...
        nSmooth,EndPt,EndPt2);
else
    fprintf(fid,'\nnSmooth = %d\t\t Thresh = %f\t\t EndPt = %d\n',nSmooth,Thresh,EndPt);
end
% if(nargin==5)
%     fprintf(fid,'\nNumPts 2 = %d\t\t NumPredict 2 = %d\n\n',nPts2,nPred2);    
% end
fclose(fid);