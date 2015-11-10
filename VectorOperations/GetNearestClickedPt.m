function[i_m,b,p,q] = GetNearestClickedPt(pts,tst)
if(nargin<2) title('Click near any point to select')
else title(tst);
end
[p,q,b]=ginput(1);
if(isempty(b))
    i_m=0;
    return;
else
    vs=pts-ones(size(pts,1),1)*[p,q];
    ds=sum(vs.^2,2);
    [mini_d,i_m]=min(ds);
end