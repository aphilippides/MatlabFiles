function LocMaxTest
nMs=[2:20];
nDs=1:5
for i=1:length(nDs)
    for j=1:length(nMs)
        [a,b]=CountLocalMinima(nDs(i),nMs(j),0);
        n=nMs(j)^nDs(i);
        LMax_prob(i,j)=b./n
        GMax_prob(i,j)=a./n;   
        clear a b n
        save LMaxD1_5N0M2_20
    end
end