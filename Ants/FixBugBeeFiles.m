function FixBugBeeFiles%(flist)

flist=dir('*All.mat');

for i=1:length(flist)
i
    vObj=-1;
    save(flist(i).name,'vObj','-append');
    GetRidOfvObj(flist(i).name);
    load(flist(i).name)

end

function GetRidOfvObj(AllN)
load(AllN)
clear vObj
save(AllN)