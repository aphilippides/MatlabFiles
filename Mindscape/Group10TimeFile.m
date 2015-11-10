function Group10TimeFile
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image10']);
cd(dn);
Gp10

function Gp10
g1=8;g2=2;g3=7;g4=5;
g5=[9 10];
g6=[6 1]
len=2500;
for g=g1
    n=zeros(len,1);
    n(1:100)=1;
    n(1425:1525)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(100:200)=1;
    n(375:450)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(175:300)=1;
    n(1500:1600)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
     n(300:400)=1;
     n(1600:1700)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g5
    n=zeros(len,1);
     n(1175:1250)=1;
     n(1375:1475)=1;
     n(1750:1850)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g6
    n=zeros(len,1);
     n(1450:1550)=1;
%     n(1850:1550)=1;     
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);