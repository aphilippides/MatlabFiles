function[newx,x1,x2,y1,y2]=ImposeBBox(x,BBox);
[rows,col]=size(x);
x1=max(0,floor(BBox(2)));
x2=min(rows,ceil(BBox(2)+BBox(4)));
y1=max(0,floor(BBox(1)));
y2=min(col,ceil(BBox(1)+BBox(3)));

newx=x(x1:x2,y1:y2);