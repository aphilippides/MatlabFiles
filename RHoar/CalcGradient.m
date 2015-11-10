function[g] = CalcGradient(t,l,n);
%s=SmoothVec(l,n,'replicate');
% t=t(end-2*n:end);
% s=l(end-2*n:end);
s=l;
    x=[t' ones(size(t'))];
    %l=movavg(l,2,2,1);%(l,sm,'replicate');
    m=x\s';
g=m(1);
%p=(x*m)';
%    ps=polyfit(t,l,1);
%    p=polyval(ps,tnew);
% if(length(l)>1)
% else 
%     p=l*ones(size(tnew));
% end