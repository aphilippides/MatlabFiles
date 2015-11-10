function[LRange]= LobeRange(Square,Space,NumSources)
%[LRange,Timez]=LobeRange1(Square,Space,NumSources);
filename=['Lobe/MeshSSt1MaxGr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) '.dat']
M=load(filename);
[X,Y]=size(M);
Timez=M(2:X,1);
NumOver=1e6-M(2:X,4);
LRange=sqrt(NumOver/pi);
plot(Timez,LRange)

function[LRange,Timez]= LobeRange1(Square,Space,NumSources)

Timez=125:125:1250;
for i=1:length(Timez)
   filename=['Lobe/MeshSSt1Gr1000X' int2str(NumSources) 'Sq' num2str(Square) 'Sp' num2str(Space) 'T' num2str(Timez(i)) '.dat']
   M=load(filename);
   MData= M(:,500)*1.324e-4;
   aff=2.5e-7;
   LRange(i)=length(find(MData>aff))/2;
end
