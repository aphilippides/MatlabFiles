function[n_ob,alv]=GetALVs(obc,obw);
if(obw==-1)
    n_ob=-1;
    alv=[NaN NaN];

else n_ob=length(obc);
    if(n_ob>0)
        alv=[mean(cos(obc)) mean(sin(obc))];
    else
        alv=[NaN NaN];
    end
end

