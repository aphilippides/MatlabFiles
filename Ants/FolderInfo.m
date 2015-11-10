function[dname,maxn,nf] = FolderInfo(s)

if(s<10) sn=['s000000' int2str(s)];
elseif(s<100) sn=['s00000' int2str(s)];
else sn=['s0000' int2str(s)];
end
d=dir;
bad=1;
for i=1:length(d)
    if(d(i).isdir)
        dname = [d(i).name '\' sn];
        if(isdir(dname))
            bad =0;
            break;
        end;
    end
end
if(bad)
    dname=[];
    maxn=0;
    nf=-1;
    return;
end
d=dir([dname '\dvr*.tif']);
nf=0;
if(isempty(d))
    d=dir(dname);
    isok=0;
    while(1)
        fd=['000' int2str(nf) '0000'];
        if(isempty(strmatch(fd,char(d.name))))
            if(isok)
                nf=nf-1;
                % dname=[dname '\000'];
                % d=dir([dname int2str(nf) '0000\dvr*.tif']);
                d=dir([dname '\000' int2str(nf) '0000\dvr*.tif']);
                maxn=str2num(d(end).name(4:end-4));
            else
                maxn=0;
                nf=-1;
            end
            break;
        else
            isok=1;
            nf=nf+1;
        end
    end
else
    maxn=str2num(d(end).name(4:end-4));
    nf=-1;
end