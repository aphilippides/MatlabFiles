s=dir('*.MOV')
is=[1:length(s)]
is=[length(s):-1:1]
for i=is
    f=s(i).name(1:end-4)
    fn=[f '_ProgWhole.mat'];
    if(~isfile(fn))
       TrackAntScanning(s(i).name);
    end
end    