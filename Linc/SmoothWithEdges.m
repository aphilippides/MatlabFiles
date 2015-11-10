function[newX] = SmoothWithEdges(x,n,sp,m)
if(n==1)
    newX=x;
    return;
end
if(nargin==3) m=1; end;
[h,w]=size(x);
l=1;
if(h==1)
    for i=1:n:w-n+1
        inds=mod((i-sp):(i+n-1+sp),w);
        inds(find(inds==0))=w;
        newX(l)=mean(x(inds),2);
        l=l+1;
    end
else
    for j=1:m:h-m+1
        meanrows=mean(x(j:j+m-1,:),1);
        c=1;
        for i=1:n:w-n+1
            inds=mod((i-sp):(i+n-1+sp),w);
            inds(find(inds==0))=w;
            newX(l,c)=mean(meanrows(inds),2);
            c=c+1;
        end;
        l=l+1;
    end
end