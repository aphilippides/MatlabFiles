function CalibrateFiles

s=dir(['*Calib.mat']);
WriteFileOnScreen(s,1);
Picked=input('select file numbers:   ');
CalibFn=s(Picked).name;

load(CalibFn)
s2=dir(['*All.mat']);

for i=1:length(s2)
    save(s2(i).name,'compassDir','cmPerPix','CalibFn','-append');
end