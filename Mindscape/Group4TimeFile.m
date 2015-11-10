function Group4TimeFile
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image4']);
cd(dn);
Gp4

function Gp4
g1=8;
g2=2;
g3=9;
g4=4;
len=4000;
for g=g1
    n=zeros(len,1);
    n(29:69)=1;
    n(1350:1385)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(95:130)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(875:925)=1;
    n(2175:2215)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
    n(1000:1045)=1;
    n(2225:2255)=1;
    n(2575:2610)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);