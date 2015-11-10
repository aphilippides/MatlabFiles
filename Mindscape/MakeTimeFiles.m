function MakeTimeFiles(DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
temp
return
if(DirNum~=20) eval(['Gp' int2str(DirNum)]);
else Gp9long; 
end;

function temp
len=760;
for g=[1:10]
    n=zeros(len,1);
    n(1:750)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end

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
g1=[1,2,8];
g2=[3,5,6];
g3=[7,4];
len=1850;
for g=g1
    n=zeros(len,1);
    n(13:310)=1;
    n(1187:1353)=1;
    n(1439:1552)=1;
    n(1736:1780)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(13:310)=1;
    n(383:777)=1;
    n(1187:1353)=1;
    n(1439:1552)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(383:777)=1;
    n(1187:1353)=1;
    n(1439:1552)=1;
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
    n(309:370)=1;
    n(495:560)=1;
    n(1582:1736)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(495:560)=1;
    n(700:757)=1;
    n(939:1527)=1;
    n(1582:1736)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(700:757)=1;
    n(939:1527)=1;
    n(1582:1736)=1;
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