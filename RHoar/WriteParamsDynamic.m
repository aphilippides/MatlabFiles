function WriteParamsDynamic(fout,nS,EndPt,RPr,nSUD,EndPtUD,RPrUD,nSUD2, ...
    EndPtUD2,RPrUD2,nSUD3,EPUD3,RPUD3)
fid=fopen(fout,'a');
if(nargin==10)
fprintf(fid,'\nnSm = %d\t EP = %d\t RP = %f\t nSUD = %d\t EPUD = %d\t RPUD = %f\t nSUD2 = %d\t EPUD2 = %d\t RPUD2 = %f\n', ...
        nS,EndPt,RPr,nSUD,EndPtUD,RPrUD,nSUD2,EndPtUD2,RPrUD2);
elseif(nargin==9)
fprintf(fid,'\nnSm = %d\t EP = %d\t RP = %f\t nSUD = %d\t EPUD = %d\t RPUD = %f\nTimeLim = %d\t p1p2Lim = %d\n', ...
        nS,EndPt,RPr,nSUD,EndPtUD,RPrUD,nSUD2,EndPtUD2);
elseif(nargin==13)
fprintf(fid,'\nnSm = %d\t EP = %d\t RP = %f\t nSUD = %d\t EPUD = %d\t RPUD = %f\nnSUD2 = %d\t EPUD2 = %d\t RPUD2 = %f\tnSUD3 = %d\t EPUD3 = %d\t RPUD3 = %f\n', ...
        nS,EndPt,RPr,nSUD,EndPtUD,RPrUD,nSUD2,EndPtUD2,RPrUD2,nSUD3,EPUD3,RPUD3);
else
fprintf(fid,'\nnSmooth = %d\t EndPt = %d\t RangeProp = %f\t nSmoothUD = %d\t EndPtUD = %d\t RangePropUD = %f\n', ...
        nS,EndPt,RPr,nSUD,EndPtUD,RPrUD);
end
fclose(fid);