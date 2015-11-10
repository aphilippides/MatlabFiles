function Outputs(V)

filename=['NetActivity'];
eval(['load ' filename '.dat -ascii;']);
eval(['Outdat=' filename ';']);
NumNodes = Outdat(1,1);
if (V(1)==-1)
   V=0:1:NumNodes-1;
end
Numb = length(V);
[Tmp,n] =size(Outdat);
Iters = Tmp-1;
for i=1:Numb
   subplot(Numb,1,i);
   plot(Outdat(2:(Iters+1),V(i)+1));
   ylabel(int2str(V(i)));
   axis([0 Iters -1.01 1.01])
   grid;
end
