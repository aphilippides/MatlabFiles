% function[newX]=  SubSampleMean(X,n,m)
%
% function which averages over nxm pixels and reduces array size by n*m
% m defaults to 1 if not entered
%
% USAGE: newX = SubSampleMean(X,4,4)  to reduce X by 4 in both x and y
% USAGE: newX = SubSampleMean(X,4)    to reduce X by 4 in x but leave y unchanged

function[newX]= SubSampleMean(X,n,m)

l=1;
[w,h]=size(X);
if(n==1) newX=X;
%     if(m==1) newX=X;
%     else
%         for i=1:m:w-m+1
%             newX=mean(X(i:i+m-1,:),1);
%             k=1;
%             for j=1:n:h-n+1
%                 newX(l,k)=mean(meanrows(j:j+n-1));
%                 k=k+1;
%             end;
%             l=l+1;
%         end
%     end
elseif(h==1)
    for i=1:n:w-n+1
        newX(l)=mean(X(i:i+n-1),1);
        l=l+1;
    end
elseif(w==1)
    for i=1:n:h-n+1
        newX(l)=mean(X(i:i+n-1),2);
        l=l+1;
    end
elseif((nargin<3)|(m==1))
    for i=1:w
        k=1;
        for j=1:n:h-n+1
            newX(l,k)=mean(X(i,j:j+n-1));
            k=k+1;
        end;
        l=l+1;
    end    
else
    for i=1:m:w-m+1
        meanrows=mean(X(i:i+m-1,:),1);
        k=1;
        for j=1:n:h-n+1
            newX(l,k)=mean(meanrows(j:j+n-1));
            k=k+1;
        end;
        l=l+1;
    end
    % last row
    if(rem(w,m)~=0)
        st=fix(w/m)*m+1;
        meanrows=mean(X(st:end,:),1);
        k=1;
        for j=1:n:h-n+1
            newX(l,k)=mean(meanrows(j:j+n-1));
            k=k+1;
        end;
    end
end