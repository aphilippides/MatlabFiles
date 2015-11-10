function WriteLogDataPreamble(fout,s)
fid=fopen(fout,'a');
if(nargin==2)
    fprintf(fid,'%s\n\n',s);
end
fprintf(fid,'TIME\t\tSIGNAL\t\tVALUE\n');
fclose(fid);