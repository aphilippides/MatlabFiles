function Group9TimeFileLong
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image9long']);
cd(dn);
Gp9

function Gp9
g1=11;
g2=9;
g3=3;
g4=2;
g5=10;
g6=4;
len=4000;
for g=g1
    n=zeros(len,1);
    n(16:56)=1;
    n(1138:1190)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(70:100)=1;
    n(375:400)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(70:100)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
    n(190:218)=1;
    n(850:880)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g5
    n=zeros(len,1);
     n(200:223)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g6
    n=zeros(len,1);
     n(700:730)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);