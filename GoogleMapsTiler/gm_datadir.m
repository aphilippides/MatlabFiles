function d = gm_datadir
dbs=dbstack;
d=which(dbs(1).name);
sls = find(d==filesep,1,'last');
d=[d(1:sls(1)) 'data'];
