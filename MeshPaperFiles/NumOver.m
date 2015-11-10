% function[Over,T]=NumOver(M,T)
function[Over,T]=NumOver(M,T)
if(nargin<2)
    Over=M(2,4)-M(2:end,4);
    T=M(2:end,1);
else
    ind=find(M(2:end,1)==T);
    Over=M(2,4)-M(ind,4);
end