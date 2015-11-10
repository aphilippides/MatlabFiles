function NetProperties(Option,V)

Names={'T_fer' 'Pos' 'Neg' 'chm0' 'chm1' 'chm2' 'chm3' 'chm4'};
NumVars=length(Names);
filename=['NetworkProperties'];
eval(['load ' filename '.dat -ascii;']);
eval(['Outdat=' filename ';']);
if (Option==0)
   V=1:1:(NumVars);
end
Numb = length(V);
Iters =size(Outdat,1);
x=Outdat(:,1);
for i=1:Numb
   subplot(Numb,1,i)			%Plot Stuff
   %keyboard
   plot(x,Outdat(:,V(i)+1));
   ylabel(Names(V(i)));
   %axis([1 Iters/4 -1 1])
   grid;
end
