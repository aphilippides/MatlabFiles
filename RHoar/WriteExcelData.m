function WriteExcelData(t,l1,l2,l3,buy,sell,fout)
s=round(t(3));
m=round(t(2));
h=round(t(1));
if(s<10) TimeStr=['0' int2str(s)];
else TimeStr=[int2str(s)];
end
if(m<10) TimeStr=['0' int2str(m) ':' TimeStr];
else TimeStr=[int2str(m) ':' TimeStr];
end
if(h<10) TimeStr=['0' int2str(h) ':' TimeStr];
else TimeStr=[int2str(h) ':' TimeStr];
end
fid=fopen(fout,'a');
fprintf(fid,'%s\t%f\t%f\t%f\t%.2f\t%.2f\n',TimeStr,l1,l2,l3,buy,sell);
fclose(fid);