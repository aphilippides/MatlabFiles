function[ok,newflist]=CheckFileList2012

load FileList.mat;
s=dir;
fdrs=s([s.isdir]);
c=1;
hm=cd;
for i=1:length(fdrs)
    cd(fdrs(i).name)
    if(isfile('AviFileData.mat'))
        newflist(c).name=[fdrs(i).name '.avi'];
        c=c+1;
    end
    cd(hm)
end
% nolm=[];
% for i=1:length(newflist)
%     fn=newflist(i).name;
%     if(~isfile([fn(1:end -4) 'NestLMData.mat']))
%         nolm=[nolm i];
%     end
% end
a=newflist.name;
b=FList12.name;
ok=isequal(a,b);