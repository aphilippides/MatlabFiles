function ImAnalysis
dWork, cd GantryProj\ImageProcessing\Pics_0206_4pm_Cloudy\
ss=[4 ]%8 2];
for s=ss
% cd Set1\
% LoadSubsample(s,'P60210', [23:28 30:34 36:37], [28 34])
% cd ..\Set2\
% LoadSubsample(s,'P60210', [52:-1:48 46:-1:42 40:-1:38],[42 48])
% cd ..\Set3\
% LoadSubsample(s,'P60210', [54:59 61:65 67:69], [59 65])
% cd ..\Set4\
% LoadSubsample(s,'P60210', [70:72 74:78 80:84], [72 78])
% cd ..\Set5\
% LoadSubsample(s,'P602', [1100:-1:1098 1096:-1:1093 1091:-1:1086], [1091 1096])
end
for i=[4]
     cd(['Set' int2str(i) ])
     GetDiffs(7,1)
     figure
     cd ..
end

function GetDiffs(j,n)
cd ../Set4
load PicsSubSampled4
r=im7;
cd ../Set5
load PicsSubSampled4
%r=SubSampleMean(eval(['im' int2str(j)]),n);
for i=1:length(pics)
    m=SubSampleMean(eval(['im' int2str(i)]),n);
    d(i)=sqrt(mean(mean((r-m).^2)));
    if(i>1) intd(i-1)=sqrt(mean(mean((m-oldm).^2))); end;
    oldm=m;
end
subplot(2,1,1),plot(d);
subplot(2,1,2),plot(intd);
keyboard

function LoadSubsample(subsam,BegStr,pics,copies)
for i=1:length(pics)
    i
    mi = double(rgb2gray(imread([BegStr int2str(pics(i)) '.jpg'])));
    im=SubSampleMean(mi,subsam);
    eval(['im' int2str(i) '=im;']);
    %     if(i==1) m=im; end;
    %     d(i)=sum(sum((m-im).^2));
end
for i=copies
    ind=find(pics==i);
    mi = double(rgb2gray(imread([BegStr int2str(i) ' Copy.jpg'])));
    im=SubSampleMean(mi,subsam);
    eval(['im' int2str(ind+100) '=im;']);
end
[x,y]=size(mi)
clear i mi im
save(['PicsSubSampled' int2str(subsam) '.mat'],'im*','copies','pics')
