function Collect_all_AllFiles%(flist)

flist=dir('*All.mat');

if(~isdir('AllFiles'))
    mkdir('AllFiles')
end
for i=1:length(flist)

    fn=flist(i).name;
    load(fn,'cmPerPix','compassDir');
    if(~exist('cmPerPix','var')||~exist('compassDir','var'))
        load([fn(1:end-7) 'NestLMData.mat'],'cmPerPix','compassDir')
        save(fn,'cmPerPix','compassDir','-append')
    end
    copyfile(fn,['AllFiles/' fn]);
end