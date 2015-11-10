
function ApplicantEmailList

[a,b]=xlsread('AppList.xls');
emails=b(2:end,1);
newemails=[];
for i=1:length(emails)
    if(sum(strcmp(char(emails(i)),newemails))==0)
        newemails=[newemails;emails(i)];
    end
end

AlreadySent={'Informatics ad day reigster 13042012.xls'};
asent=[];
for i=1:length(AlreadySent)
    [c,d]=xlsread(char(AlreadySent(i)));
    asent=[asent;d(2:end,3)];
end

notsent=[];
for i=1:length(newemails)
    if(sum(strcmp(char(newemails(i)),asent))==0)
        notsent=[notsent;newemails(i)];
    end
end
% xlswrite('notsentemails.xls',notsent);

fid=fopen('notsentemailList.csv','wt');


[rows,cols]=size(notsent);

for i=1:rows
fprintf(fid,'%s,',notsent{i,1:end-1})
fprintf(fid,'%s\n',notsent{i,end})
end

fclose(fid);
