function LobeSliceDiffs(Sq,Sp,SSt,X,Z,Slice,Time)

Sqare=1;
filename=['Lobe/MeshSSt' x2str(SSt) 'Sl' int2str(Slice) 'Gr300X' x2str(X) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'T' x2str(Time) '.dat']
%filename=['Lobe/MeshSSt' x2str(SSt) 'Sl' int2str(Slice) 'Gr300X' x2str(X) 'Z' x2str(Z) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'T' x2str(Time) '.dat']
filename2=['LobeMin/MeshSSt' x2str(SSt) 'Gr300X' x2str(X) 'Z' x2str(Z) 'Sq' x2str(Sq) 'Sp' x2str(Sp) 'Sl' int2str(Slice) 'T' x2str(Time) '.dat']
M=load(filename);
M2=load(filename2);
Bits=25:25:150;
for i=1:length(Bits)
   N=M(150-Bits(i)+1:150+Bits(i),150-Bits(i)+1:150+Bits(i));
   [dum,dum2,v]=find(N>=0.00188);
   NumOver(i)=length(v);
   
   N2=M2(150-Bits(i)+1:150+Bits(i),150-Bits(i)+1:150+Bits(i));
   [dum,dum2,v]=find(N2>=0.00188);
   NumOver2(i)=length(v);
   
   if(i==1)
      max1=max(max(N));
      max2=max(max(N2));
      MaxDiff=(max1-max2)*2/(max1+max2);
   end
end
OverDiff=NumOver-NumOver2;
AvgOver=(NumOver+NumOver2)./2;
RelDiff=OverDiff./AvgOver;
subplot(2,1,1),plot(Bits,NumOver,Bits,NumOver2,'r:')
title(['max diff= ' num2str(MaxDiff) '; max1= ' num2str(max1) ';max2= ' num2str(max2)])
subplot('Position',[0.1 0.1 0.4 0.4])
plot(Bits,OverDiff)
subplot('Position',[0.5 0.1 0.4 0.4])
plot(Bits,RelDiff),grid
