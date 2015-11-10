function tempwid(sl)

dumm2
function dumm2
GetOneDSliceAvgs3d(500,[1:35],1)
GetOneDSliceAvgs3d(1000,[1:35],1)
GetOneDSliceAvgs3d(1500,[1:35],1)
GetOneDSliceAvgs3d(2000,[1:35],1)
GetOneDSliceAvgs3d(2500,[1:35],1)
GetOneDSliceAvgs3d(500,[1:35],4)
GetOneDSliceAvgs3d(1000,[1:35],4)
GetOneDSliceAvgs3d(1500,[1:35],4)
GetOneDSliceAvgs3d(2000,[1:35],4)
GetOneDSliceAvgs3d(2500,[1:35],4)

function dumm(sl)
% NB for Sl=2, only have accurate results for v6-32
ShowWidthAvgDiffs(sl)
eval(['print -djpeg100 MaxTreeAvgDiffsW1_4Sl' int2str(sl) '.jpg']);

return
if(sl~=2)
   GetWidthAvgs('Max',sl,[1:32],1);
   GetWidthAvgs('Max',sl,[1:32],4);
else
   GetWidthAvgs('Max',sl,[6:32],1);
   GetWidthAvgs('Max',sl,[6:32],4);
end
close

function dumm3(sl)
return
fn=['MaxW1Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(sl) '.mat'];
load(fn);
MaxAvg=MaxAvg.*1.324e-4;
MaxStd=MaxStd.*1.324e-4;
MinAvg=MinAvg.*1.324e-4;
MinStd=MinStd.*1.324e-4;
MeanAvg=MeanAvg.*1.324e-4;
MeanStd=MeanStd.*1.324e-4;
SDAvg=SDAvg.*1.324e-4;
SDStd=SDStd.*1.324e-4;
%save(fn,'Times','MaxAvg','MinAvg','OverAvg','MeanAvg', ...
%   'MaxStd','MinStd','OverStd','MeanStd','SDAvg','SDStd','Vers')
fn=['MaxW4Rho100/TreeAvgsSst1MaxGr300X100Z100Sq1Sp10Sl'x2str(sl) '.mat'];
load(fn);
MaxAvg=MaxAvg.*1.324e-4;
MaxStd=MaxStd.*1.324e-4;
MinAvg=MinAvg.*1.324e-4;
MinStd=MinStd.*1.324e-4;
MeanAvg=MeanAvg.*1.324e-4;
MeanStd=MeanStd.*1.324e-4;
SDAvg=SDAvg.*1.324e-4;
SDStd=SDStd.*1.324e-4;
%save(fn,'Times','MaxAvg','MinAvg','OverAvg','MeanAvg', ...
%   'MaxStd','MinStd','OverStd','MeanStd','SDAvg','SDStd','Vers')
