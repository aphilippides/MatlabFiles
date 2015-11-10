% function[x1,x2,y1,y2]=SetBigBBox(b,x,y,wid,ht)
% function to expand a bounding box b by x and y in the relevant
% directions. The wid and ht specify the max sizes of x and y respectively.
% There's probably a more elegant way but I'm being a bit dumb today

function[x1,x2,y1,y2]=SetBigBBox(b,x,y,wid,ht)

x1=floor(b(1)-x/2);
y1=floor(b(2)-y/2);
x2=ceil(x1+b(3)+x);
y2=ceil(y1+b(4)+y);
if(x1<1)
    x1=1;
    x2=x1+x;
elseif(x2>wid)
    x2=wid;
    x1=x2-x;
end

if(y1<1)
    y1=1;
    y2=y1+y;
elseif(y2>ht)
    y2=ht;
    y1=y2-y;
end
