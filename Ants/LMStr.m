function[s,c]=LMStr(lm,LMs)
lcol=['r';'k';'y';'g'];
c=lcol(lm,:);
nlm=size(LMs,1);
lmo=LMOrder(LMs);
if(nlm==1) s=[];
elseif(nlm==2)
    if(lmo(lm)==1)
        s='N';
        c=lcol(1,:);
    else
        s='S';
        c=lcol(2,:);
    end
else
    if(lmo(lm)==1) s='NW';
    elseif(lmo(lm)==2) s='NE';
    elseif(lmo(lm)==3) s='SE';
    else s='SW';
    end
end