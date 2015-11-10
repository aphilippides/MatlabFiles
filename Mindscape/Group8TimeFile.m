function Group8TimeFile
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image8']);
cd(dn);
Gp8

function Gp8
g1=5;
g2=2;
g3=7;
g4=4;
g5=6;
len=2300;
for g=g1
    n=zeros(len,1);
    n(25:75)=1;
    n(700:740)=1;
%    n(925:975)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g5
    n=zeros(len,1);
    n(925:975)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(40:100)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(475:520)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
     n(760:800)=1;
    n(975:1000)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);