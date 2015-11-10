function Group6TimeFile(DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
Gp9

function Gp9
g1=[11];
g2=[9];
g3=[5];
g4=[10];
g5=[7];
g6=2;
len=1850;
for g=g1
    n=zeros(len,1);
    n(309:379)=1;
    %n(538:565)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(495:565)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(700:757)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
     n(939:1010)=1;
%    n(1582:1630)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g5
    n=zeros(len,1);
    n(1295:1360)=1;
    n(1600:1660)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g6
    n=zeros(len,1);
    n(530:565)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);


function Gp9V1
g1=[11];
g2=[9];
g3=[5];
g4=[8];
g5=[7];
len=1850;
for g=g1
    n=zeros(len,1);
    n(309:379)=1;
    n(538:565)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(495:565)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(700:757)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
    n(939:1010)=1;
    n(1582:1630)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g5
    n=zeros(len,1);
    n(1295:1360)=1;
    n(1620:1660)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);