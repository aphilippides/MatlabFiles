function[mask] = GetChanMask(calib,im)

% get a mask
mask=zeros(size(im));
x=1:size(im,2);
for j=1:length(calib.chan)
    [y1,m1,c1,t]=GetMC(calib.chan(j).bot,x);
    [y2,m2,c2,b]=GetMC(calib.chan(j).top,x);

    for i=1:length(x)
        mask(y1(i):y2(i),i)=1;
    end
end

function[y,m,c,t]=GetMC(t,x)
d1=diff(t);
m=d1(2)/d1(1);
c=t(1,2)-t(1,1)*m;
y=round(m*x+c);