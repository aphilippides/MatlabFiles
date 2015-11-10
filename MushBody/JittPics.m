function JittPics(x,y)

BasalRate(x)

function BasalRate(n1,n2)
h=1.324e-6*load('Jitter4000Pc10SSt0_25B3Gr2000Inn60Out125Line1000.dat');
Inn=875:1125;
if(nargin<2) hend=h(n1:end,Inn);
else hend=h(n1:n2,Inn);
end
y=std(detrend(hend));
plot((Inn-1000)/4,y)