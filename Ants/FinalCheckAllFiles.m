function FinalCheckAllFiles

s=dir('*All.mat');
for i=1:length(s)
    s(i).name
    Get1DataFinalCheck(s(i).name)
end    