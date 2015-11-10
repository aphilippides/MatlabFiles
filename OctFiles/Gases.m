function Gases(Option,V)

filename=['GasConc'];
eval(['load ' filename '.dat -ascii;']);
eval(['Outdat=' filename ';']);
NumNodes = Outdat(1,1);
NumChem = Outdat(1,2);
if (Option==0)
   V=0:1:(NumNodes-1);
end
Numb = length(V);
[Tmp,n] =size(Outdat);
Iters = Tmp-1;
x=1:1:Iters; 
for i=1:Numb
   subplot(2*Numb,1,2*(i-1)+1)			%Plot Concs
   plot(x,Outdat(2:(Iters+1),2*V(i)+1),x,Outdat(2:(Iters+1),2*V(i)+2),'r:');
   ylabel(int2str(V(i)));
   %axis([1 Iters/4 -1 1])
   grid;
   
   subplot(2*Numb,1,2*(i-1)+2)        % plot Emitt
   plot(x,Outdat(2:(Iters+1),2*Numb+V(i)+1));
   ylabel(int2str(V(i)));
   %axis([1 Iters/4 -1 1])
   grid;
end
