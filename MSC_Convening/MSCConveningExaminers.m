function MSCConveningExaminers

dwork
cd ../Current/MScConvening/2015/
[a,b]=xlsread('MSc1415ProjectNames.xlsx');
examiners=unique(b(2:end,13));
examiners(length(examiners)+1)={'n/a'};
second_marker=b(2:end,14);
for i=1:length(examiners)
nex(i)=sum(ismember(second_marker,examiners(i)));
end
disp([char(examiners) char(int2str(nex'))])
