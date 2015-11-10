function Group5TimeFile
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image5']);
cd(dn);
Gp5

function Gp5
len=2500;
for g=2
    n=zeros(len,1);
    n(1:150)=1;
    n(1650:1750)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=10
    n=zeros(len,1);
    n(100:200)=1;
    n(1300:1350)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=9
    n=zeros(len,1);
    n(225:310)=1;
    n(1175:1250)=1;
    n(2125:2200)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=7
    n=zeros(len,1);
    n(320:380)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=6
    n=zeros(len,1);
     n(375:475)=1;
     n(1375:1475)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=3
    n=zeros(len,1);
     n(500:600)=1;
     n(1050:1150)=1;     
     n(1600:1700)=1;     
     n(1925:2000)=1;     
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=5
    n=zeros(len,1);
     n(1025:1125)=1;
     n(1535:1600)=1;     
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=4
    n=zeros(len,1);
     n(1450:1550)=1;
     n(1850:1950)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=[1,8]
    n=zeros(len,1);
     n(2000:2150)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);