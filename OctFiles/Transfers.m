function Transfers(Option,V)

filename=['TransferActivity'];
eval(['load ' filename '.dat -ascii;']);
eval(['Outdat=' filename ';']);
NumNodes = Outdat(1,1);
if (Option==0)
   V=0:1:(NumNodes-1);
end
Numb = length(V);
[Tmp,n] =size(Outdat);
Iters = Tmp-1;
for i=1:Numb
   subplot(Numb,1,i);
   plot(Outdat(3:(Iters+1),V(i)+1));
   ylabel(int2str(V(i)));
   %axis([1 Iters/4 -1 1])
   grid;
end
