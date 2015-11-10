function[n_ob,alv]=GetALVs(obc,obw);
if(obw==-1)
    n_ob=-1;
    alv=[NaN NaN];

else n_ob=length(obc);
    if(n_ob>0)
        angs=obc*pi/45;
        alv=[mean(cos(angs)) mean(sin(angs))];
    else
        alv=[NaN NaN];
    end
end