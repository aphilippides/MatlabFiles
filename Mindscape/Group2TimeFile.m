function Group2TimeFile(DirNum)
dmat; 
dn=(['..\DiffEqun\MeshTube\MindScapeMany\Image' int2str(DirNum)]);
cd(dn);
Gp2

function Gp2
g1=[1];
g2=6;
g3=7;
g4=4;
len=1850;
for g=g1
    n=zeros(len,1);
    n(10:50)=1;
    n(400:430)=1;
    %n(675:720)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(70:130)=1;
    n(700:720)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(83:125)=1;
    %n(625:660)=1;
    n(695:740)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
     n(375:408)=1;
%    n(1582:1630)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);

function Gp2V1
g1=[1];
g2=6;
g3=7;
g4=4;
len=1850;
for g=g1
    n=zeros(len,1);
    n(10:50)=1;
    n(400:430)=1;
    n(675:720)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g2
    n=zeros(len,1);
    n(70:130)=1;
    n(700:720)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g3
    n=zeros(len,1);
    n(83:125)=1;
    n(625:660)=1;
    n(695:740)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);
for g=g4
    n=zeros(len,1);
     n(375:455)=1;
%    n(1582:1630)=1;
    fn=['TimeFileMask' int2str(g) '.txt'];
    save(fn,'n','-ascii');
end
figure,plot(n);