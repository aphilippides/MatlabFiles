function WriteExcelDataPreambleVol(fout,opt)
fid=fopen(fout,'w');
% fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','TIME','L1','L2','L3','BUY','SELL');
if(nargin<2) fprintf(fid,'TIME\t\tL1\t\tL2\t\tL3\t\tBUY\t\tSELL\t\tVOLUME\n\n');
elseif(opt==2) fprintf(fid,'TIME\t\tL1\t\tL2\t\tL3\t\tBUY\t\tSELL\t\tVOLUME\tT\tBV\tAV\n\n');
else fprintf(fid,'TIME\t\tL1\t\tL2\t\tL3\t\tBUY\t\tSELL\t\tVOLUME\tT\n\n');
end
fclose(fid);