% CrystalProcessing

%function ImageProcessing

dmat;
cd ../AlignmentSamples/xtal5

[f,s]=isfile('*Int.ssf');
mov1 = 1;%avifile('CrystalAll.avi','fps',4,'compression','None')
mov2 = 1;%avifile('CrystalPeaksArea.avi','fps',4,'compression','None')
mov3 = 1;%avifile('CrystalLeaks.avi','fps',4,'compression','None')
mov4 = 1;%avifile('CrystalCentroids.avi','fps',4,'compression','None')

CrystalBits=struct('boundaryAuto','boundary75');
for i=1:size(s,1)
    fn=[s(i,1:end-11) 'Crystal.mat'];
    load(fn);
    sn=AdjustGamMask(crys_adj,loop,0.25);
    %h=figure, imshow(sind);
    mov1=['CrystalPic' int2str(i) ];
    [areas,meanint,peakm,BestC,AutoB,b75,a75]=ShowTom(sn,sind,mov1);
    BestCentroids(i,:)=BestC;
    MaxPeaks(i,:)=peakm;
    CrystalBits(i).boundaryAuto=AutoB;
    CrystalBits(i).boundary75=b75;    
    AutoAreas(i)=areas; 
    Area75(i)=a75;
%    save CrystalFireData.mat BestCentroids MaxPeaks AutoAreas CrystalBits Area75
end
% mov1 = close(mov1);
% mov2 = close(mov2);
% mov3 = close(mov3);
% mov4 = close(mov4);
% 

% figure(h),hold on, plot(pm(:,1),pm(:,2),'r-x'),hold off
