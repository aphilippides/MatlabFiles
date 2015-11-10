function GetRunLengths(Run)

RunGen=[];
for i=1:Run
    fn=['Run' int2str(i) '\pop.dat'];
    if isfile(fn)
        M=load(fn);
        RunGen=[RunGen; [i FinGen(M)]]
    end
    save -ascii RunLengths.dat RunGen
end


function[g]=FinGen(M)

[X,Y]=size(M);
if(X>=30)
    if(M(X-29:end,2)==ones(30,1))
        g=M(end,1);
    elseif(M(end,1)>=9999)
        g=10000;
    else
        g=11000;
    end
else
    g=-1000;
end