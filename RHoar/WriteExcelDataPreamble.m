function WriteExcelDataPreamble(fout)
fid=fopen(fout,'w');
% fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','TIME','L1','L2','L3','BUY','SELL');
fprintf(fid,'TIME\t\tL1\t\tL2\t\tL3\t\tBUY\t\tSELL\n\n');
fclose(fid);