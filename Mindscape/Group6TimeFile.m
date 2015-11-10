function Group6TimeFile(DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
Gp6

function Gp6
g1=[2];
g2=[4];
g3=[1];
len=1850;
for g=g1
    n=zeros(len,1);
    n(13:100)=1;
    n(1439:1480)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(1187:1280)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(383:470)=1;
    n(1736:1780)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);

function Gp6V2
g1=[2];
g2=[4];
g3=[1];
len=1850;
for g=g1
    n=zeros(len,1);
    n(13:80)=1;
    n(1439:1480)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(1187:1230)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(383:450)=1;
    n(1736:1780)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);