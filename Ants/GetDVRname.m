function[fn]=GetDVRname(i,maxn)

f='dvr0';
if(i<10) fn=[f '0000' int2str(i) '.tif'];
elseif(i<100) fn=[f '000' int2str(i) '.tif'];
elseif(i<1000) fn=[f '00' int2str(i) '.tif'];
elseif(i<10000) fn=[f '0' int2str(i) '.tif'];
else fn=[f int2str(i) '.tif'];
end

if(maxn>9999) fn = ['000' int2str(floor(i/1e4)) '0000\' fn]; end;