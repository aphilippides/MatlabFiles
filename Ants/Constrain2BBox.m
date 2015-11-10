
function[c_im,addx,x1,x2,y1,y2]=Constrain2BBox(im,b)

[h,w]=size(im(:,:,1));
x1=max(1,floor(b(1)));
y1=max(1,floor(b(2)));
x2=min(w,ceil(b(1)+b(3)));
y2=min(h,ceil(b(2)+b(4)));
c_im=im(y1:y2,x1:x2,:);
% bit to make positions the same
% ie (1,1) in the new image is (x1,y1) in old image
% so add (x1-1,y1-1) 
addx=[x1-1,y1-1];

