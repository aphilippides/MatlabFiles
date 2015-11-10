function WriteLogData(AlertValue,t,AlertType,fout)
fid=fopen(fout,'a');

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

if(AlertType==1)
    fprintf(fid,'%s\tSELL\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==2)
    fprintf(fid,'%s\tDOWN2\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==3)
    fprintf(fid,'%s\tDOWN\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==4)
    fprintf(fid,'%s\tBUY \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==5)
    fprintf(fid,'%s\tUP2 \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==6)
    fprintf(fid,'%s\tUP  \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==7)
    fprintf(fid,'%s\tSELL2\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==8)
    fprintf(fid,'%s\tBUY2 \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==9)
    fprintf(fid,'%s\tSELL3\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==10)
    fprintf(fid,'%s\tBUY3 \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==11)
    fprintf(fid,'%s\tDOWN 1\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==12)
    fprintf(fid,'%s\tUP 1 \t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==13)
    fprintf(fid,'%s\tETREND DOWN\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==14)
    fprintf(fid,'%s\tETREND UP\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==15)
    fprintf(fid,'%s\tLOW 1\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==16)
    fprintf(fid,'%s\tHIGH 2\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==17)
    fprintf(fid,'%s\tTREND SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==18)
    fprintf(fid,'%s\tTREND BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==19)
    fprintf(fid,'%s\tLOW 1 DAY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==20)
    fprintf(fid,'%s\tHIGH 2 DAY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==21)
    fprintf(fid,'%s\tCOVER SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==22)
    fprintf(fid,'%s\tCOVER BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==23)
    fprintf(fid,'%s\tMID DOWN\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==24)
    fprintf(fid,'%s\tMID UP\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==25)
    fprintf(fid,'%s\tMID SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==26)
    fprintf(fid,'%s\tMID BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==27)
    fprintf(fid,'%s\tDIAGONAL SELL\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==28)
    fprintf(fid,'%s\tDIAGONAL BUY\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==29)
    fprintf(fid,'%s\tT SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==30)
    fprintf(fid,'%s\tT BUY\t\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==31)
    fprintf(fid,'%s\tCHANNEL SELL\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==32)
    fprintf(fid,'%s\tCHANNEL BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==33)
    fprintf(fid,'%s\tRETURN SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==34)
    fprintf(fid,'%s\tRETURN BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==35)
    fprintf(fid,'%s\tLINE SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==36)
    fprintf(fid,'%s\tLINE BUY\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==37)
    fprintf(fid,'%s\tBOX SELL\t\t%.2f\n',TimeStr,AlertValue);
elseif(AlertType==38)
    fprintf(fid,'%s\tBOX BUY\t\t%.2f\n',TimeStr,AlertValue);
end
fclose(fid);