function NeutStats

dvolsig
cd VS_HalfFlat2
Neuts=zeros(20,9);
Conns=zeros(20,4);
for i=1:20 
    a=load(['MutantNeutralDataRun' int2str(i) '.dat']);
    [y,x]=Frequencies(a(2:end,4));    
    [v,u]=Frequencies(a(2:end,3));
    for j=1:length(x)
        Neuts(i,x(j)+2)=y(j);
    end
    for j=1:length(u)
        Conns(i,u(j)+2)=v(j);
    end
    inds=find(a(2:end,3)>0);
    inds3=find(a(2:end,3)>=0);
    inds2=find(a(2:end,4)>=0);
    count1(i)=length(setdiff(inds,inds2));
    count2(i)=length(setdiff(inds3,inds2));      
end

cd ../VS_OrigData
NeutsO=zeros(20,9);
ConnsO=zeros(20,4);
for i=1:20 
    a=load(['MutantNeutralDataRun' int2str(i) '.dat']);
    [y,x]=Frequencies(a(2:end,4));    
    [v,u]=Frequencies(a(2:end,3));
    for j=1:length(x)
        NeutsO(i,x(j)+2)=y(j);
    end
    for j=1:length(u)
        ConnsO(i,u(j)+2)=v(j);
    end
    inds=find(a(2:end,3)>0);
    inds3=find(a(2:end,3)>=0);
    inds2=find(a(2:end,4)>=0);
    count1O(i)=length(setdiff(inds,inds2));
    count2O(i)=length(setdiff(inds3,inds2));      
end

keyboard