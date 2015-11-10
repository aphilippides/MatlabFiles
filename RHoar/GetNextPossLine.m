function[mlup,mldown]=GetNextPossLine(l1line,l2line,LastLine,l1,l2,buy,sell,i,fib)

if(isempty(LastLine)) 
    mlup=[];
    mldown=[];
    return;
end

svt=l1line.p1new(1);
[sval svalt]=min(l1(svt:i));
newl=[svalt+svt-1 sval buy(svalt+svt-1)];
if(newl(2)>LastLine(2))
    mlup=(1-fib)*newl+fib*LastLine;
else
    mlup=(1-fib)*newl+fib*LastLine;
end
mlup(1)=newl(1);
% val=ml(2);
% if(l2>val) ml(4)=1;
% elseif(l1<val) ml(4)=0;
% else ml(4)=-1;
% end
mlup(4)=1;

svt=l2line.p1new(1);
[sval svalt]=max(l2(svt:i));
newl=[svalt+svt-1 sval sell(svalt+svt-1)];
if(newl(2)>LastLine(2))
    mldown=(1-fib)*newl+fib*LastLine;
else
    mldown=(1-fib)*newl+fib*LastLine;
end
mldown(1)=newl(1);
mldown(4)=0;