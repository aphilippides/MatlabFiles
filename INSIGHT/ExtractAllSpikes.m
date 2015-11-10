function ExtractAllSpikes
s=dir('Data*.mat');
for i=length(s)
    load(s(i).name,'smlen');
    if(smlen<100)
        smlen=101;
        save(s(i).name,'smlen','-append')
    end
    GetSpikes1(s(i).name)
end
