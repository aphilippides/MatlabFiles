function MakeTimeFilesV2(DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
if(DirNum~=20) eval(['Gp' int2str(DirNum)]);
else Gp9long; 
end;

function Gp4
g1=[1,9,10];
g2=[2,3,6,7,8];
g3=[4,5];
len=4850;
for g=g1
    n=zeros(len,1);
    n(1750:2098)=1;
    n(3114:3725)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(3114:3882)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(611:985)=1;
    n(1750:2098)=1;
    n(3114:3208)=1;
    n(3478:3609)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);

function Gp6
g1=[1];
g2=[3,5,6];
g3=[7];
len=1850;
for g=g1
    n=zeros(len,1);
    n(13:80)=1;
    n(1736:1780)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(1187:1230)=1;
    n(1439:1480)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(383:450)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);

function Gp9
g1=[1,2];
g2=[4,5,6];
g3=[3,7,8,9,10,11];
len=1850;
for g=g1
    n=zeros(len,1);
    n(309:335)=1;
    n(700:720)=1;
    n(1590:1635)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(705:725)=1;
    n(1582:1635)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(495:530)=1;
    n(1000:1050)=1;
    n(1250:1300)=1;
    n(1590:1635)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);

function Gp9long
cd ../image9long
g1=[1,2];
g2=[4,5,6];
g3=[3,7,8,9,10,11];
len=4850;
for g=g1
    n=zeros(len,1);
    n(3114:3817)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(3114:3208)=1;
    n(3478:3609)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(1925:2250)=1;
    n(3114:3700)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);