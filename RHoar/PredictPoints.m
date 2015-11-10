function[p,tnew] = PredictPoints(t,l,n,sm);
tnew=[t(1) t(end) n];
if(length(l)>1)
    x=[t' ones(size(t'))];
    %l=movavg(l,2,2,1);%(l,sm,'replicate');
    m=x\l';
    x=[tnew' ones(size(tnew'))];
    p=(x*m)';
%    ps=polyfit(t,l,1);
%    p=polyval(ps,tnew);
else 
    p=l*ones(size(tnew));
end