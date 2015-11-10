function x = Ang_prctile(x, pcs,med)
if nargin < 3
    med=circ_median(x);
end

d=circ_dist(med,x);
d=sort(d);
[m,ind]=min(abs(d));
for i=1:length(pcs)
    r=round(length(x)*(pcs(i)-50)/100);
    v=d(ind+r)+med;
end
