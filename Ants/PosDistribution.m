function[M,bs,cs,as]=PosDistribution
dif=5;
M=[];
xdif=1:dif:640;
[as,bs,cs]=GetHSData;
for y=0:dif:480
    is=find((cs(:,2)>y)&(cs(:,2)<=y+dif));
    f=hist(cs(is,1),xdif);
    M=[M;f];
end
save PosData as bs cs
figure(3)
pcolor(M)

function[as,bs,cs]=GetHSData
as=[];bs=[];cs=[];
cd E:

%[dn,mn]=GetRoot

cd \01170559\s0000093\00000000
refim = imread('dvr000029.tif');
[n,c,a]=FindBee_HiSpeed(1,9999,refim,0);
as=[as a];
bs=[bs n];
cs=[cs;c];
save PosData as bs cs

cd ..\00010000
[n,c,a]=FindBee_HiSpeed(1,4300,refim,9999);
as=[as a];
bs=[bs n];
cs=[cs;c];
save PosData as bs cs

load PosData;

cd ..\..\..\01170627\s0000094\00000000
% refim = imread('dvr009999.tif');
[n,c,a]=FindBee_HiSpeed(1,9999,refim,0);
as=[as a];
bs=[bs n];
cs=[cs;c];
save PosData as bs cs

cd ..\00010000
[n,c,a]=FindBee_HiSpeed(1,3904,refim,9999);
as=[as a];
bs=[bs n];
cs=[cs;c];
save PosData as bs cs

figure(1)
imagesc(refim);
hold on;
plot(cs(:,1),cs(:,2),'rx')
hold off
figure(2)
subplot(2,1,1),plot(bs)
subplot(2,1,2),plot(as)