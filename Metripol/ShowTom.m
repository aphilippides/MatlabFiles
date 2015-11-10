function[areas,meanint,peakm,BestC,AutoB,bT,aT]=ShowTom(s,sind,mov1)
[areas,meanint,peakm,BestC,AutoB,bT,aT]=OpenThenThresh(s,5,sind,mov1)
%AdjustThenThresh(s,0.25)
%SmoothThenThresh(s,5)
%AdjustThenThresh2(s,0.25)

function SmoothThenThresh(s,t)
h=fspecial('disk',t);
sf=imfilter(s,h);
%[v,n,t]=DiffThresholdValues(sf);
% [m,d]=min((del2(v)));
% figure
% imshow(sf);
% hold on;ThreshAndBound(sf,0,0.75);%,t);
% keyboard
% hold on;contour3(sf,0);

function[areas,meanint,peakm,BestC,AutoB,b75,area75]=OpenThenThresh(s,t,sind,mov1)
i=imopen(s,strel('disk',t));
[areas,meanint,peakm,BestC,AutoB]=DiffThresholdValues(i,sind,mov1);
%areas=0;meanint=0;peakm=0;BestC=0;AutoB=0;
figure
% keyboard
% imshow(i);
% hold on;
[b75,props]=ThreshAndBound(i,0,0.75);
area75=sum([props.Area]);

function AdjustThenThresh(s,t)
i=imadjust(s,[t 1],[]);
 %[v,n,t]=DiffThresholdValues(i);
% [m,d]=min((del2(v)));
figure
%surfl(i);shading interp;
%keyboard
 imshow(i);
 hold on;ThreshAndBound(i,0,0.75);%,t(d));

function AdjustThenThresh2(s,t)
i=imadjust(s,[t 1],[]);
i=imerode(i,ones(3));
%[v,n,t]=DiffThresholdValues(i);
 figure
%surfl(i);shading interp;
imshow(i);
hold on;ThreshAndBound(i,0,0.75);