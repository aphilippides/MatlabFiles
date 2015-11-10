function MScConveningXLSToTxtNew
dwork;
cd ../Current/MScConvening/2011/
fn='MScProjects1011.xlsx';

[a,b]=xlsread(fn);
b=b(2:end,:);
outf='MScStudentList2011 V2.txt';
curr=find(a(1:end,end)==1);
currb=b;%(curr,:);
curra=a;%(curr,:);
strs={'EASy';'IS  ';'POCS';'CS  ';'MAVE';'ITEC';'HCCS';'ACS '};
% courses={'Evol';'Inte';'Phil';'Crea';'Mult';'Info';'Huma';'Adva'};
courses={'Evol';'Inte';'Phil';'Crea';'Mult';'Info';'Huma';'Adva'};
fid=fopen(outf,'w');
for i=1:size(b,1)
    %     c=char(currb(i,7));
    c=char(currb(i,1));
    
    if(~isempty(c)) 
        ind2=strmatch(c(1:4),courses);
        if(~isempty(ind2)) ind=ind2; end
    else
        c=char(currb(i,3));
        if(isequal(c(1:3),'INT')) interm=1;
        else interm=0;
        end
        c=char(currb(i,5));
        pt2=0;
        if(isequal(c(1),'P'))
            c=char(currb(i,4));
            if(isequal(c(1),'1')) yst='PT1';
            else pt2=1;
            end
        else yst='FT';
        end
        
        if((~pt2)&(~interm))
            sname=char(currb(i,2));
            while(isspace(sname(1)))
                sname=sname(2:end);
            end
            fb=strfind(sname,',');
%             if(~isempty(fb))
%             end
            fname=sname((fb(1)+2:end));
            surname=sname(1:(fb(1)-1));
            fb=strfind(surname,' ');
            if(~isempty(fb))             
                surname=surname([1:fb(1)-1]); 
            end
            fb=strfind(fname,' ');
            if(~isempty(fb))
                fname=fname(1:(fb(1)-1));
            end
            %     fprintf(fid,'%s\t%d\t%s\t%s\t%s\t%s\n',char(strs(ind,:)),curra(i,1),...
            %         sname,fname,yst,char(currb(i,8)));
            fprintf(fid,'%s\t%d\t%s\t%s\t%s\t%s\n',char(strs(ind,:)),curra(i-1,1),...
                surname,fname,yst,char(currb(i,6)));
%             sprintf('%s\t%d\t%s\t%s\t%s\t%s\n',char(strs(ind,:)),curra(i-1,1),...
%                 surname,fname,yst,char(currb(i,6)))
        end
    end
end
fclose(fid)

