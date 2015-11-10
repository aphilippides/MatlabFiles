% function[fn,fno]=GetDBName(x,y)
% 
% Helper function cor getting filenames from the databases.
% it returns filename fn for image at position (x,y)
% if image doesn't/does exist, it returns fno = 0 / 1 

function[fn,fno]=GetDBName(x,y)
fn=[GetN(x) '_' GetN(y) '.mat'];
if(~isfile(fn)) fno=0;
else fno=1;
end

function[f]=GetN(x)
if(x<10) f=['000' int2str(x)];
elseif(x<100) f=['00' int2str(x)];
elseif(x<1000) f=['0' int2str(x)];
else f=int2str(x);
end