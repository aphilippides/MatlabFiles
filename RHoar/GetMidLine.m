function[ml]=GetMidLine(newl,LastLine,l1,l2,i,fib)
if(isempty(LastLine)) 
    ml=[];
    return;
end
if(newl(2)>LastLine(2))
    ml=(1-fib)*newl+fib*LastLine;
else
    ml=(1-fib)*newl+fib*LastLine;
end
ml(1)=newl(1);
val=ml(2);
if(l2>val) ml(4)=1;
elseif(l1<val) ml(4)=0;
else ml(4)=-1;
end