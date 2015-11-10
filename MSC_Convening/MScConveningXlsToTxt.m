function MScConveningXLSToTxt
dwork;
cd ../Current/MScConvening/2010/
fn='MSc Diss Students0910.xls';

[a,b]=xlsread(fn);
b=b(2:end,:);
outf='MScStudentList2010.txt';
curr=find(a(1:end,end)==1);
currb=b(curr,:);
curra=a(curr,:);
strs={'EASy';'IS  ';'POCS';'CS  ';'MAVE';'ITEC';'HCCS'};
courses={'Evol';'Inte';'Phil';'Crea';'Mult';'Info';'Huma'}
fid=fopen(outf,'w');
for i=1:size(curra,1)
    c=char(currb(i,7));
    ind=strmatch(c(1:4),courses);
    c=char(currb(i,6));
    if(isequal(c(1),'P')) yst='PT1';
    else yst='FT';
    end

    sname=char(currb(i,2));
    while(isspace(sname(1)))
        sname=sname(2:end);
    end
    fb=strfind(sname,' ');
    if(~isempty(fb))
        sname=sname(1:(fb(1)-1));
    end
    
    fname=char(currb(i,3));
    while(isspace(fname(1)))
        fname=fname(2:end);
    end
    fb=strfind(fname,' ');
    if(~isempty(fb))
        fname=fname(1:(fb(1)-1));
    end
    fprintf(fid,'%s\t%d\t%s\t%s\t%s\t%s\n',char(strs(ind,:)),curra(i,1),...
        sname,fname,yst,char(currb(i,8)));
end
fclose(fid)
% find
